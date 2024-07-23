<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 26/11/2009--->
<!--- FECHA ÚLTIMA MOD.: 23/02/2016--->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
<!--- NOTA: Pendiente hacer que pasen bien las Ñ en Microsoft Internet Explorer --->
<!--- Obtener datos de los académicos encontrados --->
<cfquery name="tbAcademicoLista" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos
	WHERE
	<cfif #vTipoBusq# EQ 'NAME'>
		(    
		ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
		CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vTexto)#%'
		OR 
		ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
		CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apemat),'') LIKE '%#NombreSinAcentos(vTexto)#%'
        )
	<cfelseif #vTipoBusq# EQ 'RFC'>
		acd_rfc LIKE '%#vTexto#%'
	<cfelseif #vTipoBusq# EQ 'CLAVE'>
		acd_id = #vTexto#
	</cfif>
	<cfif IsDefined("Session.sTipoSistema") AND  #Session.sTipoSistema# EQ 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
	ORDER BY acd_apepat, acd_apemat, acd_nombres
</cfquery>
<select name="lstAcad" id="lstAcad" size="5" class="datos100" onchange="fSeleccionAcademico();" style="width:400px;">
	<cfoutput query="tbAcademicoLista">
		<option value="#tbAcademicoLista.acd_id#">#tbAcademicoLista.acd_apepat# #tbAcademicoLista.acd_apemat# #tbAcademicoLista.acd_nombres#</option>
	</cfoutput>
</select>
