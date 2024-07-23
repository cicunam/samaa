<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 21/10/2009 --->
<!--- LISTA DE SOLICITUDES EN CAPTURA --->
<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.AsuntosSolicitudFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosSolicitudFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vNumSol')><cfset Session.AsuntosSolicitudFiltro.vNumSol = #vNumSol#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosSolicitudFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.AsuntosSolicitudFiltro.vOrdenDir = #vOrdenDir#></cfif>
<cfif IsDefined('vStatus')><cfset Session.AsuntosSolicitudFiltro.vStatus = #vStatus#></cfif>

<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosSolicitudFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosSolicitudFiltro.vPagina#>
</cfif>

<!--- Obtener datos de la sesión para los movimientos que inician un día después de ésta --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 1 AND ssn_id = #Session.sSesion#
</cfquery>

<!--- Obtener la lista de solicitudes de la entidad --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((movimientos_solicitud 
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id) 
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE sol_pos1 = '#Session.sIdDep#'
	AND ISNULL(sol_retirada,0) = 0
	<!--- Filtro por tipo de movimiento --->
	<cfif #Session.AsuntosSolicitudFiltro.vFt# NEQ 0>
		AND 
        <cfif #Session.AsuntosSolicitudFiltro.vFt# EQ 100>
			(movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41)
        <cfelseif #Session.AsuntosSolicitudFiltro.vFt# EQ 101>
			(movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)
        <cfelse>
			movimientos_solicitud.mov_clave = #Session.AsuntosSolicitudFiltro.vFt#
        </cfif>
	</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por número de solicitud --->
	<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
	<!--- Filtro por status de la solicitud --->
	<cfif #vStatus# IS NOT ''>
    	AND (
		<cfset vActivaOr = FALSE>
		<cfif Find('C','#vStatus#')>
			<cfif vActivaOr IS TRUE> OR </cfif>
				(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 0)
			<cfset vActivaOr = TRUE>
		</cfif>	
		<cfif Find('D','#vStatus#')>
			<cfif vActivaOr IS TRUE> OR </cfif>
				(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 1)
			<cfset vActivaOr = TRUE>	
		</cfif>
		<cfif Find('E','#vStatus#')>
			<cfif vActivaOr IS TRUE> OR </cfif>
				movimientos_solicitud.sol_status = 3
			<cfset vActivaOr = TRUE>
		</cfif>
		<cfif Find('P','#vStatus#')>
			<cfif vActivaOr IS TRUE> OR </cfif>
				(movimientos_solicitud.sol_status = 2 OR movimientos_solicitud.sol_status = 1)
			<cfset vActivaOr = TRUE>		
		</cfif>
		<cfif Find('R','#vStatus#')>
			<cfif vActivaOr IS TRUE> OR </cfif>
				movimientos_solicitud.sol_status = 0
			<cfset vActivaOr = TRUE>		
		</cfif>
		)
	<cfelse>
		AND 1=0	
	</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif>
	<cfif #vOrdenDir# IS NOT ''>#vOrdenDir# </cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.AsuntosSolicitudFiltro>
<cfinclude template="../../../includes//paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="../../../includes/paginacion.cfm">
<!-- Seleccionar todas las solicitudes -->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<a style="margin: 10px 0px 10px 15px; cursor:pointer;" onclick="fMarcarTodas(true);">
	<span class="Sans9Gr">Marcar todas</span>
	</a>
	<span class="Sans9Gr">
		/ 
	</span>
	<a style="margin: 10px 0px 10px 0px; cursor:pointer;" onclick="fMarcarTodas(false);">
	<span class="Sans9Gr">
		Desmarcar todas
	</span>
	</a>
</cfif>
<!--- TABLA --->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:800px; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td height="15px"><!-- Selector de registro --></td>
			<td class="Sans9GrNe" title="Número de solicitud" <cfif #vOrden# IS 'sol_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_id','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_id','DESC');"</cfif> style="cursor:pointer;">
				No. <cfif #vOrden# IS 'sol_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'> onclick="fListarSolicitudes(1,'acd_apepat','ASC');" <cfelse> onclick="fListarSolicitudes(1,'acd_apepat','DESC');" </cfif> style="cursor:pointer;">
				NOMBRE <cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarSolicitudes(1,'mov_titulo_corto','DESC');"</cfif>	style="cursor:pointer;">
				SOLICITUD <cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" title="Fecha de inicio" <cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','ASC');"<cfelse>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','DESC');"</cfif>	style="cursor:pointer;">
				F. INICIO <cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe">SITUACIÓN</td>
			<td width="15" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="15" bgcolor="##0066FF"><!-- Ver detalle --></td>
		</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 	
		<!--- Crea variable de archivo de solicitud --->
		<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
		<cfif #tbSolicitudes.sol_status# GTE 3>
			<cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>
			<cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>
		<cfelse>
			<cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>
			<cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>
	    </cfif>
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
			<td><input type="checkbox" style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#tbSolicitudes.sol_id#,4,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosSolicitudFiltro.vMarcadas,tbSolicitudes.sol_id)# IS TRUE>checked</cfif> <cfif NOT (#tbSolicitudes.sol_status# IS 4 OR (#tbSolicitudes.sol_status# IS 3 AND (#tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41)))>disabled</cfif>></td>
			<td class="Sans9Gr">#tbSolicitudes.sol_id#</td>
			<td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</td>
			<td class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</td>
			<!--- Fecha de inicio del movimiento --->
			<td class="Sans9Gr">
				<cfif #tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19 OR #tbSolicitudes.mov_clave# IS 28><!--- Si es un movimiento que inicia un día un día despues de la reunión de pleno --->
					<cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
						#LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha),"dd/mm/yyyy")#
					<cfelse>		
						 #LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha_m),"dd/mm/yyyy")#
					</cfif>	 
				<cfelseif #tbSolicitudes.sol_pos14# IS NOT ''><!--- Si el campo no está vacío --->
					#LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#
				</cfif>
			</td>
			<td>
				<cfif #tbSolicitudes.sol_status# IS 4>
					<cfif #tbSolicitudes.sol_devuelta# IS 1>
						<span class="Sans9Vi" style="text-decoration: blink;">DEVUELTA</span>
					<cfelse>
						<span class="Sans9Gr">EN CAPTURA</span>
					</cfif>
				<cfelseif #tbSolicitudes.sol_status# IS 3>
					<span class="Sans9Gr">ENVIADA</span>
				<cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>
					<span class="Sans9Gr">EN PROCESO</span>
				<cfelseif #tbSolicitudes.sol_status# IS 0>
					<span class="Sans9GrNe">RESUELTO</span>
				</cfif>
			</td>
			<!-- Iconos -->
			<td>
				<cfif (#tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41) AND #tbSolicitudes.sol_fecha_firma# IS NOT ''>
					<img src="#vCarpetaICONO#/imp_15.jpg" title="La solicitud ya fue impresa." class="icono">				
				<cfelseif FileExists(#vArchivoSolicitudPdf#)>
					<a href="#vArchivoSolicitudPdfWeb#" target="_blank"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" title="Ver documentos en PDF" class="icono"></a>
				</cfif>
			</td>
			<td>
				<a href="#tbSolicitudes.mov_ruta#?vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA"><cfif #tbSolicitudes.sol_devuelta# EQ 1 OR #tbSolicitudes.sol_devuelve_edita# EQ 1 OR #tbSolicitudes.sol_devuelve_archivo# EQ 1><img src="#vCarpetaICONO#/detalle_error_15.jpg" style="border:none;" title="Devuelta: #tbSolicitudes.sol_devuelta_texto#" /><cfelse><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="Detalle del asunto" /></cfif></a>
			</td>
		</tr>
		</cfoutput>
	</table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="../../../includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
<input id="vPagAct" type="hidden" value="#PageNum#">
<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>
