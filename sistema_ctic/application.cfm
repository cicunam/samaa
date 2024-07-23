<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 03/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 13/06/2023 --->
<!--- Archivo APPLICATION.CFM --->
<!--- CARACTERÍSTICAS DE LA APLICACIÓN --->

<cfapplication  
name="SAMAA"
applicationTimeout = "#createTimeSpan(0,4,0,0)#"						
sessionManagement = "yes"
sessionTimeout = "#createTimeSpan(0,4,0,0)#"
setclientcookies="yes"
>

<!--- CHECAR CONTRASEÑA Y SESION ACTIVA --->
<cfif (NOT IsDefined("Application.vCarpetaRaiz")) OR 
		(NOT IsDefined("Session.sLoginSistema") OR #Session.sLoginSistema# IS '') OR
		(NOT isDefined("Session.sUsuarioNivel")) OR
		(NOT IsDefined("Session.sTipoSistema") OR (#Session.sTipoSistema# IS NOT 'stctic' AND #Session.sTipoSistema# IS NOT 'sic'))>
	
    <cfif CGI.SERVER_PORT IS "31221" AND Find("pepe", CGI.SCRIPT_NAME) NEQ 0>
        <cfset vUrl = "/samaa/pepe">
    <cfelseif CGI.SERVER_PORT IS "31221" AND Find("aram", CGI.SCRIPT_NAME) NEQ 0>
        <cfset vUrl = "/samaa/aram">
    <cfelseif CGI.SERVER_PORT IS "31220">
        <cfset vUrl = "/samaa">
    </cfif>	
	<cflocation url="#vUrl#/valida/invalido.cfm?vError=Restringe">
</cfif>

<!--- Origenes de datos --->
<cfset vOrigenDatosACCESO = 'acceso_sistemas'><!--- Después se utilizará el origen "acceso_sistemas" --->
<cfset vOrigenDatosSAMAA = 'samaa'>
<cfset vOrigenDatosSNI = 'sni_miembros'>
<cfset vOrigenDatosCURRICULUM = 'curriculum_sic'>
<cfset vOrigenDatosCATALOGOS = 'catalogos'>
<cfset vOrigenDatosCISIC = 'cisic'>
<!--- Origen de MSSQL (BECARIOS POSDOCTORALES) --->        
<cfset vOrigenDatosPOSDOC = 'becas_posdoc'>
<!--- Origen de MSSQL (PLANTILLA) --->
<cfset vOrigenDatosPLANTILLA = 'sic_plantilla'>
<!--- Origen de MSSQL (PLAZAS NUEVA CREACIÓN) --->
<cfset vOrigenDatosPLAZASN = 'plazas'>
<!--- Origen de MSSQL (SOLICITUDES A CONVOCATORIAS A COA 07/12/2021) --->
<cfset vOrigenDatosSOLCOA = 'SolicitudesRegistro'>

<!--- URLs --->
<cfif #CGI.SERVER_PORT# EQ '31221'>
	<cfset vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa/aram'>
	<cfset vCarpetaRaizWebSistema = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa/aram/sistema_ctic'>
	<cfset vCarpetaRaizLogica = '/samaa/aram'>
	<cfset vCarpetaRaizLogicaSistema = '/samaa/aram/sistema_ctic'>
	<cfset vLigaInformacionAcad = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/consultas/aram/academicos/valida_academico.cfm'>
	<cfset vLigaConsultaSolCoa = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/sistema_solicitudes_coa/'>        
	<cfif isDefined('Session.sUsuarioNivel') AND #Session.sUsuarioNivel# EQ 0>
		<cfset vTipoInput = 'text'>
	<cfelse>                
		<cfset vTipoInput = 'hidden'>
	</cfif>
<cfelse>
	<cfset vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa'>
	<cfset vCarpetaRaizWebSistema = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa/sistema_ctic'>            
	<cfset vCarpetaRaizLogica = '/samaa'>
	<cfset vCarpetaRaizLogicaSistema = '/samaa/sistema_ctic'>
	<cfset vLigaInformacionAcad = 'https://keroseno.cic.unam.mx/consultas/academicos/valida_academico.cfm'>    
	<cfset vLigaConsultaSolCoa = 'https://solicitudescoa.cic.unam.mx/'>                
	<cfset vTipoInput = 'hidden'>
</cfif>

<!--- Recursos compartidos --->
<cfset vCarpetaLIB = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/comun_cic/jquery'>

<!--- RECURSOS LOCALES --->
<cfset vCarpetaIMG = '#vCarpetaRaizLogica#/images'>
<cfset vCarpetaICONO = 'http://www.cic-ctic.unam.mx:31220/images/iconos'>
<cfset vCarpetaCSS = '#vCarpetaRaiz#/css'>
<cfset vCarpetaCSSGlobal = 'http://www.cic-ctic.unam.mx:31220/comun_cic/css'>
<cfset vCarpetaVAL = '#vCarpetaRaizLogica#/valida'>
<cfset vCarpetaINCLUDE = '#vCarpetaRaizLogica#/includes'>
<cfif Find("sistema_ctic", CGI.SCRIPT_NAME) NEQ 0>
	<cfset vCarpetaCOMUN = '#vCarpetaRaizLogica#/sistema_ctic/comun'>
<cfelseif Find("app_samaa", CGI.SCRIPT_NAME) NEQ 0>
	<cfset vCarpetaCOMUN = '#vCarpetaRaizLogica#/app_samaa/comun'>
</cfif>

<cfset vAjaxListaAcademicos = '#vCarpetaRaizLogicaSistema#/comun/seleccion_academico.cfm'> <!--- Permite dar una ruta general del AJAX para listar búsqueda de académicos en todos los módulos que se requiera--->

<!--- RECURSOS GLOBALES --->
<cfset vHttpWebGlobal = 'http://www.cic-ctic.unam.mx:' & #CGI.SERVER_PORT# & '/comun_cic'>

<!--- CARPETA VIRTUAL PARE PODER ACCESAR A LOS ARCHIVOS --->

<cfset vWebCAAA = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_pleno/asuntos/'>
<cfset vWebEntidad = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_entidades/'>
<cfset vWebAcademicos = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_academicos/'>
<cfset vWebInformesAnuales = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_academicos_inf_anual/'>
<cfset vWebSesionHistoria = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_sesion/'>
<cfset vWebSesionOtros = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_sesion_otros/'>
<cfset vWebCargosAA = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_cargos_acad_admin/'>
<cfset vWebCEUPEID = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_comision_upeid/'>
<cfset vWebGacetasCOA = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_coa_gaceta/'>
<cfset vWebSolicitudCOA = '#vCarpetaRaizLogicaSistema#/convocatorias_coa/archivosCoaSolicitud/'>
<cfset vWebCoaOficios = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_oficios/oficios_coa/'> <!--- ALTA 15/12/2021 --->
<cfset vWebGradoAcad = '#vCarpetaRaizLogicaSistema#/archivos_samaa/archivos_academicos_gradoacad/'> <!--- ALTA 11/01/2023 --->
 
<!---        
<cfset vWebCAAA = '#vCarpetaRaizLogica#/archivos_ctic/archivos_pleno/asuntos/'>
<cfset vWebEntidad = '#vCarpetaRaizLogica#/archivos_ctic/archivos_entidades/'>
<cfset vWebAcademicos = '#vCarpetaRaizLogica#/archivos_ctic/archivos_academicos/'>
<cfset vWebSesionHistoria = '#vCarpetaRaizLogica#/archivos_ctic/archivos_sesion/'>
<cfset vWebSesionOtros = '#vCarpetaRaizLogica#/archivos_ctic/archivos_sesion_otros/'>
<cfset vWebCargosAA = '#vCarpetaRaizLogica#/archivos_ctic/archivos_cargos_acad_admin/'>
<cfset vWebCEUPEID = '#vCarpetaRaizLogica#/archivos_ctic/archivos_comision_upeid/'>
<cfset vWebGacetasCOA = '#vCarpetaRaizLogica#/archivos_ctic/archivos_coa_gaceta/'>
--->    
<!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
<cfif #CGI.SERVER_PORT# EQ '31221'>    
	<cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
<cfelse>
	<cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
</cfif>
<cfset vCarpetaCAAA = '#vCarpetaRaizArchivos#\archivos_pleno\asuntos\'>
<cfset vCarpetaEntidad = '#vCarpetaRaizArchivos#\archivos_entidades\'>
<cfset vCarpetaAcademicos = '#vCarpetaRaizArchivos#\archivos_academicos\'>
<cfset vCarpetaInformesAnuales = '#vCarpetaRaizArchivos#\archivos_academicos_inf_anual\'>
<cfset vCarpetaSesionHistoria = '#vCarpetaRaizArchivos#\archivos_sesion\'>
<cfset vCarpetaSesionOtros = '#vCarpetaRaizArchivos#\archivos_sesion_otros\'>
<cfset vCarpetaCargosAA = '#vCarpetaRaizArchivos#\archivos_cargos_acad_admin\'>
<cfset vCarpetaCEUPEID = '#vCarpetaRaizArchivos#\archivos_comision_upeid\'>
<cfset vCarpetaGacetasCOA = '#vCarpetaRaizArchivos#\archivos_coa_gaceta\'>
<cfset vCarpetaSolicitudCOA = 'E:\archivos_coa_solicitud'>
<cfset vCarpetaCoaOficios = '#vCarpetaRaizArchivos#\archivos_oficios\oficios_coa\'> <!--- ALTA 15/12/2021 --->
<cfset vCarpetaGradoAcad = '#vCarpetaRaizArchivos#\archivos_academicos_gradoacad\'> <!--- ALTA 11/01/2023 --->    

<!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
<cfset vFechaHoy = #LsDateFormat(Now(),'dd/mm/yyyy')#>
<cfset vFechaHoyUsa = #LsDateFormat(Now(),'yyyy-mm-dd')#>
<cfset vAnioActual = #LsDateFormat(Now(),'yyyy')#>

<!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
<cfset vNomArchivoFecha = #LsDateFormat(Now(),'yyyymmdd')#>

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
		// Quitar caracter de gato:
		texto = Replace(texto, "##", "", "all");
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
		return Trim(texto);
	}
</cfscript>
<cfscript>
	function NombreSinAcentos(texto)
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
		// Regresar la cadena transformada:
		return texto;
	}
</cfscript>

<cffunction name="FechaCompleta" returntype="String" description="Generar una fecha en formato largo respetando la configuración regional del servidor.">
	<cfargument name="aFecha">
	<cfif #aFecha# NEQ "">
		<cfif LsDateFormat(aFecha,"d") EQ 1>
			<cfreturn "1° de " & rereplace(LsDateFormat(aFecha,"mmmm") , '^\w', '\u\0') & " de " & LsDateFormat(aFecha,"yyyy")>
		<cfelseif LsDateFormat(aFecha,"d") GT 1>
			<cfreturn LsDateFormat(aFecha,"d") & " de" & " " & rereplace(LsDateFormat(aFecha,"mmmm") , '^\w', '\u\0') & " de " & LsDateFormat(aFecha,"yyyy")>
		</cfif>                    
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
<cffunction name="SoloNumeroOficio" description="Devuelve el número y año de un No.Oficio (completo)">
	<cfargument name="vNoOficio">
	<cftry>
		<cfset vNoOficioR = #Reverse(vNoOficio)#>
		<cfset vLC = #Find("CL", vNoOficioR)#>
		<cfif #vLC# GT 0>
			<cfreturn #Right(vNoOficio, vLC + 1)#>
		<cfelse>	
			<cfset vSlash1 = #Find("/", vNoOficioR)#>
			<cfset vSlash2 = #Find("/", vNoOficioR, vSlash1 + 1)#>
			<cfreturn #Right(vNoOficio, vSlash2 - 1)#>
		</cfif>	
		<cfcatch>
			<cfreturn '#vNoOficio#'>
		</cfcatch>
	</cftry>
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

<!--- MANEJO DE ERRORES DE SISTEMA --->
<cferror type="exception" template="#vCarpetaINCLUDE#/error.cfm" mailto="samaa@cic.unam.mx" exception="any">
<cferror type="request" template="#vCarpetaINCLUDE#/error.cfm" mailto="samaa@cic.unam.mx" exception="any">    
   
<!---
<cfif NOT IsDefined("Application.vCarpetaRaiz")>
	<!--- EN CASO DE NO TENER UNA SESIÓN ACTIVA --->
    <cfif CGI.SERVER_PORT IS "31221" AND Find("pepe", CGI.SCRIPT_NAME) NEQ 0>
        <cfset vUrl = "/pepe/">
    <cfelseif CGI.SERVER_PORT IS "31221" AND Find("aram", CGI.SCRIPT_NAME) NEQ 0>
        <cfset vUrl = "/aram/">
    <cfelseif CGI.SERVER_PORT IS "31220">
        <cfset vUrl = "/">
    </cfif>
	<script type="text/javascript">
		window.top.location("http://<cfoutput>#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa#vUrl#valida/invalido.cfm?vError=Restringe</cfoutput>");
    </script>
<cfelse>
	<!--- CHECAR CONTRASEÑA Y SESION ACTIVA --->
    <cfif (NOT IsDefined("Session.sLoginSistema") OR #Session.sLoginSistema# IS '') OR NOT IsDefined("Session.sTipoSistema") OR (IsDefined("Session.sTipoSistema") AND (#Session.sTipoSistema# IS NOT 'stctic' AND #Session.sTipoSistema# IS NOT 'sic'))>
		<cfif CGI.SERVER_PORT IS "31221" AND Find("pepe", CGI.SCRIPT_NAME) NEQ 0>
			<!--- <cflocation url="/samaa/pepe/valida/invalido.cfm?vError=Restringe" addtoken="no"> --->
        	<cfset vUrl = "/pepe/">
		<cfelseif CGI.SERVER_PORT IS "31221" AND Find("aram", CGI.SCRIPT_NAME) NEQ 0>
			<!--- <cflocation url="/samaa/aram/valida/invalido.cfm?vError=Restringe" addtoken="no"> --->
        	<cfset vUrl = "/aram/">
		<cfelseif CGI.SERVER_PORT IS "31220">
			<!--- <cflocation url="/samaa/valida/invalido.cfm?vError=Restringe" addtoken="no"> --->
        	<cfset vUrl = "/">
		</cfif>
		<script type="text/javascript">
			window.top.location("http://<cfoutput>#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa#vUrl#valida/invalido.cfm?vError=Restringe</cfoutput>");
    	</script>			
    <cfelse>
	<!--- *********** --->	
    </cfif>

</cfif>
--->