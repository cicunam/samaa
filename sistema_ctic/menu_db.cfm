<cfset vFecha = #LSDATEFORMAT(now(),'dd/mm/yyyy')#>

<!--- Obtener los menús a desplegar --->
<cfquery name="tbMenus" datasource="#vOrigenDatosSAMAA#">
    <cfif #Session.sTipoSistema# EQ 'sic'>
		SELECT menu_clave, menu_nombre, menu_descrip_sic AS menu_descrip, ruta_liga_sic AS ruta_liga 
        FROM samaa_menu
		WHERE 1 = 1
    	AND menu_activo_sic = 1
		AND nivel_acceso_sic LIKE '-%#Session.sUsuarioNivel#%-'
	<cfelseif #Session.sTipoSistema# EQ 'stctic'>   <!--- ANTES 'stctic' --->
		SELECT menu_clave, menu_nombre, menu_descrip_cic AS menu_descrip, ruta_liga_cic AS ruta_liga 
        FROM samaa_menu
		WHERE 1 = 1
    	AND menu_activo_cic = 1
		AND nivel_acceso_cic LIKE '-%#Session.sUsuarioNivel#%-'
    </cfif>
	ORDER BY menu_orden
</cfquery>

<!--- Obtener información de la tabla de acceso --->
<cfquery name="tbAcceso" datasource="#vOrigenDatosACCESO#">
	SELECT * FROM acceso 
    WHERE clave = '#Session.sLoginSistema#' 
</cfquery>

<!--- Obtener información del periodo de sesión ordinaria --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #Session.sSesion# 
    AND ssn_clave = 1
</cfquery>

<cfset vSsnFechaVig = #LsDateFormat(tbSesion.ssn_fecha,'dd/mm/yyyy')# & ' ' & #LsTimeFormat(tbSesion.ssn_fecha,'hh:mm:ss')#>

<!--- Obtener la sesión o sesiones siguientes --->
<cfquery name="tbSesionPlenoActual" datasource="#vOrigenDatosSAMAA#">
	SELECT ssn_id FROM sesiones 
    WHERE ssn_fecha = '#vSsnFechaVig#'
    AND ssn_clave = 1
    ORDER BY ssn_id
</cfquery>

<cfset vSesionVig =  #LsNumberFormat(tbSesionPlenoActual.ssn_id,'9999')#>

<cfif #tbSesionPlenoActual.recordCount# GT 1>
	<cfoutput query="tbSesionPlenoActual" startrow="2">
		<cfset vSesionVig = #vSesionVig# & ' y ' & #LsNumberFormat(tbSesionPlenoActual.ssn_id,'9999')#>
	</cfoutput>
</cfif>

<!--- Obtener información del periodo de sesión extraordinaria --->
<cfquery name="tbSesionExtra" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_fecha >= '#vFecha#' 
	AND ssn_clave = 2
</cfquery>

<!--- Obtener información de la reunión CAAA --->
<cfquery name="tbSesionCAAA" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones  
    WHERE ssn_clave = 4 
	AND ssn_fecha >= '#vFecha#'
</cfquery>

<!--- Obtener información del periodo de recepción de documentos --->
<cfquery name="tbSesionDoc" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_clave = 5 
	AND ssn_fecha >= '#vFecha#' 
	ORDER BY ssn_fecha
</cfquery>