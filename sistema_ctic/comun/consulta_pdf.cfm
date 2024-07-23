<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 04/04/2019 --->
<!--- FECHA ÚLTIMA MOD: 12/01/2023 --->

<cfparam name="vArchivoPdf" default="">
<cfparam name="vModulo" default="">
<cfparam name="vSolStatus" default="">
<cfparam name="vCarpEntidad" default="">

<cfset vParamFecha = #LsDateFormat(now(),'yyyymmdd')# & #LsTimeFormat(now(),'hhmmss')#>
<!--- Identifica si el sistema se accesa por algun dispositivo móvil de APPELE --->
<cfset vIpad = Find('iPad',CGI.HTTP_USER_AGENT)>
<cfset vIphone = Find('iPhone',CGI.HTTP_USER_AGENT)>

<cfif #vModulo# EQ 'SOL'>
	<cfif #vSolStatus# LTE 2>
		<cfset vArchivoPdfWeb = '#vWebCAAA##vArchivoPdf#?#vParamFecha#'>
	<cfelseif #vSolStatus# GTE 3>
		<cfset vArchivoPdfWeb = '#vWebENTIDAD##vCarpEntidad#/#vArchivoPdf#?#vParamFecha#'>
	</cfif>
<cfelseif #vModulo# EQ 'MOV'>
	<cfset vArchivoPdfWeb = '#vWebAcademicos##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'MCTIC'>
	<cfset vArchivoPdfWeb = '#vWebCargosAA##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'ORDENDIA'>
	<cfset vArchivoPdfWeb = '#vWebSesionHistoria##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'ESTDGAPA'>
	<cfset vArchivoPdfWeb = '#vWebSesionOtros##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'INFORME'>
	<cfset vArchivoPdfWeb = '#vWebInforme##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'SOLCOA'>
	<cfset vArchivoPdfWeb = '#vWebSolicitudCOA##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'SOLCOAOFICIO'>
	<cfset vArchivoPdfWeb = '#vWebCoaOficios##vArchivoPdf#?#vParamFecha#'>
<cfelseif #vModulo# EQ 'GRADOACAD'>
	<cfset vArchivoPdfWeb = '#vWebGradoAcad##vArchivoPdf#?#vParamFecha#'>        
<cfelseif #vModulo# EQ 'SESION'>
	<!--- PENDIENTE --->
	<!--- <cfset vArchivoPdfWeb = '#vWebInforme##vArchivoPdf#?#vParamFecha#'> --->
</cfif>



<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title><cfif #CGI.SERVER_PORT# IS '31221'>SD / </cfif>SAMAA - Consulta archivo</title>
	</head>
	<frameset rows="0,*" frameborder="no" border="0" framespacing="0">
	  <frame src="../../UntitledFrame-9" name="topFrame" scrolling="No" noresize="noresize" id="topFrame" />
	  <frame src="<cfoutput>#vArchivoPdfWeb#</cfoutput>" name="mainFrame" id="mainFrame" />
	</frameset>
	<noframes>
		<body></body>
	</noframes>
</html>