<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 26/10/2009 --->
<!--- AJAX PARA ENVIAR UNA SOLICITUD A REVISIÓN --->
<!------------------------------------------------->
<!--- Procesar el comando recibido --->
<cfif #vIdSol# IS 'TODAS'>
	<!--- Cambiar el status de las solicitudes marcadas a 3 (en revision) --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosSolicitudFiltro.vMarcadas)#">
		<!--- Obtener los datos de la solicitud --->
		<cfquery name="tbSolicitudesVerificar" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud 
			WHERE sol_id = #Session.AsuntosSolicitudFiltro.vMarcadas[E]#
		</cfquery>
		<!--- Si el status de la solicitud es 4, proceder --->
		<cfif #tbSolicitudesVerificar.sol_status# IS 4>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_solicitud 
				SET sol_status = 3, sol_devuelta = 0 
				WHERE sol_id = #Session.AsuntosSolicitudFiltro.vMarcadas[E]#
			</cfquery>
			<!--- Registrar en la bitácora el envío del registro --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
				VALUES ('#Session.sUsuario#','#CGI.REMOTE_ADDR#','movimientos_solicitud',#Session.AsuntosSolicitudFiltro.vMarcadas[E]#,'E',GETDATE())
			</cfquery>
		</cfif>	
	</cfloop>
<cfelse>
	<!--- Obtener los datos de la solicitud --->
	<cfquery name="tbSolicitudesVerificar" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud WHERE sol_id = #vIdSol#
	</cfquery>
	<!--- Si el status de la solicitud es 4, proceder --->
	<cfif #tbSolicitudesVerificar.sol_status# IS 4>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud 
			SET sol_status = 3, sol_devuelta = 0 
			WHERE sol_id = #vIdSol#
		</cfquery>
		<!--- Registrar en la bitácora el envío del registro --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
			VALUES ('#Session.sUsuario#','#CGI.REMOTE_ADDR#','movimientos_solicitud',#vIdSol#,'E',GETDATE())
		</cfquery>
	</cfif>
</cfif>
