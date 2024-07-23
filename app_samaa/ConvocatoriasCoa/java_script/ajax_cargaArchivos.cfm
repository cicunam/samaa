<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/01/2022 --->
<!--- FECHA ÚLTIMA MOD.: 12/01/2022 --->
<!--- INCLUDE PARA CARGAR ARCHIVOS --->

<cfset vCargaArchivos = ''>
<cfset vNoCargaArchivos = ''>
<cfoutput>#AcdId#</cfoutput>
<cfif IsDefined('archivo_oficioctic') AND archivo_oficioctic NEQ ''>
    <cffile action="Upload" fileField="archivo_oficioctic" destination="#vCarpetaCoaOficios#" nameConflict="Overwrite" accept="application/pdf"><!---  accept="application/pdf" --->
        
    <cfset vMimeArchivoRs1 = #cffile.contentType# & "/" & #cffile.clientFileExt#>
    <cfif #vMimeArchivoRs1# EQ "application/pdf">
        <cfset vSource = "#vCarpetaCoaOficios#\#cffile.ClientFileName#.#cffile.ClientFileExt#">
        <cfset vDestination = "#vCarpetaCoaOficios#\#AcdId#_#SamaaSolId#.pdf">
        <cffile action="rename"  nameconflict="overwrite" source="#vSource#" destination="#vDestination#">
        <cfset vCargaArchivos = 'El archivo del oficio se cargó correctamante<br/>'>
    <cfelse>
        <cfset vNoCargaArchivos = '#vNoCargaArchivos# ARCHIVO DEL PUNTO 1<br/>'>
    </cfif>
    <!--- MÓDULO COMÚN PARA LA GENERACIÓN DE BITACORAS
    <cfmodule template="../comun/module_bitacora.cfm" OrigenDatos="#vOrigenDatosSolicitudes#" SolicitaId="#Session.vsSolicitudId#" TipoMov="CA" ArchivoC="#cffile.ClientFileName#.#cffile.ClientFileExt#" ArchivoR="#Session.vsSolicitudId#_rs_1.pdf">
     --->
</cfif>
        

<cfif #vCargaArchivos# EQ '' AND #vNoCargaArchivos# EQ ''>
    <span class="text-danger"><strong>Se debe seleccionar al menos un archivo para cargar al servidor.</strong></span>
<cfelse>
    <cfif #vCargaArchivos# NEQ ''>
        <strong>Los siguentes archivos se cargaron:</strong>
        <br/><br/>
        <cfoutput>#vCargaArchivos#</cfoutput>
        <br/>
    </cfif>
    <cfif #vNoCargaArchivos# NEQ ''>
        <br/><br/>
        <span class="text-danger"><strong>Los siguentes archivos NO cuentan con el formato solicitado:</strong></span>
        <br/><br/>
        <cfoutput>#vNoCargaArchivos#</cfoutput>
    </cfif>
</cfif>