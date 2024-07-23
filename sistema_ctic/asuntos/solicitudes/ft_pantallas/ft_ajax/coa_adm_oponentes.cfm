<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2022 --->
<!--- FECHA ÚLTIMA MOD.: 02/03/2022 --->
<!--- AGREGA O ELIMINA OPONENTES A UN CONCURSO DE OPOSICIÓN ABIERTO --->

<cfif #vpTipoAdmOpon# EQ 'A'>
    <!--- ALTA DE OPONENTES --->
    <cfquery name="tbSolicitudCoa" datasource="#vOrigenDatosSOLCOA#">
        SELECT * FROM solicitudes
        WHERE solicitud_id = #vpSolicitudId#
    </cfquery>
    <!--- VERIFICA EN LA TABLA DE ACADEMICOS SI EXITE POR MEDIO DE LA CURP --->    
    <cfquery name="tbCoaOponentes" datasource="#vOrigenDatosSAMAA#">
	    SELECT acd_id FROM academicos
	    WHERE acd_curp = '#tbSolicitudCoa.sol_curp#'
    </cfquery>
    <!---    
    <cfif #tbCoaOponentes.RecordCount# EQ 1>
        <!--- SI EXISTE EN LA TABLA DE ACADÉMICOS --->
        <cfoutput>        
            EXISTE #vpSolId# - #vpCoaId# -#tbCoaOponentes.acd_id# - #vpSolicitudId#
        </cfoutput>
    </cfif>
    --->
    <cfif #tbCoaOponentes.RecordCount# EQ 0>
        <!--- NO EXISTE EN LA TABLA DE ACADÉMICOS --->
        <!--- INCLUDE Obtener el siguiente número de académico ACD_ID disponible --->
        <cfinclude template="#vCarpetaRaizLogica#/sistema_ctic/comun/include_acd_id_incrementa.cfm">
        <!---    
        <cfoutput>
             <br/>NO EXISTE: #vAcadId# - #tbSolicitudCoa.sol_curp# - #tbSolicitudCoa.sol_apepat# - #tbSolicitudCoa.sol_apemat# - #tbSolicitudCoa.sol_nombres#
            - #MID(tbSolicitudCoa.sol_curp,11,1)#  - #tbSolicitudCoa.sol_email#
        </cfoutput>
        --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            INSERT INTO academicos
            (acd_id, acd_curp, acd_apepat, acd_apemat, acd_nombres, acd_fecha_nac, pais_clave_nacimiento, inegi_edo_nac_clave, pais_clave , acd_sexo, acd_email, activo, cap_fecha_crea)
            VALUES
            (
                #vAcadId#
                , 
                '#tbSolicitudCoa.sol_curp#'
                , 
                <cfif #tbSolicitudCoa.sol_apepat# NEQ ''>
                    '#tbSolicitudCoa.sol_apepat#'
                <cfelse>NULL</cfif>
                ,
                <cfif #tbSolicitudCoa.sol_apemat# NEQ ''>
                    '#tbSolicitudCoa.sol_apemat#'
                <cfelse>NULL</cfif>
                ,
                <cfif #tbSolicitudCoa.sol_nombres# NEQ ''>
                    '#tbSolicitudCoa.sol_nombres#'
                <cfelse>NULL</cfif>
                ,
                NULL
                ,
                <cfif #MID(tbSolicitudCoa.sol_curp,12,2)# NEQ 'NE'> 
                    'MEX'
                <cfelse>NULL</cfif>
                ,
                <cfif #MID(tbSolicitudCoa.sol_curp,12,2)# NEQ 'NE'> 
                    '#MID(tbSolicitudCoa.sol_curp,12,2)#'
                <cfelse>NULL</cfif>
                ,
                <cfif #MID(tbSolicitudCoa.sol_curp,12,2)# NEQ 'NE'> 
                    'MEX'
                <cfelse>NULL</cfif>
                ,
                <cfif #MID(tbSolicitudCoa.sol_curp,11,1)# EQ 'M'>'F'
                <cfelseif MID(#tbSolicitudCoa.sol_curp#,11,1) EQ 'H'>'M'
                </cfif>
                ,
                '#tbSolicitudCoa.sol_email#'
                ,
                0
                ,
                GETDATE()
            )
        </cfquery>
    </cfif>
    <cfif #tbCoaOponentes.RecordCount# LTE 1>
        <!--- SE AGREGA EN LA TABLA DE OPONENTES --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            INSERT INTO convocatorias_coa_concursa
            (sol_id, coa_id, acd_id, solicitud_id_coa, coa_ganador)
            VALUES
            (
                #vpSolId#
                ,
                '#vpCoaId#'
                , 
                <cfif #tbCoaOponentes.RecordCount# EQ 1>
                    #tbCoaOponentes.acd_id#
                <cfelseif #tbCoaOponentes.RecordCount# EQ 0>
                    #vAcadId#
                <cfelse>
                    NULL
                </cfif>
                , 
                #vpSolicitudId#
                ,
                0
            )
        </cfquery>
        <cfoutput>
            SE AGREGO COMO OPONENTE A #tbSolicitudCoa.sol_apepat# #tbSolicitudCoa.sol_apemat# #tbSolicitudCoa.sol_nombres#
            <!--- #tbSolicitudCoa.sol_curp# --->
        </cfoutput>
    <cfelse>
        ERROR AL AGREGAR AL SOLICITANTE COMO OPONENTE, FAVOR DE CONTACTAR AL ADMINISTRADOR DEL SISTEMA PARA HACER LA CORRECCION PERTINENTE
    </cfif>
<cfelseif #vpTipoAdmOpon# EQ 'E'>
    <!--- BAJA DE OPONENTES --->
    <cfquery datasource="#vOrigenDatosSAMAA#">
        DELETE FROM convocatorias_coa_concursa
        WHERE id = #vpSolicitudId#
    </cfquery>
    SE ELIMIN&Oacute; AL OPONENTE
</cfif>