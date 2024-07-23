<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/04/2019 --->
<!--- FECHA ÚLTIMA MOD.: 04/05/2023 --->
<!--- INCLUDE GENERAL PARA FORMAS TELEGRÁMICAS SOBRE LOS DATOS GENERALES DE LOS ACADÉMICOS (NOMBRE COMPLETO, ENTIDAD DE ADSCRIPCIÓN Y UBICACIÓN --->

					<cfoutput>
                        <table border="0" class="cuadrosFormularios">
                            <!-- Dependencia -->
                            <cfif LEN(#ctMovimiento.mov_pos1#) GT 0>
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos1#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos1_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos1_txt" id="pos1_txt" type="text" class="datos100" value="#vCampoPos1_txt#" disabled>
                                            <cfinput name="pos1" id="pos1" type="hidden" value="#vCampoPos1#">
                                            <cfif #ctMovimiento.mov_clave# EQ 40 OR #ctMovimiento.mov_clave# EQ 41>
                                                <cfinput name="pos1_u" id="pos1_u" type="#vTipoInput#" value="#vCampoPos1_u#">
                                            </cfif>                                                
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Ubicación --><!-- Se aplica sólo para el campo del catálogo que se requiera y en el caso de la FT-CTIC-29 se muestra en el formulario de la FT como UBICACIÓN ACTUAL -->
                            <cfif LEN(#ctMovimiento.mov_pos1_u#) GT 0 AND #ctMovimiento.mov_clave# NEQ 13 AND #ctMovimiento.mov_clave# NEQ 29>
                                <tr>
                                    <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos1_u#</span></td>
                                    <td width="80%">
                                        <cfif #vTipoComando# IS 'IMPRIME'>
			                                <cfset vCampoPos1_u_txt = ''>
                                            <cfloop query="ctUbicacion">
                                                <cfif #ubica_clave# IS #vCampoPos1_u#>
                                                    <cfset vCampoPos1_u_txt = '#ubica_completa#'>
                                                    <cfbreak>
                                                </cfif>
                                            </cfloop>
                                            <span class="Sans9Gr">#vCampoPos1_u_txt#</span>
                                        <cfelse>
                                            <cfselect name="pos1_u" class="datos" id="pos1_u" query="ctUbicacion" value="ubica_clave" display="ubica_completa" queryPosition="below" selected="#vCampoPos1_u#" style="width:480px" disabled='#vActivaCampos#'>
                                            <cfif #ctUbicacion.RecordCount# GT 1>
                                                <option value="">SELECCIONE</option>
                                            </cfif>
                                            </cfselect>
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <!-- Nombre del académico -->
                            <cfif LEN(#ctMovimiento.mov_pos2#) GT 0>
                                <tr>
                                    <td><span class="Sans9GrNe">#ctMovimiento.mov_pos2#</span></td>
                                    <td>
                                        <cfif #vTipoComando# IS 'IMPRIME'>
                                            <span class="Sans9Gr">#vCampoPos2_txt#</span>
                                        <cfelse>
                                            <cfinput name="pos2_txt" id="pos2_txt" type="text" class="datos100" value="#vCampoPos2_txt#" disabled>
                                            <cfinput name="pos2" id="pos2" type="#vTipoInput#" value="#vCampoPos2#">
                                        </cfif>
                                    </td>
                                </tr>
                            </cfif>
                        </table>
					</cfoutput>