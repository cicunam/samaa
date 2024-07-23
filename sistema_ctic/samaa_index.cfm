<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 17/04/2009 --->
<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Sistema para la Administración de Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0"> 
			<frame name="encabezado" src="samaa_head.cfm" scrolling="no" noresize>
			<frame name="contenido" src="samaa_menu.cfm">
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>	
	<noframes> 
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="3" topmargin="2">
		<h2>Lo sentimos, este sistema requiere un navegador que soporte <i>frames</i>.</h2>
	</body>
	</noframes> 
</html>
