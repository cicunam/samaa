<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 19/06/2017 --->
<!--- FECHA ÚLTIMA MOD.: 23/03/2022 --->
<!--- CÓDIGO PARA CIERRE DE SESIÓN EN EL SISTEMA  --->

						<cfoutput>
							<cfif #Session.sLoginSistema# NEQ 'pleno' AND #Session.sLoginSistema# NEQ 'caaa' AND #Session.sLoginSistema# NEQ 'cbp' AND #Session.sLoginSistema# NEQ 'ceupeid'>
								<li><a><strong>Sesi&oacute;n vigente: #Session.sSesion#</strong></a></li>
							<cfelseif #Session.sLoginSistema# EQ 'pleno' OR #Session.sLoginSistema# EQ 'caaa' OR #Session.sLoginSistema# EQ 'cbp' OR #Session.sLoginSistema# EQ 'ceupeid'>
								<!--- <li><a href="##"><span class="glyphicon glyphicon-print"></span> Imprimir</a></li> --->
							</cfif>
                            <li>
                                <a href="#vCarpetaRaizLogica#/valida/cierra.cfm" style="color:##FF0000;">
									<span class="glyphicon glyphicon-off"></span><strong> Cerrar sesi&oacute;n</strong>
								</a>
                                <!---<button type="button" class="btn btn-default" style="color:##FF0000;" onClick="window.location('#vCarpetaRaizLogica#/valida/cierra.cfm');"></button>--->
                            </li>
						</cfoutput>