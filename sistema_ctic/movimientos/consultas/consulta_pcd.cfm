<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/02/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/07/2019--->

<!--- Registrar la ruta del módulo actual --->
<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MovimientosPcdFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MovimientosPcdFiltro = StructNew();
		MovimientosPcdFiltro.vFt = 0;
		MovimientosPcdFiltro.vAcadNom = '';
		MovimientosPcdFiltro.vCn = '';
		MovimientosPcdFiltro.vDep = '';
		MovimientosPcdFiltro.vPagina = '1';
		MovimientosPcdFiltro.vRPP = '25';
		MovimientosPcdFiltro.vOrden = 'ssn_id';
		MovimientosPcdFiltro.vOrdenDir = 'DESC';
	</cfscript>
	<cfset Session.MovimientosPcdFiltro = '#MovimientosPcdFiltro#'>
</cfif>

<!--- Obtener información del catálogo de categorías (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_cn 
    WHERE cn_status = 1 ORDER BY cn_clave
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
			function fListarMovimientos(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('movimientos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('movimientos_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "movimientos_pcd.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=";
				parametros += "&vCn=" + encodeURIComponent(document.getElementById('vCn').value);
				if (document.getElementById('vDep')) parametros += "&vDep=" + encodeURIComponent(document.getElementById('vDep').value);
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
				parametros = "vCn=" +   encodeURIComponent(document.getElementById('vCn').value);
				parametros += "&vDep=" + encodeURIComponent(document.getElementById('vDep').value);
				parametros += "&vOrden=" + encodeURIComponent('<cfoutput>#Session.MovimientosPcdFiltro.vOrden#</cfoutput>');
				parametros += "&vOrdenDir=" + encodeURIComponent('<cfoutput>#Session.MovimientosPcdFiltro.vOrdenDir#</cfoutput>');
				window.open("impresion/listado_movimientos_pcd.cfm?" + parametros, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fListarMovimientos(<cfoutput>#Session.MovimientosPcdFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosPcdFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosPcdFiltro.vOrdenDir#</cfoutput>');">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table width="98%" class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">MOVIMIENTOS &gt;&gt; </span><span class="Sans9Gr">PLAZAS / CONCURSOS DESIERTOS</span></td>
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
							<td><input type="button" value="Nuevo movimiento" class="botones" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
						</tr>
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Categoría y Nivel -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Categor&iacute;a y nivel:<br></span>
								<select name="vCn" id="vCn" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.MovimientosPcdFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosPcdFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosPcdFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todas</option>
									<cfoutput query="ctCategoria">
									<option value="#cn_clave#" <cfif isDefined("Session.MovimientosPcdFiltro.vCn") AND #cn_clave# EQ #Session.MovimientosPcdFiltro.vCn#>selected</cfif>>#cn_siglas#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!--Dependencia -->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!-- Dependencia -->
							<tr>
								<td valign="top">
									<span class="Sans9GrNe">Entidad:<br></span>
									<select name="vDep" id="vDep" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.MovimientosPcdFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosPcdFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosPcdFiltro.vOrdenDir#</cfoutput>');">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif isDefined("Session.MovimientosPcdFiltro.vDep") AND #dep_clave# EQ #Session.MovimientosPcdFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
						</cfif>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="MovimientosPcdFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaRaizLogica#/includes/movimientos_catalogo_select.cfm" filtro="1" funcion="fListarMovimientos" sFiltrovFt="#Session.MovimientosPcdFiltro.vFt#" sFiltrovOrden="#Session.MovimientosPcdFiltro.vOrden#" sFiltrovOrdenDir="#Session.MovimientosPcdFiltro.vOrdenDir#">
					<!-- Lista de movimientos -->
					<div id="movimientos_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
