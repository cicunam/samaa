<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 19/06/2009 --->
<!--- PARÁMETROS: vFt, vIdSol,  --->

<!--- Obtiene datos del catálogo de movimeitnos --->
<cfquery name="ft_form" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento WHERE catmov_noft = '#vFt#'
</cfquery>

<!--- Crear el registro de asunto --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	INSERT INTO movimientos_asunto (id_solicitud, no_sesion, id_movimiento, fecha_inicio, fecha_final, id_dependencia, pos1, id_academico, id_ccn, no_plaza, sinopsis, fecha_creacion)
	SELECT
		id_ft_captura,
		123 AS no_sesion,
		no_ft,
		pos14,	<!--- Depende del número de movimiento --->
		pos15,	<!--- Depende del número de movimiento --->
		id_dependencia,
		tmp_nom_dep,	<!--- Temporal: para probar la rutina --->
		id_academico,
		pos8,	<!--- Depende del número de movimiento --->
		pos9,	<!--- Depende del número de movimiento --->
		memo1,	<!--- Depende del número de movimiento --->
		GETDATE() as fecha_creacion
	FROM movimientos_solicitud
	WHERE id_ft_captura = '#vIdSol#'
</cfquery>

<!--- Redireccionar a --->
<cflocation url="../#ft_form.catmov_ruta#?vRfc=#FORM.rfc#&vIdSol=#vIdSol#&vFt=#vFt#&vTipoComando=CONSULTA" addtoken="no">
