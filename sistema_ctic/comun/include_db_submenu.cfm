<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 17/01/2018--->
<!--- FECHA ÚLTIMA MOD.: 11/05/2020 --->



<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfquery name="tbSistemaSubMenu" datasource="#vOrigenDatosSAMAA#">
	SELECT 
    submenu_nombre, submenu_control_id, submenu_clave,
	<cfif #Session.sTipoSistema# EQ 'stctic'>
    	ruta_liga_cic AS ruta_liga
    <cfelseif #Session.sTipoSistema# EQ 'sic'>
    	ruta_liga_sic AS ruta_liga
    </cfif>
    FROM samaa_submenu
    WHERE menu_clave = #vMenuClave#
	<cfif #Session.sTipoSistema# EQ 'stctic'>
	    AND submenu_activo_cic = 1
		AND nivel_acceso_cic LIKE '-%#Session.sUsuarioNivel#%-'
	<cfelseif #Session.sTipoSistema# EQ 'sic'>
	    AND submenu_activo_sic = 1
		AND nivel_acceso_sic LIKE '-%#Session.sUsuarioNivel#%-'        
	</cfif>
	ORDER BY submenu_orden    
</cfquery>