<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/02/2015 --->
<!--- FECHA ÚLTIMA MOD: 04/12/2015 --->

<!--- ESTE PARÁMETRO DE UNTILIZA EN CASO DE QUE LAS VARIABLE DE SESIÓN DEL MÓDULO NO ESTEN DEFINIDAS --->
<cfparam name="vpSolIdBusqueda" default="">

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosEntidadFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosEntidadFiltro = StructNew();
		AsuntosEntidadFiltro.vFt = 0;
		AsuntosEntidadFiltro.vAcadNom = '';
		AsuntosEntidadFiltro.vDepId = '';
		AsuntosEntidadFiltro.vNumSol = #vpSolIdBusqueda#;
		AsuntosEntidadFiltro.vOrden = 'sol_id';
		AsuntosEntidadFiltro.vOrdenDir = 'ASC';
		AsuntosEntidadFiltro.vPagina = '1';
		AsuntosEntidadFiltro.vRPP = '25';
		AsuntosEntidadFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.AsuntosEntidadFiltro = '#AsuntosEntidadFiltro#'>
</cfif>
<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_status = 1 
    ORDER BY mov_orden
</cfquery>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT dep_clave, dep_siglas
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' 
    AND dep_tipo <> 'PRO'
    AND dep_status = 1
    ORDER BY dep_tipo, dep_siglas
</cfquery>

<!--- Obtenerla fecha de hoy para compararla con la anterior --->
<cfset vFechaHoy = #LsDateFormat(Now(),"dd/mm/yyyy")#>
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
			// Variables globales:
			var vAsuntoCAAA = false;
			// Listar las solicitudes:
			function fListarSolicitudes(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						// Actualizar lista de solicitudes:
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						// Actualizar contador de registros:
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
						// Actualizar el texto del filtro:
						if (document.getElementById('vFt').value == 0) document.getElementById('vFiltroActual').innerHTML = 'Todas las solicitudes';
						else document.getElementById('vFiltroActual').innerHTML = 'FT-CTIC-' + document.getElementById('vFt').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "lista_solicitudes_entidades.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Imprimir la lista de solicitudes:
			function fImprimirListado()
			{
				window.open("impresion/listado_revisiones.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fListarSolicitudes(<cfoutput>#Session.AsuntosEntidadFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AsuntosEntidadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosEntidadFiltro.vOrdenDir#</cfoutput>');">
		<!-- Cintillo con nombre del módulo y Filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">SOLICITUDES EN LA ENTIDAD &gt;&gt; </span><span class="Sans9Gr">LISTADO</span></td>
				<td align="right">
					<cfoutput>
						<span class="Sans9GrNe">
							Filtro:
						</span>
						<span id="vFiltroActual" class="Sans9Gr">
							<cfif #Session.AsuntosEntidadFiltro.vFt# NEQ 0>
								FT-CTIC-#Session.AsuntosEntidadFiltro.vFt#
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
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;:</div></td>
						</tr>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Dependencia -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Entidad:<br></span>
								<select name="vDepId" id="vDepId" class="datos" style="width:95%;" onChange="fListarSolicitudes(1,'<cfoutput>#Session.AsuntosEntidadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosEntidadFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todas</option>
									<cfoutput query="ctDependencia">
									<option value="#dep_clave#" <cfif isDefined("Session.AsuntosEntidadFiltro.vDepId") AND #dep_clave# EQ #Session.AsuntosEntidadFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosEntidadFiltro.vAcadNom#</cfoutput>" onKeyUp="if (this.value.length == 0 || this.value.length >= 3) fListarSolicitudes(1,'<cfoutput>#Session.AsuntosEntidadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosEntidadFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!-- Número de solicitud -->
						<tr>
							<td>
								<span class="Sans9GrNe">No. Solicitud:<br></span>
								<input name="vNumSol" id="vNumSol" type="text" style="width: 60px;" class="datos" value="<cfoutput>#Session.AsuntosEntidadFiltro.vNumSol#</cfoutput>" onKeyPress="return MascaraEntrada(event, '999999');" onKeyUp="fListarSolicitudes(1,'<cfoutput>#Session.AsuntosEntidadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosEntidadFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AsuntosEntidadFiltro" funcion="fListarSolicitudes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaINCLUDE#/movimientos_catalogo_select.cfm" filtro="0" funcion="fListarSolicitudes" sFiltrovFt="#Session.AsuntosEntidadFiltro.vFt#" sFiltrovOrden="#Session.AsuntosEntidadFiltro.vOrden#" sFiltrovOrdenDir="#Session.AsuntosEntidadFiltro.vOrdenDir#">
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
