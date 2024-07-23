<!---ELIMINAR SE REEMPLAZ� POR ft_include_menu.cfm --->

<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOS� ANTONIO ESTEVA --->
<!--- FECHA: 17/04/2009 --->
<!--- 
	NOTA: Deshabilit� la asignaci�n a una sesi�n desde este men� porque se complicaba demasiado el c�digo, 
	debido a la validaci�n necesaria para no asignar el asunto a una reuni�n de la CAAA ya celebrada
--->
<!--- Par�metros --->
<cfparam name="vIdSol" default="">
<!--- Obtener datos de la tabla de academicos --->
<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos WHERE acd_id = #vIdAcad# 
</cfquery>
<!--- Obtener datos del movimiento --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
</cfquery>
<!--- Obtener los art�culos del EPA en los que se fundamenta el movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art WHERE mov_clave = #vFt# ORDER BY mov_articulo
</cfquery>
<!--- Si se pas� el comando "EDITA" o "CONSULTA" obtener los datos del registro seleccionado --->
<cfif  #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA'>
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud WHERE sol_id = #vIdSol#
	</cfquery>
</cfif>
<!--- Archivo PDF de documentaci�n --->
<cfif #vTipoComando# EQ 'CONSULTA'>
	<cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
	<cfif #vSolStatus# GTE "3">
		<cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>
		<cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>
	<cfelse>
		<cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>
		<cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>
    </cfif>
	<cfif FileExists(#vArchivoSolicitudPdf#)>
        <cfset vTextoArchivo = "Reenviar archivo">
    <cfelse>
        <cfset vTextoArchivo = "Enviar archivo">
    </cfif>
</cfif>
<!---
<!--- Obtener la fecha de la reuni�n de la CAAA  para evitar que se asignen casos a una reuni�n ya se celebrada --->
<cfquery name="tbSesionesCAAA" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_clave = 4 AND ssn_id = #Session.sSesion#
</cfquery>
<cfif #tbSesionesCAAA.ssn_fecha_m# IS ''><!--- Si no cambi� la fecha de la sesi�n --->
	<cfset vFechaCAAA = #LsDateFormat(tbSesionesCAAA.ssn_fecha,"dd/mm/yyyy")#>
<cfelse>
	<cfset vFechaCAAA = #LsDateFormat(tbSesionesCAAA.ssn_fecha_m,"dd/mm/yyyy")#>
</cfif>
<!--- Obtenerla fecha de hoy para compararla con la anterior --->
<cfset vFechaHoy = #LsDateFormat(Now(),"dd/mm/yyyy")#>
--->
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="ft_ajax/xmlHttpRequest.js"></script>
		<style type="text/css">
			body {
				width: 160px;
				margin: 0px;
				padding: 0px;
			}
			table {
				margin: 0px;
				padding: 0px;
			}
		</style>
		<script type="text/javascript">
			// Ejecutar un comando:
			function fEnviarComando(comando, vValida)
			{
				var ValidaOK = true; // El valor predeterminado de la validaci�n es VERDADERO;
				
				if (comando == 'NUEVO' || comando == 'EDITA')
				{
					// Si existe la funci�n de validaci�n, ejecutarla:
					if (parent.fValidaCamposFt && vValida == true) ValidaOK = parent.fValidaCamposFt();
						
					// Si pasa todas la validaci�n, enviar el comando y los datos del formulario:
					if (ValidaOK) 
					{
						// Actualizar los campos "vTipoComando":
						parent.document.getElementById('vTipoComando').value = comando;
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<parent.document.forms[0].elements.length; c++)
						{
							if (parent.document.forms[0].elements[c].type != 'hidden') parent.document.forms[0].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						if (comando == 'NUEVO') parent.document.getElementById('vTipoComando').value = "NUEVO";
						parent.document.forms[0].submit();
					}
				}
				else if (comando == "LIMPIA")
				{
					parent.fLimpiaValida();
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
					// Guardar los valores originales de action y target:					
					var vAction = parent.document.forms[0].action;
					var vTarget = parent.document.forms[0].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresi�n:
					parent.document.forms[0].action = 'ft_imprime.cfm';
					parent.document.forms[0].target = 'vista_preliminar_' + id
					parent.document.forms[0].submit();
					// Reestablecer los valores originales de action y target:
					parent.document.forms[0].action = vAction;
					parent.document.forms[0].target = vTarget;
				}
				else if (comando == "IMPRIMEEJEMPLO")
				{
					// Guardar los valores originales de action y target:					
					var vAction = parent.document.forms[0].action;
					var vTarget = parent.document.forms[0].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresi�n:
					parent.document.forms[0].action = 'ft_imprime_ejemplo.cfm';
					parent.document.forms[0].target = 'vista_preliminar_' + id
					parent.document.forms[0].submit();
					// Reestablecer los valores originales de action y target:
					parent.document.forms[0].action = vAction;
					parent.document.forms[0].target = vTarget;
				}
				else if (comando == "ENVIA")
				{
					fEnviarSolicitud();
				}
				else if (comando == "CANCELA")
				{
					if ("<cfoutput>#vTipoComando#</cfoutput>" == "NUEVO")
					{
						parent.document.forms[0].action = 'ft_ctic_elimina.cfm';
						parent.document.forms[0].submit();
					}
					else
					{
						parent.document.forms[0].reset();
						// Actualizar los campos "vTipoComando":
						parent.document.getElementById('vTipoComando').value = "EDITA";
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<parent.document.forms[0].elements.length; c++)
						{
							if (parent.document.forms[0].elements[c].type != 'hidden') parent.document.forms[0].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						parent.document.forms[0].submit();
					}	
				}
				else if (comando == "BORRA")
				{
					if (confirm('�En realidad desea eliminar permanentemente la solicitud que aparece en pantalla?'))
					{
						parent.document.forms[0].action = 'ft_ctic_elimina.cfm';
						parent.document.forms[0].submit();
					}
				}
				else if (comando == "REGRESA")
				{
					// Regresar al m�dulo actual:
					parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>'); 
				}
			}
			// Ingresar una nueva solicitud:
			function NuevaSolicitud()
			{
				parent.window.location.replace('../ft_selecciona/select_ft_acad.cfm'); 
			}
			// Abrir la ventana emergente de documentos requeridos:
			function MostarDocumentosRequeridos()
			{
				window.open("ft_doc_art.cfm?vFt=<cfoutput>#vFT#</cfoutput>", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no");
			}
			<cfif #vTipoComando# EQ 'CONSULTA'>
				// Enviar solicitud:
				function fEnviarSolicitud()
				{
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petici�n HTTP:
					xmlHttp.open("POST", "../enviar_solicitud.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de par�metros:
					parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
					// Enviar la petici�n HTTP:
					xmlHttp.send(parametros);
					// Regresar al m�dulo actual:
					//parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					parent.window.location.reload();
				}
				// Devolver solicitud:
				function fDevolverSolicitud(vSituacion, vTipoDevolucion)
				{
					var vValorDevuelve = 0
					var vRazonDevuelve = '';
					// Permitir a la entidad editar y/o imprimir:
					if (vTipoDevolucion == 'IMPRIME' && document.getElementById('chkImprime').checked == true)
					{
						vValorDevuelve = 1
						vRazonDevuelve = 'Para editar y/o imprimir.';
					}
					// Permitir a la entidad re-enviar archivo PDF.
					if (vTipoDevolucion == 'ARCHIVO' && document.getElementById('chkArchivo').checked == true)
					{
						vValorDevuelve = 1
						vRazonDevuelve = 'Para re-enviar documentaci�n anexa (PDF).';
					}
					// En caso de una devoluci�n completa, capturar la raz�n de la devoluci�n:				
					if (vSituacion == 4) vRazonDevuelve = prompt('Describa brevemente la raz�n por la que se devuelve la Forma Telegr�mica.','');
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petici�n HTTP:
					xmlHttp.open("POST", "../devolver_solicitud.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de par�metros:
					parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
					parametros += "&vSituacion=" + encodeURIComponent(vSituacion);
					parametros += "&vTipoDevolucion=" + encodeURIComponent(vTipoDevolucion);
					parametros += "&vValorDevuelve=" + encodeURIComponent(vValorDevuelve);
					parametros += "&vRazonDevuelve=" + encodeURIComponent(vRazonDevuelve);
					// Enviar la petici�n HTTP:
					xmlHttp.send(parametros);
					// Regresar al m�dulo actual:
					if (vTipoDevolucion == 'IMPRIME' || vTipoDevolucion == 'ARCHIVO')
					{
						parent.window.location.reload();
					}
					else
					{
						parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					}
				}
				<!---
				// Asignar el asunto a un periodo de sesi�n:
				function fAsignarSesion()
				{
					var vFt = <cfoutput>#vFt#</cfoutput>;
					// No permitir asignar la solicitude a una reuni�n de la CAAA ya celebrada:
					if (vFt != 14 && vFt != 31 && vFt != 35 && vFt != 40 && vFt != 41 && vFt != 61 && vFt != 62)
					{
						if ((fCompararFechas('vFechaHoy', 'vFechaCAAA') == 1) && document.getElementById('vActa').value == <cfoutput>#Session.sSesion#</cfoutput>)
						{
							alert('Ha solicitado asignar asuntos a una reuni�n de la CAAA ya celebrada. Para poder realizar la operaci�n antes debe corregir este problema.');
							return;
						}
					}	
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petici�n HTTP:
					xmlHttp.open("POST", "../asignar_sesion.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de par�metros:
					parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
					parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
					// Enviar la petici�n HTTP:
					xmlHttp.send(parametros);
					// Regresar al m�dulo actual:
					parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
				}
				--->
				// Retirar asunto:
				function fRetirarAsunto()
				{
					if (confirm('�Est� seguro que desea retirar el asunto?'))
					{
						// Crear un objeto XmlHttpRequest:
						var xmlHttp = XmlHttpRequest();
						// Generar una petici�n HTTP:
						xmlHttp.open("POST", "../../reuniones/retirar_asunto.cfm", false);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
						// Crear la lista de par�metros:
						parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
						// Enviar la petici�n HTTP:
						xmlHttp.send(parametros);
						// Regresar al m�dulo actual:
						parent.window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					}	
				}
				// Aplicar correcci�n a oficio:
				function fAplicarCorreccionOficio()
				{
					parent.window.location.replace('<cfoutput>#vCarpetaRaizLogica#/sistema_ctic/movimientos/detalle/movimiento.cfm?vIdAcad=#tbSolicitudes.sol_pos2#&vIdMov=#tbSolicitudes.sol_pos12#&vTipoComando=CORRECCION&vIdSolCO=#tbSolicitudes.sol_id#</cfoutput>');
				}
			</cfif>
		</script>
	</head>
	<body>
    	ADADSADSAAS
		<!-- Men� -->
		<table width="150" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td><div class="linea_menu"></div></td>
			</tr>
			<tr>
				<td><span class="Sans10NeNe">Men&uacute;:</span></td>
			</tr>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'NUEVO'>
				<!-- Opci�n: Guardar -->
				<tr>
					<td><input type="button" class="botones" value="Guardar" onClick="fEnviarComando('<cfoutput>#vTipoComando#</cfoutput>', true);"></td>
				</tr>
				<!---
				<!-- Restablecer -->
				<tr>
					<td>
						<input type="button" class="botones" value="Reestablecer" onclick="fEnviarComando('LIMPIA', false)">
					</td>
				</tr>
				--->
				<!-- Opci�n: Cancelar -->
				<tr>
					<td>
						<input type="button" class="botones" value="Cancelar" onClick="fEnviarComando('CANCELA', false);">
					</td>
				</tr>
			</cfif>
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!-- Opci�n: Corregir -->
				<tr>
					<td>
						<input type="button" class="botones" value="Corregir" onClick="fEnviarComando('EDITA', false);" <cfif #Session.sTipoSistema# IS 'sic' AND #vSolStatus# IS NOT 4 AND #tbSolicitudes.sol_devuelve_edita# EQ 0>disabled</cfif>>
					</td>
				</tr>
				<!-- Opci�n: Imprimir -->
				<tr>
					<td>
						<input type="button" class="botones" value="Imprimir FT" onClick="fEnviarComando('IMPRIME', false);" <cfif (#Session.sTipoSistema# IS 'sic' AND (#vFt# EQ '40' OR #vFt# EQ '41')) OR (#Session.sTipoSistema# IS 'sic' AND #vSolStatus# LTE 2 AND #tbSolicitudes.sol_devuelve_edita# EQ 0)>disabled</cfif>>
					</td>
				</tr>
				<cfif #Session.sTipoSistema# IS 'stctic'>
					<!-- Opci�n: Imprimir FT en blanco-->
					<tr>
						<td>
							<input type="button" class="botones" value="Imprimir FT EJEMPLO" onClick="fEnviarComando('IMPRIMEEJEMPLO', false);">
						</td>
					</tr>
				</cfif>
				<!-- Opci�n: Regresar -->
				<tr>
					<td>
						<input type="button" class="botones" value="Regresar" onClick="fEnviarComando('REGRESA', false);">
					</td>
				</tr>
				<!--- SE CAMBI� DE POSICI�N EL BOT�N DE ELIMINAR PARA EVITAR ELIMINAR EL REGISTRO POR ERROR 03/04/2019 --->
				<tr height="25px"><td></td></tr>
				<!-- Opci�n: Eliminar -->
				<tr>
					<td>
						<input type="button" class="botones" value="Eliminar" onClick="fEnviarComando('BORRA', false);" <cfif (#Session.sTipoSistema# IS 'sic' AND #vSolStatus# IS NOT 4) OR (#Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3)>disabled</cfif>>
					</td>
				</tr>                
				<!-- Comando sobre la solicitud/asunto -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td>
						<span class="Sans10NeNe"><cfif #vSolStatus# GT 2>Solicitud:<cfelse>Asunto:</cfif></span>
					</td>
				</tr>
				<!-- Nueva solicitud -->
				<cfif #vSolStatus# GT 2>
					<tr>
						<td>
							<input type="button" class="botones" value="Nueva solicitud" onClick="NuevaSolicitud();">
						</td>
					</tr>
				</cfif>
				<!-- Enviar solicitud  -->
				<cfif #Session.sTipoSistema# IS 'sic'>
					<tr>
						<td>
							<input type="button" class="botones" value="Enviar solicitd" onClick="fEnviarComando('ENVIA', false);" 
							<cfif #vSolStatus# IS NOT 4>disabled</cfif>
							>
						</td>
					</tr>
				</cfif>
				<cfif #Session.sTipoSistema# IS 'stctic'>
					<!-- Retirar asunto -->
					<cfif #vSolStatus# LT 3>
						<tr>
							<td>
								<input type="button" class="botones" value="Retirar el asunto" onClick="fRetirarAsunto();">
							</td>
						</tr>
					</cfif>
					<!-- Devolver solicitud a la entidad -->
					<cfif #vSolStatus# EQ 3>
					<tr>
						<td>
							<input type="button" class="botones" value="Devolver a la entidad" onClick="fDevolverSolicitud(4,'ENTIDAD');">
						</td>
					</tr>
                    </cfif>
					<!-- Devolver solicitud a revisi�n -->
					<cfif #vSolStatus# LT 3>
						<tr>
							<td><input type="button" class="botones" value="Devolver a recibidas" onClick="fDevolverSolicitud(3,'RECIBIDA');"></td>
						</tr>
						<!-- Permitir a la entidad -->
						<tr height="5"><td></td></tr>
						<tr>
							<td>
								<span class="Sans9NeNe">Permitir a la entidad:</span>
							</td>
						</tr>
						<tr>
							<td class="Sans9Vi">
								<input name="chkImprime" id="chkImprime" type="checkbox" value="Imprimir" style="margin:0px;" onClick="fDevolverSolicitud(3,'IMPRIME');" <cfif #tbSolicitudes.sol_devuelve_edita# EQ 1>checked</cfif>> Editar e imprimir<br>
								<input name="chkArchivo" id="chkArchivo" type="checkbox" value="Archivo" style="margin:0px;" onClick="fDevolverSolicitud(3,'ARCHIVO');" <cfif #tbSolicitudes.sol_devuelve_archivo# EQ 1>checked</cfif>> Reeneviar archivo PDF
							</td>
						</tr>
					</cfif>
				</cfif>
				<!---
				<!-- Navegaci�n -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
				</tr>
				<!-- Ir al Men� principal -->
				<tr>
					<td>
						<input type="button" class="botones" value="Men� principal" onclick="top.location.replace('../../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
					</td>
				</tr>
				--->
			</cfif>
			<!-- Aplicar correcci�n a oficio -->
			<cfif #Session.sTipoSistema# IS 'stctic' AND #vFt# IS 31 AND #vTipoComando# IS 'CONSULTA' AND #vSolStatus# LTE 1>
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td valign="top"><div align="left" class="Sans10NeNe">Correcci&oacute;n a oficio:</div></td>
				</tr>
				<tr>
					<td class="Sans9Vi">
						<cfif #vSolStatus# EQ 1>
							Aplicar las correcciones indicadas en la solicitud al movimiento asociado.
						<cfelse>
							Ya se aplicaron las correcciones indicadas al movimiento asociado.
						</cfif>	
					</td>
				</tr>
				<cfif #vSolStatus# EQ 1>
					<tr>
						<td>
							<input type="button" value="Aplicar correcciones" class="botones" onClick="fAplicarCorreccionOficio();">
						</td>
					</tr>
				</cfif>	
			</cfif>
			<!-- Documentaci�n digitalizada -->
			<cfif (#vFt# IS NOT 40 AND #vFt# IS NOT 41) AND #vTipoComando# EQ 'CONSULTA'>
				<!-- Enviar Archivo -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans9NeNe">Documentos digitalizados:</span></td>
				</tr>
				<!-- Indicador de la existencia de la documentaci�n digitalizada -->
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
				<!-- Indicador de falta de documentaci�n digitalizada -->
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
				<cfif #vSolStatus# GTE 3 OR (#vSolStatus# LTE 3 AND #tbSolicitudes.sol_devuelve_archivo# EQ 1)>
					<tr>
						<td><input id="cmdEnvioPdf" type="button" class="botones" style="position:relative;" value="<cfoutput>#vTextoArchivo#</cfoutput>" onClick="fEnviarComando('ARCHIVOPDF', false);"></td>
					</tr>
				</cfif>
			</cfif>
			<!-- Lista de documentos que se deben anexar -->
			<cfif  #vFt# IS NOT 40 AND #vFt# IS NOT 41 AND #vSolStatus# GT 2>
				<tr><td height="15"></td></tr>
				<tr>
					<td><div class="linea_menu"></div></td>
				</tr>
				<tr>
					<td><span class="Sans10NeNe">Documentos:</span><br></td>
				</tr>
				<tr>
					<td><span class="Sans9Vi" align="justify">Lista de documentos que debe anexar.</span></td>
				</tr>
				<tr>
					<td><input onClick="MostarDocumentosRequeridos();" type="button" class="botones" value="Consultar"></td>
				</tr>
			</cfif>
			<cfif #vFt# IS NOT 15 AND #vFt# IS NOT 16>
				<tr><td height="15"></td></tr>
				<tr>
					<td><div class="linea_menu"></div></td>
				</tr>
				<tr>
					<td><span class="Sans10NeNe">Movimientos anteriores:</span><br></td>
				</tr>
				<tr>
					<td><span class="Sans9Vi" align="justify">Historia de movimientos del acad�mico.</span></td>
				</tr>
				<tr>
					<td><input onClick="parent.$('#ListaMovimientos').dialog('open');" type="button" class="botones" value="Consultar"></td>
				</tr>
			</cfif>
			<!-- Art�culos del EPA -->
			<tr><td height="15"></td></tr>
			<tr>
				<td><div class="linea_menu"></div></td>
			</tr>
			<tr>
				<td><span class="Sans10NeNe">Art&iacute;culos:</span><br></td>
			</tr>
			<tr>
				<td>
					<span class="Sans9Vi">
						<cfif #ctMovimientoArt.RecordCount# GT 0>
							<cfoutput query="ctMovimientoArt">
								#ctMovimientoArt.mov_ley# Art.#ctMovimientoArt.mov_articulo# #ctMovimientoArt.mov_incisos#<br>
							</cfoutput>	
						<cfelse>
							Ninguno
						</cfif>	
					</span>
				</td>
			</tr>
			<!-- M�s informaci�n acerca de la solicitud -->
			<tr><td height="15"></td></tr>
			<cfoutput>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA'>
				<cfif #tbSolicitudes.cap_fecha_crea# NEQ "">
					<!-- Fecha de alta -->
					<tr>
						<td><div class="linea_menu"></div></td>
					</tr>
					<tr>
						<td><span class="Sans9GrNe">Alta:</span><br><span class="Sans9Vi">#LSDateFormat(tbSolicitudes.cap_fecha_crea,"DD/MM/YYYY")# #LSTimeFormat(tbSolicitudes.cap_fecha_crea,"HH:mm")#hrs</span></td>
					</tr>
				</cfif>
				<cfif #tbSolicitudes.cap_fecha_mod# NEQ ''>
					<!-- Feha de la �ltima modificaci�n -->
					<tr>
						<td><span class="Sans9GrNe">&Uacute;ltima modificaci&oacute;n: </span><br><span class="Sans9Vi">#LSDateFormat(tbSolicitudes.cap_fecha_mod,'DD/MM/YYYY')# #LSTimeFormat(tbSolicitudes.cap_fecha_mod,'HH:mm')#hrs</span></td>
					</tr>
				</cfif>
				<!-- N�mero de solicitud -->
				<tr>
					<td><span class="Sans9GrNe">N�mero de solicitud:</span><br><span class="Sans9Vi">#tbSolicitudes.sol_id#</span></td>
				</tr>
				<!-- Estado de la solicitud -->
				<tr>
					<td>
						<span class="Sans9GrNe">Status de la solicitud:</span>
						<br>
						<span class="Sans9Vi">
							<cfif #tbSolicitudes.sol_status# IS 4>
								<cfif  #tbSolicitudes.sol_devuelta# IS FALSE>
									EN CAPTURA
								<cfelse>
									DEVUELTA
								</cfif>
							<cfelseif #tbSolicitudes.sol_status# IS 3>
								ENVIADA	
							<cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>
								EN PROCESO
							<cfelseif #tbSolicitudes.sol_status# IS 0>
								ASUNTO RESUELTO
							</cfif>
						</span>
					</td>
				</tr>
			</cfif>
			</cfoutput>
		</table>
	</body>
</html>