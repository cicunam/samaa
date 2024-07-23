<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/09/2022 --->
<!--- FECHA ÚLTIMA MOD.: 06/09/2022--->

<!--- AJAX PARA INDEXAR LA LISTA DE ASUNTOS DE LA CAAA/CTIC --->
<!--- NOTA: Para mayor control sería mejor indexar cada sección por separado, como la III y V --->

<!--- **************************************** --->
<!--- INDEXAR LAS SECCIONES I, III.II, III.IV, VI --->
<!--- Obtener la lista de solicitudes --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id, asu_parte
    FROM
	<cfif #vReunion# IS 'CAAA'>
		consulta_solicitudes_caaa
	<cfelse>
		consulta_solicitudes_pleno
	</cfif>
	WHERE ssn_id = #vpSsnId# <!--- Acta seleccionada --->
	AND (asu_parte = 1 OR asu_parte = 3.2 OR asu_parte = 3.4 OR asu_parte = 6) <!--- OR asu_parte = 3.1  SE QUITÓ LA SECCIÓN 3.1 (BECAS POSDOC) SE HACE DE FORMA MANUAL --->
	ORDER BY
	asu_parte, dep_orden, acd_apepat, acd_apemat, acd_nombres,sol_pos14
</cfquery>
    
<!--- Inicializar el contador de registros --->
<cfset vParte = 1>
<cfset vAsunto = 1>
<!--- Reindexar los registros que hayan en la lista --->
<cfoutput query="tbSolicitudes">
	<!--- Detectar cambio de aprte para reiniciar el contador --->
	<cfif #vParte# NEQ #asu_parte#>
		<cfset vAsunto =  1>
		<cfset vParte = #asu_parte#>
	</cfif>
	<!--- Actualizar la tabla de asuntos, asignar número de asunto --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_asunto 
        SET asu_numero = #vAsunto#
		WHERE sol_id = #sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vpSsnId#
	</cfquery>
	<!--- Incrementar el contador de registros --->
	<cfset vAsunto = vAsunto + 1>
</cfoutput>

<!--- **************************************** --->
<!--- INDEXAR LA SECCIÓN III --->
<!--- Obtener la lista de solicitudes --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id, asu_parte, clase_academico
    FROM
	<cfif #vReunion# IS 'CAAA'>
		consulta_solicitudes_caaa
	<cfelse>
		consulta_solicitudes_pleno
	</cfif>
    WHERE ssn_id = #vpSsnId# <!--- Acta seleccionada --->
	AND asu_parte = 3 <!--- Solo incluir Sección III --->
	ORDER BY
	clase_academico, dep_orden, acd_apepat, acd_apemat, acd_nombres, sol_pos14 
</cfquery>
<!--- Inicializar el contador de registros --->
<cfif #tbSolicitudes.Recordcount# GT 0>
    <cfset vAsunto = 1>
    <cfset vCambio = 0>
    <!--- Reindexar los registros que hayan en la lista --->
    <cfoutput query="tbSolicitudes">
        <!--- Actualizar la tabla de asuntos, asignar número de asunto --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos_asunto SET asu_numero = #vAsunto#
            WHERE sol_id = #sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vpSsnId#
        </cfquery>
        <!--- Incrementar el contador de registros --->
        <cfset vAsunto = vAsunto + 1>
        <!--- Detectar cambio de INV a TEC --->
        <cfif #clase_academico# IS 'TEC' AND vCambio IS 0>
            <cfset vAsunto = 1>
            <cfset vCambio = 1>
        </cfif>
    </cfoutput>
</cfif>

<!--- ******************** --->
<!--- INDEXAR LA SECCIÓN V --->
<!--- Los asuntos de la SECCIÓN V no pasan por la CAAA --->        
<cfif #vReunion# IS 'CTIC'>
    <!--- Obtener la lista de solicitudes --->
    <cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
        SELECT sol_id, asu_parte
        FROM consulta_solicitudes_pleno
        WHERE ssn_id = #vpSsnId# <!--- Acta seleccionada --->
        AND asu_parte = 5 <!--- Solo incluir Sección V --->
        ORDER BY dep_orden,	mov_clave, acd_apepat, acd_apemat, acd_nombres, sol_pos14
    </cfquery>
    <!--- Inicializar el contador de registros --->
    <cfset vAsunto = 1>
    <!--- Reindexar los registros que hayan en la lista --->
    <cfoutput query="tbSolicitudes">
        <!--- Actualizar la tabla de asuntos, asignar número de asunto --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos_asunto 
            SET asu_numero = #vAsunto#
            WHERE sol_id = #sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vpSsnId#
        </cfquery>
        <!--- Incrementar el contador de registros --->
        <cfset vAsunto = vAsunto + 1>
    </cfoutput>
</cfif>