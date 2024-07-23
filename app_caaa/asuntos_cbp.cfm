<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/05/2017 --->
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
	SELECT * FROM (((((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN movimientos_solicitud_comision AS T3 ON T1.sol_id = T3.sol_id)
	LEFT JOIN academicos AS T4 ON T1.sol_pos2 = T4.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.sol_pos3 = C3.cn_clave
	WHERE T1.sol_status = 2 <!--- Asuntos que pasan a la CAAA --->
	AND T2.asu_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
	AND T2.asu_parte = 3.1
	AND T2.ssn_id = #Session.sSesion#
	AND T1.mov_clave = 38
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>
	ORDER BY 
	T2.asu_parte,
	T2.asu_numero,
	C2.dep_orden,
	T4.acd_apepat,
	T4.acd_apemat,
	T4.acd_nombres,
	T1.sol_pos14
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
                <th style="width:7%;">Entidad</th>
                <th style="width:46%;">Nombre</th>
                <th style="width:12%;">Fecha</th>
                <th style="width:12%;">Sec.</th>
                <th style="width:10%;">No.</th>
                <th style="width:5%;">Nota</th>
                <th style="width:5%;">PDF</th>                                
            </tr>
        </thead>
        <tbody>
		<!-- Datos -->
		<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
			<!--- Obtener el nombre de la parte actual del listado --->
			<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_listado
				WHERE parte_numero = #tbSolicitudes.asu_parte#
			</cfquery>
			<!--- Crea variable de archivo de solicitud --->
			<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
			<cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>			
			<cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>

			<!--- Crea variable para colorear la fila depende del área del conocimiento --->
            <cfif #tbSolicitudes.dep_area# EQ '01'>
                <cfset vFilaColor = '##D4EFF4'>
            <cfelseif #tbSolicitudes.dep_area# EQ '02'>
                <cfif #tbSolicitudes.dep_clave# EQ '033101'>
                    <cfset vFilaColor = '##FFE888'>
                <cfelse>
                    <cfset vFilaColor = '##DCFFB9'>
                </cfif>
            <cfelseif #tbSolicitudes.dep_area# EQ '03'>
                <cfset vFilaColor = '##FFE888'>
            </cfif>

			<tr>
				<td  style="background-color:#vFilaColor#;"></td>
				<td><span class="Sans9Gr">#tbSolicitudes.dep_siglas#</span></td>
				<td><span class="Sans9Gr">#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#</span></td>
				<td><span class="Sans9Gr">#LSDateFormat(tbSolicitudes.cap_fecha_mod,'DD/MM/YYYY')#</span></td>
				<td><span class="Sans9Gr">#ctListado.parte_romano#</span></td>
				<td><span class="Sans9Gr">#tbSolicitudes.asu_numero#</span></td>
				<!-- Nota -->
				<td onclick="fMostrarNota('#tbSolicitudes.comision_acd_id#','#tbSolicitudes.sol_id#', this)">
					<span class="glyphicon glyphicon-pencil" style="cursor:pointer;" title="Escribir comentario" onclick="alert('Escribir comentario');"></span>
					<cfif #tbSolicitudes.comision_nota# IS NOT ''>
						<span class="glyphicon glyphicon-comment" style="cursor:pointer;" title="Existen comentarios" onclick="alert('Ver comentarios');"></span>
					</cfif>	
				</td>
				<!-- PDF -->
				<td>
					<cfif FileExists(#vArchivoSolicitudPdf#)>
						<span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span>
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
