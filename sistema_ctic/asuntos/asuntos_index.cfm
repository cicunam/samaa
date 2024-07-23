<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDOTEST_EXT --->
<!--- FECHA CREA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD.: 28/02/2022 --->

<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="1">

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">
<cfif #Session.sTipoSistema# EQ 'sic'>
	<cfset vStartrow = 1>
<cfelseif #Session.sTipoSistema# EQ 'stctic'>
    <cfif #Session.sUsuarioNivel# LTE 2>
	    <cfset vStartrow = 2>
    <cfelse>
	    <cfset vStartrow = 1>
    </cfif>
</cfif>

<html>
	<head>
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Solicitudes</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	</head>
	<frameset cols="*,1024,*" frameborder="no" framespacing="0">
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
		<frameset rows="115,*" cols="*" frameborder="no" border="0" framespacing="0"> 
			<frame name="topFrame" scrolling="NO" noresize src="asuntos_head.cfm" >
			<cfoutput query="tbSistemaSubMenu" startrow="#vStartrow#" maxrows="1">
				<frame name="mainFrame" src="#ruta_liga#">
			</cfoutput>
<!---
			<cfif #Session.sTipoSistema# EQ 'sic'>
				<frame name="mainFrame" src="solicitudes/consulta_solicitudes.cfm">
			<cfelseif #Session.sTipoSistema# EQ 'stctic'>
				<frame name="mainFrame" src="solicitudes/consulta_revisiones.cfm">

				<cfif #modulo# IS 'Solicitudes'>
				<cfelseif #modulo# IS 'AsuntosCAAA'>
					<frame name="mainFrame" src="asuntos_caaa/stctic_caaa_lista.cfm">
				<cfelseif #modulo# IS 'AsuntosCTIC'>
					<frame name="mainFrame" src="asuntos_pleno/stctic_pleno_lista.cfm">
				</cfif>
			</cfif>
--->			
		</frameset>
		<frame src="<cfoutput>#vHttpWebGlobal#</cfoutput>/background.html" scrolling="no" noresize>
	</frameset>
	<noframes> 
	<body bgcolor="#FFFFFF" text="#000000" leftmargin="3" topmargin="2">
		<h2>Lo sentimos, este sistema requiere un navegador que soporte <i>frames</i>.</h2>
	</body>
	</noframes>  
</html>
