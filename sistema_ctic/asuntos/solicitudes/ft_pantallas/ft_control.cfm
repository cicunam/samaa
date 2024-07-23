<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 20/11/2020 --->
<!--- DATOS DE CONTROL DEL ASUNTO --->

<cfif #vSolStatus# LT 3>
    <!--- Obtiene el listado de las dos últimas sesiones y las tres posteriores --->
	<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM sesiones
		WHERE ssn_id BETWEEN #vActa# - 2 AND #vActa# + 2
        AND ssn_clave = 1
        ORDER BY ssn_id DESC
	</cfquery>
    
	<!--- Obtener la recomendación de la CAAA --->
	<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_asunto
		WHERE sol_id = #vIdSol# 
		AND ssn_id = #vActa# 
		AND asu_reunion = 'CAAA'
	</cfquery>
    
	<!--- Obtener el decisión del CTIC --->
	<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_asunto
		WHERE sol_id = #vIdSol# 
		AND ssn_id = #vActa# 
		AND asu_reunion = 'CTIC'
	</cfquery>

	<!--- Obtener datos del catálogo RECOMNEDACIONES / DECICIONES de movimientos --->
	<cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_decision
		<cfswitch expression="#vFt#">
			<!--- Asuntos que reciben recomendación de RATIFICAR --->
			<cfcase value="5,7,8,9,10,15,17,18,19,28">
				WHERE dec_descrip NOT LIKE '%APROBAR%'
			</cfcase>
			<!--- Asuntos que reciben recomendación de APROBAR --->
			<cfdefaultcase>
				WHERE dec_descrip NOT LIKE '%RATIFICAR%'
			</cfdefaultcase>
		</cfswitch>
		ORDER BY dec_orden
	</cfquery>

	<!--- Obtiene los miembros de la CAAA vigentes para revisar los asuntos --->
	<cfquery name="ctMiembroCAAA" datasource="#vOrigenDatosSAMAA#">
        SELECT ISNULL(academicos.acd_apepat,'') + ' ' + ISNULL(academicos.acd_apemat,'') + ' ' + ISNULL(academicos.acd_nombres,'') AS vNombre, comision_acd_id
        FROM (academicos_comisiones
        LEFT JOIN academicos ON academicos_comisiones.acd_id = academicos.acd_id)
        WHERE (academicos_comisiones.status = 1 AND academicos_comisiones.comision_clave = 1) OR (academicos_comisiones.ssn_id = #Session.sSesion#)
        ORDER BY academicos.acd_apepat, academicos.acd_apemat DESC
	</cfquery>

	<!--- Miembro de la CAAA al que se asigno la solicitud o asunto --->
	<cfquery name="tbAsignadoCAAA" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM (movimientos_solicitud_comision AS T1
		LEFT JOIN academicos_comisiones AS T2 ON T1.comision_acd_id = T2.comision_acd_id)
        WHERE T1.sol_id = #vIdSol#
		AND T1.ssn_id = #vActa#
	</cfquery>

    <!--- Obtener los rubros del listado para asignar las solicitudes  --->
    <cfquery name="ctListadoRubro" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM catalogo_listado
        WHERE parte_status = 1
        ORDER BY parte_numero
    </cfquery>
</cfif>
<cfoutput>
	<!--- Datos de control del registro --->
	<!-- Script para actualizar la información de control -->
	<script type="text/javascript">
		function fActualizaControl(vParte)
		{
			// Crear un objeto XmlHttpRequest:
			var xmlHttp = XmlHttpRequest();
			// Generar una petición HTTP:
			xmlHttp.open("POST", "ft_ajax/actualizar_control.cfm", false);
			xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
			// Crear la lista de parámetros (obligatorios):
			parametros = "vParte=" + encodeURIComponent(vParte);
			parametros += "&vIdSol=" + encodeURIComponent('#vIdSol#');
			parametros += "&vStatus=" + encodeURIComponent('#vSolStatus#');
			parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
			// Crear la lista de parámetros (opcionales):
			if (vParte == 'SeccionCAAA') parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccionCAAA').value);
			if (vParte == 'AsuntoCAAA') parametros += "&vAsunto=" + encodeURIComponent(document.getElementById('vAsuntoCAAA').value);
			if (vParte == 'AsignaCAAA') parametros += "&vAsignaCAAA=" + encodeURIComponent(document.getElementById('vAsignaCAAA').value);
			if (vParte == 'RecCAAA') parametros += "&vRecCAAA=" + encodeURIComponent(document.getElementById('vRecCAAA').value);
			if (vParte == 'ComentarioCAAA') parametros += "&vComentario=" + encodeURIComponent(document.getElementById('vComentarioCAAA').checked ? 'Si': 'No');
			if (vParte == 'NotasCAAA') parametros += "&vNotas=" + encodeURIComponent(document.getElementById('vNotasCAAA').value);
			if (vParte == 'SeccionCTIC') parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccionCTIC').value);
			if (vParte == 'AsuntoCTIC') parametros += "&vAsunto=" + encodeURIComponent(document.getElementById('vAsuntoCTIC').value);
			if (vParte == 'DecCTIC') parametros += "&vDecCTIC=" + encodeURIComponent(document.getElementById('vDecCTIC').value);
			if (vParte == 'AsuComentaCTIC') parametros += "&vAsuComentarioCTIC=" + encodeURIComponent(document.getElementById('vAsuComentarioCTIC').value);			
			
			// Es necesario validar la fecha de oficio antes de tratar de actualizarla:
			if (vParte == 'FechaOficio') {
				if (fValidaFecha('vFechaOficio', 'OFICIO') == '') parametros += "&vFechaOficio=" + encodeURIComponent(document.getElementById('vFechaOficio').value);
			}
			if (vParte == 'Sintesis') parametros += "&vSintesis=" + encodeURIComponent(document.getElementById('vSintesis').value);
			if (vParte == 'Observa') parametros += "&vObserva=" + encodeURIComponent(document.getElementById('vObserva').value);
			// Enviar la petición HTTP:
			xmlHttp.send(parametros);
		}
		function fDesplegable(vTipo, vAccion)
		{
			if (vTipo == 'CAAA')
			{
				if (vAccion == 0)
				{
					document.getElementById('dCAAA').style.display = 'none';
					document.getElementById('bCAAA').innerHTML = "<img src=\"#vCarpetaIMG#/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CAAA',1);\">";
				}
				else
				{
					document.getElementById('dCAAA').style.display = '';
					document.getElementById('bCAAA').innerHTML = "<img src=\"#vCarpetaIMG#/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CAAA',0);\">";
				}
			}
			else if (vTipo == 'CTIC')
			{
				if (vAccion == 0)
				{
					document.getElementById('dCTIC').style.display = 'none';
					document.getElementById('bCTIC').innerHTML = "<img src=\"#vCarpetaIMG#/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CTIC',1);\">";
				}
				else
				{
					document.getElementById('dCTIC').style.display = '';
					document.getElementById('bCTIC').innerHTML = "<img src=\"#vCarpetaIMG#/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('CTIC',0);\">";
				}
			}
			else if (vTipo == 'SINTE')
			{
				if (vAccion == 0)
				{
					document.getElementById('dSINTE').style.display = 'none';
					document.getElementById('bSINTE').innerHTML = "<img src=\"#vCarpetaIMG#/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('SINTE',1);\">";
				}
				else
				{
					document.getElementById('dSINTE').style.display = '';
					document.getElementById('bSINTE').innerHTML = "<img src=\"#vCarpetaIMG#/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('SINTE',0);\">";
				}
			}
			else if (vTipo == 'OBSERVA')
			{
				if (vAccion == 0)
				{
					document.getElementById('dOBSERVA').style.display = 'none';
					document.getElementById('bOBSERVA').innerHTML = "<img src=\"#vCarpetaIMG#/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('OBSERVA',1);\">";
				}
				else
				{
					document.getElementById('dOBSERVA').style.display = '';
					document.getElementById('bOBSERVA').innerHTML = "<img src=\"#vCarpetaIMG#/ir_arriba_15.jpg\" style=\"border:none;\" onclick=\"fDesplegable('OBSERVA',0);\">";
				}
			}
		}
	</script>
	<!-- Número de sesión asiganada la solicitud -->
	<table id="DatosSESION" width="100%" border="0" class="cuadros" bgcolor="##EEEEEE">
		<tr>
			<!-- Número de solicitud -->
			<td width="115"><span class="Sans9GrNe">Número de solicitud</span></td>
			<td><input type="text" size="6" class="datos" value="#vIdSol#" disabled></td>
			<!-- Sesión a la que está asignada -->
			<td align="right"><span class="Sans9GrNe">Asunto asignado a la sesión</span></td>
			<td width="70" align="right">
				<select name="vActa" id="vActa" class="datos" onchange="fActualizaControl('Acta');">
                    <cfloop query="tbSesiones">
					    <option value="#tbSesiones.ssn_id#" <cfif #vActa# EQ #tbSesiones.ssn_id#>selected</cfif>>#tbSesiones.ssn_id#</option>
                    </cfloop>
				</select>
	        </td>
		</tr>
	</table>
	<!-- Datos de la sesión de pleno del CTIC -->
	<cfif #vSolStatus# LTE 1>
		<table width="100%" border="0" class="cuadros" bgcolor="##EEEEEE">
			<!-- Encabezado -->
			<tr bgcolor="##CCCCCC">
				<td width="605" colspan="3"><div align="center" class="Sans10NeNe">SESI&Oacute;N ORDINARIA DEL PLENO</div></td>
				<td width="15" align="right"><div id="bCTIC"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onclick="fDesplegable('CTIC',1);"></div></td>
			</tr>
			<tbody id="dCTIC" style="display:none;">
				<tr><td colspan="4" height="5"></td></tr>
				<!-- Sección en el listado -->
				<tr>
					<td width="180"><span class="Sans9GrNe"> Secci&oacute;n en el listado <!--de Recomendaciones--></span></td>
					<td width="460" colspan="2">
						<!--- NOTA: Obtener esta lista del cat&aacute;logo de partes --->
						<select name="vSeccionCTIC" id="vSeccionCTIC" class="datos" onchange="fActualizaControl('SeccionCTIC');" <cfif #vFt# IS 31 OR #vFt# IS 40 OR  #vFt# IS 41>disabled</cfif>>
							<!--- Seleccionar la secci&oacute;n del listado actual --->
                            <cfloop query="ctListadoRubro">
							    <option value="#ctListadoRubro.parte_numero#" <cfif #tbAsuntosCTIC.asu_parte# EQ #ctListadoRubro.parte_numero#>selected</cfif>>#ctListadoRubro.parte_romano#</option>
                            </cfloop>
<!---
							<option value="1" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 1>selected</cfif>>I</option>
							<option value="2.1" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 2.1>selected</cfif>>II.I</option>
							<option value="2.2" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 2.2>selected</cfif>>II.III</option>
							<option value="3" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 3>selected</cfif>>III</option>
							<option value="3.1" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 3.1>selected</cfif>>III.I</option>
							<option value="3.2" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 3.2>selected</cfif>>III.II</option>
							<option value="3.4" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 3.4>selected</cfif>>III.IV</option>
							<option value="4.1" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 4.1>selected</cfif>>IV.I</option>
							<option value="4.2" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 4.2>selected</cfif>>IV.III</option>
							<option value="5" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 5>selected</cfif>>V</option>
							<option value="6" <cfif #Val(tbAsuntosCTIC.asu_parte)# EQ 6>selected</cfif>>VI</option>
--->
						</select>
					</td>
					<td></td>
				</tr>
				<!-- Número de asunto -->
				<tr>
					<td width="180"><span class="Sans9GrNe">N&uacute;mero de asunto</span></td>
					<td colspan="2"><cfinput name="vAsuntoCTIC" id="vAsuntoCTIC" type="text" size="3" maxlenght="3" class="datos" value="#tbAsuntosCTIC.asu_numero#" onchange="fActualizaControl('AsuntoCTIC');"></td>
					<td></td>
				</tr>
				<!-- Decisión del CTIC -->
				<tr>
					<td width="180"><span class="Sans9GrNe">Decisi&oacute;n del CTIC</span></td>
					<td colspan="2">
						<cfselect name="vDecCTIC" id="vDecCTIC" class="datos100" query="ctDecision" value="dec_clave" display="dec_descrip" selected="#tbAsuntosCTIC.dec_clave#" queryPosition="below" onchange="fActualizaControl('DecCTIC');" disabled="#Iif(vFt IS 31,DE("disabled"),DE(""))#">
							<option value="" selected="selected">NINGUNA</option>
			       		</cfselect>
					</td>
					<td></td>
				</tr>
				<!-- Número de oficio -->
				<tr>
					<td width="180"><span class="Sans9GrNe">Número de oficio</span></td>
					<td width="300">
						<cfinput type="text" name="vNoOficio" id="vNoOficio" value="#tbAsuntosCTIC.asu_oficio#" class="datos" disabled="disabled">
					</td>
					<!-- Fecha del oficio --->
					<td width="180" align="right">
						<cfif #vFt# IS 31>
							<span class="Sans9GrNe">Fecha del oficio &nbsp;&nbsp;&nbsp;</span>
							<cfinput type="text" name="vFechaOficio" id="vFechaOficio" size="10" value="#LsDateFormat(tbAsuntosCTIC.asu_fecha_oficio,'dd/mm/yyyy')#" class="datos" onkeypress="return MascaraEntrada(event, '99/99/9999');" onchange="fActualizaControl('FechaOficio');">
						</cfif>
					</td>
					<td></td>
				</tr>
				<tr>
					<td width="180"><span class="Sans9GrNe">Comentario oficio</span></td>
					<td colspan="2">
						<cftextarea name="vAsuComentarioCTIC" id="vAsuComentarioCTIC" rows="3" class="datos100" value="#tbAsuntosCTIC.asu_oficio_comenta#" disabled=#Iif(vFt IS 31,DE("disabled"),DE(""))# onchange="fActualizaControl('AsuComentaCTIC');"></cftextarea>
					</td>
					<td></td>                    
				</tr>
			</tbody>
		</table>
	</cfif>
	<!-- Datos de la reunión de la CAAA -->
	<cfif #vFt# NEQ 14 AND #vFt# NEQ 31 AND #vFt# NEQ 35 AND #vFt# NEQ 40 AND #vFt# NEQ 41 AND #vFt# NEQ 61 AND #vFt# NEQ 62>
		<table width="100%" border="0" class="cuadros" bgcolor="##EEEEEE">
			<!-- Encabezado -->
			<tr bgcolor="##CCCCCC">
				<td width="605" colspan="2"><div align="center" class="Sans10NeNe">COMISI&Oacute;N DE ASUNTOS ACAD&Eacute;MICO-ADMINISTRATIVOS</div></td>
				<td width="15" align="right"><div id="bCAAA"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onclick="fDesplegable('CAAA',1);"></div></td>
			</tr>
			<tbody id="dCAAA" style="display:none;">
				<tr><td colspan="3" height="5"></td></tr>
				<!-- Sección en el listado -->
				<tr>
					<td width="180"><span class="Sans9GrNe"> Secci&oacute;n en el listado <!--CAAA--></span></td>
					<td width="460"><!--- NOTA: Obtener esta lista del cat&aacute;logo de partes --->
						<select name="vSeccionCAAA" id="vSeccionCAAA" class="datos" onchange="fActualizaControl('SeccionCAAA');" <cfif #vSolStatus# LTE 1>disabled</cfif>>
							<!--- Seleccionar la secci&oacute;n del listado actual --->
                            <cfloop query="ctListadoRubro">
							    <option value="#ctListadoRubro.parte_numero#" <cfif #tbAsuntosCAAA.asu_parte# EQ #ctListadoRubro.parte_numero#>selected</cfif>>#ctListadoRubro.parte_romano#</option>
                            </cfloop>
<!---
			                <option value="1" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 1>selected</cfif>>I</option>
			                <option value="2.1" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 2.1>selected</cfif>>II.I</option>
			                <option value="2.2" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 2.2>selected</cfif>>II.II</option>
			                <option value="3" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 3>selected</cfif>>III</option>
			                <option value="3.1" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 3.1>selected</cfif>>III.I</option>
			                <option value="3.2" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 3.2>selected</cfif>>III.II</option>
			                <option value="3.4" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 3.4>selected</cfif>>III.IV</option>
			                <option value="4.1" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 4.1>selected</cfif>>IV.I</option>
			                <option value="4.2" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 4.2>selected</cfif>>IV.II</option>
			                <option value="5" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 5>selected</cfif>>V</option>
			                <option value="6" <cfif #Val(tbAsuntosCAAA.asu_parte)# EQ 6>selected</cfif>>VI</option>
--->
						</select>
					</td>
					<td></td>
				</tr>
				<!-- Número de asunto -->
				<tr>
					<td><span class="Sans9GrNe">N&uacute;mero de asunto</span></td>
					<td><cfinput name="vAsuntoCAAA" id="vAsuntoCAAA" type="text" size="3" maxlenght="3" class="datos" value="#tbAsuntosCAAA.asu_numero#" disabled="#Iif(vSolStatus LTE 1,DE("disabled"),DE(""))#" onchange="fActualizaControl('AsuntoCAAA');"></td>
					<td></td>
				</tr>
				<!-- Miembro de la CAAA al que se le asigna la revisión del asunto --->
				<cfif #vFt# NEQ 40 AND #vFt# NEQ 41>
					<tr>
						<td><span class="Sans9GrNe">Asignar a miembro de la CAAA</span></td>
						<td>
				        	<cfselect name="vAsignaCAAA" id="vAsignaCAAA2" class="datos100" query="ctMiembroCAAA" queryPosition="below" display="vNombre" value="comision_acd_id" selected="#tbAsignadoCAAA.comision_acd_id#" disabled="#Iif(vSolStatus LTE 1,DE("disabled"),DE(""))#" onchange="fActualizaControl('AsignaCAAA');">
								<option value="" selected="selected">NINGUNO</option>
							</cfselect>
						</td>
						<td></td>
					</tr>
				</cfif>
				<!-- Recomandación de la CAAA -->
				<tr>
					<td><span class="Sans9GrNe">Recomendaci&oacute;n <cfif #tbAsuntosCAAA.asu_parte# EQ 3>de la CAAA</cfif>
	                </span></td>
					<td>
			        	<cfselect name="vRecCAAA" id="vRecCAAA" class="datos100" query="ctDecision" value="dec_clave" display="dec_descrip" selected="#tbAsuntosCAAA.dec_clave#" queryPosition="below" onchange="fActualizaControl('RecCAAA');">
							<option value="" selected="selected">NINGUNA</option>
						</cfselect>
					</td>
					<td></td>
				</tr>
				<!-- Comentarios -->
				<cfif #vFt# NEQ 40 AND #vFt# NEQ 41>
				<tr>
					<td><span class="Sans9GrNe">Comentarios</span></td>
					<td>
						<cfinput id="vComentarioCAAA" name="vComentarioCAAA" type="checkbox" value="Si" checked="#Iif(tbAsuntosCAAA.asu_comentario IS 1,DE("yes"),DE("no"))#" onclick="fActualizaControl('ComentarioCAAA'); if (this.checked) document.getElementById('vNotasCAAA').disabled = false; else document.getElementById('vNotasCAAA').disabled = true;">
					</td>
					<td></td>
				</tr>
				<!-- Notas -->
				<tr>
					<td valign="top"><span class="Sans9GrNe"><!-- Espacio disponible --></span></td>
					<td>
						<cftextarea name="vNotasCAAA" id="vNotasCAAA" rows="3" class="datos100" value="#tbAsuntosCAAA.asu_notas#" disabled="#Iif(tbAsuntosCAAA.asu_comentario NEQ 1,DE("disabled"),DE(""))#" onchange="fActualizaControl('NotasCAAA');"></cftextarea>
					</td>
					<td></td>
			    </tr>
	            </cfif>
			</tbody>
		</table>
	</cfif>
	<!-- Sintesis -->
	<table width="100%" border="0" class="cuadros" bgcolor="##EEEEEE">
		<!-- Encabezado -->
		<tr bgcolor="##CCCCCC">
			<td width="605"><div align="center" class="Sans10NeNe">SINTESIS</div></td>
			<td width="15" align="right"><div id="bSINTE"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onclick="fDesplegable('SINTE',1);"></div></td>
		</tr>
		<tbody id="dSINTE" style="display:none;">
			<tr><td colspan="2" height="5"></td></tr>
			<!-- Texto -->
			<tr>
				<td>
					<span class="Sans9GrNe">Sintesis del asunto (tal y como aparecer&aacute; en la lista de asuntos)<br></span>
					<cftextarea name="vSintesis" id="vSintesis" rows="5" class="datos100" value="#vSolSintesis#" onchange="fActualizaControl('Sintesis');"></cftextarea>
				</td>
				<td></td>
			</tr>
		</tbody>
	</table>
	<!-- Observaciones -->
	<table width="100%" border="0" class="cuadros" bgcolor="##EEEEEE">
		<!-- Encabezado -->
		<tr bgcolor="##CCCCCC">
			<td width="605"><div align="center" class="Sans10NeNe">OBSERVACIONES</div></td>
			<td width="15" align="right"><div id="bOBSERVA"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" style="border:none;" onclick="fDesplegable('OBSERVA',1);"></div></td>
		</tr>
		<tbody id="dOBSERVA" style="display:none;">
			<tr><td colspan="2" height="5"></td></tr>
			<!-- Texto -->
			<tr>
				<td>
					<span class="Sans9GrNe">Observaciones a la solicitud<br></span>
					<cftextarea name="vObserva" id="vObserva" rows="5" class="datos100" value="#vSolObserva#" onchange="fActualizaControl('Observa');"></cftextarea>
				</td>
				<td></td>
		    </tr>
		</tbody>
	</table>
</cfoutput>
<!--- Abrir de manera predeterminada el menú de la CAAA o del Pleno, según el caso --->
<script type="text/javascript">
	<cfif #vSolStatus# EQ 2>
		fDesplegable('CAAA', 1);
	<cfelseif #vSolStatus# LT 2>
		fDesplegable('CTIC', 1);
	</cfif>
</script>