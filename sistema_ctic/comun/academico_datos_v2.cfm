<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 15/09/2014 --->
<!--- FECHA �LTIMA MOD.: 16/08/2023 --->

<!--- LISTA DE MOVIMIENTOS DE UN ACAD�MICO --->
<!--- Par�metros --->
<cfparam name="vAcadId" default="0">
<cfparam name="vRfcAcad" default="">
<cfparam name="vSelAcad" default="">
<cfparam name="PageNum_tbMovimientos" default="1">
<cfset vAnioActual = #VAL(LsDateFormat(now(),'yyyy'))#>

<!--- Obtener datos del acad�mico --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((academicos
	LEFT JOIN catalogo_dependencia ON academicos.dep_clave = catalogo_dependencia.dep_clave)
	LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave)
	LEFT JOIN catalogo_contrato ON academicos.con_clave = catalogo_contrato.con_clave
	<cfif IsDefined("vAcadId") AND #vAcadId# IS NOT ''>
		WHERE acd_id = #vAcadId#
	<cfelseif IsDefined("vRfcAcad") AND #vRfcAcad# IS NOT ''>
		WHERE acd_rfc = '#vRfcAcad#'
	<cfelseif IsDefined("vSelAcad") AND #vSelAcad# IS NOT ''>
		WHERE acd_id = #vSelAcad#
	<cfelse>
		WHERE 1 = 0
	</cfif>
</cfquery>

<!--- Cuenta los d�as ocupados por LICENCIAS menores a 22 d�as en MOVIMIENTOS --->
<cfquery name="dbLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) + 1) AS vDiasLic 
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vAcadId# 
	AND mov_clave = 41
	AND YEAR(mov_fecha_inicio) = #vAnioActual# 
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'
	AND (mov_cancelado = 0 OR mov_cancelado IS NULL)
</cfquery>

<!--- Cuenta los d�as ocupados por LICENCIAS menores a 22 d�as en SOLICITUDES (25/07/2019) --->
<cfquery name="dbSolLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, sol_pos14, sol_pos15) + 1) AS vDiasLic 
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vAcadId# 
	AND mov_clave = 41
	AND YEAR(sol_pos14) = #vAnioActual#
    AND sol_status < 4
</cfquery>

<!--- Cuenta los d�as ocupados por COMISIONES menores a 22 d�as en MOVIMIENTOS--->
<cfquery name="dbComisiones" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) + 1) AS vDiasCom 
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vAcadId# 
	AND mov_clave = 40
	AND YEAR(mov_fecha_inicio) = #vAnioActual# 
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'
	AND (mov_cancelado = 0 OR mov_cancelado IS NULL)
</cfquery>

<!--- Cuenta los d�as ocupados por COMISIONES menores a 22 d�as en SOLICITUDES (25/07/2019) --->
<cfquery name="dbSolComisiones" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, sol_pos14, sol_pos15) + 1) AS vDiasCom 
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vAcadId# 
	AND mov_clave = 40
	AND YEAR(sol_pos14) = #vAnioActual#
    AND sol_status < 4
</cfquery>
	

<!--- Datos del acad�mico --->
<cfif #tbAcademicos.RecordCount# GT 0>
	<cfoutput>
		<table style="width:100%; margin: 10px 0px 2px 15px; border: none" cellspacing="0" cellpadding="1">
			<!-- Nombre del acad�mico -->
			<tr>
				<td width="55%" valign="top">
					<span class="Sans12GrNe">#tbAcademicos.acd_prefijo# #tbAcademicos.acd_nombres# #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat#</span><br>
							<!-- Dependencia de adscripci�n -->
					<cfif #tbAcademicos.dep_nombre# IS NOT ''>
						<span class="Sans11GrNe"><i>#Ucase(tbAcademicos.dep_nombre)#</i></span>
					</cfif>
					<cfif #tbAcademicos.con_clave# LTE 3 AND #tbAcademicos.con_clave# GT 0 AND #tbAcademicos.activo# EQ 1>
						<hr />
					  <table border="0" cellpadding="0" cellspacing="0" width="100%">
                          <tr>
                              <td colspan="2" bgcolor="##F6F6F6">
                                  <i><span class="Sans10ViNe">D&Iacute;AS CON GOCE DE SUELDO DISFRUTADOS DURANTE EL A&Ntilde;O:</span></i>
                              </td>
						  </tr>
                          <!-- Informaci&oacute;n acad&eacute;mica (encabezados) -->
                          <tr bgcolor="##F6F6F6">
                              <td width="40%" height="18px"><span class="Sans10NeNe">Licencias con goce de sueldo*:</span></td>
                              <td width="60%" height="18px">
									<span class="Sans10ViNe">
										<div style="float:left; width:15%;">
											<cfif #dbLicencias.vDiasLic# GT 0>#dbLicencias.vDiasLic#
                                            <cfelse>0
                                            </cfif>
                                            d�as
										</div>
										<cfif #dbSolLicencias.vDiasLic# GT 0>
											<div style="float:left; width:85%; cursor:pointer;" title="Consultar solicitudes con d�as">+ #dbSolLicencias.vDiasLic# d�as de solicitudes en proceso</div>
										</cfif>
                                  </span>
                              </td>
                          </tr>
                          <tr bgcolor="##F6F6F6">
								<td><span class="Sans10NeNe">Comisiones menores a 22 d&iacute;as*:</span></td>
								<td>
									<span class="Sans10ViNe">
									<div style="float:left; width:15%;">
										<cfif #dbComisiones.vDiasCom# GT 0>#dbComisiones.vDiasCom#
										<cfelse>0
										</cfif>
										d�as
									</div>
									<cfif #dbSolComisiones.vDiasCom# GT 0>
										<div style="float:left; width:85%; cursor:pointer;" title="Consultar solicitudes con d�as">+ #dbSolComisiones.vDiasCom#  d�as de solicitudes en proceso</div>
									</cfif>
                                  </span>
								</td>
							</tr>
							<tr bgcolor="##F6F6F6" height="5px">
								<td colspan="2"></td>
							</tr>
<!---																  
							<tr>
								<td colspan="2" align="center">
									<cfoutput>
									<div class="divSolicitudesTramite">
										<table border="0" cellpadding="0" cellspacing="0" width="98%" style="margin-top:-1px;">
											<tr>
												<td align="right" width="70%" valign="middle">
													<span class="Sans10ViNe">SOLICITUDES EN TR�MITE: </span>
													<span class="Sans10NeNe">#tbSoliciudes.vCuentaSol#</span>
												</td>
												<td align="right" width="2%"></td>
												<td width="28%" valign="middle">
													<cfif #tbSoliciudes.vCuentaSol# GT 0>
														<img id="imgDetalleSolProceso" src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="Consultar solicitudes en tr�mite" onClick="fVentanaEmergeSolPorc();">
														<input type="hidden" id="acd_id" name="acd_id" value="#vAcadId#" />
													</cfif>													
												</td>												
											</tr>
										</table>
										<div id="ListaSolCons_jQuery"></div><!-- JQUERY: Formulario de captura de nuevo oponente -->
--->						  
<!---
									  <div style="height:20px; width:70%; float:left" align="right">
											<span class="Sans10ViNe">SOLICITUDES EN TR�MITE: </span>
											<span class="Sans10NeNe">#tbSoliciudes.vCuentaSol#</span>
										</div>
										<div style="height:18px; width:10%; float:left" align="center">
											<cfif #tbSoliciudes.vCuentaSol# GT 0>
												<img id="imgDetalleSolProceso" src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="Consultar solicitudes en tr�mite">
												<input type="hidden" id="acd_id" name="acd_id" value="#vAcadId#" />
											</cfif>
										</div>
									</div>
									</cfoutput>
								</td>
	
							</tr>
--->
					  </table>
					</cfif>
				</td>
				<td width="45%" align="right" valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr bgcolor="##F6F6F6">
							<td height="18px"><span class="Sans10NeNe">No. de acad�mico (ID):</span></td>
							<td>
                            	<span class="Sans10Ne">#tbAcademicos.acd_id#</span>
								<input name="vAcadId" id="vAcadId" value="#tbAcademicos.acd_id#" type="hidden" size="5" maxlength="5" class="datos">
							</td>
						</tr>
						<tr bgcolor="##F6F6F6">
							<td height="18px"><span class="Sans10NeNe">Tipo de contrato:</span></td>
							<td>
								<cfif #tbAcademicos.con_descrip# IS NOT ''>
									<span class="Sans10Ne">#tbAcademicos.con_descrip#</span>
								</cfif>			
							</td>
						</tr>
						<cfif #tbAcademicos.con_clave# LTE 3 AND #tbAcademicos.con_clave# GT 0>
							<!--- Informaci&oacute;n acad&eacute;mica (encabezados) --->
							<tr bgcolor="##F6F6F6">
								<td width="50%" height="18px"> <span class="Sans10NeNe">Categor&iacute;a y nivel:</span></td>
								<td width="50%">
									<cfif #tbAcademicos.cn_siglas# IS NOT ''>
										<span class="Sans10Ne">#tbAcademicos.cn_siglas#</span>
									</cfif>			
								</td>
							</tr>
							<tr bgcolor="##F6F6F6">
								<td colspan="2" height="18px"><div id="antigAcadSup_dynamic"><!-- inserta la antig&uuml;edad desede un AJAX--></div></td>
							</tr>
							<tr bgcolor="##F6F6F6">
								<td colspan="2" height="11px"></td>
							</tr>
						</cfif>
						<cfif (#tbAcademicos.con_clave# EQ 1 OR #tbAcademicos.con_clave# EQ 2 OR #tbAcademicos.con_clave# EQ 3 OR #tbAcademicos.con_clave# EQ 6 OR #tbAcademicos.con_clave# EQ 10)><!--- #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0 AND--->
                            <tr>
                                <td colspan="2" align="center" style="padding-top: 10px;">
                                    <cfform id="frmInfAcad" method="post" action="#vLigaInformacionAcad#" target="winConsultas">
                                        <div class="divInformacionAcad" onclick="document.forms['frmInfAcad'].submit();" title="Consultar la informaci�n reportada en la plataforma CISIC">
                                            CONSULTAR INFORMACI�N ACAD�MICA REPORTADA EN CISIC
                                            <cfinput type="hidden" id="acdid" name="acdid" value="#vAcadId#">
                                            <cfinput type="hidden" id="vpSistemaAcceso" name="vpSistemaAcceso" value="#ToBase64('SAMAA')#">
                                            <cfinput type="hidden" id="vpSistemaPass" name="vpSistemaPass" value="#ToBase64('?31101$Cic8282Sts;')#">
											<cfinput type="hidden" id="vpAnioConsulta" name="vpAnioConsulta" value="1999">
											<cfinput type="hidden" id="vpDatosPer" name="vpDatosPer" value="1">
                                        </div>
                                    </cfform>
                                </td>
                            </tr>
                        </cfif>
					</table>
					<div id="estimuloDgapa_dynamic"><!-- INSERTA EL NIVEL DEL EST�MULO DGAPA QUE APARECE EN LA �LTIMA N�MINA CARGADA --></div>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr /></td>
			</tr>
		</table>
	</cfoutput>
</cfif>
