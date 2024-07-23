<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/11/2021 --->
<!--- FECHA ÚLTIMA MOD.: 30/11/2021 --->
<!--- AGREGA O ACTUALIZA SI LA SOLICITUD ES ACEPTADA, RECHAZADA O CANCELADA POR PARTE DE LA ENTIDAD --->
    
    <cfoutput>SOL_ID: #vpSolId# - INPUT:  #vpSolInput#</cfoutput>

    <cfif IsDefined("vpSolId") AND ((IsDefined("vpSolInput") AND #vpSolInput# NEQ '') AND (IsDefined("vpSolInputVal") AND #vpSolInputVal# NEQ ''))>
        <cfoutput> - VALOR: #vpSolInputVal#</cfoutput>

        <!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
        <cfquery datasource="#vOrigenDatosSOLCOA#">
            UPDATE solicitudes
            SET
            <cfif #vpSolInput# EQ 'sol_dep_status'>
                sol_dep_status = #vpSolInputVal#
            </cfif>
            <cfif #vpSolInput# EQ 'sol_dep_notas'>
                sol_dep_statusnotas = '#vpSolInputVal#'
            </cfif>
            <cfif #vpSolInput# EQ 'chkPerReArchivos'>
                sol_reenvioarchivos = <cfif #vpSolInputVal# EQ 1 >1<cfelse>NULL</cfif>
            </cfif>            
            WHERE solicitud_id = #vpSolId#
        </cfquery>
    </cfif>
<!---
    <cfif IsDefined("vpSolId") AND (IsDefined("vpAsuOficioCtic") AND #vpAsuOficioCtic# NEQ '')>
        <cfoutput>  - VALOR: #vpAsuOficioCtic#</cfoutput>        
        
        <!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->        
        <cfif #vpRegCoaAcuseOf# EQ 1>
            <cfquery datasource="#vOrigenDatosSOLCOA#">
                UPDATE solicitudes_acuseoficio
                SET
                asu_oficio_ctic = '#vpAsuOficioCtic#'
                WHERE solicitud_id = #vpSolId#
            </cfquery>
        <cfelseif #vpRegCoaAcuseOf# EQ 0>
            <cfquery datasource="#vOrigenDatosSOLCOA#">
                INSERT INTO solicitudes_acuseoficio
                (solicitud_id, asu_oficio_ctic)
                VALUES(#vpSolId#, '#vpAsuOficioCtic#')
            </cfquery>
        </cfif>
        <!--- ACTUALIZA EL NÚMERO DE OFICIO EN LA TABLA DE COCURSANTES EN COA's --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE convocatorias_coa_concursa
            SET
            asu_oficio_ctic = '#vpAsuOficioCtic#'
            WHERE solicitud_id_coa = #vpSolId#
        </cfquery>
    </cfif>
--->