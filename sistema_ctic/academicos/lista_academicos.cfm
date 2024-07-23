<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 11/01/2024--->
<!--- RESULTADO DE LISTA DE REGISTROS --->

<cfif #CGI.SERVER_PORT# EQ '31221'>                
    <cfoutput>DEP_CLAVE = #Session.sIdDep#; USUARIO NIVEL = #Session.sUsuarioNivel#</cfoutput>               
</cfif>

<!--- Registrar filtros --->
<cfset Session.AcademicosFiltro.vAcadId = #vAcadId#>
<cfset Session.AcademicosFiltro.vAcadNom = '#vAcadNom#'>
<cfset Session.AcademicosFiltro.vAcadRfc = '#vAcadRfc#'>
<cfset Session.AcademicosFiltro.vCn = '#vCn#'>
<cfset Session.AcademicosFiltro.vContrato = #vContrato#>
<cfif IsDefined('vAcadDep')>
	<cfset Session.AcademicosFiltro.vAcadDep = '#vAcadDep#'>
</cfif>
<cfset Session.AcademicosFiltro.vAcadSexo = #vAcdSexo#>    
<cfset Session.AcademicosFiltro.vActivo = #vActivo#>
<cfset Session.AcademicosFiltro.vPagina = '#vPagina#'>
<cfset Session.AcademicosFiltro.vRPP = #vRPP#>
<cfset Session.AcademicosFiltro.vOrden = '#vOrden#'>
<cfset Session.AcademicosFiltro.vOrdenDir = '#vOrdenDir#'>
<!--- Obtener la lista de académicos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT
    acd_id, acd_apepat, acd_apemat, acd_nombres, acd_sexo, acd_fecha_nac, cn_siglas, con_descrip, dep_siglas, edo_clave, activo
    FROM (((academicos AS T1
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias_ubica')# AS C2 ON T1.dep_clave = C2.dep_clave AND T1.dep_ubicacion = C2.ubica_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.cn_clave = C3.cn_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_contratos')# AS C4 ON T1.con_clave = C4.con_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE 1=1 
	<cfif #vAcadId# IS NOT ''>
		AND acd_id = #vAcadId#
	<cfelseif #vAcadRfc# IS NOT ''>
		AND acd_rfc LIKE '%#vAcadRfc#%'
	<cfelseif #vAcadNom# IS NOT ''>
		AND 
        (
            ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
            CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'
            OR 
            ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
            CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apepat),'') LIKE '%#NombreSinAcentos(vAcadNom)#%' 
		)
			<!--- ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'--->
	</cfif>
	<cfif #vCn# IS NOT ''>
    	<cfif #vCn# EQ 'INV' OR #vCn# EQ 'TEC'>
		   	 AND C3.cn_siglas LIKE '#vCn#%'
		<cfelse>
		   	 AND T1.cn_clave = '#vCn#'
		</cfif>
	</cfif>
	<cfif #vContrato# IS NOT ''> AND T1.con_clave = #vContrato#</cfif>
	<!--- Filtro por entidad --->
	<cfif #Session.sTipoSistema# IS 'stctic'>
		<cfif (isDefined('vAcadDep') AND #vAcadDep# IS NOT '')>
			AND T1.dep_clave = '#vAcadDep#'
		<cfelseif #Session.sUsuarioNivel# EQ 20>
			AND (T1.dep_clave = '030101' OR dep_tipo = 'UPE') <!--- T1.dep_clave = '030101' OR T1.dep_clave = '034201' OR T1.dep_clave = '034301' OR T1.dep_clave = '034401') --->
		</cfif>
	<cfelseif #Session.sTipoSistema# IS 'sic'>
		<cfif #Session.sUsuarioNivel# EQ 26> <!--- SE AGRAGARON LOS POYECTOS DE LA UPEID Y COPO 11/01/2024 --->
            AND T1.dep_clave = '030101' 
		    <cfif #Session.sIdDep# EQ '034201'>
                AND T1.dep_ubicacion = '02'
		    <cfelseif #Session.sIdDep# EQ '034301'>
                AND T1.dep_ubicacion = '03'
		    <cfelseif #Session.sIdDep# EQ '034401'>
                AND T1.dep_ubicacion = '04'
		    <cfelseif #Session.sIdDep# EQ '030116'>
                AND T1.dep_ubicacion = '06'
		    <cfelseif #Session.sIdDep# EQ '034501'>
                AND T1.dep_ubicacion = '07'
		    <cfelseif #Session.sIdDep# EQ '034601'>
                AND T1.dep_ubicacion = '08'                
            </cfif>
        <cfelse>
		    AND T1.dep_clave = '#Session.sIdDep#'
        </cfif>
	</cfif>
	<cfif #vAcdSexo# NEQ ''> <!--- Se agrego el 04/12/2023 --->
        AND T1.acd_sexo = '#vAcdSexo#'
    </cfif>
	<cfif #vActivo# IS 1>AND T1.activo = 1</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbAcademicos>
<cfset vConsultaFiltro = Session.AcademicosFiltro>
<cfset vConsultaFuncion = "fListarAcademicos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Lista de académicos --->
<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
	<tr valign="middle" bgcolor="##CCCCCC">
		<td style="width:5%; height:18px; cursor:pointer; " <cfif #vOrden# IS 'acd_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarAcademicos(1,'acd_id','ASC');"<cfelse>onclick="fListarAcademicos(1,'acd_id','DESC');"</cfif>>
			<span class="Sans9GrNe">ID </span><cfif #vOrden# IS 'acd_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
		</td>
		<td style="width:35%; cursor:pointer;" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarAcademicos(1,'acd_apepat','ASC');"<cfelse>onclick="fListarAcademicos(1,'acd_apepat','DESC');"</cfif>>
			<span class="Sans9GrNe">NOMBRE </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
		</td>
		<td style="width:5%;"><span class="Sans9GrNe">SEXO</span></td>
		<td style="width:8%;" title="Fecha de nacimiento" ><span class="Sans9GrNe">FEC. NAC.</span></td>
		<td style="width:20%; cursor:pointer;" <cfif #vOrden# IS 'con_descrip' AND #vOrdenDir# IS 'DESC'>onclick="fListarAcademicos(1,'con_descrip','ASC');"<cfelse>onclick="fListarAcademicos(1,'con_descrip','DESC');"</cfif>>
			<span class="Sans9GrNe">CONTRATO </span><cfif #vOrden# IS 'con_descrip'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
		</td>
		<td style="cursor:pointer; width:15%;" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarAcademicos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarAcademicos(1,'cn_siglas','DESC');"</cfif>>
			<span class="Sans9GrNe">CATEGORÍA </span><cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
		</td>
		<cfif #Session.sTipoSistema# IS 'stctic'>
			<td style="width:5%; cursor:pointer;" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarAcademicos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarAcademicos(1,'dep_siglas','DESC');"</cfif>>
				<span class="Sans9GrNe">ENTIDAD </span><cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
		</cfif>
		<td style="width:5%;" ><span class="Sans9GrNe">UBICA.</span></td>
		<td  width="2%" bgcolor="##0066FF" style="cursor:pointer; width:2%;">&nbsp;</td>
	</tr>
	</cfoutput>
	<!-- Datos -->
	<cfoutput query="tbAcademicos" startRow="#StartRow#" maxRows="#MaxRows#">
		<cfif #activo# EQ 1>
			<cfset vIconoDetalle = "/detalle_15.jpg">
			<cfset vTextoTitle = '(ACTIVO)'>
		<cfelse>
			<cfset vIconoDetalle = "/detalle_error_15.jpg">
			<cfset vTextoTitle = '(NO ACTIVO)'>
		</cfif>
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
			<td class="Sans9Gr">#acd_id#</td>
			<td class="Sans9Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</td>
			<td class="Sans9Gr" title="<cfif #acd_sexo# EQ 'F'>Mujer<cfelseif #acd_sexo# EQ 'M'>Hombre</cfif>"><cfif #acd_sexo# EQ 'F'>M<cfelseif #acd_sexo# EQ 'M'>H</cfif></td>
			<td class="Sans9Gr">#LsDateFormat(acd_fecha_nac,'dd/mm/yyyy')#</td>
			<td class="Sans9Gr">#con_descrip#</td>
			<td class="Sans9Gr">#CnSinTiempo(cn_siglas)#</td>
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td class="Sans9Gr">#dep_siglas#</td>
			</cfif>
			<td class="Sans9Gr">#edo_clave#</td>
			<td>
				<a href="#vCarpetaRaizLogicaSistema#/academicos/personal/academico_personal.cfm?vAcadId=#acd_id#&vTipoComando=CONSULTA">
					<img src="#vCarpetaICONO##vIconoDetalle#" style="border:none;" title="#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)# #vTextoTitle#">
				</a>
			</td>
		</tr>
	</cfoutput>
</table>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbAcademicos.RecordCount#">
</cfoutput>