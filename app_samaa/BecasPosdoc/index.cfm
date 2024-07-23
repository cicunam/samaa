<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 04/06/2019 --->
<!--- MÓDULO DE ESTÍMULOS DGAPA --->

<!--- Parámetros --->
<cfparam name="vMenuClave" default="5">
<cfparam name="vSubMenuActivo" default="1">	

<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<!--- Obtener información del periodo de sesión ordinaria/extraordinaria --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 * FROM sesiones 
	WHERE ssn_fecha >= '#vFechaHoy#'
	AND ssn_clave = 1
	ORDER BY ssn_fecha
</cfquery>

<cfset vSesionVigEst = #tbSesion.ssn_id#>

<cfif #vSubMenuActivo# EQ '1'>
    <cfif NOT IsDefined('Session.EstimulosDgapaFiltroVig')>
        <cfscript>
            EstimulosDgapaFiltroVig = StructNew();
            EstimulosDgapaFiltroVig.vSsnId = #vSesionVigEst#;
            EstimulosDgapaFiltroVig.vPagina = '1';
            EstimulosDgapaFiltroVig.vRPP = '100';
        </cfscript>
        <cfset Session.EstimulosDgapaFiltroVig = '#EstimulosDgapaFiltroVig#'>
	</cfif>
<cfelse>
	<!--- Crear un arreglo para guardar la información del filtro --->
    <cfif NOT IsDefined('Session.EstimulosDgapaFiltro')>
        <!--- Crear un arreglo para guardar la información del filtro --->
        <cfscript>
            EstimulosDgapaFiltro = StructNew();
            EstimulosDgapaFiltro.vDepClave = '';
            EstimulosDgapaFiltro.vBuscaAcademico = '';
            EstimulosDgapaFiltro.vSsnId = #vSesionVigEst# - 1;
            EstimulosDgapaFiltro.vCcnClave = '';
            EstimulosDgapaFiltro.vPrideClave = '';
            EstimulosDgapaFiltro.vBuscaOficio = '';
            EstimulosDgapaFiltro.vPagina = '1';
            EstimulosDgapaFiltro.vRPP = '25';
        </cfscript>
        <cfset Session.EstimulosDgapaFiltro = '#EstimulosDgapaFiltro#'>
    </cfif>
</cfif>

<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - ESTÍMULOS DGAPA</title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
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
		<!--- LLAMADO A ENCABEZADO DE LA PÁGINA --->		
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
		<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">
		<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
		<cfinclude template="#vCarpetaCOMUN#/include_modulo_submenus.cfm">			
		<!--- DIV QUE FUNCIONA COMO FRAME CENTRAL --->
		<div class="container-fluid text-center">
<!---            
			<div class="row content">
                <div class="col-sm-2 sidenav text-left visible-md visible-lg">
					<div class="panel panel-default">
                        <cfinclude template="include_menus.cfm"> 
					</div>
				</div>
				<div class="col-sm-10 text-left">
					<cfif #vSubMenuActivo# EQ '1'>
						<cfinclude template="agregar_academico.cfm">
					<cfelse>
						<cfinclude template="include_filtros.cfm">
					</cfif>
					<div id="registros_dynamic" class="col-sm-12" >
						<!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
					</div>
--->            
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