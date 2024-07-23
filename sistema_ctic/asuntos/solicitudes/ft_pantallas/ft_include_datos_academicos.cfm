<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/02/2017 --->
<!--- FECHA ÚLTIMA MOD.: 21/02/2023 --->

					<cfoutput>
                        <table border="0" class="cuadrosFormularios">
							<cfif #vFt# EQ 36>
                                <tr bgcolor="##CCCCCC">
                                    <td colspan="2">
                                        <span class="Sans9GrNe"><center>DATOS AL MOMENTO DE SU RETIRO</center></span>
                                    </td>
                                </tr>
							</cfif>
                            <!-- Categoría y nivel -->
							<cfif (LEN(#ctMovimiento.mov_pos3#) GT 0 AND #ctMovimiento.mov_clave# NEQ 14) OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4)>
                                <tr>
                                    <td width="25%"><span class="Sans9GrNe">#ctMovimiento.mov_pos3#</span></td>
                                    <td width="75%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos3_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos3_txt" id="pos3_txt" type="text" class="datos" size="20" value="#vCampoPos3_txt#" disabled>
                                            <cfinput name="pos3" id="pos3" type="hidden" value="#vCampoPos3#">
											<cfif #vTipoComando# EQ 'CONSULTA'>
												<img src="#vCarpetaICONO#/recargar_v2_15.jpg" style="border:none;cursor:pointer;" title="Actualizar CCN" onclick="fActualizaCcn();">
											</cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Antigüedad en esa categoría y nivel -->
<!---							<cfif (LEN(#ctMovimiento.mov_pos4#) GT 0 AND #ctMovimiento.mov_clave# NEQ 14) OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4)> --->
							<cfif (LEN(#ctMovimiento.mov_pos4#) GT 0) AND (#ctMovimiento.mov_clave# NEQ 14 OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4))>
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos4#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos4_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos4_txt" id="pos4_txt" type="text" value="#vCampoPos4_txt#" size="30" maxlength="100" disabled class="datos">
                                            <cfinput name="pos4" id="pos4" type="hidden" value="#vCampoPos4#">
                                            <cfif #vTipoComando# EQ 'CONSULTA'>
												<img src="#vCarpetaICONO#/recargar_v2_15.jpg" style="border:none;cursor:pointer;" title="Actualizar antigüedad en CCN" onclick="fActualizaAntigCcn();">
											</cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Desde (caytegoría y nivel) -->
<!---							<cfif (LEN(#ctMovimiento.mov_pos4_f#) GT 0 AND #ctMovimiento.mov_clave# NEQ 14) OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4)> --->
							<cfif (LEN(#ctMovimiento.mov_pos4_f#) GT 0) AND (#ctMovimiento.mov_clave# NEQ 14 OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4))>
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos4_f#</span></td>
                                    <td colspan="2">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos4_f)#</span>
                                        <cfelse>
                                            <cfinput name="pos4_f" id="pos4_f" type="text" class="datos" size="10" value="#vCampoPos4_f#" disabled>
                                            <cfif #vTipoComando# EQ 'CONSULTA'>
												<img src="#vCarpetaICONO#/recargar_v2_15.jpg" style="border:none;cursor:pointer;" title="Actualizar fecha en ccn" onclick="fActualizaFecha('CN');">
											</cfif>                                            
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Antigüdad académica -->
<!--- 							<cfif (LEN(#ctMovimiento.mov_pos6#) GT 0 AND #ctMovimiento.mov_clave# NEQ 14) OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4)>--->
							<cfif (LEN(#ctMovimiento.mov_pos6#) GT 0) AND (#ctMovimiento.mov_clave# NEQ 14 OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4))>
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos6#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos6_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos6_txt" id="pos6_txt" type="text" class="datos" size="30" value="#vCampoPos6_txt#" disabled>
                                            <cfinput name="pos6" id="pos6" type="hidden" value="#vCampoPos6#">
                                            <cfif #vTipoComando# EQ 'CONSULTA'>
												<img src="#vCarpetaICONO#/recargar_v2_15.jpg" style="border:none;cursor:pointer;" title="Actualizar antigüedad académica" onclick="fActualizaAntigAcad();">
											</cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Fecha de su primer contrato -->
<!---							<cfif (LEN(#ctMovimiento.mov_pos7#) GT 0 AND #ctMovimiento.mov_clave# NEQ 14) OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4)> --->
							<cfif (LEN(#ctMovimiento.mov_pos7#) GT 0) AND (#ctMovimiento.mov_clave# NEQ 14 OR (#ctMovimiento.mov_clave# EQ 14 AND #tbAcademico.con_clave# LT 4))>
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos7#</td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#FechaCompleta(vCampoPos7)#</span>
                                        <cfelse>
                                            <cfinput name="pos7" id="pos7" type="text" class="datos" size="10" value="#vCampoPos7#" disabled>
                                            <cfif #vTipoComando# EQ 'CONSULTA'>
												<img src="#vCarpetaICONO#/recargar_v2_15.jpg" style="border:none;cursor:pointer;" title="Actualizar fecha de 1er. contrato" onclick="fActualizaFecha('1C');">
											</cfif>                                            
                                        </cfif>
                                    </td>
                                </tr>
							</cfif>
                            <!-- Tipo de contrato -->
                            <cfif LEN(#ctMovimiento.mov_pos5#) GT 0>
                                <tr>
                                    <td class="Sans9GrNe">#ctMovimiento.mov_pos5#</td>
                                    <td>
                                        <span class="Sans10Gr">
                                            <cfif #vFt# EQ 14>
												<cfinput type="radio" name="pos5" id="pos5_bp" value="6" checked="#Iif(vCampoPos5 EQ "6",DE("yes"),DE("no"))#" disabled>Becario Posdoctoral
											</cfif>
                                            <cfif #vFt# EQ 5 OR #vFt# EQ 14>
												<cfinput type="radio" name="pos5" id="pos5_c" value="10" checked="#Iif(vCampoPos5 EQ "10",DE("yes"),DE("no"))#" disabled>C&aacute;tedra CONACyT&nbsp;
											</cfif>                                                
                                            <cfinput type="radio" name="pos5" id="pos5_o" value="3" checked="#Iif(vCampoPos5 EQ "3",DE("yes"),DE("no"))#" disabled>Obra determinada &nbsp;
                                            <cfinput type="radio" name="pos5" id="pos5_i" value="2" checked="#Iif(vCampoPos5 EQ "2",DE("yes"),DE("no"))#" disabled>Concurso Abierto&nbsp;
                                            <cfif #vFt# NEQ 5>
	                                            <cfinput type="radio" name="pos5" id="pos5_d" value="1" checked="#Iif(vCampoPos5 EQ "1",DE("yes"),DE("no"))#" disabled>Definitivo &nbsp;
											</cfif>
                                        </span>
                                    </td>
                                </tr>
                            </cfif>
                        </table>
					</cfoutput>