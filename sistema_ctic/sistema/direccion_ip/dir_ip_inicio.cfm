<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 22/02/2017 --->
<!--- FECHA ULTIMA MOD.: 22/02/2017 --->


<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.DireccionIpFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		DireccionIpFiltro = StructNew();
		DireccionIpFiltro.vPagina = '1';
		DireccionIpFiltro.vRPP = 25;
	</cfscript>
	<cfset Session.DireccionIpFiltro = '#DireccionIpFiltro#'>
</cfif>

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
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>

			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/valida_campo_lleno.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/limpia_validacion.js"></script>
            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
            <!--- <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/valida_general.js"></script> --->
		</cfoutput>

		<!--- ******* JAVASCRIPT ******* --->
		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a la CAAA:
			function fListarDirIp(vPagina)
			{
				// Icono de espera:
				document.getElementById('direccionIp_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('direccionIp_dynamic').innerHTML = xmlHttp.responseText;
//						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
//						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "dir_ip_lista.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);

				// Actualizar el cintillo:
//				document.getElementById('txtActa').innerHTML = 'ACTA ' + document.getElementById('vActa').value;
			}

			function fActualizaDirIp(vTipoAccion, vCampo, vIpId)
			{
				//alert(vTipoAccion + '-' + vCampo + '-' + vIpId);
				var parametrosDirIP = 
				{
					"keyGuardaReg" : vTipoAccion,"vCampo" : vCampo,"vIpId" : vIpId, "vValorChk": $('#'+vCampo+'_'+vIpId).is(':checked') ? 1 : 0
				};
				
				$.ajax({
					data: parametrosDirIP,
					url: "dir_ip_formulario_guarda.cfm",
					type:'POST',
					success: function(data) {
						//alert(data);
						if (data != '')
							{alert('HA OCURRIDO UN ERROR INESPERADO, FAVOR DE INTENTAR MÁS TARDE');}

						else							
							{fListarDirIp(1);}
					},
					error: function(data) {
						alert('ERROR AL AGREGAR LA DIRECCIÓN IP');
					},
				});
			}

		</script>

		<!--- ******* JQUERY ******* --->
        <script language="JavaScript" type="text/JavaScript">
			// Mostrar el formulario para cargar archivos:
			function ventanaAgregaIp() {
				$('#divIpFormulario_jquery').dialog('open');
			}

			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divIpFormulario_jquery').dialog({
					autoOpen: false,
					height: 150,
					width: 450,
					modal: true,
					maxHeight: 150,
					title:'AGREGAR NUEVA DIRECCIÓN IP',
					open: function() {
						$(this).load('dir_ip_formulario.cfm',);
						//$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
			});				
		</script>
	</head>
	<body onLoad="fListarDirIp(1);">
		<!-- Control para capturar una ota acerca del asunto -->
		<span id="ComisionNota" class="emergente"></span>
		<!-- Cintillo con nombre del módulo y Filtro --> 
		<table class="Cintillo">
			<tr>
				<td>
					<span class="Sans9GrNe">
						ASIGNACIÓN DE DIRECCIONES IP'S PARA LAS REUNIONES DEL PLENO, CAAA Y COMISIÓN DE BECAS POSDOCTORALES
					</span>
				</td>
				<td align="right">
					<cfoutput>
					<span class="Sans9Gr"><b>SESIÓN:#Session.sSesion#</b></span>
					</cfoutput>
				</td>
			</tr>
		</table>
		<!-- Cuerpo de la lista de solicitudes -->
		<table width="1024" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<!-- Formulario de nueva solicitud -->
					<table width="180" border="0">
						<!-- División -->
						<tr><td width="146"><div class="linea_menu"></div></td></tr>
						<!-- Menú de la lista de solicitudes -->
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="DireccionIpFiltro" funcion="fListarSolicitudes" ordenable="no">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
			  </td>
				<!-- Columna derecha (listado) -->  
				<td width="844" valign="top">
					<div id="direccionIp_dynamic" width="100%"><!-- AJAX: Lista de solicitudes --></div>
					<div id="divIpFormulario_jquery"><!-- JQUERY PARA FORMULARIO DE NUEVA IP --></div>
				</td>
			</tr>
		</table>
		<p>&nbsp;</p>
		<p>&nbsp;</p>
    </body>
</html>
