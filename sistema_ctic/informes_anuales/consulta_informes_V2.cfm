<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2023 --->

<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.InformesFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		InformesFiltro = StructNew();
		InformesFiltro.vInformeAnio = #vAnioActual# - 1;
		InformesFiltro.vInformeStatus = #vInformeStatus#;
		InformesFiltro.vActa = #Session.sSesion# - 1;
		InformesFiltro.vAcadNom = '';
		InformesFiltro.vDep = '';
		InformesFiltro.vDecClave = 0;		
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
    WHERE dec_marca_ci = 1
</cfquery>

<!--- Se genera un catálogo para filtrar por año de informe (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctInformeAnio" datasource="#vOrigenDatosSAMAA#">
    SELECT informe_anio
    FROM movimientos_informes_anuales
	GROUP BY informe_anio
	ORDER BY informe_anio DESC
</cfquery>

<cfif #Session.sTipoSistema# EQ 'stctic'>
	<!--- Obtener las próximas sesiones --->
	<cfif #vInformeStatus# EQ 1>
		<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
			SELECT TOP 5 ssn_id FROM sesiones 
			WHERE ssn_clave = 1
			AND ssn_id >= #Session.sSesion#
			ORDER BY ssn_id
		</cfquery>
	<cfelseif #vInformeStatus# GT 1>
		<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
            SELECT DISTINCT T1.ssn_id
			FROM sesiones AS T1
            LEFT JOIN movimientos_informes_asunto AS T2 ON T1.ssn_id = T2.ssn_id
            LEFT JOIN movimientos_informes_anuales AS T3 ON T2.informe_anual_id = T3.informe_anual_id
            WHERE t1.ssn_clave = 1
            AND T3.informe_status = #vInformeStatus#
            ORDER BY ssn_id DESC
		</cfquery>
	</cfif>
</cfif>

<!--- Se genera un catálogo para filtrar por tipos decisión de los CI --->
<cfquery name="ctDecCI" datasource="#vOrigenDatosSAMAA#">
	SELECT C2.dec_clave, C2.dec_descrip
	FROM movimientos_informes_anuales AS T1
	LEFT JOIN catalogo_decision AS C2 ON T1.dec_clave_ci = C2.dec_clave 
	WHERE T1.informe_status = #vInformeStatus#
	GROUP BY C2.dec_clave, C2.dec_descrip
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

			<!--- JQUERY --->
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
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
                        /*
                        if (document.getElementById('vDepClave'))
                        {
                            if ($('#vDepClave').val() != '') 
                            {
                                $('#trDevolverInf').attr("style","display:");
                                $('#trDevolverInfB').attr("style","display:");
                            }
                            else
                            {
                                $('#trDevolverInf').attr("style","display:none");
                                $('#trDevolverInf').attr("style","display:none");
                            }
                        }
                        */
                        document.getElementById('informes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones
                <cfif #Session.sTipoSistema# EQ 'stctic'>
                    xmlHttp.open("POST", "lista_informes.cfm", true);
                <cfelseif #Session.sTipoSistema# EQ 'sic'>
                    xmlHttp.open("POST", "lista_informes_sic.cfm", true);
                </cfif>
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vInformeAnio=" + encodeURIComponent(document.getElementById('vInformeAnio').value);
				parametros += "&vInformeStatus=" + encodeURIComponent(document.getElementById('informe_status').value); //PENDIENTE POR USAR
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vDecClave=" + encodeURIComponent(document.getElementById('vDecClave').value);				
				if (document.getElementById('vDepClave')) parametros += "&vDepClave=" + encodeURIComponent(document.getElementById('vDepClave').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				<cfif #vInformeStatus# GT 1>
					parametros += "&vActa=" + encodeURIComponent(document.getElementById('vSsnId').value);
				</cfif>					
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado(vpInformeStatus)
			{
				if (vpInformeStatus == 2)
					window.open("impresion/listados_caaa.cfm?vpSsnId=" + document.getElementById('vSsnId').value + "&vpInformeAnio=" + document.getElementById('vInformeAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				if (vpInformeStatus == 3)
					window.open("impresion/listados_pleno.cfm?vpSsnId=" + document.getElementById('vSsnId').value + "&vpInformeAnio=" + document.getElementById('vInformeAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				if (vpInformeStatus == 4)
					window.open("impresion/listados_acta.cfm?vpSsnId=" + document.getElementById('vSsnId').value + "&vpInformeAnio=" + document.getElementById('vInformeAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");					
			}
			function fImprimirAcuse()
			{
				//alert('IMPRIME LISTADO');
				if (document.getElementById('vImprimirAcuses').value != '0')
				{
					if (document.getElementById('vImprimirAcuses').value == '1')
						window.open("impresion/listado_acuse_oficios_entidades.cfm?vpInformeAnio=" + $('#vInformeAnio').val() + "&vpDepClave=" + $('#vDepClave').val(), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
					if (document.getElementById('vImprimirAcuses').value == '2')
						window.open("impresion/listado_acuse_oficios_archivo.cfm?vpInformeAnio=" + $('#vInformeAnio').val() + "&vpDepClave=" + $('#vDepClave').val(), "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				else {alert('Seleccione que tipo de acuse que desea generar');}
			}

			// AJAX Mostrar la lista de asuntos en formato PDF:
			function fGeneraOficios()
			{
				window.open("impresion/oficios_informes.cfm?vpSsnId=" + document.getElementById('vSsnId').value + "&vpInformeAnio=" + document.getElementById('vInformeAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
			// Imprimir la lista de registros seleccionados en los filtros:
			function fImprimirListadoAcademicos()
			{
				window.open("impresion/listados_informes_recibe.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
        
		<!--- JQUERY USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// AJAX para importar a los académicos que son reportados en el CISIC
			function fImportarRegistros()
				{
				document.getElementById("loader").style.display = "block";
				//alert($("#InformeActual").val());				
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpDepClave:$("#vDepClave").val(),vpInformeAnio:$("#vInformeAnio").val()},
					url: "ajax/importar_academicos_cisic.cfm",
					success: function(data) {
						document.getElementById("loader").style.display = "none";						
						alert(data);
						location.reload();
						//fListarInformes();
					},
					error: function(data) {
						alert('ERROR AL ASIGNAR LA SESIÓN');
						//alert(data);	
					}
				});
			}
		
			// AJAX Asigna los informes a una sesión
			function fAsignarSesion()
			{
				document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpActa:$("#vSsnId").val(),vpInformeAnio:$("#vInformeAnio").val(),vpInformeAnualId:0,vpDepClave:$("#vDepClave").val(),vpDecClave:$("#vDecClave").val()},
					url: "ajax/asignar_sesion.cfm",
					success: function(data) {
						fOrdenarAsuntos();
						//location.reload();
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ASIGNAR LA SESIÓN');
						//alert(data);						
					}
				});
			}
			// AJAX para generar el número de oficios a los informes APROBADOS, APROBADOS CON COMENTARIO Y NO APROBADOS
			function fOrdenarAsuntos()
			{
				document.getElementById("loader").style.display = "block";
				//alert('JQUERY PARA ASIGNAR NO DE ASUNTO');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpInformeAnio:$("#vInformeAnio").val(),vpInformeStatus:$("#informe_status").val(),vpSsnId:$("#vSsnId").val()},
					url: "ajax/informes_ordenar.cfm",
					success: function(data) {
						document.getElementById("loader").style.display = "none";
						location.reload();
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						document.getElementById("loader").style.display = "none";						
						alert('ERROR AL ORDENAR LOS INFORMES');
						alert(data);						
						//location.reload();
					}
				});	
			}
			<!-- AJAX para asignar número de oficio -->
			function fAsignarNoOficios()
			{
				//alert($("#vNoOficio").val());
				if ($("#vNoOficio").val() > 0)
				{
					document.getElementById("loader").style.display = "block";
					//alert('ASIGNA SESION');				
					$.ajax({
						//async: false,
						method: "POST",
						data: {vpInformeAnio:$("#vInformeAnio").val(), vpNoOficioInicia:$("#vNoOficio").val(), vpSsnId:$("#vSsnId").val()},
						url: "ajax/asignar_no_oficio.cfm",
						success: function(data) {
							document.getElementById("loader").style.display = "none";							
							location.reload();
							//fListarInformes();
							//alert(data);
						},
						error: function(data) {
							alert('ERROR AL ASIGNAR LOS NÚMEROS DE OFICIO');
							//alert(data);						
						}
					});
				}
				else
				{alert('INDIQUE EL NÚMERO DE OFICIO INICAL');}
			}
			<!-- AJAX enviar asuntos de la CAAA al PLENO -->
			function fEnviaAsuntosPleno()
			{
				document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');				
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpActa:$("#vSsnId").val(), vpInformeAnio:$("#vInformeAnio").val()},
					url: "ajax/enviar_caaa_pleno.cfm",
					success: function(data) {
						//document.getElementById("loader").style.display = "none";							
						//location.reload();
						alert(data);
					},
					error: function(data) {
						alert('ERROR AL ASIGNAR LOS NÚMEROS DE OFICIO');
						//alert(data);						
					}
				});
			}
			<!-- AJAX para registrar los informes como asuntos finalizados -->
			function fRegistrarInformes()
			{
				document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');				
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpSsnId:$("#vSsnId").val(), vpInformeAnio:$("#vInformeAnio").val()},
					url: "ajax/genera_movimiento_informes.cfm",
					success: function(data) {
						document.getElementById("loader").style.display = "none";
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL GENERAR MOVIMIENTO DE INFORMES');
						//alert(data);						
					}
				});
			}
			
			//Agrega nuevo académico 
			function fAgregaAcademico() {
				document.getElementById('vAcadNom').id = 'vAcadNomTemp';
				$('#jquery_agrega_acd').dialog('open');
			}
			// Ventana del diálogo (jQuery)
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#jquery_agrega_acd').dialog({
					autoOpen: false,
					height: 150,
					width: 500,
					modal: true,
					maxHeight: 170,
					open: function() {
						//$('#divPunto').load('orden_dia_punto.cfm');
						$(this).load('agregar_academico.cfm',{vpInformeAnio:$("#vInformeAnio").val()});
						//alert($('#vPunto').val());
					}
				});
			});
            
			// Imprimir acuse con el listado de académicos a evaluar informa :
			function fImprimirAcuseEntidades()
			{
				window.open("impresion/sic_listados_informes_acuse.cfm?vpInformeAnio=" + document.getElementById('vInformeAnio').value, "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}            
            
			//Agrega nuevo académico 
			function fEnviaInformes()
			{
				document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');				
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpDepClave:$("#vDepClave").val(),vpInformeAnio:$("#vInformeAnio").val()},
					url: "ajax/enviar_informes_entidad_stctic.cfm",
					success: function(data) {
						document.getElementById("loader").style.display = "none";
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ENVIAR LOS REGISTROS DE INFOMES A LA SECRETARÍA TÉCNICA DEL CTIC');
						//alert(data);						
					}
				});
			}
/*            
			//Agrega nuevo académico 
			function fDevolverInformes()
			{
				document.getElementById("loader").style.display = "block";
				//alert('ASIGNA SESION');				
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpDepClave:$("#vDepClave").val(),vpInformeAnio:$("#vInformeAnio").val()},
					url: "ajax/informes_devolverEntidad.cfm",
					success: function(data) {
						document.getElementById("loader").style.display = "none";
						location.reload();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DEVOLVER LOS REGISTROS DE INFOMES A LA ENTIDAD ACADEMICA');
						//alert(data);						
					}
				});
			}
*/            
		</script>
	</head>

	<body onLoad="fListarInformes(<cfoutput>#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="98%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="20%" valign="top" class="bordesmenu">
                	<br>
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top">
								<div align="left" class="Sans10NeNe">MEN&Uacute;</div>
                                <input type="hidden" id="informe_status" name="informe_status" value="<cfoutput>#vInformeStatus#</cfoutput>">
								<input type="hidden" id="vInformeAnio" name="vInformeAnio" value="<cfoutput>#Session.InformesFiltro.vInformeAnio#</cfoutput>">
								<br>
							</td>
						</tr>
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<cfif #vInformeStatus# LTE 1>
                            <!-- Opción: Nuevo movimiento -->
                            <tr>
                                <td>
                                    <input type="button" value="Agregar académico al listado" class="botones" onClick="fAgregaAcademico();">
                                    <div id="jquery_agrega_acd" title="AGREGAR ACADÉMICO"><!-- AGREGAR NUEVO ACADÉMICO A INFORME --></div>
                                </td>
                            </tr>
							<cfif #Session.sTipoSistema# EQ 'sic'>
                                <!-- Opción: Imprimir listado -->
                                <tr>
                                    <td><input type="button" id="cmdImprimirLista" value="Imprimir listado para acuse" class="botones" onClick="fImprimirAcuseEntidades();"></td>
                                </tr>
						        <tr><td><br/></td></tr>
						        <tr><td><div class="linea_menu"></div></td></tr>
                                <tr>
                                    <td><span class="Sans10NeNe">Enviar los registros de informes a la <br/>Secretaría Técnica del CTIC</span></td>
                                </tr>
                                <tr>
                                    <td><input type="button" value="Enviar informes" class="botones" onClick="fEnviaInformes();"></td>
                                </tr>
							</cfif>
							<cfif #Session.sTipoSistema# EQ 'stctic'>
                                <!-- Opción: Indexar la lista -->
                                <tr>
                                    <td><input type="button" value="Imprimir listado" class="botones" onClick="fImprimirListadoAcademicos();"></td>
                                </tr>
                                <tr><td><br/></td></tr>
<!---
                                <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <!-- Opción: Devolver informes a las entidades académicas (se agregó el 23/02/2023)-->
                                    <tr id="trDevolverInf" style="display: none;">
                                        <td><input type="button" id="cmdDevolverInf" value="Devolver informes a la entidad" class="botones" onClick="fDevolverInformes();"></td>
                                    </tr>
                                    <tr id="trDevolverInfB" style="display: none;"><td><br/></td></tr>
                                </cfif>
--->
								<tr><td><div class="linea_menu"></div></td></tr>
                                <!-- Asignar sesión -->
                                <tr>
                                    <td valign="top"><div align="left" class="Sans10NeNe">Asignar a sesión:</div></td>
                                </tr>
                                <tr>
                                    <td valign="top">
										<cfmodule template="#vCarpetaINCLUDE#/module_catalogo_sesiones.cfm" SsnId="#Session.sSesion#">
	                                    <input type="button" value="OK" class="botones" style="width:30px;" onClick="fAsignarSesion();">
									</td>
                                </tr>
							</cfif>
						</cfif>
						<cfif #Session.sTipoSistema# EQ 'stctic' AND (#vInformeStatus# EQ 2 OR #vInformeStatus# EQ 3)>
							<!-- Imprimir listados -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Ordenar informes</div></td>
                            </tr>                        
                            <!-- Botón para ordenar informes -->
                            <tr>
                                <td><input type="button" id="cmdOrdenarInf" value="Ordenar" class="botones" onClick="fOrdenarAsuntos();"></td>
                            </tr>
							<!-- Imprimir listados -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Generar listado <cfif #vInformeStatus# EQ 2>CAAA:<cfelse>PLENO:</cfif></div></td>
                            </tr>                        
                            <!-- Botón imprimir listado -->
                            <tr>
                                <td><input type="button" id="cmdImpListadoInf" value="Imprimir" class="botones" onClick="fImprimirListado('<cfoutput>#vInformeStatus#</cfoutput>' );"></td>
                            </tr>
							<cfif #vInformeStatus# EQ 2>
                                <!-- Imprimir listados -->
                                <tr>
                                    <td valign="top"><div align="left" class="Sans10NeNe">Enviar al Pleno de CTIC</div></td>
                                </tr>                        
                                <!-- Botón imprimir listado -->
                                <tr>
                                    <td><input type="button" id="cmdEnviaPleno" value="Enviar" class="botones" onClick="fEnviaAsuntosPleno();"></td>
                                </tr>
							</cfif>
						</cfif>
						<cfif #Session.sTipoSistema# EQ 'stctic' AND #vInformeStatus# EQ 3>
							<!-- Imprimir listados -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Generar listado para ACTA</td>
                            </tr>                        
                            <!-- Botón imprimir listado -->
                            <tr>
                                <td><input type="button" id="cmdImpListadoInf" value="Imprimir" class="botones" onClick="fImprimirListado('4');"></td>
                            </tr>
							<tr><td><div class="linea_menu"></div></td></tr>
                            <!-- Asignar número de oficio -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Asignar No. Oficio:</div></td>
                            </tr>
                            <!-- Tipo de oficios -->
                            <tr>
                                <td><span class="Sans9ViNe" align="justify">Asignar n&uacute;mero de oficio a los informes</span></td>
                            </tr>
                            <!-- A partir del número de oficio --->
                            <tr>
                                <td>
                                    <span class="Sans9GrNe">A partir del No.</span>
                                    <input type="text" name="vNoOficio" id="vNoOficio" maxlength="6" style="width: 40px;" class="datos" onKeyPress="return MascaraEntrada(event, '999999');">
                                    <br/>
									<input type="button" value="Asignar" class="botones" onClick="fAsignarNoOficios();">                                    
                                </td>
                            </tr>
                            <!-- Imprimir oficios -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Generar oficios:</div></td>
                            </tr>
                            <tr>
                                <td valign="top"><input type="button" value="Generar oficios" class="botones" onClick="fGeneraOficios();"></td>
                            </tr>
                            <!-- Imprimir acuses -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Generar acuses:</div></td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    <select name="vImprimirAcuses" id="vImprimirAcuses" class="datos" style="width:95%;">
                                        <option id="Impacuse_0" value="0">SELECCIONE</option>
                                        <option id="Impacuse_1" value="1">Acuse para Entidades</option>
                                        <option id="Impracuse_2" value="2">Acuse para el archivo</option>
                                    </select>
                                </td>
                            </tr>
                            <!-- Botón imprimir listado -->
                            <tr>
                                <td><input type="cmdImpListadoInf" value="Imprimir" class="botones" onClick="fImprimirAcuse();"></td>
                            </tr>
                            <!-- División -->
                            <tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
                            <!-- Registrar informes -->
                            <tr>
                                <td valign="top"><div align="left" class="Sans10NeNe">Registrar informes:</div></td>
                            </tr>
                            <tr>
                                <td valign="top"><input type="button" value="Registrar" class="botones" onClick="fRegistrarInformes();"></td>
                            </tr>
						</cfif>
                        <!-- División -->
                        <tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
                                <cfoutput>
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" style="width:95%;" value="#Session.InformesFiltro.vAcadNom#" class="datos" onKeyUp="fListarInformes(#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#');">
								</cfoutput>
							</td>
						</tr>
						<cfif #Session.sTipoSistema# IS 'stctic'>
							<cfif #vInformeStatus# GT 1 >
                                <!-- Asignar sesión -->
                                <tr>
                                    <td valign="top"><div align="left" class="Sans9GrNe">Sesión:</div></td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                    <select name="vSsnId" id="vSsnId" class="datos" onChange="<cfoutput>fListarInformes(#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
										<option value="0">SELECCIONE</option>
                                        <cfoutput query="tbSesiones">
                                            <option value="#ssn_id#" <cfif #ssn_id# EQ #Session.InformesFiltro.vActa#>selected</cfif>>#ssn_id#</option>
                                        </cfoutput>
                                    </select>
                                </tr>
							</cfif>
							<!-- Dependencia -->
							<cfmodule template="#vCarpetaRaizLogica#/includes/select_entidades.cfm" filtro="InformesFiltro" funcion="fListarInformes" origendatos="#vOrigenDatosCATALOGOS#" ordenable="yes">
						<cfelse>
                        	<input type="hidden" name="vDepClave" id="vDepClave" value="<cfoutput>#Session.sIdDep#</cfoutput>">
						</cfif>
                        <!-- Asignar sesión -->
                        <tr>
                            <td valign="top"><div align="left" class="Sans9GrNe">Recomendación CI:</div></td>
                        </tr>
                        <tr>
                            <td valign="top">
                            <select name="vDecClave" id="vDecClave" class="datos" style="width: 100%;" onChange="<cfoutput>fListarInformes(#Session.InformesFiltro.vPagina#, '#Session.InformesFiltro.vOrden#', '#Session.InformesFiltro.vOrdenDir#'</cfoutput>);">
                                <option value="0">TODOS</option>
                                <cfoutput query="ctDecCI">
                                    <option value="#dec_clave#">#dec_descrip#</option><!--- <cfif #dec_clave# EQ #Session.sSesion#>selected</cfif>--->
                                </cfoutput>
                            </select>
                        </tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="InformesFiltro" funcion="fListarInformes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="80%" valign="top">
                	<br>
					<!-- Lista de movimientos -->
					<div id="informes_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
					<div id="agregar_acad_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
		<style>
			/* Center the loader */
			#loader {
			  position: absolute;
			  left: 50%;
			  top: 50%;
			  z-index: 1;
			  width: 150px;
			  height: 150px;
			  margin: -75px 0 0 -75px;
			  border: 16px solid #f3f3f3;
			  border-radius: 50%;
			  border-top: 16px solid #3498db;
			  width: 120px;
			  height: 120px;
			  -webkit-animation: spin 2s linear infinite;
			  animation: spin 2s linear infinite;
			}
			
			@-webkit-keyframes spin {
			  0% { -webkit-transform: rotate(0deg); }
			  100% { -webkit-transform: rotate(360deg); }
			}
			
			@keyframes spin {
			  0% { transform: rotate(0deg); }
			  100% { transform: rotate(360deg); }
			}		        
        </style>
		<div id="loader" style="display:none;"></div>
	</body>
</html>