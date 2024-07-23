<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 02/03/2022 --->
<!--- PÁGINA DE INICIO  --->

<!--- Parámetros --->
<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>

<!--- INCLUDE PARA EL LLAMADO DE LAS BASES DE DATOS QUE SE REQUIEREN --->
<cfinclude template="menu_db.cfm">

<!--- Variable para desplegar el número de columnas dependiendo del tamaño de pantalla y/o dispositívo (29/08/2018) --->
<cfset vSizeScreenMenu = 'col-xs-12 col-sm-6 col-md-6 col-lg-4'>

<!DOCTYPE html>
<html lang="es">
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Sistema para la Administración de Asuntos Acad&eacute;mico-Administrativos</title>
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

		<cfoutput>
			<link href="#vCarpetaCSS#/herramientas.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/menus.css" rel="stylesheet" type="text/css">
		</cfoutput>

		<script language="JavaScript" type="text/JavaScript">
			// Generar el calendario de sesiones:
			function fActualizarCalendario(mLink)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				document.getElementById('calendario_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\">";
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('calendario_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP:
				xmlHttp.open("POST", "calendario.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:		
				parametros = "mLink=" + encodeURIComponent(mLink); 
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			function fMenuLocation(vRuta)
			{
				window.parent.location = vRuta;
			}
		</script>
	</head>

	<body onLoad="fActualizarCalendario('0');">
		<cfinclude template="/comun_cic/head/encabezado_sistemas.cfm">
		<cfoutput>
		</cfoutput>
		<nav class="navbar navbar-default navbar-static-top" style="margin-bottom:10px;">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
					</button>
					<cfoutput>
						<div style="float:left;"><img src="#vCarpetaICONO#/sistemas/V2_logo_samaa.png" width="50px" title="SAMAA"></div>
						<!--- DESPLIEGA EL NOMBRE DE LA ENTIDAD PARA TABLETAS Y COMPUTADORAS --->
						<span class="navbar-brand visible-md visible-lg"><strong>#ucase(Session.sDepAcento)#</strong></span>
						<!--- DESPLIEGA LAS SIGLAS DE LA ENTIDAD PARA TELÉFONOS MÓVILES --->
						<span class="navbar-brand visible-xs visible-sm"><strong>#ucase(Session.sDepSiglas)#</strong></span>
					</cfoutput>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav">
						<!---<li><a href="#"><strong><cfoutput>#Session.sDep#</cfoutput></strong></a></li>--->
					</ul>
					<ul class="nav navbar-nav navbar-right">
                    	<!--- CÓDIGO ÚNICO PARA EL CIERRE DE SESIÓN --->
						<cfinclude template="#vCarpetaINCLUDE#/include_cierra_sesion.cfm">
					</ul>
				</div>
			</div>
		</nav>
        <cfoutput>
	       	<div style="padding-left:15px; padding-right:15px; padding-bottom:10px;" align="right"><h5 style="margin:0px; color:##666666">Ciudad Universitaria, Cd. Mx., a #LsDateFormat(now(),'d')# de #LsDateFormat(now(),'mmmm')# de #LsDateFormat(now(),'yyyy')#</h5></div>
		</cfoutput>        
		<div class="container-fluid text-center">    
			<div class="row content">
				<div class="col-sm-1 sidenav">
				</div>
				<div class="col-sm-10 text-left">
                    <!-- Menú principal -->
					<div class="row">
	                    <cfoutput query="tbMenus"><!--- startrow="1" maxrows="3"--->
							<cfinclude template="include_menus_bd.cfm">
    	                </cfoutput>
					</div>
<!---                    
					<div class="row">
	                    <cfoutput query="tbMenus" startrow="4" maxrows="3">
							<cfinclude template="include_menus_bd.cfm">
    	                </cfoutput>
					</div>
					<cfif #tbMenus.RecordCount# GTE 7>
                        <div class="row">
                            <cfoutput query="tbMenus" startrow="7" maxrows="3">
                                <cfinclude template="include_menus_bd.cfm">
                            </cfoutput>
                        </div>
					</cfif>
					<cfif #tbMenus.RecordCount# GTE 10>
                        <div class="row">
                            <cfoutput query="tbMenus" startrow="10" maxrows="3">
                                <cfinclude template="include_menus_bd.cfm">
                            </cfoutput>
                        </div>
					</cfif>
--->					
                    <!--- Menú despliega de fechas --->
                    <div class="row">
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;" align="center">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#336699; padding-top:1px;"><h6 style="color:#FFFFFF;"><strong>Recepci&oacute;n de documentos</strong></h6></div>
                                <div class="well fade in text-center" style="width:90%; height:100px; background-color:#FFFFFF;">
                                    <h6>
                                        <cfoutput>
                                        Fecha l&iacute;mite de recepci&oacute;n de documentos:<br>
                                        #ReReplace(LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'MMMM')#,
                                        para la sesi&oacute;n <strong>#LSNUMBERFORMAT(tbSesionDoc.ssn_id,'9999')#</strong>.
                                        </cfoutput>
                                    </h6>
                                </div>
                            </div>
                        </div>
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;" align="center">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#336699; padding-top:1px;"><h6 style="color:#FFFFFF;"><strong>Reuni&oacute;n de la CAAA</strong></h6></div>
                                <div class="well text-center" style="width:90%; height:100px; background-color:#FFFFFF;">
                                    <h6>
                                        <cfoutput>
                                        Pr&oacute;xima reunión de la CAAA (<strong>#LSNUMBERFORMAT(tbSesionCAAA.ssn_id,'9999')#</strong>):<br>
                                        <cfif IsDate(#tbSesion.ssn_fecha_m#)>
                                            #ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
                                        <cfelse>
                                            #ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
                                        </cfif>
                                        #tbSesionCAAA.ssn_sede#
										</cfoutput>
                                    </h6>
                                </div>
                            </div>
                        </div>
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;" align="center">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#336699; padding-top:1px;"><h6 style="color:#FFFFFF;"><strong>Sesi&oacute;n del Pleno</strong></h6></div>
                                <div class="well fade in text-center" style="width:90%; height:100px; background-color:#FFFFFF;">
                                    <h6>
                                        <cfoutput>
                                        Pr&oacute;xima Sesi&oacute;n <strong>Ordinaria</strong> del pleno (<strong>#vSesionVig#</strong>):<br>
                                        <cfif IsDate(#tbSesion.ssn_fecha_m#)>
                                            #ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
                                        <cfelse>
                                            #ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
                                        </cfif>
                                        #tbSesion.ssn_sede#
										<cfif #tbSesionExtra.RecordCount# GT 0>
											<br><br>
											Pr&oacute;xima Sesi&oacute;n <strong>Extraordinaria</strong> del Pleno:<br>
											#ReReplace(LsDateFormat(tbSesionExtra.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LsDateFormat(tbSesionExtra.ssn_fecha, 'DD')# de #LsDateFormat(tbSesionExtra.ssn_fecha, 'MMMM')# a las #LsTimeFormat(tbSesionExtra.ssn_fecha, 'HH:mm')# hrs.<br>
                                        </cfif>
										</cfoutput>                                        
                                    </h6>
                                </div>                                
                            </div>
                        </div>
                    </div>
                    <!--- Menú de otros --->
                    <div class="row">
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#CCC; border-color:#999; padding-top:1px;"><h6 style="color:#000000"><strong>Calendario de Sesiones</strong></h6></div>
								<div class="well fade in text-center" style="height:300px; background-color:#FFFFFF;">
									<div id="calendario_dynamic" width="90%" style="margin-top:5px;"><!-- AJAX: Calendario de sesiones --></div>
									<div align="center">
										<table width="90%">
											<tr>
												<td width="5%" bordercolor="" bgcolor="#5EBEFF"></td>
												<td width="95%" align="left"><h6 class="small" style="margin:3px;">Sesi&oacute;n Ordinaria del Pleno</h6></td>
											</tr>
											<tr>
												<td bgcolor="#B3E0FF"></td>
												<td align="left"><h6 class="small" style="margin:3px;">Sesi&oacute;n Extraordinaria del Pleno</h6></td>
											</tr>
                                            <tr>
                                                <td bgcolor="#FF9900"></td>
                                                <td align="left"><h6 class="small" style="margin:3px;">Comisi&oacute;n de Asuntos Acad&eacute;mico-Administrativos</h6></td>
                                            </tr>
                                            <tr>
                                                <td bgcolor="#CCCCCC"></td>
                                                <td align="left"><h6 class="small" style="margin:3px;">Fecha l&iacute;mite de recepci&oacute;n de documentos</h6></td>
                                            </tr>
                                        </table>                                    
									</div>
                                </div>
                            </div>
                        </div>
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#CCC; border-color:#999; padding-top:1px;"><h6 style="color:#000000"><strong>Avisos importantes</strong></h6></div>
								<div class="well fade in text-center" style="height:300px; background-color:#FFFFFF;">
									<cfinclude template="include_avisos.cfm">
								</div>
                                <!---
                                <cfif #Session.sTipoSistema# EQ 'stctic'>
                                    <h5>Agregar avisos +</h5>
                                </cfif>
                                --->
                            </div>
                        </div>
                        <div class="<cfoutput>#vSizeScreenMenu#</cfoutput>">
                            <div class="well" style="padding-top:12px;">
                                <div class="alert alert-info fade in text-center" style="height:35px; background-color:#CCC; border-color:#999; padding-top:1px;"><h6 style="color:#000000"><strong>Contacto</strong></h6></div>
								<div class="well fade in text-center" style="height:300px; background-color:#FFFFFF;">
									<div class="row" align="center">
										<h6><strong>Secretaría Técnica del Consejo Técnico</strong></h6>
                                        <!--- LLAMADO A LA TABLA DEL DIRECTORIO DEL PERSONAL DE LA SECRETARÍA TÉCNICA DEL CTIC --->
                                        <cfquery name="tbDirectorio" datasource="#vOrigenDatosSAMAA#">
                                            SELECT *
                                            FROM samaa_stctic_dir
                                            WHERE #now()# BETWEEN fecha_inicio AND fecha_final
                                            AND nivel_id = 1
                                            ORDER BY nivel_id, nombre_comp
                                        </cfquery>
                                        <!--- SE GENERA VARIABLED E SESIÓN PARA LAS SIGLAS EN LOS OFICIOS --->
                                        <cfif Not IsDefined('Session.SiglasStCtic')>
                                            <cfset Session.SiglasStCtic = #tbDirectorio.siglas_oficio#>
                                            <cfset Session.EmailStCtic = #tbDirectorio.siglas_oficio#>                                                
                                        </cfif>
                                        <cfoutput query="tbDirectorio">
                                            <div style="width:65%;">
                                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-user"></span></div>
                                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">#nombre_comp#</h6></div>
                                            </div>
                                            <div style="width:65%;">
                                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-envelope"></span></div>
                                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"><a href="mailto:#email#">#email#</a></h6></div>
                                            </div>
                                            <div style="width:65%;">
                                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-phone-alt"></span></div>
                                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">#telefonof#</h6></div>
                                            </div>
                                        </cfoutput>
                                        <div style="width:65%;">
				                            <a href="contacto_apoyo.cfm?vArea=STCTIC" data-toggle="modal" data-target="#STCTIC"><!--- target="_blank" --->
                                                <div style="width:20%; float:left;"><span class="glyphicon glyphicon-plus"></span></div>
                                                <div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">Personal de apoyo</h6></div>
                                            </a>
											<!--- VENTANA EMERGENTE PARA PERSONAL DE APOYO --->
                                            <div id="STCTIC" class="modal fade" role="dialog">
                                                <div class="modal-dialog">
                                                    <div class="modal-content"></div>
                                                </div>
                                            </div>
                                        </div>
									</div>
                                    <hr style="margin:5px;">
									<div class="row" align="center">
										<h6><strong>Secretaría Técnica de Seguimiento de la Información</strong></h6>
                                        <div style="width:65%;">
                                        	<div style="width:20%; float:left;"><span class="glyphicon glyphicon-user"></span></div>
											<div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"> Aram Pichardo Durán</h6></div>
                                        </div>
                                        <div style="width:65%;">
                                        	<div style="width:20%; float:left;"><span class="glyphicon glyphicon-envelope"></span></div>
											<div style="width:80%; float:left;" align="left"><h6 style="margin:5px;"><a href="mailto:samaa@cic.unam.mx">  samaa@cic.unam.mx</a></h6></div>
                                        </div>
                                        <div style="width:65%;">
                                        	<div style="width:20%; float:left;"><span class="glyphicon glyphicon-phone-alt"></span></div>
											<div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">55562-24168 y 55562-24170</h6></div>
                                        </div>
                                        <div style="width:65%;">
				                            <a href="contacto_apoyo.cfm?vArea=STS" data-toggle="modal" data-target="#STS"><!--- target="_blank" --->                                        
    	                                    	<div style="width:20%; float:left;"><span class="glyphicon glyphicon-plus"></span></div>
												<div style="width:80%; float:left;" align="left"><h6 style="margin:5px;">Personal de apoyo</h6></div>
											</a>
											<!--- VENTANA EMERGENTE PARA PERSONAL DE APOYO --->
                                            <div id="STS" class="modal fade" role="dialog">
                                                <div class="modal-dialog">
                                                    <div class="modal-content"></div>
                                                </div>
                                            </div>
                                        </div>
									</div>
                                </div>
                            </div>
                        </div>
                    </div>
				</div>
				<div class="col-sm-1 sidenav">
				</div>
			</div>
		</div>
		<cfinclude template="../includes/include_pie_pagina.cfm">
	</body>
</html>        