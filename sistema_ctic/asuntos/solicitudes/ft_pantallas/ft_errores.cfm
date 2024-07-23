

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">	
           <link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
           <link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">			
	</head>
	<body>
		<!-- Encabezado -->
		<table width="615" border="0" cellpadding="0" cellspacing="0">
		  <!-- Lugar y fecha -->
		  <tr bgcolor="#FF9900">
		    <td height="10" colspan="2" bgcolor="#7BA7D2">
			    <!-- Espacio disponible -->
			</td>
		  </tr>
		  <!-- CIC-STS -->
		  <tr>
		    <td width="587" height="60" bgcolor="#336699">
			    <span class="Sans14BlNe">
				    Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica<br />
		            Secretar&iacute;a T&eacute;cnica del Consejo T&eacute;cnico
				</span>
			</td>
		    <td width="28" bgcolor="#FFFFFF">
				<img src="<cfoutput>#vCarpetaIMG#</cfoutput>/cic_nuevo_60.png" title="P&aacute;gina principal" width="60" height="60" border="0">
			</td>
		  </tr>
		  <!-- Nombre del sistema -->
		  <tr>
		    <td height="25">
			    <span class="Sans12NeNe">
				    <em>Sistema para la Administraci&oacute;n de Movimientos Acad&eacute;mico-Administrativos</em>
				</span>
			</td>
		    <td height="25" bgcolor="#336699">&nbsp;</td>
		  </tr>
		</table>
		<!-- Titulo de la ventana -->
		<table width="615" border="0" cellpadding="0" cellspacing="0">
		  <tr><td height="14" bgcolor="#7BA7D2"><div align="left" class="Sans9Ne">FORMATOS PARA EL TRAMITE DE LOS ASUNTOS ACAD&Eacute;MICO-ADMINISTRATIVO</div></td></tr>
		</table>
		<!-- Lista de errores -->
		<span class="Sans11Ne" style="margin:20px; padding:20px;" align="center">
			El sistema encontr&oacute; los siguientes errores al intentar guardar los datos de la solicitud:
			<ul class="Sans11Ne">
				 <cfoutput>#vListaErrores#</cfoutput>
			</ul>
			Por favor, corrija los valores de los campos marcados en rojo y vuelva a guardar la solicitud.
		</span>
	</body>
</html>
