<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 04/06/2019 --->
<!--- LISTA LA RELACIÓN DE ESTÍMULOS  --->

                        <div id="divFiltros" style="padding-left:10px;" class="collapse table-responsive"><!---  --->
							<cfform name="formFiltro" id="formFiltro" class="form-inline" role="form">
								<table id="tbFiltros" class="table">
									<thead>
										<tr class="header warning">
											<td class="small" style="width:3%;"></td>
											<td class="small" style="width:7%;">
												<div class="form-group">
													<cfquery name="ctEntidades" datasource="#vOrigenDatosCATALOGOS#">
														SELECT dep_siglas, MID(dep_clave,1,4) AS dep_clave
														FROM catalogo_dependencias
														WHERE dep_clave LIKE '03%' 
														AND dep_status = 1
														AND dep_tipo <> 'PRO'
														ORDER BY dep_tipo, dep_siglas
													</cfquery>
													<cfselect name="selDepClave" id="selDepClave" query="ctEntidades" queryPosition="below" value="dep_clave" display="dep_siglas" selected="#Session.EstimulosDgapaFiltro.vDepClave#"  class="form-control input-sm"><!---  onChange="fListarRegistros(1);"---> 
														<option value="">TODAS</option>
													</cfselect>
												</div>
											</td>
											<td class="small" style="width:29%;">
												<div class="input-group">
													<span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
													<cfinput id="txtBuscaAcad" name="txtBuscaAcad" type="text" class="form-control input-sm" placeholder="Escriba el nombre del acad&eacute;mico y presione ENTER" onkeypress="fBuscaTexto();" value="#Session.EstimulosDgapaFiltro.vBuscaAcademico#" size="50" maxlength="100">
												</div>
											</td>
											<td class="small" style="width:13%;">
												<div class="form-group">
													<cfquery name="ctCn" datasource="#vOrigenDatosCATALOGOS#">
														SELECT cn_clave, cn_siglas FROM catalogo_cn
														WHERE cn_status = 1
														ORDER BY cn_orden
													</cfquery>
													<cfselect name="selCnClave" id="selCnClave" query="ctCn" queryPosition="below" value="cn_clave" display="cn_siglas" selected="#Session.EstimulosDgapaFiltro.vCcnClave#"  class="form-control input-sm"><!---  onChange="fListarRegistros(1);" --->
														<option value="">TODAS</option>
													</cfselect>
                                                </div>
											</td>
                                            
                                            <td class="small" style="width:10%;">
                                                <div class="form-group">
													<cfquery name="ctPride" datasource="#vOrigenDatosCATALOGOS#">
														SELECT pride_clave, pride_nombre FROM catalogo_pride
														WHERE pride_nivel <> '0'
														ORDER BY pride_nombre
													</cfquery>
													<cfselect name="selPrideClave" id="selPrideClave" query="ctPride" queryPosition="below" value="pride_clave" display="pride_nombre" selected="#Session.EstimulosDgapaFiltro.vPrideClave#" class="form-control input-sm" onChange="fListarRegistros(1);">
														<option value="">TODOS</option>
													</cfselect>
												</div>
											</td>
                                            <td class="small" style="width:7%;">
<!---
												<div class="input-group">
													<span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
													<cfinput id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" placeholder="Escriba el n&uacute;mero de acta y presione ENTER" onkeypress="fBuscaTexto(); return MascaraEntrada(event, '9999');" value="#Session.EstimulosDgapaFiltro.vSsnId#" maxlength="4">
												</div>
--->												
											</td>
											<td class="small" style="width:12%;">
												<div class="input-group">
													<span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
													<cfinput id="txtBuscaOficio" name="txtBuscaOficio" type="text" class="form-control input-sm" placeholder="Escriba el n&uacute;mero de oficio y presione ENTER" onkeypress="fBuscaTexto();" value="#Session.EstimulosDgapaFiltro.vBuscaOficio#" maxlength="25">
												</div>
											</td>
										</tr>
									</thead>
								</table>
							</cfform>
						</div>