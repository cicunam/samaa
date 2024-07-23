<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 13/10/2022 --->

<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DEL PLENO --->
<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.AsuntosCTICFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vActa')><cfset Session.AsuntosCTICFiltro.vActa = #vActa#></cfif>
<cfif IsDefined('vSeccion')><cfset Session.AsuntosCTICFiltro.vSeccion = #vSeccion#></cfif>
<cfif IsDefined('vDepId')><cfset Session.AsuntosCTICFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosCTICFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vNumSol')><cfset Session.AsuntosCTICFiltro.vNumSol = #vNumSol#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosCTICFiltro.vOrden = #vOrden#></cfif>
<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosCTICFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosCTICFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.AsuntosCTICFiltro.vRPP = #vRPP#></cfif>

<!--- Obtener la lista de solicitudes que se encuentran en el PLENO de CTIC (se creo una consulta eliminando la función UNION ya que alenta la consulta (26/10/2017) --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_solicitudes_pleno
	WHERE ssn_id = #vActa#
	AND ssn_id_post = 0    
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(dbo.SINACENTOS(acd_apepat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_apemat),'') + ' ' + ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'</cfif>
	<!--- Filtro por sección --->
	<cfif #vSeccion# IS NOT ''>AND asu_parte = #vSeccion#<cfelse>AND asu_parte <> 0 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC ---></cfif>
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por tipo de movimiento --->
	<cfif #Session.AsuntosCTICFiltro.vFt# NEQ 0>
		AND
		<cfif #Session.AsuntosCTICFiltro.vFt# IS 100>
			(mov_clave <> 40 AND mov_clave <> 41)
		<cfelseif #Session.AsuntosCTICFiltro.vFt# IS 101>
			(mov_clave = 40 OR mov_clave = 41)	
		<cfelse>
			mov_clave = #Session.AsuntosCTICFiltro.vFt#
		</cfif>	
	</cfif>
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
<cfset vConsultaFiltro = Session.AsuntosCTICFiltro>
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
			<td width="2%" height="18px"><!-- Selector de registro --></td>
			<td width="5%" title="Número de asunto"><span class="Sans9GrNe">No.</span></td>
			<td width="7%"><span class="Sans9GrNe">ENTIDAD</span></td>
			<td width="30%"><span class="Sans9GrNe">NOMBRE</span></td>
			<td width="25%"><span class="Sans9GrNe">ASUNTO</span></td>
			<td width="10%" title="Fecha de inicio"><span class="Sans9GrNe">FECHA INICIO</span></td>
			<!---<td class="Sans9GrNe">Acta</td>--->
			<td width="8%"><span class="Sans9GrNe">OFICIO</span></td>
			<td width="3%" title="Sección"><span class="Sans9GrNe">SEC.</span></td>
			<td width="3%" title="Recomendación de la CAAA"><span class="Sans9GrNe">REC.</span></td>
			<td width="3%" title="Decisión del pleno"><span class="Sans9GrNe">DEC.</span></td>
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
			<!--- Obtener la recomendación CAAA --->
			<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM movimientos_asunto 
				INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
				WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = 'CAAA' AND ssn_id = #vActa#
			</cfquery>
			<!--- Obtener la decisión del CTIC --->
			<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM movimientos_asunto 
				INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
				WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = 'CTIC' AND ssn_id = #vActa#
			</cfquery>
			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td><input type="checkbox"style="margin:0px; border:none;" onclick="fSeleccionarRegistro(#tbSolicitudes.sol_id#,1,this.checked)" <cfif #ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas,tbSolicitudes.sol_id)# IS TRUE>checked</cfif>></td>
				<td><span class="Sans9Gr">#tbSolicitudes.asu_numero#</span></td>
				<td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
				<td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)#, #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
				<td><span class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#<cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3><strong> (SIJAC)</strong></cfif></span></td>
				<td>
					<cfif #tbSolicitudes.mov_clave# EQ 17 OR #tbSolicitudes.mov_clave# EQ 28> <!--- #tbSolicitudes.mov_clave# EQ 5 OR SE ELIMINÓ EL 09/03/2022  --->
						#LSDateFormat(DateAdd('d',1,tbSesiones.ssn_fecha),'dd/mm/yyyy')#	
					<cfelseif #tbSolicitudes.sol_pos14# IS NOT ''>
						<span class="Sans9Gr">#LSDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</span>
					</cfif>	
				</td>
				<!---<td><span class="Sans9Gr">#vActa#</span></td>--->
				<td>
					<span class="Sans9Gr">
						<!--- #SoloNumeroOficio(tbSolicitudes.asu_oficio)# --->
						<cfif #tbSolicitudes.asu_oficio# IS NOT ''>
							<cfif #tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41>
								LC/#Mid(tbSolicitudes.asu_oficio,14,4)#
							<cfelse>	
								#Mid(tbSolicitudes.asu_oficio,11,4)#
							</cfif>	
						</cfif>
					</span>
				</td>
				<td><span class="Sans9Gr">#ctListado.parte_romano#</span></td>
				<td><span class="Sans9Gr">#tbAsuntosCAAA.dec_super#</span></td>
				<td><span class="Sans9Gr">#tbAsuntosCTIC.dec_super#</span></td>
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
					<a href="../solicitudes/#tbSolicitudes.mov_ruta#?vActa=#vActa#&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA"><cfif #tbSolicitudes.sol_devuelve_edita# EQ 1 OR #tbSolicitudes.sol_devuelve_archivo# EQ 1><img src="#vCarpetaICONO#/detalle_error_15.jpg" style="border:none;cursor:pointer;" title="Detalle del asunto para corregir"><cfelse><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;cursor:pointer;" title="Detalle del asunto"></cfif></a>
				</td>
			</tr>
		</cfoutput>
	</table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="#vTipoInput#" value="#PageNum#">
	<input id="vRegRan" type="#vTipoInput#" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="#vTipoInput#" value="#tbSolicitudes.RecordCount#">
	<input id="txtFechaSesion" type="#vTipoInput#" value="#LsDateFormat(tbSesiones.ssn_fecha,'dd/mm/yyy')#">
</cfoutput>