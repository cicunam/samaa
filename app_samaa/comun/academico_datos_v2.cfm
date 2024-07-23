<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 15/09/2014 --->
<!--- FECHA ÚLTIMA MOD.: 02/12/2015 --->

<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Parámetros --->
<cfparam name="vAcadId" default="0">
<cfparam name="vRfcAcad" default="">
<cfparam name="vSelAcad" default="">
<cfparam name="PageNum_tbMovimientos" default="1">
<cfset vAnioActual = #VAL(LsDateFormat(now(),'yyyy'))#>

<!--- Obtener datos del académico --->
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

<!--- Cuenta los días ocupados por licencias menores a 22 días --->
<cfquery name="dbLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) + 1) AS vDiasLic 
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vAcadId# 
	AND (mov_clave = 24 OR mov_clave = 41) 
	AND YEAR(mov_fecha_inicio) = #vAnioActual# 
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'
	AND (mov_cancelado = 0 OR mov_cancelado IS NULL)
</cfquery>

<!--- Cuenta los días ocupados por licencias menores a 22 días --->
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

<!--- Datos del académico --->
<cfif #tbAcademicos.RecordCount# GT 0>
	<cfoutput>
		<table style="width:100%; margin: 10px 0px 2px 15px; border: none" cellspacing="0" cellpadding="1">
			<!-- Nombre del académico -->
			<tr>
				<td width="55%" valign="top">
					<span class="Sans12GrNe">#tbAcademicos.acd_prefijo# #tbAcademicos.acd_nombres# #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat#</span><br>
							<!-- Dependencia de adscripción -->
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
                              <td width="40%" height="18px"><span class="Sans10NeNe">Licencias con goce de sueldo:</span></td>
                              <td width="60%" height="18px">
                                  <span class="Sans10ViNe">
                                  <cfif #dbLicencias.vDiasLic# GT 0>#dbLicencias.vDiasLic#
                                    <cfelse>0
                                  </cfif>
                                  días
                                  </span>						
                              </td>
                          </tr>
                          <tr bgcolor="##F6F6F6">
                              <td><span class="Sans10NeNe">Comisiones menores a 22 d&iacute;as:</span></td>
                              <td>
                                  <span class="Sans10ViNe">
                                  <cfif #dbComisiones.vDiasCom# GT 0>#dbComisiones.vDiasCom#
                                    <cfelse>0
                                  </cfif>
                                  días
                                  </span>							
                              </td>
                          </tr>
                          <tr bgcolor="##F6F6F6" height="5px">
                              <td colspan="2"></td>
                          </tr>
					  </table>
					</cfif>
				</td>
				<td width="45%" align="right" valign="top">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr bgcolor="##F6F6F6">
							<td height="18px"><span class="Sans10NeNe">No. de académico (ID):</span></td>
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
					</table>
					<div id="sni_dynamic"><!-- INSERTA EL ÚLTIMO NIVEL EN EL SNI --></div>
					<div id="estimuloDgapa_dynamic"><!-- INSERTA EL NIVEL DEL ESTÍMULO DGAPA QUE APARECE EN LA ÚLTIMA NÓMINA CARGADA --></div>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr /></td>
			</tr>
		</table>
	</cfoutput>
</cfif>
