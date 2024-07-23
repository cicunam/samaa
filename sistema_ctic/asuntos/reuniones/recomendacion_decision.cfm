<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 10/08/2022 --->

<!--- AJAX PARA APROBAR LOS ASUNTOS SELECCIONADOS --->
<!--- Incluir la función para determinar la sección del listado que le corresponde --->
<cfinclude template="../seccion_listado.cfm">
<!--- Asignar recomendación/decición --->
<cfif #vIdSol# IS 'TODAS'>
	<cfif #vReunion# IS 'CAAA'>
		<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCAAAFiltro.vMarcadas)#">
			<cfoutput>#AsignarRecDec(vActa, vReunion, Session.AsuntosCAAAFiltro.vMarcadas[E], vDecision)#</cfoutput>
		</cfloop>
	<cfelseif #vReunion# IS 'CTIC'>
		<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#">
			<cfoutput>#AsignarRecDec(vActa, vReunion, Session.AsuntosCTICFiltro.vMarcadas[E], vDecision)#</cfoutput>
		</cfloop>
	</cfif>
<cfelse>
	<cfoutput>#AsignarRecDec(vActa, vReunion, vIdSol, vDecision)#</cfoutput>
</cfif>
<!--- Función para asignar un asunto a una sesión --->
<cffunction name="AsignarRecDec" description="Asignar un asunto a una recomandación/sesión del CTIC.">
	<!--- Parámetros utilizados --->
	<cfargument name="aActa">
	<cfargument name="aReunion">
	<cfargument name="aSolicitud">
	<cfargument name="aDecision">
	<!--- Obtener el asunto marcado sobre el que se trabajará --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud 
		WHERE sol_id = #aSolicitud# 
		AND mov_clave <> 31 <!--- NOTA: Excluir correcciones a oficio (FT-CTIC-31) --->
	</cfquery>
	<!--- Asignar a cada asunto la recomandación especificada --->
	<cfloop query="tbSolicitudes">
		<!--- Actualizar el registro de asunto indicado --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET dec_clave = 
			<cfif #aDecision# IS 100>
				#GenericaAprobatoria(tbSolicitudes.mov_clave)#
			<cfelseif #aDecision# IS NOT ''>
				#aDecision#
			<cfelse>
				NULL
			</cfif>
			WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = '#aReunion#' AND ssn_id = #aActa#
		</cfquery>
		<!--- Si se va a asignar una recomendación CAAA --->
		<cfif #aReunion# IS 'CAAA'>
			<cfif #aDecision# IS NOT ''>
				<!--- Cambiar el status de la solicitud a "asunto a considerar por el pleno" --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_solicitud SET sol_status = 1 WHERE sol_id = #tbSolicitudes.sol_id#
				</cfquery>
				<!--- Verificar si existe el registro de asunto CTIC --->
				<cfquery name="tbAsuntosCTIC"datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_asunto 
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #aActa# AND asu_reunion = 'CTIC'
				</cfquery>
				<!--- Si no existe el registro de asunto CTIC, crearlo --->
				<cfif #tbAsuntosCTIC.RecordCount# EQ 0>
					<!--- Obtener los datos actuales del asunto CAAA --->
					<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM movimientos_asunto 
						WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #aActa# AND asu_reunion = 'CAAA'
					</cfquery>
					<cfdump var="#tbAsuntosCAAA#">
					<!--- Si el asunto actual está en la sección II o IV entonces se debe conservar su número de sección y número de asunto --->					
					<cfif (#tbAsuntosCAAA.asu_parte# GTE 4 AND #tbAsuntosCAAA.asu_parte# LT 5) OR (#tbAsuntosCAAA.asu_parte# GTE 2 AND #tbAsuntosCAAA.asu_parte# LT 3)>
						<cfquery datasource="#vOrigenDatosSAMAA#">
							INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte, asu_numero)
							VALUES (#tbSolicitudes.sol_id#, #aActa#, 'CTIC', #tbAsuntosCAAA.asu_parte#, #tbAsuntosCAAA.asu_numero#)
						</cfquery>
					<cfelse>
						<cfquery datasource="#vOrigenDatosSAMAA#">
							INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte)
							VALUES (#tbSolicitudes.sol_id#, #aActa#, 'CTIC', #SeccionEnListado('CTIC',tbSolicitudes.mov_clave,tbSolicitudes.sol_pos2,tbSolicitudes.sol_pos3,tbSolicitudes.sol_pos8,tbSolicitudes.sol_pos17,tbSolicitudes.sol_pos20)#)
						</cfquery>
					</cfif>	
				</cfif>
			<cfelse>
				<!--- Cambiar el status de la solicitud a "asunto que pasa a la CAAA" --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_solicitud SET sol_status = 2 WHERE sol_id = #tbSolicitudes.sol_id#
				</cfquery>
				<!--- Eliminar el registro de asunto CTIC --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					DELETE FROM movimientos_asunto 
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #aActa# AND asu_reunion = 'CTIC'
				</cfquery>
			</cfif>
		<!--- Si se va a asignar la decisión del CTIC --->	
		<cfelseif #aReunion# IS 'CTIC'>
            <!--- Cambiar el status de la solicitud a "el CTIC tomó una decisión sobre el asunto" (actualizado el 10/08/2022) --->
            <cfquery datasource="#vOrigenDatosSAMAA#">
                UPDATE movimientos_solicitud 
                SET 
                    sol_status = <cfif #aDecision# EQ ''>1<cfelse>0</cfif>
                    , 
                    cap_fecha_mod = GETDATE() 
                WHERE sol_id = #tbSolicitudes.sol_id#
            </cfquery>
		</cfif>
	</cfloop>
</cffunction>
<!--- Función que determina cual el la recomendación/decisión genérica aprobatoaria del asunto --->
<cffunction name="GenericaAprobatoria">
	<cfargument name="aFT"><!--- Tipo de asunto --->
	<!--- Registrar la recomendación en la tabla de asuntos --->
	<cfswitch expression="#aFT#">
		<!--- Asuntos que reciben recomendación de RATIFICAR --->
		<cfcase value="5,7,8,9,10,15,17,18,19,28">	
			<cfreturn 25>
		</cfcase>
		<!--- Asuntos que reciben recomendación de APROBAR --->
		<cfdefaultcase>
			<cfreturn 1>
		</cfdefaultcase>	
	</cfswitch>	
</cffunction>
