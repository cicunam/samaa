<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 01/08/2022 --->
<!--- AJAX PARA EL ENVIO DE CORREOS ELECTRÓNICOS --->
<!--- VALORES:
    AR = ACUSE DE RECIBO; 
    RE: REENVÍO DE CORREO; 
    EOf: ENVÍO NOTIFICACION OFICIO CTIC 
--->

<!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
<cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">
    SELECT *,  
        (ISNULL(sol_nombres, N'') + CASE WHEN sol_nombres IS NULL THEN '' ELSE ' ' END + 
        ISNULL(sol_apepat, N'') + CASE WHEN sol_apepat IS NULL 
        THEN '' ELSE ' ' END + ISNULL(sol_apemat, N'')) AS NombreCompleto
        ,
        SUBSTRING(sol_curp,11,1) AS sexo
        ,
        coa_id
    FROM solicitudes
    WHERE solicitud_id = #vpSolId#
</cfquery>

<!--- LLAMADO A LA BASE DE DATOS DE SAMAA --->
<cfquery name="tbConvocaCoa" datasource="#vOrigenDatosSAMAA#">
    SELECT dep_nombre, ubica_nombre, ubica_lugar, cn_descrip, coa_no_plaza, coa_area
    FROM consulta_convocatorias_coa
    WHERE coa_id = '#tbSolCoa.coa_id#'
</cfquery>

<!--- SELECCIÓN DE EMAIL PARA USO DE SISTEMA DE PRUEBA O PRODUCCIÓN --->
<cfif #CGI.SERVER_PORT# IS '31221'>
    <cfset vEmailConvCoa = 'aramp@unam.mx'>
<cfelse>
    <cfset vEmailConvCoa = '#tbSolCoa.sol_email#'>
</cfif>

<cfif #vpTipoEmail# EQ 'AR'>
    <!--- ENVIO DE CORREO ELECTRONICO PARA ACUSE DE RECIBIDO (AR) --->
    <cfmail type="html" from="convocatorias.coa@cic.unam.mx" to="#vEmailConvCoa#" subject="Acuse recibo solicitud consideracion COA" username="convocatorias.coa@cic.unam.mx" password="HeeCaCCoa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
        <html>
            <head>
                <meta charset="charset=iso-8859-1">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    .divLiga {
                        width:250px;
                        height:30px;	
                        padding:5px;
                        background-color:##FFFFDF;
                        border-width:1px;
                        border-style:solid;
                        border-color:##CCC;
                        border-top-left-radius: 10px;
                        border-bottom-right-radius: 10px;
                    }
                </style>
            </head>
            <body>
                Estimad<cfif #tbSolCoa.sexo# EQ 'M'>a<cfelse>o</cfif> #tbSolCoa.NombreCompleto#:<br>
                <br>
                Por este medio, se env&iacute;a acuse de recibo por parte de la entidad, de la  solicitud electr&oacute;nica enviada al #tbConvocaCoa.dep_nombre# para ser considerado como  candidato para participar en el COA de la plaza:<br><br>
                <strong>Entidad acad&eacute;mica:</strong> #tbConvocaCoa.dep_nombre#
                <br/>
                <cfif #Session.sUsuarioNivel# EQ 26>
                    <strong>Proyecto UPEID:</strong> #tbConvocaCoa.ubica_nombre#
                    <br/>
                </cfif>
                <strong>Campus:</strong> #tbConvocaCoa.ubica_lugar#
                <br/>
                <strong>Plaza de:</strong> #tbConvocaCoa.cn_descrip#
                <br/>
                <strong>N&uacute;mero de plaza:</strong> #tbConvocaCoa.coa_no_plaza#
                <br/>
                <strong>En el &aacute;rea de:</strong> #tbConvocaCoa.coa_area#
                <br><br>
                En breve se har&aacute; una revisi&oacute;n de los documentos adjuntos. Es importante  se&ntilde;alar que a partir de este momento la direcci&oacute;n o la secretar&iacute;a acad&eacute;mica de  la entidad le notificar&aacute;, por este medio, si es aceptada o rechazada su  solicitud.<br><br>
                Sin m&aacute;s por el momento, reciban un cordial saludo.
                <br/>
                <strong>Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica / UNAM</strong>
                <br/><br/>
                Dudas, comentarios o sugerencias al correo electr&oacute;nico: <a href="mailto:convocatorias.coa@cic.unam.mx"><strong>convocatorias.coa@cic.unam.mx</strong></a>
            </body>
        </html>
    </cfmail>

    <cfquery datasource="#vOrigenDatosSOLCOA#">
        INSERT INTO solicitudes_bitacora
        (solicitud_id, tipo_movimiento, fecha_bitacora, ip_movimiento)
        VALUES
        (
            #vpSolId#
            ,
            'AC-RE'
            ,
            GETDATE()
            ,
            '#CGI.REMOTE_ADDR#'
        )
    </cfquery>        
        
    <cfquery name="tbCargosCaa" datasource="#vOrigenDatosSAMAA#">
        SELECT acd_id FROM SAMAA.dbo.academicos_cargos 
        WHERE caa_status = 'A' 
        AND dep_clave = '#Session.sIdDep#' 
        AND adm_clave = #Session.sUsuarioNivel#
    </cfquery>

    <cfquery datasource="#vOrigenDatosSOLCOA#">
        UPDATE solicitudes
        SET solicitud_status = 6
        ,
        fecha_acuse = GETDATE()
        <cfif #tbCargosCaa.RecordCount# EQ 1>      
            ,
            acuse_caa_id = #tbCargosCaa.acd_id#
        </cfif>
        WHERE solicitud_id = #vpSolId#
    </cfquery>
    Se ha enviado el acuse de recibo al solicitante
<cfelseif #vpTipoEmail# EQ 'RE'>
    <!--- REENVÍO DE CORREO ELECTRÓNICO PARA PARA VALIDAR CORREO ELECTRÓNICO DEL SOLICITANTE (RE) --->    
    <!--- LLAMADO A LA BASE DE DATOS DE SAMAA --->
    <cfquery name="tbConvocaCoa" datasource="#vOrigenDatosSAMAA#">
        SELECT coa_id, dep_nombre, dep_clave, dep_siglas, coa_no_plaza, cn_descrip, coa_area, ubica_lugar, ssn_id, coa_gaceta_num, coa_gaceta_fecha, coa_status
        FROM consulta_convocatorias_coa
        WHERE coa_id = '#tbSolCoa.coa_id#'
    </cfquery>
    <cfif #tbSolCoa.solicitud_status# EQ ''>
        <cfquery name="tbSolVerEmail" datasource="#vOrigenDatosSOLCOA#">
            SELECT * FROM solicitudes_email_verifica
            WHERE solicitud_id = #vpSolId#
        </cfquery>
        <cfmail type="html" from="convocatorias.coa@cic.unam.mx" to="#vEmailConvCoa#" subject="Confirmacion email solicitud consideracion COA" username="convocatorias.coa@cic.unam.mx" password="HeeCaCCoa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
            <html>
                <head>
                    <meta charset="charset=iso-8859-1">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        .divLiga {
                            width:250px;
                            height:30px;	
                            padding:5px;
                            background-color:##FFFFDF;
                            border-width:1px;
                            border-style:solid;
                            border-color:##CCC;
                            border-top-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                        }
                    </style>
                </head>
                <body>
                    Estimad<cfif #tbSolCoa.sexo# EQ 'M'>a<cfelse>o</cfif> #tbSolCoa.NombreCompleto#:<br>
                    <br>
                    Por este medio, se solicita valide su correo electrónico para continuar con el registro como candidato para ser considerado en el Concurso de Oposici&oacute;ón Abierto, con el objeto de ocupar la plaza:
                    <br><br>
                    <strong>Entidad acad&eacute;mica:</strong> #tbConvocaCoa.dep_nombre#
                    <br/>
                    <strong>Campi:</strong> #tbConvocaCoa.ubica_lugar#
                    <br/>
                    <strong>Plaza de:</strong> #tbConvocaCoa.cn_descrip#
                    <br/>
                    <strong>N&uacute;mero de plaza:</strong> #tbConvocaCoa.coa_no_plaza#
                    <br/>
                    <strong>En el &aacute;rea de:</strong> #tbConvocaCoa.coa_area#
                    <br><br>
                    Para continuar con el proceso, digite el siguiente c&oacute;digo en la pantalla de captura de la solicitud:
                    <div style="width: 100%; text-align: center;">
                        <div class="divLiga" align="center">#tbSolVerEmail.email_codigo_num#</div>
                    </div>
                    <br><br>
                    Sin m&aacute;s por el momento, reciban un cordial saludo.
                    <br/>
                    <strong>Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica / UNAM</strong>
                    <br/><br/>
                    Dudas, comentarios o sugerencias al correo electrónico: <a href="mailto:convocatorias.coa@cic.unam.mx"><strong>convocatorias.coa@cic.unam.mx</strong></a>
                </body>
            </html>
        </cfmail>
        Se ha enviado correo electr&oacute;nico de validaci&oacute;n
    <cfelseif #tbSolCoa.solicitud_status# GTE 1 AND #tbSolCoa.solicitud_status# LTE 4>
        
        <cfquery name="tbSolicitudes" datasource="#vOrigenDatosSOLCOA#">
            SELECT *
            ,
            (ISNULL(sol_nombres, N'') + CASE WHEN sol_nombres IS NULL THEN '' ELSE ' ' END + 
            ISNULL(sol_apepat, N'') + CASE WHEN sol_apepat IS NULL 
            THEN '' ELSE ' ' END + ISNULL(sol_apemat, N'')) AS NombreCompleto
            ,
            SUBSTRING(sol_curp,11,1) AS sexo
            FROM solicitudes AS T1
            LEFT JOIN solicitudes_codigo AS T2 ON T1.solicitud_id = T2.solicitud_id                    
            WHERE T1.solicitud_id = #vpSolId#
        </cfquery>
        <cfquery name="tbConvocaCoa" datasource="#vOrigenDatosSAMAA#">
            SELECT *
            FROM consulta_convocatorias_coa
            WHERE coa_id = '#tbSolicitudes.coa_id#'
        </cfquery>
        <!--- SELECCIÓN DE EMAIL PARA USO DE SISTEMA DE PRUEBA O PRODUCCIÓN --->
        <cfif #CGI.SERVER_PORT# IS '31221'>
            <cfset vEmailConvCoa = 'aramp@unam.mx'>
        <cfelse>
            <cfset vEmailConvCoa = '#tbSolicitudes.sol_email#'>
        </cfif>
        <cfmail type="html" from="convocatorias.coa@cic.unam.mx" to="#vEmailConvCoa#" subject="Correo validado y acceder a solicitud electronica COA" username="convocatorias.coa@cic.unam.mx" password="HeeCaCCoa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
            <html>
                <head>
                    <meta charset="charset=iso-8859-1">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        .divLiga {
                            width:300px;
                            height:30px;	
                            padding:5px;
                            background-color:##FFFFDF;
                            border-width:1px;
                            border-style:solid;
                            border-color:##CCC;
                            border-top-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                        }
                    </style>
                </head>
                <body>
                    Estimad<cfif #tbSolicitudes.sexo# EQ 'M'>a<cfelse>o</cfif> #tbSolicitudes.NombreCompleto#:<br>
                    <br>
                    Se ha validado el correo electr&oacute;nico. A partir de este momento usted puede acceder a la siguiente liga, para continuar con su proceso de solicitud electr&oacute;nica.<br><br>
                    <div class="divLiga" align="center"><a href="http://www.cic.unam.mx:#CGI.SERVER_PORT#/sistema_solicitudes_registro/?TipoSolicitud=C&SistemaSol=05&CoaId=#tbSolicitudes.coa_id#&cvsid=#tbSolicitudes.codigo_num#&cvsan=#tbSolicitudes.codigo_alfanum#" target="winCoa31101">ACCEDER A REGISTRO DE SOLICITUD</a></div>
                    <br>
                    <br>
                    Esta liga s&oacute;lo es v&aacute;lida para la convocatoria de COA publicada en Gaceta UNAM #tbConvocaCoa.coa_gaceta_num#, de la plaza:</p>
                    <strong>Entidad acad&eacute;mica: </strong>#tbConvocaCoa.dep_nombre#<br>
                    <strong>Campus: </strong>#tbConvocaCoa.ubica_lugar#<br>
                    <strong>Plaza de: </strong>#tbConvocaCoa.cn_descrip#<br>
                    <strong>N&uacute;mero de plaza: </strong>#tbConvocaCoa.coa_no_plaza#<br>
                    <strong>En el &aacute;rea de: </strong>#tbConvocaCoa.coa_area#</p>
                    <br>
                    <br>
                    Sin m&aacute;s por el momento, reciba un cordial saludo.
                    <br/>
                    <strong>Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica / UNAM</strong>
                    <br/><br/>
                    Dudas, comentarios o sugerencias al correo electrónico: <a href="mailto:convocatorias.coa@cic.unam.mx"><strong>convocatorias.coa@cic.unam.mx</strong></a></p>
                </body>
            </html>
        </cfmail>
        Se ha enviado correo electr&oacute;nico para acceder a solicitud
        <cfif #CGI.SERVER_PORT# IS '31221'>
            <br>
            <cfoutput>STATUS DE LA SOLICTUD: #tbSolCoa.solicitud_status#</cfoutput>
        </cfif>
    </cfif>
<cfelseif #vpTipoEmail# EQ 'EOf'>
    <!--- ENVÍO DE OFICIO DEL CTIC (13/01/2022) --->
        <!--- SELECCIÓN DE EMAIL PARA USO DE SISTEMA DE PRUEBA O PRODUCCIÓN PARA SOLICITANTE --->
        <cfif #CGI.SERVER_PORT# IS '31221'>
            <cfset vEmailConvCoa = 'aramp@unam.mx'>
        <cfelse>
            <cfset vEmailConvCoa = '#tbSolicitudes.sol_email#'>
        </cfif>
        <cfmail type="html" from="convocatorias.coa@cic.unam.mx" to="#vEmailConvCoa#" subject="Oficio CTIC COA" username="convocatorias.coa@cic.unam.mx" password="HeeCaCCoa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
            <html>
                <head>
                    <meta charset="charset=iso-8859-1">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        .divLiga {
                            width:300px;
                            height:30px;	
                            padding:5px;
                            background-color:##FFFFDF;
                            border-width:1px;
                            border-style:solid;
                            border-color:##CCC;
                            border-top-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                        }
                    </style>
                </head>
                <body>
                    Estimad<cfif #tbSolCoa.sexo# EQ 'M'>a<cfelse>o</cfif> #tbSolCoa.NombreCompleto#:<br>
                    <br>
<!---                    
                    Se ha validado el correo electr&oacute;nico. A partir de este momento usted puede acceder a la siguiente liga, para continuar con su proceso de solicitud electr&oacute;nica.<br><br>
                    <div class="divLiga" align="center"><a href="http://www.cic.unam.mx:#CGI.SERVER_PORT#/sistema_solicitudes_registro/?TipoSolicitud=C&SistemaSol=05&CoaId=#tbSolicitudes.coa_id#&cvsid=#tbSolicitudes.codigo_num#&cvsan=#tbSolicitudes.codigo_alfanum#" target="winCoa31101">ACCEDER A REGISTRO DE SOLICITUD</a></div>
                    <br>
                    <br>
                    Esta liga s&oacute;lo es v&aacute;lida para la convocatoria de COA publicada en Gaceta UNAM #tbConvocaCoa.coa_gaceta_num#, de la plaza:</p>
                    <strong>Entidad acad&eacute;mica: </strong>#tbConvocaCoa.dep_nombre#<br>
                    <strong>Campus: </strong>#tbConvocaCoa.ubica_lugar#<br>
                    <strong>Plaza de: </strong>#tbConvocaCoa.cn_descrip#<br>
                    <strong>N&uacute;mero de plaza: </strong>#tbConvocaCoa.coa_no_plaza#<br>
                    <strong>En el &aacute;rea de: </strong>#tbConvocaCoa.coa_area#</p>
--->
                    <br>
                    <br>
                    Sin m&aacute;s por el momento, reciba un cordial saludo.
                    <br/>
                    <strong>Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica / UNAM</strong>
                    <br/><br/>
                    Dudas, comentarios o sugerencias al correo electrónico: <a href="mailto:convocatorias.coa@cic.unam.mx"><strong>convocatorias.coa@cic.unam.mx</strong></a></p>
                </body>
            </html>
        </cfmail>
        
        <!--- SE RECOMIENDA GENERAR INCLUDE O MODULE PARA NO DUPLICAR LA GENERACION DE CADENAS --->
        <cfquery name="tbSysClaves" datasource="#vOrigenDatosSAMAA#">
            SELECT top 1
            abs(CHECKSUM(newid())) AS clave_acceso,            
            newid() AS clave_alfanum,
            RAND() AS 'Random'
            FROM sys.tables
        </cfquery>
        <!--- AGREGA BITACORA DE ENVÍO EMAIL --->                    
        <cfquery datasource="#vOrigenDatosSOLCOA#">
            UPDATE solicitudes_acuseoficio
            SET fecha_envio_email = GETDATE()
            ,
            acuse_codigo_num = #tbSysClaves.clave_acceso#
            ,
            acuse_codigo_alfanum = '#tbSysClaves.clave_alfanum#'
            WHERE solicitud_id = #vpSolId#
            ;
            UPDATE solicitudes
            SET solicitud_status = 7
            WHERE solicitud_id = #vpSolId#            
        </cfquery>
            
        <!--- CORREO ELECTRÓNICO PARA SECRETARIO ACADÉMICO --->
        <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
            SELECT dep_clave FROM movimientos
            WHERE coa_id = '#tbSolCoa.coa_id#'
        </cfquery>

        <cfquery name="tbCargosCaa" datasource="#vOrigenDatosSAMAA#">
            SELECT acd_prefijo, nombre_completo_npm, caa_email, acd_email, acd_sexo 
            FROM consulta_cargos_acadadm 
            WHERE caa_status = 'A' 
            AND dep_clave = '#tbMovimientos.dep_clave#' 
            AND adm_clave = 82
        </cfquery>
        <!--- SELECCIÓN DE EMAIL PARA USO DE SISTEMA DE PRUEBA O PRODUCCIÓN PARA LA ENTIDAD ACADÉMICA --->
        <cfif #CGI.SERVER_PORT# IS '31221'>
            <cfset vEmailSecAcad = 'aramp@unam.mx'>
        <cfelse>
            <cfif #tbCargosCaa.caa_email# NEQ ''>
                <cfset vEmailSecAcad = '#tbCargosCaa.caa_email#'>
            <cfelse>
                <cfset vEmailSecAcad = '#tbCargosCaa.acd_email#'>                
            </cfif>
        </cfif>
        <cfmail type="html" from="convocatorias.coa@cic.unam.mx" to="#vEmailSecAcad#" subject="Oficio CTIC COA" username="convocatorias.coa@cic.unam.mx" password="HeeCaCCoa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
            <html>
                <head>
                    <meta charset="charset=iso-8859-1">
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        .divLiga {
                            width:300px;
                            height:30px;	
                            padding:5px;
                            background-color:##FFFFDF;
                            border-width:1px;
                            border-style:solid;
                            border-color:##CCC;
                            border-top-left-radius: 10px;
                            border-bottom-right-radius: 10px;
                        }
                    </style>
                </head>
                <body>
                    Estimad<cfif #tbCargosCaa.acd_sexo# EQ 'F'>a<cfelse>o</cfif> #tbCargosCaa.acd_prefijo# #tbCargosCaa.nombre_completo_npm#,<br>
                    <br>
<!---                    
                    Se ha validado el correo electr&oacute;nico. A partir de este momento usted puede acceder a la siguiente liga, para continuar con su proceso de solicitud electr&oacute;nica.<br><br>
                    <div class="divLiga" align="center"><a href="http://www.cic.unam.mx:#CGI.SERVER_PORT#/sistema_solicitudes_registro/?TipoSolicitud=C&SistemaSol=05&CoaId=#tbSolicitudes.coa_id#&cvsid=#tbSolicitudes.codigo_num#&cvsan=#tbSolicitudes.codigo_alfanum#" target="winCoa31101">ACCEDER A REGISTRO DE SOLICITUD</a></div>
                    <br>
                    <br>
                    Esta liga s&oacute;lo es v&aacute;lida para la convocatoria de COA publicada en Gaceta UNAM #tbConvocaCoa.coa_gaceta_num#, de la plaza:</p>
                    <strong>Entidad acad&eacute;mica: </strong>#tbConvocaCoa.dep_nombre#<br>
                    <strong>Campus: </strong>#tbConvocaCoa.ubica_lugar#<br>
                    <strong>Plaza de: </strong>#tbConvocaCoa.cn_descrip#<br>
                    <strong>N&uacute;mero de plaza: </strong>#tbConvocaCoa.coa_no_plaza#<br>
                    <strong>En el &aacute;rea de: </strong>#tbConvocaCoa.coa_area#</p>
--->
                    <br>
                    <br>
                    Sin m&aacute;s por el momento, reciba un cordial saludo.
                    <br/>
                    <strong>Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica / UNAM</strong>
                    <br/><br/>
                    Dudas, comentarios o sugerencias al correo electrónico: <a href="mailto:convocatorias.coa@cic.unam.mx"><strong>convocatorias.coa@cic.unam.mx</strong></a></p>
                </body>
            </html>
        </cfmail>            

        Se han enviado los correos electr&oacute;nicos de notificación de oficio emitido por el CTIC
</cfif>
    