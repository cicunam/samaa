<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/02/2010 --->
<!--- FECHA ÚLTIMA MOD.: 13/03/2019 --->

<!--- Lista de asuntos de una sesión --->	
<!--- Registrar la búsqueda --->
<cfif IsDefined('vFt')><cfset Session.MovimientosSesionFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vSesionAnio') AND #vTipoSesionAnio# EQ 'S'><cfset Session.MovimientosSesionFiltro.vActa = #vSesionAnio#></cfif>
<cfif IsDefined('vSesionAnio') AND #vTipoSesionAnio# EQ 'A'><cfset Session.MovimientosSesionFiltro.vAnio = #vSesionAnio#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.MovimientosSesionFiltro.vAcadNom = '#vAcadNom#'></cfif>
<cfif IsDefined('vDep')><cfset Session.MovimientosSesionFiltro.vDep = #vDep#></cfif>
<cfif IsDefined('vPagina')><cfset Session.MovimientosSesionFiltro.vPagina = #vPagina#></cfif>
<cfif IsDefined('vRPP')><cfset Session.MovimientosSesionFiltro.vRPP = #vRPP#></cfif>
<cfif IsDefined('vOrden')><cfset Session.MovimientosSesionFiltro.vOrden = '#vOrden#'></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.MovimientosSesionFiltro.vOrdenDir = '#vOrdenDir#'></cfif>

<!--- Parámetros de búsqueda --->
<cfparam name="vFt" default="#Session.MovimientosSesionFiltro.vFt#">
<cfparam name="vActa" default="#Session.MovimientosSesionFiltro.vActa#">
<cfparam name="vAcadNom" default="#Session.MovimientosSesionFiltro.vAcadNom#">
<cfparam name="vDep" default="#Session.MovimientosSesionFiltro.vDep#">
<cfparam name="vOrden" default="#Session.MovimientosSesionFiltro.vOrden#">
<cfparam name="vOrdenDir" default="#Session.MovimientosSesionFiltro.vOrdenDir#">

<!--- Obtener la lista de movimientos por sesión  del SIC (SE CREA CONSULTA EN SERVIDOR 13/03/2019)--->

<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_movimientos_sesion
	WHERE asu_reunion = 'CTIC'
	<cfif #vTipoSesionAnio# EQ 'S'>
		AND ssn_id = #vSesionAnio#
	<cfelseif #vTipoSesionAnio# EQ 'A'>
		AND YEAR(mov_fecha_inicio) = #vSesionAnio#
    </cfif>
	<!--- AND ssn_id = #vActa# --->
	<cfif #vAcadNom# NEQ ''>
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
		<!--- AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'--->
	</cfif>
	<!--- Filtro por tipo de movimiento --->
	<cfif IsDefined('vFt') AND #vFt# NEQ 0>	
		<cfif #vFt# EQ 100>
			AND (mov_clave <> 40 AND mov_clave <> 41)
		<cfelseif #vFt# EQ 101>
			AND (mov_clave = 40 OR mov_clave = 41)
		<cfelse>	
			AND mov_clave = #vFt#
		</cfif>	
	</cfif>
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND dep_clave LIKE '#Left(Session.sIdDep,4)#%'
	<cfelseif #vDep# NEQ '0'>
		AND dep_clave LIKE '#Left(vDep,4)#%'
	</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!---
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT DISTINCT
	T1.mov_id, T1.sol_id, T1.mov_dep_clave, T1.acd_id, T1.mov_clave, T1.mov_numero, T1.mov_fecha_inicio, T1.mov_fecha_final, T1.prog_clave, T1.coa_id, T1.mov_cancelado, T1.mov_modificado,
	T2.acd_id, T2.acd_apepat, T2.acd_nombres,
	C1.mov_titulo_corto,
	C4.cn_siglas,
	C2.dep_siglas,
	C3.dec_super,
	T3.*,
	C5.parte_romano + '.' + LTRIM(STR(T3.asu_numero)) AS SeccionNumero
	FROM ((((((movimientos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id AND T3.asu_reunion = 'CTIC')
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
	LEFT JOIN catalogo_listado AS C5 ON T3.asu_parte = C5.parte_numero)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE asu_reunion = 'CTIC'
	AND T3.ssn_id = #vActa#
	<cfif #vAcadNom# NEQ ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
	<!--- Filtro por tipo de movimiento --->
	<cfif IsDefined('vFt') AND #vFt# NEQ 0>	
		<cfif #vFt# EQ 100>
			AND (T1.mov_clave <> 40 AND T1.mov_clave <> 41)
		<cfelseif #vFt# EQ 101>
			AND (T1.mov_clave = 40 OR T1.mov_clave = 41)
		<cfelse>	
			AND T1.mov_clave = #vFt#
		</cfif>	
	</cfif>
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
	<cfelseif #vDep# NEQ '0'>
		AND T1.dep_clave LIKE '#Left(vDep,4)#%'
	</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
--->
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbMovimientos>
<cfset vConsultaFiltro = Session.MovimientosSesionFiltro>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">				
<!--- VER LOS REGISTROS COMO TABLA --->
<table style="width:800px; margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td class="Sans9GrNe" height="18px" <cfif #vOrden# IS 'asu_parte DESC, asu_numero' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'asu_parte ASC, asu_numero','ASC');"<cfelse>onclick="fListarMovimientos(1,'asu_parte DESC, asu_numero','DESC');"</cfif> style="cursor:pointer;">
				No.
			</td>
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td class="Sans9GrNe" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
					ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
			</cfif>            
			<td class="Sans9GrNe" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'acd_apepat','ASC');"<cfelse>onclick="fListarMovimientos(1,'acd_apepat','DESC');"</cfif> style="cursor:pointer;">
				NOMBRE <cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">
				MOVIMIENTO <cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
            <td class="Sans9GrNe" title="Duración/Número de contrato">D/C</td>
			<td class="Sans9GrNe" title="Fecha de inicio" <cfif #vOrden# IS 'mov_fecha_inicio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_inicio','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_inicio','DESC');"</cfif> style="cursor:pointer;">
				F. INICIO <cfif #vOrden# IS 'mov_fecha_inicio'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif> style="cursor:pointer;">
				CATEGORÍA <cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" title="Decisión del CTIC" align="center">DEC.</td>
			<td width="15" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="15" bgcolor="##0066FF"><!-- Ver detalle --></td>
		</tr>
	</cfoutput>
	<!-- Datos -->
	<cfoutput query="tbMovimientos" startrow="#StartRow#" maxrows="#MaxRows#">
		<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA DECISIÓN --->
		<cfif #dec_super# IS 'NA'>
            <cfset vFuenteDec = 'Sans9ViNe'>
        <cfelseif #dec_super# IS 'OB'>
            <cfset vFuenteDec = 'Sans9NaNe'>
        <cfelse>
            <cfset vFuenteDec = 'Sans9GrNe'>
        </cfif>
        
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor=''">
			<td><span class="Sans9Gr">#SeccionNumero#</span></td>
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td><span class="Sans9Gr">#tbMovimientos.dep_siglas#</span></td>
			</cfif>
			<td><span class="Sans9Gr"><cfif #tbMovimientos.acd_nombres# IS NOT ''>#tbMovimientos.acd_apepat#, #PrimeraPalabra(tbMovimientos.acd_nombres)#</cfif></span></td>
			<td>
				<span class="Sans9Gr">#Ucase(tbMovimientos.mov_titulo_corto)#</span>
                <span class="Sans9Vi">
					<strong>
					<cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif>
					<cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif>
					<cfif #tbMovimientos.prog_clave# IS 3> (SIJAC)</cfif>
					</strong>
				</span>
			</td>
            <td><cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 25>#tbMovimientos.mov_numero#</cfif><cfif (#tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41) AND (#mov_fecha_inicio# NEQ '' AND #mov_fecha_final# NEQ '')>#DateDiff('d',mov_fecha_inicio, mov_fecha_final) + 1#</cfif></td>
			<td><span class="Sans9Gr">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</span></td>
			<td><span class="Sans9Gr"><cfif #mov_clave# NEQ 38 AND #mov_clave# NEQ 39>#CnSinTiempo(tbMovimientos.cn_siglas_nom)#</cfif></span></td>
			<td align="center"><span class="#vFuenteDec#">#tbMovimientos.dec_super#</span></td>
			<td>
				<!--- Documentación digitalizada --->
				<cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
				<cfset vArchivoMovPdf = #vCarpetaAcademicos# & '\' & #vArchivoPdf#>			
				<!--- <cfset vArchivoMovPdfWeb = #vWebAcademicos# & '/' & #vArchivoPdf#> --->
				<cfif FileExists(#vArchivoMovPdf#)>
					<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','MOV','', '');">
					<!---
					<a href="#vArchivoMovPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
					--->
				</cfif>
			</td>
			<td><a href="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento.cfm?vIdAcad=#tbMovimientos.acd_id#&vIdMov=#tbMovimientos.mov_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>
		</tr>
	</cfoutput>
</table>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">	
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbMovimientos.RecordCount#">
</cfoutput>