<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 10/03/2010 --->
<!--- FECHA ULTIMAMOD.: 28/11/2023 --->
<!--- Selecciona los registros con la categoría y nivel --->

<cfset vAnios = 0>
    
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (movimientos 
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
    WHERE acd_id = #vIdAcad#
	<cfif #vFt# EQ 9 OR #vFt# EQ 10  OR #vFt# EQ 19>
        AND mov_cn_clave = '#vCcnActual#'
		<!--- AND (mov_cn_clave = '#vCcnActual#' OR (mov_clave = 63 AND mov_cn_clave IS NULL)) --->
    </cfif>
	<!--- AND (mov_clave = 5 OR mov_clave = 6 OR mov_clave = 9 OR mov_clave = 10 OR mov_clave = 17 OR mov_clave = 19 OR mov_clave = 25 <cfif #vFt# EQ 9 OR #vFt# EQ 10>OR mov_clave = 28</cfif>) --->
 	AND (mov_clave = 5 OR mov_clave = 6 OR mov_clave = 9 OR mov_clave = 10 OR mov_clave = 17 OR mov_clave = 19 OR mov_clave = 25 <cfif #vFt# EQ 9 OR #vFt# EQ 10>OR mov_clave = 28 OR mov_clave = 35 OR mov_clave = 63</cfif>)
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP' <!--- Asuntos aprobados --->
    ORDER BY mov_fecha_inicio DESC
</cfquery>

<!--- Obtener la fecha de la solicitud --->
<cfif #vFechaSolicitud# EQ ''>
	<cfset vFechaHoy = #LsDateFormat(Now(), 'dd/mm/yyyy')#>
<cfelseif #vFechaSolicitud# NEQ ''>
	<cfset vFechaHoy = #vFechaSolicitud# >
</cfif>

<cfif #tbMovimientos.RecordCount# GT 0>	
	<!--- CALCULA LOS DIAS DEL PRIMER REGISTRO --->
	<cfset vFechaInicio = #LsDateFormat(tbMovimientos.mov_fecha_inicio, 'dd/mm/yyyy')#>
	<cfset vFechaFinal = #LsDateFormat(tbMovimientos.mov_fecha_final, 'dd/mm/yyyy')#>
	<cfset vCuentaAnios = #datediff('d',LsParseDateTime(tbMovimientos.mov_fecha_inicio),LsParseDateTime(vFechaHoy))#>
	<cfset vCuentaDias = #datediff('d',LsParseDateTime(tbMovimientos.mov_fecha_inicio),LsParseDateTime(vFechaHoy))#>
	<cfset vCuentaAniosSuma = 0>

	<cfif #tbMovimientos.RecordCount# LTE 2>
		<cfset vStartRow = 1>
	<cfelse>
		<cfset vStartRow = 2>    
    </cfif>
    
<!--- <cfoutput>#tbMovimientos.mov_clave# #vCuentaAnios#<br></cfoutput> --->
	<cfif #vFt# EQ 7 OR #vFt# EQ 8 OR #vFt# EQ 18>
		<!--- CALCULA LOS AÑOS DE ATINGUEDAD ACADEMICA PARA DEFINITIVIDAD --->	
		<cfloop query="tbMovimientos" startrow="#vStartRow#">
			<cfif #mov_fecha_final# EQ "">
				<cfset vFechaFinalMov = #LsDateFormat(DateAdd('d',365,LsParseDateTime(mov_fecha_inicio)),"dd/mm/yyyy")#>
			<cfelse>
				<cfset vFechaFinalMov = #LsDateFormat(LsParseDateTime(mov_fecha_final),"dd/mm/yyyy")#>
			</cfif>
			<cfset vCuentaAnios = #vCuentaAnios# + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaFinalMov) + 1)#>
			<cfset vCuentaDias = #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaFinalMov)+1)#>
			<cfset vFechaInicio = #LsDateFormat(mov_fecha_inicio, 'dd/mm/yyyy')# >
			<cfset vFechaFinal = #LsDateFormat(vFechaFinalMov, 'dd/mm/yyyy')#>
<!--- PRUEBAS <cfoutput>#mov_clave# #vCuentaAnios#<br></cfoutput> --->
		</cfloop>
	<cfelseif #vFt# EQ 9 OR #vFt# EQ 10 OR#vFt# EQ 19>
		<!--- CALCULA LOS AÑOS EN LA MISMA CATEGORIA Y NIVEL PARA PROMOCIONES --->	
		<cfset vStartRow = 1>        
		<cfloop query="tbMovimientos" startrow="#vStartRow#">
            
            <cfset vCuentaDias = 0>       
			<cfif #mov_fecha_final# EQ "">
				<cfset vFechaFinalMov = #LsDateFormat(DateAdd('d',365,LsParseDateTime(mov_fecha_inicio)),"dd/mm/yyyy")#>
			<cfelse>
				<cfset vFechaFinalMov = #LsDateFormat(LsParseDateTime(mov_fecha_final),"dd/mm/yyyy")#>
			</cfif>
			<cfif #LsParseDateTime(vFechaFinalMov)# LTE #LsParseDateTime(vFechaInicio)# - 1>
				<cfset vCuentaAnios = #vCuentaAnios# + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaFinalMov) + 1)#>
				<cfset vCuentaDias = #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaFinalMov)+1)#>
			<cfelseif #vFechaInicio# GT #LsParseDateTime(mov_fecha_inicio)# AND #LsParseDateTime(vFechaInicio)# LT #LsParseDateTime(vFechaFinalMov)# + 1>
				<cfset vCuentaAnios = #vCuentaAnios# + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaInicio))#>			
				<cfset vCuentaDias = #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(vFechaInicio))#>
			</cfif>
			<cfset vFechaInicio = #LsDateFormat(mov_fecha_inicio, 'dd/mm/yyyy')# >
			<cfset vFechaFinal = #LsDateFormat(vFechaFinalMov, 'dd/mm/yyyy')#>
            <cfif CGI.SERVER_PORT IS "31221">
                PRUEBAS <cfoutput>#mov_clave# - #mov_cn_clave# - #vCuentaDias# - #vCuentaAnios# - #vFechaInicio# - #vFechaFinal#<br></cfoutput>
            </cfif>
		</cfloop>
	<cfelse>
        <cfset vCuentaAnios = 0>
    </cfif>
	<!--- Regresar el valor calcuado --->
	<cfset vAnios = #vCuentaAnios# / 365>
        
<cfelse>
    <!--- EN CASO DE NO TENER MOVIMIENTOS REGISTRADOS, COMO EJEMPLO, LOS CAMBIOS DE ADSCRIPCIÓN EXTERNOS (23/01/2023) --->
    <cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
        SELECT fecha_pc, fecha_cn, fecha_def
        FROM academicos
        WHERE acd_id = #vIdAcad#
    </cfquery>
    
    <cfset vCuentaAnios = #datediff('d',LsParseDateTime(tbAcademicos.fecha_cn),LsParseDateTime(vFechaHoy) + 1)#>
	<cfset vCuentaDias = #datediff('d',LsParseDateTime(tbAcademicos.fecha_cn),LsParseDateTime(vFechaHoy)+1)#>
	<cfset vAnios = #vCuentaAnios# / 365>
</cfif>
<!--- Regresar un cero --->
<cfoutput>
    <input type="#vTipoInput#" id="vNoAniosCcnDef" value="#vAnios#"> <!--- SE CAMBIÓ EL VALOR DE <cfoutput>#vAnios#</cfoutput> POR 0 ---->
</cfoutput>    