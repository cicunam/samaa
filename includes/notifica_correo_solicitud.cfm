<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 07/09/2017 --->
<!--- FECHA ÚLTIMA MOD.: 30/01/2024 --->
<!--- CÓDIGO PARA EL ENVÍO DE CORREO ELECTRÓNICO DE NOTIFICACIÓN DE RENUANCIA DE BECA POSDOC --->

<cfparam name="vSolId" default="0">
<cfparam name="vEmpId" default="0">
<cfparam name="vCodVerifica" default="0">

<!--- 	
<cfset vFind1 =  #Find('-',vCodVerifica)#>
<cfset vFind2 =  #Find('-',vCodVerifica, vFind1 + 1)#>
<cfset vFind3 =  #Find('-',vCodVerifica, vFind2 + 1)#>
<cfset vFind4 =  #Find('-',vCodVerifica, vFind3 + 1)#>
<cfset vFind5 =  #Find('-',vCodVerifica, vFind4 + 1)#>								
#vFind1# - #vFind2# - #vFind3# - #vFind4# - #vFind5# 
--->
<cfif (isValid("integer", #vSolId#) AND #vSolId# GT 150000) AND (isValid("integer", #vEmpId#) AND #vEmpId# GT 50000) AND LEN(#vCodVerifica#) GT 30>
    
    <!--- Obtener información del catálogo de bajas --->
    <cfquery name="tbNotificaCorreo" datasource="samaa">
        SELECT * FROM samaa_notifica_correos
        WHERE sol_id = #vSolId#
        AND notifica_no_empleado = #vEmpId#
        AND notifica_clave_alfanum  = '#vCodVerifica#'
        AND notifica_acuse IS NULL
    </cfquery>
    <!---
    <cfoutput>
    #vSolId# - #vEmpId# - #vCodVerifica# - #tbNotificaCorreo.RecordCount#
    </cfoutput>
    --->

	
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
                <cfif #tbNotificaCorreo.RecordCount# EQ 0>
                    
                    <cfquery name="tbNotificaCorreoOk" datasource="samaa">
                        SELECT * FROM samaa_notifica_correos
                        WHERE sol_id = #vSolId#
                        AND notifica_no_empleado = #vEmpId#
                        AND notifica_clave_alfanum  = '#vCodVerifica#'
                        AND notifica_acuse = 1
                    </cfquery>
                    <cfoutput query="tbNotificaCorreoOk">
						<h4><strong>
	                        EL CORREO YA FUE NOTIFICADO EL D&Iacute;A #LsDateFormat(notifica_fecha_acuse,'dd')# de #LsDateFormat(notifica_fecha_acuse,'mmmm')# de #LsDateFormat(notifica_fecha_acuse,'yyyy')#
							<br />
							GRACIAS!
						</strong></h4>
                        <br />
                    </cfoutput>
                </cfif>
                <cfif #tbNotificaCorreo.RecordCount# EQ 1>
                    <span class="Sans14NeNe">
                        <h4><strong>EL CORREO HA SIDO NOTIFICADO, GRACIAS.</strong></h4>
                    </span>
                    <cfquery datasource="samaa">
                        UPDATE samaa_notifica_correos SET
                        notifica_acuse = 1
                        ,
                        notifica_fecha_acuse = GETDATE()
                        WHERE sol_id = #vSolId#
                        AND notifica_no_empleado = '#vEmpId#'
                        AND notifica_clave_alfanum  = '#vCodVerifica#'
                        AND notifica_acuse IS NULL
                    </cfquery>            
                </cfif>
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
<cfelse>
	<cflocation url="https://www.cic.unam.mx" addtoken="no">
</cfif>			
