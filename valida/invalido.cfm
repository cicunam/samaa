<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/03/2017 --->
<!--- FECHA: �LTIMA MOD 29/03/2019 --->
<!--- P�GINA QUE NIEGA EL ACCESO AL SISTEMA POR NO TENER ACCESO O T�RMINO DE L�MIETE DE TIEMPO DE INACTIVIDAD --->

<cfscript>StructClear(Session);</cfscript>
<cfscript>StructClear(Application);</cfscript>

<!--- Redirigir a la p�gina de salida  --->
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

<script type="text/javascript">
	top.location.href = 'http://<cfoutput>#CGI.SERVER_NAME#:#CGI.SERVER_PORT##vRutaInicio#</cfoutput>';
</script>