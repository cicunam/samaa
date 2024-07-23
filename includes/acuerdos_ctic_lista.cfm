<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ULTIMA MOD.: 20/09/2018 --->
		
					<!--- Registrar filtros --->
                    <cfif IsDefined('vpSsnId')><cfset Session.AcuerdosCticFiltro.vDepId = #vpSsnId#></cfif>
                    <cfif IsDefined('vpBuscaTexto')><cfset Session.AcuerdosCticFiltro.vAcadNom = #vpBuscaTexto#></cfif>
                    <cfif IsDefined('vOrden')><cfset Session.AcuerdosCticFiltro.vOrden = #vOrden#></cfif>
                    
                    <!--- Registrar paginación --->
                    <cfif IsDefined('vPagina')>
                        <cfset Session.AcuerdosCticFiltro.vPagina = #vPagina#>
                    <cfelse>
                        <cfset PageNum = #Session.AcuerdosCticFiltro.vPagina#>
                    </cfif>
                    
                    <cfif IsDefined('vRPP')><cfset Session.AcuerdosCticFiltro.vRPP = #vRPP#></cfif>
					<cfoutput>#vpSsnId#</cfoutput>
					<cfquery name="tbAcuerdos" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM acuerdos_ctic 
                        WHERE 1 = 1
                        <cfif LEN(#vpBuscaTexto#) GT 0>
                             AND acuerdo_titulo LIKE '%#vpBuscaTexto#%'
						</cfif>
                        <cfif LEN(#vpSsnId#) GT 0>
                             AND ssn_id = #vpSsnId#
                        </cfif>
                        ORDER BY acuerdo_fecha DESC, ssn_id
					</cfquery>

					<cfif #tbAcuerdos.RecordCount# LT #vRPP#>
                        <cfset vPagina = 1>
                    </cfif>

					<!--- Variables de paginación --->
                    <cfset vConsultaTabla = tbAcuerdos>
                    <cfset vConsultaFiltro = Session.AcuerdosCticFiltro>
                    <cfset vConsultaFuncion = "fListaAcuerdos">
                    <cfinclude template="../includes/paginacion_variables.cfm">
                    
                    <!--- Controles de paginación --->
                    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_bs.cfm">

                    <table class="table table-striped table-hover">
                        <thead>
                            <tr class="header">
                                <td width="15%"><strong>Fecha acuerdo</strong></td>
                                <td width="70%"><strong>T&iacute;tulo</strong></td>
                                <td width="10%" align="center"><strong>Acta</strong></td>
                                <td width="5%" align="center"></td>                                
                            </tr>
                        </thead>
						<tbody>
                            <!-- Datos -->
                            <cfoutput query="tbAcuerdos" startrow="#StartRow#" maxrows="#MaxRows#">
								<tr>
									<td>#LSDateFormat(acuerdo_fecha,'MMMM dd, yyyy')#</td>
									<td>#MID(acuerdo_titulo,1,120)#</td>
									<td align="center">#ssn_id#</td>
									<td align="center">
	                                    <a href="../includes/acuerdo_ctic_detalle.cfm?vAcuerdoId=#acuerdo_id#" data-toggle="modal" data-target="###acuerdo_id#">
											<span class="glyphicon glyphicon-zoom-in" title="Ver acuerdo completo"></span>
										</a>
                                        <div id="#acuerdo_id#" class="modal fade" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <!-- Content will be loaded here from "remote.php" file -->
                                                </div>
                                            </div>
                                        </div>
									</td>
                              </tr>
                            </cfoutput>
						</tbody>
                    </table>        
					<!--- Controles de paginación --->
                    <cfinclude template="../includes/paginacion_bs.cfm">
                    <!--- Total de registros --->
                    <cfoutput>
                        <input id="vPagAct" type="hidden" value="#PageNum#">
                        <input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
                        <input id="vRegTot" type="hidden" value="#tbAcuerdos.RecordCount#">
                    </cfoutput> 