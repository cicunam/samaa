<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/05/2023 --->
<!--- FECHA ÚLTIMA MOD.: 30/01/2024 --->
<!--- DETALLE PARA CONSULTA DE COA  --->


<cfset vColDP1 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP2 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP12 = 'col-xs-5 col-sm-5 col-md-5 col-lg-5'>    
<cfset vColDP3 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP4 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP34 = 'col-xs-7 col-sm-7 col-md-7 col-lg-7'>

<cfset vColDE1 = 'col-xs-10 col-sm-10 col-md-10 col-lg-10'>
<cfset vColDE2 = 'col-xs-2 col-sm-2 col-md-2 col-lg-2'>

<cfset vCol3 = 'col-xs-12 col-sm-12 col-md-12 col-lg-12'>    
    
<!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
<cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">
    SELECT * FROM consultaSolicitudes
    WHERE solicitud_id = #vpSolId#
</cfquery>
    
<!--- LLAMADO A LA BASE DE DATOS DE SAMAA --->
<cfquery name="tbCoa" datasource="#vOrigenDatosSAMAA#">
    SELECT coa_no_plaza, coa_gaceta_fecha_limite
    FROM convocatorias_coa
    WHERE coa_id = '#tbSolCoa.coa_id#'
</cfquery>

<!--- LLAMADO A LA BASE DE DATOS DE SAMAA --->
<cfquery name="tbCoaDocs" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM convocatorias_coa_presdoc
    WHERE coa_id = '#tbSolCoa.coa_id#'
    ORDER BY presdoc_indice
</cfquery>

<script language="JavaScript" type="text/JavaScript">    
    function jsfAcuseRec(vTipoCorreo, vSolId)
    {
        $.ajax({
            async: false,
            url: "java_script/ajax_email.cfm",
            type:'GET',
            data: {vpTipoEmail: vTipoCorreo, vpSolId: vSolId},
            contentType: false,
            success: function(data) {
                $.confirm({
                    title: 'Env&iacute;o de correo electr&oacute;nico',
                    content: data,
                    buttons: {
                        confirm: {
                            text: 'OK',
                            action: function() {
                                if (vTipoCorreo == 'vTipoCorreo')
                                {location.reload();}
                            }
                        }
                    }
                });                
            },
			error: function(data) {
				alert(data);
				//location.reload();
			},
        });
    }
    function jsfEliminaSol(vSolId)
    {
        $.ajax({
            async: false,
            url: "java_script/ajax_eliminaSolicitud.cfm",
            type:'GET',
            data: {vpSolId: vSolId},
            contentType: false,
            success: function(data) {
                $.confirm({
                    title: 'Se ha eliminado la solicitud: ' + vSolId,
                    content: data,
                    buttons: {
                        confirm: {
                            text: 'OK',
                            action: function() {
                                {location.reload();}
                            }
                        }
                    }
                });                
            },
			error: function(data) {
				alert(data);
				//location.reload();
			},
        });
    }
    
    function jsfActualizaEntStatus(vSolInput, vSolId)
    {
        //alert(vSolInput);
        //alert(vSolId);        
        //alert($('#'+vSolId+'_'+vSolInput).val());
        if (vSolInput == 'chkPerReArchivos')
        {
            if ($('#'+vSolId+'_'+vSolInput).is(':checked'))
            {vpSolInputVal = 1}
            else
            {vpSolInputVal = 0}
        }
        else
        {vpSolInputVal =  $('#'+vSolId+'_'+vSolInput).val()}
        
        $.ajax({
            async: false,
            url: "java_script/ajax_actualizaSolicitud.cfm",
            type:'GET',
            data: {vpSolId: vSolId, vpSolInput: vSolInput, vpSolInputVal: vpSolInputVal},
            contentType: false,
            success: function(data) {
                //alert('SE ACTUALIZO'+data);
                /*
                $.confirm({
                    title: 'Se ha eliminado la solicitud: ' + $('#SolId').val(),
                    content: data,
                    buttons: {
                        confirm: {
                            text: 'OK',
                            action: function() {
                                {location.reload();}
                            }
                        }
                    }
                });                
                */
            },
			error: function(data) {
				alert(data);
				//location.reload();
			},
        });
    }

</script>
<div class="modal-header modal-header-primary">
    <button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title" align="center">
        DETALLE DEL SOLICITANTE A SER CONSIDERADO EN LA PLAZA N&Uacute;MERO <cfoutput>#tbCoa.coa_no_plaza#</cfoutput>
    </h4>                
</div>
<div class="modal-body" align="left">
    <div class="container-fluid">
        <cfoutput query="tbSolCoa">
            <div class="row h4 text-danger"><strong>DATOS DEL SOLICITANTE</strong></div>
            <div class="row h5">
                <div class="#vColDP1#"><strong>Primer apellido:</strong></div><div class="#vColDP2#">#sol_apepat#</div>
                <div class="#vColDP3#"><strong>Correo electr&oacute;nico:</strong></div><div class="#vColDP4#">#sol_email#</div>                
            </div>
            <div class="row h5">
                <div class="#vColDP1#"><strong>Segundo apellido:</strong></div><div class="#vColDP2#">#sol_apemat#</div>
                <div class="#vColDP3#"><strong>Tel&eacute;fono fijo:</strong></div><div class="#vColDP4#">#sol_telefonof#</div>
            </div>
            <div class="row h5">
                <div class="#vColDP1#"><strong>Nombre(s):</strong></div><div class="#vColDP2#">#sol_nombres#</div>
                <div class="#vColDP3#"><strong>Tel&eacute;fono m&oacute;vil:</strong></div><div class="#vColDP4#">#sol_telefonom#</div>
            </div>
            <div class="row h5">
                <div class="#vColDP1#"><strong>Nacionalidad:</strong></div><div class="#vColDP2#">#pais_nacionalidad#</div>
                <div class="#vColDP3#"><strong></strong></div><div class="#vColDP4#"></div>
            </div>
            <div class="row h5">
                <div class="#vColDP1#"><strong>CURP:</strong></div><div class="#vColDP2#">#sol_curp#</div>
                <div class="#vColDP34#"><cfif #sol_curptemp# EQ 1><strong class="text-danger">CURP temporal y v&aacute;lida solo para el registro de la solicitud</strong></cfif></div>
            </div>
<!---            
            <div class="row h5">
                <div class="#vColDE1#">
                    <strong>Para ser considerdo en la plaza n&uacute;mero: </strong>#Mid(tbSolCoa.coa_id,6,8)#
                </div>
            </div>
            <hr/>
--->
        </cfoutput>
        <hr/>
        <!--- DOCUMENTOS ADJUNTOS A LA SOLICITUD --->
        <div class="row h4 text-danger"><strong>DOCUMENTOS DIGILTALIZADOS ADJUNTOS</strong></div>
        <cfoutput query="tbCoaDocs">
            <cfset vArchivo = '#vCarpetaSolicitudCOA#\#vpSolId#_rs_#presdoc_indice#.pdf'>
            <div class="row h5">
                <div class="#vColDE1#">
                    #presdoc_descrip#
                    <!--- SE AGREGÓ ESTA NOTA PARA LOS COA's DE ARTÍCULO 51 23/05/2022 --->
                    <cfif #presdoc_indice# EQ 7>
                        <br/>
                        <small style="color: saddlebrown;"><strong>Nota importante: </strong>En caso de requerir los documentos de inscripci&oacute;n al subprograma, favor de solicitarlos directamente a la Mtra. Ana Brull, asistente del Secretario Acad&eacute;mico de la CIC.</small>
                    </cfif>
                </div>
                <div class="#vColDE2#">
                    <!--- DIV PARA CONSULTA DE ARCHIVO --->
                    <cfif FileExists(#vArchivo#)>
                        <cfdirectory filter="#vpSolId#_rs_#presdoc_indice#.pdf" directory="#vCarpetaSolicitudCOA#\" action="list" name="vFileSize">
                        <cfif #vFileSize.size# GT 1048576>
                            <cfset vTamArch = (#vFileSize.size# / 1024) / 1024>
                            <cfset vTamArch = LsNumberFormat(#vTamArch#,'999,999')>
                            <cfset vTamArch = '#vTamArch# Mb'>
                        <cfelseif #vFileSize.size# LT 1048576>
                            <cfset vTamArch = LsNumberFormat(#vFileSize.size# / 1024,999)>
                            <cfset vTamArch = '#vTamArch# Kb'>
                        </cfif>
                        <a href="../comun/consulta_pdf.cfm?vModulo=SOLCOA&vArchivoPdf=#vpSolId#_rs_#presdoc_indice#.pdf" target="winSolConsDoc">
                            <img src="#vCarpetaICONO#/pdf_icon_2017_40.png" title="Documento anexo: #presdoc_descrip#" width="35px">
                        </a>
                        <span class="text-muted small"><strong>#vTamArch#</strong></span>
                    </cfif>
                </div>
            </div>
        </cfoutput>
        <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0 AND (#tbSolCoa.solicitud_status# GTE 5 AND #tbSolCoa.solicitud_status# LTE 6)>
            <div style="row">
                <cfoutput>                
                    <h5 class="text-danger"><input type="checkbox" name="#vpSolId#_chkPerReArchivos" id="#vpSolId#_chkPerReArchivos" <cfif #tbSolCoa.sol_reenvioarchivos# EQ 1>checked</cfif> onClick="jsfActualizaEntStatus('chkPerReArchivos', '#vpSolId#');"> <strong>Permitir reemplazar archivos a la solicitud ya enviadas a la enidad</strong></h5>
                </cfoutput>
            </div>
        </cfif>
        <!--- DITUACIÓN DE LA SOLICITUD --->            
        <hr/>            
        <cfoutput query="tbSolCoa">
            <div class="row h4 text-danger">
                <div class="#vColDP12#">
                    <strong>SITUCI&Oacute;N DE LA SOLICITUD</strong>
                </div>
            </div>
            <div class="row h5">
                <div class="#vColDP12#">
                    <strong>
                        <cfif #solicitud_status# EQ '' OR #solicitud_status# EQ '0'>
                            <strong class="text-danger">Validando email</strong>
                        <cfelseif #solicitud_status# GTE '1' AND #solicitud_status# LTE '3'>
                            <cfif #datediff("d",now(),tbCoa.coa_gaceta_fecha_limite)# LT 0>
                                <strong class="text-danger">Solicitud fuera de tiempo</strong>
                            <cfelse>
                                <strong class="text-danger">En captura</strong>
                            </cfif>
                        <cfelseif #solicitud_status# GTE '5'>
                            <strong class="text-info">                            
                               <cfif #solicitud_status# EQ '5'>
                                    Enviada a la entidad
                                <cfelseif #solicitud_status# EQ '6'>
                                    En revisi&oacute;n en la entidad
                                </cfif>
                            </strong>
                            <p class="h6">
                                <strong>Fecha de env&iacute;o de la solicitud electr&oacute;nica a la entidad: </strong><br/>#LsDateFormat(fecha_envio,'dd - mmmm - yyyy HH:mm')#
                                <cfif #solicitud_status# EQ '6'>                                
                                    <br/><br/>
                                    <strong>Se recibi&oacute; la solicitud y se envi&oacute; notificaci&oacute;n de acuse de recibo por correo electr&oacute;nico con fecha:</strong><br/>#LsDateFormat(fecha_acuse,'dd - mmmm - yyyy HH:mm')#
                                </cfif>
                            </p>                            
                        </cfif>
                    </strong>
                </div>
                <div class="#vColDP34#">
                    <cfif #datediff("d",now(),tbCoa.coa_gaceta_fecha_limite)# LT 0>
                        <cfoutput>
                            <div id="divSolStatusDep" class="form-group">
                                <label for="#vpSolId#_sol_dep_status">La soliciud es:</label>
                                    <select name="#vpSolId#_sol_dep_status" id="#vpSolId#_sol_dep_status" onChange="jsfActualizaEntStatus('sol_dep_status', '#vpSolId#');" class="form-control input-sm" selected="1">
                                        <option value="" <cfif #tbSolCoa.sol_dep_status# EQ ''>selected</cfif>>Seleccione</option>
                                        <option value="1" <cfif #tbSolCoa.sol_dep_status# EQ '1'>selected</cfif>>Aceptada</option>
                                        <option value="2" <cfif #tbSolCoa.sol_dep_status# EQ '2'>selected</cfif>>Rechazada</option>
                                        <option value="4" <cfif #tbSolCoa.sol_dep_status# EQ '4'>selected</cfif>>Declin&oacute; participaci&oacute;n</option>
                                        <option value="3" <cfif #tbSolCoa.sol_dep_status# EQ '3'>selected</cfif>>Cancelada</option>
                                    </select>
                                    <span id="span_status_dep" class=""></span>
                            </div>
                            <div id="divSolStatusMot" class="form-group">
                                <label for="#vpSolId#_sol_dep_notas">Notas:</label>
                                <textarea type="text" name="#vpSolId#_sol_dep_notas" id="#vpSolId#_sol_dep_notas" maxlength="490" rows="4" class="form-control" onBlur="jsfActualizaEntStatus('sol_dep_notas', '#vpSolId#');">#tbSolCoa.sol_dep_statusnotas#</textarea><!--- disabled="#vHabDesControles#"--->
                                <span class="small">M&aacute;ximo 500 caracteres</span>
                            </div>
                        </cfoutput>
                    </cfif>
                </div>
            </div>
        </cfoutput>
    </div>            
</div>
<div class="modal-footer">
    <cfoutput>
        <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0>
            <cfif #tbSolCoa.solicitud_status# EQ '' OR #tbSolCoa.solicitud_status# LTE '2'>
                <button id="cmdConsultaSol" type="button" class="btn btn-danger" onClick="jsfEliminaSol(#vpSolId#);"><span class="glyphicon glyphicon-trash"></span> Eliminar solicitud</button>
            </cfif>
            <button id="cmdConsultaSol" type="button" class="btn btn-info" onClick="frmConsSol#vpSolId#.submit();"><span class="glyphicon glyphicon-open"></span> Acceder a consultar solicitud</button>
            <button id="cmdEnvioEmail" type="button" class="btn btn-info" onClick="jsfAcuseRec('RE', #vpSolId#);"><span class="glyphicon glyphicon-send"></span> Reenviar correo electr&oacute;nico</button>
            <cfif #tbSolCoa.solicitud_status# EQ '5'>
                <button id="cmdEnvioEmailEs" type="button" class="btn btn-info" onClick="jsfAcuseRec('ES', #vpSolId#);"><span class="glyphicon glyphicon-send"></span> Enviar correo electr&oacute;nico ES</button>
            </cfif>
        </cfif>
        <cfif #tbSolCoa.solicitud_status# EQ '5' AND #Session.sTipoSistema# EQ 'sic'>
            <button id="cmdAcuseRecibo" type="button" class="btn btn-success" onClick="jsfAcuseRec('AR', #vpSolId#);"><span class="glyphicon glyphicon-send"></span> Enviar acuse de recibo</button>
        </cfif>
        <input type="hidden" id="SolStatus" name="SolStatus" value="#tbSolCoa.solicitud_status#">        
        <input type="hidden" id="SolId" name="SolId" value="#vpSolId#">
        <button id="cmdCierraModalAbajo" type="button" class="btn btn-basic" data-dismiss="modal">Cerrar ventana</button>
        <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0>
            <!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
            <cfquery name="tbSolCoaCodigo" datasource="#vOrigenDatosSOLCOA#">
                SELECT * FROM solicitudes_codigo
                WHERE solicitud_id = #vpSolId#
            </cfquery>        
            <cfform id="frmConsSol#vpSolId#" name="frmConsSol#vpSolId#" action="#vLigaConsultaSolCoa#" method="POST" target="winSolCoa">
                <cfinput name="TipoSolicitud" id="TipoSolicitud" type="Hidden" value="C">
                <cfinput name="SistemaSol" id="SistemaSol" type="Hidden" value="05">
                <cfinput name="CoaId" id="CoaId" type="Hidden" value="#tbSolCoa.coa_id#">
                <cfinput name="cvsid" id="cvsid" type="Hidden" value="#tbSolCoaCodigo.codigo_num#">
                <cfinput name="cvsan" id="cvsan" type="Hidden" value="#tbSolCoaCodigo.codigo_alfanum#">
            </cfform>
        </cfif>
    </cfoutput>
</div>    