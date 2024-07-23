<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 31/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 13/10/2022 --->

<!--- LISTA DE SOLICITUDES EN CAPTURA DE TODAS LAS ENTIDADES DEL SUBISTEMA --->
<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.AsuntosEntidadFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosEntidadFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vDepId')><cfset Session.AsuntosEntidadFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vNumSol')><cfset Session.AsuntosEntidadFiltro.vNumSol = #vNumSol#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosEntidadFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vOrdenDir')><cfset Session.AsuntosEntidadFiltro.vOrdenDir = #vOrdenDir#></cfif>
<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosEntidadFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosEntidadFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.AsuntosEntidadFiltro.vRPP = #vRPP#></cfif>
<!--- Obtener datos de la sesión para los movimientos que inician un día después de ésta --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_clave = 1 AND ssn_id = #Session.sSesion#
</cfquery>
<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_solicitudes_entidades
	WHERE sol_status BETWEEN 4 AND 6 <!--- > 3  Solicitudes en la Entidad --->
	<!--- Filtro por tipo de movimiento --->
	<cfif #Session.AsuntosEntidadFiltro.vFt# NEQ 0>
		AND 
        <cfif #Session.AsuntosEntidadFiltro.vFt# EQ 100>
			(mov_clave <> 40 AND mov_clave <> 41)
        <cfelseif #Session.AsuntosEntidadFiltro.vFt# EQ 101>
			(mov_clave = 40 OR mov_clave = 41)
        <cfelse>
			mov_clave = #Session.AsuntosEntidadFiltro.vFt#
        </cfif>
	</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por número de solicitud --->
	<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.AsuntosEntidadFiltro>
<cfset vConsultaFuncion = "fListarSolicitudes">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Tabla de datos --->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td width="5%" height="18px" title="Número de solicitud" <cfif #vOrden# IS 'sol_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_id','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_id','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">No. </span><cfif #vOrden# IS 'sol_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="8%" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'dep_siglas','ASC');"<cfelse>onclick="fListarSolicitudes(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">ENTIDAD </span><cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="40%" <cfif #vOrden# IS 'acd_apepat' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'acd_apepat','ASC');"<cfelse>onclick="fListarSolicitudes(1,'acd_apepat','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">NOMBRE </span><cfif #vOrden# IS 'acd_apepat'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="32%" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarSolicitudes(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">SOLICITUD </span><cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<td width="11%" title="Fecha de inicio" <cfif #vOrden# IS 'sol_pos14' AND #vOrdenDir# IS 'DESC'>onclick="fListarSolicitudes(1,'sol_pos14','ASC');"<cfelse>onclick="fListarSolicitudes(1,'sol_pos14','DESC');"</cfif> style="cursor:pointer;">
				<span class="Sans9GrNe">FECHA INICIO </span><cfif #vOrden# IS 'sol_pos14'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
			</td>
			<!---<td class="Sans9GrNe">Status</td>--->
			<td width="2%" bgcolor="##FF9933" title="Documentos digitalizados"><!-- Ver PDF --></td>
			<td width="2%" bgcolor="##0066FF" title="Detalle de solicitud"><!-- Ver detalle --></td>
		</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td><span class="Sans9Gr">#tbSolicitudes.sol_id#</span></td>
                <td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
                <td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
                <td><span class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#<cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3><strong> (SIJAC)</strong></cfif></span></td>
                <!--- Fecha de inicio del movimiento --->
                <td class="Sans9Gr">
                    #LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#
    <!---
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
                <!-- PDF -->
                <td>
					<!--- Crea variable de archivo de solicitud --->
					<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
					<cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>			
                    <cfif FileExists(#vArchivoSolicitudPdf#)>
						<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','SOL','3', '#MID(sol_pos1,1,4)#');">
						<!--- 					
						<cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>
						<a href="#vArchivoSolicitudPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
						--->
                    </cfif>
                </td>
                <!-- Botón VER DETALLE -->
                <td>
                    <a href="#tbSolicitudes.mov_ruta#?vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="Detalle de la solicitud"></a>
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

