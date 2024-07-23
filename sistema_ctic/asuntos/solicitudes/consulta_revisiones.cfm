<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/10/2009 --->
<!--- FECHA ÚLTIMA MOD: 04/12/2015 --->

<!--- ESTE PARÁMETRO DE UNTILIZA EN CASO DE QUE LAS VARIABLE DE SESIÓN DEL MÓDULO NO ESTEN DEFINIDAS --->
<cfparam name="vpSolIdBusqueda" default="">

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosRevisionFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosRevisionFiltro = StructNew();
		AsuntosRevisionFiltro.vFt = 0;
		AsuntosRevisionFiltro.vAcadNom = '';
		AsuntosRevisionFiltro.vDepId = '';
		AsuntosRevisionFiltro.vNumSol = #vpSolIdBusqueda#;
		AsuntosRevisionFiltro.vOrden = 'sol_id';
		AsuntosRevisionFiltro.vOrdenDir = 'ASC';
		AsuntosRevisionFiltro.vPagina = '1';
		AsuntosRevisionFiltro.vRPP = '25';
		AsuntosRevisionFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.AsuntosRevisionFiltro = '#AsuntosRevisionFiltro#'>
</cfif>

<!--- Obtener la fecha de la reunión de la CAAA  para evitar que se asignen casos a una reunión ya se celebrada --->
<cfquery name="tbSesionesCAAA" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_clave = 4 
    AND ssn_id = #Session.sSesion#
</cfquery>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT dep_clave, dep_siglas
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%'
	<cfif #Session.sUsuario# NEQ 'aram_st' AND #Session.sUsuarioNivel# LT 5>
        AND dep_tipo <> 'PRO'
        AND dep_status = 1
	<cfelseif #Session.sUsuarioNivel# EQ 20> 
        AND (dep_clave = '030101' OR dep_tipo = 'UPE')
        AND dep_status = 1                                
    </cfif>
    ORDER BY dep_tipo, dep_siglas
</cfquery>

<cfif #tbSesionesCAAA.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
	<cfset vFechaCAAA = #LsDateFormat(tbSesionesCAAA.ssn_fecha,"dd/mm/yyyy")#>
<cfelse>
	<cfset vFechaCAAA = #LsDateFormat(tbSesionesCAAA.ssn_fecha_m,"dd/mm/yyyy")#>
</cfif>
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
		<script type="text/javascript" src="../../comun/java_script/compara_fechas.js"></script>

		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// Variables globales:
			var vAsuntoCAAA = false;
			// Abrir la ventana de captura de nuevas solicitudes:
			function NuevaSolicitud()
			{
				window.location.replace('ft_selecciona/select_ft_acad.cfm')
			}
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
				xmlHttp.open("POST", "lista_solicitudes_recibidas.cfm", true);
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
			// Seleccionar/Deseleccionar una o todas las solicitudes:
			function fSeleccionarRegistro(vSolId, vTipo, vValor)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "seleccionar_solicitud.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent(vSolId);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				parametros += vValor == true ? "&vValor=TRUE": "&vValor=FALSE";
				// Pasar también los demás campos para seleccionar solo las solicitudes filtradas:
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Determinar si se seleccionaron asuntos que pasan a la CAAA:
				if (xmlHttp.responseText.indexOf('ASUNTOSCAAA') != -1)
				{
					vAsuntoCAAA = true;
				}
				else
				{
					vAsuntoCAAA = false;
				}
			}
			function fMarcarTodas(vValor)
			{
				// Marcar todas las solicitudes en la BD:
				fSeleccionarRegistro('TODAS', 3, vValor);
				// Actualizar la lista:
				fListarSolicitudes(1,'<cfoutput>#Session.AsuntosRevisionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosRevisionFiltro.vOrdenDir#</cfoutput>');
			}
			function fAsignarSesion()
			{
				// Verificar que el usuario no asigne solicitudes a una reunión de la CAAA ya celebrada:
				if (vAsuntoCAAA && (fCompararFechas('vFechaHoy', 'vFechaCAAA') == 0 || fCompararFechas('vFechaHoy', 'vFechaCAAA') == 1) && document.getElementById('vActa').value == <cfoutput>#Session.sSesion#</cfoutput>)
				{
					alert('Ha solicitado asignar asuntos a una reunión de la CAAA ya celebrada. Para poder realizar la operación antes debe corregir este problema.');
					return;
				}
				document.getElementById('solicitudes_dynamic').innerHTML = '';
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "asignar_sesion.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent('TODAS');
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Actualizar la lista al terminar:
				fMarcarTodas(false);
				// Avisar si hubo error por falta de algún PDF':
				if (xmlHttp.responseText.indexOf('FALTA-ARCHIVO-PDF') != -1) alert('No pudieron asignar algunas solicitudes por falta de documentación anexa (PDF).');
			}
			// Imprimir la lista de solicitudes:
			function fImprimirListado()
			{
				window.open("impresion/listado_revisiones.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fListarSolicitudes(<cfoutput>#Session.AsuntosRevisionFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AsuntosRevisionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosRevisionFiltro.vOrdenDir#</cfoutput>');">
		<!-- Fechas necesarias para validar la asignación de asuntos a la CAAA -->
		<cfoutput>
			<input name="vFechaHoy" id="vFechaHoy" type="hidden" value="#vFechaHoy#">
			<input name="vFechaCAAA" id="vFechaCAAA" type="hidden" value="#vFechaCAAA#">
		</cfoutput>
		<!-- Cintillo con nombre del módulo y Filtro -->
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">SOLICITUDES EN REVISI&Oacute;N &gt;&gt; </span><span class="Sans9Gr">LISTADO</span></td>
				<td align="right">
					<cfoutput>
						<span class="Sans9GrNe">
							Filtro:
						</span>
						<span id="vFiltroActual" class="Sans9Gr">
							<cfif #Session.AsuntosRevisionFiltro.vFt# NEQ 0>
								FT-CTIC-#Session.AsuntosRevisionFiltro.vFt#
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
						<cfif #Session.sUsuarioNivel# LT 5>
                            <!-- Opción: Nueva solicitud -->
                            <tr>
                                <td><input type="button" value="Nueva Solicitud" class="botones" onClick="NuevaSolicitud();"></td>
                            </tr>
                            <!-- Opción: Devolver solicitudes -->
                            <!--
                            <tr>
                                <td><input type="button" value="Devolver solicitud" class="botones" onclick="fDevolverSolicitud();"></td>
                            </tr>
                            --->
                            <tr>
                                <td>&nbsp;</td>
                            </tr>
                            <!-- Opción: Imprimir la lista de licencias y comisiones-->
                            <tr>
                                <td><div align="left" class="Sans10NeNe">Imprimir:</div></td>
                            </tr>
                            <tr>
                                <td><input type="button" value="Imprimir solicitudes" class="botones" onClick="fImprimirListado();"></td>
                            </tr>
                            <!-- Asignar a la sesion -->
                            <tr><td><br><div class="linea_menu"></div></td></tr>
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Asignar a sesi&oacute;n:</div></td>
                            </tr>
                            <!-- Descripción de la asignación a sesión -->
                            <tr>
                                <td><span class="Sans9Vi" align="justify">Asignar las solicitudes marcadas al periodo de sesi&oacute;n especificado.</span></td>
                            </tr>
                            <!-- Opción: Asignar a una sesión de consejo -->
                            <tr>
                                <td>
                                    <select name="vActa" id="vActa" class="datos">
                                        <cfoutput>
                                        <option value="#Session.sSesion#">#Session.sSesion#</option>
                                        <option value="#Session.sSesion + 1#">#Session.sSesion + 1#</option>
                                        <option value="#Session.sSesion + 2#">#Session.sSesion + 2#</option>
                                        </cfoutput>
                                    </select>
                                    <input type="button" value="OK" class="botones" style="width:30px;" onClick="fAsignarSesion();">
                                </td>
                            </tr>
						</cfif>
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Dependencia -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Entidad:<br></span>
								<select name="vDepId" id="vDepId" class="datos" style="width:95%;" onChange="fListarSolicitudes(1,'<cfoutput>#Session.AsuntosRevisionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosRevisionFiltro.vOrdenDir#</cfoutput>');">
									<option value="">Todas</option>
									<cfoutput query="ctDependencia">
									<option value="#dep_clave#" <cfif isDefined("Session.AsuntosRevisionFiltro.vDepId") AND #dep_clave# EQ #Session.AsuntosRevisionFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosRevisionFiltro.vAcadNom#</cfoutput>" onKeyUp="if (this.value.length == 0 || this.value.length >= 3) fListarSolicitudes(1,'<cfoutput>#Session.AsuntosRevisionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosRevisionFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!-- Número de solicitud -->
						<tr>
							<td>
								<span class="Sans9GrNe">No. Solicitud:<br></span>
								<input name="vNumSol" id="vNumSol" type="text" style="width: 60px;" class="datos" value="<cfoutput>#Session.AsuntosRevisionFiltro.vNumSol#</cfoutput>" onKeyPress="return MascaraEntrada(event, '999999');" onKeyUp="fListarSolicitudes(1,'<cfoutput>#Session.AsuntosRevisionFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AsuntosRevisionFiltro.vOrdenDir#</cfoutput>');">
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AsuntosRevisionFiltro" funcion="fListarSolicitudes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->
					<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
                	<!--- INCLUDE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<cfmodule template="#vCarpetaINCLUDE#/movimientos_catalogo_select.cfm" filtro="0" funcion="fListarSolicitudes" sFiltrovFt="#Session.AsuntosRevisionFiltro.vFt#" sFiltrovOrden="#Session.AsuntosRevisionFiltro.vOrden#" sFiltrovOrdenDir="#Session.AsuntosRevisionFiltro.vOrdenDir#">
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
