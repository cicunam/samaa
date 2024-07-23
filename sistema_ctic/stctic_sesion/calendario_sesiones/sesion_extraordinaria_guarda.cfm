
	<cfset vFechaHoy = LsDateFormat(now(),"dd/mm/yyyy hh:mm:ss")>
	<cfif IsDefined("vTipoComando") AND #vTipoComando# EQ "NUEVO">

<!-- GUARDA NUEVAS SESIONES-->
	
	<!-- CREA EL REGISTRO DE RECEPCION DE DOCUMENTOS-->
		<cfset vSesionId =VAL('#MID(ssn_fechaExtra,7,4)#' & '#MID(ssn_fechaExtra,4,2)#' & '#MID(ssn_fechaExtra,1,2)#')>

		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
			<cfif IsDefined("ssn_fechaExtra") AND #ssn_fechaExtra# NEQ "">
				#vSesionId#<cfelse>0</cfif>
				,
				2
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
				'#vFechaHoy#'
			)
		</cfquery>
		<cfmodule template="#vCarpetaCOMUN#/modulo_genera_claves_acceso.cfm" SsnId="#vSesionId#" SsnClave="2" SsnDescrip="PECTIC" OrigenDatos="#vOrigenDatosSAMAA#">
	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "EDITA">
<!-- EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE -->
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
				cap_fecha_mod= 
				'#vFechaHoy#'
			WHERE ssn_clave = 2 AND ssn_id = #vSesionId#
		</cfquery>
	</cfif>
	
	<cflocation url="sesion_extraordinaria.cfm?vSesionId=#vSesionId#&vTipoComando=CONSULTA" addtoken="no">

