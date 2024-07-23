<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 13/11/2019 --->

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.AcademicosMovFiltro')>
	<cfscript>
		AcademicosMovFiltro = StructNew();
		AcademicosMovFiltro.vAcadId = 0;
		AcademicosMovFiltro.vRfcAcad = '';
		AcademicosMovFiltro.vNomAcad = '';
		AcademicosMovFiltro.vFt = 0;
		AcademicosMovFiltro.vAnioMov = 0;		
		AcademicosMovFiltro.vPagina = '1';
		AcademicosMovFiltro.vRPP = '25';
		AcademicosMovFiltro.vOrden = 'ssn_id DESC, mov_fecha_inicio';
		AcademicosMovFiltro.vOrdenDir = 'DESC';
	</cfscript>
	<cfset Session.AcademicosMovFiltro = '#AcademicosMovFiltro#'>
</cfif>

<!--- Parámetros utilizados --->
<cfparam name="vAcadId" default="#Session.AcademicosMovFiltro.vAcadId#">
<cfparam name="vTipoMov" default='0'>

<!--- Fecha actual --->
<cfset vAnioActual = #VAL(LsDateFormat(now(),'yyyy'))#>

<!--- INCLUDE que abre la tabla de academicos e inserta en hidden tres datos --->
<cfinclude template="../include_datos_academico.cfm">
<!---
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos
		WHERE acd_id = #vAcadId#
	</cfquery>
--->

<cfquery name="ctAniosMov" datasource="#vOrigenDatosSAMAA#">
	SELECT YEAR(mov_fecha_inicio) AS vAnios
	FROM movimientos
	WHERE movimientos.acd_id = #vAcadId# 
	GROUP BY YEAR(mov_fecha_inicio)
    ORDER BY  YEAR(mov_fecha_inicio) DESC
</cfquery>

<!--- Abrir el catálogo de prefijos  (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT C1.mov_titulo, C1.mov_clave 
	FROM movimientos AS T1
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave
	WHERE T1.acd_id = #vAcadId# 
	GROUP BY C1.mov_titulo, C1.mov_clave 
</cfquery>


<!--- Abre tabla de solicitudes para indicar si esxiete solicitud en trámite--->
<cfquery name="tbSoliciudes" datasource="#vOrigenDatosSAMAA#">
	SELECT COUNT(*) AS vCuentaSol
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vAcadId# 
</cfquery>

<!---
<cfoutput>#Session.sModulo#<br /></cfoutput>
--->
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
		<!--- JAVA SCRIPT USO LOCAL EN EL MÓDULO ACADÉMICOS --->
		<cfinclude template="../javaScript_academicos.cfm">
		<script type="text/JavaScript">
	        function fInicioCargaPagina()
	        {
				document.getElementById('mPaMov').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico();
				//fCalulaAntigAcad();
				fSolicitudesProceso();
				fListarMovimientos(<cfoutput>#Session.AcademicosMovFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.AcademicosMovFiltro.vOrden#</cfoutput>','<cfoutput>#Session.AcademicosMovFiltro.vOrdenDir#</cfoutput>'); 
			}
			// Movimientos del académico:
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
				xmlHttp.open("POST", "movimientos_academico.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(<cfoutput>#vAcadId#</cfoutput>);
				parametros += "&vRfcAcad=" + encodeURIComponent('');
				parametros += "&vNomAcad=" + encodeURIComponent('');
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				parametros += "&vAniosMov=" + encodeURIComponent(document.getElementById('vAniosMov').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}
			// Imprimir la lista de movimientos:
			function fImprimirListado()
			{
				window.open("<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/movimientos/consultas/impresion/listado_movimientos_academico.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}			
		</script>
        <!--- JQUERY LOCAL --->
		<script type="text/javascript" language="JavaScript">
			// AJAX que despliega un mesanje qi existen solicitudes en trámite del académico
			function fSolicitudesProceso()
			{
				//alert('JQUERY PARA CONSULTAR SOLICITUDES EN PROCESO');
				$.ajax({
					async: false,
					method: "POST",
					data: {vpAcadId:<cfoutput>#vAcadId#</cfoutput>},
					url: "<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/consulta_solicitudes_proceso.cfm",
					success: function(data) {
						$("#solicitudes_proceso_dynamic").html(data);
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL ORDENAR LOS INFORMES');
						//location.reload();
					}
				});	
			}
		</script>

	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">MOVIMIENTOS</span></td>
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
						<!-- Menú -->
						<tr>
							<td>
								<div class="linea_menu"></div>
							</td>
						</tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Imprimir -->
						<tr>
							<td>
								<input  name="Submit4" type="button" class="botones" value="Imprimir" onClick="fImprimirListado();">
							</td>
						</tr>
						<!-- Opción: Regresar -->
						<tr>
							<td>
								<input type="button" value="Regresar" class="botones" onClick="history.back(1);">
							</td>
						</tr>
                        <!-- Desplega si existen solicitudes en proceso -->
                        <tr>
                            <td><div id="solicitudes_proceso_dynamic" ><!--DESPLEGA RESULTADO DE AJAX EN JQUERY --></div></td>
                        </tr>
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="AcademicosMovFiltro" funcion="fListarMovimientos" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
					<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
                    <cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
    			</td>
				<td width="844" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'MOVIMIENTOS ACADÉMICO-ADMINISTRATIVOS'>
                    <cfinclude template="../include_menus.cfm">
                    <br>
					<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/movimientos_filtro_select.cfm">
					<div id="movimientos_dynamic" width="844">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>
