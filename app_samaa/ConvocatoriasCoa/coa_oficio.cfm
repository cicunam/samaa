<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/12/2021 --->
<!--- FECHA ÚLTIMA MOD.: 13/01/2022 --->
<!--- DETALLE PARA CONSULTA DE COA  --->

<!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
<cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">
    SELECT * FROM consultaSolicitudes
    WHERE solicitud_id = #vpSolId#
</cfquery>

<!--- LLAMADO A LA BASE DE DATOS DE SOLICITUDES --->
<cfquery name="tbSolCoaOfAcuse" datasource="#vOrigenDatosSOLCOA#">
    SELECT *
    FROM solicitudes_acuseoficio
    WHERE solicitud_id = #vpSolId#
</cfquery>

<cfif #tbSolCoaOfAcuse.RecordCount# EQ 0>
    <cfset vAsuOficioCtic = 'CJIC/CTIC/'>
<cfelse>
    <cfset vAsuOficioCtic = #tbSolCoaOfAcuse.asu_oficio_ctic#>
</cfif>

<!--- LLAMADO A LA BASE DE DATOS DE SAMAA --->
<cfquery name="tbCoa" datasource="#vOrigenDatosSAMAA#">
    SELECT coa_no_plaza, coa_gaceta_fecha_limite
    FROM convocatorias_coa
    WHERE coa_id = '#tbSolCoa.coa_id#'
</cfquery>

<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
    SELECT T1.sol_id, T1.mov_fecha_inicio, T2.acd_id, T2.coa_ganador, CASE WHEN T2.coa_ganador = 1 THEN 'Ganador' ELSE 'Oponente' END AS vTipoGanador
    FROM movimientos AS T1
    LEFT JOIN convocatorias_coa_concursa AS T2 ON T1.coa_id = T2.coa_id
    WHERE T1.coa_id = '#tbSolCoa.coa_id#'
    AND T2.solicitud_id_coa = '#vpSolId#'
</cfquery>

<cfif #tbMovimientos.RecordCount# EQ 0>
    <cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
        SELECT T1.sol_id, T1.mov_fecha_inicio, T2.acd_id, T2.coa_ganador,  CASE WHEN T2.coa_ganador = 1 THEN 'Ganador' ELSE 'Oponente' END AS vTipoGanador
        FROM movimientos_solicitud AS T1
        LEFT JOIN convocatorias_coa_concursa AS T2 ON T1.sol_pos23 = T2.coa_id
        WHERE T1.sol_pos23 = '#tbSolCoa.coa_id#'
        AND T2.solicitud_id_coa = '#vpSolId#'        
    </cfquery>
</cfif>
    
<cfif #tbMovimientos.RecordCount# EQ 1>
    <cfset vSolMov = 'MOVIMIENTO'>
    <cfset vFechaMov = '#tbMovimientos.mov_fecha_inicio#'>    
    <cfset vpartTipo = '#tbMovimientos.vTipoGanador#'>
    <cfset vSamaaSolId = '#tbMovimientos.sol_id#'>
    <cfset vAcdId = '#tbMovimientos.acd_id#'>
<cfelseif #tbMovimientos.RecordCount# EQ 0>
    <cfset vSolMov = 'SOLICITUD'>
    <cfset vFechaMov = '#tbSolicitudes.sol_pos14#'>
    <cfset vpartTipo = '#tbSolicitudes.vTipoGanador#'>
    <cfset vSamaaSolId = '#tbSolicitudes.sol_id#'>
    <cfset vAcdId = '#tbSolicitudes.acd_id#'>
</cfif>
<!--- VARIABLE PARA CONSULTAR OFICIO DIGITALIZADO (12/01/2022) --->
<cfset vArchivoCoaOficio = '#vCarpetaCoaOficios#\#vAcdId#_#vSamaaSolId#.pdf'>        
    
<script language="JavaScript" type="text/JavaScript">    
    function jsfActualizaOficio()
    {
        //alert('HOLA');
        $.ajax({
            async: false,
            url: "java_script/ajax_actualizaSolicitud.cfm",
            type:'GET',
            data: {vpSolId: $('#CoaSolId').val(), vpSamaaSolId: $('#SamaaSolId').val(), vpRegCoaAcuseOf: $('#RegCoaAcuseOf').val(), vpAsuOficioCtic: $('#asu_oficio_ctic').val()},
            contentType: false,
            success: function(data) {
                //alert(data);
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
				alert('Se produjo un error al actualizar el número de oficio');
				//location.reload();
			},
        });
    }
    
    $(function() {
       $('#cmdFileCargaCoaOficio').click(function(){
            $('#cmdFileCargaCoaOficio').css("display","none");
            //$('#divFileLoader').css("display","");

            //alert($('#archivo_rs_1').val())
            if ($('#archivo_oficioctic').val() != '')
            {
                $('#archivo_oficioctic').css("display","none");
                setTimeout(function(){                
                    jsUploadFile();
                }, 50);
            }
            else
            {
                $('#cmdFileCargaCoaOficio').css("display","");
                //$('#divFileLoader').css("display","none");
                $.alert({
                    title: 'Verificando de archivos',
                    content: 'Debe seleccionar al menos un archivo para cargar al servidor',
                });
            }
        });
    });
    
    function jsUploadFile()
    {
        $.ajax({
            url: "java_script/ajax_cargaArchivos.cfm",
            async: false,
            type:'POST',
            data: new FormData($('#frmCoaOficio')[0]),
            processData: false,
            contentType: false,
            success: function(data) {
                //alert(data);
                $('#cmdFileCargaCoaOficio').css("display","");
                $('#archivo_oficioctic').css("display","");
                $('#archivo_oficioctic').val('');
            },
            error: function(data) {
                //alert('data');
                //$('#spanGlyRm'+vForm).css("display","");
                //location.reload();
            },
        });
    }
    function jsfAcuseRecOficio()
    {
        $.ajax({
            async: false,
            url: "java_script/ajax_email.cfm",
            type:'GET',
            data: {vpTipoEmail: 'EOf', vpSolId: $('#CoaSolId').val()},
            contentType: false,
            success: function(data) {
                $.confirm({
                    title: 'Env&iacute;o de correo electr&oacute;nico',
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
</script>    

<cfset vColDP1 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP2 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP12 = 'col-xs-5 col-sm-5 col-md-5 col-lg-5'>    
<cfset vColDP3 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP4 = 'col-xs-3 col-sm-3 col-md-3 col-lg-3'>
<cfset vColDP34 = 'col-xs-7 col-sm-7 col-md-7 col-lg-7'>

<cfset vColDE1 = 'col-xs-10 col-sm-10 col-md-10 col-lg-10'>
<cfset vColDE2 = 'col-xs-2 col-sm-2 col-md-2 col-lg-2'>

<cfset vCol3 = 'col-xs-12 col-sm-12 col-md-12 col-lg-12'> 

<div class="modal-header modal-header-primary">
    <button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
    <h4 class="modal-title" align="center">
        DETALLE DEL CONCURSO DE OPOSICI&Oacute;N ABIERTO, PLAZA No.: <cfoutput>#tbCoa.coa_no_plaza#</cfoutput>
    </h4>                
</div>
<div class="modal-body" align="left">
    <div class="container-fluid">
        <cfoutput query="tbSolCoa">
            <div class="row h4 text-danger"><strong>DATOS DEL CONCURSANTE</strong></div>
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
        </cfoutput>
        <!--- DITUACIÓN DE LA SOLICITUD --->            
        <hr/>
        <!--- INFORMACIÓN DEL COA --->
        <div class="row h4 text-danger"><strong>INFORMACI&Oacute;N SOBRE EL MOVIMIENTO ACAD&Eacute;MICO-ADMINISTRATIVO</strong></div>
            <cfoutput>
            #vSolMov#<br/><br/>
            #vpartTipo#<br/>
            Fecha de inicio: #vFechaMov#<br/>
            #vSamaaSolId#
            </cfoutput>
        <hr/>
        <!--- INFORMACIÓN DEL OFICIO --->
        <div class="row h4 text-danger"><strong>INFORMACI&Oacute;N SOBRE EL OFICIO</strong></div>
        <cfform name="frmCoaOficio" id="frmCoaOficio" class="form-horizontal" enctype="multipart/form-data">
            <div id="divNumOficioCtic" class="form-group">
                <label for="asu_oficio_ctic" class="col-xs-2 col-sm-2 col-md-2 col-lg-2 control-label">N&uacute;mero de oficio:</label>
                <div  id="divNumOficioCtic_i1" class="col-xs-3 col-sm-3 col-md-3 col-lg-3">
                    <cfinput type="text" name="asu_oficio_ctic" id="asu_oficio_ctic" value="#vAsuOficioCtic#" maxlength="20" class="form-control input-sm" onBlur="jsfActualizaOficio();"> <!--- onMouseOut="jsfValudaDup();" --->
                    <span id="span_NumOficioCtic" class=""></span>
                </div>
                <div id="divNumOficioCtic_i2" class="col-xs-7 col-sm-7 col-md-7 col-lg-7">
                    <cfif FileExists(#vArchivoCoaOficio#)>
                            <label for="pdf_oficioctic" class="control-label col-xs-4 col-sm-4 col-md-4 col-lg-4">Consultar oficio:</label>
                            <div id="divPdfOfCtic_i1" class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                            <cfoutput>
                                <a href="../comun/consulta_pdf.cfm?vModulo=SOLCOAOFICIO&vArchivoPdf=#vAcdId#_#vSamaaSolId#.pdf" target="winPdfPfCtic">
                                    <img src="#vCarpetaICONO#/pdf_icon_2017_40.png" title="Oficio digitalizado" width="35px">
                                </a>                                    
                            </cfoutput>
                            </div>
                    </cfif>                    
                </div>
            </div>
            <div id="divArchivoOfCtic" class="form-group">
                <label for="archivo_oficioctic" class="control-label col-xs-2 col-sm-2 col-md-2 col-lg-2">Adjuntar oficio:</label>
                <div id="divArchivoOfCtic_i1" class="col-xs-6 col-sm-6 col-md-6 col-lg-6">
                    <cfinput type="file" name="archivo_oficioctic" id="archivo_oficioctic" value="" class="form-control input-sm">
                </div>
                <div id="divArchivoOfCtic_i2" class="col-xs-4 col-sm-4 col-md-4 col-lg-4">
                    <button name="cmdFileCargaCoaOficio" id="cmdFileCargaCoaOficio" type="button" class="btn btn-primary btn-sm">
                        <span class="glyphicon glyphicon-cloud-upload"></span> CARGAR ARCHIVO
                    </button>                    
                </div>
            </div>
            <cfinput type="#vTipoInput#" id="CoaSolId" name="CoaSolId" value="#vpSolId#">
            <cfinput type="#vTipoInput#" id="AcdId" name="AcdId" value="#vAcdId#">
            <cfinput type="#vTipoInput#" id="SamaaSolId" name="SamaaSolId" value="#vSamaaSolId#">                        
            <cfinput type="#vTipoInput#" id="RegCoaAcuseOf" name="RegCoaAcuseOf" value="#tbSolCoaOfAcuse.RecordCount#">                
        </cfform>
    </div>            
</div>
<div class="modal-footer">
    <cfif FileExists(#vArchivoCoaOficio#)>
        <button id="cmdEnvioEmail" type="button" class="btn btn-info" onClick="jsfAcuseRecOficio();"><span class="glyphicon glyphicon-send"></span> Enviar oficio por correo electr&oacute;nico</button>
    </cfif>        
    <button id="cmdCierraModalAbajo" type="button" class="btn btn-basic" data-dismiss="modal">Cerrar ventana</button>
</div>          