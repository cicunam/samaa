                        <table width="95%" border="0" align="center">
                            <!-- Menú de la lista de sesiones -->
                            <tr><td><div class="linea_menu"></div></td></tr>
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
                            </tr>
                            <cfif #vTipoComando# EQ "CONSULTA">
                                <cfif #Session.sTipoSistema# IS 'stctic'>
									<cfif #Session.CalendarioSesFiltro.TipoSesion# EQ 1>
										<cfif #vssn_id# GTE #Session.sSesion# OR #Session.sUsuarioNivel# EQ 0>
											<cfset vEditaDes = ''>
										<cfelse>
											<cfset vEditaDes = 'disabled'>
										</cfif>
									<cfelseif #Session.CalendarioSesFiltro.TipoSesion# EQ 2 OR #Session.CalendarioSesFiltro.TipoSesion# EQ 7>
										<cfif #tbSesiones.ssn_fecha# GTE #Now()# OR #Session.sUsuarioNivel# EQ 0>
											<cfset vEditaDes = ''>
										<cfelse>
											<cfset vEditaDes = 'disabled'>
										</cfif>
									</cfif>
                                    <!-- Opción: Corregir -->
                                    <tr>
                                        <td>
                                            <cfinput name="subCorrige" type="button" class="botones" value="Corregir" disabled="#vEditaDes#" onclick="fSubmitFormulario('EDITA');">
                                        </td>
                                    </tr>
                                    <!-- Opción: Nueva -->
                                    <tr>
                                        <td>
                                            <cfinput name="subNueva" type="button" class="botones" value="Nueva sesi&oacute;n" onclick="fSubmitFormulario('NUEVO');">
                                        </td>
                                    </tr>
                                </cfif>
                                <!-- Opción: Regresar -->
                                <tr>
                                    <td>
                                        <cfinput name="subRegresa" type="button" class="botones" value="Regresar" onclick="fSubmitFormulario('REGRESA');">
                                    </td>
                                </tr>
                            </cfif>
                            <cfif #vTipoComando# EQ "EDITA" OR #vTipoComando# EQ "NUEVO">
                                <!-- Opción: Guardar -->
                                <tr>
                                    <td>
                                        <cfinput name="Submit" type="button" class="botones" value="Guardar" onclick="fSubmitFormulario('GUARDA');">
                                        <cfinput type="hidden" name="GuardaReg" value="Nuevo">
                                    </td>
                                </tr>
                                <!-- Opción: Restablecer -->
                                <tr>
                                    <td>
                                        <cfinput name="Submit2" type="reset" class="botones" value="Restablecer">
                                    </td>
                                </tr>
                                <!-- Opción: Cancelar -->
                                <tr>								
                                    <td>
                                        <cfinput name="subCancela" type="button" class="botones" value="Cancelar" onclick="fSubmitFormulario('CANCELA');">
                                    </td>
                                </tr>
                            </cfif>
                            
                            <!---
                            <cfif #vTipoComando# EQ 'CONSULTA'>
                                <!-- Navegación -->
                                <tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
                                <tr>
                                    <td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
                                </tr>
                                <!-- Menú principal -->
                                <tr>
                                    <td>
                                        <input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
                                    </td>
                                </tr>
                            </cfif>	
                            --->
                        </table>