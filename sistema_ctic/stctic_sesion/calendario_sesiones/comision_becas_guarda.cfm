<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 05/09/2017 --->
<!--- FECHA ULTIMA MOD.: 03/05/2023 --->
<!--- GUARDA LOS NUEVOS REGISTROS / MODIFCACIONES DE LAS SESIONES DE LA COMISIÓN DE BECAS POSDOCTRALES  --->


	<cfset vFechaHoy = LsDateFormat(now(),"dd/mm/yyyy hh:mm:ss")>
	<!-- GUARDA NUEVAS FECHA PARA COMISIÓN DE BECAS-->
	<cfif IsDefined("vTipoComando") AND #vTipoComando# EQ "NUEVO">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
				#ssn_id#
				,
				7
				,
			<cfif IsDefined("ssn_fechaExtra") AND #ssn_fechaExtra# NEQ "">
				'#ssn_fechaExtra# #ssn_HoraExtra#'<cfelse>NULL</cfif>
				,
				'en la sala de Juntas del CTIC'
				,
			<cfif IsDefined("ssn_notaExtra") AND #ssn_notaExtra# NEQ "">
					'#ssn_notaExtra#'<cfelse>NULL</cfif>
				,
				NULL
				,
				GETDATE()
			)
		</cfquery>
	
	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "EDITA">
    <!-- GUARDA LOS CAMBIOS DEL REGISTRO EDITADO DE SESION EXTRAORDINARIA-->
	
	<!-- GUARDA EL REGISTRO EDITADO EN SESION EXTRAORDINARIA -->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones SET 
				ssn_fecha=
				<cfif IsDefined("ssn_fechaExtra") AND #ssn_fechaExtra# NEQ "">
				    '#ssn_fechaExtra# #ssn_HoraExtra#'<cfelse>NULL</cfif>
				,
				ssn_sede=
				<cfif IsDefined("ssn_sedeExtra") AND #ssn_sedeExtra# NEQ "">
					'#ssn_sedeExtra#'<cfelse>NULL</cfif>
				,
				ssn_nota= 
				<cfif IsDefined("ssn_notaExtra") AND #ssn_notaExtra# NEQ "">
                    '#ssn_notaExtra#'<cfelse>NULL</cfif>
				,
				cap_fecha_mod = GETDATE()
			WHERE ssn_clave = 7 AND id = #vid#
		</cfquery>
	</cfif>
	<cfif LEN(#periodo_conv_id#) GT 0>
		<cfquery datasource="#vOrigenDatosPOSDOC#">
			UPDATE convocatorias_periodos
			SET ssn_id = #ssn_id#
			WHERE periodo_conv_id = #periodo_conv_id#
            AND ssn_id IS NULL
		</cfquery>
	</cfif>
	<cflocation url="comision_becas.cfm?vSesionId=#ssn_id#&vTipoComando=CONSULTA" addtoken="no">

