<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/01/2010 --->
<!--- FECHA ÚLTIMA MOD: 17/03/2017 --->
<!--- ORDEN DEL DÍA --->
<!--- Obtener datos de la sesión --->

<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #vIdSsn# 
	AND 
	<cfif #Session.sTipoSesionCel# EQ "1">
		ssn_clave = 1
	<cfelseif #Session.sTipoSesionCel# EQ "2">
		ssn_clave = 2 
	</cfif> 
</cfquery>

<!--- Obtener la lista de punto resultante --->
<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones_orden 
    WHERE ssn_id = #vIdSsn# 
    ORDER BY punto_num
</cfquery>

<cfif #Session.sTipoSesionCel# EQ "1">
	<cfset vSesionAnt = #tbSesion.ssn_id# - 1>
	<cfset vSesionPost = #tbSesion.ssn_id# + 1>
<cfelseif #Session.sTipoSesionCel# EQ "2">
	<cfset vSesionAnt = 0>
	<cfset vSesionPost = 0>
</cfif> 

<cfset vWebArchivoOd = ''>
<cfset vCarpetaArchivoOd = ''>

<cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
<cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
    
<cfif FileExists(#vCarpetaArchivoOd#)>
	<cfset vTextoArchivo = "Reenviar archivo">
<cfelse>
	<cfset vTextoArchivo = "Enviar archivo">
</cfif>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Documento sin t&iacute;tulo</title>
		<!--- CSS --->
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<!--- JQUERY --->
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>

		<!--- JAVA SCRIPT  --->
		<cfinclude template="../javascript/sesion_scripts_valida.cfm">

		<script language="JavaScript" type="text/JavaScript">
			// Mostrar el formulario para cargar archivos:
			function ventanaPunto() {
				$('#divPunto').dialog('open');
			}
			// Ventana del diálogo (jQuery)
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divPunto').dialog({
					autoOpen: false,
					height: 300,
					width: 700,
					modal: true,
					title: "DETALLE PUNTO ORDEN DEL DÍA",
					maxHeight: 400,
					open: function() {
						//$('#divPunto').load('orden_dia_punto.cfm');
						$(this).load('orden_dia_formulario_punto.cfm', {vIdSsn:$('#ssn_id').val(), vTipoComando:$('#vAccion').val(), vPunto:$('#vPunto').val()});
						//alert($('#vPunto').val());
					}
				});
			});
			
			function cierraventanaPunto() {
				$('#divPunto').dialog('close');
			}
			
			function fRempValoresPunto(vTipoComando,vPunto)
			{
				document.getElementById('vAccion').value = vTipoComando;
				document.getElementById('vPunto').value = vPunto;
				ventanaPunto();
			}
		</script>		

		<script language="JavaScript" type="text/JavaScript">

			// Función para direccionar la acción de los botones:
			function fEnviarComando() // Argumentos variables: vComando, vPunto, punto_numero, punto_texto, punto_pdf
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				
				vComando = arguments[0];

				if (vComando == 'SUBE')
				{
					// Ejecutar comando:
					document.getElementById('vAccion').value = "S";
					document.getElementById('vPunto').value = arguments[1];
					fAcualizaPunto();
				}
				else if (vComando == 'BAJA')
				{
					// Ejecutar comando:
					document.getElementById('vAccion').value = "B";
					document.getElementById('vPunto').value = arguments[1];
					fAcualizaPunto();
				}
				else if (vComando == 'ELIMINA')
				{
					// Ejecutar comando:
					if (confirm('Si elimina este registro y existe algún archivo que esté relacionado con el mismo, éste será borrado del servidor. ¿Desea continuar?'))
					{
						document.getElementById('vAccion').value = "D";
						document.getElementById('vPunto').value = arguments[1];
						document.getElementById('vPuntoClave').value = arguments[2];
						fAcualizaPunto();
					}
				}
				else if (vComando == 'REGRESA')	
				{
					window.location = 'orden_dia_inicio.cfm';
				}
				else if (vComando == "ARCHIVOPDF")
				{
					var posTop = document.getElementById('cmdEnvioPdf').offsetTop;
					var posleft = document.getElementById('cmdEnvioPdf').offsetLeft;					
					document.getElementById('ifrmSelArchivo').width = 515;
					document.getElementById('ifrmSelArchivo').height = 200;
					document.getElementById('ifrmSelArchivo').style.top = posTop + 'px';
					document.getElementById('ifrmSelArchivo').style.left = '150px';
					document.getElementById('ifrmSelArchivo').style.display = '';
				}
			}

			// FUNCIÓN PARA LLAMAR LOS PUNTOS DEL ORDEN DEL DÍA			
			function fAcualizaPunto()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('ActualizaPunto_dynamic').innerHTML = xmlHttp.responseText;
						window.location.reload();
					}
				}
				// Generar una petición HTTP:
				xmlHttp.open("POST", "orden_dia_formulario_punto_guarda.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSsn=" + encodeURIComponent(document.getElementById('ssn_id').value);
				parametros += "&vAccion=" + encodeURIComponent(document.getElementById('vAccion').value);
				parametros += "&vPunto=" + encodeURIComponent(document.getElementById('vPunto').value);
				parametros += "&punto_clave=" + encodeURIComponent(document.getElementById('vPuntoClave').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">ORDEN DEL D&Iacute;A &gt;&gt; </span><span class="Sans9Gr">EDICI&Oacute;N</span>
				</td>
				<td align="right"><cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm"></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="100%" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) -->
				<td width="18%" valign="top">
					<!-- Opción: Nuevo punto -->
					<!-- Comandos -->
					<table width="95%" border="0" align="center">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<tr id="cmdImprimir">
							<td>
								<input type="button" class="botones" value="Imprimir" onclick="fEnviarComando('IMPRIME');" <cfif #vIdSsn# NEQ #Session.sSesion# OR #Session.sTipoSistema# IS 'sic' OR #tbSesionOrden.RecordCount# EQ 0>disabled</cfif>>
						  </td>
						</tr>
						<!-- Opción Regresar -->
						<tr id="cmdRegresar">
							<td>
								<input type="button" class="botones" value="Regresar" onclick="fEnviarComando('REGRESA');">
							</td>
						</tr>
						<!-- Opción: Cancelar -->
						<tr id="cmdCancelar" style="display:none;">
							<td>
								<input type="button" value="Cancelar" class="botones" onclick="fEnviarComando('CANCELA');">
							</td>
						</tr>
						<cfif #Session.sTipoSesionCel# EQ '1' AND #tbSesion.ssn_id# LTE #Session.sSesion#>
						<tr>
							<td><div class="linea_menu"></div></td>
						</tr>
						<tr>
							<td><span class="Sans9NeNe">Ir al orden del día de la sesión</span></td>
						</tr>
						<tr>
							<cfoutput>
							<td><input name="cmdAnterior" type="button" value="<<&nbsp;#vSesionAnt#" class="botones" onclick="window.location='orden_dia.cfm?vIdSsn=#vSesionAnt#'"></td>
							</cfoutput>
						</tr>
						<tr>
							<cfoutput>
							<td><input name="cmdAnterior" type="button" value="#vSesionPost#&nbsp;>>" class="botones" onclick="window.location='orden_dia.cfm?vIdSsn=#vSesionPost#'" <cfif #tbSesion.ssn_id# EQ #Session.sSesion#>disabled</cfif>></td>
							</cfoutput>
						</tr>
                        </cfif>
						<tr>
						  <td><input name="vTipoSesionCel" id="vTipoSesionCel" type="hidden" value="<cfoutput>#Session.sTipoSesionCel#</cfoutput>"></td>
						</tr>
						<tr>
							<td><div class="linea_menu"></div></td>
						</tr>
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (datos de la orden del día) -->
				<td width="82%" height="300" valign="top" align="center">
					<cfoutput>
                        <br>
                        <!-- Número de sesión -->
                        <div align="left" style="width:80%;">
                            <span class="Sans12NeNe">SESIÓN: </span>
                            <span class="Sans12ViNe">
                                #tbSesion.SSN_ID#
                          </span>
                        </div>
                        <br>
                        <!-- Introducción -->
                        <div align="justify" style="width:80%;">
                            <span class="Sans12Gr">Agradecer&eacute; a ustedes su asistencia a la sesi&oacute;n ordinaria del Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica, que se llevar&aacute; a cabo el <strong><strong>#LsDateFormat(tbSesion.ssn_fecha,'dddd')#</strong> #LsDateFormat(tbSesion.ssn_fecha,'dd')# de #LsDateFormat(tbSesion.ssn_fecha,'mmmm')#</strong>, a partir de las <strong>#LsTimeFormat(tbSesion.ssn_fecha,'hh:mm')# horas</strong>, <strong>#tbSesion.ssn_sede#</strong>, de acuerdo con el siguiente:</span>
                            <p>&nbsp;</p>
                        </div>
                        <div align="center">
                        	<span class="Sans14NeNe">
                                ORDEN DEL D&Iacute;A
                                <br />
                                SESIÓN 
                                <cfif #Session.sTipoSesionCel# EQ "1">
                                    ORDINARIA
                                <cfelseif #Session.sTipoSesionCel# EQ "2">
                                    EXTRAORDINARIA
                                </cfif>
							</span>
                        </div>
                        <br />
					</cfoutput>
<!---                    
					<table width="80%" align="center" cellspacing="0">
						<cfoutput>
						<tr>
							<td>
								<br>
								<!-- Número de sesión -->
								<div align="left" style="width:80%;">
									<span class="Sans12NeNe">SESIÓN: </span>
									<span class="Sans12ViNe">
										#tbSesion.SSN_ID#
								  </span>
								</div>
								<br>
								<!-- Introducción -->
								<div align="justify" style="width:80%;">
									<span class="Sans12Gr">Agradecer&eacute; a ustedes su asistencia a la sesi&oacute;n ordinaria del Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica, que se llevar&aacute; a cabo el <strong><strong>#LsDateFormat(tbSesion.ssn_fecha,'dddd')#</strong> #LsDateFormat(tbSesion.ssn_fecha,'dd')# de #LsDateFormat(tbSesion.ssn_fecha,'mmmm')#</strong>, a partir de las <strong>#LsTimeFormat(tbSesion.ssn_fecha,'hh:mm')# horas</strong>, <strong>#tbSesion.ssn_sede#</strong>, de acuerdo con el siguiente:</span>
									<p>&nbsp;</p>
								</div>
							</td>
						</tr>
						<!-- Titulo -->
						<tr>
							<td class="Sans14NeNe">
								<div align="center">
									ORDEN DEL D&Iacute;A
                                    <br />
									SESIÓN 
									<cfif #Session.sTipoSesionCel# EQ "O">
                                        ORDINARIA
                                    <cfelseif #Session.sTipoSesionCel# EQ "E">
                                        EXTRAORDINARIA
                                    </cfif>
                                </div>
							</td>
						</tr>
						<tr><td class="Sans14NeNe">&nbsp;</td></tr>
						</cfoutput>
					</table>
--->
					<div id="despelga_puntos_dynamic" style="width:80%;"></div>                
					<!-- Lista de puntos -->
					<table width="80%" align="center">
						<cfset CC = 1><!--- Lo inicio en 1 porque quiero obtener el siguiente número del último número --->
						<cfoutput query="tbSesionOrden">
							<!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF --->
							<cfset vArchivoPdfPuntoOd = ''>
							<cfif #punto_pdf# NEQ ''>
								<cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
									<cfset vArchivoPdfPuntoOd = #vCarpetaSesionHistoria# & #punto_pdf#>
									<cfset vWebPdf = #vWebSesionHistoria# & #punto_pdf#>
								<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
									<cfset vArchivoPdfPuntoOd = #vCarpetaAcademicos# & #punto_pdf#>
									<cfset vWebPdf = #vWebAcademicos# & #punto_pdf#>
								<cfelseif #RTrim(punto_clave)# EQ 'OTRO' OR #RTrim(punto_clave)# EQ 'ICRI'>
									<cfset vArchivoPdfPuntoOd = #vCarpetaSesionOtros# & #punto_pdf#>
									<cfset vWebPdf = #vWebSesionOtros# & #punto_pdf#>
								</cfif>
							</cfif>
							<!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF_2 --->
							<cfset vArchivoPdfPuntoOd2 = ''>
							<cfif #punto_pdf_2# NEQ ''>
								<cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                   	<cfset vArchivoPdfPuntoOd2 = #vCarpetaSesionHistoria# & #punto_pdf_2#>
  	                               	<cfset vWebPdf2 = #vWebSesionHistoria# & #punto_pdf_2#>
								<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
									<cfset vArchivoPdfPuntoOd2 = #vCarpetaAcademicos# & #punto_pdf_2#>
									<cfset vWebPdf2 = #vWebAcademicos# & #punto_pdf_2#>
								<cfelse>		
									<cfset vArchivoPdfPuntoOd2 = #vCarpetaSesionOtros# & #punto_pdf_2#>
									<cfset vWebPdf2 = #vWebSesionOtros# & #punto_pdf_2#>
								</cfif>
							</cfif>	                        
							<tr valign="top">
								<td width="3%" valign="top">
									<span class="Sans12Gr">#punto_num#</span>
								</td>
								<td width="77%" valign="top" style="padding-right:10px;">
									<div align="justify"><span class="Sans12Gr">#punto_texto#</span></div>
								</td>
								<cfif #Session.sTipoSistema# IS 'stctic' AND ((#vIdSsn# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st'))>
									<td width="3%"><img src="#vCarpetaICONO#/ir_arriba_15.jpg" onclick="fEnviarComando('SUBE','#punto_num#')" style="cursor:pointer;" title="Subir posición" /></td>
									<td width="3%"><img src="#vCarpetaICONO#/ir_abajo_15.jpg" onclick="fEnviarComando('BAJA','#punto_num#')" style="cursor:pointer;"  title="Bajar posición"></td>
									<td width="3%"><img src="#vCarpetaICONO#/detalle_15.jpg" onclick="fRempValoresPunto('E','#punto_num#');" style="cursor:pointer;" title="Editar punto"></td>
									<td width="3%"><img src="#vCarpetaICONO#/elimina_15.jpg" onclick="fEnviarComando('ELIMINA','#punto_num#','#punto_clave#');" style="cursor:pointer;" title="Eliminar punto"></td>
								</cfif>
								<td width="8%" align="right" <cfif #Session.sTipoSistema# IS 'stctic' AND (#vIdSsn# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2)>width="15"<cfelse>width="40"</cfif>>
					                <cfif FileExists(#vArchivoPdfPuntoOd#)>
										<a href="#vWebPdf#" target="_blank"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf#"></a>
									</cfif>
					                <cfif FileExists(#vArchivoPdfPuntoOd2#)>
										<a href="#vWebPdf2#" target="_blank"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf_2#"></a>
									</cfif>
                                </td>
							</tr>
							<tr>
								<td <cfif (#vIdSsn# GTE #Session.sSesion#) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>colspan="7"<cfelse>colspan="4"</cfif> align="center">
									<hr>
								</td>
							</tr>
							<cfset CC = CC + 1>
						</cfoutput>
					</table>
					<!---
                    <cfif ((#vIdSsn# EQ #Session.sSesion# OR #Session.sTipoSistema# IS 'sic') AND #Session.sTipoSesionCel# EQ "O" AND #Session.sUsuario# NEQ 'aram_st') OR ((#tbSesion.ssn_fecha# LTE #NOW()# OR #Session.sTipoSistema# IS 'sic') AND #Session.sTipoSesionCel# EQ "E" AND #Session.sUsuario# NEQ 'aram_st') OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>
                    --->
					<cfif #Session.sTipoSistema# IS 'stctic' AND (#vIdSsn# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>
						<table width="80%" align="center">
                            <tr>
                                <td width="3%" align="center"><span class="AgregarRegTexto"><em>*</em></span></td><!--- bgcolor="#66CC00"--->
                                <td width="94%"><span class="AgregarRegTexto"><em>AGREGAR NUEVO PUNTO AL ORDEN DEL DÍA...</em></span></td>
                                <td width="3%"><img src="<cfoutput>#vCarpetaICONO#</cfoutput>/agregar_15.jpg" width="15" onclick="fRempValoresPunto('N','');" style="border:none;cursor:pointer;" title="AGREGAR PUNTO"></td>
                            </tr>
                        </table>
                    </cfif>
					<br />
					<div style="background-color:#FFC; height:20px;">
                       <h3 style="padding-top:5px;">OTROS DOCUMENTOS DIGITALIZADOS</h3>
					</div>
					<hr />
					<div style="width:100%;" align="center">
						<div style="float:left; width:30%;">
							<!--- Include para consutar o anexar documento(s) en PDF (ORDEN DEL DÍA) --->
							<table border="0" cellpadding="0" cellspacing="0" width="180px">
								<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="ORDENDIA" AcdId="" NumRegistro="1" SsnId="#vIdSsn#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE= "#vCarpetaINCLUDE#">
							</table>
						</div>
						<cfif #tbSesion.ssn_clave# EQ 1>
							<div style="float:left; width:30%;">
								<!--- Include para consutar o anexar documento(s) en PDF (ESTIMULOS DGAPA) --->
								<table border="0" cellpadding="0" cellspacing="0" width="180px">
									<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="ESTDGAPA" AcdId="" NumRegistro="1" SsnId="#vIdSsn#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE= "#vCarpetaINCLUDE#">
								</table>
							</div>
							<div style="float:left; width:30%;">
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
									<table border="0" cellpadding="0" cellspacing="0" width="180px">
										<!--- Include para consutar o anexar documento(s) en PDF (OFICIOS DIGITALIZADOS (NO LICENCIAS)) --->
										<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="OFICIOSG" AcdId="" NumRegistro="1" SsnId="#vIdSsn#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
									</table>
								</cfif>
							</div>
						</cfif>
					</div>
					<div id="divPunto"><!-- INSETA AJAX PARA ACTIVAR EL FORMULARIO DE CAPTURA DE PUNTOS DEL ORDEN DEL DÍA --></div>
					<div id="ActualizaPunto_dynamic"><!-- INSETA AJAX PARA ACTIVAR EL FORMULARIO DE CAPTURA DE PUNTOS DEL ORDEN DEL DÍA --></div>
                    <!-- Campos ocultos -->
					<cfoutput>
	                    <input type="hidden" name="ssn_id" id="ssn_id" value="#tbSesion.ssn_id#">
    	                <input type="hidden" name="vAccion" id="vAccion" value="">
	       	            <input type="hidden" name="vPunto" id="vPunto" value="">
	       	            <input type="hidden" name="vPuntoClave" id="vPuntoClave" value="">
					</cfoutput>
				</td>
			</tr>
		</table>
	</body>
</html>
