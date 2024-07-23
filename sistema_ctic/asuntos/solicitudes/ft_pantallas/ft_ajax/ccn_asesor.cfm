<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 05/05/2009--->
<!--- AJAX PARA OBTENER CCN DEL ACADEMICO --->



<!--- Obtener la clave de la categoría y nivel del académico --->
<cfquery name="tbAcademicoAsesor" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.cn_clave, C1.cn_siglas 
    FROM academicos AS T1
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C1 ON T1.cn_clave = C1.cn_clave <!---CATALOGOS GENERALES MYSQL --->
    WHERE acd_id = #vIdAcad#
</cfquery>

<!--- ELIMINA XXXXXXXXXXXXXX
	<!--- Obtener la clave de la categoría y nivel del académico --->
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos
		WHERE acd_id = #vIdAcad# 
	</cfquery>
	
	<!--- Obtener el nombre de la categoría y nivel obtenidos --->
	<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_cn 
		WHERE cn_clave = '#tbAcademico.cn_clave#'
	</cfquery>
--->

<!--- Regresar la categoría y nivel del asesor --->
<cfoutput query="tbAcademicoAsesor">
	<input name="pos8_txt" id="pos8_txt" type="text" class="datos" size="20" value="#cn_siglas#" disabled>
	<input name="pos8" id="pos8" type="hidden" value="#cn_clave#">
</cfoutput>
