


	<!---<cfset vFechaHoy = LsDateFormat(now(),"dd/mm/yyyy hh:mm:ss")>--->

	<cfif IsDefined("vTipoComando") AND #vTipoComando# EQ "N">

	<!--- GUARDA NUEVAS SESIONES --->
	
	<!--- CREA EL REGISTRO DE RECEPCION DE DOCUMENTOS --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
			<cfif IsDefined("vSsnId") AND #vSsnId# NEQ "">
				#vSsnId#<cfelse>0</cfif>
				,
				5
				,
			<cfif IsDefined("ssn_fechaRecDoc") AND #ssn_fechaRecDoc# NEQ "">
				'#LsDateFormat(ssn_fechaRecDoc,"dd/mm/yyyy")# #ssn_horaRecDoc#'<cfelse>NULL</cfif>
				,
				'Secretaría Técnica del Consejo Técnico'
				,
			<cfif IsDefined("ssn_notaRecDoc") AND #ssn_notaRecDoc# NEQ "">
					'#ssn_notaRecDoc#'<cfelse>NULL</cfif>
				,
				NULL
				,
				GETDATE()
			)
		</cfquery>
	
	<!--- CREA EL REGISTRO PARA LA COMISIÓN DE ASUNTOS ACADÉMICO ADAMINISTRATIVOS --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
			<cfif IsDefined("vSsnId") AND #vSsnId# NEQ "">
				#vSsnId#<cfelse>0</cfif>
				,
				4
				,
			<cfif IsDefined("ssn_fechaCaaa") AND #ssn_fechaCaaa# NEQ "">
				'#LsDateFormat(ssn_fechaCaaa,"dd/mm/yyyy")# #ssn_horaCaaa#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("ssn_sedeCaaa") AND #ssn_sedeCaaa# NEQ "">
				'#ssn_sedeCaaa#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("ssn_notaCaaa") AND #ssn_notaCaaa# NEQ "">
					'#ssn_notaCaaa#'<cfelse>NULL</cfif>
				,
				NULL
				,
				GETDATE()
			)
		</cfquery>
	
	<!--- CREA EL REGISTRO DE ENVÍO DE CORRESPONDENCIA --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
			<cfif IsDefined("vSsnId") AND #vSsnId# NEQ "">
				#vSsnId#<cfelse>0</cfif>
				,
				3
				,
			<cfif IsDefined("ssn_fechaCorresp") AND #ssn_fechaCorresp# NEQ "">
				'#LsDateFormat(ssn_fechaCorresp,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
				,
				null
				,
			<cfif IsDefined("ssn_notaCorresp") AND #ssn_notaCorresp# NEQ "">
					'#ssn_notaCorresp#'<cfelse>NULL</cfif>
				,
				NULL
				,
				GETDATE()
			)
		</cfquery>
	
	
	<!--- CREA EL REGISTRO PARA SESION ORDINARIA DEL PLENO --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones (ssn_id, ssn_clave, ssn_fecha, ssn_sede, ssn_nota, ssn_archivo, cap_fecha_crea) VALUES (
			<cfif IsDefined("vSsnId") AND #vSsnId# NEQ "">
				#vSsnId#<cfelse>0</cfif>
				,
				1
				,
			<cfif IsDefined("ssn_fechaPleno") AND #ssn_fechaPleno# NEQ "">
				'#LsDateFormat(ssn_fechaPleno,"dd/mm/yyyy")# #ssn_horaPleno#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("ssn_sedePleno") AND #ssn_sedePleno# NEQ "">
				'#ssn_sedePleno#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("ssn_notaPleno") AND #ssn_notaPleno# NEQ "">
					'#ssn_notaPleno#'<cfelse>NULL</cfif>
				,
				NULL
				,
				GETDATE()
			)
		</cfquery>

	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "E">
<!--- ****************************************************************************  --->
<!--- GUARDA LOS CAMBIOS DEL REGISTRO EDITADO --->
	
	<!--- GUARDA EL REGISTRO DE RECEPCION DE DOCUMENTOS --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones SET 
				ssn_fecha=
				<cfif IsDefined("ssn_fechaRecDoc") AND #ssn_fechaRecDoc# NEQ "">
					'#LsDateFormat(ssn_fechaRecDoc,"dd/mm/yyyy")# #ssn_horaRecDoc#'<cfelse>NULL</cfif>
				,
				ssn_nota= 
				<cfif IsDefined("ssn_notaRecDoc") AND #ssn_notaRecDoc# NEQ "">
						'#ssn_notaRecDoc#'<cfelse>NULL</cfif>
				,
				cap_fecha_mod = GETDATE()
			WHERE ssn_clave = 5 AND ssn_id = #vSsnId#
		</cfquery>
	
	<!--- GUARDA EL REGISTRO PARA LA COMISIÓN DE ASUNTOS ACADÉMICO ADAMINISTRATIVOS --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones SET 
				ssn_fecha= 
				<cfif IsDefined("ssn_fechaCaaa") AND #ssn_fechaCaaa# NEQ "">
					'#LsDateFormat(ssn_fechaCaaa,"dd/mm/yyyy")# #ssn_horaCaaa#'<cfelse>NULL</cfif>
				,
				ssn_sede= 
				<cfif IsDefined("ssn_sedeCaaa") AND #ssn_sedeCaaa# NEQ "">
					'#ssn_sedeCaaa#'<cfelse>NULL</cfif>
				,
				ssn_nota=
				<cfif IsDefined("ssn_notaCaaa") AND #ssn_notaCaaa# NEQ "">
						'#ssn_notaCaaa#'<cfelse>NULL</cfif>
				,
				cap_fecha_mod = GETDATE()
			WHERE ssn_clave = 4 AND ssn_id = #vSsnId#
		</cfquery>
	
	<!--- GUARDA EL REGISTRO DE ENVÍO DE CORRESPONDENCIA --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones SET
				ssn_fecha=
				<cfif IsDefined("ssn_fechaCorresp") AND #ssn_fechaCorresp# NEQ "">
					'#LsDateFormat(ssn_fechaCorresp,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
				,
				ssn_nota=
				<cfif IsDefined("ssn_notaCorresp") AND #ssn_notaCorresp# NEQ "">
						'#ssn_notaCorresp#'<cfelse>NULL</cfif>
				,
				cap_fecha_mod = GETDATE() 
			WHERE ssn_clave = 3 AND ssn_id = #vSsnId#
		</cfquery>
	
	<!--- GUARDA EL REGISTRO PARA SESION ORDINARIA DEL PLENO --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones SET
				ssn_fecha=
				<cfif IsDefined("ssn_fechaPleno") AND #ssn_fechaPleno# NEQ "">
					'#LsDateFormat(ssn_fechaPleno,"dd/mm/yyyy")# #ssn_horaPleno#'<cfelse>NULL</cfif>
				,
				ssn_sede=
				<cfif IsDefined("ssn_sedePleno") AND #ssn_sedePleno# NEQ "">
					'#ssn_sedePleno#'<cfelse>NULL</cfif>
				,
				ssn_nota=		
			<cfif IsDefined("ssn_notaPleno") AND #ssn_notaPleno# NEQ "">
					'#ssn_notaPleno#'<cfelse>NULL</cfif>
				,
				cap_fecha_mod = GETDATE() 
			WHERE ssn_clave = 1 AND ssn_id = #vSsnId#
		</cfquery>
	</cfif>

