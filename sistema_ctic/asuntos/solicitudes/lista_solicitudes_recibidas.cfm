<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 13/10/2022 --->

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
	SELECT * FROM consulta_solicitudes_recibidas
	WHERE sol_status = 3 <!--- Solicitudes enviadas --->
	AND ISNULL(sol_retirada,0) = 0
	<!--- Filtro por tipo de movimiento --->
	<cfif #Session.AsuntosRevisionFiltro.vFt# NEQ 0>
		AND 
        <cfif #Session.AsuntosRevisionFiltro.vFt# EQ 100>
			(mov_clave <> 40 AND mov_clave <> 41)
        <cfelseif #Session.AsuntosRevisionFiltro.vFt# EQ 101>
			(mov_clave = 40 OR mov_clave = 41)
        <cfelse>
			mov_clave = #Session.AsuntosRevisionFiltro.vFt#
        </cfif>
	</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por entidad --->
	<cfif #Session.sTipoSistema# IS 'stctic'>
		<cfif (isDefined('vDepId') AND #vDepId# IS NOT '')>
			AND sol_pos1 = '#vDepId#'
		<cfelseif #Session.sUsuarioNivel# EQ 20>
			AND (sol_pos1 = '030101' OR dep_tipo = 'UPE')
		</cfif>
	<cfelseif #Session.sTipoSistema# IS 'sic'>
		AND sol_pos1 = '#Session.sIdDep#'
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
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Seleccionar todas las solicitudes --->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<a style="margin: 10px 0px 10px 15px; cursor:pointer;" onclick="fMarcarTodas(true);"><span class="Sans9Gr">Marcar todos</span></a><span class="Sans9Gr">/</span>
	<a style="margin: 10px 0px 10px 0px; cursor:pointer;" onclick="fMarcarTodas(false);"><span class="Sans9Gr">Desmarcar todos</span></a>
</cfif>
<!--- Tabla de datos --->
<cfif #tbSolicitudes.RecordCount# GT 0>

	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td width="3%" height="18px"><!-- Selector de registro --></td>
			<td width="5%" title="Número de solicitud" <cfif #vOrden# IS 'sol_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_id','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_id','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">No. </span><cfif #vOrden# IS 'sol_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="8%" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'dep_siglas','ASC');"<cfelse>onclick="fListarSolicitudes(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">ENTIDAD </span><cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="40%" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'acd_apepat','ASC');"<cfelse>onclick="fListarSolicitudes(1,'acd_apepat','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">NOMBRE </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="30%" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarSolicitudes(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">ASUNTO </span><cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="10%" title="Fecha de inicio" <cfif #vOrden# IS 'sol_pos14' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_pos14','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_pos14','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">FECHA INICIO </span><cfif #vOrden# IS 'sol_pos14'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<!---<td class="Sans9GrNe">Status</td>--->
			<td width="2%" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="2%" bgcolor="##0066FF"><!-- Ver detalle --></td>
		</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#">
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td>
                    <!--- LOS DOCUMENTOS NO IMPRESOS, NO SE PRODRÁN ASIGNAR A UNA SESIÓN (03/02/2022) --->
                    <cfif ((#mov_clave# EQ 40 OR #mov_clave# EQ 41) AND #sol_fecha_firma# NEQ '') OR ((#mov_clave# NEQ 40 OR #mov_clave# EQ 41) AND  #acd_id_firma# NEQ '' AND #sol_fecha_firma# NEQ '')>
                        <input type="checkbox" style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#sol_id#,3,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosRevisionFiltro.vMarcadas,sol_id)# IS TRUE>checked</cfif>>
                    </cfif>
                </td>
                <td><span class="Sans9Gr">#sol_id#</span></td>
                <td><span class="Sans9Gr">#dep_siglas#</span></td>
                <td><span class="Sans9Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(PrimeraPalabra(acd_nombres))#</span></td>
                <td><span class="Sans9Gr">#Ucase(mov_titulo_corto)#<cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3><strong> (SIJAC)</strong></cfif></span></td>
                <!--- Fecha de inicio del movimiento --->
                <td class="Sans9Gr">
					#LsDateFormat(sol_pos14,"dd/mm/yyyy")#
                </td>
                <!-- PDF -->
                <td>
					<!--- Crea variable de archivo de solicitud --->
                    <cfset vArchivoPdf = #sol_pos2# & '_' & #sol_id# & '.pdf'>
                    <cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(sol_pos1,1,4)# & '\' & #vArchivoPdf#>			
                    <cfif FileExists(#vArchivoSolicitudPdf#)>
						<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','SOL','3', '#MID(sol_pos1,1,4)#');">
                    </cfif>
                </td>
                <!-- Botón VER DETALLE -->
                <td>
                    <a href="#mov_ruta#?vIdAcad=#sol_pos2#&vFt=#mov_clave#&vIdSol=#sol_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="Detalle de la solicitud"></a>
                </td>
            </tr>
		</cfoutput>
	</table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="<cfif tbSolicitudes.RecordCount GT 0>#StartRow# al #EndRow#<cfelse>0</cfif>">
	<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>

