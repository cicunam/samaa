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
<cfif IsDefined('vDepId')><cfset Session.ComisionUPEIDFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.ComisionUPEIDFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vOrden')><cfset Session.ComisionUPEIDFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vRPP')><cfset Session.ComisionUPEIDFiltro.vRPP = #vRPP#></cfif>

<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.ComisionUPEIDFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.ComisionUPEIDFiltro.vPagina#>
</cfif>

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT
    	T1.asunto_id, T1.acd_id, T1.comision_nota, T1.acd_otro,
        C1.mov_titulo_corto,
    	C2.dep_siglas, C2.dep_clave,
        C3.cn_siglas, 
    	(
    	ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
        CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_nombres),'')
        ) AS nombre
		
    FROM (((evaluaciones_comision_upeid AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.cn_clave = C3.cn_clave
	WHERE T1.evalua_status = 2 <!--- Asuntos que pasan a la COMISIÓN EVALUADORA UPEID --->
	AND T1.ssn_id = #Session.sSesion#
	<!--- Filtro por dependencia --->
	<cfif #vDepId# IS NOT ''>AND dep_clave = '#vDepId#'</cfif>
	<!--- Filtro por académico --->
	<cfif #vAcadNom# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>
	ORDER BY 
	C2.dep_siglas,
	T2.acd_apepat,
	T2.acd_apemat,
	T2.acd_nombres
</cfquery>
<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #Session.sSesion# 
	AND ssn_clave = 20
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.ComisionUPEIDFiltro>
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
                <th style="width:3%;">No.</th>
                <th style="width:7%;">Proyecto</th>
                <th style="width:43%;">Nombre</th>
                <th style="width:17%;">Ccn</th>
                <th style="width:20%;">Tipo movimiento</th>
                <th style="width:5%;" align="center">Comenta</th>
                <th style="width:5%;" align="center">PDF</th>                                
            </tr>
        </thead>
        <tbody>
        <!-- Datos -->
        <cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
            <!--- Crea variable de archivo de solicitud --->
            <cfset vArchivoPdf = '#acd_id#_#Session.sSesion#.pdf'>
            <cfset vArchivoAsuntoPdf = #vCarpetaCEUPEID# & #vArchivoPdf#>			
            <cfset vArchivoAsuntoPdfWeb = #vWebCEUPEID# & #vArchivoPdf#>

            <tr>
                <td>#CurrentRow#</td>
                <td>#dep_siglas#</td>
                <td><cfif #acd_id# GT 0>#nombre#<cfelse>#acd_otro#</cfif></td>
                <td>#cn_siglas#</td>
                <td>#mov_titulo_corto#</td>
                <!-- Nota -->
                <td align="center">
                    <a href="include_asunto_comentario.cfm?vAsuId=#asunto_id#&vTipoVistaComentario=T" data-toggle="modal" data-target="###asunto_id#">
                        <cfif LEN(#comision_nota#) GT 0>
                            <span class="glyphicon glyphicon-comment" title="Hay comentarios"></span>
                        <cfelse>
                            <span class="glyphicon glyphicon-pencil" style="cursor:pointer;" title="Escribir comentario"></span>
                        </cfif>
                    </a>
                    <div id="#asunto_id#" class="modal fade" role="dialog">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <!-- Content will be loaded here from "remote.php" file -->
                            </div>
                        </div>
                    </div>
                </td>
                <!-- PDF -->
                <td align="center">
                    <cfif FileExists(#vArchivoAsuntoPdf#)>
                        <a href="#vArchivoAsuntoPdfWeb#" target="winPdf"><span class="fa fa-file-pdf-o" style="cursor:pointer;" title="Abrir archivo"></span></a>
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
