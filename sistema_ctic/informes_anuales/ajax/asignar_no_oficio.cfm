<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 24/04/2016 --->
<!--- FECHA ULTIMA MOD.: 17/05/2019 --->
<!--- IMPRESION DE OFICIOS DE RESPUESTA INFORMES ANUALES --->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="">
<cfparam name="vpNoOficioInicia" default="">
<cfparam name="vpSsnId" default=0>

<cfif (IsDefined('vpNoOficioInicia') AND #vpNoOficioInicia# GT 0) AND (IsDefined('vpInformeAnio') AND #vpInformeAnio# GT 0) AND #Session.sTipoSistema# EQ 'stctic'>

    <cfquery name="tbIAAsignaOficio" datasource="#vOrigenDatosSAMAA#">
        SELECT T1.acd_id, T1.informe_anual_id
        FROM movimientos_informes_anuales AS T1
        LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CTIC' AND T2.ssn_id = #vpSsnId#
        LEFT JOIN catalogo_dependencia AS C1 ON T1.dep_clave = C1.dep_clave
        WHERE T1.informe_anio = '#vpInformeAnio#'
        AND (T2.dec_clave = 1 OR T2.dec_clave = 4 OR T2.dec_clave = 19 OR T2.dec_clave = 49 OR T2.dec_clave = 57 OR T2.dec_clave = 61) <!--- SE AGREGA OFICIO A LOS APROBADOS, APROBADOS CON COMENTARIO Y NO APROBADO; NO EVALUADOS POR RECIEN INGRESO Y OBJETADOS (14/05/2019)--->
        ORDER BY C1.dep_orden, T2.asu_numero
    </cfquery>

    <cfoutput query="tbIAAsignaOficio">

        <cfset vInformeAnualId = #informe_anual_id#>
        <cfset vNoOficio = "#vpNoOficioInicia#/#LsDateFormat(now(),'yyyy')#">

        <cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos_informes_asunto SET
            informe_oficio = '#vNoOficio#'
            WHERE informe_anual_id = '#vInformeAnualId#'
            AND informe_reunion = 'CTIC'
        </cfquery>
        <cfset vpNoOficioInicia = #vpNoOficioInicia# + 1>
    </cfoutput> 
<cfelse>
	NO PROCEDE
</cfif>
