
<cfparam name="vMenuActivo" default="1">
<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfset vMenuClave = 7>
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

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
	</head>
	<body>

		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">

		<cfoutput>
            <input type="hidden" value="#vMenuActivo#"  name="#vMenuActivo#" id="#vMenuActivo#">
            <input type="hidden" value="0"  name="vPagina" id="vPagina">            
		</cfoutput>
		<nav class="navbar navbar-default navbar-static-top" style="margin-bottom:20px;">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
					</button>
					<span class="navbar-brand  visible-lg" title="Consejeros / Comisiones del CTIC"><strong>Cons/Com</strong></a></span>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav">
						<cfoutput query="tbSistemaSubMenu">
	                        <li class="<cfif #submenu_control_id# EQ #vMenuActivo#>active</cfif>" id="1"><a href="?vMenuActivo=#submenu_control_id#">#submenu_nombre#</a></li>
						</cfoutput>
					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li><a href="#">Sesión vigente: <strong><cfoutput>#Session.sSesion#</cfoutput></strong></a></li>
						<li title="Regresar al menú principal"><a href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"><span class="glyphicon glyphicon-home" style="color:#0066CC;"></span> <strong style="color:#0066CC;">Menú principal</strong></a></li>
					</ul>
				</div>
			</div>
		</nav>
		<div class="container-fluid text-center" style="margin:5px;">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
					<div class="panel-group">
                        <div class="panel panel-primary">
                            <div class="panel-heading">
                                <label>MEN&Uacute;</label>
                            </div>
                            <div class="panel-body">
                            </div>
                            <div class="panel-body">
                            </div>
                        </div>
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <label>FILTROS</label>
                            </div>
                            <div class="panel-body">
                            </div>
                            <div class="panel-body">
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<div id="calendario_dynamic" class="col-sm-12">
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                    </div>
				</div>
			</div>
		</div>        
		<cfinclude template="#vCarpetaRaizLogica#/includes/include_pie_pagina.cfm">
	</body>
</html>        