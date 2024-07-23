<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009--->
<!--- FECHA ÚLTIMA MOD.: 10/12/2015--->
<!--- NOTA IMPORTANTE: ESTE ARCHIVO ES UNA COPIA DE LA PRIMER VERSIÓN --->

<!--- AJAX PARA INDEXAR LA LISTA DE ASUNTOS DE LA CAAA/CTIC --->
<!--- NOTA: Para mayor control sería mejor indexar cada sección por separado, como la III y V --->
<!--- INDEXAR LAS SECCIONES I, III.I, III.II, III.IV, VI --->
<!--- Obtener la lista de solicitudes --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE
	<cfif #vReunion# IS 'CAAA'>
		sol_status = 2 AND T2.asu_reunion = 'CAAA'
	<cfelse>
		sol_status <= 3 AND asu_reunion = 'CTIC'
	</cfif>
	AND T2.ssn_id = #vActa# <!--- Acta seleccionada --->
	AND (T2.asu_parte = 1 OR T2.asu_parte = 3.1 OR T2.asu_parte = 3.2 OR T2.asu_parte = 3.4 OR T2.asu_parte = 6)
	ORDER BY
	T2.asu_parte,
	C2.dep_orden,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>
<!--- Inicializar el contador de registros --->
<cfset vParte = 1>
<cfset vAsunto = 1>
<!--- Reindexar los registros que hayan en la lista --->
<cfloop query="tbSolicitudes">
	<!--- Detectar cambio de aprte para reiniciar el contador --->
	<cfif #vParte# NEQ #tbSolicitudes.asu_parte#>
		<cfset vAsunto =  1>
		<cfset vParte = #tbSolicitudes.asu_parte#>
	</cfif>
	<!--- Actualizar la tabla de asuntos, asignar número de asunto --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_asunto SET asu_numero = #vAsunto#
		WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vActa#
	</cfquery>
	<!--- Incrementar el contador de registros --->
	<cfset vAsunto = vAsunto + 1>
</cfloop>
<!--- INDEXAR LA SECCIÓN III --->
<!--- Obtener la lista de solicitudes --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT *, LEFT(C3.cn_siglas, 3) AS clase_academico FROM ((((movimientos_solicitud AS T1 
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON C3.cn_clave = ISNULL(T1.sol_pos8, T1.sol_pos3)
	WHERE
	<cfif #vReunion# IS 'CAAA'>
		sol_status = 2 AND T2.asu_reunion = 'CAAA'
	<cfelse>
		sol_status <= 1 AND T2.asu_reunion = 'CTIC'
	</cfif>
	AND T2.ssn_id = #vActa# <!--- Acta seleccionada --->
	AND T2.asu_parte = 3 <!--- Solo incluir Sección III --->
	ORDER BY
	LEFT(C3.cn_siglas, 3),
	C2.dep_orden,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>
<!--- Inicializar el contador de registros --->
<cfset vAsunto = 1>
<cfset vCambio = 0>
<!--- Reindexar los registros que hayan en la lista --->
<cfloop query="tbSolicitudes">
	<!--- Actualizar la tabla de asuntos, asignar número de asunto --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_asunto SET asu_numero = #vAsunto#
		WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vActa#
	</cfquery>
	<!--- Incrementar el contador de registros --->
	<cfset vAsunto = vAsunto + 1>
	<!--- Detectar cambio de INV a TEC --->
	<cfif #tbSolicitudes.clase_academico# IS 'TEC' AND vCambio IS 0>
		<cfset vAsunto = 1>
		<cfset vCambio = 1>
	</cfif>
</cfloop>
<!--- INDEXAR LA SECCIÓN V --->
<!--- Obtener la lista de solicitudes --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave
	WHERE
	<cfif #vReunion# IS 'CAAA'>
		sol_status = 2 AND T2.asu_reunion = 'CAAA'
	<cfelse>
		sol_status <= 1 AND T2.asu_reunion = 'CTIC'
	</cfif>
	AND T2.ssn_id = #vActa# <!--- Acta seleccionada --->
	AND T2.asu_parte = 5 <!--- Solo incluir Sección V --->
	ORDER BY
	C2.dep_orden,
	T1.mov_clave,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>
<!--- Inicializar el contador de registros --->
<cfset vAsunto = 1>
<!--- Reindexar los registros que hayan en la lista --->
<cfloop query="tbSolicitudes">
	<!--- Actualizar la tabla de asuntos, asignar número de asunto --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_asunto SET asu_numero = #vAsunto#
		WHERE sol_id = #tbSolicitudes.sol_id# AND asu_reunion = '#vReunion#' AND ssn_id = #vActa#
	</cfquery>
	<!--- Incrementar el contador de registros --->
	<cfset vAsunto = vAsunto + 1>
</cfloop>
