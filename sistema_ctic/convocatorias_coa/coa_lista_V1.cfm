<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 10/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 03/11/2022 --->
<!--- LISTA LA CONVOCATORIAS COA Y SOLICITANTES --->

<cfparam name="vpNoPlaza" default="">
<cfparam name="vpSsnId" default="">
<cfparam name="vpNoGaceta" default="">

<cfif #vAppConCoaMenu# EQ 3>
    <cfset #Session.ConCoaFiltro.vDepClave# = #vpDepClave#>    
    <cfset #Session.ConCoaFiltro.vNoPlaza# = #vpNoPlaza#>
    <cfset #Session.ConCoaFiltro.vSsnId# = #vpSsnId#>
    <cfset #Session.ConCoaFiltro.vNoGaceta# = #vpNoGaceta#>
</cfif>

<cfif #Session.sTipoSistema# IS 'sic'>
    <cfset vOrden = 'coa_no_plaza'>
<cfelseif #Session.sTipoSistema# IS 'stctic'>
    <cfset vOrden = 'dep_siglas'>
</cfif>
<cfset vOrdenDir = 'ASC'>    

<!--- LLAMADO A LA BASE DE DATOS DE ESTÍMULOS DE DGAPA --->
<cfquery name="tbCoas" datasource="#vOrigenDatosSAMAA#">
    SELECT id, coa_id, dep_clave, dep_siglas, coa_no_plaza, cn_descrip, coa_area, ubica_nombre, ubica_lugar, ssn_id, coa_gaceta_num, 
    coa_gaceta_fecha, coa_gaceta_fecha_limite, coa_status, subprograma_asocia
    FROM consulta_convocatorias_coa
    <cfif #vAppConCoaMenu# EQ 0>
        WHERE coa_status BETWEEN 1 AND 3
    <cfelse>
        WHERE YEAR(coa_gaceta_fecha) >= 2021
        <cfif #vAppConCoaMenu# EQ 1>
            AND coa_status < 5 AND '#vFechaHoy#' BETWEEN coa_gaceta_fecha AND coa_gaceta_fecha_limite
        <cfelseif #vAppConCoaMenu# EQ 2>
            AND coa_status < 5 AND '#vFechaHoy#' > coa_gaceta_fecha_limite
        <cfelseif #vAppConCoaMenu# GTE 3>
            AND (coa_status = 5 OR coa_status = 15 OR coa_status = 16) <!--- SE AGREGARON LOS CONCURSOS Y PLAZAS DESIERTAS 03/11/2022 --->
            <cfif LEN(#vpNoPlaza#) GT 4>
                AND coa_no_plaza = '#vpNoPlaza#'
            </cfif>
            <!--- Filtro por acta --->        
            <cfif LEN(#vpSsnId#) EQ 4>
                AND ssn_id = #vpSsnId#
            </cfif>
            <!--- Filtro por número de gaceta --->
            <cfif LEN(#vpNoGaceta#) EQ 4>
                AND coa_gaceta_num = #vpNoGaceta#
            </cfif>            
        </cfif>
    </cfif>
    <!--- Filtro por entidad --->
    <cfif #Session.sTipoSistema# IS 'sic'>	         
        AND dep_clave = '#Session.sIdDep#'
    <cfelseif #Session.sTipoSistema# IS 'stctic' AND #vpDepClave# NEQ '' AND #vAppConCoaMenu# GTE 3>        
        AND dep_clave LIKE '#vpDepClave#%'
    </cfif>
    ORDER BY #vOrden#
</cfquery>

<cfif #CGI.SERVER_PORT# EQ '31221'>        
    <cfoutput>MENU: #vAppConCoaMenu# - REGISTROS: #tbCoas.RecordCount# - #Session.sTipoSistema# - #Session.sIdDep# - #vpDepClave# - #vpNoPlaza# - #vpSsnId# - #vpNoGaceta# </cfoutput>
</cfif>    
<!--- VARIABLES PARA EL ANCHO DE COLUMNAS EN TABLA --->
<cfinclude template="comun/include_ColsAncho.cfm">

<cfif #vAppConCoaMenu# GTE 3 AND ((LEN(#vpDepClave#) GT 3 AND #Session.sTipoSistema# EQ 'stctic') OR LEN(#vpNoPlaza#) GT 4 OR LEN(#vpSsnId#) EQ 4 OR LEN(#vpNoGaceta#) EQ 4)>
    <div style="cursor: pointer; position:absolute; width: 100%; padding-right: 40px;" align="right" onClick="fLimpiafiltros();">
        <div style="color: #FF6600">        
            <strong><span class="glyphicon glyphicon-remove"></span> QUITAR LOS FILTROS</strong>
        </div>            
    </div>
</cfif>

<h4 class="text-danger" align="center">
    <strong>
    <cfif #vAppConCoaMenu# EQ 0>
        CONVOCATORIAS EN PROCESO
    <cfelseif #vAppConCoaMenu# EQ 1>        
        CONVOCATORIAS PUBLICADAS VIGENTES
    <cfelseif #vAppConCoaMenu# EQ 2>
        CONVOCATORIAS PUBLICACI&Oacute;N FINALIZADA Y EN PROCESO SELECCI&Oacute;N
        <cfelseif #vAppConCoaMenu# EQ 3>
        CONVOCATORIAS HIST&Oacute;RICO
        <cfelseif #vAppConCoaMenu# EQ 4>
        CONVOCATORIAS QUE CONCLUYERON EL PROCESO DE SELECCI&OacuteN PARA CARGA OFICIOS
    </cfif>
    </strong>
</h4>

<!--- Variables requeridas para paginación (NO PONER COMILLAS EN vConsultaTablas) --->
<cfset vConsultaTabla = tbCoas>
<cfset vConsultaFuncion = 'fListarRegistros'>
<!--- Variables de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion_bs.cfm">
    
<!--- Tabla para desplegar la información --->
<table id="tbListaDatos" class="table table-striped table-hover table-condensed">
    <thead>
        <cfoutput>
            <tr class="header">
                <th style="width: #vColRow#%;"></th>
                <cfif #Session.sTipoSistema# EQ 'stctic'>
                    <th style="width: 7%;">
                        Entidad
                        <cfif #vAppConCoaMenu# GTE '3'>
                            <span id="spanFiltroEntidad" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="##divFiltrosSolCoa"></span>
                        </cfif>
                    </th>
                </cfif>
                <th style="width: #vColPlaza#%;">
                    Plaza
                    <cfif #vAppConCoaMenu# GTE '3'>
                        <span id="spanFiltroNoPlaza" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="##divFiltrosSolCoa"></span>
                    </cfif>
                </th>
                <th style="width: #vColActa#%;" class="hidden-sm hidden-xs" align="center">
                    Acta CTIC
                    <cfif #vAppConCoaMenu# GTE '3'>
                        <span id="spanFiltroSsn" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="##divFiltrosSolCoa"></span>
                    </cfif>
                </th>
                <th style="width: #vColPublica#%;" class="hidden-sm hidden-xs" align="center">
                    Publicada
                    <cfif #vAppConCoaMenu# GTE '3'>
                        <span id="spanFiltroGaceta" class="glyphicon glyphicon-filter" title="Filtrar" style="cursor:pointer;" data-toggle="collapse" data-target="##divFiltrosSolCoa"></span>
                    </cfif>
                </th>
                <th style="width: #vColSolicita#%;" class="hidden-sm hidden-xs" align="center">
                    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2>
                        Solicitudes para ser considerado como candidato
                    <cfelseif #vAppConCoaMenu# EQ 2>
                        Solicitudes recibidas
                    </cfif>
                </th>
            </tr>
        </cfoutput>
	</thead>
    <!--- CUERPO DE LA TABLA --->
	<tbody>
        <cfoutput query="tbCoas" startRow="#StartRow#" maxRows="#MaxRows#">
            <cfset vCoaId = #coa_id#>
            <tr>
                <td class="small">#CurrentRow#</td>
                <cfif #Session.sTipoSistema# EQ 'stctic'>
                    <td class="small">#dep_siglas#</td>
                </cfif>
                <td class="small">
                    <cfif #Session.sUsuarioNivel# EQ 26>
                        <strong>#ubica_nombre#</strong>
                        <br/>
                    </cfif>
                    <strong>N&uacute;mero de plaza:</strong> #coa_no_plaza#
                    <br/>
                    <strong title="Clase, categoria nivel">Ccn:</strong> #cn_descrip#
                    <br/>
                    <strong>&Aacute;rea:</strong> #coa_area#
                    <br/>
                    <strong>Ubicaci&oacute;n de la plaza:</strong> #ubica_lugar#
                    <cfif #subprograma_asocia# EQ 1>
                        <br/>
                        <strong class="text-danger small">Subprograma para Promover el Ingreso del Personal Acad&eacute;mico Contratado por Art&iacute;culo 51 del Estatuto del Personal Acad&eacute;mico
                    </cfif>
                    <cfif #vAppConCoaMenu# EQ 2><!--- #vAppConCoaMenu# GTE 2 AND #vAppConCoaMenu# LTE 3 --->
                        <a href="impresion/imprime_coaIndividual.cfm?vpCoaId=#coa_id#" target="winImpCoaInd">                        
                        <div class="panel panel-info text-center" style="position:absolute; width: 50%; height: 25px; padding-top: 5px;">
                            <strong><span class="glyphicon glyphicon-print"></span> IMPRIMIR INFORMACI&Oacute;N DE CONVOCATORIA Y SOLICITUDES REGISTRADAS
                        </div>
                        </a>
                        <br/><br/><br/>       
                    </cfif>
                </td>
				<td class="small hidden-sm hidden-xs">#ssn_id#</td>
                <td class="small hidden-sm hidden-xs">
                    <cfif #coa_gaceta_num# EQ '' AND #coa_gaceta_fecha# EQ ''>
                        <strong class="text-danger">En proceso de publicaci&oacute;n en Gaceta UNAM</strong>
                    <cfelse>
                        <strong>Gaceta no.:</strong> #coa_gaceta_num#
                        <br/>
                        <strong>Fecha pub.:</strong> #LsDateFormat(coa_gaceta_fecha,'dd/mm/yyyy')#
                        <br/>
                        <strong>Fecha l&iacute;mite:</strong> #LsDateFormat(coa_gaceta_fecha_limite,'dd/mm/yyyy')#
                        <!--- DIFERENCIA: #datediff("d",now(),coa_gaceta_fecha_limite)# --->
                        <cfif #datediff("d",now(),coa_gaceta_fecha_limite)# LT 0>
                            <br/>
                            <strong class="text-danger">CONVOCATORIA FINALIZADA</strong>
                        </cfif>
                        <br/>
                    </cfif>
                    <br/>
                </td>
                <td class="small" align="center">
                    <cfif #vAppConCoaMenu# LTE 3>
                        <cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">                        
                            SELECT solicitud_id AS vsolicitudid, sol_apepat AS vapepat, sol_apemat AS vapemat, sol_nombres AS vnombres, solicitud_status AS vsolicitudstatus
                            FROM solicitudes
                            WHERE coa_id = '#vCoaId#'
                            ORDER BY sol_apepat, sol_apemat
                        </cfquery>
                    <cfelseif #vAppConCoaMenu# EQ 4>
                        <cfquery name="tbSolCoa" datasource="#vOrigenDatosSAMAA#">
                            SELECT solicitud_id_coa AS vsolicitudid, acd_apepat AS vapepat, acd_apemat AS vapemat, acd_nombres AS vnombres, 6 AS vsolicitudstatus, coa_ganador
                            FROM consulta_convocacoa_concursa
                            WHERE coa_id = '#vCoaId#'
                            ORDER BY acd_apepat, acd_apemat
                        </cfquery>
                    </cfif>
                    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2 OR #vAppConCoaMenu# EQ 4>
                        <table width="100%">
                            <tbody>
                                <cfloop query="tbSolCoa">
                                    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2 OR #vAppConCoaMenu# EQ 3>
                                        <cfset vColSolicita1 = '65%'>
                                        <cfset vColSolicita2 = '30%'>
                                        <cfset vColSolicita3 = '5%'>
                                    <cfelseif #vAppConCoaMenu# EQ 4>
                                        <cfset vColSolicita1 = '90%'>
                                        <cfset vColSolicita2 = '0%'>
                                        <cfset vColSolicita3 = '5%'>
                                    </cfif>
                                    <tr>
                                        <td width="#vColSolicita1#"><span class="glyphicon glyphicon-user btn-md"></span> <strong>#tbSolCoa.vapepat# #tbSolCoa.vapemat# #tbSolCoa.vnombres#</strong></td>
                                        <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2>
                                            <td width="vColSolicita2" align="left">
                                                <cfif #datediff("d",now(),tbCoas.coa_gaceta_fecha_limite)# LT 0 AND #tbSolCoa.vsolicitudstatus# LTE 4>
                                                    <strong class="text-danger">Solicitud fuera de tiempo</strong>
                                                <cfelse>
                                                    <cfif #tbSolCoa.vsolicitudstatus# EQ '' OR #tbSolCoa.vsolicitudstatus# EQ '0'>
                                                        <strong class="text-danger">Validando email</strong>
                                                    <cfelseif #tbSolCoa.vsolicitudstatus# GTE '1' AND #tbSolCoa.vsolicitudstatus# LTE '4'>
                                                        <strong class="text-danger">En captura</strong>
                                                    <cfelseif #tbSolCoa.vsolicitudstatus# EQ '5'>
                                                        <strong class="text-info">Enviada a la entidad</strong>
                                                    <cfelseif #tbSolCoa.vsolicitudstatus# EQ '6'>
                                                        <strong class="text-info">En revisi&oacute;n en la entidad</strong>
                                                    </cfif>
                                                </cfif>
                                                <cfif CGI.SERVER_PORT IS "31221">
                                                    (#tbSolCoa.vsolicitudstatus#)
                                                </cfif>
                                            </td>
                                        </cfif>
                                        <td width="##vColSolicita3" align="center">
                                            <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2 OR #vAppConCoaMenu# EQ 3>
                                                <cfset vArchivoModal = 'coa_detalle.cfm'>
                                                <cfset vTitle = 'Ver detalle'>
                                                <cfset vGlyphicon = 'glyphicon glyphicon-folder-open'>
                                            <cfelseif #vAppConCoaMenu# EQ 4>
                                                <cfset vArchivoModal = 'coa_oficio.cfm'>
                                                <cfset vTitle = 'Adjuntar oficio'>
                                                <cfif #tbSolCoa.coa_ganador# EQ 1>
                                                    <cfset vGlyphicon = 'glyphicon glyphicon-cloud-upload'>
                                                <cfelse>
                                                    <cfset vGlyphicon = 'glyphicon glyphicon-cloud-upload text-danger'>
                                                </cfif>
                                            </cfif>
                                            <cfif #datediff("d",now(),tbCoas.coa_gaceta_fecha_limite)# LT 0 AND #tbSolCoa.vsolicitudstatus# LTE 4>
                                                <a href="#vArchivoModal#?vpSolId=#tbSolCoa.vsolicitudid#" data-toggle="modal" data-target="##CoaModal#tbSolCoa.vsolicitudid#">
                                                    <span class="#vGlyphicon# text-danger" style="cursor:pointer;" title="#vTitle#"></span>
                                                </a>
                                            <cfelse>
                                                <cfif #tbSolCoa.vsolicitudstatus# GTE '5'>
                                                    <a href="#vArchivoModal#?vpSolId=#tbSolCoa.vsolicitudid#" data-toggle="modal" data-target="##CoaModal#tbSolCoa.vsolicitudid#">
                                                        <span class="#vGlyphicon# text-info" style="cursor:pointer;" title="#vTitle#"></span>
                                                    </a>
                                                <cfelseif #tbSolCoa.vsolicitudstatus# LTE '4'>
                                                    <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0>
                                                        <a href="#vArchivoModal#?vpSolId=#tbSolCoa.vsolicitudid#" data-toggle="modal" data-target="##CoaModal#tbSolCoa.vsolicitudid#">
                                                            <span class="glyphicon glyphicon-hourglass text-danger" style="cursor:pointer;" title="#vTitle#"></span>
                                                        </a>
                                                    <cfelse>
                                                        <span class="glyphicon glyphicon-hourglass text-danger" title="En captura"></span>
                                                    </cfif>
                                                </cfif>
                                            </cfif>
                                            <div id="CoaModal#tbSolCoa.vsolicitudid#" class="modal fade" role="dialog">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <!-- Inserta el contenido de la solicitud -->
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr><td colspan="3" height="8px;"></td></tr>
                                </cfloop>
                            </tbody>
                        </table>
                    <cfelseif #vAppConCoaMenu# EQ 3>
                        <div class="row">
                            <div class="col-xs-10" >
                                <span class="h5">Total de solicitudes registradas: <strong>#tbSolCoa.RecordCount#</strong></span> 
                                <a data-toggle="collapse" href="##ListaSol#id#"><span class="glyphicon glyphicon-triangle-bottom" title="Ver detalle"></span></a>
                            </div>
                            <div class="col-xs-2">
                                <a href="impresion/imprime_coaIndividual_finaliza.cfm?vpCoaId=#coa_id#" target="winImpCoaInd">                        
                                    <span class="glyphicon glyphicon-print" title="Imprmir resumen"></span>
                                </a>
                            </div>
                        </div>
                        <div id="ListaSol#id#" class="panel-collapse collapse">
                            <div class="panel-body">
                                <div align="left">
                                    <h5 class="text-info"><strong>Solicitudes recibidas en la entidad</strong></h5>
                                    <cfquery name="tbSolCoaA" dbtype="query">
                                        SELECT *
                                        FROM tbSolCoa
                                        WHERE vsolicitudstatus >= 6
                                    </cfquery>
                                    <cfloop query="tbSolCoaA">
                                        <div class="row h6 text-info small">
                                            <div class="col-xs-1" >#currentrow#.- </div>
                                            <div class="col-xs-9">#tbSolCoaA.vapepat# #tbSolCoaA.vapemat# #tbSolCoaA.vnombres#</div>
                                            <div class="col-xs-1">
                                                <a href="coa_detalle.cfm?vpSolId=#tbSolCoaA.vsolicitudid#" data-toggle="modal" data-target="##CoaModal#tbSolCoaA.vsolicitudid#">
                                                    <span class="glyphicon glyphicon-folder-open"></span>
                                                    <cfif CGI.SERVER_PORT IS "31221">
                                                        (#tbSolCoaA.vsolicitudstatus#)
                                                    </cfif>
                                                </a>
                                            </div>
                                        </div>
                                        <div id="CoaModal#tbSolCoaA.vsolicitudid#" class="modal fade" role="dialog">
                                            <div class="modal-dialog modal-lg">
                                                <div class="modal-content">
                                                    <!-- Inserta el contenido de la solicitud -->
                                                </div>
                                            </div>
                                        </div>
                                    </cfloop>
                                    <!--- SOLICITUDES NO FINALIZARON REGISTRO --->
                                    <cfquery name="tbSolCoaNA" dbtype="query">
                                        SELECT *
                                        FROM tbSolCoa
                                        WHERE vsolicitudstatus < 6
                                    </cfquery>
                                    <cfif #tbSolCoaNA.Recordcount# GT 0>
                                        <h5 class="text-danger"><strong>Solicitudes que no concluyeron proceso de registro</strong></h5>
                                        <cfloop query="tbSolCoaNA">
                                            <div class="row h6 text-danger small">
                                                <div class="col-xs-1" >#currentrow#.- </div>
                                                <div class="col-xs-10">#tbSolCoaNA.vapepat# #tbSolCoaNA.vapemat# #tbSolCoaNA.vnombres#</div>
                                            </div>
                                        </cfloop>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <hr/>
                        <!--- CONSULTA DE SOLICITUD/MOVIMIENTO REGISTRADO POR LA ENTIDAD  03/11/2022  --->
                        <cfquery name="tbSolEnt" datasource="#vOrigenDatosSAMAA#">
                            SELECT sol_pos2 AS acd_id, mov_clave, sol_id, 0 AS mov_id, 'Solicitud' AS tipo_mov
                            FROM movimientos_solicitud
                            WHERE sol_pos23 = '#vCoaId#'
                        </cfquery>
                        <cfif #tbSolEnt.Recordcount# EQ 0>
                            <cfquery name="tbSolEnt" datasource="#vOrigenDatosSAMAA#">
                                SELECT acd_id, mov_clave, sol_id, mov_id, 'Movimiento' AS tipo_mov
                                FROM movimientos
                                WHERE coa_id = '#vCoaId#'
                            </cfquery>
                        </cfif>                            
                        <div class="row">
                            <div class="col-xs-10" >
                                <span class="h6 text-primary">
                                    Forma telegr&aacute;mica registrada (#tbSolEnt.tipo_mov#):
                                    <br/>
                                    <strong>
                                        FT-CTIC-#tbSolEnt.mov_clave#
                                        <cfif #tbSolEnt.mov_clave# EQ 5>
                                            COA
                                        <cfelseif #tbSolEnt.mov_clave# EQ 15>
                                            Concurso desierto
                                        <cfelseif #tbSolEnt.mov_clave# EQ 16>
                                            Plaza desierta
                                        </cfif>
                                        <br/>
                                    </strong>                                            
                                    N&uacute;mero de solicitud: <strong>#tbSolEnt.sol_id#</strong>
                                </span>
                            </div>
                            <div class="col-xs-2">
<!---                                
                                <br/>
                                <a href="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento_modal.cfm?vIdAcad=#tbSolEnt.acd_id#&vIdMov=#tbSolEnt.mov_id#&vTipoComando=CONSULTA&vMenuHidden=0" data-toggle="modal" data-target="##FtRegistro#tbSolEnt.sol_id#">
                                    <span class="glyphicon glyphicon-file" title="Consultar"></span>
                                </a>
                                <div id="FtRegistro#tbSolEnt.sol_id#" class="modal fade" role="dialog">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <!--- Inserta el contenido de la solicitud --->
                                        </div>
                                    </div>
                                </div>
--->                            
                            </div>
                        </div>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    </tbody>
	<tfoot>
		<tr>
			<td colspan="<cfoutput>#vColSpan#</cfoutput>"></td>
		</tr>
    </tfoot>
</table>

<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion_bs.cfm">
<!--- Total de registros --->
<cfoutput>
    <input id="vPagAct" type="hidden" value="#PageNum#">
    <input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
    <input id="vRegTot" type="hidden" value="#tbCoas.RecordCount#">
</cfoutput>
