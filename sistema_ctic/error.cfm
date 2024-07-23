<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
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
		</style>
	</head>
	<body style="padding:15px 25px 15px 25px; width:1024px;">
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
			<span class="Sans12NeNe">Ayudanos a corregir el error</span>
			<p class="Sans10Gr">
				Favor de copiar la información de arriba y enviarla a la <a href = "mailto:#error.mailTo#">Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica</a> para darle soluci&oacute;n lo antes posible.
			</p>
		</cfoutput>
	</body>
</html>