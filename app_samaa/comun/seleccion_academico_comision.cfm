<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 05/03/2009--->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
<!--- NOTA: Pendiente hacer que pasen bien las Ñ en Microsoft Internet Explorer --->
<!--- Obtener datos de los académicos encontrados --->

<cfquery name="tbAcademicoLista" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos_comisiones
	LEFT JOIN academicos ON academicos_comisiones.acd_id = academicos.acd_id
	WHERE 
	ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
	CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
	ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
	CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
	ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vTexto)#%'
	AND status = 1
	ORDER BY acd_apepat, acd_apemat, acd_nombres
</cfquery>
<select name="lstAcadSus" id="lstAcadSus" size="5" class="datos100" onchange="fSeleccionAcademicoSus();" style="width:400px;">
	<cfoutput query="tbAcademicoLista">
	<option value="#tbAcademicoLista.comision_acd_id#">#tbAcademicoLista.acd_apepat# #tbAcademicoLista.acd_apemat# #tbAcademicoLista.acd_nombres#</option>
	</cfoutput>
</select>
