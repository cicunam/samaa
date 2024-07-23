<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 31/05/2017  --->
<!--- FECHA ULTIMA MOD.: 27/05/2022 --->
<!--- IMPRESION DE OFICIOS DE RESPUESTA INFORMES ANUALES --->

<cfquery datasource="#vOrigenDatosSAMAA#">
    INSERT INTO movimientos_informes_asunto
    (informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave, comentario_texto)
		SELECT T1.informe_anual_id, 'CTIC', T1.ssn_id, T1.asu_parte, T1.asu_numero, NULL, T2.comentario_texto_ci
		FROM movimientos_informes_asunto AS T1
		LEFT JOIN movimientos_informes_anuales AS T2 ON T1.informe_anual_id = T2.informe_anual_id
		WHERE T1.informe_reunion = 'CAAA'
		AND T1.ssn_id = #vpActa#
		AND T2.informe_status = 2
		AND T2.informe_anio = #vpInformeAnio#
        AND T1.dec_clave IS NOT NULL
    ;
	UPDATE movimientos_informes_anuales SET
    informe_status = 3
    WHERE informe_status = 2    
	AND informe_anio = #vpInformeAnio#
<!---
    INSERT INTO movimientos_informes_asunto
    (informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave, comentario_texto, comentario_clave)
		SELECT T1.informe_anual_id, 'CTIC', T1.ssn_id, T1.asu_parte, T1.asu_numero, NULL, T2.comentario_texto_ci, 99
		FROM movimientos_informes_asunto AS T1
		LEFT JOIN movimientos_informes_anuales AS T2 ON T1.informe_anual_id = T2.informe_anual_id
		WHERE T1.informe_reunion = 'CAAA'
		AND T1.ssn_id = #vpActa#
		AND T2.informe_status = 2
		AND T2.informe_anio = #vpInformeAnio#
        AND T2.comentario_clave_ci = 99
    ;
--->
</cfquery>