<!--- CREADO: JOSÉ ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 02/05/2022 --->
<!--- CACHA LOS ERRORES QUE SE GENEREN EN EL SISTEMA --->

<html>
	<head>
		<cfoutput>
			<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / #Session.vsSistemaSiglas#<cfelse>CIC - #vTituloSistema#</cfif></title>
		</cfoutput>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<style type="text/css">
			.Sans10Gr {
				font-family: sans-serif;
				font-size: 10px;
				color: #333333;
				font-weight: normal;
			}
			.Sans10GrNe {
				font-family: sans-serif;
				font-size: 10px;
				color: #333333;
				font-weight: bold;
			}
			.Sans12Ne {
				font-family: sans-serif;  
				font-size: 12px; 
				color: #000000; 
			}
			.Sans12NeNe {
				font-family: sans-serif;  
				font-size: 12px; 
				color: #000000; 
				font-weight: bold;
			}
			.Sans16NeNe {
				font-family: sans-serif; 
				font-size: 16px; 
				color: #000000; 
				font-weight: bold;
			}
			.Sans25NeNe {
				font-family: sans-serif; 
				font-size: 25px; 
				color: #000000; 
				font-weight: bold;
			}
		</style>
	</head>
	<body style="width:1024px;">
		<div>
			<cfoutput>        
                <div style="width:10%; float:left;"><img src="https://vectores.cic.unam.mx/images/cic/cic_nuevo_70.png"></div>
                <div style="width:90%; height:90px; padding-top:15px;"><span class="Sans25NeNe">COORDINACIÓN DE LA INVESTIGACIÓN CIENTÍFICA</span></div>
			</cfoutput>            
		</div>
        
		<div style="width:100%"></div>
		<div>
			<cfoutput>
                <span class="Sans16NeNe">Ha ocurrido un error de sistema</span>
                <p>
                    <span class="Sans10GrNe">Direcci&oacute;n IP:</span><br><span class="Sans10Gr">#error.remoteAddress#</span><br>
                    <span class="Sans10GrNe">Navegador:</span><br><span class="Sans10Gr">#error.browser#</span><br>
                    <span class="Sans10GrNe">Fecha y hora:</span><br><span class="Sans10Gr">#error.dateTime#</span><br>
                    <span class="Sans10GrNe">P&aacute;gina de referencia:</span><br><span class="Sans10Gr">#error.HTTPReferer#</span><br>
                    <span class="Sans10GrNe">Script donde se generó el error:</span><br><span class="Sans10Gr">#error.template#</span><br>
                </p>
                <span class="Sans12NeNe">Descripci&oacute;n del error</span>
                <p class="Sans10Gr">
                    #error.diagnostics#
                </p>
                <cfif isDefined('error.RootCause.Sql') AND #error.RootCause.Sql# IS NOT ''>
                    <p class="Sans10Gr">
                        #error.RootCause.Sql#
                    </p>
                </cfif>
                <span class="Sans12NeNe">Ay&uacute;denos a corregir el error</span>
                <p class="Sans12Ne">
                    Favor de copiar la informaci&oacute;n de arriba y enviarla a la correo electr&oacute;nico <strong><a href = "mailto:#error.mailTo#">samaa@cic.unam.mx</a></strong>, para darle soluci&oacute;n lo antes posible.
                </p>
            </cfoutput>
		</div>
	</body>
</html>