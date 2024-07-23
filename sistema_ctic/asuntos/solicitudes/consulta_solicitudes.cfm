<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 13/10/2009 --->
<!--- FECHA ÚLTIMA MOD: 04/12/2015 --->

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosSolicitudFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosSolicitudFiltro = StructNew();
		AsuntosSolicitudFiltro.vFt = 0;
		AsuntosSolicitudFiltro.vAcadNom = '';
		AsuntosSolicitudFiltro.vNumSol = '';
		AsuntosSolicitudFiltro.vOrden = 'sol_id';
		AsuntosSolicitudFiltro.vOrdenDir = 'ASC';
		AsuntosSolicitudFiltro.vPagina = '1';
		AsuntosSolicitudFiltro.vRPP = '25';
		AsuntosSolicitudFiltro.vMarcadas = ArrayNew(1);
		AsuntosSolicitudFiltro.vStatus = 'CEDPR';
	</cfscript>
	<cfset Session.AsuntosSolicitudFiltro = '#AsuntosSolicitudFiltro#'>
</cfif>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>

		<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->        
		<script type="text/javascript" src="../../comun/java_script/mascara_entrada.js"></script>

		<!--- JAVA SCRIPT USO LOCAL --->        
		<script language="JavaScript" type="text/JavaScript">
			var vLYCImpresa;
			// Abrir la ventana de captura de nuevas solicitudes:
			function NuevaSolicitud()
			{
				window.location.replace('ft_selecciona/select_ft_acad.cfm')
			}
			// Actualizar la lista de solicitudes:
			function fListarSolicitudes(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						// Actualizar la lista de solicitudes:
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						// Actualizar el contador de registros:
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
						// Actualizar el texto del filtro:
						if (document.getElementById('vFt').value == 0) document.getElementById('vFiltroActual').innerHTML = 'Todas las solicitudes';
						else document.getElementById('vFiltroActual').innerHTML = 'FT-CTIC-' + document.getElementById('vFt').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "lista_solicitudes_entidad.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				if (document.getElementById('vDepId')) parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				parametros += "&vStatus=" + encodeURIComponent(document.getElementById('vStatus').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Construir la cadena vStatus que se enviará al filtro:
			function fFiltrarPorStatus()
			{
				var vStatus = '';
				// Detectar checkboxes activados:
				if (document.getElementById('vStatus_c').checked) vStatus += 'C';
				if (document.getElementById('vStatus_e').checked) vStatus += 'E';
				if (document.getElementById('vStatus_d').checked) vStatus += 'D';
				if (document.getElementById('vStatus_p').checked) vStatus += 'P';
				if (document.getElementById('vStatus_r').checked) vStatus += 'R';
				// Asignar el valor generado al input-hidden vStatus:
				document.getElementById('vStatus').value = vStatus;
				// Actualizar la lista de solicitudes:
				fListarSolicitudes(1,'<cfoutput>#Session.AsuntosSolicitudFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosSolicitudFiltro.vOrdenDir#</cfoutput>');
			}
			// Seleccionar/Deseleccionar una o todas las solicitudes:
			function fSeleccionarRegistro(vSolId, vTipo, vValor)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "seleccionar_solicitud.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent(vSolId);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				parametros += vValor == true ? "&vValor=TRUE": "&vValor=FALSE";
				// Pasar también los demás campos para seleccionar solo las solicitudes filtradas:
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				if (document.getElementById('vDepId')) parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				parametros += "&vStatus=" + encodeURIComponent(document.getElementById('vStatus').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Habilitar/deshabilitar el comandos que afectar solicitudes seleccionadas:
				if (xmlHttp.responseText.indexOf('SOLICITUDESCONSELECCION') != -1)
				{
					document.getElementById('cmdEnviaSol').disabled = false;
				}
				else
				{
					document.getElementById('cmdEnviaSol').disabled = true;
				}
				// Determinar si se seleccionó una licencia o comisión ya impresa:
				if (xmlHttp.responseText.indexOf('LYCENVIADA') != -1)
				{
					vLYCImpresa = true;
					//document.getElementById('cmdImprimir').disabled = false;
				}
				else
				{
					vLYCImpresa = false;
					//document.getElementById('cmdImprimir').disabled = true;
				}
			}
			// Marcar todas las solicitudes para aplicarles un comando:
			function fMarcarTodas(vValor)
			{
				// Marcar todas las solicitudes en la BD:
				fSeleccionarRegistro('TODAS', 4, vValor);
				// Actualizar la lista:
				fListarSolicitudes(1,'<cfoutput>#Session.AsuntosSolicitudFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosSolicitudFiltro.vOrdenDir#</cfoutput>');
			}
			// Enviar a la ST-CTIC las solicitudes marcadas:
			function fEnviarSolicitud()
			{
				// Verificar si el usuario desea realizar la acción:
				if (!confirm('¿En realidad desea enviar a la ST-CTIC las solicitudes marcadas?')) return;
				// Limpiar la lista de solicitudes:
				document.getElementById('solicitudes_dynamic').innerHTML = '';
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "enviar_solicitud.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent('TODAS');
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Desmarcar todas las solicitudes y actualizar la lista:
				fMarcarTodas(false);
			}
			// Imprimir la lista de solicitudes:
			function fImprimirListado()
			{
				// Acuse de recibo:
				if (document.getElementById('vTipoImpresion').value == 'ACU')
				{
					window.open("impresion/acuse_recibo.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				// Acuse de recibo:
				else if (document.getElementById('vTipoImpresion').value == 'ABP')
				{
					window.open("impresion/acuse_recibo_bp.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				// Relación de licencias y comisiones:
				else if (document.getElementById('vTipoImpresion').value == 'LYC')
				{
					if (vLYCImpresa)
					{
						if (!confirm("Ha seleccionado solicitudes de licencias y comisiones, impresas anteriormente en otra relación para la ST-CTIC. ¿Desea continuar con la impresión?")) return;
					}
					// Abrir la relación de licencias y comisiones enviadas a la ST-CTIC:
					window.open('impresion/listado_lyc.cfm','listado_lyc','modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcas las solicitudes y actualizar la lista:
					setTimeout("fMarcarTodas(false);",3000);
				}
				// Solicitudes filtradas:
				else if (document.getElementById('vTipoImpresion').value == 'LIS')
				{
					window.open("impresion/listado_solicitudes.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
			}
			// Actualizar el texto de descripción del tipo de impresión:
			function fActualizarTextoTipoImpresion()
			{
				// Acuse de recibo:
				if (document.getElementById('vTipoImpresion').value == 'ACU')
				{
					document.getElementById('vTipoImpresion_txt').innerHTML = 'Acuse de solicitudes enviadas a la Secretar&iacute;a T&eacute;cnica del CTIC; excepto licnecias y comisiones.';
				}
				// Acuse de recibo de becas posdoctorales:
				else if (document.getElementById('vTipoImpresion').value == 'ABP')
				{
					document.getElementById('vTipoImpresion_txt').innerHTML = 'Acuse de solicitudes de becas posdoctorales enviadas a la Secretar&iacute;a T&eacute;cnica del CTIC.';
				}
				// Relación de licencias y comisiones:
				else if (document.getElementById('vTipoImpresion').value == 'LYC')
				{
					document.getElementById('vTipoImpresion_txt').innerHTML = 'Relaci&oacute;n de licencias con sueldo y comisiones menores a 22 d&iacute;s enviadas a la Secretar&iacute;a T&eacute;cnica del CTIC.';
				}
				// Solicitudes filtradas:
				else if (document.getElementById('vTipoImpresion').value == 'LIS')
				{
					document.getElementById('vTipoImpresion_txt').innerHTML = 'Lista de solicitudes filtradas; este reporte es exclusivamente para uso interno.';
				}
			}
		</script>
	</head>
	<body onLoad="fListarSolicitudes(<cfoutput>#Session.AsuntosSolicitudFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AsuntosSolicitudFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosSolicitudFiltro.vOrdenDir#</cfoutput>');">
    	<!-- Cintillo con nombre del módulo y Filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">SOLICITUDES &gt;&gt; </span><span class="Sans9Gr">LISTADO</span></td>
				<td align="right">
					<cfoutput>
						<span class="Sans9GrNe">
							Filtro:
						</span>
						<span id="vFiltroActual" class="Sans9Gr">
							<cfif #Session.AsuntosSolicitudFiltro.vFt# NEQ 0>
								FT-CTIC-#Session.AsuntosSolicitudFiltro.vFt#
							<cfelse>
								Todas las solicitudes
							</cfif>
						</span>
					</cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) -->
				<td width="180" valign="top" class="bordesmenu">
					<!-- Controles -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;:</div></td>
						</tr>
						<!-- Opción: Nueva solicitud -->
						<tr>
							<td><input type="button" value="Nueva Solicitud" class="botones" onClick="NuevaSolicitud();"></td>
						</tr>
						<!---
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado('L');"></td>
						</tr>
						<!-- Opción: Imprimir acuse de recibo -->
						<tr>
							<td><input type="button" value="Imprimir Acuse" class="botones" onClick="fImprimirListado('A');"></td>
						</tr>
						--->
						<!-- Imprimir -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Imprimir:</div></td>
						</tr>
						<tr>
							<td valign="top">
								<select name="vTipoImpresion" id="vTipoImpresion" class="datos" style="width:150px;" onChange="fActualizarTextoTipoImpresion();">
									<option value="ACU">Acuse de solicitudes</option>
									<option value="ABP">Acuse de becas posdoc.</option>
									<option value="LYC">Licencias y comisiones</option>
									<option value="LIS">Lista de solicitudes</option>
								</select>
							</td>
						</tr>
						<tr>
							<td id="vTipoImpresion_txt" class="Sans9Vi">
								Acuse de solicitudes enviadas a la Secretar&iacute;a T&eacute;cnica del CTIC; excepto licnecias y comisiones.
							</td>
						</tr>
						<tr>
							<td><input id="cmdImprimir" type="button" value="Imprimir" class="botones" onClick="fImprimirListado();"></td>  <!---<cfif #ArrayIsEmpty(Session.AsuntosSolicitudFiltro.vMarcadas)#>disabled</cfif>--->
						</tr>

						<!-- Enviar solicitud -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Enviar solicitudes:</div></td>
						</tr>
						<tr>
							<td align="justify"><span class="Sans9Vi">Enviar las solicitudes marcadas a la ST-CTIC para su revisi&oacute;n y posteriormente incluirla en la sesi&oacute;n del CTIC que le corresponda.</span></td>
						</tr>
						<tr>
							<td><input id="cmdEnviaSol" type="button" value="Enviar solicitudes" class="botones" onClick="fEnviarSolicitud();" <cfif #ArrayIsEmpty(Session.AsuntosSolicitudFiltro.vMarcadas)#>disabled</cfif>></td>
						</tr>
						<!---
						<!-- Imprimir listado de licencias y comisiones-->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Licencias y comisiones:</div></td>
						</tr>
						<!-- Descripción de imprimir -->
						<tr>
							<td align="justify"><span class="Sans9Vi">Imprimir la relaci&oacute;n de licencias y comisiones enviadas a la Secretar&iacute;a T&eacute;cnica del CTIC.</span></td>
						</tr>
						<!-- Botón de imprimir-->
						<tr>
							<td><input id="cmdImpLYC" type="button" value="Imprimir" class="botones" onClick="fImprimirLYC();" <cfif #ArrayIsEmpty(Session.AsuntosSolicitudFiltro.vMarcadas)#>disabled</cfif>></td>
						</tr>
						--->
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Filtrar por académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosSolicitudFiltro.vAcadNom#</cfoutput>" onKeyUp="if (this.value.length == 0 || this.value.length >= 3) fListarSolicitudes(1,'<cfoutput>#Session.AsuntosSolicitudFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosSolicitudFiltro.vOrdenDir#</cfoutput>')">
							</td>
						</tr>
						<!-- Número de solicitud -->
						<tr>
							<td>
								<span class="Sans9GrNe">No. Solicitud:<br></span>
								<input name="vNumSol" id="vNumSol" type="text" style="width: 60px;" class="datos" value="<cfoutput>#Session.AsuntosSolicitudFiltro.vNumSol#</cfoutput>" onKeyPress="return MascaraEntrada(event, '999999');" onKeyUp="fListarSolicitudes(1,'<cfoutput>#Session.AsuntosSolicitudFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosSolicitudFiltro.vOrdenDir#</cfoutput>')">
							</td>
						</tr>

						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AsuntosSolicitudFiltro" funcion="fListarSolicitudes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaINCLUDE#/movimientos_catalogo_select.cfm" filtro="0" funcion="fListarSolicitudes" sFiltrovFt="#Session.AsuntosSolicitudFiltro.vFt#" sFiltrovOrden="#Session.AsuntosSolicitudFiltro.vOrden#" sFiltrovOrdenDir="#Session.AsuntosSolicitudFiltro.vOrdenDir#">                
					<!-- Filtro de la lista por tipo de movimiento -->
					<table style="width:70%; margin:5px 0px 15px 15px;" cellspacing="0" cellpadding="1">
						<tr valign="middle">
							<td width="30%" style="padding:5px 5px 0px 5px; background-color: #FFCC66"><span class="Sans9ViNe">Filtrar por situación de solicitud:</span></td>
							<td width="70%"  style="padding:0px 5px 8px 5px; background-color:#FFCC66;" align="center">
								<input name="vStatus_c" id="vStatus_c" type="checkbox" onClick="fFiltrarPorStatus();" <cfif Find('C','#Session.AsuntosSolicitudFiltro.vStatus#')>checked</cfif>>En captura &nbsp;
								<input name="vStatus_e" id="vStatus_e" type="checkbox" onClick="fFiltrarPorStatus();" <cfif Find('E','#Session.AsuntosSolicitudFiltro.vStatus#')>checked</cfif>>Enviadas &nbsp;
								<input name="vStatus_d" id="vStatus_d" type="checkbox" onClick="fFiltrarPorStatus();" <cfif Find('D','#Session.AsuntosSolicitudFiltro.vStatus#')>checked</cfif>>Devueltas &nbsp;
								<input name="vStatus_p" id="vStatus_p" type="checkbox" onClick="fFiltrarPorStatus();" <cfif Find('P','#Session.AsuntosSolicitudFiltro.vStatus#')>checked</cfif>>En proceso &nbsp;
								<input name="vStatus_r" id="vStatus_r" type="checkbox" onClick="fFiltrarPorStatus();" <cfif Find('R','#Session.AsuntosSolicitudFiltro.vStatus#')>checked</cfif>>Asuntos resueltos &nbsp;
								<input name="vStatus" id="vStatus" type="hidden" value="<cfoutput>#Session.AsuntosSolicitudFiltro.vStatus#</cfoutput>">
							</td>
						</tr>
					</table>
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
