					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 03/09/2020 --->
					<!--- FECHA ULTIMA MOD.: 03/09/2020 --->
					
					<!--- CONTROLES PARA PODER REALIZAR FILTROS POR CLASE, CATEGORÍA Y NIVEL --->
                    <!--- NOTA: remplaza al archivo movimientos_catalogoa_select.cfm --->



<cfset vMovFiltro = "#attributes.filtro#">
<cfset vFuncionScriptAjax = "#attributes.funcion#">
<cfset vfFt = #attributes.sFiltrovFt#>
<cfset vfOrdenDir = #attributes.sFiltrovOrdenDir#>

<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn
    WHERE cn_status = 1 
    ORDER BY cn_clave
</cfquery>

<span class="Sans9GrNe">Categor&iacute;a y nivel:<br></span>
<select name="vCcn" id="vCcn" class="datos" style="width:95%;" onChange="fListarAcademicos(1,'<cfoutput>#Session.AcademicosFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosFiltro.vOrdenDir#</cfoutput>');">
    <option value="">Todas</option>
    <option value="">-----------------------------------</option>
    <option value="INV">INVESTIGADORES</option>
    <option value="TEC">TECNICOS ACADÉMICOS</option>
    <option value="">-----------------------------------</option>
    <cfoutput query="ctCategoria">
        <option value="#cn_clave#" <cfif #cn_clave# EQ #Session.AcademicosFiltro.vCn#>selected</cfif>>#CnSinTiempo(cn_siglas)#</option>
    </cfoutput>
</select>