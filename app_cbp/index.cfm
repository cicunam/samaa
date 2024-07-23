<!--- CREADO: ARAM PICHARDO DUR�N --->
<!--- EDITO: ARAM PICHARDO DUR�N --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA �LTIMA MOD.: 31/08/2017 --->
<!--- P�GINA DE INICIO PARA LA CONSULTA DE ASUNTOS DE BECARIOS POSDOCTORALES --->
<!--- COMISI�N DE BECAS POSDOCTORALES --->

<!--- Par�metros --->
<cfset vTituloSistema= UCASE('Comisi�n de Becas Posdoctorales')>

<cfparam name="vSeccion" default="3.1">
<cfparam name="vFt" default=38>

<cfset vFechaHoy=#LsDateFormat(Now(), "dd/mm/yyyy")#>

<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
<!--- Crear un arreglo para guardar la informaci�n del filtro --->
<cfif NOT IsDefined('Session.CBPFiltro')>
	<!--- Crear un arreglo para guardar la informaci�n del filtro --->
	<cfscript>
		CBPFiltro = StructNew();
		CBPFiltro.vDepId = '';
		CBPFiltro.vAcadNom = '';
		CBPFiltro.vPagina = '1';
		CBPFiltro.vRPP = '25';
		CBPFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.CBPFiltro = '#CBPFiltro#'>
</cfif>

<!--- Obtener la lista de dependencias del SIC --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia 
    WHERE dep_clave LIKE '03%' 
    AND dep_status = 1 
    ORDER BY dep_siglas
</cfquery>
    
<!--- Obtener el n�mero de sesi�n que se ver� en la CAAA --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_clave = 7
    AND ssn_fecha >= GETDATE()
</cfquery>

<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / SAMAA - CBP<cfelse>SAMAA - <cfoutput>#vTituloSistema#</cfoutput></cfif></title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

		<cfoutput>
			<link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
    		<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>

		<style>
		</style>

		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>


		<script language="JavaScript" type="text/JavaScript">
			// Listar las asuntos que pasan a la CAAA:
			function fListarSolicitudes(vPagina)
			{
				//alert(vPagina)
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Funci�n de atenci�n a las petici�n HTTP:
				xmlHttp.onreadystatechange = function() {
					//alert(xmlHttp.readyState);
					if (xmlHttp.readyState == 4) {
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petici�n HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				xmlHttp.open("POST", "asuntos_cbp.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de par�metros:
				parametros = "vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petici�n HTTP:
				xmlHttp.send(parametros);
			}
		</script>
	</head>

	<body onLoad="fListarSolicitudes(1);">
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<nav class="navbar navbar-default navbar-static-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
					</button>
					<!--- <a class="navbar-brand" href="#">SAMAA</a> --->
					<cfoutput>
						<div style="float:left;"><img src="#vCarpetaICONO#/sistemas/V2_logo_samaa.png" width="50px" title="SAMAA"></div>
						<span class="navbar-brand" title="Sistema para la Administraci�n de Movimientos Acad�mico-Administrativos">SAMAA</span>
					</cfoutput>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav">
                        <!--- <li class="active"><a href="#">Home</a></li> --->
                        <li class="active"><a href="#">Asuntos de becarios posdoctorales</a></li>
					</ul>
					<ul class="nav navbar-nav navbar-right">
                        <!--- LIGA PARA ACCEDER V�A ZOOM A LA REUNI�N EN CASO DE QUE SE ENCUENTRE REGISTRADA EN LA BASE DE DATOS 23/03/2022 --->
                        <cfif #find("zoom.us",tbSesion.videoconferencia_zoom)# GT 0>
                            <cfoutput>
						        <li><a href="#tbSesion.videoconferencia_zoom#" target="WinZoom" class="text-primary" title="Ingresar a la reuni�n"><span class="glyphicon glyphicon-facetime-video text-primary"></span> <span class="text-primary"> <strong>Reuni�n ZOOM</strong></span></a></li>
                            </cfoutput>
                        </cfif>                        
						<!--- INCLUDE �NICO PARA EL CIERRE DE SESI�N --->
                        <cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">                        
						<!--- <li><a href="#"><span class="glyphicon glyphicon-print"></span> Imprimir</a></li> --->
						<!--- <li><a href="#" onClick="window.close();"><span class="glyphicon glyphicon-off"></span> Cerrar sistema</a></li> --->
					</ul>

				</div>
			</div>
		</nav>
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
                    <div class="panel panel-default">
						<div class="panel-heading">
							<label>MEN�</label>
						</div>
						<div class="panel-body">
                            <label class="control-label text-left" for="lblEntidad">Entidad:</label>
                            <select name="vDepId" id="vDepId" class="form-control" onChange="fListarSolicitudes(1);">
                                <option value="">Todas</option>
                                <cfoutput query="ctDependencia">
                                    <option value="#dep_clave#" <cfif isDefined("Session.CBPFiltro.vDepId") AND #dep_clave# EQ #Session.CBPFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
                                </cfoutput>
                            </select>
						</div>
						<div class="panel-body">
							<label class="control-label text-left" for="lblBuscar">Buscar becario:</label>
							<input name="vAcadNom" id="vAcadNom" type="text" class="form-control" value="<cfoutput>#Session.CBPFiltro.vAcadNom#</cfoutput>" onKeyUp="fListarSolicitudes(1)">
						</div>
						<hr>
						<div class="panel-body text-center">
                            <p style="background-color:#D4EFF4;"><strong>�rea F�sico-Matem�ticas</strong></p>
                            <p style="background-color:#DCFFB9;"><strong>�rea Qu�mico-Biol�gica</strong></p>
                            <p style="background-color:#FFE888;"><strong>�rea Tierra e Ingenier�as</strong></p>
                            <p style="background-color:#FFCEFF;"><strong>Otras �reas</strong></p>
						</div>
						<hr>
						<div class="panel-body">
							<!--- Selecci�n de n�mero de registros por p�gina --->
                            <cfmodule template="#vCarpetaINCLUDE#/registros_pagina_bs.cfm" filtro="CBPFiltro" funcion="fListarSolicitudes" ordenable="no">
						</div>
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
                            <input type="hidden" value="<cfoutput>#Session.CBPFiltro.vRPP#</cfoutput>"  name="vRPP" id="vRPP">
						</div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="solicitudes_dynamic" class="col-sm-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACI�N -->						
                    </div>
				</div>
			</div>
		</div>
		<cfinclude template="../includes/include_pie_pagina.cfm">
	</body>
</html>  