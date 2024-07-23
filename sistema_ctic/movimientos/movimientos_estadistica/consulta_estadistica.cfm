<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 11/01/2017 --->
<!--- FECHA ÚLTIMA MOD.: 13/03/2024 --->

<!--- Registrar la ruta del módulo actual --->
<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MovimientosEstadisticaFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MovimientosEstadisticaFiltro = StructNew();
		MovimientosEstadisticaFiltro.vDep = '';
		MovimientosEstadisticaFiltro.vCn = '';
		MovimientosEstadisticaFiltro.vAnio = '';
	</cfscript>
	<cfset Session.MovimientosEstadisticaFiltro = '#MovimientosEstadisticaFiltro#'>
</cfif>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctAnios" datasource="#vOrigenDatosSAMAA#">
	SELECT YEAR(ssn_fecha) AS anio 
	FROM sesiones
    WHERE YEAR(ssn_fecha) <= #LsDateFormat(Now(),'yyyy')#
	GROUP BY YEAR(ssn_fecha)
    ORDER BY YEAR(ssn_fecha) DESC
</cfquery>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' AND dep_status = 1 
    ORDER BY dep_siglas
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

		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// Desplegar la lista de movimientos:
			function fListarEstadistica()
			{
				// Icono de espera:
				document.getElementById('estadisticas_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('estadisticas_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "movimientos_estadistica.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vAnio=" + encodeURIComponent(document.getElementById('vAnio').value);
				if (document.getElementById('vDep')) parametros += "&vDep=" + encodeURIComponent(document.getElementById('vDep').value);
				parametros += "&vCnClase=" + encodeURIComponent(document.getElementById('vCnClase').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Imprimir la lista de movimientos:
			function fImprimirListado()
			{
				window.open("impresion/listado_movimientos_vencer.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fListarEstadistica();">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table width="98%" class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">MOVIMIENTOS &gt;&gt; </span><span class="Sans9Gr">POR SESI&Oacute;N</span></td>
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
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir informe" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<tr>
							<td>
								<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
							</td>
						</tr>
						--->
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
                        <!-- Filtro por año -->
                        <tr>
                            <td valign="top">
                                <span class="Sans9Gr">Año:<br></span>
                                <select name="vAnio" id="vAnio" class="datos" style="width:95%;" onChange="fListarEstadistica();">
                                    <cfoutput query="ctAnios" maxrows="7">
                                    <option value="#anio#" <cfif isDefined("Session.MovimientosEstadisticaFiltro.vAnio") AND #anio# EQ #Session.MovimientosEstadisticaFiltro.vAnio#>selected</cfif>>#anio#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
						<!-- Clase -->
						<tr>
							<td valign="top">
								<span class="Sans9Gr">Tipo de académico:<br></span>
								<select name="vCnClase" id="vCnClase" class="datos" style="width:95%;" onChange="fListarEstadistica();">
									<option value="">Todos</option>
									<option value="INV" <cfif isDefined("Session.MovimientosEstadisticaFiltro.vCn") AND 'INV' EQ #Session.MovimientosEstadisticaFiltro.vCn#>selected</cfif>>Investigadores</option>
									<option value="TEC" <cfif isDefined("Session.MovimientosEstadisticaFiltro.vCn") AND 'INV' EQ #Session.MovimientosEstadisticaFiltro.vCn#>selected</cfif>>Técnicos académicos</option>
								</select>
							</td>
						</tr>
						<!--Dependencia -->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!-- Dependencia -->
							<tr>
								<td valign="top">
									<span class="Sans9Gr">Dependencia:<br></span>
									<select name="vDep" id="vDep" class="datos" style="width:95%;" onChange="fListarEstadistica();">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif isDefined("Session.MovimientosEstadisticaFiltro.vDep") AND #dep_clave# EQ #Session.MovimientosEstadisticaFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
						</cfif>
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<!-- Lista de movimientos -->
					<div id="estadisticas_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
