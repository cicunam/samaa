<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 11/01/2017 --->
<!--- FECHA ÚLTIMA MOD.: 27/08/2020 --->

<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="2">

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Movimientos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0"> 
			<frame name="topFrame" scrolling="NO" noresize src="movimientos_head.cfm" >
			<cfoutput query="tbSistemaSubMenu" startrow="1" maxrows="1">
				<frame name="mainFrame" src="#ruta_liga#">
			</cfoutput>
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>
	<noframes> 
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="3" topmargin="2">
		<h2>Lo sentimos, este sistema requiere un navegador que soporte <i>frames</i>.</h2>
	</body>
	</noframes>  
</html>
