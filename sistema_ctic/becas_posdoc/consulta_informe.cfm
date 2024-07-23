<!--- CREADO: ARAM PICHARDO --->
<!--- EDITÓ: ARAM PICHARDO --->
<!--- FECHA CREA: 19/03/2014 --->
<!--- FECHA ÚLTIMA MOD.: 18/02/2022 --->

<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.BecasInformeFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		BecasInformeFiltro = StructNew();
		BecasInformeFiltro.vFt = 0;
		BecasInformeFiltro.vAcadNom = '';
		BecasInformeFiltro.vCn = '';
		BecasInformeFiltro.vDep = '';
		BecasInformeFiltro.vPagina = '1';
		BecasInformeFiltro.vRPP = '25';
		BecasInformeFiltro.vOrden = 'acd_apepat';
		BecasInformeFiltro.vOrdenDir = 'ASC';
	</cfscript>
	<cfset Session.BecasInformeFiltro = '#BecasInformeFiltro#'>
</cfif>
<!--- Obtener la lista de dependencias del SIC --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' 
    AND dep_status = 1 ORDER BY dep_siglas
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
				xmlHttp.open("POST", "movimientos_informe.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
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
				window.open("movimientos_informe_imprime.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fListarMovimientos(<cfoutput>#Session.BecasInformeFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.BecasInformeFiltro.vOrden#</cfoutput>','<cfoutput>#Session.BecasInformeFiltro.vOrdenDir#</cfoutput>');">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table width="100%" class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">BECARIOS POSDOCTORALES &gt;&gt; </span><span class="Sans9Gr">PRESENTAR INFORME ANUAL O FINAL</span></td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="18%" valign="top" class="bordesmenu">
					<!-- Formulario de nueva solicitud -->
					<table width="95%" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td>
						</tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nuevo movimiento -->						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" value="<cfoutput>#Session.BecasInformeFiltro.vAcadNom#</cfoutput>" class="datos" onKeyUp="fListarMovimientos(<cfoutput>#Session.BecasInformeFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.BecasInformeFiltro.vOrden#</cfoutput>','<cfoutput>#Session.BecasInformeFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!--Dependencia -->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!-- Dependencia -->
							<tr>
								<td valign="top">
									<span class="Sans9GrNe">Entidad:<br></span>
									<select name="vDep" id="vDep" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.BecasInformeFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.BecasInformeFiltro.vOrden#</cfoutput>','<cfoutput>#Session.BecasInformeFiltro.vOrdenDir#</cfoutput>');">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif isDefined("Session.BecasInformeFiltro.vDep") AND #dep_clave# EQ #Session.BecasInformeFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
						</cfif>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="BecasInformeFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="82%" valign="top">
					<!-- Filtro de la lista por tipo de movimiento --><!-- Lista de movimientos -->
					<div id="movimientos_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
