<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 12/01/2023 --->
<!--- MÓDULO GENERAL PARA ENVIAR ARCHIVOS AL SERVIDOR --->


<cfparam name="vModuloConsulta" default="">
<cfparam name="vAcdId" default="">
<cfparam name="vNumRegistro" default="">
<cfparam name="vSsnIdArchivo" default="">
<cfparam name="vDepClave" default="">

<!---  INCLUDE CON LAS CARPETAS Y RUTAS WEB PARA UBICAR Y ACCESAR A LOS DIFERENTES ARCHIVOS PDF'S --->
<cfinclude template="#vCarpetaINCLUDE#/include_ruta_archivos.cfm">

<cfif #vModuloConsulta# EQ 'SOL'>
	<!---  CARGAR ARCHIVO A UNA SOLICITUD --->
	<cfset vNombreArchivoNuevo = '#vAcdId#_#vNumRegistro#.pdf'>
	<cfif #vSolStatus# GTE 3>
        <cfset vCarpetaModulo = #vCarpetaEntidad# & #MID(vDepClave,1,4)# & '\'>
    <cfelse>
        <cfset  vCarpetaModulo = #vCarpetaCAAA# & '\'>
    </cfif>
<cfelseif #vModuloConsulta# EQ 'MOV'>
	<!---  CARGAR ARCHIVO A UN MOVIMIENTO --->
	<cfset vNombreArchivoNuevo = '#vAcdId#_#vNumRegistro#_#vSsnIdArchivo#.pdf'>
	<cfset vCarpetaModulo = #vCarpetaAcademicos#><!--- & #vAcdId# & '\'  --->
<cfelseif #vModuloConsulta# EQ 'MCTIC'>
	<!---  CARGAR ARCHIVO CARGO ACADÉMICO-ADMINISTRATIVO --->
	<cfset vNombreArchivoNuevo = '#vAcdId#_#vNumRegistro#.pdf'>
    <cfset vCarpetaModulo = #vCarpetaCargosAA#>
<cfelseif #vModuloConsulta# EQ 'ORDENDIA'>
	<!---  CARGAR ARCHIVO PARA EL ORDEN DEL DÍA --->
	<cfset vNombreArchivoNuevo = 'ORDENDIA_#vSsnIdArchivo#.pdf'>
    <cfset vCarpetaModulo = #vCarpetaSesionHistoria#>
<cfelseif #vModuloConsulta# EQ 'ESTDGAPA'>
	<!---  CARGAR ARCHIVO ESTÍMULOS DGAPA --->
	<cfset vNombreArchivoNuevo = 'ESTIMULOS_DGAPA_#vSsnIdArchivo#.pdf'>
    <cfset vCarpetaModulo = #vCarpetaSesionOtros#>
<cfelseif #vModuloConsulta# EQ 'INFORME'>
	<!---  CARGAR ARCHIVO INFORMES ANUALES --->
	<cfset vNombreArchivoNuevo = '#vAcdId#_#vNumRegistro#_#vSsnIdArchivo#.pdf'>
	<cfset  vCarpetaModulo = #vCarpetaInforme#>
<cfelseif #vModuloConsulta# EQ 'CEUPEID'>
	<cfset vNombreArchivoNuevo = '#vAcadId#_#ssn_id#.pdf'>
	<cfset  vCarpetaModulo = #vCarpetaCEUPEID# & '\'>
<cfelseif #vModuloConsulta# EQ 'OFICIOSG'>
	<cfset vNombreArchivoNuevo = '#vSsnIdArchivo#_oficiosg.pdf'>
	<cfset  vCarpetaModulo = #vCarpetaOficios#>
<cfelseif #vModuloConsulta# EQ 'GRADOACAD'>
	<!---  CARGAR ARCHIVO GRADOS ACADEMICOS (12/01/2023) --->    
	<cfset vNombreArchivoNuevo = '#vAcdId#_#vSolStatus#.pdf'>
	<cfset  vCarpetaModulo = #vCarpetaGradoAcad#>
</cfif>
        
<cfif #CGI.SERVER_PORT# EQ '31221'>
    <cfoutput>#vNombreArchivoNuevo# </cfoutput>
</cfif>    
        
<cffile action="UPLOAD" filefield="selecciona_pdf" destination="#vCarpetaModulo#" nameconflict="overwrite" >

<cfset vMimeArchivo = #cffile.contentType# & "/" & #cffile.clientFileExt#>


<cfif #vMimeArchivo# EQ "application/pdf">
    <cfset vNomArchivoAnt = #cffile.attemptedServerFile#>

    <cffile action="RENAME" source="#vCarpetaModulo##cffile.attemptedServerFile#" destination="#vCarpetaModulo##vNombreArchivoNuevo#" nameconflict="overwrite" >

    <cfquery datasource="#vOrigenDatosSAMAA#">
        INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip, modulo_carga)
        VALUES (#vUsuarioId# ,'E','#vNombreArchivoNuevo#', '#vNomArchivoAnt#', GETDATE(), '#CGI.REMOTE_ADDR#', '#vModuloConsulta#')
    </cfquery>

    <cfset vStatusArchivo = "EL ARCHIVO SE CARGÓ AL SISTEMA CORRECTAMENTE">
<cfelse>
    <cffile action="delete" file="#vCarpetaModulo##cffile.attemptedServerFile#">

    <cfquery datasource="#vOrigenDatosSAMAA#">
        INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip, modulo_carga)
        VALUES (#vUsuarioId# ,'B','#cffile.attemptedServerFile#', 'NO ES UN ARCHIVO DE ADOBE ACROBAT', GETDATE(), '#CGI.REMOTE_ADDR#', '#vModuloConsulta#')
    </cfquery>
    <cfset vStatusArchivo = "EL ARCHIVO NO ES DEL FORMATO REQUERIDO (ADOBE ACROBAR), VUELVA A CARGARLO">
</cfif>

<cfif #vModuloConsulta# NEQ 'CEUPEID'>
	<cfoutput>#vStatusArchivo#</cfoutput>
</cfif>
