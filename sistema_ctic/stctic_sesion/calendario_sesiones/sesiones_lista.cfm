<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/06/2015 --->
<!--- FECHA ULTIMA MOD.: 06/09/2017 --->
<!--- LISTA DE SESIONES DEL CTIC --->
				<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
                <cfparam name="PageNum_sesiones" default="1">
                <cfparam name="vpAnio" default="0">
                <cfparam name="vpSesionTipo" default="1">
                <cfparam name="vpSemestre1" default="">
                <cfparam name="vpSemestre2" default="">                    

                <cfset vMes = val(LsDateFormat(now(),"mm"))>
                <cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>
                

                <!--- Registrar filtros --->
                <cfset Session.CalendarioSesFiltro.vAnioConsulta = #vpAnio#>
                <cfset Session.CalendarioSesFiltro.TipoSesion = '#vpSesionTipo#'>
                <cfset Session.CalendarioSesFiltro.Semestre1 = '#vpSemestre1#'>
                <cfset Session.CalendarioSesFiltro.Semestre2 = '#vpSemestre2#'>
	
                    
					<cfquery name="tbCatalogoSesiones" datasource="#vOrigenDatosSAMAA#">
						<cfif #vpSesionTipo# EQ '1'>
							SELECT ssn_id FROM sesiones 
                            WHERE (ssn_clave = 1 OR ssn_clave BETWEEN 3 AND 5)
							<cfif #vpSemestre1# EQ 'checked' AND #vpSemestre2# EQ ''>
								 AND (MONTH(ssn_fecha) < 9 AND YEAR(ssn_fecha) = #vpAnio#)
							<cfelseif #vpSemestre1# EQ '' AND #vpSemestre2# EQ 'checked'>
								 AND (MONTH(ssn_fecha) > 7 AND YEAR(ssn_fecha) = #vpAnio#) OR (MONTH(ssn_fecha) = 1 AND YEAR(ssn_fecha) = #vAnioPost#)
							<cfelse>
								AND YEAR(ssn_fecha) = #vpAnio#
							</cfif>
							GROUP BY ssn_id
						</cfif>
						<cfif #vpSesionTipo# EQ '2' OR #vpSesionTipo# EQ '7'>
							SELECT * FROM sesiones WHERE
							ssn_clave = #vpSesionTipo#
							<cfif #vpAnio# NEQ 0>
								AND YEAR(ssn_fecha) = #vpAnio#
							</cfif>
							ORDER BY ssn_id DESC
						</cfif>
					</cfquery>

					<cfset MaxRows_sesiones=100>
					<cfset StartRow_sesiones=Min((PageNum_sesiones-1)*MaxRows_sesiones+1,Max(tbCatalogoSesiones.RecordCount,1))>
					<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,tbCatalogoSesiones.RecordCount)>
					<cfset TotalPages_sesiones=Ceiling(tbCatalogoSesiones.RecordCount/MaxRows_sesiones)>
					<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
					<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_sesiones=","&")>
					<cfif tempPos NEQ 0>
						<cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
					</cfif>

					<table width="80%" border="0" align="center" class="CuadrosMarron">
						<tr>
							<td>
								<div align="center">
									<span class="Sans12NeNe">CALENDARIO DE SESIONES DEL CTIC</span>
									<br>
									<cfif #vpSesionTipo# EQ "1">
										<span class="Sans12NeNe">SESIONES ORDINARIAS</span>
										<br>
										<cfoutput>
										<span class="Sans12ViNe">
											<cfif #vpSemestre1# EQ 'checked' AND #vpSemestre2# EQ ''>
												Enero a Julio de #vpAnio#
											<cfelseif #vpSemestre1# EQ '' AND #vpSemestre2# EQ 'checked'>
												Junio de #vpAnio# a Enero de #vAnioPost#
											<cfelse>
												#vpAnio#
											</cfif>
										</span>
										</cfoutput>
									<cfelseif #vpSesionTipo# EQ "2">
										<span class="Sans12NeNe">SESIONES EXTRAORDINARIAS</span>
									<cfelseif #vpSesionTipo# EQ "7">
										<span class="Sans12NeNe">COMISIÓN DE BECAS POSDOCTORALES</span>
									</cfif>
									<br>
								</div>
							</td>
						</tr>
					</table>
					<br>
					<!--- REUNIÓN DEL PLETNO ORDINARIAS --->
					<cfif #vpSesionTipo# EQ "1" AND (#vpSemestre1# NEQ '' OR #vpSemestre2# NEQ '')>
						<table style="width: 90%;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
							<!-- Encabezados -->
							<tr bgcolor="#CCCCCC">
								<td width="20%" align="center" bgcolor="#CCCCCC" class="Sans9GrNe">RECEPCI&Oacute;N DE DOCUMENTOS</td>
								<td width="20%" align="center" class="Sans9GrNe">REUNI&Oacute;N DE LA CAAA</td>
								<td width="20%" align="center" class="Sans9GrNe">ENTREGA DE CORRESPONDENCIA</td>
								<td width="20%" align="center" class="Sans9GrNe">SESI&Oacute;N DEL PLENO</td>
								<td width="17%" align="center" class="Sans9GrNe">SESI&Oacute;N</td>
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
									<td width="3%" bgcolor="#0066FF"></td>
								</cfif>                                    
							</tr>
							<tr><td colspan="6" align="center"><hr></td></tr>
                            <cfif #vpAnio# GTE #LsDateFormat(now(),"yyyy")#>
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <tr>
                                        <cfoutput>
                                        <td colspan="5"><span class="Sans10ViNe"><em>AGREGAR NUEVO REGISTRO.....</em></span></td>
                                        <td align="center"><a href="sesion_ordinaria.cfm?vTipoComando=NUEVO"><img src="#vCarpetaICONO#/agregar_15.jpg" width="15" height="15" style="border:none;" title="Agregar nuevo registro"></a></td>
                                        </cfoutput>
                                    </tr>
									<tr><td colspan="6" align="center"><hr></td></tr>
								</cfif>
							</cfif>
							<!-- Datos -->
							<cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
								<cfset vssnId = #tbCatalogoSesiones.ssn_ID#>
								<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
									SELECT * FROM sesiones 
									WHERE ssn_id = #vssnId#
									AND (ssn_clave = 1 OR ssn_clave BETWEEN 3 AND 5)
									ORDER BY ssn_clave DESC
								</cfquery>
								<tr <cfif #tbSesiones.ssn_id# EQ session.sSesion> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse> onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
									<cfloop query="tbSesiones" startrow="1" endrow="1">
										<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
									</cfloop>
									<cfloop query="tbSesiones" startrow="2" endrow="2">
										<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
									</cfloop>
									<cfloop query="tbSesiones" startrow="3" endrow="3">
										<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
									</cfloop>
									<cfloop query="tbSesiones" startrow="4" endrow="4">
										<td align="center" <cfif IsDate(#tbSesiones.ssn_fecha_m#)>bgcolor="##FF9900"</cfif>>
											<span class="Sans10Ne">
												<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
													#LSDateFormat(tbSesiones.ssn_fecha_m,'MMMM dd, yyyy')#
												<cfelse>
													#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#
											</cfif>
											</span>
										</td>
									</cfloop>
									<td align="center"><span class="Sans10Ne">#LSNUMBERFORMAT(tbSesiones.ssn_id,'9999')#</span></td>
									<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>                                    
                                        <td align="center">
                                            <a href="sesion_ordinaria.cfm?vSesionId=#tbSesiones.ssn_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" width="15" height="15" style="border:none;"></a>
                                        </td>
									</cfif>                                        
								</tr>
								<tr><td colspan="6" align="center"><hr></td></tr>
							</cfoutput>
						</table>
					</cfif>
					<!--- REUNIÓN DEL PLETNO EXTRAORDINARIAS --->
					<cfif #vpSesionTipo# EQ "2">
						<table style="width: 615px;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
							<!-- Encabezados -->
							<tr bgcolor="#CCCCCC">
								<td height="20" class="Sans9GrNe">FECHA</td>
								<td class="Sans9GrNe">LUGAR</td>
								<td width="15" bgcolor="#0066FF"></td>
							</tr>
							<tr><td colspan="3" align="center"><hr></td></tr>
                            <cfif #vpAnio# GTE #LsDateFormat(now(),"yyyy")# OR #vpAnio# EQ 0>
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <tr>
                                        <cfoutput>
                                        <td colspan="2"><span class="Sans11ViNe"><em>AGREGAR NUEVO REGISTRO.....</em></span></td>
                                        <td align="center"><a href="sesion_extraordinaria.cfm?vTipoComando=NUEVO&vSsnClave=2"><img src="#vCarpetaICONO#/agregar_15.jpg" width="15" height="15" style="border:none;" title="Agregar nuevo registro"></a></td>
                                        </cfoutput>
                                    </tr>
									<tr><td colspan="3" align="center"><hr></td></tr>
								</cfif>
							</cfif>
							<!-- Datos -->
							<cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
								<tr <cfif #tbCatalogoSesiones.ssn_id# EQ #Session.sSesion#> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse> onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
									<td class="Sans10Ne">#LSDateFormat(tbCatalogoSesiones.ssn_fecha,'MMMM, dd yyyy')#</td>
									<td class="Sans10Ne">#tbCatalogoSesiones.ssn_sede#</td>
									<!-- Botón VER -->
									<td>
										<a href="sesion_extraordinaria.cfm?vSesionId=#tbCatalogoSesiones.ssn_id#&vTipoComando=CONSULTA&vSsnClave=2"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="#tbCatalogoSesiones.ssn_id#"></a>
									</td>
								</tr>
								<tr><td colspan="3" align="center"><hr></td></tr>
							</cfoutput>
						</table>
					</cfif>
					<!---REUNIÓN DE LA COMISIÓN DE BECAS POSDOCTORALES --->
					<cfif #vpSesionTipo# EQ "7">
						<table style="width: 615px;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
							<!-- Encabezados -->
							<tr bgcolor="#CCCCCC">
								<td height="20" class="Sans9GrNe">FECHA</td>
							  <td class="Sans9GrNe">LUGAR</td>
								<td width="15" bgcolor="#0066FF"></td>
							</tr>
							<tr><td colspan="7" align="center"><hr></td></tr>
                            <cfif #vpAnio# GTE #LsDateFormat(now(),"yyyy")# OR #vpAnio# EQ 0>
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <tr>
                                        <cfoutput>
                                        <td colspan="2"><span class="Sans11ViNe"><em>AGREGAR NUEVO REGISTRO.....</em></span></td>
                                        <td align="center"><a href="comision_becas.cfm?vTipoComando=NUEVO&vSsnClave=7"><img src="#vCarpetaICONO#/agregar_15.jpg" width="15" height="15" style="border:none;" title="Agregar nuevo registro"></a></td>
                                        </cfoutput>
                                    </tr>
									<tr><td colspan="7" align="center"><hr></td></tr>
								</cfif>
							</cfif>
							<!-- Datos -->
							<cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
								<tr <cfif #tbCatalogoSesiones.ssn_id# EQ #Session.sSesion#> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse> onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
									<td class="Sans10Ne">#LSDateFormat(tbCatalogoSesiones.ssn_fecha,'MMMM, dd yyyy')#</td>
									<td class="Sans10Ne">#tbCatalogoSesiones.ssn_sede#</td>
									<!-- Botón VER -->
									<td>
										<a href="comision_becas.cfm?vSesionId=#tbCatalogoSesiones.ssn_id#&vTipoComando=CONSULTA&vSsnClave=7"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="#tbCatalogoSesiones.ssn_id#"></a>
									</td>
								</tr>
								<tr><td colspan="3" align="center"><hr></td></tr>
							</cfoutput>
						</table>
					</cfif>
					<br>
					<cfif #tbCatalogoSesiones.recordcount# GT 6>
						<table width="50%" border="0" align="center" class="CuadrosMarron">
							<cfoutput>
							<tr>
								<td width="23%" align="center">
									<cfif PageNum_sesiones GT 1>
										<a href="#CurrentPage#?PageNum_sesiones=1#QueryString_sesiones#" class="Sans10ViNe">Primero</a>
									</cfif>
								</td>
								<td width="31%" align="center">
									<cfif PageNum_sesiones GT 1>
										<a href="#CurrentPage#?PageNum_sesiones=#Max(DecrementValue(PageNum_sesiones),1)##QueryString_sesiones#" class="Sans10ViNe">Anterior</a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_sesiones LT TotalPages_sesiones>
										<a href="#CurrentPage#?PageNum_sesiones=#Min(IncrementValue(PageNum_sesiones),TotalPages_sesiones)##QueryString_sesiones#" class="Sans10ViNe">Siguiente</a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_sesiones LT TotalPages_sesiones>
										<a href="#CurrentPage#?PageNum_sesiones=#TotalPages_sesiones##QueryString_sesiones#" class="Sans10ViNe">Último</a>
									</cfif>
								</td>
							</tr>
							</cfoutput>
						</table>
					</cfif>
