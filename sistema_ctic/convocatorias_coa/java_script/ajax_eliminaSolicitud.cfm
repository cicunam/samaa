<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 10/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 20/11/2021 --->
<!--- CÓDIGO PARA ELIMIAR SOLICTUDES QUE TENGN ALGÚN PROBLEMA E INTENTAR NUEVAMANTE --->

<!--- SE ELIMINAN LOS REGISTROS DE SOLICITUD --->
<cfquery datasource="#vOrigenDatosSOLCOA#">
    DELETE solicitudes
    WHERE solicitud_id = #vpSolId#
    
    DELETE solicitudes_codigo
    WHERE solicitud_id = #vpSolId#

    DELETE solicitudes_email_verifica
    WHERE solicitud_id = #vpSolId#
</cfquery>

<cfquery datasource="#vOrigenDatosSOLCOA#">
    INSERT INTO solicitudes_bitacora
    (solicitud_id, tipo_movimiento, fecha_bitacora, ip_movimiento, notas)
    VALUES
    (
        #vpSolId#
        ,
        'SOL-ELM'
        ,
        GETDATE()
        ,
        '#CGI.REMOTE_ADDR#'
        ,
        'SE ELIMINO SOLICITUD POR ALGUN PROBLEMA'
    )
</cfquery>
    