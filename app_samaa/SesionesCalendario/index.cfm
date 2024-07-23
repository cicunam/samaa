<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 16/05/2020 --->
<!--- MÓDULO DE CALENDARIO DE SESIONES Y ORDEN DEL DÍA --->

<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="8">
<cfparam name="vSubMenuActivo" default="1">
<cfparam name="vSsnId" default="0">

<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>
<cfset Session.sModulo = '#CGI.SCRIPT_NAME#'>

<cfquery name="tbCatalogoAnios" datasource="#vOrigenDatosSAMAA#">
    SELECT YEAR(ssn_fecha) as vAnios FROM sesiones
    GROUP BY YEAR(ssn_fecha)
    ORDER BY YEAR(ssn_fecha) DESC
</cfquery>

<cfif #vSubMenuActivo# EQ '1'>
	<cfset vOnLoad = 'onLoad="fListaCalendario();"'>
<cfelseif #vSubMenuActivo# EQ '2' AND #vSsnId# EQ 0>
	<cfset vOnLoad = 'onLoad="fListarOrdenDia(1);"'>
<cfelse>
	<cfset vOnLoad = ''>
</cfif>

<!DOCTYPE html>
<html lang="es">
	<head>
		<cfoutput>
			<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / SAMAA - #vTituloSistema#<cfelse>SAMAA - <cfoutput>#vTituloSistema#</cfoutput></cfif></title>
		</cfoutput>			
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
	<body <cfoutput>#vOnLoad#</cfoutput>>
		<!--- LLAMADO A ENCABEZADO DE LA PÁGINA --->
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">

		<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
		<cfinclude template="#vCarpetaCOMUN#/include_modulo_submenus.cfm">
			
		<!--- DIV QUE FUNCIONA COMO FRAME CENTRAL --->
		<cfif #vSubMenuActivo# EQ 1>
			<cfinclude template="calendario_sesiones_inicio.cfm">
        <cfelseif #vSubMenuActivo# EQ 2>
			<cfif #vSsnId# EQ 0>
				<cfinclude template="orden_dia_inicio.cfm">
			<cfelseif #vSsnId# GT 0>
				<cfinclude template="orden_dia/orden_dia.cfm">            
            </cfif>
       	</cfif>
		<cfinclude template="#vCarpetaRaizLogica#/includes/include_pie_pagina.cfm">
	</body>
</html>