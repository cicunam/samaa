<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 12/06/2019 --->

<!--- Registrar la ruta del módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.InformeAnualFiltro')>
	<cfscript>
		InformeAnualFiltro = StructNew();
		InformeAnualFiltro.vAcadId = 0;
		InformeAnualFiltro.vPagina = '1';
		InformeAnualFiltro.vRPP = '25';
		InformeAnualFiltro.vOrden = 'informe_anio';
		InformeAnualFiltro.vOrdenDir = 'DESC';
	</cfscript>
	<cfset Session.InformeAnualFiltro = '#InformeAnualFiltro#'>
</cfif>

<!--- Parámetros utilizados --->
<cfparam name="vAcadId" default="#Session.InformeAnualFiltro.vAcadId#">
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
	SELECT catalogo_movimiento.mov_titulo, catalogo_movimiento.mov_clave 
	FROM movimientos
	LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave
	WHERE movimientos.acd_id = #vAcadId# 
	GROUP BY catalogo_movimiento.mov_titulo, catalogo_movimiento.mov_clave 
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
		<!--- JAVA SCRIPT USO LOCAL EN EL MÓDULO ACADÉMICOS --->
		<cfinclude template="../javaScript_academicos.cfm">
		<script type="text/JavaScript">
	        function fInicioCargaPagina()
	        {
				document.getElementById('mPaIa').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico();
				fListarInformes(<cfoutput>#Session.InformeAnualFiltro.vPagina#</cfoutput>,'<cfoutput>#Session.InformeAnualFiltro.vOrden#</cfoutput>','<cfoutput>#Session.InformeAnualFiltro.vOrdenDir#</cfoutput>'); 
			}
			// Movimientos del académico:
			function fListarInformes(vPagina, vOrden, vOrdenDir)
			{
				// Icono de espera:
				document.getElementById('informes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('informes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "informes_academico.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vIdAcad=" + encodeURIComponent(<cfoutput>#vAcadId#</cfoutput>);
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
				window.open("informes_academico_imprime.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
		</script>
	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">INFORMES ANUALES</span></td>
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
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaINCLUDE#/registros_pagina.cfm" filtro="InformeAnualFiltro" funcion="fListarInformes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaINCLUDE#/contador_registros.cfm">
					</table>
				</td>
				<td width="844" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'INFORMES ANUALES'>
                    <cfinclude template="../include_menus.cfm">
					<div id="informes_dynamic" width="844"><!-- AJAX: Lista de movimientos --></div>
				</td>
			</tr>
		</table>
		<script language="JavaScript" type="text/JavaScript">
            function ventanaInformeAnual() {
                $('#divInformeAnual').dialog('open');
            }
            // Ventana del diálogo (jQuery)
            $(function() {
                $('#dialog:ui-dialog').dialog('destroy');
                $('#divInformeAnual').dialog({
                    autoOpen: false,
                    height: 500,
                    width: 800,
                    modal: true,
                    title: "DETALLE INFORME ANUAL",
                    maxHeight: 400,
                    open: function() {
                        //'informe_detalle.cfm'
                        $(this).load('<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/informes_anuales/informe.cfm', {vInformeAnualId:$('#informe_anual_id').val(), vTipoComando:'CONSEMERGENTE'});
                    }
                });
            });

            function cierraVentanaInforme() 
            {
                //alert('CIERRA DIALOGO');
                $('#divInformeAnual').dialog('close');
				window.location.reload();
            }

            // Mostrar el formulario para cargar archivos:
            function fInformeId(vInformeAnualId)
            {
                document.getElementById('informe_anual_id').value = vInformeAnualId;
                ventanaInformeAnual();
            }						
        </script>
		<div id="divInformeAnual"><!-- INSETA AJAX PARA ACTIVAR EL FORMULARIO DE CAPTURA DE PUNTOS DEL ORDEN DEL DÍA --></div>
		<input type="<cfoutput>#vTipoInput#</cfoutput>" name="informe_anual_id" id="informe_anual_id" value="">        
	</body>
</html>
