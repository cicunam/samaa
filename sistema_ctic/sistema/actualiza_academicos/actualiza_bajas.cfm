<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 28/06/2010 --->
<!--- ACTUALIZA EL NÚMERO DE CONTRATOS PARA OBRA DETERMINADA DE LOS ACADÉMICOS --->

<cfset vIdInicioAct = 1>
<cfset vidFinalAct = 9300>

INICIO DEL PROCESO: <cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput><br>

<!--- Obtener la lista de los académicos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    WHERE 
    acd_id BETWEEN #vIdInicioAct# AND #vidFinalAct#
<!---	acd_id = #vIdInicioAct# --->
    ORDER BY acd_id
</cfquery>


<!--- ACTUALIZA LOS CONTRATOS PARA OBRA DETERMINADA --->
	<cfloop query="tbAcademicos">
		<cfset vAcdid = #tbAcademicos.acd_id#>

<!---
        <cfoutput>
	        #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#<br>
		</cfoutput>
---->
        <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE movimientos.acd_id = #vAcdId# 
            AND movimientos_asunto.asu_reunion = 'CTIC' 
            AND catalogo_decision.dec_super = 'AP'
            AND mov_clave = 6
            ORDER BY mov_fecha_inicio ASC
        </cfquery>

		<cfset vCcn = "">
        <cfset vCuentaNumCont = 0>
        <cfset vFechafinal = "">
        <cfset vCalculaDias = 0>

		<cfloop query="tbMovimientos">
			<cfset vSolId = #tbMovimientos.sol_id#>

			<cfif #tbMovimientos.mov_fecha_inicio# EQ '' OR #tbMovimientos.mov_fecha_final# EQ ''>
				<cfoutput>
            	ERROR EN EL ACADEMICO: #vAcdId# DEL MOVIMIENTO: #vSolId# DEL MOVIMIENTO DEL #tbMovimientos.mov_fecha_inicio# AL #tbMovimientos.mov_fecha_final#<br>
                </cfoutput>
            <cfelse>
				<cfif #tbMovimientos.mov_cn_clave# NEQ #vCcn# OR #tbMovimientos.mov_fecha_inicio# GT #vFechafinal#>
                    <cfset vCuentaNumCont = 0>
                    <cfset vCalculaDias = 0>
                </cfif>
    
                <cfset vCalculaDifDias =  #DateDiff('d',tbMovimientos.mov_fecha_inicio, tbMovimientos.mov_fecha_final)#>
                <cfif #vCalculaDifDias# EQ 365>
                    <cfset vCalculaDias = #vCalculaDias# + #vCalculaDifDias# - 1>
                <cfelse>
                    <cfset vCalculaDias = #vCalculaDias# + #vCalculaDifDias#>
                </cfif>
                
                <cfif #vCalculaDias# GTE 364 * (#vCuentaNumCont#)>
                    <cfset vCuentaNumCont = #vCuentaNumCont# + 1>
                <cfelseif #vCalculaDias# LT 364 * (#vCuentaNumCont#)>
                    <cfset vCuentaNumCont = #vCuentaNumCont#>            
                </cfif>
    
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    UPDATE movimientos SET 
                    mov_numero = # vCuentaNumCont#
                    WHERE sol_id = #vSolId#
                </cfquery>
    
                <cfset vCcn = #tbMovimientos.mov_cn_clave#>
                <cfset vFechaFinal = #tbMovimientos.mov_fecha_final# + 1>
    <!---
                <cfoutput>
                    #vCalculaDias# - #vCalculaDifDias# - #vCuentaNumCont# - #vCcn# - #LsDateFormat(vFechaFinal,'dd/mm/yyyy')#<br>
                </cfoutput>
    --->
			</cfif>
		</cfloop>
	</cfloop>
	<cfoutput>
    FINALIZÓ LA ACTUALIZACIÓN DEL NÚMERO DE CONTRATOS PARA OBRA DETERMINADA<br>
	FIN DEL PROCESO: #LsTimeFormat(now(),'HH:mm:ss')#<br>
    DEL REGISTRO #vIdInicioAct# AL #vidFinalAct#
    </cfoutput>
