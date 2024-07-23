<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/02/2022 --->
<!--- FECHA ÚLTIMA MOD.: 18/02/2022 --->
<!--- MÓDULO DE INFORMES ANUALES --->

<!--- Parámetros --->
<cfparam name="vMenuClave" default="1">
<cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 3>
    <cfparam name="vSubMenuActivo" default="2">	
<cfelseif #Session.sTipoSistema# EQ 'sic' OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GTE 3)>
    <cfparam name="vSubMenuActivo" default="1">	
</cfif>

<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>
    
<cfif NOT IsDefined('Session.InformesFiltro')>
    <cfset Session.vInformeAnio = #vAnioActual# - 1>
</cfif>    
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.InformesFiltro')>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfscript>
		InformesFiltro = StructNew();
		InformesFiltro.vInformeStatus = 0; // #vInformeStatus#
		InformesFiltro.vActa = #Session.sSesion# - 1;
		InformesFiltro.vAcadNom = '';
		InformesFiltro.vDep = '';
		InformesFiltro.vDecClave = 0;		
		InformesFiltro.vPagina = '1';
		InformesFiltro.vRPP = '25';
		InformesFiltro.vOrden = 'nombre'; // 'asu_parte ASC, asu_numero'
		InformesFiltro.vOrdenDir = 'ASC';  //'ASC'
	</cfscript>
	<cfset Session.InformesFiltro = '#InformesFiltro#'>
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
		<cfinclude template="#vCarpetaCOMUN#/include_modulo_submenus.cfm">
		<!--- DIV QUE FUNCIONA COMO FRAME CENTRAL --->
		<div class="container-fluid text-center">
			<div class="row content">
<!---                
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
				</div>
--->            
			</div>
		</div>
		<!--- LLAMADO A LA INCLUDE DE LOADER --->
		<cfinclude template="#vCarpetaCOMUN#/include_loader.cfm">
		<!--- LLAMADO A LA INCLUDE DE PIE DE PAGINA --->
		<cfinclude template="#vCarpetaINCLUDE#/include_pie_pagina.cfm">
	</body>
</html>