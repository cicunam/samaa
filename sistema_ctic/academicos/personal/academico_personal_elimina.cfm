<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 03/02/2010 --->
<!--- FECHA �LTIMA MOD.: 22/02/2018 --->
<!--- ELIMINAR ACAD�MICOS Y TODO LO RELACIONADO CON EL ACAD�MICO--->

<!--- Elimina el registro de la solicitud o asunto seleccionado --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	DELETE FROM academicos 
    WHERE acd_id = #vAcadId#
</cfquery>

<!--- NOTA: Aqu� se deben eliminar todos los registros relacionados. --->
<cfparam name="vpModulo" default="ACD">

<!--- Selecci�n de movimientos asociados al acad�mico --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id, mov_id AS vIdMov
	FROM movimientos
    WHERE acd_id = #vAcadId#
</cfquery>

<cfoutput query="tbMovimientos">
	<cfinclude template="#vCarpetaRaizLogicaSistema#/movimientos/detalle/mov_elimina.cfm">
</cfoutput>

<!--- Selecci�n solicitudes activas y asociadas al acad�mico --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id AS vIdSol
	FROM movimientos_solicitud
    WHERE sol_pos2 = #vAcadId#
</cfquery>

<cfoutput query="tbSolicitudes">
	<cfinclude template="#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/ft_pantallas/ft_ctic_elimina.cfm">
</cfoutput>

<!--- Registrar en la bit�cora la eliminaci�n del registro --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
	VALUES 
	(
		'#Session.sUsuario#',
		'#CGI.REMOTE_ADDR#',
		'academicos',
		#vAcadId#,
		'B',
		GETDATE()
	)
</cfquery>

<cfset Session.AcademicosFiltro.vAcadId = ''>

<cflocation url="../consulta_academicos.cfm" addtoken="no">
