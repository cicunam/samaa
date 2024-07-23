<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 10/12/2020 --->
<!--- PÁGINA DE INICIO PARA LA CONSULTA DE ASUNTOS PARA LAS SESIONES DEL CTIC --->
<!--- CONSEJO TÉCNICO --->

<!--- Parámetros --->
<cfparam name="vAppPlenoMenu" default="Sesion">

<cfset vTituloSistema= UCASE('Consejo Técnico de la Investigación Científica')>

<cfset vRutaUrl = "#Application.vCarpetaRaiz#/archivos_ctic/archivos_pleno">
<cfset vCuentaSel  = 0>
<cfset vFecha = LSDATEFORMAT(now(),'dd/mm/yyyy')>

<cfif #vAppPlenoMenu# EQ 'CalSes'>
	<cfset vOnLoad = 'onLoad="fSesionFiltro();"'>
<cfelseif #vAppPlenoMenu# EQ 'Acuerdos'>
	<cfset vOnLoad = 'onLoad="fListaAcuerdos(1);"'>
	<!--- Crear un arreglo para guardar la información del filtro --->
	<cfif NOT IsDefined('Session.AcuerdosCticFiltro')>
		<!--- Crear un arreglo para guardar la información del filtro --->
		<cfscript>
			AcuerdosCticFiltro = StructNew();
			/* AcuerdosCticFiltro.vActa = ''; */
			/*AcuerdosCticFiltro.vDepId = '';*/
			AcuerdosCticFiltro.vAcadNom = '';
			AcuerdosCticFiltro.vPagina = '1';
			AcuerdosCticFiltro.vRPP = '25';
			AcuerdosCticFiltro.vMarcadas = ArrayNew(1);
		</cfscript>
		<cfset Session.AcuerdosCticFiltro = '#AcuerdosCticFiltro#'>
	</cfif>
<cfelse>
	<cfset vOnLoad = ''>
</cfif>

<!--- Obtener los submenús del sistema --->
<cfquery name="ctSubMenu" datasource="#vOrigenDatosSAMAA#">
	SELECT 
    submenu_nombre, submenu_control_id, submenu_clave, ruta_liga_cic AS ruta_liga
    FROM samaa_submenu AS T1
	WHERE T1.menu_clave = 6
    <cfif #Session.sLoginSistema# NEQ 'pleno'>
        AND T1.submenu_activo_cic = 1
    </cfif>
    ORDER BY T1.submenu_orden
</cfquery>
    
<!--- Obtener información del periodo de sesión ordinaria/extraordinaria --->
<cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
	SELECT TOP 1 *, CONVERT(date, ssn_fecha) AS vSsnFechaCorta 
	FROM sesiones 
	WHERE ssn_fecha >= '#vFecha#'
	AND (ssn_clave = 1 OR ssn_clave = 2)
	ORDER BY ssn_fecha, ssn_id DESC
</cfquery>

<cfquery name="tbOrdenDia" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones_orden 
	WHERE ssn_id = #tbSesion.ssn_id#
    AND punto_num < 30
	ORDER BY punto_num
</cfquery>

<cfif #tbSesion.ssn_clave# EQ 1>
    <cfset vTipoSesionCtic = 'Sesión ordinaria'>
<cfelseif #tbSesion.ssn_clave# EQ 2>
    <cfset vTipoSesionCtic = 'Sesión extraordinaria'>
</cfif>


<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - PLENO DEL CTIC <cfoutput>(#UCASE(vTipoSesionCtic)#)</cfoutput></title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

		<cfoutput>
			<link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
    		<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        
        <script>
            //alert('HOLA');    
            
            function fModalActivaVoto(vSolId)
            {
                // alert('HOLA'+ vSolId);
                $.ajax({
                    async: false,
                    url: "voto_asuntos/voto_SeleccionAsuntos_guarda.cfm",
                    type:'POST',
                    data: new FormData($('#frmAsuntoVoto_' + vSolId)[0]),
                    processData: false,
                    contentType: false,
                    success: function(data) {
                        if (data == '')
                            window.location.reload();
                        if (data != '')
                            alert('OCURRI&Oacute; UN ERROR AL ACTIVAR LA VOTACI&Oacute;' + data);
                        //fSesionLista();
                    },
                    error: function(data) {
                        alert('ERROR AL ACTIVAR LA VOTACIÓN');
                        //location.reload();
                    },
                });
            }

            function fModalVotar(vSolId)
            {
                //alert('HOLA'+ vSolId);
                $.ajax({
                    async: false,
                    url: "voto_asuntos/voto_AsuntosPleno_guarda.cfm",
                    type:'POST',
                    data: new FormData($('#frmAsuntoVoto_' + vSolId)[0]),
                    processData: false,
                    contentType: false,
                    success: function(data) {
                        if (data == '')
                            window.location.reload();
                        if (data != '')
                            alert('OCURRI&Oacute; UN ERROR AL VOTAR' + data);
                        //fSesionLista();
                    },
                    error: function(data) {
                        alert('OCURRIO UN ERROR AL GUARDAR SU VOTO');
                        //location.reload();
                    },
                });
            }
        </script>
	</head>

	<body <cfoutput>#vOnLoad#</cfoutput>>
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<input type="hidden" value="0"  name="vPagina" id="vPagina">        
		<div id="navMenus">
            <nav class="navbar navbar-default navbar-static">
                <div class="container-fluid">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
						<cfoutput>
							<div style="float:left;"><img src="#vCarpetaICONO#/sistemas/V2_logo_samaa.png" width="50px" title="SAMAA"></div>
    	                    <span class="navbar-brand" title="Sistema para la Administración de Movimientos Académico-Administrativos">PLENO CTIC / #tbSesion.ssn_id#</span>
						</cfoutput>                        
                    </div>
                    <div class="navbar-collapse collapse" id="myNavbar">
                        <ul class="nav navbar-nav">
                            <cfoutput query="ctSubMenu">
                                <li class="<cfif #vAppPlenoMenu# EQ #submenu_control_id#>active</cfif>" id="Sesion">
                                    <a href="#ruta_liga#">
                                        <cfif #submenu_clave# EQ 1>
                                            #Replace(submenu_nombre,'(TIPO_SESION)',vTipoSesionCtic)#
                                        <cfelse>
                                            #submenu_nombre#
                                        </cfif>
                                    </a>
                                </li>
                            </cfoutput>
<!---                            
                            <li class="<cfif #vAppPlenoMenu# EQ 'Sesion'>active</cfif>" id="Sesion"><a href="?vAppPlenoMenu=Sesion"><cfoutput>#vTipoSesionCtic#</cfoutput></a></li>
                            <cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# EQ 'pleno')>
                                <li class="<cfif #vAppPlenoMenu# EQ 'Miembros'>active</cfif>" id="Miembros"><a href="?vAppPlenoMenu=Miembros">Miembros del CTIC</a></li>
                                <li class="<cfif #vAppPlenoMenu# EQ 'CalSes'>active</cfif>" id="CalSes"><a href="?vAppPlenoMenu=CalSes">Calendario de sesiones</a></li>
                            </cfif>
							<li class="<cfif #vAppPlenoMenu# EQ 'Acuerdos'>active</cfif>" id="CalSes"><a href="?vAppPlenoMenu=Acuerdos">Acuerdos del CTIC</a></li>
--->
                        </ul>
                        <ul class="nav navbar-nav navbar-right">
							<cfoutput>
								<cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')>
                                    <li title="Regresar al menú principal"><a href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"><span class="glyphicon glyphicon-home" style="color:##0066CC;"></span> <strong style="color:##0066CC;">Menú principal</strong></a></li>
                                <cfelse>
									<!--- INCLUDE ÚNICO PARA EL CIERRE DE SESIÓN --->
                                    <cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">
									<!--- <li><a href="#vCarpetaRaizLogica#/valida/cierra.cfm"><span class="glyphicon glyphicon-off"></span> Cerrar sesión</a></li> --->
                                </cfif>
							</cfoutput>
                        </ul>
                    </div>
                </div>
            </nav>
		</div>
		<cfinclude template="#vCarpetaINCLUDE#/include_button_top.cfm">
        <cfif #vAppPlenoMenu# EQ 'Sesion'>
			<cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# EQ 'pleno')>        
                <div style="height:50px; position:absolute; top:4%; left:95%;">
                    <a href="#" onClick="window.location.reload();" class="btn btn-warning btn-lg"><span class="glyphicon glyphicon-refresh" title="Actualizar página"></span></a>
                </div>
			</cfif>
			<cfinclude template="sesion_inicio.cfm">
		<cfelseif #vAppPlenoMenu# EQ 'Miembros'>
			<cfinclude template="miembros_inicio.cfm">
		<cfelseif #vAppPlenoMenu# EQ 'CalSes'>
			<cfinclude template="calendario_inicio.cfm">
		<cfelseif #vAppPlenoMenu# EQ 'Acuerdos'>
			<cfinclude template="#vCarpetaINCLUDE#/acuerdos_ctic.cfm">
		</cfif>
		<cfinclude template="#vCarpetaINCLUDE#/include_pie_pagina.cfm">
	</body>
</html>        