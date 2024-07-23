<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 16/05/2017 --->
<!--- LISTA DE INFORMES ANUALES A CONSIDERAR EN LA REUNIÓN DE LA COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS --->
<!--- Parámetros --->

<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<cfparam name="vDepId" default="">
<cfparam name="vAcadNom" default="">
<cfparam name="vOrden" default="">
<cfparam name="vPagina" default=1>

<!--- Registrar filtros --->
<cfif IsDefined('vDepId')><cfset Session.ComisionUPEIDInfFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.ComisionUPEIDInfFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vOrden')><cfset Session.ComisionUPEIDInfFiltro.vOrden = #vOrden#></cfif>
<cfif IsDefined('vRPP')><cfset Session.ComisionUPEIDInfFiltro.vRPP = #vRPP#></cfif>

<!--- Identifica si el sistema se accesa por algun dispositivo móvil de APPELE --->
<cfset vIpad = Find('iPad',CGI.HTTP_USER_AGENT)>
<cfset vIphone = Find('iPhone',CGI.HTTP_USER_AGENT)>

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbInformes" datasource="#vOrigenDatosSAMAA#">
	SELECT 
    	T1.acd_id, T1.informe_anual_id,
    	C2.dep_siglas,    
    	(
    	ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
        CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_nombres),'')
        ) AS nombre,
        C3.cn_siglas,
        T1.informe_anio
	FROM (((movimientos_informes_anuales AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.cn_clave = C3.cn_clave) <!---CATALOGOS GENERALES MYSQL --->
	WHERE T1.informe_status = 0 <!--- Registro en la entidad --->
	AND T1.ssn_id = #Session.sSesion# <!--- Solo filtra los movimiento de esa sesión de la CEUPEID --->
	<cfif #vDepId# IS NOT ''> <!--- Filtro por dependencia --->
		AND T1.dep_clave = '#vDepId#'
	</cfif>
	<cfif #vAcadNom# IS NOT ''> <!--- Filtro por académico --->
    	AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'
	</cfif> 
	ORDER BY 
	C2.dep_orden,
	T2.acd_apepat,
	T2.acd_apemat,
	T2.acd_nombres
</cfquery>

<cfif #tbInformes.RecordCount# LT #vRPP#>
	<cfset vPagina = 1>
</cfif>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbInformes>
<cfset vConsultaFiltro = Session.ComisionUPEIDInfFiltro>
<cfset vConsultaFuncion = "fListarInformes">
<cfinclude template="../includes/paginacion_variables.cfm">

<!--- Controles de paginación --->
<cfinclude template="../includes/paginacion_bs.cfm">

<!--- TABLA --->
<!--- Inicializar la variable para detectar cambio de sección del listado --->		
<cfset vParte = 0>	
<cfif #tbInformes.RecordCount# GT 0>
	<!-- Lista de solicitudes capturadas -->
    <table id="tbListaDatos" class="table table-striped table-hover">
        <thead>
            <tr class="header">
                <th style="width:7%;">Entidad</th>
                <th style="width:50%;">Nombre</th>
                <th style="width:33%;">CCN</th>
                <th style="width:5%;" align="center">Nota</th>
                <th style="width:5%;" align="center">PDF</th>
            </tr>
        </thead>
        <tbody>
        <!-- Datos --> 
            <cfoutput query="tbInformes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
                <!--- Crea variable de archivo de solicitud --->
                <cfset vArchivoPdf = '#acd_id#_#informe_anual_id#_#informe_anio#.pdf'>
                <cfset vArchivoInformePdf = '#vCarpetaCEUPEID#/informes_anuales/#vArchivoPdf#'>
                <cfset vArchivoInformePdfWeb = '#vWebCEUPEID#/informes_anuales/#vArchivoPdf#'>
                <tr>
                    <td>#dep_siglas#</td>
                    <td><cfif CGI.SERVER_PORT IS "31221">#acd_id#_#informe_anual_id# </cfif>#nombre#</td><!---#Trim(tbInformes.acd_apepat)# #Trim(tbInformes.acd_apemat)# #Trim(PrimeraPalabra(tbInformes.acd_nombres))#--->
                    <td>#cn_siglas#</td>
                    <!-- Nota -->
                    <td align="center">
<!---
                        <a href="include_informe_comentario.cfm?vInfAnId=#informe_anual_id#" data-toggle="modal" data-target="###informe_anual_id#">
                                <span id="sp_###informe_anual_id#" <cfif LEN(#comision_nota#) GT 0>class="glyphicon glyphicon-comment" title="Hay comentarios"<cfelse>class="glyphicon glyphicon-pencil"  title="Escribir comentario"</cfif> style="cursor:pointer;"></span>
                            
                        </a>
                        <div id="#informe_anual_id#" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <!-- Content will be loaded here from "remote.php" file -->
                                </div>
                            </div>
                        </div>
--->						
                    </td>
                    <!-- PDF -->
                    <td align="center">
                        <cfif FileExists(#vArchivoInformePdf#)>
                            <a href="#vArchivoInformePdfWeb#" target="winPdf"><span class="fa fa-file-pdf-o" title="Abrir archivo"></span></a>
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
	<input id="vRegTot" type="hidden" value="#tbInformes.RecordCount#">
</cfoutput>