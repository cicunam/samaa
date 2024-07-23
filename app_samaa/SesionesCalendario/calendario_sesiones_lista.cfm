					<!--- CREADO: ARAM PICHARDO --->
					<!--- EDITO: ARAM PICHARDO DURÁN --->
					<!--- FECHA CREA: 16/05/2017 --->
					<!--- FECHA ULTIMA MOD.: 16/05/2016 --->

					<!--- LISTA DE SESIONES DEL CTIC --->
					<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
					<cfparam name="PageNum_sesiones" default="1">
	                <cfparam name="vpAnio" default="0">
    	            <cfparam name="vpSesionTipo" default="O">
        	        <cfparam name="vpSemestre1" default="">
            	    <cfparam name="vpSemestre2" default="">

					<cfset vMes = val(LsDateFormat(now(),"mm"))>
					<cfset vAnioPost = #vpAnio# + 1>
					<cfif #vpSesionTipo# EQ 'O'>
						<cfset vTablaCol = 5>
					<cfelse>
						<cfset vTablaCol = 3>
					</cfif>
                    
					<!--- Registrar filtros --->
                    <cfset Session.CalendarioSesFiltro.vAnioConsulta = #vpAnio#>
                    <cfset Session.CalendarioSesFiltro.TipoSesion = '#vpSesionTipo#'>
                    <cfset Session.CalendarioSesFiltro.Semestre1 = '#vpSemestre1#'>
                    <cfset Session.CalendarioSesFiltro.Semestre2 = '#vpSemestre2#'>
					
					<cfquery name="tbCatalogoSesiones" datasource="#vOrigenDatosSAMAA#">
						<cfif #vpSesionTipo# EQ 'O'>
                            SELECT ssn_id FROM sesiones 
                            WHERE (ssn_clave <> 2 AND ssn_clave <> 6 AND ssn_clave <> 7)
                            <cfif #vpSemestre1# EQ 'checked' AND #vpSemestre2# NEQ 'checked'>
                                 AND (MONTH(ssn_fecha) < 9 AND YEAR(ssn_fecha) = #vpAnio#)
                            <cfelseif #vpSemestre1# NEQ 'checked' AND #vpSemestre2# EQ 'checked'>
                                 AND (MONTH(ssn_fecha) > 7 AND YEAR(ssn_fecha) = #vpAnio#) OR (MONTH(ssn_fecha) = 1 AND YEAR(ssn_fecha) = #vAnioPost#)
                            </cfif>
                            AND YEAR(ssn_fecha) = #vpAnio#
                            GROUP BY ssn_id
						<cfelseif #vpSesionTipo# EQ 'E' OR #vpSesionTipo# EQ 'P'>
							SELECT * FROM sesiones WHERE
							<cfif #vpSesionTipo# EQ 'E'>ssn_clave = 2</cfif>
							<cfif #vpSesionTipo# EQ 'P'>ssn_clave = 7</cfif>
							<!--- AND YEAR(ssn_fecha) = #vpAnio#--->
							ORDER BY ssn_fecha DESC
						</cfif>                            
					</cfquery>

                    <div align="center">
                        <!--- <h3><strong>CALENDARIO DE SESIONES DEL CTIC</strong></h3> --->
                        <h4><strong>SESIONES ORDINARIAS</strong></h4>
                        <cfoutput>
                        <h4>
                            <cfif #vpSemestre1# EQ 'checked' AND #vpSemestre2# NEQ 'checked'>
                                Enero a Julio de #vpAnio#
                            <cfelseif #vpSemestre1# NEQ 'checked' AND #vpSemestre2# EQ 'checked'>
                                Junio de #vpAnio# a Enero de #vAnioPost#
							<cfelse>
								#vpAnio#
                            </cfif>
                        </h4>
                        </cfoutput>
                        <br>
                    </div>
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr class="header">
								<cfif #vpSesionTipo# EQ 'O'>
                                    <td width="20%" align="center"><strong>RECEPCI&Oacute;N DE DOCUMENTOS</strong></td>
                                    <td width="20%" align="center"><strong>REUNI&Oacute;N DE LA CAAA</strong></td>
                                    <td width="20%" align="center"><strong>ENTREGA DE CORRESPONDENCIA</strong></td>
                                    <td width="20%" align="center"><strong>SESI&Oacute;N DEL PLENO</strong></td>
                                    <td width="17%" align="center"><strong>SESI&Oacute;N</strong></td>
								<cfelseif #vpSesionTipo# EQ 'E' OR #vpSesionTipo# EQ 'P'>
                                    <td width="20%" align="center"><strong>FECHA</strong></td>
                                    <td width="57%"><strong>LUGAR</strong></td>
                                    <td width="20%" align="center"><strong>SESI&Oacute;N</strong></td>
                                </cfif>
                                <td width="3%" align="center"></td>
                            </tr>
                        </thead>
						<tbody>
							<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                <tr class="success"> 
                                    <td colspan="<cfoutput>#vTablaCol#</cfoutput>"><strong class="small">AGREGAR NUEVA SESI&Oacute;N</strong></td>
                                    <td align="center">
										<a href="calendario_sesiones/sesion_ordinaria.cfm?vTipoComando=N&vpSesionTipo=<cfoutput>#vpSesionTipo#</cfoutput>" data-toggle="modal" data-target="#0">
											<span class="glyphicon glyphicon-plus-sign"></span>
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
                            <!-- Datos -->
                            <cfoutput query="tbCatalogoSesiones">
								<cfif #vpSesionTipo# EQ 'O'>
									<cfset vssnId = #ssn_id#>
                                    <cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
                                        SELECT * FROM sesiones 
                                        WHERE ssn_id = #vssnId# 
                                        ORDER BY ssn_clave DESC
                                    </cfquery>
                                    <tr <cfif #ssn_ID# EQ #Session.sSesion#>style="background-color:##FFFFCC; color:##FF3300;"</cfif>>
                                        <cfloop query="tbSesiones" startrow="1" endrow="1">
                                            <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                        </cfloop>
                                        <cfloop query="tbSesiones" startrow="2" endrow="2">
                                            <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                        </cfloop>
                                        <cfloop query="tbSesiones" startrow="3" endrow="3">
                                            <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                        </cfloop>
                                        <cfloop query="tbSesiones" startrow="4" endrow="4">
                                            <td align="center" <cfif IsDate(#tbSesiones.ssn_fecha_m#)>bgcolor="##FF9900"</cfif>>
                                                <cfif IsDate(#tbSesiones.ssn_fecha_m#)>
                                                    #LSDateFormat(tbSesiones.ssn_fecha_m,'MMMM dd, yyyy')#
                                                <cfelse>
                                                    #LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#
                                                </cfif>
                                            </td>
                                        </cfloop>
                                        <td align="center">#LSNUMBERFORMAT(tbSesiones.ssn_id,'9999')#</td>
									<cfelseif #vpSesionTipo# EQ 'E' OR #vpSesionTipo# EQ 'P'>
										<td>#LSDateFormat(ssn_fecha,'MMMM dd, yyyy')#</td>
										<td>#ssn_sede#</td>
                                        <td align="center">#LSNUMBERFORMAT(ssn_id,'9999')#</td>
                                    </cfif>
									<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
										<td align="center">
											<a href="calendario_sesiones/sesion_ordinaria.cfm?vpSsnId=#ssn_id#&vTipoComando=C&vpSesionTipo=#vpSesionTipo#" data-toggle="modal" data-target="###ssn_id#">
												<span class="glyphicon glyphicon-open"></span>
											</a>
                                            <div id="#ssn_id#" class="modal fade" role="dialog">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <!-- Content will be loaded here from "remote.php" file -->
                                                    </div>
                                                </div>
                                            </div>
										</td>
									</cfif>
                                </tr>
                            </cfoutput>
                            
						</tbody>
                    </table>