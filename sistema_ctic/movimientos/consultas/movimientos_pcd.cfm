<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/02/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/07/2019 --->

<!--- Lista de asuntos de una sesión --->	
<!--- Registrar la búsqueda --->
<cfif IsDefined('vFt')><cfset Session.MovimientosPcdFiltro.vFt = #vFt#></cfif>
<!---
<cfif IsDefined('vActa')><cfset Session.MovimientosPcdFiltro.vActa = #vActa#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.MovimientosPcdFiltro.vAcadNom = '#vAcadNom#'></cfif>
--->
<cfif IsDefined('vDep')><cfset Session.MovimientosPcdFiltro.vDep = #vDep#></cfif>
<cfif IsDefined('vPagina')><cfset Session.MovimientosPcdFiltro.vPagina = #vPagina#></cfif>
<cfif IsDefined('vRPP')><cfset Session.MovimientosPcdFiltro.vRPP = #vRPP#></cfif>
<cfif IsDefined('vOrden')><cfset Session.MovimientosPcdFiltro.vOrden = '#vOrden#'></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.MovimientosPcdFiltro.vOrdenDir = '#vOrdenDir#'></cfif>
<!--- Parámetros de búsqueda --->
<cfparam name="vFt" default="#Session.MovimientosPcdFiltro.vFt#">
<!---
<cfparam name="vActa" default="#Session.MovimientosPcdFiltro.vActa#">
<cfparam name="vAcadNom" default="#Session.MovimientosPcdFiltro.vAcadNom#">
--->
<cfparam name="vDep" default="#Session.MovimientosPcdFiltro.vDep#">
<cfparam name="vOrden" default="#Session.MovimientosPcdFiltro.vOrden#">
<cfparam name="vOrdenDir" default="#Session.MovimientosPcdFiltro.vOrdenDir#">
<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT DISTINCT
	T1.*, 
	T2.acd_id, T2.acd_apepat, T2.acd_nombres,
	C1.mov_titulo_corto,
	C4.cn_siglas,
	C2.dep_siglas,
	C3.dec_super,
    T3.*,
	C5.parte_romano + '.' + LTRIM(STR(T3.asu_numero)) AS SeccionNumero
	FROM ((((((movimientos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN catalogo_listado AS C5 ON T3.asu_parte = C5.parte_numero)
	WHERE asu_reunion = 'CTIC'
	AND (C3.dec_super = 'AP' OR C3.dec_super = 'NA' OR C3.dec_super = 'CO')    
    AND (T1.mov_clave = 15 OR T1.mov_clave = 16)
	<cfif #vCn# NEQ ''>AND T1.mov_cn_clave = '#vCn#'</cfif>
	<!--- <cfif #vActa# NEQ ''>AND T3.ssn_id = #vActa#</cfif>--->
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
	<cfelseif #vDep# NEQ '0'>
		AND T1.dep_clave LIKE '#Left(vDep,4)#%'
	</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbMovimientos>
<cfset vConsultaFiltro = Session.MovimientosPcdFiltro>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">				
<!--- VER LOS REGISTROS COMO TABLA --->
<table style="width:98%; margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td class="Sans9GrNe" width="10%" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
					ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
			</cfif>
			<td class="Sans9GrNe" width="28%">MOVIMIENTO</td>
			<td class="Sans9GrNe" width="28%" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif> style="cursor:pointer;">
				CATEGORÍA <cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" width="10%">PLAZA</td>
			<td class="Sans9GrNe" width="10%" <cfif #vOrden# IS 'ssn_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'ssn_id','ASC');"<cfelse>onclick="fListarMovimientos(1,'ssn_id','DESC');"</cfif> style="cursor:pointer;">
				SESIÓN <cfif #vOrden# IS 'ssn_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" title="Decisión del CTIC" width="10%" align="center">DEC.</td>
			<td width="2%" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="2%" bgcolor="##0066FF"><!-- Ver detalle --></td>
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
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td><span class="Sans9Gr">#tbMovimientos.dep_siglas#</span></td>
			</cfif>
			<td><span class="Sans9Gr">#Ucase(tbMovimientos.mov_titulo_corto)#</span> <span class="Sans9Vi"><cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif> <cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif></span></td>
			<td><span class="Sans9Gr">#CnSinTiempo(tbMovimientos.cn_siglas)#</span></td>
			<td><span class="Sans9Gr">#mov_plaza#</span></td>
			<td><span class="Sans9Gr">#ssn_id#</span></td>
			<td align="center"><span class="#vFuenteDec#">#tbMovimientos.dec_super#</span></td>
			<td>
				<!--- Documentación digitalizada --->
				<cfset vArchivoPdf =  '0_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
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