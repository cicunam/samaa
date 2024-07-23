<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 24/06/2016 --->
<!--- FT-CTIC-23.- Informe de periodo sabático --->

                        <cfoutput>
                            <table id="idLugar" border="0" class="cuadrosFormularios">
                                <tr bgcolor="##CCCCCC">
                                    <td>
                                        <cfif #vFt# EQ '32'>
                                            <span class="Sans9GrNe">
                                                <center id="txtLugar">
                                                    <cfif #vTipoComando# IS 'IMPRIME'>
                                                        <span class="Sans9GrNe" id="txtPeriodo">
                                                            <cfif #Find("PROGRAMA", vCampoPos12)# IS 0>Instituciones donde realizar&aacute; su periodo sab&aacute;tico<cfelse>Nuevas instituciones donde realizar&aacute; su periodo sab&aacute;tico</cfif>
                                                        </span>
                                                    <cfelse>
                                                        Instituciones donde realizar&aacute; su periodo sab&aacute;tico
                                                    </cfif>
                                                </center>
                                            </span>
                                        <cfelse>
                                            <span class="Sans9GrNe"><center>#UCASE(ctMovimiento.mov_memo2)#</center></span>
                                        </cfif>
                                    </td>
                                </tr>
                                <!-- Lista de instituciones -->
                                <tr>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <cfinclude template="ft_ajax/lista_destinos.cfm">
                                        <cfelse>
                                            <div id="destino_dynamic"><!-- AJAX: Lista de instituciones --></div>
											<div id="formularioDestino_jquery"><!-- JQUERY: Formulario para agregar destino --></div>
                                        </cfif>
                                    </td>
                                </tr>
								<cfif #vActivaCampos# EQ ''>                                
                                    <!-- Botón que habilita el formulario para agregar instituciones -->
                                    <tr>
                                        <td class="NoImprimir" colspan="2" align="center">
                                            <cfinput name="cmdFormularioDestino" id="cmdFormularioDestino" type="button" class="botonesStandar" value="AGREGAR DESTINO" disabled='#vActivaCampos#'>
                                        </td>
                                    </tr>
								</cfif>
                            </table>
                        </cfoutput>
