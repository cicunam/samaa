<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 23/03/2019 --->

<!--- Cerrar la sesión --->
<cfscript>StructClear(Session);</cfscript>
<cfscript>StructClear(Application);</cfscript>

<!--- Redirigir a la página de salida  --->
<cfif CGI.SERVER_PORT IS "31221">
	PUERTO <cfoutput>#Find('pepe', CGI.SCRIPT_NAME)# #Find('aram', CGI.SCRIPT_NAME)#</cfoutput>
	<cfif Find('pepe', #CGI.SCRIPT_NAME#) GT 0>
		<cfset vRutaInicio = "/samaa/pepe/"> --->
	<cfelseif Find('aram', #CGI.SCRIPT_NAME#) GT 0>
		<cfset vRutaInicio = "/samaa/aram/">
	</cfif>
<cfelse>
	<cfset vRutaInicio = "/samaa/">
</cfif>

<cflocation url="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##vRutaInicio#" addtoken="no">

