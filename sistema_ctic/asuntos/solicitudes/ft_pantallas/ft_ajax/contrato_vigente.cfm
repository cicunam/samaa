<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 26/05/2015 --->
<!--- FECHA ÚLTIMA MOD.: 26/09/2023 --->
<!--- Determinar si el académico tiene un contrato vigente --->

<!--- Ajustar las fechas para que las entienda MySQL --->
<cfset vFechaInicio = LsdateFormat(vFechaInicio,'dd/mm/yyyy')>

<!--- Buscar contratos vigentes en la tabla de MOVIMIENTOS--->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT COUNT(*) AS NumeroContratos
	FROM ((movimientos 
	LEFT JOIN academicos ON movimientos.acd_id = academicos.acd_id)
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE academicos.acd_id = #vIdAcad# 
	AND 
    (
        academicos.con_clave = 1 
        OR (
            academicos.con_clave = 2
            AND (mov_clave = 5  OR mov_clave = 9 OR mov_clave = 10 OR mov_clave = 17 OR mov_clave = 19 OR mov_clave = 20 OR mov_clave = 25 OR mov_clave = 26 OR mov_clave = 28 OR mov_clave = 35 OR mov_clave = 36 OR mov_clave = 37) <!---  SE AGREGA FT 9 Y 10 SON PROMOCIONES; SE AGREGA FT 35 26/09/203 --->
            AND '#vFechaInicio#' BETWEEN mov_fecha_inicio AND mov_fecha_final
            <!--- 
                NOTA: Antes se validaba que la comisión estubiera dentro de un contrato:
                AND ('#vFechaInicio#' BETWEEN mov_fecha_inicio AND mov_fecha_final) AND ('#vFechaFinal#' BETWEEN mov_fecha_inicio AND mov_fecha_final))
            --->	
            <!--- NOTA: Ahora simplemente se valida que haya un contrato vigente cuando inicie la comisión --->
            )
        OR (
        	academicos.con_clave = 3
			AND mov_clave = 6
            AND '#vFechaInicio#' BETWEEN mov_fecha_inicio AND mov_fecha_final
            )
        OR ( <!--- SE AGREGÓ PARA EL CASO DE LOS BECARIOS POSDOCTORALES 27/0/2017 --->
            academicos.con_clave = 6 
            AND (mov_clave = 38 OR mov_clave = 39)
            AND '#vFechaInicio#' BETWEEN mov_fecha_inicio AND mov_fecha_final
            )
	)
	AND asu_reunion = 'CTIC' <!--- Decición del CTIC --->
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
</cfquery>

<!--- EN CASO DE NO HABER CONTRATO VIGENTE EN MOVIMIENTOS BUSCA EN SOLICITUDES QUE YA TENGAN UNA DECISIÓN DEL PLENO --->
<!--- SE INSERTÓ CÓDIGO EL 22/08/2013 POR: ARAM PICHARDO --->
<cfif #tbMovimientos.NumeroContratos# EQ 0>
    <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
        SELECT COUNT(*) AS NumeroContratos
        FROM ((movimientos_solicitud AS T1
        LEFT JOIN academicos AS T2 ON T1.sol_pos2 = T2.acd_id)
        LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id)
        LEFT JOIN catalogo_decision AS C1 ON T3.dec_clave = C1.dec_clave
        WHERE T2.acd_id = #vIdAcad# 
        AND 
		(
			T2.con_clave = 1 
            OR (
                T2.con_clave = 2
                AND (mov_clave = 5 OR mov_clave = 17 OR mov_clave = 20 OR mov_clave = 25 OR mov_clave = 26 OR mov_clave = 28 OR mov_clave = 36 OR mov_clave = 9 OR mov_clave = 10 OR mov_clave = 37)
                AND '#vFechaInicio#' BETWEEN sol_pos14 AND sol_pos15
                <!--- NOTA: Ahora simplemente se valida que haya un contrato vigente cuando inicie la comisión --->
                )
            OR ( 
				T2.con_clave = 3
				AND mov_clave = 6
                AND '#vFechaInicio#' BETWEEN sol_pos14 AND sol_pos15
				)
            OR ( <!--- SE AGREGÓ PARA EL CASO DE LOS BECARIOS POSDOCTORALES 27/0/2017 --->
                T2.con_clave = 6 AND mov_clave = 39
                AND '#vFechaInicio#' BETWEEN sol_pos14 AND sol_pos15
                ) 
        )
        AND asu_reunion = 'CTIC' <!--- Decición del CTIC --->
        AND dec_super = 'AP' <!--- Asuntos aprobados --->
        AND sol_status = 1 <!--- Solicitud en sesión del pleno --->
    </cfquery>
</cfif>


<cfif #Session.sTipoSistema# EQ 'stctic' AND #tbMovimientos.NumeroContratos# EQ 0>
	<input name="contrato_vigente" id="contrato_vigente" type="hidden" value="1">	
<cfelse>
<!--- Regresar el valor en un control oculto --->
	<input name="contrato_vigente" id="contrato_vigente" type="hidden" value="<cfoutput>#tbMovimientos.NumeroContratos#</cfoutput>">
</cfif>
<!---
<input name="contrato_vigente" id="contrato_vigente" type="hidden" value="<cfoutput>#tbMovimientos.NumeroContratos#</cfoutput>">
--->

