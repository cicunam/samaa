<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 22/10/2009 --->
<!--- FECHA ÚLTIMA MOD: 02/09/2019 --->

<!--- ESTE PARÁMETRO SE UTILIZA EN CASO DE QUE LAS VARIABLE DE SESIÓN DEL MÓDULO NO ESTEN DEFINIDAS PARA LAS BÚSQUEDES --->
<cfparam name="vpSolIdBusqueda" default="">
<cfparam name="vpSsnIdBusqueda" default="#Session.sSesion#">

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AsuntosCAAAFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		AsuntosCAAAFiltro = StructNew();
		AsuntosCAAAFiltro.vFt = 0;
		AsuntosCAAAFiltro.vActa = '#vpSsnIdBusqueda#';
		AsuntosCAAAFiltro.vSeccion = '';
		AsuntosCAAAFiltro.vDepId = '';
		AsuntosCAAAFiltro.vAcadNom = '';
		AsuntosCAAAFiltro.vNumSol = #vpSolIdBusqueda#;		
		AsuntosCAAAFiltro.vPagina = '1';
		AsuntosCAAAFiltro.vRPP = '25';
		AsuntosCAAAFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.AsuntosCAAAFiltro = '#AsuntosCAAAFiltro#'>
</cfif>

<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT dep_clave, dep_siglas
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%' 
    AND dep_tipo <> 'PRO'
    AND dep_status = 1
    ORDER BY dep_tipo, dep_siglas
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
			<script type="text/javascript" src="#vHttpWebGlobal#/java_script/mascara_entrada.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>            
		</cfoutput>

		<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->


		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a la CAAA:
			function fListarSolicitudes(vPagina, vOrden, vOrdenDir)<!-- LAS ÚLTIMAS DOS VARIABLES NO SE OCUPAN, ES PARA HOMOLOGAR EL CÓDIGO Y USAR UN SOLO SELECT DE FT'S EN TODO EL SISTEMA -->
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						// Actualizar la lista de asuntos:
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						// Actualizar el contador de registros:
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
						// Actualizar el texto del filtro:
						if (document.getElementById('vFt').value == 0) document.getElementById('vFiltroActual').innerHTML = 'Todas las solicitudes';
						else document.getElementById('vFiltroActual').innerHTML = 'FT-CTIC-' + document.getElementById('vFt').value;
						fContadorRegSel();
						fJqDesplegaLigaCaaa();
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "asuntos_caaa.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vNumSol=" + encodeURIComponent(document.getElementById('vNumSol').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Actualizar el cintillo:
				document.getElementById('txtActa').innerHTML = 'SESI&Oacute;N ' + document.getElementById('vActa').value;
			}
			// Seleccionar/Deseleccionar una o todas las solicitudes:
			function fSeleccionarRegistro(vIdSol, vTipo, vValor)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "seleccionar_asunto.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdSol=" + encodeURIComponent(vIdSol);
				parametros += "&vTipo=" + encodeURIComponent(vTipo);
				parametros += vValor == true ? "&vValor=TRUE": "&vValor=FALSE";
				// Pasar también los demás campos para seleccionar solo las solicitudes filtradas:
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				fContadorRegSel();
			}
			function fMarcarTodas(vValor)
			{
				// Marcar todas las solicitudes en la BD:
				fSeleccionarRegistro('TODAS', 2, vValor);
				// Actualizar la lista:
				fListarSolicitudes(1);
				fContadorRegSel();				
			}
			// AJAX para enviar datos de variable de sesión con el conteo de registros marcados sin necesidad de refrescar todo el sitio 
			function fContadorRegSel()
			{
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						// Actualizar la lista de asuntos:
						document.getElementById('reg_seleccionados_dynamic').innerHTML = xmlHttp.responseText;

						//Verifica que haya registros seleccionados y que esté habilitado los botones
						//alert(document.getElementById('hiddRegMarcados').value);
						if (document.getElementById('hiddRegMarcados').value > 0)
						{ document.getElementById('cmdAprRat').disabled = false; }
						if (document.getElementById('hiddRegMarcados').value == 0)
						{ document.getElementById('cmdAprRat').disabled = true; }
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
				xmlHttp.open("POST", "ajax_registros_seleccion.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vSubmenuActivo=2";
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}			
			
			// Indexar todos los asuntos:
			function fIndexarAsuntos()
			{
				//if (!confirm("Esta operación sobre escribirá cualquier cambio que haya realizado manualmente. ¿Desea continuar?")) return;
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
/*                
				xmlHttp.onreadystatechange = function(){
                    alert(xmlHttp.readyState);
				    fListarSolicitudes(1);
                }
*/                
				// Generar una petición HTTP:
				xmlHttp.open("POST", "indexar_asuntos.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
                // Crear la lista de parámetros:
				parametros = "vpSsnId=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vReunion=" + encodeURIComponent('CAAA');
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Actualizar la lista al terminar:
				fListarSolicitudes(1);                
			}
			// Asignar recomendación "aprobatoria" a los asuntos sel</b>eccionados:
			function fAsignarRecomendacion()
			{
				document.getElementById('solicitudes_dynamic').innerHTML = '';
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Generar una petición HTTP:
				xmlHttp.open("POST", "recomendacion_decision.cfm", false);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				parametros = "vIdSol=" + encodeURIComponent('TODAS');
				parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);
				parametros += "&vReunion=" + encodeURIComponent('CAAA');
				parametros += "&vDecision=" + encodeURIComponent(100); <!-- Aprobar/Ratificar genérico (1,35) --->
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
				// Desmarcar todas las solicitudes y actualizar la lista:
				fMarcarTodas(false);
			}
			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado()
			{
				window.open("impresion/listado_caaa.cfm?vTipo=OTRO&vActa=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			// Imprimir la relación de asuntos para solicitar expedientes:
			function fImprimirSolExpedientes()
			{
				window.open("impresion/archivo_listado_solicitud_expediantes.cfm?vSsnId=" + document.getElementById('vActa').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			// Imprimir la relación de asuntos para entrega de documentos al archivo:
			function fGenerarListadoAsuntosProb()
			{
				window.open("impresion/listado_asuntos_probatorios.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
				setTimeout("fMarcarTodas(false);", 5000);
			}
			// Imprimir la relación de asuntos para entrega de documentos al archivo:
			function fGenerarListadoVerificaPlazas()
			{
				window.open("impresion/tabla_plazas_verifica.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
				setTimeout("fMarcarTodas(false);", 5000);
			}
			function fGenerarListadoPosdoc()
			{
				window.open("impresion/listado_caaa_becas_posdoc.cfm?vSsnId=" + encodeURIComponent(document.getElementById('vActa').value), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				// IMPORTANTE: Debido a que el llamado al archivo "oficios.cfm" no es sincrono, es necesario esperar a que se genere la impresión antes de desmarcar las solicitudes y actualizar la lista:
				setTimeout("fMarcarTodas(false);", 5000);
			}
		</script>
        
		<script language="JavaScript" type="text/JavaScript">
			function fJqDesplegaLigaCaaa()
			{
				//alert('MIEMBROS');
				$.ajax({
					async: false,
					method: "GET",
					//data: {},
					url: "ajax_caaa_liga.cfm",
					success: function(data) {
						$("#desplega_liga_caaa_dynamic").html(data);
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DESPELGAR LA INFORMACIÓN');
						//location.reload();
					}
				});
			}
		</script>
	</head>
	<body onLoad="<cfif #Session.AsuntosCAAAFiltro.vPagina# IS NOT ''>fListarSolicitudes(<cfoutput>#Session.AsuntosCAAAFiltro.vPagina#</cfoutput>);</cfif>">
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ASUNTOS QUE PASAN A LA CAAA &gt;&gt; </span><span id="txtActa" class="Sans9Gr"><!-- Número de acta--></span></td>
				<td align="right">
					<cfoutput>
						<span class="Sans9GrNe">
							Filtro:
						</span>	
						<span id="vFiltroActual" class="Sans9Gr">	
							<cfif #Session.AsuntosCAAAFiltro.vFt# NEQ 0>
								FT-CTIC-#Session.AsuntosCAAAFiltro.vFt#
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
					<div id="reg_seleccionados_dynamic" width="100%">
						<!-- AJAX: Para el conteo de registros marcados -->
					</div>
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;:</div></td>
						</tr>
						<!-- Opción: Indexar la lista -->
						<tr>
							<td><input type="button" value="Ordenar asuntos" class="botones" onClick="fIndexarAsuntos();"></td>
						</tr>
						<!-- Opción: Retirar asunto -->
						<!--
						<tr>
							<td><input type="button" value="Retirar asunto" class="botones" onclick="fRetirarAsunto();"></td>
						</tr>
						-->
						<!---
						<!-- División -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<!-- Asignar a la sesion -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Aprobar asuntos:</div></td>
						</tr>
						<!-- Descripción de la asignación a sesión -->
						<tr>
							<td><span class="Sans9Vi" align="justify">Asignar recomendación aprobatoria a los asuntos.</span></td>
						</tr>
						--->
						<!-- Opción: Aprobar/Ratificar -->
						<tr>
							<td><input type="button" id="cmdAprRat" value="Aprobar/Ratificar" class="botones" onClick="fAsignarRecomendacion();"></td>
						</tr>
						<!-- Opción: Imprimir listado para la CAAA -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><div align="left" class="Sans10NeNe">Imprimir:</div></td>
						</tr>
						<tr>
							<td><input id="cmdImpListado" type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
						<tr><td valign="top">Archivo</td></tr>
						<tr>
							<td><input id="cmdImpSolExpedientes" type="button" value="Imprimir solicitud expedientes" class="botones" onClick="fImprimirSolExpedientes();"></td>
						</tr>
						<tr id="trImpListaAsuntosProb">
							<td>
								<input id="cmdImpListaAsuntosProb" type="button" value="Generar listado probatorios" class="botones" onClick="fGenerarListadoAsuntosProb();">
							</td>
						</tr>
						<tr><td valign="top">Otros</td></tr>
						<tr id="trImpListaVerificaPlazas">
							<td>
								<input id="cmdImpListaAsuntosProb" type="button" value="Listado verifica plazas" class="botones" onClick="fGenerarListadoVerificaPlazas();">
							</td>
						</tr>
						<tr id="trImpListaPosdoct">
							<td>
								<input id="cmdImpListaAsuntosProb" type="button" value="Listado posdoctorales" class="botones" onClick="fGenerarListadoPosdoc();">
							</td>
						</tr>                        
                        <tr>
                            <td align="center">
		                        <div id="desplega_liga_caaa_dynamic"><!-- DIV para desplegar la opción de consulta de los asuntos que se verán en la CAAA ---></div>
							</td>
						</tr>
						<!---
						<!-- Imprimir la lista de asuntos -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Imprimir listado:</div></td>
						</tr>
						<!-- Imprimir la listado para la CAAA -->
						<tr>
							<td><input type="button" value="Para la CAAA" class="botones" onclick="fImprimirListado();"></td>
						</tr>
						--->
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<!-- Ir al Menú principal -->
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
						<!-- Acta (No. Sesión) -->
						<tr>
							<td>
								<span class="Sans9GrNe">Sesi&oacute;n:<br></span>
								<select name="vActa" id="vActa" class="datos" onChange="fListarSolicitudes(1);">
									<cfoutput>
									<option value="#Session.sSesion - 1#" <cfif isDefined("Session.AsuntosCAAAFiltro.vActa") AND #Session.AsuntosCAAAFiltro.vActa# EQ #Session.sSesion# - 1>selected</cfif>>#Session.sSesion - 1#</option>	
									<option value="#Session.sSesion#" <cfif isDefined("Session.AsuntosCAAAFiltro.vActa") AND #Session.AsuntosCAAAFiltro.vActa# EQ #Session.sSesion#>selected</cfif>>#Session.sSesion#</option>
									<option value="#Session.sSesion + 1#" <cfif isDefined("Session.AsuntosCAAAFiltro.vActa") AND #Session.AsuntosCAAAFiltro.vActa# EQ #Session.sSesion# + 1>selected</cfif>>#Session.sSesion + 1#</option>
									<option value="#Session.sSesion + 2#" <cfif isDefined("Session.AsuntosCAAAFiltro.vActa") AND #Session.AsuntosCAAAFiltro.vActa# EQ #Session.sSesion# + 2>selected</cfif>>#Session.sSesion + 2#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
<!---
						<!-- Sección -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Secci&oacute;n:</span><br>
								<!--- NOTA: Obtener esta lista del catálogo de partes --->
								<select name="vSeccion" id="vSeccion" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<option value="">Todas</option>
									<option value="1" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 1>selected</cfif>>Sección No. I</option>
									<option value="2.1" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 2.1>selected</cfif>>Sección No. II.I</option>
									<option value="2.2" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 2.2>selected</cfif>>Sección No. II.III</option>
									<option value="3" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 3>selected</cfif>>Sección No. III</option>
									<option value="3.1" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 3.1>selected</cfif>>Sección No. III.I</option>
									<option value="3.2" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 3.2>selected</cfif>>Sección No. III.II</option>
									<option value="3.4" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 3.4>selected</cfif>>Sección No. III.IV</option>
									<option value="4.1" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 4.1>selected</cfif>>Sección No. IV.I</option>
									<option value="4.2" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 4.2>selected</cfif>>Sección No. IV.III</option>
									<option value="4.4" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 4.4>selected</cfif>>Sección No. IV.IV</option>
									<option value="5" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 5>selected</cfif>>Sección No. V</option>
									<option value="6" <cfif isDefined("Session.AsuntosCAAAFiltro.vSeccion") AND #Session.AsuntosCAAAFiltro.vSeccion# EQ 6>selected</cfif>>Sección No. VI</option>
								</select>
							</td>
						</tr>
--->
						<!-- Dependencia -->
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Entidad:<br></span>
								<select name="vDepId" id="vDepId" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
									<option value="">Todas</option>
									<cfoutput query="ctDependencia">
									<option value="#dep_clave#" <cfif isDefined("Session.AsuntosCAAAFiltro.vDepId") AND #dep_clave# EQ #Session.AsuntosCAAAFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" style="width:95%;" class="datos" value="<cfoutput>#Session.AsuntosCAAAFiltro.vAcadNom#</cfoutput>" onKeyUp="if (this.value.length == 0 || this.value.length >= 3) fListarSolicitudes(1)">
							</td>
						</tr>
						<!-- Número de solicitud -->
						<tr>
							<td>
								<span class="Sans9GrNe">No. Solicitud:<br></span>
								<input name="vNumSol" id="vNumSol" type="text" style="width: 60px;" class="datos" value="<cfoutput>#Session.AsuntosCAAAFiltro.vNumSol#</cfoutput>" onKeyPress="return MascaraEntrada(event, '999999');" onKeyUp="fListarSolicitudes(1);">
							</td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AsuntosCAAAFiltro" funcion="fListarSolicitudes" ordenable="no">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->
					<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
                	<!--- MODULE PARA AGRAGAR SELECT CON EL CATÁLOGO DE MOVIMIENTOS --->
					<div style="float:left; width:65%; margin:5px 0px 5px 15px; padding:5px 5px 5px 5px; height:30px; background-color:#FFCC66">
						<cfmodule template="#vCarpetaINCLUDE#/module_movimientos_catalogo_select.cfm" filtro="0" funcion="fListarSolicitudes" sFiltrovFt="#Session.AsuntosCAAAFiltro.vFt#" sFiltrovOrden="0" sFiltrovOrdenDir="0">
					</div>
                	<!--- MODULE PARA AGRAGAR SELECT CON EL CATÁLOGO DE SECCIÓN PARA LOS ASUNTOS --->
					<div style="float:left; width:25%; margin:5px 0px 5px 15px; padding:5px 5px 5px 5px; height:30px; background-color:#FFCC66">
						<cfmodule template="#vCarpetaINCLUDE#/module_seccion_catalogo_select.cfm" funcion="fListarSolicitudes" sFiltrovSeccion="#Session.AsuntosCAAAFiltro.vSeccion#">                    
					</div>
					<div id="solicitudes_dynamic" width="100%">
						<!-- AJAX: Lista de solicitudes -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>