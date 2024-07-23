<!--- CREADO: JOS� ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 26/10/2009 --->
<!--- FECHA �LTIMA MOD.: 05/02/2019 --->
<!--- AJAX PARA INDICAR QUE YA SE RECIBI� LA DOCUMENTACI�N DE UNA SOLICITUD --->
<!--- Incluir la funci�n para determinar la secci�n del listado que le corresponde --->
<cfinclude template="../seccion_listado.cfm">
<!--- Bandera para determinar si falta alg�n PDF --->
<cfset vFaltaPDF = 0>
<!--- Procesar solicitudes marcadas en la lista --->
<cfif #vIdSol# IS 'TODAS'>
	<!--- Cambiar el status de las solicitudes marcadas a 3 (en revision) --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosRevisionFiltro.vMarcadas)#">
		<!--- Asignar la solicitud a la sesi�n especificada --->
		<cfif #AsignarSesion(vActa, Session.AsuntosRevisionFiltro.vMarcadas[E])# IS 'NAK'>
			<cfset vFaltaPDF = 1>
		</cfif>
	</cfloop>
<cfelse>
	<cfoutput>#AsignarSesion(vActa, vIdSol)#</cfoutput>
</cfif>
<!--- Funci�n para asignar un asunto a una sesi�n --->
<cffunction name="AsignarSesion" description="Asignar un asunto a una sesi�n del CTIC.">
	<cfargument name="aActa">
	<cfargument name="aSolicitud">
	<!--- Obtener informaci�n de la solicitud marcada --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud WHERE sol_id = #aSolicitud#
	</cfquery>
	<cfloop query="tbSolicitudes">
		<!---
		<!--- Verificar que exista la documentaci�n anexa --->
		<cfif tbSolicitudes.mov_clave NEQ 40 AND tbSolicitudes.mov_clave NEQ 41 AND NOT FileExists(#vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf')>
			<cfreturn 'NAK'>
		</cfif>
		--->
		<!--- Asignar la solicitud a la reuni�n correspondeinte --->
		<cfswitch expression="#tbSolicitudes.mov_clave#">
			<!--- Asuntos que pasan directamente al pleno --->
			<cfcase value="14,31,35,40,41,61,62">
				<!--- Cambiar el status de la solicitud --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_solicitud
					SET sol_status = 1,
					<cfif #tbSolicitudes.mov_clave# NEQ 5 AND #tbSolicitudes.mov_clave# NEQ 17 AND #tbSolicitudes.mov_clave# NEQ 28>sol_sintesis = UPPER(ISNULL(sol_memo1,'')) <cfif #tbSolicitudes.mov_clave# NEQ 6> + ' ' + UPPER(ISNULL(sol_memo2,''))</cfif>, </cfif>
					cap_fecha_mod = GETDATE()
					WHERE sol_id = #tbSolicitudes.sol_id#
				</cfquery>
				<!--- En el caso de licencias y comisiones, crear un registro CAAA aprobatorio --->
				<cfif #tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41>
					<cfquery datasource="#vOrigenDatosSAMAA#">
						INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte, dec_clave)
						VALUES (#tbSolicitudes.sol_id#, #aActa#, 'CAAA', 5, 1)
					</cfquery>
				</cfif>
				<!--- Crear el registro correspondiente en la tabla de asuntos --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte)
					VALUES (#tbSolicitudes.sol_id#, #aActa#, 'CTIC', #SeccionEnListado('CTIC',tbSolicitudes.mov_clave,tbSolicitudes.sol_pos2,tbSolicitudes.sol_pos3,tbSolicitudes.sol_pos8,tbSolicitudes.sol_pos17,tbSolicitudes.sol_pos20)#)
				</cfquery>
			</cfcase>
			<!--- Asuntos que pasan antes a la CAAA --->
			<cfdefaultcase>
				<!--- Cambiar el status de la solicitud --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_solicitud
					SET sol_status = 2,
					<cfif #tbSolicitudes.mov_clave# NEQ 5 AND #tbSolicitudes.mov_clave# NEQ 17 AND #tbSolicitudes.mov_clave# NEQ 28>sol_sintesis = UPPER(ISNULL(sol_memo1,'')) <cfif #tbSolicitudes.mov_clave# NEQ 6> + ' ' + UPPER(ISNULL(sol_memo2,''))</cfif>, </cfif>
					cap_fecha_mod = GETDATE()
					WHERE sol_id = #tbSolicitudes.sol_id#
				</cfquery>
				<!--- Crear el registro correspondiente en la tabla de asuntos --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte)
					VALUES (#tbSolicitudes.sol_id#, #aActa#, 'CAAA',#SeccionEnListado('CAAA',tbSolicitudes.mov_clave,tbSolicitudes.sol_pos2,tbSolicitudes.sol_pos3,tbSolicitudes.sol_pos8,tbSolicitudes.sol_pos17,tbSolicitudes.sol_pos20)#)
				</cfquery>

				<!--- Crear el registro correspondiente para asignarlo a un miembro de la CAAA
				***	SE ELIMIN� YA QUE LOS ASUNTOS DE LA CAAA SE ASIGNAN EN EL M�DULO DE COMISIONES (05/01/2019) ***
				<cfquery datasource="#vOrigenDatosSAMAA#">
					INSERT INTO movimientos_solicitud_comision (sol_id)
					VALUES (#tbSolicitudes.sol_id#)
				</cfquery>
				 --->				
			</cfdefaultcase>
		</cfswitch>
		<!--- Variable para identificar el archivo ligado a la solicitud --->
		<cfset vArchivoActual = #vCarpetaENTIDAD# & mid(#sol_pos1#,1,4) & '\' & #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
		<!--- Si el archivo existe se copia a la carpata de la CAAA --->
		<cfif FileExists(#vArchivoActual#)>
			<cffile action="move" source="#vArchivoActual#" destination="#vCarpetaCAAA#">
		</cfif>
	</cfloop>
	<cfreturn 'ACK'>
</cffunction>
<!--- Si falta al�n archivo PDF enviar un mensaje de regreso --->
<cfif #vFaltaPDF# IS 1>FALTA-ARCHIVO-PDF</cfif>