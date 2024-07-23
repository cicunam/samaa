<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/11/2017 --->
<!--- FECHA ULTIMA MOD.: 23/11/2019--->
<!--- INCLUDE QUE PERMITE AL COORDINADOR ACTIVAR EL O LOS ASUNTOS QUE SE VOTARÁN --->



<cfif #id# EQ ''>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        INSERT INTO sesion_asuntovoto
        (ssn_id, sol_id, asunto_descrip, voto_status, fecha_crea)
        VALUES
        (#ssn_id#, #sol_id#, '#asunto_descrip#', #voto_status#, GETDATE())
    </cfquery>
<cfelseif  #id# GT 0>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        UPDATE sesion_asuntovoto
        SET
        asunto_descrip = '#asunto_descrip#'
        ,
        voto_status = #voto_status#
        WHERE id = #id#
    </cfquery>
</cfif>
