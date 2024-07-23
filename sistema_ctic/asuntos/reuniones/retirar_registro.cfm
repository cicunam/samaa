<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 26/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 26/10/2009 --->
<!--- AJAX PARA RETIRAR UN ASUNTO DE LA SESIÓN --->
<cfif #vIdSol# IS 'TODAS'>
	<!--- Cambiar el status de las solicitudes marcadas a 3 (en revision) --->
	<cfif #vReunion# IS 'CAAA'>
		<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCAAAFiltro.vMarcadas)#">
			<cfoutput>#RetirarAsunto(Session.AsuntosCAAAFiltro.vMarcadas[E])#</cfoutput>
		</cfloop>	
	<cfelseif #vReunion# IS 'CTIC'>
		<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#">
			<cfoutput>#RetirarAsunto(Session.AsuntosCTICFiltro.vMarcadas[E])#</cfoutput>
		</cfloop>
	</cfif>	
<cfelse>
	<cfoutput>#RetirarAsunto(vIdSol)#</cfoutput>
</cfif>
<cffunction name="RetirarAsunto" description="Retirar uno o más asuntos de la sesión del CTIC.">
	<!--- Parámetros --->
	<cfargument name="aSolicitud">
	<!--- Obtener la lista de asuntos marcados --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud WHERE sol_id = #aSolicitud#
	</cfquery>
	<!--- Retirar los asuntos --->
	<cfloop query="tbSolicitudes">
		<!--- Marcar la solicitud como retirada --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_retirada = 1, cap_fecha_mod = GETDATE()
			WHERE sol_id = #tbSolicitudes.sol_id#
		</cfquery>
		<!--- Copiar la solicitud en el historial de solicitudes --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO movimientos_solicitud_historia
			SELECT * FROM movimientos_solicitud 
			WHERE sol_id = #tbSolicitudes.sol_id#
		</cfquery>
		<!--- Eliminar la solicitud de la tabla --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			DELETE FROM movimientos_solicitud
			WHERE sol_id = #tbSolicitudes.sol_id#
		</cfquery>
	</cfloop>
</cffunction>
