<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 02/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 16/05/2017 --->
<!--- GUARDA POR MEDIO DE UN AJAX LO QUE SE ESCRIBE EN NOTAS YA SEA EN SOLICITUDES O INFORMES --->
<!--------------------------------------------------->

<cfparam name="vTipoGuarda" default="0">

<cfif #vTipoGuarda# EQ 'SOL'>
	<!--- Obtener datos de la tabla de comisiones --->
    <cfquery  name="tbSolicitudComision" datasource="#vOrigenDatosSAMAA#">
        SELECT COUNT(*) AS vCuenta 
        FROM movimientos_solicitud_comision
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
            (comision_acd_id, sol_id, comision_nota, ssn_id)
            VALUES (9000001, #vSolId#, '#vComentario#', #Session.sSesion#)
		</cfquery>
	</cfif>
<cfelse>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        UPDATE movimientos_informes_asunto
        SET comision_nota = '#vComentario#'
        WHERE informe_anual_id = #vInfAnId# 
        AND ssn_id = #Session.sSesion#
        AND informe_reunion = 'CAAA'
    </cfquery>
</cfif>

<cfoutput>#LEN(vComentario)#</cfoutput>
<!----  SE CAMBIÓ LA UBICACIÓN DE GUARDAR LAS NOTAS DE LA CAAA 
<!--- Obtener datos de la tabla de comisiones --->
<cfquery  name="tbComisiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_asunto
	WHERE sol_id = #vSolId# 
    AND ssn_id = #Session.sSesion#
</cfquery>

<cfquery datasource="#vOrigenDatosSAMAA#">
	<cfif #tbComisiones.RecordCount# GT 0>
		UPDATE movimientos_solicitud_comision
		SET comision_nota = '#vComentario#'
		WHERE sol_id = #vSolId# 
        AND ssn_id = #Session.sSesion#
	<cfelseif #tbComisiones.RecordCount# EQ 0>
		INSERT INTO movimientos_solicitud_comision
		(sol_id, comision_nota, ssn_id)
		VALUES (#vSolId#, '#vComentario#', #Session.sSesion#)
	</cfif>
</cfquery>
--->