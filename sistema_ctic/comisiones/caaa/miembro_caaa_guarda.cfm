<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO DUAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 30/11/2015 --->

	<cfset vFechaHoy = LsDateFormat(now(),"dd/mm/yyyy hh:mm:ss")>

	<cfif IsDefined("vTipoComando") AND #vTipoComando# EQ "NUEVO">

		<!--- Obtener el siguiente número de miembro de la CAAA --->
        <cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM contadores;
            EXEC INCREMENTAR_CONTADOR 'COM';
        </cfquery>
		
        <cfset vComisionId = #tbContadores.c_acd_comisiones#>
		
        <cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM academicos
            WHERE acd_id = #vSelAcad#
        </cfquery>
    
        <cfif IsDefined("vSelAcadSus") AND #vSelAcadSus# NEQ "">
            <cfquery name="tbAcademicoSus" datasource="#vOrigenDatosSAMAA#">
                SELECT * FROM academicos_comisiones
                WHERE comision_acd_id = #vSelAcadSus#
                AND status = 1
            </cfquery>
            <cfset vAcdIdSus = #tbAcademicoSus.acd_id#>
        <cfelse>
            <cfset vAcdIdSus = "">
        </cfif>
        
        <cfset vEntidadClave = #tbAcademicos.dep_clave#>
        <cfset vCnClave = #tbAcademicos.cn_clave#>    
	<!-- ------------------------------------------------->
	<!-- GUARDA NUEVOS CARGOS ACADEMICO-ADMINISTRATIVOS -->
	<!-- CREA EL REGISTRO NUEVO-->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO academicos_comisiones (comision_acd_id, comision_clave, acd_id, dep_clave, cn_clave, fecha_inicio, presidente, sustitucion, ssn_id, nota, acd_id_remplazo, status) VALUES (
			#vComisionId#
			,
			<cfif IsDefined("comision_clave") AND #comision_clave# NEQ "">
				#comision_clave#<cfelse>0</cfif>
				,
			<cfif IsDefined("vSelAcad") AND #vSelAcad# NEQ "">
				#vSelAcad#<cfelse>0</cfif>
				,
				'#vEntidadClave#'
				,
				'#vCnClave#'
				,
			<cfif IsDefined("fecha_inicio") AND #fecha_inicio# NEQ "">
				'#fecha_inicio#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("presidente") AND #presidente# NEQ "">
				#presidente#<cfelse>0</cfif>
				,
			<cfif IsDefined("sustitucion") AND #sustitucion# NEQ "">
				#sustitucion#<cfelse>0</cfif>
				,
			<cfif IsDefined("ssn_id") AND #ssn_id# NEQ "">
				#ssn_id#<cfelse>0</cfif>
				,
			<cfif IsDefined("comision_nota") AND #comision_nota# NEQ "">
				'#comision_nota#'<cfelse>NULL</cfif>
				,
			<cfif IsDefined("vSelAcadSus") AND #vSelAcadSus# NEQ "">
				#vAcdIdSus#<cfelse>0</cfif>
				,
			<cfif IsDefined("sustitucion") AND #sustitucion# NEQ "">
				0<cfelse>1</cfif>
			)
		</cfquery>

		<!-- ACTUALIZA LA SITUACION DEL ACADEMICO QUE SUSTITUYE -->
		<cfif Not IsDefined("sustitucion")>
			<cfif VAL(#vSelAcadSus#) GT 0>
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    UPDATE academicos_comisiones SET
                        fecha_final =
                        <cfif IsDefined("fecha_inicio") AND #fecha_inicio# NEQ "">
                            '#fecha_inicio#'<cfelse>NULL</cfif>
                        ,
                        status = 0
                    WHERE comision_acd_id = #vSelAcadSus# AND status = 1
                </cfquery>
            </cfif>
        </cfif>

	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "EDITA">
<!-- ------------------------------------------------------------------------------------- -->
<!-- GUARDA LOS CAMBIOS DEL REGISTRO EDITADO DE CARGOS ACADEMICO-ADMINISTRATIVOS-->
	
	<!-- GUARDA EL REGISTRO DEL MIEMBRO DE LA COMISIÓN -->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE academicos_comisiones SET 
				fecha_inicio= 
				<cfif IsDefined("fecha_inicio") AND #fecha_inicio# NEQ "">
						'#fecha_inicio#'<cfelse>NULL</cfif>
				,
				presidente= 
				<cfif IsDefined("presidente") AND #presidente# NEQ "">
						'#presidente#'<cfelse>NULL</cfif>
				,
				nota= 
				<cfif IsDefined("comision_nota") AND #comision_nota# NEQ "">
						'#comision_nota#'<cfelse>NULL</cfif>
			WHERE comision_acd_id = #vComisionId#
		</cfquery>
	<cfelseif  IsDefined("vTipoComando") AND #vTipoComando# EQ "ELIMINAR">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			DELETE FROM academicos_comisiones WHERE comision_acd_id = #vComisionId#
        </cfquery>
	</cfif>
	<cflocation url="miembro_caaa.cfm?vComisionId=#vComisionId#&vTipoComando=CONSULTA" addtoken="no">

