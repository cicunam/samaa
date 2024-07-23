<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 23/05/2016 --->
<!--- FECHA ULTIMA MOD.: 23/05/2016 --->
<!--- AJAX que agrega académicos seleccionados a la lista de informes anuales --->


<!--- <cfoutput>#acd_id# - #informe_anio# - #informe_status#</cfoutput> --->
<cfif (IsDefined('acd_id') AND (#acd_id# NEQ 0 AND #acd_id# NEQ ''))  AND (IsDefined('informe_anio') AND (#informe_anio# NEQ 0 AND #informe_anio# NEQ ''))>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        INSERT INTO movimientos_informes_anuales (informe_anual_id, acd_id, dep_clave, ubica_clave , cn_clave, dec_clave_ci, informe_anio, informe_status)
        SELECT 
        (SELECT TOP 1 informe_anual_id + 1 FROM movimientos_informes_anuales ORDER BY informe_anual_id DESC) AS informe_anual_id,
        acd_id, 
        dep_clave, 
        dep_ubicacion, 
        cn_clave, 
        1, 
	    #informe_anio#,
		#informe_status#
        FROM academicos 
        WHERE acd_id = #acd_id#
    </cfquery>
</cfif>