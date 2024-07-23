<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 19/05/2010 --->
<!--- FECHA ULTIMA MOD.: 20/11/2015--->

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<cfset vSesionInicio = #Session.sSesion# - 1>
<cfset vSesionFinal = #Session.sSesion# + 1>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosLYCFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosLYCFiltro = StructNew();
		AsuntosLYCFiltro.vActa = '';
		AsuntosLYCFiltro.vDepId = '';
		AsuntosLYCFiltro.vAcadNom = ''; 
		AsuntosLYCFiltro.vPagina = '1';
		AsuntosLYCFiltro.vRPP = 25;
	</cfscript>
	<cfset Session.AsuntosLYCFiltro = '#AsuntosLYCFiltro#'>
</cfif>


<!--- Obtener la lista de movimientos disponibles --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_status = 1 
    ORDER BY mov_orden
</cfquery>
<!--- Obtener la lista de dependencias del SIC --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia 
    WHERE dep_clave LIKE '03%' 
    AND dep_status = 1 
    ORDER BY dep_siglas
</cfquery>

<!--- Obtener el número de sesión que se verá en la CAAA --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones
	WHERE ssn_clave = 4 
	AND (ssn_id BETWEEN #vSesionInicio# AND #vSesionFinal#)
</cfquery>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
		</cfoutput>

		<style type="text/css">
			.emergente { 
				position: absolute;
				visibility: hidden;
				background-color: #EEEEEE;
				padding: 2px;
				border-style: solid;
				border-width: 1px;
				border-color: #AAAAAA;
				z-index:10; /* Esta propiedad es importante para que se mueste sobre el calendario! */
			} 
		</style>
		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a la CAAA:
			function fListarSolicitudes(vPagina)
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lyc_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
//				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);

				// Actualizar el cintillo:
//				document.getElementById('txtActa').innerHTML = 'ACTA ' + document.getElementById('vActa').value;
			}
			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado()
			{
				window.open("../sistema_ctic/asuntos/reuniones/impresion/listado_caaa.cfm?vListado=CAAA&vTipo=OTRO&vActa=" + document.getElementById('vActa').value, "_blank" , "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			function fExportaDbf()
			{
				window.location = 'lyc_exporta_csv_txt.cfm?&vActa=' + document.getElementById('vActa').value + '&vDepId=' + document.getElementById('vDepId').value
			}
			function fExportaExcel()
			{
				window.open("lyc_exporta_excel.cfm?&vSsnId=" + document.getElementById('vActa').value + '&vDepId=' + document.getElementById('vDepId').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
        <script language="JavaScript" type="text/JavaScript">
			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divExportaLyC').dialog({
					autoOpen: false,
					height: 350,
					width: 400,
					modal: true,
					maxHeight: 400,
					title:'EXPORTAR LICENCIAS Y COMISIONES CON GOCE DE SUELDO',
					open: function() {
						//alert($('#cmdLibera').attr('checked'));
						$(this).load('lyc_exporta_csv_txt.cfm', {vpSesion:$('#vActa').val(), vDepId:$('#vDepId').val()});
//						$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
				$('#cmdExportaLyC').click(function(){
					$('#divExportaLyC').dialog('open');
				});
			});				
		</script>        
	</head>
	<body onLoad="fListarSolicitudes(1);">
		<!-- Control para capturar una ota acerca del asunto -->
		<span id="ComisionNota" class="emergente"></span>
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">
						EXPORTAR LICENCIAS Y COMISIONES CON GOCE DE SUELDO
					</span>
				</td>
				<td align="right">
					<cfoutput>
					<span class="Sans9Gr"><b>SESIÓN:#Session.sSesion#</b></span>
					</cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="1024" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<!-- Campos ocultos -->
					<input type="hidden" value="<cfoutput>#tbSesion.ssn_id#</cfoutput>"  name="vtActa" id="vtActa">
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td width="146"><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Imprimir listado -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();" disabled></td>
						</tr>
						<!-- Opción: Genera Archivo para Fortel -->
<!--- 
						<tr>
							<td><input name="cmdExportaLyC" id="cmdExportaLyC" type="button" value="Exportar a formatos CSV / TXT" class="botones"></td>
						</tr>
--->
						<tr>
							<td><input name="cmdExportaLyCXls" id="cmdExportaLyCXls" type="button" value="Exportar a formato EXCEL" class="botones" onClick="fExportaExcel();"></td>
						</tr>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Dependencia -->
						<tr>
							<td valign="top">
								<span class="Sans9Gr">Dependencia:<br></span>
								<select name="vDepId" id="vDepId" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<option value="">Todas</option>
									<cfoutput query="ctDependencia">
										<option value="#dep_clave#">#dep_siglas#</option>									
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>Sesi&oacute;n
								<select name="vActa" id="vActa" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<!--- <option value="1585" <cfif isDefined("Session.sSesion") AND 1585 EQ #Session.sSesion#>selected</cfif>>1585</option> --->
									<cfoutput query="tbSesion">
										<option value="#ssn_id#" <cfif isDefined("Session.sSesion") AND #ssn_id# EQ #Session.sSesion#>selected</cfif>>#ssn_id#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								<span class="Sans9Gr">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosLYCFiltro.vAcadNom#</cfoutput>" onKeyUp="fListarSolicitudes(1)">
							</td>
						</tr>
						<!-- Sección -->
						<tr>
							<td valign="top">
								<!--- NOTA: Obtener esta lista del catálogo de partes
								<input type="hidden" value="<cfoutput>#vSeccion#</cfoutput>"  name="vSeccion" id="vSeccion">
								--->
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="../../../includes/registros_pagina.cfm" filtro="AsuntosLYCFiltro" funcion="fListarSolicitudes" ordenable="no">
						<!--- Contador de registros --->
						<cfmodule template="../../../includes/contador_registros.cfm">
					</table>
			  </td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
				  </div>
					<div id="vError_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
					<div id="divExportaLyC" width="100%">
						<!-- JQUERY: DIV que para desplegar pantalla emergente de EXPORTAR LICENCIAS Y COMISIONES MENORES A 22 DÍAS -->
					</div>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
    </body>
</html>
