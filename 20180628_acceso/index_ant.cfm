<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 27/08/2014 --->
<cfparam name="vpReturnValor" default="">
<cfset StructClear(Session)>
<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Sistema para la Administración de Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<meta name="description" content="Sistema de Administración de Movimientos Académico-Administrativos">
		<meta name="keywords" lang="es-MX" content="UNAM, CIC, CTIC, SAMAA, Administración, Asuntos Académico-Administrativos">
		<meta name="author" content="CIC-CTIC-UNAM">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0"> 
			<frame name="encabezado" src="head.cfm" scrolling="no" noresize>
			<frame name="contenido" src="valida.cfm?vpReturnValor=<cfoutput>#vpReturnValor#</cfoutput>">
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>
	<noframes> 
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="3" topmargin="2">
		<h2>Lo sentimos, este sistema requiere un navegador que soporte <i>frames</i>.</h2>
	</body>
	</noframes> 
</html>
