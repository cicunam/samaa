<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 20/11/2015 --->
<!--- FECHA ÚLTIMA MOD.: 20/10/2022 --->

<cfquery name="tbMovDevSol" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM movimientos_asunto
    WHERE 
	asu_reunion = 'CTIC'
	<cfif #vTipoDevolucion# EQ 'SSNID'>
		AND ssn_id = #vActa#
        <cfif IsDefined('vFt') AND #vFt# NEQ 0>	
            <cfif #vFt# EQ 100>
                AND asu_parte < 5
            <cfelseif #vFt# EQ 101>
                AND asu_parte = 5
            </cfif>	
        </cfif>
		ORDER BY asu_parte, asu_numero
	<cfelseif #vTipoDevolucion# EQ 'SOLID'>
		AND sol_id = #vpSolId#
        ORDER BY ssn_id DESC
	</cfif>	
</cfquery>

<cfif #vTipoDevolucion# EQ 'SOLID'>
	<cfset vActa = #tbMovDevSol.ssn_id#>
</cfif>
<!--- <cfoutput>#vActa# - #vpSolId# - #tbMovDevSol.recordcount#</cfoutput> --->
<cfoutput query="tbMovDevSol">
	<cfset vSolId = #sol_id#>
	<cfquery datasource="#vOrigenDatosSAMAA#">
    	INSERT INTO movimientos_solicitud
        	SELECT * FROM movimientos_solicitud_historia
            WHERE sol_id = #vSolId#
		;            
		UPDATE movimientos_solicitud
        SET
	        sol_status = 1
		WHERE
			sol_id = #vSolId#
	</cfquery>    	

	<cfquery name="tbMovDevSolTemp" datasource="#vOrigenDatosSAMAA#">
		SELECT sol_id, sol_pos2 FROM movimientos_solicitud
		WHERE sol_id = #vSolId# 
	</cfquery>
        
    - #tbMovDevSolTemp.sol_id# - #tbMovDevSolTemp.sol_pos2#
	<cfif #tbMovDevSolTemp.RecordCount# EQ 1>
		<cfset vAcdId = #tbMovDevSolTemp.sol_pos2#>
		<!--- Pasar el archivo digitalizado (PDF) al historial de archivos --->
        <cfset vNomArchMov = '#vAcdId#_#sol_id#_#vActa#.pdf'>
        <cfset vNomArchSol = '#vAcdId#_#sol_id#.pdf'>

        <cfif FileExists(#vCarpetaAcademicos# & #vNomArchMov#)>
            <cffile action="move" source="#vCarpetaAcademicos##vNomArchMov#" destination="#vCarpetaCAAA#">
            <cffile action="rename" source="#vCarpetaCAAA##vNomArchMov#" destination="#vNomArchSol#">
        </cfif>
    
        <cfquery datasource="#vOrigenDatosSAMAA#">
            DELETE FROM movimientos_solicitud_historia
            WHERE sol_id = #vSolId#
        </cfquery>
    
        <cfquery  datasource="#vOrigenDatosSAMAA#">
            DELETE FROM movimientos
            WHERE sol_id = #vSolId#    
        </cfquery>
	</cfif>
</cfoutput>
