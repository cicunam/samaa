<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/05/2009--->
<!--- FECHA ÚLTIMA MOD.: 03/04/2019 --->
<!--- CODIGO PARA ELIMINAR MOVIMIENTOS, ASÍ COMO REGISTROS LIGADOS A LA SOLICITUD--->

<cfparam name="vpModulo" default="MOV">

<!--- Elimina el registro de la solicitud o asunto seleccionado --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos 
    WHERE sol_id = #sol_id#
</cfquery>

<!--- Eliminar los registros de las tablas relacionadas --->
<cfquery datasource="#vOrigenDatosSAMAA#">
    DELETE FROM movimientos_asunto 
    WHERE sol_id = #sol_id#
</cfquery>

<!--- Elimina los registros de los destinos relacionados --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_destino 
    WHERE sol_id = #sol_id#
</cfquery>

<!--- Elimina los registros de correcciones a oficio relacionados --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM movimientos_correccion
    WHERE mov_id = #vIdMov#
</cfquery>

<!--- Registrar en la bitácora la eliminación del registro --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
	VALUES 
	(
		'#Session.sUsuario#',
		'#CGI.REMOTE_ADDR#',
		'movimientos',
		#sol_id#,
		'B',
		GETDATE()
	)
</cfquery>


<!--- Regresar a la lista de solicitudes --->
<cfif #vpModulo# EQ 'MOV'>
	<script type="text/javascript">
		window.location.assign('<cfoutput>#Session.sModulo#?vAcadId=#vIdAcad#</cfoutput>');
	</script>
</cfif>
<!--- <cflocation url="../consultas/movimientos_academico.cfm" addtoken="no"> --->
