<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/09/2023 --->
<!--- FECHA ÚLTIMA MOD.: 06/09/2023 --->
<cfif #tipo_asunto# EQ 'MOV'>
    <cfif #mov_cancelado# EQ 1 OR #mov_cancelado# EQ 0>
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos SET
            mov_cancelado = #mov_cancelado#
            , 
            mov_cancelado_fecha = <cfif #mov_cancelado# EQ 1>'#LsDateFormat(fecha_cancelacion,"yyyy-mm-dd")#'<cfelse>NULL</cfif>
            ,
            mov_cancelado_oficio = <cfif #mov_cancelado# EQ 1>'#mov_cancelado_oficio#'<cfelse>NULL</cfif>
            WHERE sol_id = #sol_id#
        </cfquery>

        <cfquery datasource="#vOrigenDatosPOSDOC#">
            UPDATE solicitudes_beca SET
            declinacion =  #mov_cancelado#
            WHERE sol_id_38 = #sol_id#
        </cfquery>    

        <cfif #mov_cancelado# EQ 1>MOVIMIENTO CANCELADO
        <cfelseif #mov_cancelado# EQ 0>MOVIMIENTO SE REACTIVO
        </cfif>
    </cfif>
</cfif>

<cfif #tipo_asunto# EQ 'INF'>
    <cfif #mov_cancelado# EQ 1 OR #mov_cancelado# EQ 0>
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos_informes_anuales SET
            informe_cancela = #mov_cancelado#
            , 
            informe_cancela_fecha = <cfif #mov_cancelado# EQ 1>'#LsDateFormat(fecha_cancelacion,"yyyy-mm-dd")#'<cfelse>NULL</cfif>
            ,
            infome_cancela_oficio = <cfif #mov_cancelado# EQ 1>'#num_cancelado_oficio#'<cfelse>NULL</cfif>
            WHERE informe_anual_id = #registro_id#
        </cfquery>

        <cfif #mov_cancelado# EQ 1>INFORME ANUAL CANCELADO
        <cfelseif #mov_cancelado# EQ 0>INFORME ANUAL SE REACTIVO
        </cfif>
    </cfif>
</cfif>
