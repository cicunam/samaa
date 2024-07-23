<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 24/01/2018 --->

					<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
					<cfparam name="PageNum_miembros" default="1">

					<cfquery name="tbMiembrosCeUpeid" datasource="#vOrigenDatosSAMAA#">
                        SELECT 
						T1.comision_acd_id, T1.presidente, T1.ssn_id,
                        T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres, T2.acd_email,
						C1.dep_siglas,
                        C2.cn_siglas
                        FROM academicos_comisiones AS T1
                        LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave
                        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave                        
                        WHERE comision_clave = 20
                        <cfif #vSsnId# EQ 0>
							AND ssn_id = #Session.CeUpeidFiltro.SsnIdCeUpeid#
						<cfelse>
							AND ssn_id = #vSsnId#
						</cfif>
                        ORDER BY T2.acd_apepat, T2.acd_apemat
					</cfquery>
<!---
					<cfset MaxRows_sesiones=50>
					<cfset StartRow_sesiones=Min((PageNum_miembros-1)*MaxRows_sesiones+1,Max(tbMiembrosCeUpeid.RecordCount,1))>
					<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,tbMiembrosCeUpeid.RecordCount)>
					<cfset TotalPages_sesiones=Ceiling(tbMiembrosCeUpeid.RecordCount/MaxRows_sesiones)>
					<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
					<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_miembros=","&")>
					<cfif tempPos NEQ 0>
						<cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
					</cfif>
--->					
					<div class="container table_responsive" style="width:95%;">
						<cfoutput>
							<input type="#vTipoInput#" id="vCuentaReg" name="vCuentaReg" value="#tbMiembrosCeUpeid.RecordCount#" />
						</cfoutput>
                        <table class="table table-striped table-hover table-condensed">
                            <thead>
                                <tr class="header">
									<td width="35%"><strong>Nombre</strong></td>
									<td width="15%"><strong>Entidad</strong></td>
									<td width="20%"><strong>Categor&iacute;a y nivel</strong></td>
									<td width="27%"><strong>Correo electr&oacute;nico</strong></td>
									<!---<td width="22%" align="center"><strong>Presidente</strong></td>--->
									<!---<td width="3%"></td>--->
									<td width="3%"></td>
								</tr>
                            </thead>
                            <tbody>
                                <cfoutput query="tbMiembrosCeUpeid">
                                    <tr>
										<td>#acd_apepat# #acd_apemat#, #acd_nombres#</td>
										<td>#dep_siglas#</td>
										<td>#cn_siglas#</td>
										<td>#acd_email#</td>                                        
<!---
										<td align="center">
											<cfif #vSsnId# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid#>
												<cfif #presidente# EQ 1>
                                                <cfelse>
                                                </cfif>
												<input type="checkbox" name="presidente" id="presidente" checked="checked"/>
											<cfelseif #presidente# EQ 1>
												<span class="glyphicon glyphicon-ok">
											</cfif>
										</td>
--->										
<!---
										<td align="center">
											<a href="miembro_detalle.cfm?vComisionAcdId=#comision_acd_id#&vTipoComando=ED" data-toggle="modal" data-target="###comision_acd_id#">
												<span class="glyphicon glyphicon-edit" title="Editar"></span>
											</a>
                                            <div id="#comision_acd_id#" class="modal fade" role="dialog">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <!-- Content will be loaded here from "remote.php" file -->
                                                    </div>
                                                </div>
                                            </div>
										</td>
--->										
										<td align="center">
											<cfif #vSsnId# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
												<a href="miembro_detalle.cfm?vComisionAcdId=#comision_acd_id#&vTipoComando=EL" data-toggle="modal" data-target="###comision_acd_id#">
													<span class="glyphicon glyphicon-remove" style="color:##F00; cursor:pointer;" title="Eliminar"></span>
												</a>
                                                <div id="#comision_acd_id#" class="modal fade" role="dialog">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <!-- Content will be loaded here from "remote.php" file -->
                                                        </div>
                                                    </div>
	                                            </div>                                                
											</cfif>
										</td>
                                    </tr>
                                </cfoutput>
								<cfif #vSsnId# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
                                    <tr class="success">
                                        <td colspan="4"><strong><em>Agregar nuevo miembro a la comisi&oacute;n...</em></strong></td>
                                        <td align="center">
                                            <a href="miembro_detalle.cfm?vComisionAcdId=0&vTipoComando=NV" data-toggle="modal" data-target="#0">
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