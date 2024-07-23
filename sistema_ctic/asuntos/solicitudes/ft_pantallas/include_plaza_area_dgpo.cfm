<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/11/2021 --->
<!--- FECHA ÚLTIMA MOD.: 23/11/2021 --->
<!---  --->

                                    <cfquery name="tbPlazasNuevas" datasource="#vOrigenDatosPLAZASN#">
										SELECT TOP 1 plaza_adscrip_id, adscripcion_dgpo 
										FROM consulta_plazas_adscrip
										WHERE plaza_numero = '#vCampoPos9#'
										ORDER BY fecha_alta DESC												
									</cfquery>
									<cfif #tbPlazasNuevas.RecordCount# EQ 1>
										<tr>
											<td valign="top"><span class="Sans9GrNe" >Adscripci&oacute;n de la plaza:<div style="cursor: pointer" title="Direcci&oacute;n General de Presupuesto">(DGPo)</div></span></td>
											<td>
												<cfoutput>
													<cftextarea name="memo99" id="memo99" rows="3" class="datos100" disabled='disabled' value="#tbPlazasNuevas.adscripcion_dgpo#"></cftextarea>
													<input name="pos99" id="pos99" type="hidden" value="#tbPlazasNuevas.plaza_adscrip_id#">
												</cfoutput>
											</td>
										</tr>
									</cfif>