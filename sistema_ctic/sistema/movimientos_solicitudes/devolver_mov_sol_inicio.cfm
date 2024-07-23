<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 20/11/2015 --->
<!--- FECHA �LTIMA MOD.: 03/09/2018 --->

<!--- Registrar la ruta del m�dulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

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

			<!--- LLAMADO A C�DIGO DE JAVA SCRIPT COM�N O GLOBAL --->        
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
		</cfoutput>

		<script language="JavaScript" type="text/JavaScript">
			function fSelTipoDevuelve()
			{
				if (document.getElementById('radSsn').checked == true)
				{
					//alert('SSNID');
					document.getElementById('vSsnId').disabled = false;
					document.getElementById('vFt').disabled = false;
					document.getElementById('vSolId').disabled = true;
				}
				if (document.getElementById('radSolId').checked == true)
				{
					//alert('SOLID');
					document.getElementById('vSsnId').disabled = true;
					document.getElementById('vFt').disabled = true;
					document.getElementById('vSolId').disabled = false;
				}
			}

			// Listar las asuntos que pasan a la CAAA:
			function fListarMovimientos()
			{
				if (document.getElementById('vSsnId').value.length == 4 || document.getElementById('vSolId').value.length == 6)
				{
					// Icono de espera:
					document.getElementById('movimientos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Funci�n de atenci�n a las petici�n HTTP:
					xmlHttp.onreadystatechange = function() {
						if (xmlHttp.readyState == 4) {
							document.getElementById('movimientos_dynamic').innerHTML = xmlHttp.responseText;
							document.getElementById('cmdDevMovSol').disabled = '';
						}
					}
					// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
					xmlHttp.open("POST", "movimientos_devolver_lista.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de par�metros:
					if (document.getElementById('radSsn').checked == true)
					{
						parametros = "vTipoDevolucion=SSNID";
						parametros += "&vActa=" + encodeURIComponent(document.getElementById('vSsnId').value);
						parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
					}
					if (document.getElementById('radSolId').checked == true)
					{
						parametros = "vTipoDevolucion=SOLID";
						parametros += "&vpSolId=" + encodeURIComponent(document.getElementById('vSolId').value);
					}
					//parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
					// Enviar la petici�n HTTP:
					xmlHttp.send(parametros);
				}
			}
			
			function fDevolverMovimientos()
			{

				// Icono de espera:
				document.getElementById('devolver_movimientos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Funci�n de atenci�n a las petici�n HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('devolver_movimientos_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('cmdDevMovSol').disabled = 'disabled';
						fListarMovimientos();
					}
				}
				// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "ajax_devolver_movimientos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de par�metros:
				if (document.getElementById('radSsn').checked == true)
				{
					parametros = "vTipoDevolucion=SSNID";
					parametros += "&vActa=" + encodeURIComponent(document.getElementById('vSsnId').value);
					parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				}
				if (document.getElementById('radSolId').checked == true)
				{
					parametros = "vTipoDevolucion=SOLID";
					parametros += "&vpSolId=" + encodeURIComponent(document.getElementById('vSolId').value);
				}
				//parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				// Enviar la petici�n HTTP:
				xmlHttp.send(parametros);
			}
		</script>
	</head>


	<body onLoad="">
		<!-- Control para capturar una ota acerca del asunto -->
		<span id="ComisionNota" class="emergente"></span>
		<!-- Cintillo con nombre del m�dulo y Filtro --> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">
						EXPORTAR LICENCIAS Y COMISIONES CON GOCE DE SUELDO
					</span>
				</td>
				<td align="right">
					<cfoutput>
					<span class="Sans9Gr"><b>SESI�N:#Session.sSesion#</b></span>
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
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- Divisi�n -->
						<tr><td width="146"><div class="linea_menu"></div></td></tr>
						<!-- Men� de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<!-- Opci�n: Imprimir listado -->
						<tr>
							<td>&nbsp;</td>
						</tr>
						<!-- Opci�n: Genera Archivo para Fortel -->
						<!-- Filtrar por -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Devolver movimientos a soliciudes</div></td>
						</tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe"><input id="radSsn" name="radSolDev" type="radio" onClick="fSelTipoDevuelve();" value="">Por sesi�n:</div></td>
						</tr>
						<tr>
							<td valign="top">
								<input name="vSsnId" id="vSsnId" type="text" maxlength="4"  size="5" style="width:30%;" class="datos" value="" onKeyPress="return MascaraEntrada(event, '9999');" onKeyUp="fListarMovimientos();">
							</td>
						</tr>
						<tr>
							<td valign="top">
                            <select name="vFt" id="vFt" class="datos100" onChange="fListarMovimientos();">
		                        <option value="0" selected>Todas las solicitudes</option>
                                <option value="100">Excepto LyC</option>
                                <option value="101">S&oacute;lo LyC</option>
							</select>
						</td>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe"><input id="radSolId" name="radSolDev" type="radio" onClick="fSelTipoDevuelve();" value="">Por solicitud:</div></td>
						</tr>
						<tr>
							<td valign="top">
								<input name="vSolId" id="vSolId" type="text" maxlength="10"  size="10" style="width:50%;" class="datos" value="" onKeyPress="return MascaraEntrada(event, '9999999999');" onKeyUp="fListarMovimientos();">
							</td>
						</tr>
						<tr>
							<td><input id="cmdDevMovSol" type="button" value="Devolver" class="botones" onClick="fDevolverMovimientos();" disabled></td>
						</tr>
					</table>
			  </td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<div id="devolver_movimientos_dynamic" width="100%">
						<!-- AJAX: Inicia el proceso de devoluci�n de MOVIMIENTOS REGISTRADOS a SOLICITUDES -->
					</div>
					<div id="movimientos_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos de sesi�n seleccionada -->
					</div>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
    </body>
</html>
