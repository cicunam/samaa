<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/10/2009 --->
<!--- FECHA ÚLTIMA MOD: 11/01/2024 --->
<!--- LISTA DE SOLICITUDES POR CADA ENTIDAD --->

<cfif #CGI.SERVER_PORT# EQ '31221'>
    <cfoutput>DEP_CLAVE = #Session.sIdDep#; USUARIO NIVEL = #Session.sUsuarioNivel#</cfoutput>
</cfif>   

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
	SELECT * 
    FROM ((movimientos_solicitud 
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id) 
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE ISNULL(sol_retirada,0) = 0
    <cfif #Session.sUsuarioNivel# EQ 26>
        AND sol_pos1 = '030101' 
        <cfif #Session.sIdDep# EQ '034201'>
            AND sol_pos1_u = '02'
        <cfelseif #Session.sIdDep# EQ '034301'>
            AND sol_pos1_u = '03'
        <cfelseif #Session.sIdDep# EQ '034401'>
            AND sol_pos1_u = '04'
        <cfelseif #Session.sIdDep# EQ '030116'>
            AND sol_pos1_u = '06'
        <cfelseif #Session.sIdDep# EQ '034501'>
            AND sol_pos1_u = '07'
        <cfelseif #Session.sIdDep# EQ '034601'>
            AND sol_pos1_u = '08'                
        </cfif>
    <cfelse>
	    AND sol_pos1 = '#Session.sIdDep#'
    </cfif>    
<!---    
    <cfswitch expression="#Session.sIdDep#">
        <cfcase value="034201;034301;034401;034501;034502;034601" delimiters=";">
            sol_pos1 = '030101'
            AND sol_pos1_u = '02'            
        </cfcase>            
        <cfdefaultcase>
            sol_pos1 = '#Session.sIdDep#'
        </cfdefaultcase> 
    </cfswitch>
--->

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
<cfinclude template="#vCarpetaRaizLogica#/includes//paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
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
	<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
		<tr valign="middle" w bgcolor="##CCCCCC">
			<td width="3%" height="18px"><!-- Selector de registro --></td>
			<td width="7%" title="Número de solicitud" <cfif #vOrden# IS 'sol_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_id','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_id','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">No. </span><cfif #vOrden# IS 'sol_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="35%" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'> onclick="fListarSolicitudes(1,'acd_apepat','ASC');" <cfelse> onclick="fListarSolicitudes(1,'acd_apepat','DESC');" </cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">NOMBRE </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="25%" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarSolicitudes(1,'mov_titulo_corto','DESC');"</cfif>	style="cursor:pointer;">
				<span class="Sans9GrNe">SOLICITUD </span><cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="10%" title="Fecha de inicio" <cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','ASC');"<cfelse>onclick="fListarSolicitudes(1,'movimientos_solicitud.cap_fecha_crea','DESC');"</cfif>	style="cursor:pointer;">
				<span class="Sans9GrNe">FECHA INICIO </span><cfif #vOrden# IS 'movimientos_solicitud.cap_fecha_crea'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="10%"><span class="Sans9GrNe">SITUACIÓN</span></td>
			<td width="6%" title="Asignada a la Sesión"><span class="Sans9GrNe">SESIÓN</span></td>
			<td width="2%" bgcolor="##FF9933"><!-- Ver PDF --></td>
			<td width="2%" bgcolor="##0066FF"><!-- Ver detalle --></td>
		</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 	
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td><input type="checkbox" style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#tbSolicitudes.sol_id#,4,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosSolicitudFiltro.vMarcadas,tbSolicitudes.sol_id)# IS TRUE>checked</cfif> <cfif NOT (#tbSolicitudes.sol_status# IS 4 OR (#tbSolicitudes.sol_status# IS 3 AND (#tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41)))>disabled</cfif>></td>
                <td class="Sans9Gr">#tbSolicitudes.sol_id#</td>
                <td class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</td>
                <td class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#<cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3><strong> (SIJAC)</strong></cfif></td>
                <!--- Fecha de inicio del movimiento --->
                <td class="Sans9Gr">
                    #LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#                    
<!---  SE ELIMINÓ EL 15/08/2023                  
                    <cfif #tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19 OR #tbSolicitudes.mov_clave# IS 28><!--- Si es un movimiento que inicia un día un día despues de la reunión de pleno --->
                        <cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
                            #LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha),"dd/mm/yyyy")#
                        <cfelse>		
                             #LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha_m),"dd/mm/yyyy")#
                        </cfif>	 
                    <cfelseif #tbSolicitudes.sol_pos14# IS NOT ''><!--- Si el campo no está vacío --->
                        #LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#
                    </cfif>
--->
                </td>
                <td>
                    <cfif #sol_status# IS 4>
                        <span class="Sans9Gr">En captura</span>
                    <cfelseif #sol_status# IS 3>
                        <span class="Sans9Gr">Enviada</span>
                    <cfelseif #sol_status# LTE 2>
                        <cfif #sol_devuelta# IS 1>
                            <span class="Sans9Vi" style="text-decoration: blink; cursor: pointer;" title="#sol_devuelta_texto#">DEVUELTA</span>
                        <cfelseif #sol_devuelve_edita# IS 1 OR #sol_devuelve_archivo# IS 1>
                            <span class="Sans9Vi" style="text-decoration: blink; cursor: pointer;" title="#sol_devuelta_texto#">CORRECCIONES</span>
                        <cfelse>
                            <span class="Sans9Gr">En proceso</span>
                        </cfif>
                    </cfif>
 <!---                            
                    <cfelseif #tbSolicitudes.sol_status# IS 2>
                        <span class="Sans9Gr">EN LA CAAA</span>
                    <cfelseif #tbSolicitudes.sol_status# EQ 1 OR #tbSolicitudes.sol_status# EQ 0>
                        <span class="Sans9Gr">PLENO DEL CTIC</span>
                    <cfelseif #tbSolicitudes.sol_status# IS 0>
                        <span class="Sans9GrNe">RESUELTO</span>
                    <cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>
                        <span class="Sans9Gr">EN PROCESO</span>
--->
                </td>
                <td></td>
                <!-- Iconos -->
                <td>
                    <cfif (#tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41) AND #tbSolicitudes.sol_fecha_firma# IS NOT ''>
                        <img src="#vCarpetaICONO#/imp_15.jpg" title="La solicitud ya fue impresa." class="icono">				
                    <cfelse>
						<!--- Crea variable de archivo de solicitud --->
                        <cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
                        <cfif #tbSolicitudes.sol_status# GTE 3>
                            <cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>
                            <!--- <cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>--->
						<cfelse>
							<cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>
                            <!--- <cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#> --->
						</cfif>
						<cfif FileExists(#vArchivoSolicitudPdf#)>
							<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','SOL','#sol_status#', '#MID(sol_pos1,1,4)#');">
							<!---
							<a href="#vArchivoSolicitudPdfWeb#" target="_blank"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" title="Ver documentos en PDF" class="icono"></a>
							--->
						</cfif>
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
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
<input id="vPagAct" type="hidden" value="#PageNum#">
<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>
