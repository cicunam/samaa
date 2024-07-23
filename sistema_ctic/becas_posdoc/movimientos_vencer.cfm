<!--- CREADO: ARAM PICHARDO --->
<!--- EDITÓ: ARAM PICHARDO --->
<!--- FECHA: 19/03/2014 --->
<!--- Lista de becarios posdoctorales que vence su primera beca --->
<!--- Registrar la búsqueda --->
<cfif IsDefined('vAcadNom')><cfset Session.BecasVenceFiltro.vAcadNom = '#vAcadNom#'></cfif>
<cfif IsDefined('vDep')><cfset Session.BecasVenceFiltro.vDep = '#vDep#'></cfif>
<cfif IsDefined('vOrden')><cfset Session.BecasVenceFiltro.vOrden = '#vOrden#'></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.BecasVenceFiltro.vOrdenDir = '#vOrdenDir#'></cfif>
<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.BecasVenceFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.BecasVenceFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.BecasVenceFiltro.vRPP = #vRPP#></cfif>

<!--- Parámetros de búsqueda --->
<cfparam name="vAcadNom" default="#Session.BecasVenceFiltro.vAcadNom#">
<cfparam name="vDep" default="#Session.BecasVenceFiltro.vDep#">
<cfparam name="vOrden" default="#Session.BecasVenceFiltro.vOrden#">
<cfparam name="vOrdenDir" default="#Session.BecasVenceFiltro.vOrdenDir#">
<!--- Obtener la lista de movimientos que vencen en los tres meses siguientes --->
<cfset vFechaActual = LsDateFormat(Now(),"dd/mm/yyyy")>
<cfset vFechaPosterior = LsDateFormat(DateAdd("m", 4, Now()),"dd/mm/yyyy")>
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * 
	FROM (((((movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id  AND T2.ssn_id = (SELECT MAX(ssn_id) FROM movimientos_asunto WHERE sol_id = T1.sol_id))<!--- IMPORTANTE: Obtener el registro más reciente de la tabla de asuntos --->
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave)
	LEFT JOIN catalogo_decision AS C3 ON T2.dec_clave = C3.dec_clave)
	LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave
	WHERE asu_reunion = 'CTIC'
	<!--- AND (T3.con_clave = 2 OR T3.con_clave = 3 OR T3.con_clave = 6) --->
	AND (T1.mov_fecha_final > '#vFechaActual#' AND T1.mov_fecha_final < '#vFechaPosterior#')
	AND C3.dec_super = 'AP'
	AND T1.mov_cancelado IS NULL
    AND T1.mov_clave = 38
	<cfif #vAcadNom# NEQ ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
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
<cfset vConsultaFiltro = Session.BecasVenceFiltro>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">				
<!--- VER LOS REGISTROS COMO TABLA --->
<table style="width:95%; margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td style="cursor:pointer; width:10%;"  <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif>>
					<span class="Sans9GrNe">ENTIDAD </span><cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
			</cfif>        
			<td  style="cursor:pointer; width:35%" height="18px" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'acd_apepat','ASC');"<cfelse>onclick="fListarMovimientos(1,'acd_apepat','DESC');"</cfif>>
				<span class="Sans9GrNe">NOMBRE </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td style="cursor:pointer; width:20%" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif>>
				<span class="Sans9GrNe">MOVIMIENTO </span><cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td style="cursor:pointer; width:15%" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_inicio','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_inicio','DESC');"</cfif>>
				<span class="Sans9GrNe">FECHA INICIO </span><cfif #vOrden# IS 'mov_fecha_inicio'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td style="cursor:pointer; width:15%" <cfif #vOrden# IS 'mov_fecha_final' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_final','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_final','DESC');"</cfif>>
				<span class="Sans9GrNe">FECHA TÉRMINO </span><cfif #vOrden# IS 'mov_fecha_final'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="2%" bgcolor="##0066FF" title="Detalle del movimiento"></td>
		</tr>
	</cfoutput>
	<!-- Datos -->
	<cfoutput query="tbMovimientos" startrow="#StartRow#" maxrows="#MaxRows#">
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor=''">
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td class="Sans9Gr">#tbMovimientos.dep_siglas#</td>
			</cfif>
			<td class="Sans9Gr"><cfif #acd_nombres# IS NOT ''>#acd_apepat#, #PrimeraPalabra(acd_nombres)#</cfif></td>
			<td class="Sans9Gr">#Ucase(tbMovimientos.mov_titulo_corto)# <span class="Sans9Vi"><cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif></span></td>
			<td class="Sans9Gr">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</td>
			<td class="Sans9Gr">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>
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