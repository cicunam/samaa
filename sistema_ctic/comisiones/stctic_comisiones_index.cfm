<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 21/01/2010 --->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Administración de Miembros y Comisiones del CTIC</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0">
			<frame src="stctic_comisiones_head.cfm" name="topFrame" scrolling="NO" noresize>
			<frame src="consejeros/consejeros_ctic_inicio.cfm" name="mainFrame">
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>
	<noframes>
	<body>
		<h1>Lo sentimos, esta p&aacute;gine requiere un navegador que soporte marcos (frames).</h1>
	</body>
	</noframes>
</html>
