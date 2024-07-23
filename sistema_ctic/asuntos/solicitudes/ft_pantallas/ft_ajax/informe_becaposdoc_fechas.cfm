<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 19/01/2023 --->
<!--- FECHA ULTIMA MOD.: 22/02/2024 --->
<!--- Obtener las fecha de inicio y término del informe a reportar --->
<!--- PENDIENTE --->

<cfparam name="vpAcdId" default="0">
<cfparam name="vpPos10" default="24">
<cfparam name="vpTipoComando" default="NUEVO">    

<cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
    SELECT T1.sol_id, T1.mov_fecha_inicio, T1.mov_fecha_final 
    FROM movimientos AS T1
    LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
    LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
    WHERE T1.acd_id = #vpAcdId#
    AND (T1.mov_clave = <cfif #vpPos10# EQ 12>38<cfelse>38 OR T1.mov_clave = 39</cfif>)<!--- <cfelseif #vpPos10# EQ 24>39 --->
    AND T2.asu_reunion = 'CTIC'
    AND (C1.dec_super = 'AP' OR C1.dec_super = 'CO')<!--- Asuntos aprobados --->
    AND (T1.mov_cancelado = 0 OR T1.mov_cancelado IS NULL)
    AND (GETDATE() BETWEEN T1.mov_fecha_inicio AND T1.mov_fecha_final OR T1.mov_fecha_final < GETDATE())
    ORDER BY T1.mov_fecha_inicio DESC
</cfquery>
	

<cfoutput>#tbMovimientosBecas.RecordCount#</cfoutput>
	
<cfif #tbMovimientosBecas.RecordCount# EQ 2 AND #vpPos10# NEQ 14>
	<cfoutput query="tbMovimientosBecas" startrow="2" maxrows="1">
		<cfset vCampoPos14 = #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio,'dd/mm/yyyy')#>
	</cfoutput>
	<cfoutput query="tbMovimientosBecas" startrow="1" maxrows="1">
		<cfset vCampoPos15 = #LsDateFormat(tbMovimientosBecas.mov_fecha_final,'dd/mm/yyyy')#>
	</cfoutput>
<cfelse>
	<cfset vCampoPos14 = #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio,'dd/mm/yyyy')#>
	<cfset vCampoPos15 = #LsDateFormat(tbMovimientosBecas.mov_fecha_final,'dd/mm/yyyy')#>
</cfif>		
    
<cfif #vpPos10# EQ 14>
    <cfquery name="tbBajas" datasource="#vOrigenDatosSAMAA#">
        SELECT mov_fecha_inicio AS fecha_baja 
        FROM movimientos
        WHERE acd_id = #vpAcdId#
        AND mov_clave = '14'
        AND (baja_clave = 1 OR baja_clave = 6 OR baja_clave = 8 OR baja_clave = 12)
        AND mov_fecha_inicio >  #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio, 'dd/mm/yyyy')#
        ORDER BY mov_fecha_inicio DESC
    </cfquery>
    
    <cfif #tbBajas.RecordCount# EQ 0>
        <cfquery name="tbBajas" datasource="#vOrigenDatosSAMAA#">
            SELECT sol_pos14 AS fecha_baja 
            FROM movimientos_solicitud
            WHERE sol_pos2 = #vpAcdId#
            AND mov_clave = '14'
            AND (sol_pos12 = 1 OR sol_pos12 = 6 OR sol_pos12 = 8 OR sol_pos12 = 12)
            AND sol_status < 4
            AND sol_pos14 >=  #LsDateFormat(tbMovimientosBecas.mov_fecha_inicio, 'dd/mm/yyyy')#
            ORDER BY sol_pos14 DESC
        </cfquery>
    </cfif>
    <cfif #tbBajas.RecordCount# EQ 0>
        <cfset #vCampoPos15# = ''>
		<script type="text/javascript">
			alert('NO HAY BAJA REGISTRADA EN EL SAMAA, FAVOR DE HACER EL TÁMITE DE BAJA Y POSTERIORMENTE EL INFORME')
		</script>
    <cfelse>
        <cfset #vCampoPos15# = #LsDateFormat(tbBajas.fecha_baja - 1,'dd/mm/yyyy')#>
    </cfif>    
</cfif>
            
<!--- Inserta el periodo a reportar --->
<cfoutput>            
    <span class="Sans9Gr">del </span>
    <input name="pos14" id="pos14" type="text" class="datos" value="#vCampoPos14#" size="10" maxlength="10" disabled>
    <span class="Sans9Gr">al </span>
   	<input name="pos15" id="pos15" type="text" class="datos" value="#vCampoPos15#" size="10" maxlength="10" disabled>
    <input name='pos12' id='pos12' type='hidden' value='#tbMovimientosBecas.sol_id#'>
    <input name='pos14_temp' id='pos14_temp' type='hidden' value='#vCampoPos14#'>
</cfoutput>