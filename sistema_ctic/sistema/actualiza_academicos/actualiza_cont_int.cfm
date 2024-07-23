<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 28/06/2010 --->
<!--- ACTUALIZA EL NÚMERO DE CONTRATOS PARA OBRA DETERMINADA DE LOS ACADÉMICOS --->

<cfset vIdInicioAct = 9001>
<cfset vidFinalAct = 9500>

INICIO DEL PROCESO: <cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput><br>

<!--- Obtener la lista de los académicos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
	WHERE
    acd_id BETWEEN #vIdInicioAct# AND #vidFinalAct#
	<!---
    acd_id = 1333  --->
    ORDER BY acd_id
</cfquery>

	<cfloop query="tbAcademicos">
		<cfset vAcdid = #tbAcademicos.acd_id#>
        
        <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE movimientos.acd_id = #vAcdId# 
            AND movimientos_asunto.asu_reunion = 'CTIC' 
            AND catalogo_decision.dec_super = 'AP'
            AND mov_clave = 25
            ORDER BY mov_fecha_inicio ASC
        </cfquery>

		<cfset vCcn = "">
        <cfset vCuentaNumMov = 1>

		<cfloop query="tbMovimientos">
			<cfset vSolId = #tbMovimientos.sol_id#>

			<cfif #tbMovimientos.mov_cn_clave# NEQ #vCcn# OR #tbMovimientos.mov_fecha_inicio# GT #vFechafinal#>
            	<cfset vCuentaNumMov = 1>
            </cfif>
			
			<cfquery datasource="#vOrigenDatosSAMAA#">
            	UPDATE movimientos SET 
                mov_numero = #vCuentaNumMov#
                WHERE sol_id = #vSolId#
            </cfquery>

            <cfset vCcn = #tbMovimientos.mov_cn_clave#>
			<cfset vFechaFinal = #tbMovimientos.mov_fecha_inicio# + 366>
            <cfset vCuentaNumMov = #vCuentaNumMov# + 1>
		</cfloop>
	</cfloop>
	<cfoutput>
    FINALIZÓ LA ACTUALIZACIÓN DEL NÚMERO DE RENOVACIONES<br>
	FIN DEL PROCESO: #LsTimeFormat(now(),'HH:mm:ss')#<br>
    DEL REGISTRO #vIdInicioAct# AL #vidFinalAct#
    </cfoutput>