<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 30/09/2009 --->

<!--- Obtener información del académico --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    WHERE acd_id = #vIdAcad#
</cfquery>
<!--- Obtener la lista de movimientos disponibles --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
	WHERE mov_clave <> 15 AND mov_clave <> 16 AND mov_clave <> 42
	AND (
	mov_status = 1	OR 
		(mov_clave = 61) <!--- Agregar a esta lista los movimientos no activos que se pueden agregar --->
	) 
	ORDER BY mov_orden
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<script type="text/javascript" src="xmlHttpRequest.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			<!--- NOTA: Si decidimos enviar parámetros particulares segun el tipo de movimientos, entonces utilizar esto:
			// Obtener la lista de periodos sabáticos del académico:
			function fListarPlazas()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstPlazas_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_plazas.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value); // Para hacer algunos filtros
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Obtener la lista de periodos sabáticos del académico:
			function fListarSabaticos()
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstSaba_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_sabaticos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('selAcad').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Obtener la lista de asuntos para recorsos de revisión, reconsideración y corrección a oficio:
			function fListarAsuntos(vTipo)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('lstAsuntos_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_asuntos.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('selAcad').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			--->
			// El usuario selecciona un movimiento:
			function fSeleccionMovimiento(vFt)
			{
				// Se el usuario seleccionó un movimiento válido:
				if (vFt != 0) 
				{
					fReestablecer();
					// Habilitar siempre el nombre del académico:
					document.getElementById("seleccion_acad_1").style.display = '';
					document.getElementById("seleccion_acad_2").style.display = '';
					<!--- NOTA: Si decidimos enviar parámetros particulares segun el tipo de movimientos, entonces utilizar esto:
					// Determinar si se debe mostrar alguna lista antes del boton "Siguiente":
					if (vFt==5 || vFt==15 || vFt==16 || vFt==17 || vFt==28 || vFt==42)
					{
						fListarPlazas();
						document.getElementById("seleccion_plaza_1").style.display = '';
				  		document.getElementById("seleccion_plaza_2").style.display = '';
					}
					else if (vFt==23 || vFt==32)
					{
						fListarSabaticos();
						document.getElementById("seleccion_sabatico_1").style.display = '';
				  		document.getElementById("seleccion_sabatico_2").style.display = '';
				  		if (vFt==23) document.getElementById('seleccion_sabatico_txt').innerHTML = 'Periodo sabático que va a informar:';
						if (vFt==32) document.getElementById('seleccion_sabatico_txt').innerHTML = 'Periodo sabático que va a modificar:';
					}
					else if (vFt==31 || vFt==35 || vFt==37)
					{
						document.getElementById("seleccion_asunto_1").style.display = '';
				  		document.getElementById("seleccion_asunto_2").style.display = '';
						if (vFt==31) 
						{
							fListarAsuntos('COR');
							document.getElementById("seleccion_asunto_txt").innerHTML = "Seleccione el asunto que desea corregir:";	
						}
						if (vFt==35) 
						{
							fListarAsuntos('REV');
							document.getElementById("seleccion_asunto_txt").innerHTML = "Seleccione el asunto al que desea imponer un recurso de revisión:";	
						}
						if (vFt==37) 
						{
							fListarAsuntos('REC');
							document.getElementById("seleccion_asunto_txt").innerHTML = "Seleccione el asunto al que desea imponer un recurso de reconsideración:";	
						}
					}
					else
					--->
					{
						document.getElementById("cmdSiguente").style.display = '';
					}
				}
			}
			// Validar la selección de un académico:
			function fValidaDatos()
			{
				<!--- NOTA: Si decidimos enviar parámetros particulares segun el tipo de movimientos, entonces utilizar esto:
				// Validar número de plaza:
				if (document.getElementById("vFt").value == 5 || document.getElementById("vFt").value == 15 || document.getElementById("vFt").value == 16 || document.getElementById("vFt").value == 17 || document.getElementById("vFt").value == 28 || document.getElementById("vFt").value == 42) 
				{
					if (!document.getElementById("vIdCoa")) 
					{
						alert('Espere, antes debe seleccionar un número de plaza.');
						return false;
					}
					else if (document.getElementById("vIdCoa").value == '')
					{
						alert('Por favor, seleccione un número de plaza.');
						return false;
					}
				}
				// Validar asunto relacionado:
				if (document.getElementById("vFt").value == 31 || document.getElementById("vFt").value == 35 || document.getElementById("vFt").value == 37) 
				{
					if (!document.getElementById("selAsunto")) 
					{
						alert('Espere, antes debe seleccionar un asunto.');
						return false;
					}
					else if (document.getElementById("selAsunto").value == '')
					{
						alert('Por favor, seleccione un asunto.');
						return false;
					} 
				}
				--->
				return true;
			}
			// Reestablecer el formulario:
			function fReestablecer() 
			{
				document.getElementById("seleccion_acad_1").style.display = 'none';
				document.getElementById("seleccion_acad_2").style.display = 'none';
				<!--- NOTA: Si decidimos enviar parámetros particulares segun el tipo de movimientos, entonces utilizar esto:
				document.getElementById("seleccion_plaza_1").style.display = 'none';
				document.getElementById("seleccion_plaza_2").style.display = 'none';
				document.getElementById("seleccion_asunto_1").style.display = 'none';
				document.getElementById("seleccion_asunto_2").style.display = 'none';
				document.getElementById("seleccion_sabatico_1").style.display = 'none';
				document.getElementById("seleccion_sabatico_2").style.display = 'none';
				--->
				document.getElementById("cmdSiguente").style.display = 'none';
			}
		</script>
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>            
	</head>
	<body>
		<!-- Cintillo con nombre del módulo --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">MOVIMIENTOS &gt;&gt; </span><span class="Sans9Gr">AGREGAR UN MOVIMIENTO</span></td>
			</tr>
		</table>
		<form  name="form" method="post" action="select_mov_n.cfm" onSubmit="fValidaDatos();">
			<input name="vIdAcad" type="hidden" value="<cfoutput>#vIdAcad#</cfoutput>">
			<table width="760" height="400" border="0">
				<tr>
					<!-- Parte izquierda -->
					<td width="180" height="240" valign="top">
						<!-- Menú lateral -->
						<table width="180" border="0" class="bordesmenu">
							<tr>
								<td><div class="linea_menu"></div></td>
							</tr>
							<!-- Menú de nuevo movimiento -->
							<tr>
								<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
							</tr>
							<!-- Botón de comando "Restablecer" -->
							<tr>
								<td valign="top">
									<input type="button" class="botones" value="Restablecer" onClick="document.forms[0].reset(); fReestablecer();">
								</td>
							</tr>
							<!-- Botón de comando "Cancelar" -->
							<tr>
								<td height="23" valign="top">
									<input onClick="window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');" type="button" class="botones" value="Cancelar">
								</td>
							</tr>
							<!---
							<!-- Navegación -->
							<tr><td height="15"></td></tr>
							<tr><td><div class="linea_menu"></div></td></tr>
							<tr>
								<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
							</tr>
							<!-- Regresar a la lista de solicitudes -->
							<tr>
								<td>
									<input type="button" class="botones" value="Regresar" onclick="window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');">
								</td>
							</tr>
							--->
						</table>
					</td>
					<!-- Parte derecha -->
					<td width="600" valign="top">
						<!-- Selección de Forma, Académico y Plaza (en su caso) -->			    
						<table style="width: 605px; margin: 10px 0px 10px 15px;" cellspacing="0">
							<!--Leyenda de selector de forma telegrámica -->    
							<tr>
								<td height="22" colspan="2" class="Sans9GrNe" style="padding: 5px; background-color: #9eb8d2">Seleccione el tipo de movimiento:</td>
							</tr>
							<!-- Selector de tipo de movimiento -->    
							<tr>
								<td colspan="2" style="padding: 5px; background-color: #9eb8d2">
									<select name="vFt" id="vFt" class="datos" style="width: 550px;" onChange="fSeleccionMovimiento(this.value)">
										<option value="" selected>SELECCIONE</option>
										<cfoutput query="ctMovimiento">
											<option value="#ctMovimiento.mov_clave#"> #ctMovimiento.mov_noft#.-#ctMovimiento.mov_titulo# <cfif #ctMovimiento.mov_clase# NEQ ''>#ctMovimiento.mov_clase#</cfif></option>
										</cfoutput>
									</select>
								</td>
							</tr>
							<!-- Selección del académico -->
							<tr><td height="18" colspan="2"></td></tr>
							<tr id="seleccion_acad_1" style="display: none;">
								<td colspan="2" class="Sans9GrNe">Nombre del acad&eacute;mico:</td>
							</tr>
							<tr id="seleccion_acad_2" style="display: none;">
								<td class="Sans9GrNe">
									<input type="text" class="datos" style="width: 550px;" value="<cfoutput>#Trim(tbAcademicos.acd_prefijo)# #Trim(tbAcademicos.acd_nombres)# #Trim(tbAcademicos.acd_apepat)# #Trim(tbAcademicos.acd_apemat)#</cfoutput>" disabled>
								</td>
							</tr>
							<tr><td height="18" colspan="2"></td></tr>
							<!---
							<!-- Seleción de número de plaza -->
							<tr><td height="18" colspan="2"></td></tr>
							<tr id="seleccion_plaza_1" style="display: none;">
								<td colspan="2"><span class="Sans9GrNe">Seleccione el n&uacute;mero de plaza al que hace referencia la convocatoria:</span></td>
							</tr>
							<tr id="seleccion_plaza_2" style="display: none;">
								<td id="lstPlazas_dynamic" style="text-align: left">
									<!-- AJAX: Lista de PLAZAS -->  
								</td>
							</tr>
							<!-- Seleción de periodo sabático -->
							<tr id="seleccion_sabatico_1" style="display: none;">
								<td colspan="2">
									<span id="seleccion_sabatico_txt" class="Sans9GrNe"></span>
								</td>
							</tr>
							<tr id="seleccion_sabatico_2" style="display: none;">
								<td id="lstSaba_dynamic" style="text-align: left">
									<!-- AJAX: Lista de sabáticos -->
								</td>
							</tr>
							<!-- Selección de oficio -->
							<tr id="seleccion_asunto_1" style="display: none;">
								<td colspan="2">
									<span id="seleccion_asunto_txt" class="Sans9GrNe">Seleccione el asunto que desea corregir:</span>
								</td>
							</tr>
							<tr id="seleccion_asunto_2" style="display: none;">
								<td id="lstAsuntos_dynamic" style="text-align: left">
									<!-- AJAX: Lista de oficios -->
								</td>
							</tr>
							--->
							<!-- Botón de comando "Siguiente" -->
							<tr>
								<td style="text-align: right;">
									<input id="cmdSiguente" type="submit" class="botones" value="Siguiente &gt;&gt;" style="display: none;">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
