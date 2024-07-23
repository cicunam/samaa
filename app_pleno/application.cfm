<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 03/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 22/02/2022 --->
<!--- Archivo APPLICATION.CFM --->
<!--- CARACTERÍSTICAS DE LA APLICACIÓN --->
<cfapplication
name="SAMAA"
applicationTimeout = "#createTimeSpan(1,0,0,0)#"
sessionManagement = "yes"
sessionTimeout = "#createTimeSpan(0,3,0,0)#"
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
            <cfset vCarpetaRaizLogicaSistema = '/samaa/pepe/app_pleno'>
        <cfelseif Find("aram", CGI.SCRIPT_NAME) NEQ 0>
            <cfset vCarpetaRaizLogica = '/samaa/aram'>
            <cfset vCarpetaRaizLogicaSistema = '/samaa/aram/app_pleno'>
        </cfif>
        <cfset Application.vCarpetaRaizArchivos = 'E:\archivos_samaa'>
    <cfelse>
        <cfset vCarpetaRaizLogica = '/samaa'>
            <cfset vCarpetaRaizLogicaSistema = '/samaa/app_pleno'>
    </cfif>

    <!--- RECURSOS GLOBALES --->
    <cfset vHttpWebGlobal = 'https://www.cic.unam.mx:' & #CGI.SERVER_PORT# & '/comun_cic'>
    
    <!--- Recursos compartidos --->
    <cfset vCarpetaLIB = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/comun_cic/jquery'>
    
    <!--- Recursos locales --->
    <cfset vCarpetaIMG = '#vCarpetaRaizLogica#/images'>
	<cfset vCarpetaICONO = 'http://www.cic-ctic.unam.mx:31220/images/iconos'>
    <cfset vCarpetaCSS = '#vCarpetaRaizLogica#/css'>
	<cfset vCarpetaCSSGlobal = 'http://www.cic-ctic.unam.mx:31220/comun_cic/css'>
    <cfset vCarpetaVAL = '#vCarpetaRaizLogica#/valida'>
	<cfset vCarpetaINCLUDE = '#vCarpetaRaizLogica#/includes'>    
 
    
    <!--- CARPETA VIRTUAL PARE PODER ACCESAR A LOS ARCHIVOS --->
    <cfset vWebCAAA = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_pleno/asuntos/'>
    <cfset vWebEntidad = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_entidades/'>
    <cfset vWebAcademicos = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_academicos/'>
    <cfset vWebInformesAnuales = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_academicos_inf_anual/'>
    <cfset vWebSesionHistoria = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_sesion/'>
    <cfset vWebSesionOtros = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_sesion_otros/'>    
<!---
    <cfset vWebCAAA = '#vCarpetaRaizLogica#/archivos_ctic/archivos_pleno/asuntos/'>
    <cfset vWebEntidad = '#vCarpetaRaizLogica#/archivos_ctic/archivos_entidades/'>
    <cfset vWebAcademicos = '#vCarpetaRaizLogica#/archivos_ctic/archivos_academicos/'>
    <cfset vWebSesionHistoria = '#vCarpetaRaizLogica#/archivos_ctic/archivos_sesion/'>
    <cfset vWebSesionOtros = '#vCarpetaRaizLogica#/archivos_ctic/archivos_sesion_otros/'>
--->	
    <!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
    <cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
    <cfset vCarpetaCAAA = '#vCarpetaRaizArchivos#\archivos_pleno\asuntos\'>
    <cfset vCarpetaEntidad = '#vCarpetaRaizArchivos#\archivos_entidades\'>
    <cfset vCarpetaAcademicos = '#vCarpetaRaizArchivos#\archivos_academicos\'>
	<cfset vCarpetaInformesAnuales = '#vCarpetaRaizArchivos#\archivos_academicos_inf_anual\'>
    <cfset vCarpetaSesionHistoria = '#vCarpetaRaizArchivos#\archivos_sesion\'>
    <cfset vCarpetaSesionOtros = '#vCarpetaRaizArchivos#\archivos_sesion_otros\'>

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
    <cffunction name="PrimeraPalabra" description="Devuelve la primera palabra de una frase">
        <cfargument name="aTexto">
        <cfif #Find(" ", Trim(aTexto))# IS 0>
            <cfreturn #aTexto#>
        <cfelse>
            <cfreturn #Left(aTexto, Find(" ", Trim(aTexto)) - 1)#>
        </cfif>
    </cffunction>
    <cffunction name="cffTamañoArchivo" description="Devuelve el tamaño de un archivo">
        <cfargument name="aTamArch">
        <cfif #aTamArch# GT 1000000>
            <cfset vTamArch = (#NombreCarpeta.size# / 1024) / 1024>
        <cfelseif #NombreCarpeta.size# LT 1000000>
            <cfset vTamArch = val(#NombreCarpeta.size#) / 1024>
        </cfif>
    
        <cfif #aTamArch# GT 0>
            <cfif #NombreCarpeta.size# GT 1000000>
                <span class="Sans10Ne"><cfoutput>#LSNumberFormat(vTamArch,'99.9')#</cfoutput></span> <span class="Sans10Vi"> Mb </span>
            <cfelseif #NombreCarpeta.size# LT 1000000>
                <span class="Sans10Ne"><cfoutput>#LSNumberFormat(vTamArch,'9,999')#</cfoutput></span> <span class="Sans10Vi"> Kb </span>
            </cfif>
        </cfif>
    </cffunction>
    
    <cffunction name="fAntiguedad" description="Devuleve la antigüedad académica">
    </cffunction>
    <cffunction name="fAntiguedadCn" description="Devuleve la antigüedad en categoría y nivel">
    </cffunction>
    
	<!--- CHECAR CONTRASEÑA Y SESION ACTIVA --->
    <cfif IsDefined('Session.sLoginSistema') AND IsDefined('Session.sTipoSistema')>
		<cfif #Session.sTipoSistema# IS NOT 'stctic' AND #Session.sTipoSistema# IS NOT 'sic' AND #Session.sTipoSistema# IS NOT 'samaa_pleno'>
			<cflocation url="#vCarpetaRaizLogica#/valida/invalido.cfm?vError=Restringe" addtoken="no">
		</cfif>
	<cfelse>        
		<cflocation url="#vCarpetaRaizLogica#/valida/invalido.cfm?vError=Restringe" addtoken="no">
    </cfif>
</cfif>
<!--- MANEJO DE ERRORES DE SISTEMA --->
<cferror type="exception" template="../includes/error.cfm" mailto="samaa@cic.unam.mx" exception="any">
<cferror type="request" template="../includes/error.cfm" mailto="samaa@cic.unam.mx" exception="any">
