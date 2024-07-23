<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 10/08/2018 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS --->

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
    	T1.sol_pos2, T1.sol_id,
    	T3.comision_acd_id, C2.dep_siglas,
    	(
    	ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
        CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_nombres),'')
        ) AS nombre ,
		C1.mov_titulo_corto, T1.sol_pos14, T2.asu_parte, T2.asu_numero, T3.comision_nota,
        C3.cn_siglas
	<!--- (SELECT COUNT(*) FROM movimientos_solicitud_comision WHERE sol_id = T1.sol_id AND ssn_id = #Session.sSesion#) AS vCuentaNota --->
	FROM (((((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CAAA')
	LEFT JOIN movimientos_solicitud_comision AS T3 ON T1.sol_id = T3.sol_id AND T3.ssn_id = #Session.sSesion#
	LEFT JOIN academicos AS T4 ON T1.sol_pos2 = T4.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.sol_pos3 = C3.cn_clave) <!---CATALOGOS GENERALES MYSQL --->
	WHERE T1.sol_status = 2 <!--- Asuntos que pasan a la CAAA --->
	AND T2.asu_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
	AND T2.asu_parte <> 0 <!--- Excluir los asuntos que no pasan a las reuniones CAAA/CTIC --->
	AND T2.ssn_id = #Session.sSesion# <!--- Solo filtra los movimiento de esa sesión --->
	<cfif #vSeccion# EQ 1>
		<!--- AND T3.ssn_id IS NULL ARREGLO TEMPORAL: Se duplican los registros en la sesión 1419 --->
		<!--- AND T3.comision_acd_id <> 0 --->
	</cfif>
	<cfif #vSeccion# EQ 1 OR #vSeccion# EQ 3>
		AND T2.asu_parte = #vSeccion#
	<cfelseif #vSeccion# EQ 32>
		AND T2.asu_parte = 3.2 <!---AND T2.asu_parte = 3.1--->
	<cfelseif #vSeccion# EQ 331>
		AND T2.asu_parte = 3.3 AND T1.mov_clave = 37      
	<cfelseif #vSeccion# EQ 34>
		AND T2.asu_parte = 3.4
	<cfelseif #vSeccion# EQ 4>
		AND (T2.asu_parte BETWEEN 4.1 AND 4.4)
	</cfif>
	<cfif #Session.ReunionCAAAFiltro.vFt# NEQ 0> <!--- Filtro por tipo de movimiento --->
		AND T1.mov_clave = #Session.ReunionCAAAFiltro.vFt#
	</cfif>
	<!--- Filtro por acta
	<cfif #vActa# IS NOT ''>AND T2.ssn_id = #vActa#</cfif>
	 --->
	<cfif #vDepId# IS NOT ''> <!--- Filtro por dependencia --->
		AND sol_pos1 = '#vDepId#'
	</cfif>
	<cfif #vAcadNom# IS NOT ''> <!--- Filtro por académico --->
    	AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'
	</cfif> 
	ORDER BY 
	T2.asu_parte,
	T2.asu_numero,
	C2.dep_orden,
	T4.acd_apepat,
	T4.acd_apemat,
	T4.acd_nombres,
	T1.sol_pos14
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
    <table id="tbListaDatos" class="table table-hover table-condensed table-striped"><!--- --->
        <thead>
            <tr class="header">
				<cfif #Session.sAcadIdCaaa# GT 0>            
	                <th style="width:3%;"></th>
				</cfif>
                <th style="width:3%;">No.</th>
                <th style="width:7%;">Entidad</th>
                <th style="width:37%;">Nombre</th>
				<th style="width:21%;">Asunto</th>
				<cfif #vSeccion# EQ 32>
					<th style="width:12%;" align="center">Producción</th>
				<cfelse>
					<th style="width:12%;" class="hidden-sm hidden-xs">Fecha inicio</th>
				</cfif>                    
                <th style="width:7%;">Comenta</th>
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
                <cfset vArchivoPdf = '#tbSolicitudes.sol_pos2#_#tbSolicitudes.sol_id#.pdf'>
                <cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>			
                <cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>
                <tr>
                    <cfif #Session.sAcadIdCaaa# GT 0>
                        <td>
                            <cfif #Session.sAcadIdCaaa# EQ #tbSolicitudes.comision_acd_id#>
                                <span class="glyphicon glyphicon-ok" title="Asunto que le corresponde revisar"></span>
                                <!--- <img src="#vCarpetaIMG#/aceptar_15.jpg" style="border:none;" title="Asunto que le corresponde revisar"> --->
                            </cfif>
                        </td>
                    </cfif>
                    <td class="small">#asu_numero#</td>
                    <td class="small">#dep_siglas#</td>
                    <td class="small">#nombre#</td><!---#Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# #Trim(PrimeraPalabra(tbSolicitudes.acd_nombres))#--->
					<td class="small">#Ucase(mov_titulo_corto)#</td>
					<cfif #vSeccion# EQ 32>
                        <td>
                            <a href="asuntos_informes_produccion.cfm?vAcdId=#sol_pos2#" data-toggle="modal" data-target="###sol_pos2#"><span class="glyphicon glyphicon-signal" style="cursor:pointer;" title="Ver productividad"></span></a>
                            <div id="#sol_pos2#" class="modal fade" role="dialog">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <!-- Content will be loaded here from "remote.php" file -->
                                    </div>
                                </div>
                            </div>
                        </td>
            		<cfelse>        
						<td class="small hidden-sm hidden-xs">#LSDateFormat(sol_pos14,'DD/MM/YYYY')#</td>
					</cfif>                        
                    <!-- Nota -->
                    <cfif (#vSeccion# EQ 1) OR (#vSeccion# GTE 3) OR (#Session.sAcadIdCaaa# EQ 0)>
                        <td align="center">
                            <a href="include_asunto_comentario.cfm?vSolId=#sol_id#&vTipoVistaComentario=T" data-toggle="modal" data-target="###sol_id#">
								<span id="sp_###sol_id#" <cfif LEN(#comision_nota#) GT 0>class="glyphicon glyphicon-comment" title="Hay comentarios"<cfelse>class="glyphicon glyphicon-pencil"  title="Escribir comentario"</cfif> style="cursor:pointer;"></span>
                            </a>
                            <div id="#sol_id#" class="modal fade" role="dialog" align="left">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <!-- Content will be loaded here from "remote.php" file -->
                                    </div>
                                </div>
                            </div>
                        </td>
                    </cfif>
                    <!-- PDF -->
                    <td align="center">
                        <cfif FileExists(#vArchivoSolicitudPdf#)>
                            <cfif #vIpad# GT 0 OR #vIphone# GT 0>                    
                                <a href="#vArchivoSolicitudPdfWeb#" target="winPdf"><span class="glyphicon glyphicon-open-file" title="Abrir archivo"></span></a>
                            <cfelse>                            
                                <a href="asunto_pdf_comentario.cfm?vArchivoPdf=#vArchivoPdf#&vIdComAcad=#sol_pos2#&vSolId=#sol_id#" target="winPdf"><span class="glyphicon glyphicon-open-file" title="Abrir archivo"></span></a>
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
