<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 08/09/2022 --->

<!--- Registrar filtros --->
<cfset Session.InformesConsultaFiltro.vInformeAnio = #vInformeAnio#>
<cfset Session.InformesConsultaFiltro.vAcadNom = '#vAcadNom#'>
<cfset Session.InformesConsultaFiltro.vDep = '#vDepClave#'>
<cfset Session.InformesConsultaFiltro.vDecCtic = '#vDecClaveCtic#'>
<cfset Session.InformesConsultaFiltro.vDecCi = '#vDecClaveCi#'>    
<cfset Session.InformesConsultaFiltro.vPagina = '#vPagina#'>
<cfset Session.InformesConsultaFiltro.vRPP = #vRPP#>
<cfset Session.InformesConsultaFiltro.vOrden = '#vOrden#'>
<cfset Session.InformesConsultaFiltro.vOrdenDir = '#vOrdenDir#'>
<!---<cfset Session.InformesConsultaFiltro.vActa = #vActa#>--->

<!--- QUERY PARA DESPLEGAR INFORMACIÓN  (SE CREA CONSULTA EN SERVIDOR 13/03/2019)--->
<cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_informes_anuales
	WHERE 1 = 1
    AND informe_anio = #vInformeAnio#
	AND dec_super <> 'OB'
	<cfif #Session.sTipoSistema# IS 'stctic'>
		<cfif (isDefined('vDepClave') AND #vDepClave# IS NOT '')>
			AND dep_clave = '#vDepClave#'
		<cfelseif #Session.sUsuarioNivel# EQ 20>
			AND (dep_clave = '030101' OR dep_tipo = 'UPE')
		</cfif>
	<cfelseif #Session.sTipoSistema# IS 'sic'>        
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
    <cfif (isDefined('vDecClaveCtic') AND #vDecClaveCtic# IS NOT '')>
        AND dec_clave = '#vDecClaveCtic#'
    </cfif>
    <cfif (isDefined('vDecClaveCi') AND #vDecClaveCi# IS NOT '')>
        AND dec_clave_ci = '#vDecClaveCi#'
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
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>
    	ORDER BY 
			<cfif #vOrden# EQ 'nombre'>
				dep_siglas, acd_apepat #vOrdenDir#, acd_apemat #vOrdenDir#, acd_nombres #vOrdenDir#
			<cfelse>
				#vOrden#
				<cfif #vOrdenDir# IS NOT ''> 
                    #vOrdenDir#
                </cfif>
			</cfif>
		</cfif>
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbInformesAnuales>
<cfset vConsultaFiltro = Session.InformesConsultaFiltro>
<cfset vConsultaFuncion = "fListarInformes">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">

<cfif #tbInformesAnuales.RecordCount# GT 0>
	<!--- Controles de paginación --->
    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
    <table style="width:95%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
        <!-- Encabezados -->
        <cfoutput>
            <tr valign="middle" bgcolor="##CCCCCC">
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9GrNe" style="cursor:pointer; width:5%; height:18px;" <cfif #vOrden# IS 'acd_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'acd_id','ASC');"<cfelse>onclick="fListarInformes(1,'acd_id','DESC');"</cfif>>
                        ID <cfif #vOrden# IS 'acd_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                    </td>
					<!---
					<td class="Sans9GrNe" style="cursor:pointer; width:3%;" <cfif #vOrden# IS 'nombre' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'asu_numero','ASC');"<cfelse>onclick="fListarInformes(1,'asu_numero','DESC');"</cfif>>
						No. <cfif #vOrden# IS 'asu_numero'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
					</td>
					--->
				</cfif>
                <td class="Sans9GrNe" style="cursor:pointer; width:35%;" <cfif #vOrden# IS 'nombre' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'nombre','ASC');"<cfelse>onclick="fListarInformes(1,'nombre','DESC');"</cfif>>
                    NOMBRE <cfif #vOrden# IS 'nombre'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                </td>
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9GrNe" style="cursor:pointer; width:10%;" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'dep_siglas','ASC');"<cfelse>onclick="fListarInformes(1,'dep_siglas','DESC');"</cfif>>
                    ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                    </td>
                </cfif>
                <td class="Sans9GrNe" style="cursor:pointer; width:16%;" title="CLASE, CATEGORÍA Y NIVEL" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'cn_siglas','ASC');"<cfelse>onclick="fListarInformes(1,'cn_siglas','DESC');"</cfif>>
                    CCN<cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                </td>
<!---
                <td class="Sans9GrNe" style="width:5%;" title="Opinión Consejo Interno" align="center">CI</td>
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9GrNe" style="width:5%;" title="Recomendación CAAA" align="center">CAAA</td>
                </cfif>
--->
                <td class="Sans9GrNe" style="width:7%;" title="Dictamen Consejo Interno" align="center">D.C.I.</td>
                <td class="Sans9GrNe" style="width:7%;" title="Número de acta" align="center">ACTA</td>
                <td class="Sans9GrNe" style="width:7%;" title="Decisión CTIC" align="center">DEC. CTIC</td>
                <td class="Sans9GrNe" style="width:10%;" title="Número de Oficio" align="center">OFICIO</td>
                <td bgcolor="##FF9933" style="cursor:pointer; width:2%;">&nbsp;</td><!--- SE AGREGÓ PARA CONSULTAR ARCHIVO 08/09/2022--->
                <td bgcolor="##0066FF" style="cursor:pointer; width:2%;">&nbsp;</td>
            </tr>
        </cfoutput>
        <!-- Datos -->
        <cfoutput query="tbInformesAnuales" startRow="#StartRow#" maxRows="#MaxRows#">
			<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA DECISIÓN --->
			<cfif #dec_super# IS 'NA'>
                <cfset vFuenteDec = 'Sans9ViNe'>
			<cfelseif #dec_super# IS 'OB'>
                <cfset vFuenteDec = 'Sans9NaNe'>
            <cfelse>
                <cfset vFuenteDec = 'Sans9GrNe'>
            </cfif>
			<!--- Documentación digitalizada --->
            <cfset vArchivoPdf = #acd_id# & '_' & #informe_anual_id# & '_' & #informe_anio# & '.pdf'>            
			<cfset vArchivoMovPdf = #vCarpetaInformesAnuales# & '\' & #vArchivoPdf#>
			<cfset vArchivoMovPdfWeb = #vWebInformesAnuales# & '/' & #vArchivoPdf#> 
        
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <cfif #Session.sTipoSistema# IS 'stctic'>
	                <td class="Sans9Gr">#acd_id#</td>
	                <!---<td class="Sans9Gr">#asu_numero#</td> --->
				</cfif>
                <td class="Sans9Gr">
                    #Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#
                    <cfif #informe_cancela# EQ 1><span class="Sans9Vi"><strong> (CANCELADO)</strong></span></cfif>
                </td>
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9Gr">#dep_siglas#</td>
                </cfif>
                <td class="Sans9Gr">#CnSinTiempo(cn_siglas)#</td>
    <!---
                <td class="Sans9Gr" align="center">#CI_dec_super#</td>
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9Gr" align="center">#CAAA_dec_super#</td>
                </cfif>
    --->
                <td class="Sans9Gr" align="center">#dec_super_ci#<cfif #dec_clave_ci# EQ 49>C</cfif></td><!--- #dec_super_ci#--->
                <td class="Sans9Gr" align="center">#ssn_id#</td>
                <td class="#vFuenteDec#" align="center" title="#dec_descrip#" style="cursor:pointer">#dec_super#<cfif #dec_clave# EQ 49>C</cfif></td>
                <td class="Sans9Gr" align="center">#informe_oficio#</td>
                <td> <!--- SE AGREGÓ PARA CONSULTAR ARCHIVO 08/09/2022--->
                    <cfif FileExists(#vArchivoMovPdf#)>
                        <a href="#vArchivoMovPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_15.jpg" onclick="" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
                    </cfif>
                </td>
                <td>
					<img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#" onclick="fInformeId(#informe_anual_id#);">
<!---
					<a href="#vCarpetaRaizLogicaSistema#/informes_anuales/informe.cfm?vInformeAnualId=#informe_anual_id#&vTipoComando=CONSULTA">
						<img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#">
					</a>
--->
                </td>
            </tr>
        </cfoutput>
    </table>
    <!--- Controles de paginación --->
    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
</cfif>


<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbInformesAnuales.RecordCount#">
</cfoutput>