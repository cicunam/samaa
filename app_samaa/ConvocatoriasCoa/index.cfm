<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 01/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 31/08/2022--->
<!--- PÁGINA DE INICIO PARA LA CONSULTA DE SOLICITUDES PARA SER CONSIDERADOS A COAs --->
<!--- CONVOCATORIAS COAs --->

<!--- Parámetros --->
<cfparam name="vMenuClave" default="12">
<cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# EQ 0)>
    <cfparam name="vAppConCoaMenu" default='1' type="string">    
<cfelse>    
    <cfparam name="vAppConCoaMenu" default='4' type="string">
</cfif>

<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<cfif NOT IsDefined('Session.ConCoaFiltroVig')>
    <cfscript>
        ConCoaFiltroVig = StructNew();            
        ConCoaFiltroVig.vDepClave = '';
        ConCoaFiltroVig.vNoPlaza = '';
        ConCoaFiltroVig.vSsnId = '';
        ConCoaFiltroVig.vNoGaceta = '';
        ConCoaFiltroVig.vPagina = '1';
        ConCoaFiltroVig.vRPP = '50';
    </cfscript>
    <cfset Session.ConCoaFiltroVig = '#ConCoaFiltroVig#'>
</cfif>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.ConCoaFiltro')>
    <!--- Crear un arreglo para guardar la información del filtro --->
    <cfscript>
        ConCoaFiltro = StructNew();
        ConCoaFiltro.vDepClave = '';
        ConCoaFiltro.vNoPlaza = '';
        ConCoaFiltro.vSsnId = '';
        ConCoaFiltro.vNoGaceta = '';
        ConCoaFiltro.vPagina = '1';
        ConCoaFiltro.vRPP = '25';
    </cfscript>
    <cfset Session.ConCoaFiltro = '#ConCoaFiltro#'>
</cfif>


<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">
<!DOCTYPE html>
<html lang="es">
	<head>
		<meta http-equiv="Content-Type" content="text/html;" charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">        
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Convocatorias COA</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<cfoutput>
			<link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
			<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
			<cfinclude template="#vCarpetaRaizLogica#/css/jquery_modal.cfm">

			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.css">
			<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>

            <script type="text/javascript" src="java_script/llamado_ajax.js"></script>
			<script type="text/javascript" src="java_script/filtros.js"></script>            

			<!--- LLAMADO A CÓDIGO DE JAVA SCRIPT COMÚN O GLOBAL --->        
            <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>
		</cfoutput>
	</head>
	<body onLoad="fListarRegistros(1);">
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<input type="hidden" value="0"  name="vPagina" id="vPagina">
		<div id="navMenus">
            <nav class="navbar navbar-default navbar-static">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
							<cfoutput query="tbSistemaSubMenu">
	                            <span class="icon-bar"></span>
							</cfoutput>                                
                            <span class="icon-bar"></span>
                        </button>
                        <span class="navbar-brand" title="Sistema para la Administración de Movimientos Académico-Administrativos">
							Concursos COA's 
							<cfoutput>
                                <input id="vAppConCoaMenu" name="vAppConCoaMenu" type="hidden" value="#vAppConCoaMenu#" maxlength="4">
                            </cfoutput>
						</span>
                    </div>
                    <div class="navbar-collapse collapse" id="myNavbar">
                        <ul class="nav navbar-nav">
							<cfoutput query="tbSistemaSubMenu">
            	                <li class="<cfif #submenu_control_id# EQ #vAppConCoaMenu# OR #tbSistemaSubMenu.Recordcount# EQ 1>active</cfif>" id="#submenu_control_id#"><a href="?vAppConCoaMenu=#submenu_control_id#">#submenu_nombre#</a></li><!---- onClick="fMenuRuta('#submenu_control_id#');" --->
							</cfoutput>
						</ul>
                        <ul class="nav navbar-nav navbar-right">
							<cfoutput>
								<li title="Regresar al menú principal"><a href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"><span class="glyphicon glyphicon-home" style="color:##0066CC;"></span> <strong style="color:##0066CC;">Men&uacute; principal</strong></a></li>
<!---
								<cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')>
								<cfelse>
									<!--- INCLUDE ÚNICO PARA EL CIERRE DE SESIÓN --->
									<cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">
									<!--- <li><a href="#vCarpetaRaizLogica#/valida/cierra.cfm"><span class="glyphicon glyphicon-off"></span> Cerrar sesión</a></li> --->
								</cfif>
--->								
							</cfoutput>
                        </ul>
                    </div>
                </div>
            </nav>
		</div>
		<div class="container-fluid text-center" style="min-height: 400px;">
			<div class="row content">
                <div class="col-sm-2 sidenav text-left visible-md visible-lg">
					<div class="panel panel-default">
                        <cfinclude template="include_menus.cfm">
					</div>
				</div>
				<div class="col-sm-10 text-left">
                    <cfinclude template="include_filtros.cfm">
					<div id="registros_dynamic" class="col-sm-12" >
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
					</div>
				</div>
			</div>
		</div>
		<style>
			/* Center the loader */
			#loader {
			  position: absolute;
			  left: 50%;
			  top: 50%;
			  z-index: 1;
			  width: 150px;
			  height: 150px;
			  margin: -75px 0 0 -75px;
			  border: 16px solid #f3f3f3;
			  border-radius: 50%;
			  border-top: 16px solid #3498db;
			  width: 120px;
			  height: 120px;
			  -webkit-animation: spin 2s linear infinite;
			  animation: spin 2s linear infinite;
			}
			
			@-webkit-keyframes spin {
			  0% { -webkit-transform: rotate(0deg); }
			  100% { -webkit-transform: rotate(360deg); }
			}
			
			@keyframes spin {
			  0% { transform: rotate(0deg); }
			  100% { transform: rotate(360deg); }
			}		        
        </style>
		<div id="loader" style="display:none;"></div>
		<cfinclude template="#vCarpetaINCLUDE#/include_pie_pagina.cfm">
	</body>
</html>