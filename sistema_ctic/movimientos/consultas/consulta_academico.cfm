<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 09/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2022--->

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.MovimientosAcadFiltro')>
	<cfscript>
		MovimientosAcadFiltro = StructNew();
		MovimientosAcadFiltro.vIdAcad = '';
		MovimientosAcadFiltro.vRfcAcad = '';
		MovimientosAcadFiltro.vNomAcad = '';
		MovimientosAcadFiltro.vFt = '0';
		MovimientosAcadFiltro.vAnioMov = '0';
		MovimientosAcadFiltro.vPagina = '1';
		MovimientosAcadFiltro.vRPP = '25';
		MovimientosAcadFiltro.vOrden = 'mov_fecha_inicio DESC, ssn_id';
		MovimientosAcadFiltro.vOrdenDir = 'DESC';
	</cfscript>
	<cfset Session.MovimientosAcadFiltro = '#MovimientosAcadFiltro#'>
</cfif>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/jquery/jquery-ui-1.8.12.custom.css" rel="stylesheet" type="text/css">
			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<!--- <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/ajax_lista_academicos.js"></script> --->
    	    <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
            <!-- JQUERY -->
			<script type="text/javascript" src="#vCarpetaLIB#/jquery-1.5.1.min.js"></script>
            <script type="text/javascript" src="#vCarpetaLIB#/jquery-ui-1.8.12.custom.min.js"></script>
            <script type="text/javascript" src="#vCarpetaLIB#/jquery.activity-indicator-1.0.0.min.js"></script>
		</cfoutput>

		<!--- JAVA SCRIPT USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
            // Obtener los datos personales del académico:
			function fDatosAcademico()
			{
				if (document.getElementById('vAcadId').value != '')
				{
					// Icono de espera:
					document.getElementById('academico_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Función de atención a las petición HTTP:
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('academico_dynamic').innerHTML = xmlHttp.responseText;
							// Determinar si se encontró al académico:
							// fSolicitudesProceso();
							fFiltroMovimientos();
							if (document.getElementById('vAcadId').value != '' && parseInt(document.getElementById('vAcadId').value) > 0)
							//if (document.getElementById('academico_dynamic').innerHTML.toString().indexOf('ID:') != -1)
							{
								<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    $('#BotonNuevo').show();
                                    //document.getElementById('BotonNuevo').disabled = false;
                                <cfelse>
                                    $('#BotonNuevo').hide();
                                </cfif>
							}
							else	
							{	
                                $('#BotonNuevo').hide();
								//document.getElementById('BotonNuevo').disabled = true;
							}	
						}
					}
					// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
					xmlHttp.open("POST", "../../comun/academico_datos_v2.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vAcadId=" + encodeURIComponent(document.getElementById('vAcadId').value);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
				}	
			}

			// Despliega un INPUT SELECT con los :
			function fFiltroMovimientos()
			{
				if (document.getElementById('vAcadId').value != '' && document.getElementById('vAcadId').value != 0)
				{
					// Icono de espera:
					document.getElementById('filtroMovimientos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Función de atención a las petición HTTP:
					xmlHttp.onreadystatechange = function(){
						if (xmlHttp.readyState == 4) {
							document.getElementById('filtroMovimientos_dynamic').innerHTML = xmlHttp.responseText;
							// Determinar si se encontró al académico:
							fListarMovimientos(<cfoutput>#Session.MovimientosAcadFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosAcadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosAcadFiltro.vOrdenDir#</cfoutput>');
						}
					}
					// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
					xmlHttp.open("POST", "../../comun/movimientos_filtro_select.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vAcadId=" + encodeURIComponent(document.getElementById('vAcadId').value);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
				}	
			}			
			// Desplegar la lista de movimientos:
			function fListarMovimientos(vPagina, vOrden, vOrdenDir)
			{
				if (document.getElementById('vAcadId').value != '' || document.getElementById('vAcadNom').value != '' || document.getElementById('vAcadRfc').value != '')
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
					xmlHttp.open("POST", "movimientos_academico.cfm", true);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vIdAcad=" + encodeURIComponent(document.getElementById('vAcadId').value);
					parametros += "&vNomAcad=" + encodeURIComponent(document.getElementById('vAcadNom').value);
					parametros += "&vRfcAcad=" //+ encodeURIComponent(document.getElementById('vAcadRfc').value);
					if (document.getElementById('vFt')) parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
					parametros += "&vFiltroTipoMov=" + ""; 	// CREO QUE ESTE PARÁMETRO NO SE UTILIZA (!)
					parametros += "&vAniosMov=" + encodeURIComponent(document.getElementById('vAniosMov').value);
					parametros += "&vPagina=" + encodeURIComponent(vPagina);
					parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
					parametros += "&vOrden=" + encodeURIComponent(vOrden);
					parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
				}	
			}
			// Registrar la clave y el nombre del académico seleccionado:
			// Limpiar la lista de movimientos y los datos del académico:
			function fLimpiarLista()
			{
				fBorrarParametros();
				// Borrar los datos del académico:
				document.getElementById('academico_dynamic').innerHTML = '';
				// Borrar los movimientos del académico:
				document.getElementById('movimientos_dynamic').innerHTML = '';
				// Ocultar el filtro de tipo de movimiento:
				document.getElementById('filtroMovimientos_dynamic').innerHTML = '';
				// fSolicitudesProceso();
				// Deshabilitar el botón para agregar un nuevo registro:
                $('#BotonNuevo').hide();
				//document.getElementById('BotonNuevo').disabled = true;
                
			}
			// Abrir la ventana de captura de nuevo movimiento:
			function NuevoMovimiento()
			{
				window.location.replace('../mov_selecciona/select_mov.cfm?vIdAcad=' + document.getElementById('vAcadId').value);
			}
			// Imprimir la lista de movimientos:
			function fImprimirListado()
			{
				window.open("impresion/listado_movimientos_academico.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
		<script language="JavaScript" type="text/JavaScript">
            function fInformacionAcad()
            {
                document.forms['frmInfAcad'].submit();
            }

		</script>
		<!--- JQUERY LOCAL 
		<script type="text/javascript" language="JavaScript">
			// AJAX que despliega un mesanje qi existen solicitudes en trámite del académico
			function fSolicitudesProceso()
			{
				//alert('JQUERY PARA CONSULTAR SOLICITUDES EN PROCESO');
				$.ajax({
					async: false,
					method: "POST",
					data: {vpAcadId:$("#vAcadId").val()},
					url: "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/consulta_solicitudes_proceso.cfm",
					success: function(data) {
						$("#solicitudes_proceso_dynamic").html(data);
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL CONSULTAR SOLICITUDES EN PROCESO');
					}
				});	
			}
		</script>
		--->
	</head>
	<body onLoad="fDatosAcademico();"> <!--- fListarMovimientos(<cfoutput>#Session.MovimientosAcadFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.MovimientosAcadFiltro.vOrden#</cfoutput>','<cfoutput>#Session.MovimientosAcadFiltro.vOrdenDir#</cfoutput>');--->
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">MOVIMIENTOS &gt;&gt; </span><span class="Sans9Gr">POR ACAD&Eacute;MICO</span></td>
				<td align="right">
					<cfoutput><span class="Sans9Gr"><b>Filtro:</b> <cfif IsDefined("vIdAcad") AND #vIdAcad# NEQ 0>#vIdAcad#<cfelse>Ninguno</cfif></span></cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de movimientos -->
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<table width="180" border="0">
						<!-- Menú -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nuevo movimiento -->
						<tr>
							<td><input id="BotonNuevo" type="button" value="Nuevo movimiento" class="botones" onClick="NuevoMovimiento();" style="display: none"></td>
						</tr>
						<!-- Opción: Imprimir la lista -->
						<tr>
							<td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListado();"></td>
						</tr>
                        <!--- Desplega si existen solicitudes en proceso
                        <tr>
                            <td><div id="solicitudes_proceso_dynamic"> </div></td>DESPLEGA RESULTADO DE AJAX EN JQUERY
						</tr>
						--->
						<cfif #Session.sTipoSistema# IS 'sic'>
							<!-- Claves de las recomendaciones -->
							<tr id="Claves1"><td valign="top"><br><div class="linea_menu"></div></td></tr>
							<tr id="Claves2">
								<td valign="top"><div align="left" class="Sans10NeNe">Claves:</div></td>
							</tr>
							<tr id="Claves3">
								<td valign="top">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr><td class="Sans9Gr" width="15%">AP:</td><td class="Sans9Gr">Aprobar</td></tr>
										<tr><td class="Sans9Gr">NA:</td><td class="Sans9Gr">No Aprobar</td></tr>
										<!---
										<tr><td class="Sans9Gr">RT:</td><td class="Sans9Gr">Ratificar</td></tr>
										<tr><td class="Sans9Gr">NR:</td><td class="Sans9Gr">No Ratificar</td></tr>
										--->
										<tr><td class="Sans9Gr">OB:</td><td class="Sans9Gr">Objeto</td></tr>
										<tr><td class="Sans9Gr">PE:</td><td class="Sans9Gr">Pendiente por ausencia</td></tr>
										<tr><td class="Sans9Gr">CA:</td><td class="Sans9Gr">Cancelado</td></tr>
									</table>
								</td>
							</tr>
						</cfif>	
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="MovimientosAcadFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<!-- Filtro de la lista por académico --> 
					<table style="width:800px; margin:5px 0px 0px 15px; border:none" cellspacing="0" cellpadding="1">
						<tr>
							<!-- Titulo del recuadro -->
							<td style="padding: 5px; background-color: #FFCC66"><span class="Sans9ViNe">Buscar los movimientos del académico: <!---<cfoutput>#Session.MovimientosAcadFiltro.vIdAcad#</cfoutput>---></span></td>
							<!-- Botones de comando -->
							<td width="100" rowspan="2" bgcolor="#FFCC66">
								<table width="95%" border="0" cellspacing="0" bgcolor="#FFFFFF">
									<tr bgcolor="#FFCC66">
										<td align="center">
											<input type="button" class="botones" style="width: 80px;" onClick="fDatosAcademico();" value="BUSCAR">
										</td>
									</tr>
									<tr bgcolor="#FFCC66">
										<td align="center">
											<input type="reset" class="botones" value="LIMPIAR" style="width: 80px;" onClick="fLimpiarLista();">
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr bgcolor="#FFCC66">
							<!-- Ingreso de parámetros -->
							<td bgcolor="#FFCC66">
								<table style="margin:0px 5px 5px 5px;" border="0" cellspacing="0" callpadding="1">
									<!-- Nombre -->
									<tr>
										<td width="43"><span class="Sans9Ne">Nombre</span></td>
<!---
                                        <td>
											<span class="Sans9Ne">RFC</span>
											<br>
										</td>
--->
                                        <td><span class="Sans9Ne">Clave</span></td>
									</tr>
									<tr>
										<!-- Nombre -->
										<td>
											<input name="vAcadNom" id="vAcadNom" type="text" class="datos" maxlength="100" value="<cfoutput>#Session.MovimientosAcadFiltro.vNomAcad#</cfoutput>" style="width:450px" autocomplete="off"  onFocus="fBorrarParametros();"><!---  onKeyUp="fTeclas();" fListaSeleccionAcademico('NAME'); --->
                                            <!--- INCLUDE ADICIONAL PARA LA BÚSQUEDA DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
                                            <cfset vTipobusquedaValor = 'SelAcdMov'>
                                            <cfinclude template="#vCarpetaCOMUN#/lista_academicos_teclas_contol.cfm"></cfinclude>
                                            <br>
											<div id="lstAcad_dynamic" style="position:absolute;display:block;">
												<!-- AJAX: Lista desplegable de académicos -->
											</div>
										</td>
										<!-- RFC -->
<!---
                                        <td width="76" valign="top">
											<input name="vAcadRfc" id="vAcadRfc" type="text" size="14" maxlength="13" class="datos"  value="<cfoutput>#Session.MovimientosAcadFiltro.vRfcAcad#</cfoutput>" style="width:120px" onFocus="fBorrarParametros();" onKeyUp="//fListaSeleccionAcademico('RFC');">
										</td>
--->
										<!-- Número de académico -->
										<td width="13" align="right" valign="top">
											<input name="vAcadId" id="vAcadId" type="text" size="5" maxlength="5" class="datos"  value="<cfoutput>#Session.MovimientosAcadFiltro.vIdAcad#</cfoutput>" style="width:120px" onFocus="fBorrarParametros();" onKeyUp="//fListaSeleccionAcademico('CLAVE');" onKeyPress="return MascaraEntrada(event, '99999');">
											<input name="vSelAcad" id="vSelAcad" type="hidden" size="5" maxlength="5" style="width:120px" class="datos" value="">
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					<div id="academico_dynamic" width="85%">
						<!-- AJAX: Lista de movimientos -->
					</div>
					<div id="filtroMovimientos_dynamic" width="85%">
						<!-- AJAX: Despliega INPUT SELECT para filtrar por movimientos -->
					</div>
					<div id="movimientos_dynamic" width="85%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>

<!--- JAVA SCRIPT COMÚN PARA REALIZAR BÚSQUEDAD DE ACADÉMICOS (FECHA INCORPORA 12/11/2019) --->
<cfoutput>
    <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/ajax_lista_academicos_teclas.js"></script>
</cfoutput>
		
	<!--- JQUERY LOCAL --->
    <script type="text/javascript" language="JavaScript">
		// Ventana de dialogo para mostrar la lista de solicitudes en trámite:
		function fVentanaEmergeSolPorc()
		{
			//alert('HOLA');
			$('#ListaSolCons_jQuery').dialog('open');
		}
		
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
    				//fListarMovimientos(1,'mov_fecha_inicio','DESC');
                }
			});
		});
    </script>		