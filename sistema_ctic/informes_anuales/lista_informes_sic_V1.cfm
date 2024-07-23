<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 01/09/2020 --->
<!--- PRIMER VERSIÓN --->

<!--- Registrar filtros --->
<cfset Session.InformesFiltro.vInformeAnio = #vInformeAnio#>
<cfset Session.InformesFiltro.vInformeStatus = #vInformeStatus#>
<cfset Session.InformesFiltro.vAcadNom = '#vAcadNom#'>
<cfset Session.InformesFiltro.vDep = '#vDepClave#'>
<cfset Session.InformesFiltro.vDecClave = '#vDecClave#'>
<cfset Session.InformesFiltro.vPagina = '#vPagina#'>
<cfset Session.InformesFiltro.vRPP = #vRPP#>
<cfset Session.InformesFiltro.vOrden = '#vOrden#'>
<cfset Session.InformesFiltro.vOrdenDir = '#vOrdenDir#'>
<cfif #vInformeStatus# GT 1>
	<cfset Session.InformesFiltro.vActa = #vActa#>
</cfif>    

<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
<cfquery name="tbInformesAnualesTemp" datasource="#vOrigenDatosSAMAA#">
	SELECT
    informe_anual_id, informe_anio, acd_id, acd_apepat, acd_apemat, acd_nombres, cn_siglas, dec_super_ci
    FROM consulta_informes_anualesEnt
    WHERE informe_anio = #Session.InformesFiltro.vInformeAnio#
    AND dep_clave = '#vDepClave#'
    AND informe_status BETWEEN 1 AND 5
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>
    	ORDER BY 
        <cfif #vOrden# EQ 'nombre'>
            acd_apepat #vOrdenDir#, acd_apemat #vOrdenDir#, acd_nombres #vOrdenDir#
        <cfelse>
            #vOrden#
            <cfif #vOrdenDir# IS NOT ''> 
                #vOrdenDir#
            </cfif>
        </cfif>
	</cfif>
</cfquery>

<cfquery name="tbInformesAnuales" dbtype="query">
	SELECT *  FROM tbInformesAnualesTemp
    WHERE 1 = 1
    <cfif #vDecClave# NEQ '0'>
        AND dec_clave_ci = #vDecClave#
    </cfif>
    <cfif #LEN(vAcadNom)# GT 3>
		AND 
        (
            ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
            CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'
            OR 
            ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
            CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apemat),'') LIKE '%#NombreSinAcentos(vAcadNom)#%' 
		)	    
    </cfif>
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbInformesAnuales>
<cfset vConsultaFiltro = Session.InformesFiltro>
<cfset vConsultaFuncion = "fListarInformes">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">

<cfif #tbInformesAnuales.RecordCount# GT 0>
	<!--- Controles de paginación --->
    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
    <table style="width:95%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
        <!-- Encabezados -->
        <cfoutput>
            <tr valign="middle" bgcolor="##CCCCCC">
                <td class="Sans9GrNe" style="width:3%;" title="Registro">##</td>
                <td class="Sans9GrNe" style="cursor:pointer; width:30%;" <cfif #vOrden# IS 'nombre' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'nombre','ASC');"<cfelse>onclick="fListarInformes(1,'nombre','DESC');"</cfif>>
                    NOMBRE <cfif #vOrden# IS 'nombre'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                </td>
                <td class="Sans9GrNe" style="cursor:pointer; width:15%;" title="CLASE, CATEGORÍA Y NIVEL" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'cn_siglas','ASC');"<cfelse>onclick="fListarInformes(1,'cn_siglas','DESC');"</cfif>>
                    CCN<cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                </td>
                <td class="Sans9GrNe" style="width:7%;" title="Dictamen Consejo Interno" align="center">D.C.I.</td>
                <td class="Sans9GrNe" style="width:7%;" title="Dictamen Consejo Interno" align="center">Situación</td>
                <td bgcolor="##FF9933" style="cursor:pointer; width:2%;">&nbsp;</td>
                <td bgcolor="##0066FF" style="cursor:pointer; width:2%;">&nbsp;</td>
            </tr>
        </cfoutput>
        <!-- Datos -->
        <cfoutput query="tbInformesAnuales" startRow="#StartRow#" maxRows="#MaxRows#">
			<!--- Crea variable de archivo de solicitud --->
            <cfset vArchivoPdf = '#acd_id#_#informe_anual_id#_#informe_anio#.pdf'>
            <cfset vArchivoInformePdf = #vCarpetaInformesAnuales# & #vArchivoPdf#>			
            <cfset vArchivoInformePdfWeb = #vWebInformesAnuales# & #vArchivoPdf#>
			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td class="Sans9Gr">#CurrentRow#</td>
                <td class="Sans9Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</td>
                <td class="Sans9Gr">#cn_siglas#</td>
                <td class="Sans9Gr" align="center">#dec_super_ci#</td>
                <td class="Sans9Gr" align="center"></td>
                <td>
					<cfif FileExists(#vArchivoInformePdf#)>
                        <a href="#vArchivoInformePdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>                    
					</cfif>
                </td>
                <td>
					<a href="informe.cfm?vInformeAnualId=#informe_anual_id#&vTipoComando=CONSULTA">
						<img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#">
					</a>
                </td>
            </tr>
        </cfoutput>
    </table>
    
    
    <!--- Controles de paginación --->
    <cfinclude template="../../includes/paginacion.cfm">
    
<cfelseif #tbInformesAnuales.RecordCount# EQ 0 AND #vInformeAnio# GT 0 AND #vInformeStatus# LTE 1>
	<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
    <cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
        SELECT DISTINCT COUNT(*) OVER(PARTITION BY informe_status) AS vCuenta
		, informe_status
        FROM movimientos_informes_anuales AS T1
        WHERE 1 = 1
        AND T1.informe_anio = #vInformeAnio#
        <cfif #vDepClave# NEQ ''>
            AND T1.dep_clave = '#vDepClave#'
        </cfif>
    </cfquery>
	<div align="center" style="height:150px; margin-top: 50px;">
		<cfif #tbInformesAnuales.RecordCount# EQ 0>
            <span class="Sans12ViNe">IMPORTAR ACADÉMICOS REPORTADOS EN EL SISTEMA CISIC PARA MEMORIA UNAM <cfoutput>#vInformeAnio#</cfoutput></span>
            <br /><br />
            <div style="width:30%;"><input type="button" name="cmdInicioCarga" id="cmdInicioCarga" value="IMPORTAR REGISTROS" onclick="fImportarRegistros();" class="botones" /></div>
        <cfelse>
			<cfoutput query="tbInformesAnuales">
				<cfif #informe_status# EQ 1 AND #vCuenta# GT 0>
        	        <span class="Sans12ViNe">LOS INFORMES ANUALES <cfoutput>#vInformeAnio#</cfoutput> YA SE ENCUENTRAN EN PROCESO</span>
				</cfif>
                <br /><br />
			</cfoutput>
        </cfif>
	</div>
</cfif>


<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbInformesAnuales.RecordCount#">
</cfoutput>