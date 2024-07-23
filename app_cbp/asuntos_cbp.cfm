<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 19/04/2024 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA COMISIÓN DE BECAS POSDOCTORALES --->

<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<cfparam name="vDepId" default="">
<cfparam name="vAcadNom" default="">
<cfparam name="vOrden" default="">
<cfparam name="vPagina" default=1>
<!---
<cfoutput>#vActa#</cfoutput>
--->
<!--- Registrar filtros --->
<cfif IsDefined('vDepId')><cfset Session.CBPFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.CBPFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vOrden')><cfset Session.CBPFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vRPP')><cfset Session.CBPFiltro.vRPP = #vRPP#></cfif>

<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.CBPFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.CBPFiltro.vPagina#>
</cfif>

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_solicitudes_cbp
	WHERE ssn_id = #Session.sSesion#
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND nombre LIKE '%#vAcadNom#%'</cfif>
	ORDER BY
	asu_numero,
	dep_orden,
	nombre
</cfquery>
<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #Session.sSesion# 
	AND ssn_clave = 2
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.CBPFiltro>
<cfset vConsultaFuncion = "fListarSolicitudes">
<cfinclude template="../includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="../includes/paginacion_bs.cfm">
<!--- TABLA --->
<!--- Inicializar la variable para detectar cambio de sección del listado --->		
<cfset vParte = 0>	
<cfif #tbSolicitudes.RecordCount# GT 0>
	<!-- Lista de solicitudes capturadas -->
    <table id="tbListaDatos" class="table table-striped table-hover">
        <thead>
            <tr class="header">
				<th style="width:3%;">Área</th>
				<th style="width:3%;">No.</th>
				<th style="width:7%;">Entidad</th>
				<th style="width:53%;">Nombre</th>
                <!--- <th style="width:12%;">Fecha inicio</th>--->
				<!--- <th style="width:12%;">Sec.</th>--->
				<th style="width:5%;" align="center">Comenta</th>
				<th style="width:5%;" align="center">PDF</th>
			</tr>
		</thead>
		<tbody>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#">	
			<!--- Obtener el nombre de la parte actual del listado 
			<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_listado
				WHERE parte_numero = #tbSolicitudes.asu_parte#
			</cfquery>
			--->
			<!--- Crea variable de archivo de solicitud --->
			<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
			<cfset vArchivoSolicitudPdf = #vCarpetaCBP# & #vArchivoPdf#>			
			<cfset vArchivoSolicitudPdfWeb = #vWebCBP# & #vArchivoPdf#>

			<!--- Crea variable para colorear la fila depende del área del conocimiento --->
            <cfif #tbSolicitudes.dep_area# EQ '01'>
                <cfset vFilaColor = '##D4EFF4'>
            <cfelseif #dep_area# EQ '02'>
                <cfset vFilaColor = '##DCFFB9'>
<!---
                <cfif #dep_clave# EQ '033101' OR #dep_clave# EQ '033102'>
                    <cfset vFilaColor = '##FFE888'>
                <cfelse>
                    <cfset vFilaColor = '##DCFFB9'>
                </cfif>
--->
            <cfelseif #dep_area# EQ '03'>
                <cfset vFilaColor = '##FFE888'>
            <cfelseif #dep_area# EQ '10'>
				<cfif #sol_pos1_u# EQ '04' OR #sol_pos1_u# EQ '07'>
                	<cfset vFilaColor = '##D4EFF4'>
				<cfelseif #sol_pos1_u# EQ '02' OR #sol_pos1_u# EQ '03'>
                	<cfset vFilaColor = '##DCFFB9'>
				<cfelse>
                	<cfset vFilaColor = '##FFCEFF'>
				</cfif>
			<cfelse>
                <cfset vFilaColor = '##FFCEFF'>
            </cfif>

			<tr>
				<td style="background-color:#vFilaColor#;"></td>
				<td>#tbSolicitudes.asu_numero#</td>
				<td>#tbSolicitudes.dep_siglas#</td>
				<td>#nombre#</td>
				<!--- <td>#LSDateFormat(sol_pos14,'DD/MM/YYYY')#</td>--->
				<!--- <td>#ctListado.parte_romano#</td>--->
				<!-- Nota -->
				<td align="center">
					<a href="include_asunto_comentario.cfm?vSolId=#sol_id#" data-toggle="modal" data-target="###sol_id#">
						<cfif LEN(#comision_nota#) GT 0>
							<span class="glyphicon glyphicon-comment" title="Hay comentarios"></span>
						<cfelse>
							<span class="glyphicon glyphicon-pencil" style="cursor:pointer;" title="Escribir comentario"></span>
						</cfif>
					</a>
					<div id="#sol_id#" class="modal fade" role="dialog">
						<div class="modal-dialog">
							<div class="modal-content">
								<!-- Content will be loaded here from "remote.php" file -->
							</div>
						</div>
					</div>
<!---
					<span class="glyphicon glyphicon-pencil" style="cursor:pointer;" title="Escribir comentario" onclick="alert('Escribir comentario');"></span>
					<cfif #tbSolicitudes.comision_nota# IS NOT ''>
						<span class="glyphicon glyphicon-comment" style="cursor:pointer;" title="Existen comentarios" onclick="alert('Ver comentarios');"></span>
					</cfif>
--->					
				</td>
				<!-- PDF -->
				<td align="center">
					<cfif FileExists(#vArchivoSolicitudPdf#)>
						<a href="#vArchivoSolicitudPdfWeb#" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span></a>
<!---
                        <a href="comision_nota/pdf_abre_nota.cfm?vArchivoPdf=#vArchivoPdf#&vIdComAcad=#tbSolicitudes.sol_pos2#&vIdSol=#tbSolicitudes.sol_id#" target="WINARCHIVO"><img src="#vCarpetaIMG#/pdf_15.jpg" onclick="" style="border:none; cursor:pointer;" title="Ver documentos en PDF"></a>
--->
                    </cfif>
                </td>
			</tr>
		</cfoutput>
        </tbody>
	</table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="../includes/paginacion_bs.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbSolicitudes.RecordCount#">
</cfoutput>
