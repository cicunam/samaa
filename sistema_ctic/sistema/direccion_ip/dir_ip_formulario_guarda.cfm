<cfif IsDefined('keyGuardaReg') AND #keyGuardaReg# EQ 'N'>
	<cfset vConcatenaIp = "#ip_g_1#.#ip_g_2#.#ip_g_3#.#ip_g_4#">
    <cfquery datasource="#vOrigenDatosSAMAA#">
        INSERT INTO samaa_sistema_ip
        (direccion_ip, status, ubicacion_ip)
		VALUES
		(
        	'#vConcatenaIp#'
            ,
            1
            ,
            <cfif #ubicacion_ip# NEQ ''>'#ubicacion_ip#'
            <cfelse>NULL</cfif>
		)
    </cfquery>
<cfelseif IsDefined('keyGuardaReg') AND #keyGuardaReg# EQ 'E'>
    <cfquery datasource="#vOrigenDatosSAMAA#">
		DELETE samaa_sistema_ip
		WHERE ip_id = #vIpId#
    </cfquery>
<cfelseif IsDefined('keyGuardaReg') AND #keyGuardaReg# EQ 'M'>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        UPDATE samaa_sistema_ip SET
        	#vCampo# = #vValorChk#
		WHERE ip_id = #vIpId#        
    </cfquery>
</cfif>
