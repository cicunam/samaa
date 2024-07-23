<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 04/10/2023--->

<cfset vFechaHoy = LsDateFormat(now(),"dd/mm/yyyy hh:mm:ss")>

<!-- ------------------------------------------------------------------------------------- -->
<!-- ELIMINA REGISTORS DE CARGOS ACADEMICO-ADMINISTRATIVOS-->
	<cfif IsDefined("vTipoComando") AND #vTipoComando# EQ "ELIMINAR">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			DELETE FROM academicos_cargos WHERE caa_id = #vCaaId#
		</cfquery>
		<cflocation url="consejeros_ctic_inicio.cfm" addtoken="no">
<!-- ------------------------------------------------------------------------------------- -->
	<cfelseif IsDefined("vTipoComando") AND #vTipoComando# EQ "NUEVO">

<!-- ELIMINA EL CARGO ACADEMICO-ADMINISTRATIVO ANTERIOR-->
		<cfif #adm_clave# EQ "82" OR #adm_clave# EQ "11" OR MID(#adm_clave#,1,1) EQ "5">
			<cfset vFechaFinalCargo = #LsDateFormat(caa_apartir,'dd/mm/yyyy')# - 1>
		<cfelse>
			<cfset vFechaFinalCargo = #LsDateFormat(caa_fecha_inicio,'dd/mm/yyyy')# - 1>
		</cfif>

		<cfquery name="tbCargosAcdAdmin" datasource="#vOrigenDatosSAMAA#">
			UPDATE academicos_cargos SET
            caa_status = 'F'
            <cfif #adm_clave# EQ "82" OR #adm_clave# EQ "11" OR MID(#adm_clave#,1,1) EQ "5">
            	, caa_fecha_final = #vFechaFinalCargo#
			</cfif>                
			WHERE adm_clave = '#adm_clave#' 
			<cfif #adm_clave# NEQ '13'>
				AND dep_clave = #dep_clave#
			</cfif>
			AND caa_status = 'A'
		</cfquery>

<!-- GUARDA NUEVOS CARGOS ACADEMICO-ADMINISTRATIVOS-->
		<!-- CREA EL REGISTRO NUEVO-->
		<cfquery name="" datasource="#vOrigenDatosSAMAA#">
			INSERT INTO academicos_cargos (acd_id, adm_clave, dep_clave, caa_fecha_inicio, caa_fecha_final, ssn_id, cn_clave, caa_status, caa_depto, caa_email, caa_nota, no_oficio) VALUES (
			<cfif IsDefined("vSelAcad") AND #vSelAcad# NEQ "">
				#vSelAcad#<cfelse>0</cfif>
				,
			<cfif IsDefined("adm_clave") AND #adm_clave# NEQ "">
				'#adm_clave#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("dep_clave") AND #dep_clave# NEQ "">
				'#dep_clave#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_fecha_inicio") AND #caa_fecha_inicio# NEQ "">
				'#caa_fecha_inicio#'
			<cfelseif IsDefined("caa_apartir") AND #caa_apartir# NEQ "">                        
				'#caa_apartir#'
			<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_fecha_final") AND #caa_fecha_final# NEQ "">
				'#caa_fecha_final#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("ssn_id") AND #ssn_id# NEQ "">
					#ssn_id#<cfelse>NULL</cfif>
				,
			<cfif IsDefined("cn_clave") AND #cn_clave# NEQ "">
					'#cn_clave#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_status") AND #caa_status# NEQ "">
					'#caa_status#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_depto") AND #caa_depto# NEQ "">
					'#caa_depto#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_email") AND #caa_email# NEQ "">
					'#caa_email#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_nota") AND #caa_nota# NEQ "">
					'#caa_nota#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("caa_oficio") AND #caa_oficio# NEQ "">
					'#caa_oficio#'<cfelse>NULL</cfif>
			)
		</cfquery>

		<!---
		<cflocation url="miembro_ctic.cfm?vCaaId=#vCaaId#&vTipoComando=CONSULTA" addtoken="no">	
		--->
		<cflocation url="consejeros_ctic_inicio.cfm" addtoken="no">
	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "EDITA">
<!-- ------------------------------------------------------------------------------------- -->
<!-- GUARDA LOS CAMBIOS DEL REGISTRO EDITADO DE CARGOS ACADEMICO-ADMINISTRATIVOS-->
	
	<!-- GUARDA EL REGISTRO EDITADO EN SESION EXTRAORDINARIA -->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE academicos_cargos SET 
				adm_clave=
				<cfif IsDefined("adm_clave") AND #adm_clave# NEQ "">
					'#adm_clave#'<cfelse>NULL</cfif>
				,
				dep_clave= 
				<cfif IsDefined("dep_clave") AND #dep_clave# NEQ "">
					'#dep_clave#'<cfelse>NULL</cfif>
				,
				caa_fecha_inicio= 
	            <cfif #adm_clave# EQ "82" OR MID(#adm_clave#,1,1) EQ "5">
					'#caa_apartir#'
				<cfelse>
					'#caa_fecha_inicio#'
				</cfif>                        
<!---
    			<cfif IsDefined("caa_fecha_inicio") AND #caa_fecha_inicio# NEQ "">
					'#caa_fecha_inicio#'
				<cfelseif IsDefined("caa_apartir") AND #caa_apartir# NEQ "">                        
					'#caa_apartir#'
				<cfelse>NULL</cfif>
--->
				,
				caa_fecha_final= 
				<cfif IsDefined("caa_fecha_final") AND #caa_fecha_final# NEQ "">
					'#caa_fecha_final#'<cfelse>NULL</cfif>
				,
				ssn_id= 
				<cfif IsDefined("ssn_id") AND #ssn_id# NEQ "">
					#ssn_id#<cfelse>0</cfif>
				,
				caa_status= 
				<cfif IsDefined("caa_status") AND (#caa_status# EQ "A" OR #caa_status# EQ "F" OR #caa_status# EQ "R")>
					'#caa_status#'<cfelse>NULL</cfif>
				,
				caa_depto= 
				<cfif IsDefined("caa_depto") AND #caa_depto# NEQ "">
					'#caa_depto#'<cfelse>NULL</cfif>
				,
				caa_email= 
				<cfif IsDefined("caa_email") AND #caa_email# NEQ "">
					'#caa_email#'<cfelse>NULL</cfif>
				,
				caa_nota= 
				<cfif IsDefined("caa_nota") AND #caa_nota# NEQ "">
					'#caa_nota#'<cfelse>NULL</cfif>
				,
				no_oficio= 
				<cfif IsDefined("caa_oficio") AND #caa_oficio# NEQ "">
						'#caa_oficio#'<cfelse>NULL</cfif>
			WHERE caa_id = #vCaaId#
		</cfquery>
		<cflocation url="consejeros_ctic_inicio.cfm" addtoken="no">
	</cfif>



