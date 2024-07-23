<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/01/2018 --->

					<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
					<cfparam name="PageNum_asuntos" default="1">

					<cfquery name="tbAsuntosCeUpeid" datasource="#vOrigenDatosSAMAA#">
                        SELECT 
						T1.asunto_id, T1.evalua_status, T1.ssn_id,
                        T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
						C1.dep_siglas,
                        C2.cn_siglas,
                        C3.mov_titulo_corto
                        FROM evaluaciones_comision_upeid AS T1
                        LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave
                        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave
                        LEFT JOIN catalogo_movimiento AS C3 ON T1.mov_clave = C3.mov_clave                        
                        WHERE 1 = 1
						<cfif #Session.sTipoSistema# EQ 'stctic'>                        
							<cfif #vSsnId# GT 0>
                                AND ssn_id = #vSsnId#
								<!--- AND ssn_id = #Session.CeUpeidFiltro.SsnIdCeUpeid# --->
                            <cfelse>
                                AND ssn_id IS NULL
								AND evalua_status = 2
                            </cfif>
						<cfelse>
                        	AND evalua_status > 2
							AND T1.dep_clave = '#Session.sIdDep#'
                        </cfif>
                        ORDER BY C1.dep_siglas, T2.acd_apepat, T2.acd_apemat
					</cfquery>
					<div class="container table_responsive" style="width:95%;">
                        <table class="table table-striped table-hover table-condensed">
                            <thead>
                                <tr class="header">
									<td width="40%"><strong>Nombre</strong></td>
									<td width="15%"><strong>Proyecto</strong></td>
									<td width="17%"><strong>Categor&iacute;a y nivel</strong></td>
									<td width="19%"><strong>Asunto</strong></td>                                    
									<td width="3%"></td>
									<td width="3%"></td>
									<td width="3%"></td>                                    
								</tr>
                            </thead>
                            <tbody>
                                <cfoutput query="tbAsuntosCeUpeid">
									<!--- Crea variable de archivo de solicitud --->
									<cfif #evalua_status# LT 2>
	                                    <cfset vArchivoPdf = '#acd_id#.pdf'>
									<cfelse>
	                                    <cfset vArchivoPdf = '#acd_id#_#ssn_id#.pdf'>
									</cfif>
                                    <cfset vArchivoAsuntoPdf = #vCarpetaCEUPEID# & #vArchivoPdf#>			
                                    <cfset vArchivoAsuntoPdfWeb = #vWebCEUPEID# & #vArchivoPdf#>
                                    <tr>
										<td>#acd_apepat# #acd_apemat#, #acd_nombres#</td>
										<td>#dep_siglas#</td>
										<td>#cn_siglas#</td>
										<td >#mov_titulo_corto#</td>
										<td align="center">
				                            <a href="asunto_detalle.cfm?vAsuntoId=#asunto_id#&vTipoComando=ED" data-toggle="modal" data-target="###asunto_id#">
												<span class="glyphicon glyphicon-edit" style="cursor:pointer;" title="Editar"></span>
											</a>
                                            <div id="#asunto_id#" class="modal fade" role="dialog">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <!-- Content will be loaded here from "remote.php" file -->
                                                    </div>
                                                </div>
                                            </div>
										</td>
										<td align="center">
											<cfif #vSsnId# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
												<a href="asunto_detalle.cfm?vAsuntoId=#asunto_id#&vTipoComando=EL" data-toggle="modal" data-target="###asunto_id#">                                            
													<span class="glyphicon glyphicon-remove" style="color:##F00; cursor:pointer;" title="Eliminar"></span>
												</a>                                                    
											</cfif>
										</td>
										<td align="center">
											<cfif FileExists(#vArchivoAsuntoPdf#)>
												<a href="#vArchivoAsuntoPdfWeb#" target="winPdf"><span class="fa fa-file-pdf-o"></span></a>
											</cfif>
										</td>
                                    </tr>
								</cfoutput>
								<cfif #vSsnId# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
                                    <tr class="success">
                                        <td colspan="6"><strong class="small"><em>Agregar nuevo asunto...</em></strong></td>
                                        <td align="center">
											<!--- <span class="glyphicon glyphicon-plus"></span> --->
                                            <a href="asunto_detalle.cfm?vAsuntoId=0&vTipoComando=NV" data-toggle="modal" data-target="#0">
                                                <span class="glyphicon glyphicon-plus"></span>
                                            </a>
                                            <div id="0" class="modal fade" role="dialog">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <!-- Content will be loaded here from "remote.php" file -->
                                                    </div>
                                                </div>
                                            </div>
										</td>
                                    </tr>
								</cfif>
                            </tbody>
                        </table>
					</div>                    