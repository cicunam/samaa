<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 08/05/2017 --->
<!--- GUARDA POR MEDIO DE UN AJAX LO QUE SE ESCRIBE EN NOTAS --->
<!--------------------------------------------------->

<cfparam name="vSolId" default="0">
<cfparam name="vComentario" default="">

<!--- Obtener datos de la tabla de comisiones --->
<cfquery name="tbSolicitudComision" datasource="#vOrigenDatosSAMAA#">
	SELECT COUNT(*) AS vCuenta FROM movimientos_solicitud_comision
	WHERE sol_id = #vSolId# 
    AND ssn_id = #Session.sSesion#
</cfquery>

<cfif #tbSolicitudComision.vCuenta# GT 0>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_solicitud_comision
		SET comision_nota = '#vComentario#'
		WHERE sol_id = #vSolId# 
		AND ssn_id = #Session.sSesion#
	</cfquery>
<cfelseif #tbSolicitudComision.vCuenta# EQ 0>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos_solicitud_comision
		(sol_id, comision_nota, ssn_id)
		VALUES (#vSolId#, '#vComentario#', #Session.sSesion#)
	</cfquery>
</cfif>
