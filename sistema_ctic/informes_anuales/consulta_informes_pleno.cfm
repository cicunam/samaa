<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 29/08/2016 --->

<!--- Registrar la ruta del módulo actual --->

<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.InformesFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		InformesFiltro = StructNew();
		InformesFiltro.vInformeAnio = 0;
		//InformesFiltro.vActa = #Session.sSesion# - 1;
		InformesFiltro.vAcadNom = '';
		InformesFiltro.vDep = '';
		InformesFiltro.vPagina = '1';
		InformesFiltro.vRPP = '25';
		InformesFiltro.vOrden = 'nombre'; // 'asu_parte ASC, asu_numero'
		InformesFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.InformesFiltro = '#InformesFiltro#'>
</cfif>

<!--- Obtener la lista de decisiones del CTIC (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
    SELECT * 
    FROM catalogo_decision
    WHERE (dec_clave = 1 OR dec_clave = 4 OR  dec_clave > 48)
</cfquery>

<!--- Se genera un catálogo para filtrar por año de informe (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctInformeAnio" datasource="#vOrigenDatosSAMAA#">
    SELECT informe_anio
    FROM movimientos_informes_anuales
	GROUP BY informe_anio
    ORDER BY informe_anio DESC
</cfquery>

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
		<script type="text/javascript" src="../comun/java_script/mascara_entrada.js"></script>

		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// Desplegar la lista de movimientos:
			function fListarInformes(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('informes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('informes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_informes.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vInformeAnio=" + encodeURIComponent(document.getElementById('vInformeAnio').value);
				//parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value); //PENDIENTE POR USAR
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				if (document.getElementById('vDepClave')) parametros += "&vDepClave=" + encodeURIComponent(document.getElementById('vDepClave').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Imprimir la lista de movimientos:
			function fImprimirListado()
			{
				window.open("informes_academicos_imprime.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			function fGenerarNoOficios()
			{
				alert('JQUERY PARA ASIGNAR');
			}
		</script>
	</head>

	<body onLoad="fListarInformes(<cfoutput>#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table width="1024" class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">INFORMES ANUALES</span></td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td>
						</tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nuevo movimiento -->
						<tr>
							<td><input type="button" value="Agregar informe anual" class="botones" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
						</tr>
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<cfif #Session.sTipoSistema# IS 'stctic'>
                            <!-- Filtrar por -->
                            <tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Listados y Oficios</div></td>
                            </tr>
                            <tr>
                                <td valign="top">&nbsp;</td>
                            </tr>
							<cfif #Session.sUsuarioNivel# LTE 1> 
                                <!-- Tipo de oficios -->
                                <tr>
                                    <td><span class="Sans10Vi" align="justify">Asignar n&uacute;mero de oficio a los asuntos.</span></td>
                                </tr>
                                <!-- A partir del número de oficio --->
                                <tr>
                                    <td>
                                        <span class="Sans9GrNe">A partir del No.</span>
                                        <input name="vNoOficio" id="vNoOficio" type="text" maxlength="6" style="width: 40px;" class="datos">
										<!-- Registrar movimientos: Botón de comando -->
                                        <input type="button" value="Asignar" class="botones" onClick="fGenerarNoOficios();">
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">&nbsp;</td>
                                </tr>
							</cfif>
							<!-- Opción: Generar listado para CAAA y PELNO del CTIC -->
                            <tr>
                                <td><input type="button" value="Generar listado" class="botones" onClick="fGenerarListado();"></td>
                            </tr>
                            <!-- Opción: Generar oficios de informes anuales -->
                            <tr>
                                <td><input type="button" value="Generar oficios" class="botones" onClick="fGenerarOficios();"></td>
                            </tr>
                            <!-- Opción: Generar listado de acuse de oficios -->
                            <tr>
                                <td><input type="button" value="Generar oficios" class="botones" onClick="fGenerarOficios();"></td>
                            </tr>
                        </cfif>                        
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9Gr">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" style="width:95%;" value="<cfoutput>#Session.InformesFiltro.vAcadNom#</cfoutput>" class="datos" onKeyUp="fListarInformes(<cfoutput>#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
							</td>
						</tr>
<!---
						<!-- Sesión -->
						<tr>
							<td>
								<span class="Sans9Gr">Sesi&oacute;n:<br></span>	
								<input name="vActa" id="vActa" type="text"  size="5" style="width:55%;" class="datos" value="<cfoutput>#Session.InformesFiltro.vActa#</cfoutput>" onKeyPress="return MascaraEntrada(event, '9999');" onKeyUp="if (this.value != '') fListarInformes();">
							</td>
						</tr>
---->
                        <!-- Año de informe -->
                        <tr>
                            <td valign="top">
                                <span class="Sans9Gr">Año de informe:<br></span>
                                <select name="vInformeAnio" id="vInformeAnio" class="datos" style="width:95%;" onChange="fListarInformes(<cfoutput>#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
                                    <option value="0">--- Seleccione ---</option>
                                    <cfoutput query="ctInformeAnio">
                                    <option value="#informe_anio#" <cfif isDefined("Session.InformesFiltro.vInformeAnio") AND #informe_anio# EQ #Session.InformesFiltro.vInformeAnio#>selected</cfif>>#informe_anio#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!-- Dependencia -->
							<cfmodule template="#vCarpetaRaizLogica#/includes/select_entidades.cfm" filtro="InformesFiltro" funcion="fListarInformes" origendatos="#vOrigenDatosCATALOGOS#" ordenable="yes">
						<cfelse>
                        	<input type="hidden" name="vDepClave" id="vDepClave" value="<cfoutput>#Session.sIdDep#</cfoutput>">
						</cfif>

						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="InformesFiltro" funcion="fListarInformes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<!-- Lista de movimientos -->
					<div id="informes_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>

			</tr>
		</table>
	</body>
</html>
