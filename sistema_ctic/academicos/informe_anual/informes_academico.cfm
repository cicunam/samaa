<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 07/12/2015 --->
<!--- FECHA ÚLTIMA MOD.: 05/09/2023 --->

<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Registrar el filtro --->
<cfset Session.InformeAnualFiltro.vIdAcad = #vIdAcad#>
<cfset Session.InformeAnualFiltro.vPagina = #vPagina#>
<cfset Session.InformeAnualFiltro.vRPP = #vRPP#>
<cfset Session.InformeAnualFiltro.vOrden = '#vOrden#'>
<cfset Session.InformeAnualFiltro.vOrdenDir = '#vOrdenDir#'>

<!--- Obtener la lista de informes anuales del académico --->
<cfquery name="tbInformesAnual" datasource="#vOrigenDatosSAMAA#">
	SELECT
	T1.informe_anio,
	T1.informe_anual_id,
	T1.acd_id,
	T1.informe_cancela,    
    T2.ssn_id,
    T2.informe_oficio,
	C1.dep_siglas,
	C2.cn_siglas,
	C3.dec_super,
	C3.dec_descrip
	FROM
	movimientos_informes_anuales AS T1 
	LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CTIC'  AND (T2.dec_clave = 1 OR T2.dec_clave = 4 OR T2.dec_clave = 49 OR T2.dec_clave BETWEEN 50 AND 60)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN catalogo_decision AS C3 ON T2.dec_clave = C3.dec_clave
	WHERE T1.acd_id = #vIdAcad#
	AND T1.informe_status IS NULL    
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbInformesAnual>
<cfset vConsultaFiltro = Session.InformeAnualFiltro>
<cfset vConsultaFuncion = "tbInformesAnual">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">

<!--- VER LOS REGISTROS COMO TABLA --->
<cfif #tbInformesAnual.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:98%;  margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
			<tr valign="middle" bgcolor="##CCCCCC" height="18px">
				<td class="Sans9GrNe" style="width:15%;">AÑO DE INFORME</td>
				<td class="Sans9GrNe" style="width:23%;">CLASE, CATEGORÍA Y NIVEL</td>
				<td class="Sans9GrNe" style="width:13%;">ENTIDAD</td>
				<td class="Sans9GrNe" style="width:10%;">ACTA</td>
				<td class="Sans9GrNe" style="width:20%;" align="center" title="Decisión del Pleno del CTIC">DECISIÓN CTIC</td>
				<td class="Sans9GrNe" style="width:15%;">NÚMERO DE OFICIO</td>
				<td style="width:2%;" bgcolor="##FF9933"><!-- Ver detalle --></td>                
				<td style="width:2%;" bgcolor="##0066FF"><!-- Ver detalle --></td>
			</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbInformesAnual" startrow="#StartRow#" maxrows="#MaxRows#">
    		<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA RECOMENDACIÓN DEL CONSEJO INTERNO --->
            <cfif #dec_super# IS 'AP'>
                <cfset vFuenteRecCi = 'Sans9Gr'>
            <cfelse>
                <cfset vFuenteRecCi = 'Sans9Vi'>
            </cfif>
			<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA DECISIÓN DEL PLENO DEL CTIC --->
            <cfif #dec_super# IS 'AP'>
                <cfset vFuenteDec = 'Sans9Gr'>
            <cfelse>
                <cfset vFuenteDec = 'Sans9Vi'>
            </cfif>
			<!--- Documentación digitalizada --->
            <cfset vArchivoPdf = #acd_id# & '_' & #informe_anual_id# & '_' & #informe_anio# & '.pdf'>            
			<cfset vArchivoMovPdf = #vCarpetaInformesAnuales# & '\' & #vArchivoPdf#>
			<cfset vArchivoMovPdfWeb = #vWebInformesAnuales# & '/' & #vArchivoPdf#>                 

			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td class="Sans9Gr">#informe_anio#<cfif #informe_cancela# EQ 1><span class="Sans9Vi"><strong> (CANCELADO)</strong></span></cfif></td>
				<td class="Sans9Gr">#cn_siglas#</td>
				<td class="Sans9Gr">#dep_siglas#</td>
				<td class="Sans9Gr">#ssn_id#</td>
				<td class="#vFuenteDec#">#dec_descrip#</td>
				<td class="Sans9Gr">#SoloNumeroOficio(informe_oficio)#</td>
                <td> <!--- SE AGREGÓ PARA CONSULTAR ARCHIVO 08/09/2022--->
                    <cfif FileExists(#vArchivoMovPdf#)>
                        <a href="#vArchivoMovPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_15.jpg" onclick="" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
                    </cfif>
                </td>                
				<td>
					<img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" onclick="fInformeId(#informe_anual_id#);">                
					<!---<a href="informe_academico_detalle.cfm?vIdAcad=#tbInformesAnual.acd_id#&vIdMov=#tbInformesAnual.informe_anual_id#"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a>--->
				</td>
			</tr>
		</cfoutput>
  </table>
</cfif>


<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbInformesAnual.RecordCount#">
</cfoutput>
