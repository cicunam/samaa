<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 02/05/2018 --->
<!--- LISTA DE INFORMES ANUALES A CONSIDERAR EN LA REUNIÓN DE LA COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS --->
<!--- Parámetros --->

<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<cfparam name="vFt" default="">
<cfparam name="vSeccion" default="">
<cfparam name="vDepId" default="">
<cfparam name="vAcadNom" default="">
<cfparam name="vOrden" default="">
<cfparam name="vPagina" default=1>

<!--- Registrar filtros --->
<cfif IsDefined('vFt')><cfset Session.ReunionCAAAFiltro.vFt = #vFt#></cfif>
<cfif IsDefined('vSeccion')><cfset Session.ReunionCAAAFiltro.vSeccion = #vSeccion#></cfif>
<cfif IsDefined('vDepId')><cfset Session.ReunionCAAAFiltro.vDepId = #vDepId#></cfif>
<cfif IsDefined('vAcadNom')><cfset Session.ReunionCAAAFiltro.vAcadNom = #vAcadNom#></cfif>
<cfif IsDefined('vOrden')><cfset Session.ReunionCAAAFiltro.vOrden = #vOrden#></cfif>

<!--- Registrar paginación --->
<cfif IsDefined('vPagina')>
	<cfset Session.ReunionCAAAFiltro.vPagina = #vPagina#>
<cfelse>
	<cfset PageNum = #Session.ReunionCAAAFiltro.vPagina#>
</cfif>

<cfif IsDefined('vRPP')><cfset Session.ReunionCAAAFiltro.vRPP = #vRPP#></cfif>

<!--- Identifica si el sistema se accesa por algun dispositivo móvil de APPELE --->
<cfset vIpad = Find('iPad',CGI.HTTP_USER_AGENT)>
<cfset vIphone = Find('iPhone',CGI.HTTP_USER_AGENT)>

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
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
        T1.informe_anio,
        C4.dec_descrip,
        T2.asu_numero, T2.comision_nota
	FROM ((((movimientos_informes_anuales AS T1
	LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id)
	LEFT JOIN academicos AS T4 ON T1.acd_id = T4.acd_id)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.cn_clave = C3.cn_clave) <!---CATALOGOS GENERALES MYSQL --->
    LEFT JOIN catalogo_decision AS C4 ON T1.dec_clave_ci = C4.dec_clave
	WHERE T2.informe_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
	AND T2.ssn_id = #Session.sSesion# <!--- Solo filtra los movimiento de esa sesión --->
	<cfif #vDepId# IS NOT ''> <!--- Filtro por dependencia --->
		AND T1.dep_clave = '#vDepId#'
	</cfif>
	<cfif #vAcadNom# IS NOT ''> <!--- Filtro por académico --->
    	AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'
	</cfif> 
	ORDER BY 
    T2.dec_clave DESC, <!--- EL ORDEN DE LOS INFORMES ES: AP/COMENTARIO Y NO APROBADOS (02/05/2018)--->
	C2.dep_orden,
	T2.asu_numero,
	T4.acd_apepat,
	T4.acd_apemat,
	T4.acd_nombres
</cfquery>

<cfif #tbSolicitudes.RecordCount# LT #vRPP#>
	<cfset vPagina = 1>
</cfif>

<!--- Variables de paginación --->
<cfset vConsultaTabla = tbSolicitudes>
<cfset vConsultaFiltro = Session.ReunionCAAAFiltro>
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
                <th style="width:7%;">Entidad</th>
                <th style="width:37%;">Nombre</th>
                <th style="width:15%;">CCN</th>
                <th style="width:17%;">Dictamen CI</th>
                <th style="width:5%;">No.</th>
                <th style="width:6%;" title="Producción científica">Prod.</th>
                <th style="width:5%;">Nota</th>
                <th style="width:5%;">PDF</th>
            </tr>
        </thead>
        <tbody>
		<!-- Datos -->
			<cfoutput query="tbSolicitudes" startrow="#StartRow#" maxrows="#MaxRows#"> 			
                <!--- Crea variable de archivo de solicitud --->
                <cfset vArchivoPdf = '#acd_id#_#informe_anual_id#_#informe_anio#.pdf'><!---   9033_21783_2014--->
                <cfset vArchivoSolicitudPdf = #vCarpetaInformesAnuales# & #vArchivoPdf#>			
                <cfset vArchivoSolicitudPdfWeb = #vWebInformesAnuales# & #vArchivoPdf#>
                <tr>
                    <td class="small">#dep_siglas#</td>
                    <td class="small">#nombre#</td><!---#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#--->
                    <td class="small">#cn_siglas#</td>
                    <td class="small">#dec_descrip#</td>
                    <td class="small">#asu_numero#</td>
                    <!-- Productividad CISIC -->
                    <td>
						<a href="asuntos_informes_produccion.cfm?vAcdId=#acd_id#" data-toggle="modal" data-target="###acd_id#"><span class="glyphicon glyphicon-signal" style="cursor:pointer;" title="Ver productividad"></span></a>
                        <div id="#acd_id#" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="modal-content">
		                         	<!-- Content will be loaded here from "remote.php" file -->
								</div>
							</div>
                        </div>
					</td>
                    <!-- Nota -->
                    <td>
                        <a href="include_informe_comentario.cfm?vInfAnId=#informe_anual_id#" data-toggle="modal" data-target="###informe_anual_id#">
								<span id="sp_###informe_anual_id#" <cfif LEN(#comision_nota#) GT 0>class="glyphicon glyphicon-comment" title="Hay comentarios"<cfelse>class="glyphicon glyphicon-pencil"  title="Escribir comentario"</cfif> style="cursor:pointer;"></span>
<!---
                            <cfif LEN(#comision_nota#) GT 0>
                                <span class="glyphicon glyphicon-comment" title="Hay comentarios"></span>
                            <cfelse>
                                <span class="glyphicon glyphicon-pencil" style="cursor:pointer;" title="Escribir comentario"></span>
                            </cfif>
--->							
                        </a>
                        <div id="#informe_anual_id#" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <!-- Content will be loaded here from "remote.php" file -->
                                </div>
                            </div>
                        </div>
                    </td>
                    <!-- PDF -->
                    <td>
                        <cfif FileExists(#vArchivoSolicitudPdf#)>
                            <cfif #vIpad# GT 0 OR #vIphone# GT 0>                    
                                <a href="#vArchivoSolicitudPdfWeb#" target="winPdf"><span class="glyphicon glyphicon-open-file" title="Abrir archivo"></a>
                            <cfelse>                            
                                <a href="informe_pdf_comentario.cfm?vArchivoPdf=#vArchivoPdf#&vIdComAcad=#acd_id#&vInfAnId=#informe_anual_id#" target="winPdf"><span class="glyphicon glyphicon-open-file" title="Abrir archivo"></span></a>
                            </cfif>
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