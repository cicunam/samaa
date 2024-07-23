<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 30/10/2017 --->


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