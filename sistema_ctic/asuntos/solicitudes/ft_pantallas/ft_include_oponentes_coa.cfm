<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 20/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 20/06/2016 --->

                        <!-- Lista de oponentes -->
                        <cfoutput>
                            <table border="0" class="cuadrosFormularios">
                                <!-- Titulo del recuadro -->
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2" align="center">
                                        <span class="Sans9GrNe">
											<cfif #vFt# EQ 15 OR #vFt# EQ 42>
	                                        	CONCURSANTE(S)
											<cfelse>
	                                        	OPONENTE(S)
											</cfif>
										</span>
                                    </td>
                                </tr>
								<cfif #vTipoComando# IS 'IMPRIME'>
                                    <tr>
                                        <td colspan="2">
											<cfset vConvocatoria = '#vCampoPos23#'>
                                            <cfinclude template="ft_ajax/lista_oponentes.cfm">
                                        </td>
                                    </tr>
								<cfelse>
                                    <!-- Lista de oponentes capturados -->
									<cfif #vActivaCampos# EQ ''>
                                    <tr>
										<td colspan="2" id="cmdAgregarOponente" class="NoImprimir" valign="top">
											<!-- Controles para agregar un oponente -->                                    
											<span class="AgregarRegTexto">Agregar nuevo<cfif #vFt# EQ 15 OR #vFt# EQ 42> concursante<cfelse> oponente</cfif></span>
											<cfinput type="text" name="filtraacademico" id="filtraacademico" size="60" maxlength="60" disabled='#vActivaCampos#' autocomplete="off" onKeyUp="fObtenerAcademicos('filtraacademico','academico_dynamic','')" class="datos">
											<cfinput type="hidden" name="idOponente" id="idOponente" value="0">
											<div id="academico_dynamic" style="position:absolute; display:block; left:360px;"></div>
											<cfinput type="button" id="cmdAgregaOponente" name="cmdAgregaOponente" value="AGREGAR" class="botonesStandar" disabled='#vActivaCampos#' onclick="fAgregarOponente('INSERTA', 0)">
											<div id="nuevooponente_jquery"><!-- JQUERY: Formulario de captura de nuevo oponente --></div>
											<!--- División por secciones --->
											<div style="float:left; margin-top:10px; width: 100%;"><hr /></div>
                                        </td>
                                    </tr>
									</cfif>
                                    <tr>
                                        <td colspan="2" id="cmdAgregarOponente" class="NoImprimir" valign="top">
                                        	<div id="oponente_dynamic"><!-- AJAX: Lista oponentes --></div>
                                        </td>
                                    </tr>
								</cfif>
                                <!-- FORMULARIO PARA AGREGAR NUEVO ACADÉMICO (TERMINA)-->
                            </table>
                        </cfoutput>