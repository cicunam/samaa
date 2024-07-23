<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD: 25/02/2022 --->
<!--- CODIGO PARA ELIMINAR SOLICITUDES, ASÍ COMO REGISTROS LIGADOS A LA SOLICITUD --->

<cfparam name="vpModulo" default="MOV">

<!--- Elimina el registro de la solicitud --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_solicitud 
    WHERE sol_id = #vIdSol#
</cfquery>

<!--- Elimina el registro de la sesión al que fue asignado  --->
<cfquery datasource="#vOrigenDatosSAMAA#">
    DELETE FROM movimientos_asunto 
    WHERE sol_id = #vIdSol#
</cfquery>

<!--- Elimina los registros de los destinos relacionados --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_destino 
    WHERE sol_id = #vIdSol#
</cfquery>

<!--- Elimina los registros de correcciones a oficio relacionados --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_correccion    
    WHERE sol_id = #vIdSol#
</cfquery>

<!--- Elimina los registros de reconocimiento de antigüedad ligado a la solicitud seleccionada --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_antiguedad 
	WHERE sol_id = #vIdSol#
</cfquery>

<!--- Actualiza la situación de la convocatoria cuando se elimina una solicitud de COA a starus 4 --->
<cfif #vFt# EQ 5 OR #vFt# EQ 15>
	<cfquery datasource="#vOrigenDatosSAMAA#">
    	UPDATE convocatorias_coa SET
		coa_status = 4
		WHERE coa_id = '#pos23#'
	</cfquery>
    <!--- se eliminan los participantes relacionados al COA 21/02/2022 --->
    <cfquery datasource="#vOrigenDatosSAMAA#">
        DELETE FROM convocatorias_coa_concursa
        WHERE sol_id = #vIdSol#
    </cfquery>    
</cfif>

<!--- Registrar en la bitácora la eliminación del registro --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
	VALUES 
	(
		'#Session.sUsuario#',
		'#CGI.REMOTE_ADDR#',
		'movimientos_solicitud',
		#vIdSol#,
		'B',
		GETDATE()
	)
</cfquery>

<!--- Regresar a la lista de solicitudes --->
<cfif #vpModulo# EQ 'MOV'>
	<cflocation url="#Session.sModulo#" addtoken="no">
</cfif>
