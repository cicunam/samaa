<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 18/02/2010 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA CAAA --->
<!--- Parámetros --->

<cfset vIdInicioAct = 1>
<cfset vidFinalAct = 100>

INICIO DEL PROCESO: <cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput><br>

<!--- Obtener la lista de los académicos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    acd_id BETWEEN #vIdInicioAct# AND #vidFinalAct#
	<!---
    acd_id = 1333  --->
    ORDER BY acd_id
</cfquery>

<cfloop query="tbAcademicos">

	<!-- VARIABLE PARA GURDAR EL IDENTIFICADOR DEL ACADÉMICO -->
	<cfset vAcdid = #tbAcademicos.acd_id#>
	<cfoutput>#tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#</cfoutput><br>

	<!-- ABRE LA BASE DE DATOS DE MOVIMIENTOS PARA VER CUAL ES LA ULTIMA CATEGORÍA Y NIVEL -->
    <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM (movimientos 
        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
        WHERE movimientos.acd_id = #vAcdId# 
        AND movimientos_asunto.asu_reunion = 'CTIC' 
        AND catalogo_decision.dec_super = 'AP'
        AND mov_clave = 9 OR  mov_clave = 10 OR mov_clave = 19 OR mov_clave = 5 OR mov_clave = 6 OR mov_clave = 17
        ORDER BY mov_fecha_inicio DES
    </cfquery>

	<cfloop query="tbMovimientos">
    	<cfoutput>
    	#tbMovimientos.mov_ccn_clave# - #tbMovimientos.mov_clave# - #LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#  - #LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#<br>
		</cfoutput>
    </cfloop>

	<cfif #tbMovimientos.RecordCount# GT 0>
		<cfset vCcnAct = #tbMovimientos.mov_ccn_clave#>
        <cfset vTipoMov = #tbMovimientos.mov_clave#>
    
        <!-- ABRE LA BASE DE DATOS DE MOVIMIENTOS PARA VER CUAL ES LA ULTIMA CATEGORÍA Y NIVEL -->
        <cfquery name="tbMovAct" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE movimientos.acd_id = #vAcdId# 
            AND movimientos_asunto.asu_reunion = 'CTIC' 
            AND catalogo_decision.dec_super = 'AP'
            AND mov_clave = 9 OR  mov_clave = 10 OR mov_clave = 19 OR mov_clave = 5 OR mov_clave = 6 OR mov_clave = 17
            AND mov_cn_clave = '#vCcnAct#'
            ORDER BY mov_fecha_inicio ASC
        </cfquery>
        
    <!---
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE academicos SET 
            ccn_calve = #vCcnAct#, fecha_cn = '##'
            
            WHERE sol_id = #vSolId#
        </cfquery>
    --->
	</cfif>
</cfloop>


<cfoutput>
	FINALIZÓ LA ACTUALIZACIÓN DE LA CATEGORÍA Y NIVEL ACTUAL<br>
	FIN DEL PROCESO: #LsTimeFormat(now(),'HH:mm:ss')#<br>
	DEL REGISTRO #vIdInicioAct# AL #vidFinalAct#
</cfoutput>



<!---
<!--- ACTUALIZA LOS CONTRATOS PARA OBRA DETERMINADA --->
<cfif #vCod# EQ 'Si'>
	<cfloop query="tbAcademicos">
		<cfset vAcdid = #tbAcademicos.acd_id#>
<!---
        <cfoutput>
	        #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#<br>
		</cfoutput>
--->


        <cfquery name="tbMovAct" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE movimientos.acd_id = #vAcdId# 
            AND movimientos_asunto.asu_reunion = 'CTIC' 
            AND catalogo_decision.dec_super = 'AP'
            AND mov_clave = 9 OR  mov_clave = 10 OR mov_clave = 19 OR mov_clave = 5 OR mov_clave = 6 OR mov_clave = 17
			AND
            ORDER BY mov_fecha_inicio DES
        </cfquery>


		<cfloop query="tbMovimientos">
			<cfset vSolId = #tbMovimientos.sol_id#>

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
		</cfloop>
	</cfloop>
    FINALIZÓ LA ACTUALIZACIÓN DEL NÚMERO DE CONTRATOS PARA OBRA DETERMINADA<br>
</cfif>

<!--- ACTUALIZA LAS RENOVACIONES DE ACADÉMICO INTERNO --->
<cfif #vInt# EQ 'Si'>
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
        	<cfif #tbMovimientos.mov_cn_clave# NEQ #vCcn#>
            	<cfset vCuentaNumMov = 1>
            </cfif>
			
			<cfquery datasource="#vOrigenDatosSAMAA#">
            	UPDATE movimientos SET 
                mov_numero = #vCuentaNumMov#
                WHERE sol_id = #vSolId#
            </cfquery>

            <cfset vCcn = #tbMovimientos.mov_cn_clave#>            
            <cfset vCuentaNumMov = #vCuentaNumMov# + 1>
		</cfloop>
	</cfloop>
    FINALIZÓ LA ACTUALIZACIÓN DEL NÚMERO DE RENOVACIONES<br>
</cfif>


---->