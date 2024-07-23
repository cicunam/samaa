<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/02/2010 --->
<!--- FECHA ÚLTIMA MOD.: 11/01/2024 --->

<!--- Lista de asuntos de una sesión --->	
<!--- Registrar la búsqueda --->
<cfif IsDefined('vFt')><cfset Session.MovimientosVenceFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.MovimientosVenceFiltro.vAcadNom = '#vAcadNom#'></cfif>
<cfif IsDefined('vCn')><cfset Session.MovimientosVenceFiltro.vCn = #vCn#></cfif>
<cfif IsDefined('vDep')><cfset Session.MovimientosVenceFiltro.vDep = '#vDep#'></cfif>
<cfif IsDefined('vOrden')><cfset Session.MovimientosVenceFiltro.vOrden = '#vOrden#'></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.MovimientosVenceFiltro.vOrdenDir = '#vOrdenDir#'></cfif>
<cfif IsDefined('vPagina')><cfset Session.MovimientosVenceFiltro.vPagina = '#vPagina#'></cfif>
<cfif IsDefined('vRPP')><cfset Session.MovimientosVenceFiltro.vRPP = #vRPP#></cfif>

<!--- Parámetros de búsqueda --->
<cfparam name="vFt" default="#Session.MovimientosVenceFiltro.vFt#">
<cfparam name="vAcadNom" default="#Session.MovimientosVenceFiltro.vAcadNom#">
<cfparam name="vCn" default="#Session.MovimientosVenceFiltro.vCn#">
<cfparam name="vDep" default="#Session.MovimientosVenceFiltro.vDep#">
<cfparam name="vOrden" default="#Session.MovimientosVenceFiltro.vOrden#">
<cfparam name="vOrdenDir" default="#Session.MovimientosVenceFiltro.vOrdenDir#">
    
<!--- Obtener la lista de movimientos que vencen en los tres meses siguientes --->
<cfset vFechaActual = LsDateFormat(Now(),"dd/mm/yyyy")>
<cfset vFechaPosterior = LsDateFormat(DateAdd("m", 3, Now()),"dd/mm/yyyy")>
<cfquery name="tbMovimientosVence" datasource="#vOrigenDatosSAMAA#">
	SELECT DISTINCT 
    T1.mov_id, T1.sol_id, T1.mov_dep_clave, T1.acd_id, T1.mov_clave, T1.mov_numero, T1.mov_fecha_inicio, T1.mov_fecha_final, T1.coa_id, T1.mov_cancelado, T1.mov_modificado,
	T2.acd_id, T2.acd_apepat, T2.acd_nombres,
	C1.mov_titulo_corto,
	C4.cn_siglas,
	C2.dep_siglas,
	C3.dec_super,
    T3.*
    FROM (((((movimientos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN movimientos_asunto AS T3 ON T3.sol_id = T1.sol_id AND T3.asu_reunion = 'CTIC')
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE asu_reunion = 'CTIC'
	AND (T2.con_clave = 2 OR T2.con_clave = 3 OR T2.con_clave = 6)
	AND (T1.mov_clave = 5 OR T1.mov_clave = 6 OR T1.mov_clave = 25 OR T1.mov_clave = 38) 
	AND (T1.mov_fecha_final > '#vFechaActual#' AND T1.mov_fecha_final < '#vFechaPosterior#')
	AND C3.dec_super = 'AP'
	AND T1.mov_cancelado IS NULL
	<cfif #vAcadNom# NEQ ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
	<cfif #vCn# NEQ ''>AND T1.mov_cn_clave = '#vCn#'</cfif>
	<cfif #vFt# NEQ 0>AND T1.mov_clave = #vFt#</cfif>
	<cfif #Session.sTipoSistema# IS 'sic'>
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
		    AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
        </cfif>
	<cfelseif #vDep# NEQ '0'>
		AND T1.dep_clave LIKE '#Left(vDep,4)#%'
	</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbMovimientosVence>
<cfset vConsultaFiltro = Session.MovimientosVenceFiltro>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">				
<!--- VER LOS REGISTROS COMO TABLA --->
<table style="width:800px; margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<cfif #Session.sTipoSistema# IS 'stctic'>
				<td <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
					<span class="Sans9GrNe">ENTIDAD </span><cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
			</cfif>
			<td height="18px" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'acd_apepat','ASC');"<cfelse>onclick="fListarMovimientos(1,'acd_apepat','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">NOMBRE DEL ACADÉMICO </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">MOVIMIENTO </span><cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td title="Fecha de término" <cfif #vOrden# IS 'mov_fecha_final' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_final','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_final','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">F. TÉRMINO </span><cfif #vOrden# IS 'mov_fecha_final'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">CATEGORÍA </span><cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td align="center" title="Solicitud en trámite"><span class="Sans9GrNe">S. TRÁMITE</span></td>
			<td title="Número de contratos" <cfif #vOrden# IS 'mov_numero' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_numero','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_numero','DESC');"</cfif> style="cursor:pointer;" align="center">
				<span class="Sans9GrNe">N.C. </span><cfif #vOrden# IS 'mov_numero'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="2%" bgcolor="##0066FF"></td>
		</tr>
	</cfoutput>
	<!-- Datos -->
	<cfoutput query="tbMovimientosVence" startrow="#StartRow#" maxrows="#MaxRows#">
		<!--- IDENTIFICA SI YA SE ENCUENTRAN SOLICITUDES EN TRÁMITE --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT sol_id FROM movimientos_solicitud
            WHERE sol_pos2 = #acd_id#
			<cfif #mov_clave# EQ 5>
	            AND mov_clave = 25
			<cfelse>
				<cfif #mov_clave# EQ 6>
		            AND (mov_clave = 5 OR mov_clave = 6)
				<cfelse>
		            AND mov_clave = #mov_clave#
				</cfif>
			</cfif>
		</cfquery>

		<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
			SELECT sol_id FROM movimientos
            WHERE acd_id = #acd_id#
			<cfif #mov_clave# EQ 5>
	            AND mov_clave = 25
			<cfelse>
				<cfif #mov_clave# EQ 6>
		            AND (mov_clave = 5 OR mov_clave = 6)
				<cfelse>
		            AND mov_clave = #mov_clave#
				</cfif>
			</cfif>
            AND mov_fecha_inicio > '#LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#'
		</cfquery>

		<cfif #tbMovimientos.recordcount# EQ 0>
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor=''">
                <cfif #Session.sTipoSistema# IS 'stctic'>
                    <td class="Sans9Gr">#dep_siglas#</td>
                </cfif>
                <td class="Sans9Gr"><cfif #acd_nombres# IS NOT ''>#acd_apepat#, #PrimeraPalabra(acd_nombres)#</cfif></td>
                <td class="Sans9Gr">#Ucase(mov_titulo_corto)# <span class="Sans9Vi"><cfif #mov_cancelado# IS 1>(CANCELADO)</cfif></span></td>
                <td class="Sans9Gr">#LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#</td>
                <td class="Sans9Gr"><cfif #mov_clave# NEQ "38" AND #mov_clave# NEQ "39">#CnSinTiempo(cn_siglas)#<cfelse></cfif></td>
                <td class="Sans9Gr" align="center" title="Solicitud: #tbSolicitudes.sol_id#">
                    <cfif #tbSolicitudes.recordcount# GT 0><img src="#vCarpetaICONO#/palomita.jpg" width="15px" border="0" style="cursor:pointer;" onclick="fSeleccionaSolicitud('#acd_id#');" /></cfif>
                </td>
                <td class="Sans9Gr" align="center">#mov_numero#</td>
                <!---<td><a href="detalle/movimiento.cfm?vIdMov=#mov_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>--->
                <td><a href="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento.cfm?vIdAcad=#acd_id#&vIdMov=#mov_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>
            </tr>
		</cfif>
	</cfoutput>
</table>
<!--- Controles de paginación --->
<cfinclude template="../../../includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbMovimientosVence.RecordCount#">
</cfoutput>