<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 19/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 04/10/2016 --->
<!--- Archivo APPLICATION.CFM --->
<!--- CARACTERÍSTICAS DE LA APLICACIÓN --->

<cfapplication
name="SAMAA"
applicationTimeout = "#createTimeSpan(1,0,0,0)#"
sessionManagement = "yes"
sessionTimeout = "#createTimeSpan(0,1,0,0)#"
setclientcookies="yes"
>


<cfset vTituloSistema= UCASE('Sistema para la Adminstración de Asuntos Académico-Administrativos')>
<cfset Session.vsSistemaClave = 'SAMAA'>
<cfset Session.vsSistemaSiglas = 'SAMAA'>

<!--- Origenes de datos --->
<cfset vOrigenDatosACCESO = 'acceso_sistemas'><!--- Después se utilizará el origen "acceso_sistemas" --->
<cfset vOrigenDatosSAMAA = 'samaa'>

<!--- URLs ANTERIOR --->
<cfif NOT IsDefined("Application.vCarpetaRaiz")>
	<cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
</cfif>
<!--- URLs --->
<cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>

<!--- URLs Lógico --->
<cfif NOT IsDefined("Application.vCarpetaRaizLogica")>
	<cfset Application.vCarpetaRaizLogica = '#ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
</cfif>

<!--- Archivos Lógico --->
<cfif NOT IsDefined("Application.vCarpetaRaizArchivos")>
	<cfset Application.vCarpetaRaizArchivos = 'E:\archivos_samaa'>
</cfif>

<!--- Si es el servidor de desarrollo agregar a la carpoeta raíz la subcarpeta del desarrollador   --->
<cfif CGI.SERVER_PORT IS "31221">
	<cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
	<cfset Application.vCarpetaRaizLogica = '#ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>    
	<cfset Application.vCarpetaRaizArchivos = 'E:\archivos_samaa'>
	<cfset vCarpetaRaizLogica = '/samaa/aram'>        
<cfelse>
	<cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
	<cfset Application.vCarpetaRaizLogica = '#ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
	<cfset Application.vCarpetaRaizArchivos = 'E:\archivos_samaa'>
	<cfset vCarpetaRaizLogica = '/samaa'>
</cfif>

<cfset vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>

<!--- RECURSOS GLOBALES --->
<cfset vHttpWebGlobal = 'http://www.cic-ctic.unam.mx:' & #CGI.SERVER_PORT# & '/comun_cic'>

<!--- Recursos compartidos --->
<cfset vCarpetaLIB = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/comun_cic/jquery'>

<!--- Recursos locales --->
<cfset vCarpetaIMG = '#vCarpetaRaizLogica#/images'>
<cfset vCarpetaICONO = 'http://www.cic-ctic.unam.mx:31220/images/iconos'>
<cfset vCarpetaCSS = '#vCarpetaRaizLogica#/css'>
<cfset vCarpetaCSSGlobal = 'http://www.cic-ctic.unam.mx:31220/comun_cic/css'>
<cfset vCarpetaVAL = '#vCarpetaRaizLogica#/valida'>
<cfset vCarpetaINCLUDE = '#vCarpetaRaizLogica#/includes'>


<!---- ANTERIOR 06/09/2016 
	<!--- URLs --->
	<cfif NOT IsDefined("Application.vCarpetaRaiz")>
		<cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
	</cfif>
	
	<!--- Si es el servidor de desarrollo agregar a la carpoeta raíz la subcarpeta del desarrollador   --->
	<cfif CGI.SERVER_PORT IS "31221">
		<cfif Find("pepe", CGI.SCRIPT_NAME) EQ 1>
			<cfset Application.vCarpetaRaiz = Application.vCarpetaRaiz & "/pepe">
		<cfelseif Find("aram", CGI.SCRIPT_NAME) EQ 1>
			<cfset Application.vCarpetaRaiz = Application.vCarpetaRaiz & "/aram">
		</cfif>
	</cfif>
	
	<!--- URLs Lógico --->
	<cfif NOT IsDefined("Application.vCarpetaRaizLogica")>
		<cfset Application.vCarpetaRaizLogica = '#ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
	</cfif>
	
	<cfif NOT IsDefined("Application.vCarpetaRaizArchivos")>
		<cfset Application.vCarpetaRaizArchivos = 'E:\archivos_ctic'>
	</cfif>
--->