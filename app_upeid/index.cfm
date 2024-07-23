<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 03/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 03/11/2017 --->
<!--- PÁGINA DE INICIO PARA LA CONSULTA DE ASUNTOS A EVALUAR LA COMISIÓN DE LA RAI --->
<!--- COMISIÓN DE DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS --->

<!--- Parámetros --->
<cfset vTituloSistema= UCASE('Comisión Especial de Evaluación de los académicos adscritos a la UPEID')>

<cfparam name="vSeccion" default="1">
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<cfif #vSeccion# EQ 1>
	<cfset vOnload = 'fListarAsuntos(1);'>
	<!--- Crear un arreglo para guardar la información del filtro --->
    <cfif NOT IsDefined('Session.ComisionUPEIDFiltro')>
        <!--- Crear un arreglo para guardar la información del filtro --->
        <cfscript>
            ComisionUPEIDFiltro = StructNew();
            ComisionUPEIDFiltro.vDepId = '';
            ComisionUPEIDFiltro.vAcadNom = '';
            ComisionUPEIDFiltro.vPagina = '1';
            ComisionUPEIDFiltro.vRPP = '25';
            ComisionUPEIDFiltro.vMarcadas = ArrayNew(1);
        </cfscript>
        <cfset Session.ComisionUPEIDFiltro = '#ComisionUPEIDFiltro#'>
    </cfif>
<cfelseif #vSeccion# EQ 2>
	<cfset vOnload = ''>
<cfelseif #vSeccion# EQ 3>
	<cfset vOnload = 'fListarInformes(1);'>
    <cfif NOT IsDefined('Session.ComisionUPEIDInfFiltro')>
        <!--- Crear un arreglo para guardar la información del filtro --->
        <cfscript>
            ComisionUPEIDInfFiltro = StructNew();
            ComisionUPEIDInfFiltro.vDepId = '';
            ComisionUPEIDInfFiltro.vAcadNom = '';
            ComisionUPEIDInfFiltro.vPagina = '1';
            ComisionUPEIDInfFiltro.vRPP = '25';
            ComisionUPEIDInfFiltro.vMarcadas = ArrayNew(1);
        </cfscript>
        <cfset Session.ComisionUPEIDInfFiltro = '#ComisionUPEIDInfFiltro#'>
    </cfif>
</cfif>

<!--- Obtener la lista de dependencias del SIC --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
	SELECT dep_nombre, dep_siglas, dep_clave FROM catalogo_dependencia 
    WHERE dep_tipo = 'UPE'
    AND dep_status = 1
    ORDER BY dep_nombre
</cfquery>

<!--- Obtener el número de sesión que se verá en la CAAA --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_clave = 20
    AND ssn_id = #Session.sSesion#
</cfquery>

<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / SAMAA - CEUPEID<cfelse>SAMAA - <cfoutput>#vTituloSistema#</cfoutput></cfif></title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">        

		<cfoutput>
			<link href="#vHttpWebGlobal#/css/jquery/jquery-ui-1.8.16.custom.css" type="text/css" rel="Stylesheet">
			<link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
    		<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>

			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-1.6.2.min.js"></script>
			<script type="text/javascript" src="#vHttpWebGlobal#/jquery/jquery-ui-1.8.16.custom.min.js"></script>

			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		</cfoutput>

		<!--- ESTILOS CSS --->
		<style>

		</style>

		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a a evaluar por la CEUPEID:
			function fListarAsuntos(vPagina)
			{
				// Icono de espera:
				document.getElementById('asuntos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('asuntos_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "asuntos_upeid.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vSsnId=";
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				//parametros = "vSsnId=" + encodeURIComponent(document.getElementById('vFt').value);
				/*parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);*/
				//parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				//
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);

				// Actualizar el cintillo:
//				document.getElementById('txtActa').innerHTML = 'ACTA ' + document.getElementById('vActa').value;
			}

			// Listar las informes anuales a evaluar por la CEUPEID:
			function fListarInformes(vPagina)
			{
				// Icono de espera:
				document.getElementById('informes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('informes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "asuntos_informes.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vSsnId=";
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				//parametros = "vSsnId=" + encodeURIComponent(document.getElementById('vFt').value);
				/*parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);*/
				//parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				//
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);

				// Actualizar el cintillo:
//				document.getElementById('txtActa').innerHTML = 'ACTA ' + document.getElementById('vActa').value;
			}
<!---
			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado()
			{
				window.open("../sistema_ctic/asuntos/reuniones/impresion/listado_caaa.cfm?vListado=CAAA&vTipo=OTRO&vActa=" + <cfoutput>#Session.sSesion#</cfoutput> + "&vSeccion =" + document.getElementById('vSeccion').value, "_blank" , "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}
--->			
		</script>
	</head>

	<body onLoad="<cfoutput>#vOnload#</cfoutput>">
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<cfoutput>
            <input type="hidden" value="0"  name="vPagina" id="vPagina">
		</cfoutput>
		<nav class="navbar navbar-default navbar-static-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
					</button>
					<!--- <a class="navbar-brand" href="#">SAMAA</a> --->
					<span class="navbar-brand  visible-lg" title="<cfoutput>#vTituloSistema#</cfoutput>"><strong>CEUPEID</strong></span>     
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav">
                        <li class="<cfif #vSeccion# EQ 1>active</cfif>" id="1"><a href="../app_upeid/?vSeccion=1">Académicos a evaluar</a></li>
					</ul>
					<ul class="nav navbar-nav">
                        <li class="<cfif #vSeccion# EQ 2>active</cfif>" id="2"><a href="../app_upeid/?vSeccion=2">Estímulos por asistencia</a></li>
					</ul>
					<ul class="nav navbar-nav">
                        <li class="<cfif #vSeccion# EQ 3>active</cfif>" id="3"><a href="../app_upeid/?vSeccion=3">Informes anuales</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<!--- INCLUDE ÚNICO PARA EL CIERRE DE SESIÓN --->
                        <cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">
					</ul>

				</div>
			</div>
		</nav>        
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
                    <div class="panel panel-default">
						<div class="panel-heading">
							<label>MENÚ</label>
						</div>
<!---
						<div class="panel-body">
							<label class="control-label text-left" for="lblEntidad">Entidad:</label>
							<select name="vDepId" id="vDepId" class="form-control" onChange="fListarSolicitudes(1);">
								<option value="">Todas</option>
								<cfoutput query="ctDependencia">
									<option value="#dep_clave#" <cfif isDefined("Session.ComisionUPEIDFiltro.vDepId") AND #dep_clave# EQ #Session.ComisionUPEIDFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
								</cfoutput>
							</select>
						</div>
--->											
						<cfif #vSeccion# NEQ 2>
                            <div class="panel-body">
                                <label class="control-label text-left" for="lblBuscar">Buscar por nombre:</label>
                                <input name="vAcadNom" id="vAcadNom" type="text" class="form-control" value="<cfoutput><cfif #vSeccion# EQ 1>#Session.ComisionUPEIDFiltro.vAcadNom#<cfelseif #vSeccion# EQ 3>#Session.ComisionUPEIDInfFiltro.vAcadNom#</cfif></cfoutput>" onKeyUp="<cfoutput>#vOnload#</cfoutput>">
                            </div>
                            <hr>
							<cfif #vSeccion# EQ 3>
								<div class="panel-body small">
									<cfoutput query="ctDependencia">
										<!--- Crea variable de archivo de solicitud --->
                                        <cfset vArchivoPdf = '#dep_clave#_#Session.sSesion#.pdf'>
										<cfset vArchivoInfOpinionCoordPdf = '#vCarpetaCEUPEID#/informes_anuales/#vArchivoPdf#'>
										<cfset vArchivoInfOpinionCoordPdfWeb = '#vWebCEUPEID#/informes_anuales/#vArchivoPdf#'>
										<cfif FileExists(#vArchivoInfOpinionCoordPdf#)>
											<a href="#vArchivoInfOpinionCoordPdfWeb#" target="winPdf">
												<div class="well well-sm">                                        
													Opiniones del Coord. #dep_siglas# <span class="fa fa-file-pdf-o" title="Abrir archivo"></span>
												</div>
											</a>
										</cfif>
									</cfoutput>
								</div>
                                <hr>
							</cfif>
                            <div class="panel-body text-left">
                                <p><span class="glyphicon glyphicon-pencil"></span> Escribir comentario<br></p>
                                <p><span class="glyphicon glyphicon-comment"></span> Hay comentarios</p>
                                <p><span class="glyphicon glyphicon-open-file"></span> Documentos disponibles (PDF)</p>
                            </div>
                            <hr>
                            <div class="panel-body text-left">
                                <!--- Selección de número de registros por página --->
                                <cfmodule template="#vCarpetaINCLUDE#/registros_pagina_bs.cfm" filtro="ComisionUPEIDFiltro" funcion="fListarAsuntos" ordenable="no">
                            </div>
                            <div class="panel-footer">
                                <!--- Contador de registros --->
                                <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
                                <input type="hidden" value="<cfoutput>#Session.ComisionUPEIDFiltro.vRPP#</cfoutput>"  name="vRPP" id="vRPP">
                            </div>
						</cfif>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<cfif #vSeccion# EQ 1>
                        <div id="asuntos_dynamic" class="table-responsive col-sm-12">
                            <!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                        </div>
					<cfelseif #vSeccion# EQ 2>
                        <div id="estimulos_dynamic" class="table-responsive col-sm-12">                    
							<cfinclude template="include_estimulos_asistencia.cfm">
						</div>                            
					<cfelseif #vSeccion# EQ 3>
<!---
						<div class="row content">
							<cfoutput query="ctDependencia">
								<!--- Crea variable de archivo de solicitud --->
								<cfset vArchivoPdf = '#dep_clave#_#Session.sSesion#.pdf'>
								<cfset vArchivoInfOpinionCoordPdf = '#vCarpetaCEUPEID#/informes_anuales/#vArchivoPdf#'>
								<cfset vArchivoInfOpinionCoordPdfWeb = '#vWebCEUPEID#/informes_anuales/#vArchivoPdf#'>
								<cfif FileExists(#vArchivoInfOpinionCoordPdf#)>
									<div class="well well-sm col-sm-3 text-center">
										<a href="#vArchivoInfOpinionCoordPdfWeb#" target="winPdf">
											Opiniones del Coordinador #dep_siglas# <span class="glyphicon glyphicon-open-file" title="Abrir archivo"></span>
										</a>
									</div>
									<div class="col-sm-1"></div>
								</cfif>
							</cfoutput>
						</div>
---->						
                        <div id="informes_dynamic" class="table-responsive col-sm-12">
                            <!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                        </div>
					</cfif>
				</div>
			</div>
		</div>
        <div id="divJQComentarios" title="PDF movimientos"><!-- DIV PARA DESPLEGAR COMENTARIO DEL ASUNTO SELECCIONADO--></div>
		<cfinclude template="../includes/include_pie_pagina.cfm">
	</body>
</html>