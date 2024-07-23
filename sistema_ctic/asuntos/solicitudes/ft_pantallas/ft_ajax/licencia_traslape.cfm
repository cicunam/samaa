<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 09/10/2009 --->
<!--- Obtener el número de traslapes de licencia y comisiones dado un rango de fechas --->

<!--- Ajustar las fechas para que las entienda MySQL --->
<cfset vFechaInicio = LsdateFormat(vFechaInicio,'dd/mm/yyyy')>
<cfset vFechaFinal = LsdateFormat(vFechaFinal,'dd/mm/yyyy')>

<!--- Buscar movimientos que se traslapen --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT count(*) AS numero_traslapes 
	FROM (movimientos 
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad# 
	AND (mov_clave = 40 OR mov_clave = 41) <!--- Licencias y comisiones --->
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'  <!--- Asuntos aprobados --->
	AND (mov_cancelado = 0 OR mov_cancelado IS NULL)<!--- VERIFICA QUE LOS MOVIMIENTOS NO ESTEN CANCELADOS, SE AGREGÓ EL 18/10/2011 ---->
	<!--- Buscar traslape de fechas --->
	AND (
			('#vFechaInicio#' BETWEEN mov_fecha_inicio AND mov_fecha_final) OR ('#vFechaFinal#' BETWEEN mov_fecha_inicio AND mov_fecha_final)
		OR
			(mov_fecha_inicio BETWEEN '#vFechaInicio#' AND '#vFechaFinal#') AND (mov_fecha_final BETWEEN '#vFechaInicio#' AND '#vFechaFinal#')
		)
</cfquery>

<!--- Buscar solicitudes que se traslapen --->
<!--- NOTA: Es importante que en la tabla de movimientos_solicitud solo estén las solicitudes del periodo sesión actual --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT count(*) AS numero_traslapes
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vIdAcad# 
	AND (mov_clave = 40 OR mov_clave = 41) <!--- Licencias y comisiones --->
	AND (
			('#vFechaInicio#' BETWEEN sol_pos14 AND sol_pos15) OR ('#vFechaFinal#' BETWEEN sol_pos14 AND sol_pos15)
		OR
			(sol_pos14 BETWEEN '#vFechaInicio#' AND '#vFechaFinal#') AND (sol_pos15 BETWEEN '#vFechaInicio#' AND '#vFechaFinal#')
		)
	AND sol_id <> #vIdSol# 	<!--- No incluir la solicitud actual --->
    AND ISNULL(sol_retirada, 0) <> 1 <!--- No incluir las solicitudes retiradas --->
</cfquery>

<input name="traslape_licencia" id="traslape_licencia" type="hidden" value="<cfoutput>#val(tbMovimientos.numero_traslapes) + val(tbSolicitudes.numero_traslapes)#</cfoutput>">

