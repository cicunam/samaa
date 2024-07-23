<!--- CREADO: JOS� ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DUR�N --->
<!--- FECHA: 18/02/2010 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNI�N DE LA CAAA --->
<!--- Par�metros --->

<cfparam name="vCcn" default="No">
<cfparam name="vCod" default="No">
<cfparam name="vInt" default="No">

<cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput><br>

<!--- Obtener la lista de los acad�micos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    WHERE acd_id BETWEEN 1 AND 2000
<!---    acd_id = 6277 --->
    ORDER BY acd_id
</cfquery>

<cfif #vCcn# EQ 'Si'>
</cfif>

<!--- ACTUALIZA LOS CONTRATOS PARA OBRA DETERMINADA --->
<cfif #vCod# EQ 'Si'>
	<cfloop query="tbAcademicos">
		<cfset vAcdid = #tbAcademicos.acd_id#>
<!---
        <cfoutput>
	        #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#<br>
		</cfoutput>
--->
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
    FINALIZ� LA ACTUALIZACI�N DEL N�MERO DE CONTRATOS PARA OBRA DETERMINADA<br>
</cfif>

<!--- ACTUALIZA LAS RENOVACIONES DE ACAD�MICO INTERNO --->
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
    FINALIZ� LA ACTUALIZACI�N DEL N�MERO DE RENOVACIONES<br>
</cfif>

<cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput>
