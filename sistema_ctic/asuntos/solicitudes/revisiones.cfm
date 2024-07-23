<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 21/10/2009 --->
<!--- LISTA DE SOLICITUDES RECIBIDAS POR LA STCTIC --->
<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.AsuntosRevisionFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosRevisionFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vDepId')><cfset Session.AsuntosRevisionFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vNumSol')><cfset Session.AsuntosRevisionFiltro.vNumSol = #vNumSol#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosRevisionFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.AsuntosRevisionFiltro.vOrdenDir = #vOrdenDir#></cfif>
<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosRevisionFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosRevisionFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.AsuntosRevisionFiltro.vRPP = #vRPP#></cfif>
<!--- Obtener datos de la sesión para los movimientos que inician un día después de ésta --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_clave = 1 
    AND ssn_id = #Session.sSesion#
</cfquery>
<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((movimientos_solicitud AS T1
	LEFT JOIN academicos AS T2 ON T1.sol_pos2 = T2.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE sol_status = 3 <!--- Solicitudes enviadas --->
	AND ISNULL(sol_retirada,0) = 0
	<!--- Filtro por tipo de movimiento --->
	<cfif #Session.AsuntosRevisionFiltro.vFt# NEQ 0>
		AND 
        <cfif #Session.AsuntosRevisionFiltro.vFt# EQ 100>
			(T1.mov_clave <> 40 AND T1.mov_clave <> 41)
        <cfelseif #Session.AsuntosRevisionFiltro.vFt# EQ 101>
			(T1.mov_clave = 40 OR T1.mov_clave = 41)
        <cfelse>
			T1.mov_clave = #Session.AsuntosRevisionFiltro.vFt#
        </cfif>
	</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por dependencia --->
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND sol_pos1 = '#Session.sIdDep#'
	<cfelse>
		<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	</cfif>
	<!--- Filtro por número de solicitud --->
	<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.AsuntosRevisionFiltro>
<cfset vConsultaFuncion = "fListarSolicitudes">
<cfinclude template="../../../includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="../../../includes/paginacion.cfm">
<!--- Seleccionar todas las solicitudes --->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<a style="margin: 10px 0px 10px 15px; cursor:pointer;" onclick="fMarcarTodas(true);"><span class="Sans9Gr">Marcar todos</span></a><span class="Sans9Gr">/</span>
	<a style="margin: 10px 0px 10px 0px; cursor:pointer;" onclick="fMarcarTodas(false);"><span class="Sans9Gr">Desmarcar todos</span></a>
</cfif>
<!--- Tabla de datos --->
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
			<td class="Sans9GrNe" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'dep_siglas','ASC');"<cfelse>onclick="fListarSolicitudes(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
				ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'acd_apepat','ASC');"<cfelse>onclick="fListarSolicitudes(1,'acd_apepat','DESC');"</cfif> style="cursor:pointer;">
				NOMBRE <cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarSolicitudes(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">
				ASUNTO <cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td class="Sans9GrNe" title="Fecha de inicio" <cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','ASC');"<cfelse>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','DESC');"</cfif> style="cursor:pointer;">
				F. INICIO <cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<!---<td class="Sans9GrNe">Status</td>--->
			<td width="15" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="15" bgcolor="##0066FF"><!-- Ver detalle --></td>
		</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
		<!--- Crea variable de archivo de solicitud --->
		<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
		<cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>			
		<cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>

		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
			<td><input type="checkbox" style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#tbSolicitudes.sol_id#,3,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosRevisionFiltro.vMarcadas,tbSolicitudes.sol_id)# IS TRUE>checked</cfif>></td>
			<td><span class="Sans9Gr">#tbSolicitudes.sol_id#</span></td>
			<td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
			<td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
			<td><span class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</span></td>
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
			<!---
			<td>
				<span class="Sans9Gr">
					<cfif #tbSolicitudes.sol_status# IS 4>
						<cfif  #tbSolicitudes.sol_devuelta# IS FALSE>
							EN CAPTURA
						<cfelse>
							DEVUELTA
						</cfif>
					<cfelseif #tbSolicitudes.sol_status# IS 3>
						ENVIADA	
					<cfelseif #tbSolicitudes.sol_status# LT 3>
						EN SESI&Oacute;N
					</cfif>
				</span>
			</td>
			--->
			<!-- PDF -->
			<td>
				<cfif FileExists(#vArchivoSolicitudPdf#)>
					<a href="#vArchivoSolicitudPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
				</cfif>
			</td>
			<!-- Botón VER -->
			<td>
				<a href="#tbSolicitudes.mov_ruta#?vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="Detalle de la solicitud"></a>
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
	<input id="vRegRan" type="hidden" value="<cfif tbSolicitudes.RecordCount GT 0>#StartRow# al #EndRow#<cfelse>0</cfif>">
	<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>

