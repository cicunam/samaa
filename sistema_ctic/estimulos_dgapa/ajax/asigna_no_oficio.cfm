<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/10/2023 --->
<!--- FECHA ÚLTIMA MOD.: 28/11/2023 --->
<!--- AJAX PARA ASIGNAR EL NÚMERO DE OFICIO A LOS DICTÁMENES DE LOS ESTÍMULOS DE LA DGAPA --->

<cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
	SELECT *
    FROM estimulos_dgapa AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave    
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave    
   	WHERE ssn_id = #vpSsnId#
    ORDER BY C1.dep_orden, C3.orden_samaa, T1.ingreso DESC <!--- 28/11/2023 --->
	<!--- ORDER BY C1.dep_orden, T2.acd_apepat, T2.acd_apemat --->
</cfquery>

<cfquery name="tbRegistros" dbtype="query">
    SELECT estimulo_id FROM tbEstimulosDgapa
    WHERE orden_samaa = 1
    AND recurso_revision IS NULL
</cfquery>

<cfif #tbRegistros.RecordCount# GT 0>
    <cfoutput query="tbRegistros">
        <cfif LEN(#vpAsignaNoOficio#) EQ 1>
            <cfset vNumeroOficioAcdEst = '000#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 2>
            <cfset vNumeroOficioAcdEst = '00#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 3>
            <cfset vNumeroOficioAcdEst = '0#vpAsignaNoOficio#'>    
        </cfif>

        <cfset vOficioNo = 'P.#vNumeroOficioAcdEst#/' & #LsDateFormat(now(),'YYYY')#>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE estimulos_dgapa SET
            estimulo_oficio = '#vOficioNo#'
            WHERE estimulo_id = #estimulo_id#
        </cfquery>

        <cfset #vpAsignaNoOficio# = #vpAsignaNoOficio# + 1>
    </cfoutput>
</cfif>

<!--- ********** RECURSOS DE REVISIÓN ********** 08/02/2023---->
<cfquery name="tbRegistrosRR" dbtype="query">
    SELECT estimulo_id FROM tbEstimulosDgapa
    WHERE recurso_revision = 1
    AND orden_samaa = 1
</cfquery>

<cfif #tbRegistrosRR.RecordCount# GT 0>
    <cfoutput query="tbRegistrosRR">
        <cfif LEN(#vpAsignaNoOficio#) EQ 1>
            <cfset vNumeroOficioAcdEst = '000#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 2>
            <cfset vNumeroOficioAcdEst = '00#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 3>
            <cfset vNumeroOficioAcdEst = '0#vpAsignaNoOficio#'>    
        </cfif>

        <cfset vOficioNo = 'P.#vNumeroOficioAcdEst#/' & #LsDateFormat(now(),'YYYY')#>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE estimulos_dgapa SET
            estimulo_oficio = '#vOficioNo#'
            WHERE estimulo_id = #estimulo_id#
        </cfquery>

        <cfset #vpAsignaNoOficio# = #vpAsignaNoOficio# + 1>
    </cfoutput>
</cfif>

<!--- ********** EQUIVALANCIA ********** ---->
<cfquery name="tbRegistrosEQ" dbtype="query">
    SELECT estimulo_id FROM tbEstimulosDgapa
    WHERE ingreso IS NULL
    AND orden_samaa = 2
</cfquery>

<cfif #tbRegistrosEQ.RecordCount# GT 0>
    <cfoutput query="tbRegistrosEQ">
        <cfif LEN(#vpAsignaNoOficio#) EQ 1>
            <cfset vNumeroOficioAcdEst = '000#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 2>
            <cfset vNumeroOficioAcdEst = '00#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 3>
            <cfset vNumeroOficioAcdEst = '0#vpAsignaNoOficio#'>    
        </cfif>

        <cfset vOficioNo = 'P.#vNumeroOficioAcdEst#/' & #LsDateFormat(now(),'YYYY')#>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE estimulos_dgapa SET
            estimulo_oficio = '#vOficioNo#'
            WHERE estimulo_id = #estimulo_id#
        </cfquery>

        <cfset #vpAsignaNoOficio# = #vpAsignaNoOficio# + 1>
    </cfoutput>
</cfif>
            

<!--- ********** PEI ********** ---->
<cfquery name="tbRegistrosPEI" dbtype="query">
    SELECT estimulo_id FROM tbEstimulosDgapa
    WHERE ingreso IS NULL
    AND orden_samaa = 3
</cfquery>
            
<cfif #tbRegistrosPEI.RecordCount# GT 0>
    <cfoutput query="tbRegistrosPEI">
        <cfif LEN(#vpAsignaNoOficio#) EQ 1>
            <cfset vNumeroOficioAcdEst = '000#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 2>
            <cfset vNumeroOficioAcdEst = '00#vpAsignaNoOficio#'>
        <cfelseif LEN(#vpAsignaNoOficio#) EQ 3>
            <cfset vNumeroOficioAcdEst = '0#vpAsignaNoOficio#'>    
        </cfif>

        <cfset vOficioNo = 'P.#vNumeroOficioAcdEst#/' & #LsDateFormat(now(),'YYYY')#>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE estimulos_dgapa SET
            estimulo_oficio = '#vOficioNo#'
            WHERE estimulo_id = #estimulo_id#
        </cfquery>

        <cfset #vpAsignaNoOficio# = #vpAsignaNoOficio# + 1>
    </cfoutput>
</cfif>




