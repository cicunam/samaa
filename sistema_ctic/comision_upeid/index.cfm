<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/08/2019 --->
<!--- PÁGINA DE INICIO PARA LA CONSULTA DE ASUNTOS, SESIONES Y MIEMBROS DE LA COMISIÓN ESPECIAL DE LA UPEID --->
<!--- CONSEJO TÉCNICO --->


<!--- Parámetros --->
<cfparam name="vAppCeUpeidMenu" default="Sesiones">
<cfset vTituloSistema= UCASE('Consejo Técnico de la Investigación Científica')>
<cfset vFecha = LSDATEFORMAT(now(),'dd/mm/yyyy')>

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfset vMenuClave = 10>
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

<cfif #Session.sTipoSistema# EQ 'stctic'>
	<cfif #vAppCeUpeidMenu# EQ 'Sesiones'>
        <cfset vOnLoad = 'fSesionLista();'>
        <cfset vDivDynamic = 'sesiones_dynamic'>
    <cfelseif #vAppCeUpeidMenu# EQ 'Miembros'>
        <cfset vOnLoad = 'fMiembrosLista()'>
        <cfset vDivDynamic = 'miembros_dynamic'>
    <cfelseif #vAppCeUpeidMenu# EQ 'Asuntos'>
        <cfset vOnLoad = 'fAsuntosLista()'>
        <cfset vDivDynamic = 'asuntos_dynamic'>
    <cfelse>
        <cfset vOnLoad = ''>
    </cfif>
<cfelse>
	<cfset vOnLoad = 'fAsuntosLista()'>
    <cfset vDivDynamic = 'asuntos_dynamic'>
</cfif>
<!--- Crear un arreglo para guardar la información del filtro --->
<cfif NOT IsDefined('Session.CeUpeidFiltro')>

	<cfif #Session.sTipoSistema# EQ 'stctic'>
        <cfquery name="tbSesionesCeUpeidActual" datasource="#vOrigenDatosSAMAA#">
            SELECT TOP 1 * FROM sesiones 
            WHERE ssn_clave = 20
            AND ssn_fecha >= #vFechaHoy#
            ORDER BY ssn_fecha DESC
        </cfquery>
		<cfset vSesionActualCEUPEID = #tbSesionesCeUpeidActual.ssn_id#>
    <cfelse>
		<cfset vSesionActualCEUPEID = 0>
    </cfif>
	    
	<!--- Crear un arreglo para guardar la información del filtro --->
    <cfscript>
		CeUpeidFiltro = StructNew();
		CeUpeidFiltro.MenuUpeid = '#vAppCeUpeidMenu#';
		CeUpeidFiltro.SsnIdCeUpeid = #vSesionActualCEUPEID#;
		CeUpeidFiltro.vPagina = '1';
		CeUpeidFiltro.vRPP = '25';		
    </cfscript>
    <cfset Session.CeUpeidFiltro = '#CeUpeidFiltro#'>
<cfelse>
	<cfset Session.CeUpeidFiltro.MenuUpeid = '#vAppCeUpeidMenu#'>
</cfif>
    
<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Comisión Especial Evaluadora de la UPEID</title>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
		<cfinclude template="#vCarpetaRaizLogica#/css/jquery_modal.cfm">
<!---
		<cfif #CGI.SERVER_PORT# IS '31221'>
			<style>
                .modal-header-primary {
                    color:#fff;
                    padding:9px 15px;
                    border-bottom:1px solid #eee;
                    background-color: #d9232f;
                    -webkit-border-top-left-radius: 5px;
                    -webkit-border-top-right-radius: 5px;
                    -moz-border-radius-topleft: 5px;
                    -moz-border-radius-topright: 5px;
                     border-top-left-radius: 5px;
                     border-top-right-radius: 5px;
                }	
            </style>
        <cfelse>
			<style>
                .modal-header-primary {
                    color:#fff;
                    padding:9px 15px;
                    border-bottom:1px solid #eee;
					background-color: #507aaa;
                    -webkit-border-top-left-radius: 5px;
                    -webkit-border-top-right-radius: 5px;
                    -moz-border-radius-topleft: 5px;
                    -moz-border-radius-topright: 5px;
                     border-top-left-radius: 5px;
                     border-top-right-radius: 5px;
                }	
            </style>        
		</cfif>
--->		
		<cfoutput>
			<link href="#vCarpetaCSS#/jquery/tablas_datos.css" rel="stylesheet" type="text/css">
    		<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
			<script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/mascara_entrada.js"></script>
		</cfoutput>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			function fSesionLista()
			{
				//alert('SESIONES');
				$.ajax({
					async: false,
					method: "POST",
					data: {vpAnio:$('#SsnAnio').val()},
					url: "sesiones_lista.cfm",
					success: function(data) {
						$("#sesiones_dynamic").html(data);
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DESPELGAR LA INFORMACIÓN');
						//location.reload();
					}
				});
			}
			function fMiembrosLista()
			{
				//alert('MIEMBROS');
				$.ajax({
					async: false,
					method: "POST",
					data: {vSsnId:$('#SsnId').val()},
					url: "miembros_lista.cfm",
					success: function(data) {
						$("#miembros_dynamic").html(data);
						if ($('#SsnId').val() == <cfoutput>#Session.CeUpeidFiltro.SsnIdCeUpeid#</cfoutput>)
						{ 
							if($('#vCuentaReg').val() > 0)
							{
								$('#divEmail').show();
							}
							else
							{
								$('#divEmail').hide();
							}
						}
						else
						{
							$('#divEmail').hide();
						}
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DESPELGAR LA INFORMACIÓN');
						//location.reload();
					}
				});
			}
			function fAsuntosLista()
			{
				// alert('ASUNTOS');
				$.ajax({
					async: false,
					method: "POST",
					data: {vSsnId:$('#SsnId').val()},
					url: "asuntos_lista.cfm",
					success: function(data) {
						$("#asuntos_dynamic").html(data);
						//fListarInformes();
						//alert(data);
					},
					error: function(data) {
						alert('ERROR AL DESPELGAR LA INFORMACIÓN');
						//location.reload();
					}
				});
			}
		</script>
        
	</head>

	<body onLoad="<cfoutput>#vOnLoad#</cfoutput>;">
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
                        <span class="navbar-brand" title="Comisión Especial Evaluadora de la UPEID">CEUPEID</span>
                    </div>
                    <div class="navbar-collapse collapse" id="myNavbar">
                        <ul class="nav navbar-nav">
							<cfoutput query="tbSistemaSubMenu">            
								<li class="<cfif #vAppCeUpeidMenu# EQ #submenu_control_id#>active</cfif>" id="Sesiones"><a href="?vAppCeUpeidMenu=#submenu_control_id#">#submenu_nombre#</a></li>
                            </cfoutput>
<!---
                            <cfif #Session.sTipoSistema# EQ 'stctic'>
                                <li class="<cfif #vAppCeUpeidMenu# EQ 'Sesiones'>active</cfif>" id="Sesiones"><a href="?vAppCeUpeidMenu=Sesiones">Sesiones</a></li>
                                <li class="<cfif #vAppCeUpeidMenu# EQ 'Miembros'>active</cfif>" id="Miembros"><a href="?vAppCeUpeidMenu=Miembros">Miembros</a></li>
                            </cfif>
							<li class="<cfif #vAppCeUpeidMenu# EQ 'Asuntos'>active</cfif>" id="Asuntos"><a href="?vAppCeUpeidMenu=Asuntos">Asuntos</a></li>
--->							
                        </ul>
						<ul class="nav navbar-nav navbar-right">
							<cfoutput>
								<li title="Regresar al menú principal"><a href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"><span class="glyphicon glyphicon-home" style="color:##0066CC;"></span> <strong style="color:##0066CC;">Men&uacute; principal</strong></a></li>
							</cfoutput>
                        </ul>
                    </div>
                </div>
            </nav>
		</div>
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-sm-2 sidenav text-left visible-md visible-lg">
                    <div class="panel panel-default">
						<div class="panel-heading">
							<label>MENÚ</label>
						</div>
						<cfif #vAppCeUpeidMenu# EQ 'Sesiones'>
                            <cfquery name="ctSsnAnios" datasource="#vOrigenDatosSAMAA#">
                                SELECT YEAR(ssn_fecha) AS anios
                                FROM sesiones 
                                WHERE ssn_clave = 20
								GROUP BY YEAR(ssn_fecha)
                                ORDER BY YEAR(ssn_fecha) DESC
                            </cfquery>
                            <div class="panel-body">
                                <label class="control-label text-left" for="lblAnioSsn">Sesión:</label>
                                <select name="SsnAnio" id="SsnAnio" class="form-control" onChange="fSesionLista();">
                                    <option value="0">Todas</option>
                                    <cfoutput query="ctSsnAnios">
                                        <option value="#anios#" <cfif isDefined("Session.ReunionCAAAFiltro.vDepId") AND #dep_clave# EQ #Session.ReunionCAAAFiltro.vDepId#>selected</cfif>>#anios#</option>
                                    </cfoutput>
                                </select>                        
                            </div>
						</cfif>
						<cfif #Session.sTipoSistema# EQ 'stctic'>
							<cfif #vAppCeUpeidMenu# EQ 'Miembros' OR #vAppCeUpeidMenu# EQ 'Asuntos'>
                                <cfquery name="ctSsn" datasource="#vOrigenDatosSAMAA#">
                                    SELECT ssn_fecha, ssn_id
                                    FROM sesiones 
                                    WHERE ssn_clave = 20
                                    ORDER BY ssn_fecha DESC
                                </cfquery>
                                <div class="panel-body">
                                    <label class="control-label text-left" for="lblSsnId">Fecha de sesión:</label>
                                    <select name="SsnId" id="SsnId" class="form-control" onChange="<cfoutput>#vOnLoad#</cfoutput>">
                                        <cfif #vAppCeUpeidMenu# EQ 'Asuntos'>
                                            <option value="0">No asignados a sesión</option>
                                        </cfif>
                                        <cfoutput query="ctSsn">
                                            <option value="#ssn_id#" <cfif #ssn_id# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid#>selected</cfif>>#LsDateFormat(ssn_fecha,'dd/mm/yyyy')#</option>
                                        </cfoutput>
                                    </select>                        
                                </div>
								<cfif #vAppCeUpeidMenu# EQ 'Miembros'>
									<script language="JavaScript" type="text/JavaScript">
                                        function fEnviaCorreo()
                                        {
                                            //alert('SESIONES');
                                            $.ajax({
                                                async: false,
                                                method: "POST",
                                                data: {vpSesionIdCeUpeid:$('#SsnId').val()},
                                                url: "miembros_envia_correo.cfm",
                                                success: function(data) {
                                                    $("#envia_correo_dynamic").html(data);
                                                   // alert(data);
													$('#cmdEnviaCorreo').addClass('disabled');													
                                                },
                                                error: function(data) {
                                                    alert('ERROR AL ENVIAR EL CORREO');
                                                    //location.reload();
                                                }
                                            });
                                        }
									</script>
                                    <div id="divEmail" class="panel-body">
                                        <label class="control-label text-left" for="lblSsnId">Enviar correo electrónico con la liga para el acceso a los asuntos:</label>
                                        <button id="cmdEnviaCorreo" type="button" class="btn btn-primary" style="font-size:18px" onClick="fEnviaCorreo();">Enviar <i class="glyphicon glyphicon-send"></i></button>
                                        <div id="envia_correo_dynamic"><!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN --></div>
									</div>
								</cfif>
                            </cfif>
						<cfelse>
                            <div class="panel-body">
								<input id="SsnId" name="SsnId" type="hidden" value="0">
                            </div>
						</cfif>
						<hr>
						<div class="panel-body text-left">
							<!--- Selección de número de registros por página
                            <cfmodule template="#vCarpetaINCLUDE#/registros_pagina_bs.cfm" filtro="CeUpeidFiltro" funcion="fListarSolicitudes" ordenable="no"> --->
						</div>
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
                            <input type="hidden" value="<cfoutput>#Session.CeUpeidFiltro.vRPP#</cfoutput>"  name="vRPP" id="vRPP">
						</div>
                    </div>
				</div>
				<div class="col-sm-10 text-left">
					<cfoutput>
                        <div id="#vDivDynamic#" class="col-sm-12">
                            <!-- DIV PARA DESPLEGAR EL AJAX CON EL LISTADO DE INFORMACIÓN -->						
                        </div>
                    </cfoutput>
				</div>
			</div>
		</div>
		<cfinclude template="../../includes/include_pie_pagina.cfm">
	</body>
</html>