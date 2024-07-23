<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 17/04/2009 --->

<!--- Si se pasó el comando "EDITA" o "CONSULTA" obtener los datos del registro seleccionado --->
<cfif  #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'CORRECCION'>
	<!--- Obtener información del movimiento --->
	<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos WHERE mov_id = #vIdMov# 
	</cfquery>
	<!--- Obtener información de la solicitud relacionada --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud_historia 
		<!---LEFT JOIN catalogo_movimiento ON movimientos_solicitud_historia.mov_clave = catalogo_movimiento.mov_clave --->
		WHERE sol_id = <cfif #tbMovimientos.sol_id# IS NOT ''>#tbMovimientos.sol_id#<cfelse>0</cfif>
	</cfquery>
	<!--- Obtener información del COA relacionado --->
	<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM convocatorias_coa WHERE coa_id = <cfif #tbMovimientos.coa_id# IS NOT ''>'#tbMovimientos.coa_id#'<cfelse>''</cfif>
	</cfquery>
</cfif>
<!--- Archivo PDF de documentación --->
<cfif #vTipoComando# EQ 'CONSULTA'>
	<!--- Obtener información de la sesión de pleno en que se dio una decisión al asunto --->
	<cfquery name="tbAsuntos" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_asunto 
		WHERE sol_id = <cfif #tbMovimientos.sol_id# IS NOT ''>#tbMovimientos.sol_id#<cfelse>0</cfif>
		AND asu_reunion = 'CTIC'
        ORDER BY ssn_id DESC
	</cfquery>
	<cfif #tbAsuntos.RecordCount# GT 0>
		<cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbAsuntos.ssn_id# & '.pdf'>
		<cfset vArchivoSolicitudPdf = #vCarpetaAcademicos# & #vArchivoPdf#>
		<cfset vArchivoSolicitudPdfWeb = #vWebAcademicos# & #vArchivoPdf#>
		<cfif FileExists(#vArchivoSolicitudPdf#)>
            <cfset vTextoArchivo = "Reenviar archivo">
        <cfelse>
            <cfset vTextoArchivo = "Enviar archivo">
        </cfif>
	</cfif>	
</cfif>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
		<style type="text/css">
			body
			{
				width: 160px;
				margin: 0px;
				padding: 0px;
			}
		</style>
		<script type="text/javascript">
			// Ejecutar un comando:
			function fEnviarComando(comando, vValida)
			{
				if (comando == 'NUEVO' || comando == 'EDITA' || comando == 'CORRECCION')
				{
					var vValidaOK = true;
					// Validar los datos del formulario:
					if (vValida) vValidaOK = parent.fValidar();
					// Si pasa todas la validación, enviar el comando y los datos del formulario:
					if (vValidaOK) 
					{
						// Actualizar los campos "vTipoComando":
						parent.document.getElementById('vTipoComando').value = comando;
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<parent.document.forms[0].elements.length; c++)
						{
							if (parent.document.forms[0].elements[c].type != 'hidden') parent.document.forms[0].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						parent.document.forms[0].submit();
					}	
				}
				else if (comando == "LIMPIA")
				{
					parent.document.forms[0].reset();
				}
				else if (comando == "ARCHIVOPDF")
				{
					var posTop = document.getElementById('cmdEnvioPdf').offsetTop;
					var posleft = document.getElementById('cmdEnvioPdf').offsetLeft;					
					parent.document.getElementById('ifrmSelArchivo').width = 515;
					parent.document.getElementById('ifrmSelArchivo').height = 200;
					parent.document.getElementById('ifrmSelArchivo').style.top = posTop + 'px';
					parent.document.getElementById('ifrmSelArchivo').style.left = '150px';
					parent.document.getElementById('ifrmSelArchivo').style.display = '';
				}
				else if (comando == "IMPRIME")
				{
					// Solución temporal hasta que ColdFusion permita procesar javascript con CFDOCUMENT:
					if (parent.print) 
					{
						parent.focus();
						parent.print();
					} 
					else 
					{
						var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
						parent.focus();
						parent.document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
						WebBrowser1.ExecWB(6, 1); // Utilizar "1" en lugar de "2" para que aparezca la ventanita de dialogo de impresión.
					}
					// Recargar la página:
					parent.location.reload(false);
					/*
					// Guardar los valores originales de action y target:					
					var vAction = parent.document.forms[0].action;
					var vTarget = parent.document.forms[0].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresión:
					parent.document.forms[0].action = 'mov_imprime.cfm';
					parent.document.forms[0].target = 'vista_preliminar_' + id
					parent.document.forms[0].submit();
					// Reestablecer los valores originales de action y target:
					parent.document.forms[0].action = vAction;
					parent.document.forms[0].target = vTarget;
					*/
				}
				else if (comando == "CANCELA")
				{
					<cfif #vTipoComando# IS 'NUEVO'>
						parent.document.forms[0].action = 'mov_elimina.cfm';
						parent.document.forms[0].submit();
					<cfelseif #vTipoComando# IS 'EDITA'>
						parent.document.getElementById('vTipoComando').value = "CONSULTA";
						parent.document.forms[0].action = 'movimiento.cfm';
						parent.document.forms[0].submit();
					<cfelse>
						// Regresar al módulo actual:
						parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					</cfif>
				}
				else if (comando == "REGRESA")
				{
					// Regresar al módulo actual:
					parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
				}
				<!----------------------------------------------------------------------------------------------------------------------->
				<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
				<!----------------------------------------------------------------------------------------------------------------------->
				<!--- Habilitar esta opción sólo si no es un registro nuevo y hay una solicitud relacionada (sino causa error) --->
				<cfif  #vTipoComando# NEQ 'NUEVO' AND #tbSolicitudes.RecordCount# GT 0>
					else if (comando == "SOLICITUD")
					{
						//alert('<cfoutput>#Application.vCarpetaRaiz#/sistema_ctic/asuntos/solicitudes/' + document.getElementById('vFt').value + '?vIdSol=#tbSolicitudes.sol_id#</cfoutput>')
						window.open('<cfoutput>#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/' + document.getElementById('vFt').value + '?vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA&vHistoria=1</cfoutput>','solicitud_relacionada', 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no')
					}
					else if (comando == "SOLICITUDIMP")
					{
						window.open('<cfoutput>#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/ft_pantallas/ft_imprime_historia.cfm?vIdSol=#tbSolicitudes.sol_id#&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#</cfoutput>','solicitud_relacionada', 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					}
				</cfif>
			}
			// FUNCIÓN PARA ELIMINAR REGISTROS
			function EliminaRegistro()
			{
				if (confirm('¿En realidad desea eliminar permanentemente la solicitud que aparece en pantalla?'))
				{
					parent.document.forms[0].action = 'mov_elimina.cfm';
					parent.document.forms[0].submit();
				}
			}
			// Preparar el formulario para enviar a impersión:
			function PrepararImpresion()
			{
				// Reemplazar los controles TEXT y TEXTAREA por un SPAN (para evitar que se trunquen los datos):
				c = 0
				while (c < parent.document.forms[0].elements.length)
				{
					if (parent.document.forms[0].elements[c].type == 'text' || parent.document.forms[0].elements[c].type == 'textarea') 
					{
						var cInput = parent.document.forms[0].elements[c];
						var cSpan = document.createElement("span");
						// Crear un SPAN con el contenido original:
						cSpan.className = "Sans9Gr";
						cSpan.innerHTML = parent.document.forms[0].elements[c].value;
						// Remplazar el control anterior por el nuevo control:
						cInput.parentNode.replaceChild(cSpan, cInput);
					}
					else
					{
						c++;
					}
				}
			}
		</script>
	</head>
	<body>
		<table width="150" border="0">
			<tr>
				<td><div class="linea_menu"></div></td>
			</tr>
			<tr>
				<td><span class="Sans10NeNe">Men&uacute;:</span></td>
			</tr>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'NUEVO' OR #vTipoComando# EQ 'CORRECCION'>
				<!-- Opción: Guardar -->
				<tr>
					<td><input type="button" class="botones" value="Guardar" onClick="fEnviarComando('<cfoutput>#vTipoComando#</cfoutput>', true)"></td>
				</tr>
				<!-- Opción: Cancelar -->
				<tr>
					<td><input type="button" class="botones" value="Cancelar" onClick="fEnviarComando('CANCELA', false);"></td>
				</tr>
			</cfif>
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!-- Opción: Corregir -->
				<tr>
					<td><input type="button" class="botones" value="Corregir" onClick="fEnviarComando('EDITA', false)" <cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>></td>
				</tr>
				<!-- Opción: Imprimir -->
				<tr>
					<td><input type="button" class="botones" value="Imprimir" onClick="fEnviarComando('IMPRIME', false);"></td>
				</tr>
				<!--- 
				PENDIENTE: Lo implementaré después, por ahora solo se pueden editar los registros existentes.
				<!-- Nuevo -->
				<tr>
					<td><input type="button" class="botones" value="Nuevo" onclick="NuevoRegistro();"></td>
				</tr>
				--->
				<!---
				<!-- Navegación -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
				</tr>
				<!-- Menú principal -->
				<tr>
					<td>
						<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
					</td>
				</tr>
				--->
				<!-- Opción: Regresar -->
				<tr>
					<td><input type="button" class="botones" value="Regresar" onClick="fEnviarComando('REGRESA', false);"></td>
				</tr>
				<!--- SE CAMBIÓ DE POSICIÓN EL BOTÓN DE ELIMINAR PARA EVITAR ELIMINAR EL REGISTRO POR ERROR 03/04/2019 --->
				<tr height="20px"><td></td></tr>
				<!-- Opción: Eliminar -->
				<tr>
					<td><input type="button" class="botones" value="Eliminar" onClick="EliminaRegistro();" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
				</tr>                
			</cfif>
			<!--- Datos relacionados gurdados en otras tablas --->
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!------------------------------------------------------------------------------------------------------------------------------------->
				<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
				<!------------------------------------------------------------------------------------------------------------------------------------->
				<!--- La consulta de la FT relacionada es redundante pues exite una copia idéntica en la documentación del asunto. Además, al generar 
					  la FT ""al vuelo" los datos calculados se generan considerando la fecha de la consulta. Por esta razón, se ha deshabilitado esta 
					  opción de la consulta. --->
				
				<!-- Solicitud relaciondada -->
				<cfif #tbSolicitudes.RecordCount# GT 0 AND #Session.sTipoSistema# IS 'stctic'>
					<!--- Obtener información del movimiento --->
					<cfquery name="ctMovimientos" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM catalogo_movimiento 
						WHERE mov_clave = #tbMovimientos.mov_clave# 
					</cfquery>
					<tr><td><div class="linea_menu"></div></td></tr>
					<tr><td height="15"></td></tr>
					<!-- Título de la opción -->
					<tr>
						<td><span class="Sans9NeNe">Solicitud original relacionada:</span><br></td>
					</tr>
					<!-- Descripción -->
					<tr>
						<td><span class="Sans9Vi" align="justify">Est&aacute; disponible la solicitud que dio origen al movimiento.</span></td>
					</tr>
					<!-- Botón -->
					<tr>
						<td>
							<input type="button" class="botones" value="Consultar" onClick="fEnviarComando('SOLICITUD', false);">
							<input type="hidden" name="vFt" id="vFt" value="<cfoutput>#ctMovimientos.mov_ruta#</cfoutput>">
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" class="botones" value="Imprimir" onClick="fEnviarComando('SOLICITUDIMP', false);">
						</td>
					</tr>
				</cfif>
				
				<!-- Convocatoria COA relacionada -->
				<cfif #tbConvocatorias.RecordCount# GT 0>
					<tr><td height="15"></td></tr>
					<tr><td><div class="linea_menu"></div></td></tr>
					<!-- Título de la opción -->
					<tr>
						<td><span class="Sans9NeNe">Convocatoria relacionada:</span><br></td>
					</tr>
					<!-- Descripción -->
					<tr>
						<td><span class="Sans9Vi" align="justify">Est&aacute; disponible la convocatoria relacionada al movimiento.</span></td>
					</tr>
					<!-- Botón -->
					<tr>
						<td>
							<input type="button" class="botones" value="Consultar" onClick="alert('Lo sentimos, la opción seleccionada aún no está disponible.');">
						</td>
					</tr>
				</cfif>
			</cfif>
			<!-- Documentación digitalizada -->
			<cfif #vTipoComando# EQ 'CONSULTA' AND #tbMovimientos.mov_clave# IS NOT 40 AND #tbMovimientos.mov_clave# IS NOT 41>
				<!-- Enviar Archivo -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans9NeNe">Documentos digitalizados:</span></td>
				</tr>
				<!-- Indicador de la existencia de la documentación digitalizada -->
				<tr id="ExisteArchivoPDF" <cfif NOT FileExists(#vArchivoSolicitudPdf#)>style="display:none;"</cfif>>
					<td>
						<table>
							<tr>	
								<td>
									<cfoutput>
										<a id="LigaArchivoPDF" href="#vArchivoSolicitudPdfWeb#" target="_blank">
											<img src="#vCarpetaIMG#/pdf.png" width="30" style="border:none; cursor:pointer;" title="Archivo PDF disponible">
										</a>
									</cfoutput>
								</td>
								<td class="Sans9Vi"> 
									Est&aacute; disponible la documentaci&oacute;n del asunto.
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Indicador de falta de documentación digitalizada -->
				<tr id="NoExisteArchivoPDF" <cfif FileExists(#vArchivoSolicitudPdf#)>style="display:none;"</cfif>>
					<td>
						<table>
							<tr>	
								<td>
									<img src="<cfoutput>#vCarpetaIMG#/pdfx.png</cfoutput>" width="30" style="border:none;" title="Archivo PDF disponible">
								</td>
								<td class="Sans9Vi"> 
									No est&aacute; disponible la documentaci&oacute;n del asunto.
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<cfif #Session.sTipoSistema# IS 'stctic'>
					<tr>
						<td><input id="cmdEnvioPdf" type="button" class="botones" style="position:relative;" value="<cfoutput>#vTextoArchivo#</cfoutput>" onClick="fEnviarComando('ARCHIVOPDF', false);"></td>
					</tr>
				</cfif>
			</cfif>
			<!-- Otros datos -->
			<tr><td height="15"></td></tr>
			<cfoutput>
				<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'CORRECCION'>
					<cfif #tbMovimientos.cap_fecha_crea# NEQ "">
						<!-- Fecha de alta -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans9GrNe">Alta:</span><br><span class="Sans9Vi">#LSDateFormat(tbMovimientos.cap_fecha_crea,"DD/MM/YYYY")# #LSTimeFormat(tbMovimientos.cap_fecha_crea,"HH:mm")#hrs</span></td>
						</tr>
					</cfif>
					<cfif #tbMovimientos.cap_fecha_mod# NEQ ''>
						<!-- Última modificación -->
						<tr>
							<td><span class="Sans9GrNe">&Uacute;ltima modificaci&oacute;n: </span><br><span class="Sans9Vi">#LSDateFormat(tbMovimientos.cap_fecha_mod,'DD/MM/YYYY')# #LSTimeFormat(tbMovimientos.cap_fecha_mod,'HH:mm')#hrs</span></td>
						</tr>
					</cfif>
					<!-- Número de registro -->
					<tr>
						<td><span class="Sans9GrNe">Número de registro:</span><br><span class="Sans9Vi">#tbMovimientos.mov_id#</span></td>
					</tr>	
					<!-- Solicitud relacionada -->
					<tr>
						<td><span class="Sans9GrNe">Solicitud relacionada:</span><br><span class="Sans9Vi"><cfif #tbMovimientos.sol_id# IS NOT ''>#tbMovimientos.sol_id#<cfelse>No existe</cfif></span></td>
					</tr>	
				</cfif>
			</cfoutput>
		</table>
	</body>
</html>