<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 02/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 16/05/2017 --->
<!--- GUARDA POR MEDIO DE UN AJAX LO QUE SE ESCRIBE EN NOTAS YA SEA EN SOLICITUDES O INFORMES --->
<!--------------------------------------------------->

<cfparam name="vTipoGuarda" default="0">

<cfif #vTipoGuarda# EQ 'ASU'>
    <cfquery datasource="#vOrigenDatosSAMAA#">
        UPDATE evaluaciones_comision_upeid
        SET comision_nota = '#vComentario#'
        WHERE asunto_id = #vAsuId# 
        AND ssn_id = #Session.sSesion#
    </cfquery>
</cfif>

<cfoutput>#LEN(vComentario)#</cfoutput>
