<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/07/2022 --->
<!--- CÓDIGO LIBERAR LOS REGISTROS DE INFORME QUE YA CUENTAN CON DECISIÓN Y NÚMERO DE OFICIO --->


<!--- INFORMES APROBADOS, APROBADOS CON COMENTARIO Y LOS NO APROBADS: GENERA MOVIMIENTO --->
<cfquery datasource="#vOrigenDatosSAMAA#">
    UPDATE movimientos_informes_anuales
    SET movimientos_informes_anuales.informe_status = NULL
		FROM movimientos_informes_asunto AS T2
		LEFT JOIN movimientos_informes_anuales AS T3 ON T2.informe_anual_id = T3.informe_anual_id
		WHERE T2.ssn_id = #vpSsnId#
		AND T2.informe_reunion = 'CTIC'
		AND (T2.dec_clave = 1 OR T2.dec_clave = 4 OR T2.dec_clave = 49)
		AND T3.informe_status = 3
		AND T2.informe_oficio IS NOT NULL <!--- NO ENVIAR LOS ASUNTOS SIN NÚMERO DE OFICIO --->
</cfquery>

<!--- INFORMES NO EVALUADOS: GENERA MOVIMIENTO --->
<cfquery datasource="#vOrigenDatosSAMAA#">
    UPDATE movimientos_informes_anuales
    SET movimientos_informes_anuales.informe_status = NULL
		FROM movimientos_informes_asunto AS T2
		LEFT JOIN movimientos_informes_anuales AS T3 ON T2.informe_anual_id = T3.informe_anual_id
		WHERE T2.ssn_id = #vpSsnId#
		AND T2.informe_reunion = 'CTIC'
		AND T2.dec_clave BETWEEN 50 AND 60
		AND T3.informe_status = 3
</cfquery>

<!--- INFORMES OBJETADOS/PENDIENTES: REGRESA EL ASUNTO A LA CAAA EN UNA SESIÓN POSTERIOR --->
<cfset vSsnIdPost = #vpSsnId# + 1>

<cfquery name="tbInformesOB" datasource="#vOrigenDatosSAMAA#">
		SELECT T1.informe_anual_id, T1.asu_numero, T1.dec_clave, T2.comentario_texto_ci,
        (
            SELECT COUNT(*) 
            FROM movimientos_informes_asunto 
            WHERE informe_anual_id = T1.informe_anual_id 
            AND ssn_id > #vpSsnId#
            AND informe_reunion = 'CTIC'
        ) AS vCuenta		
		FROM movimientos_informes_asunto AS T1
		LEFT JOIN movimientos_informes_anuales AS T2 ON T1.informe_anual_id = T2.informe_anual_id
		WHERE T1.informe_reunion = 'CTIC'
		AND (T1.dec_clave BETWEEN 11 AND 24 OR T1.dec_clave BETWEEN 61 AND 62)
        AND T1.ssn_id = #vpSsnId#
		AND T2.informe_status = 3
		AND T2.informe_anio = '#vpInformeAnio#'
</cfquery>

<cfoutput query="tbInformesOB">
	<cfif #tbInformesOB.vCuenta# EQ 0>
		<cfset vinforme_anual_id = #informe_anual_id#>
		<cfset vasu_numero = #asu_numero#>
		<cfset vdec_clave = #dec_clave#>
		<cfset vcomentario_texto_ci = #comentario_texto_ci#>
    
	    <cfquery datasource="#vOrigenDatosSAMAA#">
    	    INSERT INTO movimientos_informes_asunto
        	(informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave, comentario_texto, comentario_clave)
	        VALUES
    	    (#vinforme_anual_id#, 'CAAA', #vSsnIdPost#, 4.3, #vasu_numero#, #vdec_clave#, '#vcomentario_texto_ci#', NULL)
	    </cfquery>

		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_informes_anuales 
			SET informe_status = 2
			WHERE informe_anual_id = #vinforme_anual_id#
		</cfquery>
	</cfif>
</cfoutput>
<!---
<cfquery datasource="#vOrigenDatosSAMAA#">
    INSERT INTO movimientos_informes_asunto
    (informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave, comentario_texto, comentario_clave)
		SELECT T1.informe_anual_id, 'CAAA', #vSsnIdPost#, 4.3, T1.asu_numero, T1.dec_clave, T2.comentario_texto_ci, NULL
		FROM movimientos_informes_asunto AS T1
		LEFT JOIN movimientos_informes_anuales AS T2 ON T1.informe_anual_id = T2.informe_anual_id
		WHERE T1.informe_reunion = 'CTIC'
		AND (T1.dec_clave BETWEEN 12 AND 24 OR T1.dec_clave BETWEEN 61 AND 62)
        AND T1.ssn_id = #vpSsnId#	
		AND T2.informe_status = 3
		AND T2.informe_anio = '#vpInformeAnio#'
</cfquery>

<cfquery datasource="#vOrigenDatosSAMAA#">
	UPDATE movimientos_informes_anuales 
	SET informe_status = 2
		FROM movimientos_informes_asunto AS T1
		LEFT JOIN movimientos_informes_anuales AS T2 ON T1.informe_anual_id = T2.informe_anual_id
		WHERE T1.informe_reunion = 'CAAA'
		<!--- AND (T1.dec_clave BETWEEN 12 AND 24 OR T1.dec_clave BETWEEN 61 AND 62) --->
        AND T1.ssn_id = #vSsnIdPost#	
		AND T2.informe_status = 3
		AND T2.informe_anio = '#vpInformeAnio#'    
</cfquery>
--->