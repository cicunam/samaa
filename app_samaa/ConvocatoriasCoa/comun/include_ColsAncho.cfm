<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 04/03/2022 --->
<!--- INCLUD PARA DETERMINAR EL ANCHO DE COLUMNAS EN TABLAS DE LISTA DE REGISTROS Y FILTROS  --->


<cfif #Session.sTipoSistema# IS 'sic'>
    <cfset vColSpan = 5>
    <cfset vColRow = 3>
    <cfset vColEntidad = 0>
    <cfset vColPlaza = 35>
    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2>
        <cfset vColActa = 10>
        <cfset vColPublica = 15>
        <cfset vColSolicita = 37>
    <cfelseif #vAppConCoaMenu# EQ 3>
        <cfset vColActa = 15>
        <cfset vColPublica = 20>
        <cfset vColSolicita = 27>
    </cfif>
<cfelseif #Session.sTipoSistema# IS 'stctic'>
    <cfset vColSpan = 6>
    <cfset vColRow = 3>
    <cfset vColEntidad = 7>
    <cfset vColPlaza = 37>
    <cfif #vAppConCoaMenu# EQ 1 OR #vAppConCoaMenu# EQ 2>
        <cfset vColActa = 8>
        <cfset vColPublica = 15>
        <cfset vColSolicita = 30>
    <cfelseif #vAppConCoaMenu# GTE 3>
        <cfset vColActa = 10>
        <cfset vColPublica = 16>
        <cfset vColSolicita = 29>
    </cfif>
</cfif>