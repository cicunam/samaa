<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 08/09/2009 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2024 --->
<!--- ARCHIVO PARA CREAR VARIABLES LOCALES --->
<cfif #vTipoComando# EQ 'NUEVO'>
	<!--- Obtener los datos del académico relacionado --->
	<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos 
        WHERE acd_id = #vIdAcad#
	</cfquery>
	<!--- Obtener los datos del movimiento relacionado --->
	<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_movimiento 
        INNER JOIN catalogo_movimiento_etq ON catalogo_movimiento.mov_clave = catalogo_movimiento_etq.mov_clave
		WHERE catalogo_movimiento.mov_clave = #mov_clave#
	</cfquery>
	<!--- Opciones de apertura del formulario de captura --->
	<cfset vRutaPagSig = "mov_nuevo.cfm">
	<cfset vActivaCampos = "">
	<!--- Valores predeterminados --->
	<cfset mov_id = #vIdMov#>
	<cfset sol_id = #vIdSol#>
	<cfset dep_clave = '#tbAcademicos.dep_clave#'>
	<cfset dep_ubicacion = '#tbAcademicos.dep_ubicacion#'>
	<cfset acd_id = #vIdAcad#>
	<cfset cn_clave = ''>
	<cfset con_clave = ''>
	<cfset mov_clave = #mov_clave#>
	<cfset mov_fecha_inicio = ''>
	<cfset mov_fecha_final = ''>
	<cfset mov_dep_clave = ''>
	<cfset mov_dep_ubicacion = ''>
	<cfset acd_id_asesor = ''>
	<cfset mov_cn_clave = ''>
	<cfset mov_plaza = ''>
	<cfset coa_id = ''>
	<cfset pais_clave = ''>
	<cfset edo_clave = ''>
	<cfset mov_ciudad = ''>
	<cfset mov_institucion = ''>
	<cfset mov_cargo = ''>
	<cfset mov_periodo = ''>
	<cfset cam_clave = ''>
	<cfset mov_prorroga = ''>
	<cfset prog_clave = ''>
	<cfset baja_clave = ''>
	<cfset activ_clave = ''>
	<cfset mov_texto = ''>
	<cfset mov_horas = ''>
	<cfset mov_numero = ''>
	<cfset mov_sueldo = ''>
	<cfset mov_erogacion = ''>
	<cfset mov_aapaunam = ''><!--- (SE AGREGÓ EL 23/02/2024) --->
	<cfset mov_fecha_1 = ''>
	<cfset mov_fecha_2 = ''>
	<cfset mov_logico = ''>
	<cfset mov_memo_1 = ''>
	<cfset mov_memo_2 = ''>
	<cfset mov_opinion_ci = ''>
	<cfset mov_opinion_dir = ''>
	<cfset mov_dictamen_cd = ''>
	<cfset mov_relacionado = ''>
	<cfset mov_modificado = ''>
	<cfset mov_cancelado = ''>
	<cfset mov_observaciones = ''>
<cfelseif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'CORRECCION'>
	<!--- Obtener los datos del movimiento --->
	<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
		SELECT T1.*, T2.ssn_id FROM movimientos AS T1
        LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND  T2.asu_reunion = 'CTIC'
        WHERE mov_id = #vIdMov#
	</cfquery>
    
	<!--- Obtener los datos del académico relacionado --->
	<cfif #tbMovimientos.mov_clave# IS NOT 15 AND #tbMovimientos.mov_clave# IS NOT 16>
		<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM academicos 
            WHERE acd_id = #tbMovimientos.acd_id#
		</cfquery>
	</cfif>

	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud_historia 
		<!---LEFT JOIN catalogo_movimiento ON movimientos_solicitud_historia.mov_clave = catalogo_movimiento.mov_clave --->
		WHERE sol_id = <cfif #tbMovimientos.sol_id# IS NOT ''>#tbMovimientos.sol_id#<cfelse>0</cfif>
	</cfquery>

	<!--- Obtener información del COA relacionado --->
	<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM convocatorias_coa 
        WHERE coa_id = <cfif #tbMovimientos.coa_id# IS NOT ''>'#tbMovimientos.coa_id#'<cfelse>''</cfif>
	</cfquery>
    
	<!--- Obtener los datos del movimiento relacionado --->
	<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_movimiento 
        INNER JOIN catalogo_movimiento_etq ON catalogo_movimiento.mov_clave = catalogo_movimiento_etq.mov_clave
		WHERE catalogo_movimiento.mov_clave = #tbMovimientos.mov_clave#
	</cfquery>
	<!--- Opciones de apertura del formulario de captura --->
	<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CORRECCION'>
		<cfset vActivaCampos = "">
		<cfset vRutaPagSig = "mov_edita.cfm">
	<cfelseif #vTipoComando# EQ 'CONSULTA'>
		<cfset vActivaCampos = "disabled">
		<cfset vRutaPagSig = "movimiento.cfm">
	</cfif>
	<!--- Valores obtenidos de la base de datos --->
	<cfset mov_id = #tbMovimientos.mov_id#>
	<cfset sol_id = #tbMovimientos.sol_id#>
	<cfset dep_clave = #tbMovimientos.dep_clave#>
	<cfset dep_ubicacion = #tbMovimientos.dep_ubicacion#>
	<cfset acd_id = #tbMovimientos.acd_id#>
	<cfset cn_clave = #tbMovimientos.cn_clave#>
	<cfset con_clave = #tbMovimientos.con_clave#>
	<cfset mov_clave = #tbMovimientos.mov_clave#>
	<cfset mov_fecha_inicio = #LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#>
	<cfset mov_fecha_final = #LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#>
	<cfset mov_dep_clave = #tbMovimientos.mov_dep_clave#>
	<cfset mov_dep_ubicacion = #tbMovimientos.mov_dep_ubicacion#>
	<cfset acd_id_asesor = #tbMovimientos.acd_id_asesor#>
	<cfset mov_cn_clave = #tbMovimientos.mov_cn_clave#>
	<cfset mov_plaza = #tbMovimientos.mov_plaza#>
	<cfset coa_id = #tbMovimientos.coa_id#>
	<cfset pais_clave = #tbMovimientos.pais_clave#>
	<cfset edo_clave = #tbMovimientos.edo_clave#>
	<cfset mov_ciudad = #tbMovimientos.mov_ciudad#>
	<cfset mov_institucion = #tbMovimientos.mov_institucion#>
	<cfset mov_cargo = #tbMovimientos.mov_cargo#>
	<cfset mov_periodo = #tbMovimientos.mov_periodo#>
	<cfset cam_clave = #tbMovimientos.cam_clave#>
	<cfset mov_prorroga = #Iif(tbMovimientos.mov_prorroga IS 1,DE("Si"),DE("No"))#>
	<cfset prog_clave = #tbMovimientos.prog_clave#>
	<cfset baja_clave = #tbMovimientos.baja_clave#>
	<cfset activ_clave = #tbMovimientos.activ_clave#>
	<cfset mov_texto = #tbMovimientos.mov_texto#>
	<cfset mov_horas = #tbMovimientos.mov_horas#>
	<cfset mov_numero = #tbMovimientos.mov_numero#>
	<cfset mov_sueldo = #tbMovimientos.mov_sueldo#>
	<cfset mov_erogacion = #tbMovimientos.mov_erogacion#>
	<cfset mov_aapaunam = #Iif(tbMovimientos.mov_aapaunam IS 1,DE("Si"),DE("No"))#> <!--- (SE AGREGÓ EL 23/02/2024) --->
	<cfset mov_fecha_1 = #LsDateFormat(tbMovimientos.mov_fecha_1,'dd/mm/yyyy')#>
	<cfset mov_fecha_2 = #LsDateFormat(tbMovimientos.mov_fecha_2,'dd/mm/yyyy')#>
	<cfset mov_logico = #Iif(tbMovimientos.mov_logico IS 1,DE("Si"),DE("No"))#>
	<cfset mov_memo_1 = #tbMovimientos.mov_memo_1#>
	<cfset mov_memo_2 = #tbMovimientos.mov_memo_2#>
	<cfset ssn_id = #tbMovimientos.ssn_id#>
	<!--- Opinión del CI --->
	<cfif #tbMovimientos.mov_opinion_ci# IS NOT ''>
		<cfset mov_opinion_ci = #Iif(tbMovimientos.mov_opinion_ci IS 1,DE("Si"),DE("No"))#>
	<cfelse>
		<cfset mov_opinion_ci = ''>
	</cfif>		
	<!--- Opinión del director --->
	<cfif #tbMovimientos.mov_opinion_dir# IS NOT ''>
		<cfset mov_opinion_dir = #Iif(tbMovimientos.mov_opinion_dir IS 1,DE("Si"),DE("No"))#>
	<cfelse>
		<cfset mov_opinion_dir = ''>
	</cfif>
	<!--- Dictamen de la CD --->
	<cfif #tbMovimientos.mov_dictamen_cd# IS NOT ''>	
		<cfset mov_dictamen_cd = #Iif(tbMovimientos.mov_dictamen_cd IS 1,DE("Si"),DE("No"))#>
	<cfelse>
		<cfset mov_dictamen_cd = ''>
	</cfif>
	<cfset mov_relacionado = #tbMovimientos.mov_relacionado#>
<!---
	<cfset mov_modificado = #Iif(tbMovimientos.mov_modificado IS 1,DE("yes"),DE("no"))#>
	<cfset mov_cancelado = #Iif(tbMovimientos.mov_cancelado IS 1,DE("yes"),DE("no"))#>
--->
	<cfset mov_modificado = #Iif(tbMovimientos.mov_modificado IS 1,DE("checked"),DE(""))#>
	<cfset mov_cancelado = #Iif(tbMovimientos.mov_cancelado IS 1,DE("checked"),DE(""))#>
	<cfset mov_observaciones = #tbMovimientos.mov_observaciones#>
</cfif>
<!--- Generar el nombre del académico en modo texto --->
<cfif #acd_id# IS NOT ''>
	<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos 
        WHERE acd_id = #acd_id# 
	</cfquery>
	<cfif #tbAcademicos.RecordCount# EQ 1> 
		<cfset acd_id_txt = '#Trim(tbAcademicos.acd_prefijo)# #Trim(tbAcademicos.acd_nombres)# #Trim(tbAcademicos.acd_apepat)# #Trim(tbAcademicos.acd_apemat)#'>
	<cfelse>
		<cfset acd_id_txt = ''>
	</cfif>
<cfelse>
	<cfset acd_id_txt = ''>	
</cfif>	
<!--- Generar el nombre del asesor en modo texto, si existe --->
<cfif #acd_id_asesor# IS NOT ''>
	<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos 
        WHERE acd_id = #acd_id_asesor# 
	</cfquery>
	<cfif #tbAcademicos.RecordCount# EQ 1> 
		<cfset acd_id_asesor_txt = '#Trim(tbAcademicos.acd_apepat)# #Trim(tbAcademicos.acd_apemat)# #Trim(tbAcademicos.acd_nombres)#'>
	<cfelse>
		<cfset acd_id_asesor_txt = ''>
	</cfif>	
<cfelse>
	<cfset acd_id_asesor_txt = ''>
</cfif>

<!--- Obtener el nombre del movimiento relacionado --->
<cfset mov_relacionado_txt = ''>
<cfif #mov_relacionado# IS NOT ''>
    <cfif #mov_relacionado# IS ''>
        <cfquery name="tbMovimientoRelacionado" datasource="#vOrigenDatosSAMAA#">
            SELECT mov_titulo 
            FROM movimientos T1
            LEFT JOIN catalogo_movimiento C1 ON T1.mov_clave = C1.mov_clave
            WHERE mov_id = #mov_relacionado#
        </cfquery>
    	<cfif #tbMovimientoRelacionado.RecordCount# EQ 1> 
	    	<cfset mov_relacionado_txt = '#Ucase(tbMovimientoRelacionado.mov_titulo)#'>
	    </cfif>	
    <cfelse>
        <cfquery name="tbInformeRelacionado" datasource="#vOrigenDatosSAMAA#">
            SELECT informe_anio
            FROM movimientos_informes_anuales
            WHERE informe_anual_id = #mov_relacionado#
        </cfquery>
    	<cfif #tbInformeRelacionado.RecordCount# EQ 1> 
	    	<cfset mov_relacionado_txt = 'INFORME ANUAL #Ucase(tbInformeRelacionado.informe_anio)#'>
	    </cfif>	
    </cfif>
<cfelse>
	<cfset mov_relacionado_txt = ''>
</cfif>


