<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 01/09/2020 --->

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
    T1.informe_anual_id, T1.informe_anio,
    T3.asu_numero,
    T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
    C2.cn_siglas_nom,
    C1.dep_siglas,
	T3.ssn_id,
	T3.informe_oficio,
    C3.dec_super
	<cfif #vInformeStatus# GT 1>
        ,
        (
            SELECT COUNT(*) 
            FROM movimientos_informes_asunto 
            WHERE informe_anual_id = T1.informe_anual_id 
            AND ssn_id > #vActa# 
            AND informe_reunion = <cfif #vInformeStatus# EQ 3>'CTIC'<cfelse>'CAAA'</cfif>
        ) AS vCuenta
    </cfif>
	<cfif #vInformeStatus# LTE 1>
	    ,C4.dec_super AS dec_super_ci
	</cfif>        
    FROM movimientos_informes_anuales AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id <!--- AND T3.informe_reunion = <cfif #vInformeStatus# EQ 3>'CTIC'<cfelse>'CAAA'</cfif> --->
	LEFT JOIN catalogo_dependencia AS C1 ON T1.dep_clave = C1.dep_clave
	LEFT JOIN catalogo_cn AS C2 ON T1.cn_clave = C2.cn_clave
<!---
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave  <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave <!---CATALOGOS GENERALES MYSQL --->
--->	
    LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave 
	<cfif #vInformeStatus# LTE 1>
	    LEFT JOIN catalogo_decision AS C4 ON T1.dec_clave_ci = C4.dec_clave
	</cfif>
    WHERE informe_status = #vInformeStatus#
	<cfif #vInformeStatus# GT 1>
    	AND T3.ssn_id = #vActa#
		<cfif #vInformeStatus# EQ 2>
			AND T3.informe_reunion = 'CAAA'
		<cfelseif #vInformeStatus# EQ 3>
			AND T3.informe_reunion = 'CTIC'
		</cfif>
	</cfif>
    <cfif #vDepClave# NEQ ''>
    	AND T1.dep_clave = '#vDepClave#'
    </cfif>

    <cfif #vInformeStatus# LTE 1 AND #vDecClave# NEQ '0'>
        AND T1.dec_clave_ci = #vDecClave#
    </cfif>
    <cfif (#vInformeStatus# EQ 2 OR #vInformeStatus# EQ 3) AND #vDecClave# NEQ '0'>
        AND T3.dec_clave = #vDecClave#
    </cfif>
    <cfif #vDecClave# NEQ '0'>
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
		<cfif #vInformeStatus# EQ 3>
			dep_orden, asu_numero
        <cfelseif #vInformeStatus# EQ 2>
			T3.dec_clave DESC, dep_orden, acd_apepat, acd_apemat
        <cfelse>            
            <cfif #vOrden# EQ 'nombre'>
                dep_orden, acd_apepat #vOrdenDir#, acd_apemat #vOrdenDir#, acd_nombres #vOrdenDir#
            <cfelse>
                #vOrden#
                <cfif #vOrdenDir# IS NOT ''> 
                    #vOrdenDir#
                </cfif>
            </cfif>
        </cfif>
	</cfif>
</cfquery>

<cfquery name="tbInformesAnuales" dbtype="query">
	SELECT *  FROM tbInformesAnualesTemp
	<cfif #vInformeStatus# GT 1>
	    WHERE vCuenta = 0
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
                <cfif #Session.sTipoSistema# IS 'stctic'>
					<cfif #vInformeStatus# EQ 1>
                        <td class="Sans9GrNe" style="cursor:pointer; width:5%; height:18px;" <cfif #vOrden# IS 'acd_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'acd_id','ASC');"<cfelse>onclick="fListarInformes(1,'acd_id','DESC');"</cfif>>
                            ID <cfif #vOrden# IS 'acd_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                        </td>
                        <td class="Sans9GrNe" style="cursor:pointer; width:5%;" <cfif #vOrden# IS 'nombre' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'asu_numero','ASC');"<cfelse>onclick="fListarInformes(1,'asu_numero','DESC');"</cfif>>
                            No. <cfif #vOrden# IS 'asu_numero'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                        </td>
					<cfelse>
                        <td class="Sans9GrNe" style="width:5%; height:18px;">ID</td>
                        <td class="Sans9GrNe" style="width:5%;">No.</td>
					</cfif>
				</cfif>
				<cfif #vInformeStatus# EQ 1>
                    <td class="Sans9GrNe" style="cursor:pointer; width:35%;" <cfif #vOrden# IS 'nombre' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'nombre','ASC');"<cfelse>onclick="fListarInformes(1,'nombre','DESC');"</cfif>>
                        NOMBRE <cfif #vOrden# IS 'nombre'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                    </td>
				<cfelse>
					<td class="Sans9GrNe" style="width:35%;">NOMBRE</td>
				</cfif>
                <cfif #Session.sTipoSistema# IS 'stctic'>
					<cfif #vInformeStatus# EQ 1>
                        <td class="Sans9GrNe" style="cursor:pointer; width:7%;" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'dep_siglas','ASC');"<cfelse>onclick="fListarInformes(1,'dep_siglas','DESC');"</cfif>>
                        ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                        </td>
                    <cfelse>
                        <td class="Sans9GrNe" style="width:7%;">ENTIDAD</td>
                    </cfif>
                </cfif>
                <td class="Sans9GrNe" style="cursor:pointer; width:14%;" title="CLASE, CATEGORÍA Y NIVEL" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarInformes(1,'cn_siglas','ASC');"<cfelse>onclick="fListarInformes(1,'cn_siglas','DESC');"</cfif>>
                    CCN<cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
                </td>
                <cfif #vInformeStatus# LTE 1>
	                <td class="Sans9GrNe" style="width:7%;" title="Dictamen Consejo Interno" align="center">D.C.I.</td>
				</cfif>                    
				<cfif #vInformeStatus# GT 1>
                    <td class="Sans9GrNe" style="width:7%;" title="Número de acta" align="center">ACTA</td>
				</cfif>
				<cfif #vInformeStatus# EQ 2>
                    <td class="Sans9GrNe" style="width:7%;" title="Decisión CTIC" align="center">REC. CAAA</td>
				</cfif>
				<cfif #vInformeStatus# EQ 3>
                    <td class="Sans9GrNe" style="width:7%;" title="Decisión CTIC" align="center">DEC. CTIC</td>
                    <td class="Sans9GrNe" style="width:10%;" title="Número de Oficio" align="center">OFICIO</td>
				</cfif>                    
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
                <cfif #Session.sTipoSistema# IS 'stctic'>
	                <td class="Sans9Gr">#acd_id#</td>
	                <td class="Sans9Gr">#asu_numero#</td>
				</cfif>
                <td class="Sans9Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</td>
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9Gr">#dep_siglas#</td>
                </cfif>
                <td class="Sans9Gr">#cn_siglas_nom#</td>
				<cfif #vInformeStatus# LTE 1>                
	                <td class="Sans9Gr" align="center">#dec_super_ci#</td>
				</cfif>                    
				<cfif #vInformeStatus# GT 1>
	                <td class="Sans9Gr" align="center">#ssn_id#</td>
				</cfif>
				<cfif #vInformeStatus# EQ 2>
                    <td class="Sans9Gr" align="center">#dec_super#</td>
				</cfif>
				<cfif #vInformeStatus# EQ 3>
                    <td class="Sans9Gr" align="center">#dec_super#</td>
                    <td class="Sans9Gr" align="center">#informe_oficio#</td>
				</cfif>
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
				<cfelseif #informe_status# EQ 0 AND #vCuenta# GT 0> 
        	        <span class="Sans12ViNe">LOS INFORMES ANUALES <cfoutput>#vInformeAnio#</cfoutput> SE ENCUENTRAN EN CAPTURA POR LA ENTIDAD</span>
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