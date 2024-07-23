<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/01/2010 --->
<!--- FECHA ÚLTIMA MOD.: 27/11/2015 --->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Académicos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0">
				<frame src="academico_head.cfm" name="topFrame" scrolling="no" noresize>
				<frame src="consulta_academicos.cfm" name="mainFrame">
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>
	<noframes> 
		<body bgcolor="#FFFFFF" text="#000000" leftmargin="3" topmargin="2">
			<h2>Lo sentimos, este sistema requiere un navegador que soporte <i>frames</i>.</h2>
		</body>
	</noframes> 
</html>
