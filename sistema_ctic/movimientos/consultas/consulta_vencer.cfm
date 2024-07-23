<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 09/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 20/11/2015--->

<!--- Registrar la ruta del módulo actual --->
<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MovimientosVenceFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MovimientosVenceFiltro = StructNew();
		MovimientosVenceFiltro.vFt = 0;
		MovimientosVenceFiltro.vAcadNom = '';
		MovimientosVenceFiltro.vCn = '';
		MovimientosVenceFiltro.vDep = '';
		MovimientosVenceFiltro.vPagina = '1';
		MovimientosVenceFiltro.vRPP = '25';
		MovimientosVenceFiltro.vOrden = 'mov_fecha_final';
		MovimientosVenceFiltro.vOrdenDir = 'ASC';
	</cfscript>
	<cfset Session.MovimientosVenceFiltro = '#MovimientosVenceFiltro#'>
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
			<link href="#vCarpetaCSS#/jquery/jquery-ui-1.8.12.custom.css" rel="stylesheet" type="text/css">

			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
            <!-- JQUERY -->
			<script type="text/javascript" src="#vCarpetaLIB#/jquery-1.5.1.min.js"></script>
            <script type="text/javascript" src="#vCarpetaLIB#/jquery-ui-1.8.12.custom.min.js"></script>
            <script type="text/javascript" src="#vCarpetaLIB#/jquery.activity-indicator-1.0.0.min.js"></script>
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
				xmlHttp.open("POST", "movimientos_vencer.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
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
				window.open("impresion/listado_movimientos_vencer.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			function fSeleccionaSolicitud(vAcdId)
			{
				//alert(vAcdId);
				document.getElementById('acd_id').value = vAcdId;
				$("#acd_id").click();
			}
		</script>
        <!--- JQUERY LOCAL --->
		<script type="text/javascript" language="JavaScript">
            // Ventana de dialogo para mostrar la lista de solicitudes en trámite:
            $(function() {
                $('#dialog:ui-dialog').dialog('destroy');
                $('#ListaSolCons_jQuery').dialog({
                    autoOpen: false,
                    height: 200,
                    width: 780,
                    show: 'slow',
                    modal: true,
                    title: 'SOLICITUDES EN TRÁMITE',
                    open: function() {
                        $(this).load('<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/consulta_solicitudes_tramite_emergente.cfm',
                        {
                            vAcadId:$("#acd_id").val(),
                        });
                    }
                });
                $('#acd_id').click(function(){
                    $('#ListaSolCons_jQuery').dialog('open');
                });		
            });
        </script>
	</head>
	<body onLoad="fListarMovimientos(<cfoutput>#Session.MovimientosVenceFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosVenceFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosVenceFiltro.vOrdenDir#</cfoutput>');">
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
<!---
						<!-- Opción: Nuevo movimiento -->
						<tr>
							<td><input type="button" value="Nuevo movimiento" class="botones" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
						</tr>
--->
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
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
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" style="width:95%;" value="<cfoutput>#Session.MovimientosVenceFiltro.vAcadNom#</cfoutput>" class="datos" onKeyUp="fListarMovimientos(<cfoutput>#Session.MovimientosVenceFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosVenceFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosVenceFiltro.vOrdenDir#</cfoutput>');">
								<input type="<cfoutput>#vTipoInput#</cfoutput>" name="acd_id" id="acd_id" value="">
							</td>
						</tr>
						<!-- Categoría y Nivel -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Categor&iacute;a y nivel:<br></span>
								<select name="vCn" id="vCn" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.MovimientosVenceFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosVenceFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosVenceFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todas</option>
									<cfoutput query="ctCategoria">
									<option value="#cn_clave#" <cfif isDefined("Session.MovimientosVenceFiltro.vCn") AND #cn_clave# EQ #Session.MovimientosVenceFiltro.vCn#>selected</cfif>>#cn_siglas#</option>
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
									<select name="vDep" id="vDep" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.MovimientosVenceFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosVenceFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosVenceFiltro.vOrdenDir#</cfoutput>');">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif isDefined("Session.MovimientosVenceFiltro.vDep") AND #dep_clave# EQ #Session.MovimientosVenceFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
						</cfif>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="MovimientosVenceFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaRaizLogica#/includes/movimientos_catalogo_select.cfm" filtro="1" funcion="fListarMovimientos" sFiltrovFt="#Session.MovimientosVenceFiltro.vFt#" sFiltrovOrden="#Session.MovimientosVenceFiltro.vOrden#" sFiltrovOrdenDir="#Session.MovimientosVenceFiltro.vOrdenDir#">
					<div id="ListaSolCons_jQuery"><!-- JQUERY: Formulario de captura de nuevo oponente --></div>
					<!-- Lista de movimientos -->
					<div id="movimientos_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
