<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 15/12/2022 --->
<!--- FECHA ÚLTIMA MOD.: 16/12/2022 --->
<!--- LISTA LAS SOLICITUDES REGITRADAS --->
                                <cfoutput>
                                    <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0>
                                        <cfset vIconVisible = 1>
                                    <cfelseif #Session.sTipoSistema# EQ 'sic' AND #tbSolCoaTemp.vsolicitudstatus# GTE 5>
                                        <cfset vIconVisible = 1>                                        
                                    <cfelse>
                                        <cfset vIconVisible = 0>
                                    </cfif>
                                    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2 OR #vAppConCoaMenu# EQ 3>
                                        <cfset vArchivoModal = 'coa_detalle.cfm'>
                                        <cfset vTitle = 'Ver detalle'>
                                        <cfif #tbSolCoaTemp.vsolicitudstatus# LTE 4>
                                            <cfset vGlyphicon = 'glyphicon glyphicon-hourglass'>                                            
                                        <cfelse>                                            
                                            <cfset vGlyphicon = 'glyphicon glyphicon-folder-open'>
                                        </cfif>
                                    <cfelseif #vAppConCoaMenu# EQ 4>
                                        <cfset vArchivoModal = 'coa_oficio.cfm'>
                                        <cfset vTitle = 'Adjuntar oficio'>
                                        <cfif #tbSolCoaTemp.coa_ganador# EQ 1>
                                            <cfset vGlyphicon = 'glyphicon glyphicon-cloud-upload'>
                                        <cfelse>
                                            <cfset vGlyphicon = 'glyphicon glyphicon-cloud-upload text-danger'>
                                        </cfif>
                                    </cfif>
                                    <!--- #vIconVisible# - #Session.sTipoSistema# -  #tbSolCoaTemp.vsolicitudstatus# --->
                                    <div id="divCoaSol#tbSolCoaTemp.vsolicitudid#" class="row h6 #vTipoTextoSolCoa# small">
                                        <div class="col-xs-1" >#currentrow#.- </div>
                                        <div class="col-xs-9">#tbSolCoaTemp.vapepat# #tbSolCoaTemp.vapemat# #tbSolCoaTemp.vnombres#<cfif CGI.SERVER_PORT IS "31221"> (#tbSolCoaTemp.vsolicitudstatus#)</cfif></div>
                                        <div class="col-xs-1">
                                            <cfif #vIconVisible# EQ 1>
                                                <a href="#vArchivoModal#?vpSolId=#tbSolCoaTemp.vsolicitudid#" data-toggle="modal" data-target="##CoaModal#tbSolCoaTemp.vsolicitudid#">
                                                    <span class="#vGlyphicon# #vTipoTextoSolCoa#" title="#vTitle#"></span>
                                                </a>
                                            </cfif>
                                        </div>
                                    </div>
                                    <div id="CoaModal#tbSolCoaTemp.vsolicitudid#" class="modal fade" role="dialog">
                                        <div class="modal-dialog modal-lg">
                                            <div class="modal-content">
                                                <!-- Inserta el contenido de la solicitud -->
                                            </div>
                                        </div>
                                    </div>
                                </cfoutput>