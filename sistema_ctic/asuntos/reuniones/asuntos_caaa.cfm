<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 21/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 13/10/2022 --->

<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA CAAA --->
<!--- Parámetros --->
<cfparam name="PageNum_tbSolicitudes" default="1">
<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.AsuntosCAAAFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vActa')><cfset Session.AsuntosCAAAFiltro.vActa = #vActa#></cfif>
<cfif IsDefined('vSeccion')><cfset Session.AsuntosCAAAFiltro.vSeccion = #vSeccion#></cfif>
<cfif IsDefined('vDepId')><cfset Session.AsuntosCAAAFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosCAAAFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vNumSol')><cfset Session.AsuntosCAAAFiltro.vNumSol = #vNumSol#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosCAAAFiltro.vOrden = #vOrden#></cfif>
<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosCAAAFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosCAAAFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.AsuntosCAAAFiltro.vRPP = #vRPP#></cfif>

<!--- Agrupación por parte del listado (para dar trato especial a la sección III) --->
<cfquery name="ctListadoOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_listado
	ORDER BY parte_numero
</cfquery>

<!--- Obtener la lista de solicitudes que se encuentran en la CAAA (se creo una consulta eliminando la función UNION ya que alenta la consulta (26/10/2017) --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_solicitudes_caaa
	WHERE ssn_id = #vActa#
    AND ssn_id_post = 0
	<!--- AND dec_clave IS NULL --->
	<cfif #Session.AsuntosCAAAFiltro.vFt# NEQ 0>
		AND mov_clave = #Session.AsuntosCAAAFiltro.vFt#
	</cfif>
	<!--- Filtro por sección --->
	<cfif #vSeccion# IS NOT ''>AND asu_parte = #vSeccion#</cfif>
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por número de solicitud --->
	<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
	ORDER BY 
	asu_parte,
	clase_academico, <!--- Campo clave para ordenar de manera distinata la SECCIÓN 3 --->
	asu_numero,
	dep_orden,
	acd_apepat,
	acd_apemat,
	acd_nombres,
	sol_pos14
</cfquery>

<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vActa# 
    AND ssn_clave = 1
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.AsuntosCAAAFiltro>
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!-- Seleccionar todas las solicitudes -->
<cfif #tbSolicitudes.RecordCount# GT 0>
	<a style="margin: 10px 0px 10px 15px; cursor:pointer;" onclick="fMarcarTodas(true);">
	<span class="Sans9Gr">Marcar todos</span>
	</a>
	<span class="Sans9Gr">
		/ 
	</span>
	<a style="margin: 10px 0px 10px 0px; cursor:pointer;" onclick="fMarcarTodas(false);">
	<span class="Sans9Gr">
		Desmarcar todos
	</span>
	</a>
</cfif>
<!--- TABLA --->
<!--- Inicializar la variable para detectar cambio de sección del listado --->		
<cfset vParte = 0>	
<cfif #tbSolicitudes.RecordCount# GT 0>
	<!-- Lista de solicitudes capturadas -->
	<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<tr valign="middle" bgcolor="#CCCCCC">
			<td width="3%" height="18px"><!-- Selector de registro --></td>
			<td width="5%" title="Número de asunto"><span class="Sans9GrNe">No.</span></td>
			<td width="10%"><span class="Sans9GrNe">ENTIDAD</span></td>
			<td width="35%"><span class="Sans9GrNe">NOMBRE</span></td>
			<td width="29%"><span class="Sans9GrNe">ASUNTO</span></td>
			<td width="10%" title="Fecha de inicio"><span class="Sans9GrNe">FECHA INICIO</span></td>
			<!---<td class="Sans9GrNe">Acta</td>--->
			<td width="5%" title="Sección"><span class="Sans9GrNe">SEC.</span></td>
			<td width="2%" bgcolor="#FFBC81"><!-- PDF --></td>
			<td width="2%" bgcolor="#0066FF"><!-- Ver detalle --></td>
		</tr>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
			<!--- Obtener el nombre de la parte actual del listado --->
            <cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
                SELECT * FROM catalogo_listado
                WHERE parte_numero = #tbSolicitudes.asu_parte#
            </cfquery>
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td><input type="checkbox"style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#tbSolicitudes.sol_id#,2,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosCAAAFiltro.vMarcadas,tbSolicitudes.sol_id)# IS TRUE>checked</cfif>></td>
                <td><span class="Sans9Gr">#tbSolicitudes.asu_numero#</span></td>
                <td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
                <td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
                <td><span class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#<cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3><strong> (SIJAC)</strong></cfif></span></td>
                <td>
                    <cfif #tbSolicitudes.mov_clave# EQ 5 OR #tbSolicitudes.mov_clave# EQ 17 OR #tbSolicitudes.mov_clave# EQ 28>
                        #LSDateFormat(DateAdd('d',1,tbSesiones.ssn_fecha),'dd/mm/yyyy')#	
                    <cfelseif #tbSolicitudes.sol_pos14# IS NOT ''>
                        <span class="Sans9Gr">#LSDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</span>
                    </cfif>		
                </td>
                <!---<td><span class="Sans9Gr">#vActa#</span></td>--->
                <td><span class="Sans9Gr">#ctListado.parte_romano#</span></td>
                <!-- PDF -->
                <td>
                    <!--- Crea variable de archivo de solicitud --->
                    <cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
                    <cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>			
                    <cfif FileExists(#vArchivoSolicitudPdf#)>
                        <img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','SOL','2', '')">                
                        <!---
						<cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>
						<a href="#vArchivoSolicitudPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
						--->
                    </cfif>
                </td>
                <!-- Botón VER -->
                <td>
                    <a href="../solicitudes/#tbSolicitudes.mov_ruta#?vActa=#vActa#&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA"><cfif #tbSolicitudes.sol_devuelve_edita# EQ 1 OR #tbSolicitudes.sol_devuelve_archivo# EQ 1><img src="#vCarpetaICONO#/detalle_error_15.jpg" style="border:none;" title="Detalle del asunto, la solicitud tiene algún problema"><cfelse><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="Detalle del asunto"></cfif></a>
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


