<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 03/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 22/02/2022 --->
<!--- Archivo APPLICATION.CFM --->
<!--- CARACTERÍSTICAS DE LA APLICACIÓN --->
<cfapplication  
name="SAMAA_CBP"
applicationTimeout = "#createTimeSpan(1,0,0,0)#"						
sessionManagement = "yes"
sessionTimeout = "#createTimeSpan(0,6,0,0)#"
setclientcookies="yes"
>


<cfif NOT IsDefined("Application.vCarpetaRaiz")>
	<cfif CGI.SERVER_PORT IS "31221">
        <cfif Find("pepe", CGI.SCRIPT_NAME) NEQ 0>
            <cfset vCarpetaRaizLogica = '/samaa/pepe'>
        <cfelseif Find("aram", CGI.SCRIPT_NAME) NEQ 0>
            <cfset vCarpetaRaizLogica = '/samaa/aram'>
        </cfif>
    <cfelse>
        <cfset vCarpetaRaizLogica = '/samaa'>
    </cfif>
   	<cflocation url="#vCarpetaRaizLogica#/valida/invalido.cfm?vError=Restringe" addtoken="no">
<cfelse>
	<!--- Origenes de datos --->
    <cfset vOrigenDatosACCESO = 'acceso_sistemas'><!--- Después se utilizará el origen "acceso_sistemas" --->
    <cfset vOrigenDatosSAMAA = 'samaa'>
    <cfset vOrigenDatosCATALOGOS = 'catalogos'>

	<cfif CGI.SERVER_PORT IS "31221">
        <cfif Find("pepe", CGI.SCRIPT_NAME) NEQ 0>
            <cfset vCarpetaRaizLogica = '/samaa/pepe'>
			<cfset vCarpetaRaizLogicaSistema = '/samaa/pepe/app_cbp'>
        <cfelseif Find("aram", CGI.SCRIPT_NAME) NEQ 0>
            <cfset vCarpetaRaizLogica = '/samaa/aram'>
			<cfset vCarpetaRaizLogicaSistema = '/samaa/aram/app_cbp'>
        </cfif>
        <cfset Application.vCarpetaRaizArchivos = 'E:\archivos_samaa'>
    <cfelse>
        <cfset vCarpetaRaizLogica = '/samaa'>
		<cfset vCarpetaRaizLogicaSistema = '/samaa/app_cbp'>
    </cfif>    
    
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
	<cfset vCarpetaINCLUDE = '#Application.vCarpetaRaizLogica#/includes'>        
    <!--- CARPETA VIRTUAL PARE PODER ACCESAR A LOS ARCHIVOS --->
    <cfset vWebCBP = '#vCarpetaRaizLogicaSistema#/archivos_cbp/'>

<!---
    <cfset vWebPleno = '#vCarpetaRaizLogica#/archivos_ctic/archivos_pleno/sesion/'>
    <cfset vWebCAAA = '#vCarpetaRaizLogica#/archivos_ctic/archivos_pleno/asuntos/'>
    <cfset vWebEntidad = '#vCarpetaRaizLogica#/archivos_ctic/archivos_entidades/'>
--->	
    <!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
    <cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
    <cfset vCarpetaCBP = '#vCarpetaRaizArchivos#\archivos_pleno\asuntos\'>
<!---
    <cfset vCarpetaPleno = '#vCarpetaRaizArchivos#\archivos_pleno\sesion\'>
    <cfset vCarpetaEntidad = '#vCarpetaRaizArchivos#\archivos_entidades\'>
--->	
    <!--- FUNCIONES DE USO COMÚN --->
    <cfscript>
        function SinAcentos(texto, comillas)
        {
            // Reemplazar minusculas:
            texto = Replace(texto, "á", "a", "all");
            texto = Replace(texto, "é", "e", "all");
            texto = Replace(texto, "í", "i", "all");
            texto = Replace(texto, "ó", "o", "all");
            texto = Replace(texto, "ú", "u", "all");
            // Reemplazar mayusculas:
            texto = Replace(texto, "Á", "A", "all");
            texto = Replace(texto, "É", "E", "all");
            texto = Replace(texto, "Í", "I", "all");
            texto = Replace(texto, "Ó", "O", "all");
            texto = Replace(texto, "Ú", "U", "all");
            // Quitar siempre comillas simple:
            texto = Replace(texto, "'", "", "all");
            texto = Replace(texto, Chr(145), "", "all");
            texto = Replace(texto, Chr(146), "", "all");
            // Reemplazar comilla doble provenientes de MS-WORD:
            texto = Replace(texto, Chr(147), """", "all");
            texto = Replace(texto, Chr(148), """", "all");
            // Determinar si se quitan las comillas dobles:
            if (comillas EQ 0) texto = Replace(texto, """", "", "all");
            // Regresar la cadena transformada:
            return texto;
        }
    </cfscript>
    <cffunction name="FechaCompleta" returntype="String" description="Generar una fecha en formato largo respetando la configuración regional del servidor.">
        <cfargument name="aFecha">
        <cfif #aFecha# NEQ "">
            <cfreturn LsDateFormat(aFecha,"d") & " de" & " " & rereplace(LsDateFormat(aFecha,"mmmm") , '^\w', '\u\0') & " de " & LsDateFormat(aFecha,"yyyy")>
        <cfelse>
            <cfreturn "">
        </cfif>
    </cffunction>
    <cffunction name="ArrayContainsValue" returntype="boolean" description="Verifica si existe un elemento dentro de un arreglo.">
        <cfargument name="aArray">
        <cfargument name="aElement">
        <!--- Recorrer el arreglo en busca del elemento --->
        <cfloop index="E" from="1" to="#ArrayLen(aArray)#">
            <cfif #aArray[E]# EQ #aElement#><cfreturn TRUE></cfif>
        </cfloop>
        <cfreturn FALSE>
    </cffunction>
    <cffunction name="ArrayIndexOf" returntype="Numeric" description="Regresa la posición de un elemento en un arreglo, o CERO si no lo encuentra.">
        <cfargument name="aArray">
        <cfargument name="aElement">
        <!--- Recorrer el arreglo en busca del elemento --->
        <cfloop index="E" from="1" to="#ArrayLen(aArray)#">
            <cfif #aArray[E]# EQ #aElement#><cfreturn E></cfif>
        </cfloop>
        <cfreturn 0>
    </cffunction>
    <cffunction name="PrimeraPalabra" description="Devuelve la primera palabra de una frase">
        <cfargument name="aTexto">
        <cfif #Find(" ", Trim(aTexto))# IS 0>
            <cfreturn #aTexto#>
        <cfelse>
            <cfreturn #Left(aTexto, Find(" ", Trim(aTexto)) - 1)#>	
        </cfif>
    </cffunction>
    <cffunction name="CnSinTiempo" description="Quita el texto de tiempo del nombre de una categoría">
        <cfargument name="aCnDescrip">
        <cfset rCn = #aCnDescrip#>
        <cfset rCn = #Replace(rCn,' DE TIEMPO COMPLETO','')#>
        <cfset rCn = #Replace(rCn,' DE MEDIO TIEMPO','')#>
        <cfset rCn = #Replace(rCn,' DE TC','')#>
        <cfset rCn = #Replace(rCn,' DE MT','')#>
        <cfset rCn = #Replace(rCn,' TC','')#>
        <cfset rCn = #Replace(rCn,' MT','')#>
        <cfreturn #rCn#>
    </cffunction>
    
    <!---------------------------------------------------------------------------------------------------------------------->
    <!--- Función para generar el código necesario para accesar una tabla de MySQL desde SQL Server (servidor vinculado) --->
    <!---------------------------------------------------------------------------------------------------------------------->
    <cffunction name="MYSQL" returntype="string" description="Generar el código SQL necesario para acceder a una tabla de CISIC(MySQL) desde el origen de datos CTIC(MSSQL).">
        <cfargument name="vNombreBase">
        <cfargument name="vNombreTabla">
        <cfargument name="vFiltroTabla">
        <!--- Generar el SQL de la consulta al servidor vinculado --->
        <cfset vSQL = 'SELECT * FROM #LCase(vNombreBase)#.#vNombreTabla#'>
        <!--- Se puede aplicar un flitro a la consulta para optimizar el tiempo de respuesta --->
        <cfif #IsDefined('vFiltroTabla')# AND #vFiltroTabla# IS NOT ''>
            <cfset vSQL = vSQL + 'WHERE #vFiltroTabla#'>
        </cfif>
        <!--- Regresar el código --->
        <cfreturn "OPENQUERY(MYSQL, '#vSQL#')">
    </cffunction>
    
    <cfif IsDefined('Session.sLoginSistema') AND IsDefined('Session.sTipoSistema')>
    	<cfif #Session.sLoginSistema# NEQ 'cbp' AND #Session.sTipoSistema# NEQ 'samaa_cbp'>
			<cflocation url="#vCarpetaRaizLogica#/valida/invalido.cfm?vError=Restringe" addtoken="no">
		</cfif>            
	<cfelse>
		<cflocation url="#vCarpetaRaizLogica#/valida/invalido.cfm?vError=Restringe" addtoken="no">
    </cfif>

</cfif>

<!--- MANEJO DE ERRORES DE SISTEMA --->
<cferror type="exception" template="../includes/error.cfm" mailto="samaa@cic.unam.mx" exception="any">
<cferror type="request" template="../includes/error.cfm" mailto="samaa@cic.unam.mx" exception="any">