<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 02/03/2010 --->
<!--- DEVOLVER UNA SOLICITUD A LA DEPENDECIA EMISORA PARA SU CORRECCIÓN --->

<cfif #vTipoDevolucion# EQ 'ENTIDAD' OR #vTipoDevolucion# EQ 'RECIBIDA'>
	<!--- Obtener información de la solicitud --->
    <cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM movimientos_solicitud WHERE sol_id = #vIdSol#
    </cfquery>
    
    <!--- Eliminar la solicitud de la lista de solicitudes marcadas correspondiente, de lo contrario los comandos posteriores se aplicarán sobre esta solicitud (!) --->
    <cfif #tbSolicitudes.sol_status# EQ 3 AND ArrayIndexOf(Session.AsuntosRevisionFiltro.vMarcadas,vIdSol) GT 0>
        <cfoutput>#ArrayDeleteAt(Session.AsuntosRevisionFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosRevisionFiltro.vMarcadas,vIdSol))#</cfoutput>
    <cfelseif #tbSolicitudes.sol_status# EQ 2 AND ArrayIndexOf(Session.AsuntosCAAAFiltro.vMarcadas,vIdSol) GT 0>
        <cfoutput>#ArrayDeleteAt(Session.AsuntosCAAAFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosCAAAFiltro.vMarcadas,vIdSol))#</cfoutput>
    <cfelseif #tbSolicitudes.sol_status# LTE 1 AND ArrayIndexOf(Session.AsuntosCTICFiltro.vMarcadas,vIdSol)>
        <cfoutput>#ArrayDeleteAt(Session.AsuntosCTICFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosCTICFiltro.vMarcadas,vIdSol))#</cfoutput>
    </cfif>
    
    <!--- Cambiar el status de la solicitud y marcarla como devuelta --->
    <cfquery datasource="#vOrigenDatosSAMAA#">
        UPDATE movimientos_solicitud 
        <cfif #vSituacion# IS 4>
            SET sol_status = 4, sol_devuelta = 1, sol_fecha_firma = NULL, <cfif #vRazonDevuelve# IS NOT ''>sol_devuelta_texto = '#vRazonDevuelve#', </cfif> cap_fecha_mod = GETDATE()
        <cfelseif #vSituacion# IS 3>	
            SET sol_status = 3, sol_devuelta_texto = NULL, cap_fecha_mod = GETDATE()
        </cfif>
        WHERE sol_id = #vIdSol#
    </cfquery>
    
    <!--- Eliminar los registros relacionados de la tabla de asuntos, si existen --->
    <cfquery datasource="#vOrigenDatosSAMAA#">
        DELETE FROM movimientos_asunto WHERE sol_id = #vIdSol#
    </cfquery>
    
    <!--- Eliminar los registros relacionados miembro de la CAAA que verá el asunto o solicitud --->
    <cfquery datasource="#vOrigenDatosSAMAA#">
        DELETE FROM movimientos_solicitud_comision WHERE sol_id = #vIdSol#
    </cfquery>
    
    <!--- Mover el archivo de documentación, si existe, a la carpeta de la entidad --->
    <cfset vCarpetaArchActual = #vCarpetaCAAA# & #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
    <cfset vCarpetaCambio = #vCarpetaENTIDAD# & mid(#tbSolicitudes.sol_pos1#,1,4) & '\'>
    <cfif FileExists(#vCarpetaArchActual#)>
        <cffile action="move" source="#vCarpetaArchActual#" destination="#vCarpetaCambio#">
    </cfif>
<cfelseif #vTipoDevolucion# EQ 'ARCHIVO' OR #vTipoDevolucion# EQ 'IMPRIME'>
    <cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_solicitud 
		<cfif #vTipoDevolucion# EQ 'IMPRIME'>
			SET sol_devuelve_edita = #vValorDevuelve#, <cfif #vRazonDevuelve# IS NOT ''>sol_devuelta_texto = '#vRazonDevuelve#', </cfif> cap_fecha_mod = GETDATE()
		<cfelseif #vTipoDevolucion# EQ 'ARCHIVO'>	
			SET sol_devuelve_archivo = #vValorDevuelve#, <cfif #vRazonDevuelve# IS NOT ''>sol_devuelta_texto = '#vRazonDevuelve#', </cfif> cap_fecha_mod = GETDATE()
        </cfif>	
        WHERE sol_id = #vIdSol#
    </cfquery>
</cfif>