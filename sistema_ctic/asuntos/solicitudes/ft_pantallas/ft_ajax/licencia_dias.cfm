<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 09/10/2009 --->
<!--- Obtener el número de días de licencia que ha ocupado el académico --->

<cfparam name="vIdAcad" default="0">
<cfparam name="vAnio" default="#Year(Now())#">

<!--- Contar días en movimientos --->
<cfquery name="tbMovimientosLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) + 1) AS dias_ocupados 
	FROM (movimientos 
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad# 
	AND mov_clave = 41 <!--- Licencias con goce de sueldo --->
	AND asu_reunion = 'CTIC'
	AND YEAR(mov_fecha_inicio) = #vAnio# <!--- En el mismo año --->
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
	AND (mov_cancelado IS NULL OR mov_cancelado = 0) <!--- Omitir movimientos cancelados --->
</cfquery>

<!--- Contar días en solicitudes --->
<cfquery name="tbAsuntosLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(sol_pos13_d) AS dias_ocupados 
	FROM movimientos_solicitud
	WHERE sol_pos2 = #vIdAcad# 
	AND mov_clave = 41 <!--- Licencias con goce de sueldo --->
	AND YEAR(sol_pos14) = #vAnio# <!--- En el mismo año --->
	AND sol_id <> #vIdSol# <!--- No incluir la solicitud actual --->
    AND ISNULL(sol_retirada, 0) <> 1 <!--- No incluir las solicitudes retiradas --->    
</cfquery>

<input name="pos13_d_temp" id="pos13_d_temp" type="text" class="datos" size="2" maxlength="2" value="<cfoutput>#val(tbMovimientosLicencias.dias_ocupados) + val(tbAsuntosLicencias.dias_ocupados)#</cfoutput>" disabled>
