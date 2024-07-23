<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 19/03/2020 --->
<!--- FECHA ÚLTIMA MOD.: 29/04/2020 --->

<!doctype html>
<html>
	<head>
		<title>STCTIC - Miembros del CTIC</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>
		</cfoutput>
		<!--- JQUERY --->
        <script language="JavaScript" type="text/JavaScript">
			function fListaMiembrosPleno()
			{
				//alert('SESIONES');
				$.ajax({
					async: false,
					method: "POST",
					data: {vSesionActualPleno:<cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput>},
					url: "miembros_pleno.cfm",
					success: function(data) {
						$("#listaMiembrosPleno_dynamic").html(data);
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DESPELGAR LA INFORMACIÓN');
						//location.reload();
					}
				});
			}				
			// JQUERY para generar liga para sesión del pleno del CTIC
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divEnviaCorreoClpCtic').dialog({
					autoOpen: false,
					height: 200,
					width: 450,
					modal: true,
					maxHeight: 700,
					title:'CORREO LA SESIÓN ORDINARIA DEL PLENO DEL CTIC',
					open: function() {
						$(this).load('clpctic_genera_liga.cfm',{vSesionActualPleno:<cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput>, vMuestraLiga:'T'});
//						$(this).load('caaa_correo.cfm', {vpSesion:('dos'), vDepId:('uno')});
//						$(this).load('libera_registro.cfm', {vNumero:$('#vNumero').val(), vTipoRegistro:$('#vTipoRegistro').val(), vValorLibera:$('#cmdLibera').is(':checked') ? 1 : 0});
					}
				});
				$('#cmdGeneraLigaPCtic').click(function(){
					$('#divEnviaCorreoClpCtic').dialog('open');
				});
			});
			function vValidaCorreo()
			{
				if (document.getElementById('txtAsunto').value == '')
				{alert('Campo: ASUNTO es obligarorio.\n');}
				else
				{
					document.forms['frmCorreo'].action = 'miembros_pleno_correo_envia.cfm'
					document.forms['frmCorreo'].submit()
				}
			}					
		</script>
	</head>

	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">CORREO/LIGA A SESI&Oacute;N DEL PLENO</span></td>
				<td align="right">
	                <cfinclude template="#vCarpetaINCLUDE#/sesion_vigente.cfm">
				</td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="1024" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top">
					<!-- Controles -->
					<table width="155" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<tr><td height="18px;"></td></tr>
						<tr>
							<td height="18px;"><span class="Sans10NeNe">Sesión Pleno <cfoutput>(#LsNumberFormat(Session.sSesion,'9999')#)</cfoutput></span></td>
						</tr>
						<tr>
							<td><span class="Sans10NeNe">Generar liga</span></td>
						</tr>
						<tr>
							<td valign="top"><input name="cmdGeneraLigaPCtic" id="cmdGeneraLigaPCtic" type="button" class="botones" value="Generar liga"></td>
						</tr>
						<tr><td height="10px;"></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Enviar correo electrónico</span></td>
						</tr>

						<tr>
							<td><input name="cmdEnviarCorreoPCtic" id="cmdEnviarCorreoPCtic" type="button" class="botones" value="Enviar" onClick="fListaMiembrosPleno();"></td>
						</tr>

						<!-- Contador de registros -->
						<tr>
						  <td valign="top"><br><div class="linea_menu"></div></td></tr>
					</table>
				</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top" align="center">
					<div id="divEnviaCorreoClpCtic" width="100%">
						<!-- JQUERY: DIV que para desplegar la liga a generar para el envío de correos para los miembros del CTIC-->
					</div>
					<div id="listaMiembrosPleno_dynamic" width="100%">
						<!-- JQUERY: DIV que para desplegar pantalla emergente para el envío de correos a los miembros del pleno del CTIC -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>