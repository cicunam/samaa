<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 25/11/2015 --->

<!--- PENDIENTE --->

<!--- INCLUDE que abre la tabla de academicos e inserta en hidden tres datos --->
<cfinclude template="../include_datos_academico.cfm">
<!---
	<!--- Obtener información del académico --->
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos 
		WHERE acd_id = #vAcadId#
	</cfquery>
--->
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
		<!--- JAVA SCRIPT USO LOCAL EN EL MÓDULO ACADÉMICOS --->
		<cfinclude template="../javaScript_academicos.cfm">
		<script type="text/JavaScript">
	        function fInicioCargaPagina()
	        {
				<!-- LLAMADO DE INICIO -->
				document.getElementById('mPaE').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico(); 
				fCalulaAntigAcad();
			}
		</script>
	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">EST&Iacute;MULOS</span></td>
				<td align="right">
					<span class="Sans9Gr">
						<b>Filtro:</b> <cfoutput>#tbAcademico.acd_apepat# #tbAcademico.acd_apemat# #tbAcademico.acd_nombres#</cfoutput>
					</span>
				</td>
			</tr>
		</table>
		<table width="97%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="180" height="233" valign="top">
					<table width="180" border="0">
						<!-- Menú del submódulo -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<!-- Ir al menú principal -->
						<tr>
							<td>
								<input type="button" value="Menú principal" class="botones" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
							</td>
						</tr>
						--->
						<!-- Opción: Regresar -->
						<tr>
							<td>
								<input type="button" value="Regresar" class="botones" onClick="window.location.replace('../consulta_academicos.cfm');">
							</td>
						</tr>
					</table>
				</td>
				<td width="844" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'ESTÍMULOS DE LA DGAPA'>
					<cfinclude template="../include_menus.cfm">
					<!-- Contenido -->
					<table style="width:100%;  margin-left:15px; border:none;" cellspacing="0" cellpadding="1">	
						<!-- Espacio disponible -->
					</table>
					
				</td>
			</tr>
		</table>
	</body>
</html>
