<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2022 --->

<!--- Registrar la ruta del módulo actual --->
<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MovimientosSesionFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		MovimientosSesionFiltro = StructNew();
		MovimientosSesionFiltro.vFt = 0;
		MovimientosSesionFiltro.vActa = #Session.sSesion# - 1;
		MovimientosSesionFiltro.vAnio = #LsDateFormat(now(),'YYYY')#;
		MovimientosSesionFiltro.vAcadNom = '';
		MovimientosSesionFiltro.vDep = 0;
		MovimientosSesionFiltro.vPagina = '1';
		MovimientosSesionFiltro.vRPP = '25';
		MovimientosSesionFiltro.vOrden = 'asu_parte ASC, asu_numero';
		MovimientosSesionFiltro.vOrdenDir = 'ASC';
	</cfscript>
	<cfset Session.MovimientosSesionFiltro = '#MovimientosSesionFiltro#'>
</cfif>
<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_status = 1 
    ORDER BY mov_orden
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
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<!--- JQUERY --->
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->        
            <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>
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
				xmlHttp.open("POST", "movimientos_sesion.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				//parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				if (document.getElementById('radSesion').checked == true) parametros += "&vTipoSesionAnio=S";
				if (document.getElementById('radAnio').checked == true) parametros += "&vTipoSesionAnio=A";
				parametros += "&vSesionAnio=" + encodeURIComponent(document.getElementById('vSesionAnio').value);				
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
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
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				if (document.getElementById('radSesion').checked == true) parametros += "&vTipoSesionAnio=S";
				if (document.getElementById('radAnio').checked == true) parametros += "&vTipoSesionAnio=A";
				parametros += "&vSesionAnio=" + encodeURIComponent(document.getElementById('vSesionAnio').value);				
				window.open("impresion/listado_movimientos_sesion.cfm?" + parametros, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			function fImprimirSolExpedientes()
			{
				window.open("impresion/archivo_listado_solicitud_expediantes.cfm?vSsnId=" + document.getElementById('vSesionAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}            
			// Función que permite 
			function fFiltroSesAnio(vTipoFiltro)
			{
				if (vTipoFiltro == 'S') 
				{				
					document.getElementById('vSesionAnio').value = '<cfoutput>#Session.MovimientosSesionFiltro.vActa#</cfoutput>';
					document.getElementById('ArchivoPDFLinea').hidden = false;
					document.getElementById('ArchivoPDFEncabeza').hidden = false;
					document.getElementById('ArchivoPDF').hidden = false;
					document.getElementById('ArchivoPDFCmd').hidden = false;
					
				}
				if (vTipoFiltro == 'A') 
				{
					document.getElementById('vSesionAnio').value = '<cfoutput>#Session.MovimientosSesionFiltro.vAnio#</cfoutput>';
					document.getElementById('ArchivoPDFLinea').hidden = true;
					document.getElementById('ArchivoPDFEncabeza').hidden = true;
					document.getElementById('ArchivoPDF').hidden = true;
					document.getElementById('ArchivoPDFCmd').hidden = true;
				}
				fListarMovimientos(1,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>')				
			}
			// Imprimir la relación de asuntos para entrega de documentos al archivo:
			function fGenerarListadoArchivo()
			{
				
				if (document.getElementById('radSesion').checked == true)
				{
					window.open("impresion/listado_documentos_turnados_archivo.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vSesionAnio').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				if (document.getElementById('radAnio').checked == true) 
				{				
					alert('DEBE SELECCIONAR EN FILTROS LA OPCIÓN POR SESIÓN');
				}
				// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
			}
			
		</script>
	</head>
	<body onLoad="fFiltroSesAnio('S');fListarMovimientos(<cfoutput>#Session.MovimientosSesionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>');">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table width="1024" class="Cintillo">
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
						<!-- Opción: Nuevo movimiento -->
						<tr>
							<td><input type="button" value="Nuevo movimiento" class="botones" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
						</tr>
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<tr><td valign="top"><br></td></tr>
						<!--- SE GENERA LISTADO PARA ENTREGA DE DOCUMENTOS AL ARCHIVO (EL 17/05/219 SE MOVIÓ ESTA OPCIÓN DE SOLICITUDES EN EL CTIC A CONSULTA POR SESIÓN) ---> 
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LT 2>
							<tr>
								<td><div align="left"><span class="Sans10NeNe">Generar listado para el Archivo:</span></div></td>
							</tr>
							<tr id="trImpListaArchivo">
								<td><input id="cmdImpListaArchivoDocs" type="button" value="Generar MsExcel" class="botones" onClick="fGenerarListadoArchivo();"></td>
							</tr>
                            <!--- SE GENERA LISTADO PARA SOLICITAR EXPEDIENTES DE LA CAAA (IGUAL QUE EN EL MÓDULO DE LA CAAA) 23/02/2022 --->
                            <tr>
                                <td><input id="cmdImpSolExpedientes" type="button" value="Imprimir solicitud expedientes" class="botones" onClick="fImprimirSolExpedientes();"></td>
                            </tr>
						</cfif>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
							<!--- Include para consutar o anexar documento(s) en PDF (OFICIOS DIGITALIZADOS (NO LICENCIAS)) --->
							<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="OFICIOSG" AcdId="" NumRegistro="" SsnId="#Session.MovimientosSesionFiltro.vActa#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
						</cfif>
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
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" style="width:95%;" value="<cfoutput>#Session.MovimientosSesionFiltro.vAcadNom#</cfoutput>" class="datos" onKeyUp="fListarMovimientos(<cfoutput>#Session.MovimientosSesionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!-- Sesión / año --->
						<tr>
							<td>
								<span class="Sans9GrNe">                            
									<input type="radio" name="radSesAnio" id="radSesion" onClick="fFiltroSesAnio('S')" checked>Sesi&oacute;n <input type="radio" name="radSesAnio" id="radAnio" onClick="fFiltroSesAnio('A')">Año inicio mov.
								</span>                                
								<div>
									<input name="vSesionAnio" id="vSesionAnio" type="text"  size="5" style="width:55%;" class="datos" value="" onKeyPress="return MascaraEntrada(event, '9999');" onKeyUp="if (this.value != '') fListarMovimientos(<cfoutput>#Session.MovimientosSesionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>');">
									<!--- <cfoutput>#Session.MovimientosSesionFiltro.vActa#</cfoutput> --->
								</div>
							</td>
						</tr>
						<!---
						<!-- Sesión -->
						<tr>
							<td>
								<div>
									<input name="vActa" id="vActa" type="text"  size="5" style="width:55%;" class="datos" value="<cfoutput>#Session.MovimientosSesionFiltro.vActa#</cfoutput>" onKeyPress="return MascaraEntrada(event, '9999');" onKeyUp="if (this.value != '') fListarMovimientos(<cfoutput>#Session.MovimientosSesionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>');">
								</div>                                    
							</td>
						</tr>
						--->						
						<!--Dependencia -->
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<!-- Dependencia -->
							<!---<cfmodule template="#vCarpetaRaizLogica#/includes/select_entidades.cfm" filtro="0" funcion="fListarMovimientos" sFiltrovFt="#Session.MovimientosSesionFiltro.vFt#" sFiltrovOrden="#Session.MovimientosSesionFiltro.vOrden#" sFiltrovOrdenDir="#Session.MovimientosSesionFiltro.vOrdenDir#">--->
							<tr>
								<td valign="top">
									<span class="Sans9GrNe">Entidad:<br></span>
									<select name="vDep" id="vDep" class="datos" style="width:95%;" onChange="fListarMovimientos(<cfoutput>#Session.MovimientosSesionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosSesionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosSesionFiltro.vOrdenDir#</cfoutput>');">
										<option value="">Todas</option>
										<cfoutput query="ctDependencia">
										<option value="#dep_clave#" <cfif isDefined("Session.MovimientosSesionFiltro.vDep") AND #dep_clave# EQ #Session.MovimientosSesionFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>
						</cfif>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="MovimientosSesionFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
					<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaRaizLogica#/includes/movimientos_catalogo_select.cfm" filtro="0" funcion="fListarMovimientos" sFiltrovFt="#Session.MovimientosSesionFiltro.vFt#" sFiltrovOrden="#Session.MovimientosSesionFiltro.vOrden#" sFiltrovOrdenDir="#Session.MovimientosSesionFiltro.vOrdenDir#">
					<!-- Lista de movimientos -->
					<div id="movimientos_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
