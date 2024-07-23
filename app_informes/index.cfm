<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 07/12/2020 --->
<!--- PÁGINA DE INICIO PARA LA CONSULTA DE ASUNTOS PARA CONSULTA DE LA CAAA --->
<!--- COMISIÓN DE DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS --->

<!--- Parámetros --->
<cfset vTituloSistema= UCASE('Comisión de Asuntos Académico-Administrativos')>

<cfparam name="vSeccion" default="33">

<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.ReunionCAAAFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		ReunionCAAAFiltro = StructNew();
		ReunionCAAAFiltro.vFt = 0;
		/* ReunionCAAAFiltro.vActa = ''; */
		ReunionCAAAFiltro.vSeccion = '1';
		ReunionCAAAFiltro.vDepId = '';
		ReunionCAAAFiltro.vAcadNom = '';
		ReunionCAAAFiltro.vPagina = '1';
		ReunionCAAAFiltro.vRPP = '25';
		ReunionCAAAFiltro.vMarcadas = ArrayNew(1);
	</cfscript>
	<cfset Session.ReunionCAAAFiltro = '#ReunionCAAAFiltro#'>
</cfif>

<!--- Obtener la lista de movimientos disponibles
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
	WHERE mov_status = 1
    ORDER BY mov_orden
</cfquery>
 --->
<!--- Obtener los submenús del sistema --->

<cfquery name="ctSubMenu" datasource="#vOrigenDatosSAMAA#">
	SELECT 
    T1.*
    FROM samaa_submenu AS T1
	WHERE T1.menu_clave = 50
    AND submenu_clave = 33
    AND T1.submenu_activo_cic = 1
    ORDER BY T1.submenu_orden
</cfquery>

<!--- Obtener la lista de dependencias del SIC --->
<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia 
	WHERE dep_clave LIKE '03%' 
    AND dep_status = 1 ORDER BY dep_siglas
</cfquery>

<!--- Obtener el número de sesión que se verá en la CAAA --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_clave = 4
    AND ssn_id = #Session.sSesion#
</cfquery>

<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / SAMAA - CAAA<cfelse>SAMAA - <cfoutput>#vTituloSistema#</cfoutput></cfif></title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

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
			// Listar las asuntos que pasan a la CAAA:
			function fListarSolicitudes(vPagina)
			{
				// Icono de espera:
				document.getElementById('solicitudes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\" style=\"display:block; margin:auto;\">";
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState == 4) {
						document.getElementById('solicitudes_dynamic').innerHTML = xmlHttp.responseText;
						document.getElementById('vRegRan_dynamic').innerHTML = document.getElementById('vRegRan').value;
						document.getElementById('vRegTot_dynamic').innerHTML = document.getElementById('vRegTot').value;
					}
				}
				// Generar una petición HTTP: se especifica si son sincronicas(false) o asincronicas(true) las peticiones 
				if (document.getElementById('vSeccion').value == 33) xmlHttp.open("POST", "asuntos_informes.cfm", true);
				if (document.getElementById('vSeccion').value != 33) xmlHttp.open("POST", "asuntos_caaa.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:
				parametros = "vFt=" + encodeURIComponent(document.getElementById('vFt').value);
				/*parametros += "&vActa=" + encodeURIComponent(document.getElementById('vActa').value);*/
				parametros += "&vSeccion=" + encodeURIComponent(document.getElementById('vSeccion').value);
				parametros += "&vDepId=" + encodeURIComponent(document.getElementById('vDepId').value);
				parametros += "&vAcadNom=" + encodeURIComponent(document.getElementById('vAcadNom').value);
				parametros += "&vPagina=" + encodeURIComponent(vPagina);
				parametros += "&vRPP=" + encodeURIComponent(document.getElementById('vRPP').value);
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);

				// Actualizar el cintillo:
//				document.getElementById('txtActa').innerHTML = 'ACTA ' + document.getElementById('vActa').value;
			}

			// Mostrar la lista de asuntos en formato PDF:
			function fImprimirListado()
			{
				window.open("../sistema_ctic/asuntos/reuniones/impresion/listado_caaa.cfm?vListado=CAAA&vTipo=OTRO&vActa=" + <cfoutput>#Session.sSesion#</cfoutput> + "&vSeccion =" + document.getElementById('vSeccion').value, "_blank" , "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
			}			
		</script>
	</head>

	<body onLoad="fListarSolicitudes(1);">
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<cfoutput>
            <input type="hidden" value="#vSeccion#"  name="vSeccion" id="vSeccion">
            <input type="hidden" value="0"  name="vFt" id="vFt">
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
					<cfoutput>
						<div style="float:left;"><img src="#vCarpetaICONO#/sistemas/V2_logo_samaa.png" width="50px" title="SAMAA"></div>
						<span class="navbar-brand  visible-lg" title="Sistema para la Administración de Movimientos Académico-Administrativos"><strong>CAAA / #Session.sSesion#</strong></span>
					</cfoutput>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav">
						<cfoutput query="ctSubMenu">
							<!--- LISTA EL MENÚ SUPERIOR E IDENTIFICA SI HAY ASUNTOS A REVISAR POR LA CAAA, EN CASO DE NO REGISTROS NO MUESTRA EL MENÚ CORRESPONDIENTE (17/01/2019)  --->
							<cfquery name="tbCountReg" datasource="#vOrigenDatosSAMAA#">
								SELECT COUNT(*) AS vCuenta
								<cfif #submenu_clave# NEQ 33 AND #submenu_clave# NEQ 331>
									FROM movimientos_solicitud AS T1
									LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
									WHERE T1.sol_status = 2
									AND T2.asu_reunion = 'CAAA'
								<cfelseif #submenu_clave# EQ 331>
									FROM movimientos_solicitud AS T1
									LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
									WHERE T1.sol_status = 2
									AND T2.asu_reunion = 'CAAA'                                    
								<cfelse>
									FROM movimientos_informes_anuales AS T1
									LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id
									WHERE T1.informe_status = 2
									AND T2.informe_reunion = 'CAAA'                                    
								</cfif>
								AND T2.ssn_id = #Session.sSesion#
								AND #submenu_descrip_cic#
							</cfquery>

							<cfif #tbCountReg.vCuenta# GT 0>
								<li class="<cfif #vSeccion# EQ #submenu_clave#>active</cfif>" id="1"><a href="?vSeccion=#submenu_clave#">#submenu_nombre# <span class="badge" title="Número de asuntos">#tbCountReg.vCuenta#</span></a></li>
							</cfif>                            
						</cfoutput>
					</ul>
					<ul class="nav navbar-nav navbar-right">
                        <!--- LIGA PARA ACCEDER VÍA ZOOM A LA REUNIÓN EN CASO DE QUE SE ENCUENTRE REGISTRADA EN LA BASE DE DATOS 23/03/2022 --->
                        <cfif #find("zoom.us",tbSesion.videoconferencia_zoom)# GT 0>
                            <cfoutput>
						        <li><a href="#tbSesion.videoconferencia_zoom#" target="WinZoom" class="text-primary"><span class="glyphicon glyphicon-facetime-video text-primary"></span> <span class="text-primary"> <strong>Reunión ZOOM</strong></span></a></li>
                            </cfoutput>
                        </cfif>
						<!--- INCLUDE ÚNICO PARA EL CIERRE DE SESIÓN --->
                        <cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">
						<!--- <li><a href="#" onClick="fImprimirListado();"><span class="glyphicon glyphicon-print"></span> Imprimir</a></li> --->
						<!--- <li><a href="#" onClick="window.close();"><span class="glyphicon glyphicon-off"></span> Cerrar sistema</a></li> --->
					</ul>

				</div>
			</div>
		</nav>        
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-xs-0 col-sm-0 col-md-2 col-lg-2 sidenav text-left visible-md visible-lg">
                    <div class="panel panel-default">
						<div class="panel-heading">
							<label>MENÚ</label>
						</div>
						<div class="panel-body">
                            <label class="control-label text-left" for="lblEntidad">Entidad:</label>
                            <select name="vDepId" id="vDepId" class="form-control" onChange="fListarSolicitudes(1);">
                                <option value="">Todas</option>
                                <cfoutput query="ctDependencia">
                                    <option value="#dep_clave#" <cfif isDefined("Session.ReunionCAAAFiltro.vDepId") AND #dep_clave# EQ #Session.ReunionCAAAFiltro.vDepId#>selected</cfif>>#dep_siglas#</option>
                                </cfoutput>
                            </select>
						</div>
						<div class="panel-body">
							<label class="control-label text-left" for="lblBuscar">Buscar por nombre:</label>
							<input name="vAcadNom" id="vAcadNom" type="text" class="form-control" value="<cfoutput>#Session.ReunionCAAAFiltro.vAcadNom#</cfoutput>" onKeyUp="fListarSolicitudes(1)">
						</div>
						<cfif #vSeccion# EQ 1 OR #vSeccion# EQ 3>
							<hr>
							<div class="panel-body text-left">
								<p><span class="glyphicon glyphicon-pencil"></span> Escribir comentario<br></p>
								<p><span class="glyphicon glyphicon-comment"></span> Hay comentarios</p>
								<p><span class="glyphicon glyphicon-open-file"></span> Documentos disponibles (PDF)</p>
							</div>
						</cfif>
						<hr>
						<div class="panel-body text-left">
							<!--- Selección de número de registros por página --->
                            <cfmodule template="#vCarpetaINCLUDE#/registros_pagina_bs.cfm" filtro="ReunionCAAAFiltro" funcion="fListarSolicitudes" ordenable="no">
						</div>
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
                            <input type="hidden" value="<cfoutput>#Session.ReunionCAAAFiltro.vRPP#</cfoutput>"  name="vRPP" id="vRPP">
						</div>
                    </div>
				</div>
				<div class="col-xs-12 col-sm-12 col-md-10 col-lg-10 text-left">
					<div id="solicitudes_dynamic" class="col-xs-12 col-sm-12 col-md-12 col-lg-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                    </div>
				</div>
			</div>
		</div>
        <div id="divJQComentarios" title="PDF movimientos"><!-- DIV PARA DESPLEGAR COMENTARIO DEL ASUNTO SELECCIONADO--></div>
		<cfinclude template="../includes/include_pie_pagina.cfm">
	</body>
</html>