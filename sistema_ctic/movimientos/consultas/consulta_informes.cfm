<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 08/03/2017 --->

<!--- Registrar el módulo actual --->
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.InformesConsultaFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		InformesConsultaFiltro = StructNew();
		InformesConsultaFiltro.vInformeAnio = 0;
		InformesConsultaFiltro.vAcadNom = '';
		InformesConsultaFiltro.vDep = '';
		InformesConsultaFiltro.vDecCtic = '';
		InformesConsultaFiltro.vDecCi = '';        
		InformesConsultaFiltro.vPagina = '1';
		InformesConsultaFiltro.vRPP = '25';
		InformesConsultaFiltro.vOrden = 'nombre'; // 'asu_parte ASC, asu_numero'
		InformesConsultaFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.InformesConsultaFiltro = '#InformesConsultaFiltro#'>
</cfif>

<!--- Se genera un catálogo para filtrar por año de informe (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctInformeAnio" datasource="#vOrigenDatosSAMAA#">
	SELECT informe_anio
	FROM movimientos_informes_anuales
	WHERE informe_status IS NULL
	GROUP BY informe_anio
	ORDER BY informe_anio DESC
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
						document.getElementById('informes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "lista_informes.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vInformeAnio=" + encodeURIComponent(document.getElementById('vInformeAnio').value);
				//parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value); //PENDIENTE POR USAR
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				if (document.getElementById('vDepClave')) parametros += "&vDepClave=" + encodeURIComponent(document.getElementById('vDepClave').value);
				if (document.getElementById('vDecClaveCtic')) parametros += "&vDecClaveCtic=" + encodeURIComponent(document.getElementById('vDecClaveCtic').value);
				if (document.getElementById('vDecClaveCi')) parametros += "&vDecClaveCi=" + encodeURIComponent(document.getElementById('vDecClaveCi').value);                
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				parametros += "&vOrden=" + encodeURIComponent(vOrden);
				parametros += "&vOrdenDir=" + encodeURIComponent(vOrdenDir);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			// Imprimir la lista de registros seleccionados en los filtros:
			function fImprimirListadoAcademicos()
			{
				window.open("impresion/listado_informes_anuales.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}

            function fInformacionAcad(vAcdId)
            {
				$('#acdid').val(vAcdId) ;				
				$('#vpAnioConsulta').val($('#vInformeAnio').val());
				$('#frmInfAcad').submit();
            }
		</script>
	</head>

	<body onLoad="fListarInformes(<cfoutput>#Session.InformesConsultaFiltro.vPagina#, '#Session.InformesConsultaFiltro.vOrden#', '#Session.InformesConsultaFiltro.vOrdenDir#'</cfoutput>);">
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
							<td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;DADASD</div><br></td>
						</tr>
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Búsqueda por:</div></td>
						</tr>
						<!-- Académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Acad&eacute;mico:<br></span>
								<input name="vAcadNom" id="vAcadNom" type="text" size="15" style="width:95%;" value="<cfoutput>#Session.InformesConsultaFiltro.vAcadNom#</cfoutput>" class="datos" onKeyUp="fListarInformes(<cfoutput>#Session.InformesConsultaFiltro.vPagina#, '#Session.InformesConsultaFiltro.vOrden#', '#Session.InformesConsultaFiltro.vOrdenDir#'</cfoutput>);">
								<input type="<cfoutput>#vTipoInput#</cfoutput>" name="informe_anual_id" id="informe_anual_id" value="">                                
							</td>
						</tr>
						<!-- División -->
						<tr><td><div class="linea_menu"></div></td>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Filtrar por:</div></td>
						</tr>
                        <!-- Año de informe -->
                        <tr>
                            <td valign="top">
                                <span class="Sans9GrNe">Año de informe:<br></span>
                                <select name="vInformeAnio" id="vInformeAnio" class="datos" style="width:95%;" onChange="fListarInformes(<cfoutput>#Session.InformesConsultaFiltro.vPagina#, '#Session.InformesConsultaFiltro.vOrden#', '#Session.InformesConsultaFiltro.vOrdenDir#'</cfoutput>);">
                                    <option value="0">--- Seleccione ---</option>
                                    <cfoutput query="ctInformeAnio">
                                    <option value="#informe_anio#" <cfif isDefined("Session.InformesConsultaFiltro.vInformeAnio") AND #informe_anio# EQ #Session.InformesConsultaFiltro.vInformeAnio#>selected</cfif>>#informe_anio#</option>
                                    </cfoutput>
                                </select>
                                <input type="hidden" name="InformeActual" id="InformeActual" value="2016">
                            </td>
                        </tr>
						<cfif #Session.sTipoSistema# IS 'stctic'>
						    <!--- Módulo para incluir selección de catálogo de dependencias  --->
							<cfmodule template="#vCarpetaRaizLogica#/includes/select_entidades.cfm" filtro="InformesConsultaFiltro" funcion="fListarInformes" origendatos="#vOrigenDatosCATALOGOS#" ordenable="yes">
						<cfelse>
                        	<input type="hidden" name="vDepClave" id="vDepClave" value="<cfoutput>#Session.sIdDep#</cfoutput>">
						</cfif>
						<!--- Módulo para incluir selección de catálogo de decisiones CTIC (09/09/2022) --->
				        <cfmodule template="#vCarpetaRaizLogica#/includes/select_decision.cfm" filtro="InformesConsultaFiltro" funcion="fListarInformes" origendatos="#vOrigenDatosSAMAA#" tiporeunion="Ctic">
						<!--- Módulo para incluir selección de catálogo de decisiones evaluación deñConsejo Interno (09/09/2022)  --->
				        <cfmodule template="#vCarpetaRaizLogica#/includes/select_decision.cfm" filtro="InformesConsultaFiltro" funcion="fListarInformes" origendatos="#vOrigenDatosSAMAA#" tiporeunion="Ci">
						<!--- Selección de número de registros por página --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/registros_pagina.cfm" filtro="InformesConsultaFiltro" funcion="fListarInformes" ordenable="yes">
						<!--- Contador de registros --->
						<cfmodule template="#vCarpetaRaizLogica#/includes/contador_registros.cfm">
					</table>
				</td>
				<!-- Columna derecha (listado) -->  
				<td width="80%" valign="top">
                	<br>
					<div style="text-align:right;"><span class="Sans10GrNe" style="cursor:pointer;" onClick="fImprimirListadoAcademicos();">IMPRIMIR RELACIÓN</span></div>
					<!-- Lista de movimientos -->
					<div id="informes_dynamic" width="100%">
						<!-- AJAX: Lista de movimientos -->
					</div>
				</td>
			</tr>
		</table>
		<!--  FORM PARA IR A CONSULTAS DE INFORMACIÓN ACADÉMICA (04/09/2020)--->
		<cfform id="frmInfAcad" method="post" action="#vLigaInformacionAcad#" target="winConsultas">
			<cfinput type="#vTipoInput#" id="acdid" name="acdid" value="">
			<cfinput type="#vTipoInput#" id="vpSistemaAcceso" name="vpSistemaAcceso" value="#ToBase64('SAMAA.INFANUAL')#">
			<cfinput type="#vTipoInput#" id="vpSistemaPass" name="vpSistemaPass" value="#ToBase64('=31101!Cic8282SamaaInfAnual:?')#">
			<cfinput type="#vTipoInput#" id="vpAnioConsulta" name="vpAnioConsulta" value="">
		</cfform>        
        <div id="divInformeAnual"><!-- DIV PAR DESPLEGAR MODAL CON DETALLE DEL REGISTRO SELECCIONADO --></div>
		<script language="JavaScript" type="text/JavaScript">
            // Mostrar el formulario para cargar archivos:
            function fInformeId(vInformeAnualId)
            {
                document.getElementById('informe_anual_id').value = vInformeAnualId;
                ventanaInformeAnual();
            }		
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
                        //$(this).load('<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/informes_anuales/informe.cfm', {vInformeAnualId:$('#informe_anual_id').val(), vTipoComando:'CONSEMERGENTE'});
						$(this).load('modal_informe_detalle.cfm', {vInformeAnualId:$('#informe_anual_id').val(), vTipoComando:'CONSEMERGENTE'});						
                    }
                });
            });
            function fCierraVentanaInforme() 
            {
                //alert('CIERRA DIALOGO');
				//$('#divInformeAnual').modal('toggle');
                $('#divInformeAnual').dialog('close');
            }
        </script>
	</body>
</html>
