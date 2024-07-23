<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 25/06/2018 --->
<!--- FECHA ÚLTIMA MOD.: 28/06/2018--->
<!--- PÁGINA DE INICIO PARA ACCESO A SISTEMAS --->
<!--- SISTEMA DE ADMINISTRACIÓN DE MOVIMIENTOS ACADÉMICO-ADMINISTRATIVOS --->

<cfparam name="vpReturnValor" default="">

<!DOCTYPE html>
<html lang="es">
	<head>
		<cfoutput>
			<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / #Session.vsSistemaSiglas#<cfelse>CIC - #vTituloSistema#</cfif></title>
		</cfoutput>
		<meta charset="charset=iso-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

		<cfoutput>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

			<script src="#vHttpWebGlobal#/sistemas/java_script_accesos.js"></script>
           
		</cfoutput>
	</head>
	<body onLoad="init();">
		<!--- Obtener el HTML del encabezado --->
        <cfhttp url="#vHttpWebGlobal#/head/encabezado_sistemas.cfm" method="post" resolveurl="true">
            <cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
            <cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
            <cfhttpparam type="COOKIE" name="vTituloSistema" value="#vTituloSistema#">
        </cfhttp>
		<cfoutput>#cfhttp.fileContent#</cfoutput>

		<nav class="navbar navbar-default navbar-static-top">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
					<cfoutput>
						<div style="float:left;"><img src="#vCarpetaICONO#/sistemas/V2_logo_samaa.png" width="50px"></div>
						<span class="navbar-brand visible-lg" title="#vTituloSistema#">
							<strong>#UCASE(Session.vsSistemaSiglas)#</strong>
						</span>
                        <!---  --->
					</cfoutput>
				</div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<ul class="nav navbar-nav"></ul>
					<ul class="nav navbar-nav navbar-right">
						<li>
							<a href="<cfoutput>#vHttpWebGlobal#</cfoutput>/sistemas/modal_req_contacto.cfm?vTipoConsultaModal=RQ" data-toggle="modal" data-target="#modRequisitosSistema">
								<span class="glyphicon glyphicon glyphicon-cog"></span> Requisitos de sistema
							</a>
						</li>
						<li>
							<a href="<cfoutput>#vHttpWebGlobal#</cfoutput>/sistemas/modal_req_contacto.cfm?vTipoConsultaModal=CS" data-toggle="modal" data-target="#modContactoSistema">
								<span class="glyphicon glyphicon-envelope"></span> Contacto
							</a>
						</li>
					</ul>
				</div>
			</div>
		</nav>
		<div class="container-fluid text-center">
			<div class="row content">
				<div class="col-xs-0 col-sm-2 col-md-4 col-lg-4 sidenav text-left visible-sm visible-md visible-lg"></div>
				<div class="col-xs-12 col-sm-8 col-md-4 col-lg-4 text-left center-block">
					<div class="col-xs-0 col-sm-1 col-md-1 col-lg-1"></div>
					<div class="col-xs-12 col-sm-10 col-md-10 col-lg-10">
						<div class="panel panel-default">
							<div class="panel-heading"><h5 class="text-center"><strong>ACCESO A SISTEMA</strong></h5></div>
							<div class="panel-body">
								<cfif #vpReturnValor# GT 0>
									<cfinclude template="/comun_cic/sistemas/include_msj_error_acceso.cfm">
								</cfif>
                                <cfform id="frmAccesoSis">
                                    <div id="divUser" class="form-group">
                                        <!--- <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span> --->
                                        <label for="usuario_acceso">Usuario:</label>
                                        <cfinput id="usuario_acceso" name="vpUno" type="text" class="form-control" placeholder="Escribir usuario con mayúsculas y minúsculas" onClick="fLimpiaFormulario(1);" onkeypress="DetectarEnter(event,'#Session.vsSistemaClave#');">
										<span id="spanUser" class=""></span>
                                    </div>
                                    <div id="divDos" class="form-group">
                                        <!--- <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span> --->
                                        <label for="password">Contraseña:</label>
                                        <cfinput id="password" name="vpDos" type="password" class="form-control" placeholder="Escribir contraseña con mayúsculas y minúsculas" onClick="fLimpiaFormulario(2);" onkeypress="DetectarEnter(event,'#Session.vsSistemaClave#');">
										<span id="spanDos" class=""></span>                                        
                                    </div>
                                    <div class="btn-group btn-group-justified">
									    <div class="btn-group">
                                    	    <button type="button" class="btn btn-primary" onClick="fValidaCampos('<cfoutput>#Session.vsSistemaClave#</cfoutput>');">Iniciar</button>
										</div>
										<cfinput name="vpHttp" type="hidden" id="vpHttp" value="#vCarpetaRaiz#" />
										<cfinput id="vpSistema" name="vpSistema" type="hidden" value="#Session.vsSistemaClave#">
									    <div class="btn-group">
	                                        <button type="button" class="btn btn-basic" onClick="fLimpiaFormulario(0);">Limpiar formulario</button>
										</div>
									</div>
                                </cfform>
							</div>
						</div>                            
                    </div>
					<div class="col-xs-0 col-sm-1 col-md-1 col-lg-1"></div>
				</div>
				<div class="col-xs-0 col-sm-2 col-md-4 col-lg-4 sidenav text-left visible-sm visible-md visible-lg"></div>
				</div>                
			</div>
		</div>
		<!--- VENTANA EMERGENTE PARA PERSONAL DE APOYO --->
        <div id="modRequisitosSistema" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content modal-sm"></div>
            </div>
        </div>
        <div id="modContactoSistema" class="modal fade" role="dialog">
            <div class="modal-dialog">
                <div class="modal-content modal-md"></div>
            </div>
        </div>
	</body>
</html>