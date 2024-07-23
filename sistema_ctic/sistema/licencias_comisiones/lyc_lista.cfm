<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 18/02/2010 --->
<!--- FECHA ÚLTIMA MOD.: 20/10/2017 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA CAAA --->
<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<!---
ELIMINAR
<cfparam name="vFt" default="">
--->
<cfparam name="vActa" default=1376>
<cfparam name="vDepId" default="">
<cfparam name="vAcadNom" default="">
<cfparam name="vOrden" default="">
<cfparam name="vPagina" default=1>

<!--- Registrar filtros --->
<cfif IsDefined('vActa')><cfset Session.AsuntosLYCFiltro.vActa = #vActa#></cfif>
<cfif IsDefined('vDepId')><cfset Session.AsuntosLYCFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.AsuntosLYCFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vOrden')><cfset Session.AsuntosLYCFiltro.vOrden = #vOrden#></cfif>

<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.AsuntosLYCFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.AsuntosLYCFiltro.vPagina#>
</cfif>
<cfif IsDefined('vRPP')><cfset Session.AsuntosLYCFiltro.vRPP = #vRPP#></cfif>

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT
	T1.sol_id, T1.sol_pos2, T1.sol_pos14, T1.sol_pos15, T2.asu_numero, T3.acd_apepat, T3.acd_apemat, T3.acd_nombres, C1.mov_titulo_corto, C2.dep_siglas
    FROM ((((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN catalogo_dependencia AS C2 ON T1.sol_pos1 = C2.dep_clave)
	LEFT JOIN catalogo_cn ON T1.sol_pos3 = catalogo_cn.cn_clave
	WHERE (T1.sol_status = 1 OR T1.sol_status = 0) <!--- Asuntos que pasan a la PLENO --->
	AND T2.asu_reunion = 'CTIC' <!--- Registro de asunto PLENO --->
	AND T2.asu_parte = 5 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
	AND (T1.mov_clave = 40 OR T1.mov_clave = 41)	<!--- Filtro solo de Licencias y Comisiones a las que ya se asignó una sesión --->
	<!--- Filtro por acta --->
	<cfif #vActa# IS NOT ''>AND T2.ssn_id = #vActa#</cfif>
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>
	ORDER BY 
	T2.asu_parte,
	T2.asu_numero,
	C2.dep_orden,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>

<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vActa# 
    AND ssn_clave = 2
</cfquery>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.AsuntosLYCFiltro>
<cfset vConsultaFuncion = "fListarSolicitudes">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">

<cfif #tbSolicitudes.RecordCount# GT 0>
  <!--- TABLA --->
  <!--- Inicializar la variable para detectar cambio de sección del listado --->		
    <cfset vParte = 0>
	<!-- Lista de solicitudes capturadas -->
	<table style="width:800px; margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<tr valign="middle" bgcolor="#CCCCCC">
			<td class="Sans9GrNe">No.</td>
			<td class="Sans9GrNe">Entidad</td>
			<td class="Sans9GrNe">Nombre</td>
			<td class="Sans9GrNe">Asunto</td>
			<td class="Sans9GrNe">Fecha inicio</td>
			<td class="Sans9GrNe">Fecha termino</td>
			<!---<td class="Sans9GrNe">Acta</td>--->
		</tr>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
			<!--- Crea variable de archivo de solicitud --->
			<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
			<cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>			
			<cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>

			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td><span class="Sans9Gr">#tbSolicitudes.asu_numero#</span></td>
				<td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
				<td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
				<td><span class="Sans9Gr">#Ucase(tbSolicitudes.mov_titulo_corto)#</span></td>
				<td><span class="Sans9Gr">#LSDateFormat(tbSolicitudes.sol_pos14,'DD/MM/YYYY')#</span></td>
				<td><span class="Sans9Gr">#LSDateFormat(tbSolicitudes.sol_pos15,'DD/MM/YYYY')#</span></td>
			</tr>
		</cfoutput>
	</table>
<cfelse>
    <br />
    <br />
    <br />
    <br />
	<div style="width:100%" align="center">
        <span class="Sans10Ne">
        NO SE ENCONTRARON LAS SOLICITUDES DE LICENCIAS Y COMISIONES PARA LA SESIÓN <cfoutput><strong>#vActa#</strong></cfoutput>, PERO SE PUEDEN RECUPERAR Y EXPORTAR DE LA HISTORIA.
        </span>
        <br />
        <br />
        <span class="Sans11ViNe">
        PRESIONE EL BOTÓN DE EXPORTAR.
        </span>    
	</div>
</cfif>

<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>