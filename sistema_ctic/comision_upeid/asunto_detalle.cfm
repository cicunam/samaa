<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/01/2018 --->

            <div class="modal-header modal-header-primary">
                <button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">
					<strong>Comisi&oacute;n Especial de Evaluaci&oacute;n UPEID</strong><br/>
					<cfif vTipoComando EQ 'NV'>Agregar nuevo asunto
					<cfelseif vTipoComando EQ 'ED'>Editar asunto
					<cfelseif vTipoComando EQ 'EL'>Eliminar asunto
                    </cfif>
				</h4>
            </div>
			<div class="modal-body" align="left">
				<cfform id="frmAsunto" name="frmAsunto" class="form-horizontal">
					<cfif vTipoComando EQ 'NV'>
                        <!--- ABRE EL CATÁLOGO DE MOVIMIENTOS --->
                        <cfquery name="ctMovimientos" datasource="#vOrigenDatosSAMAA#">
                            SELECT 
                                (mov_titulo + CASE WHEN mov_clase IS NULL THEN '' ELSE ' ' END + ISNULL(mov_clase,'')) AS mov_titulo
                                ,
                                mov_clave 
                            FROM catalogo_movimiento
                            WHERE mov_status = 1
                        </cfquery>
        
                        <!--- ABRE LA TABLA DE SESIONES QUE SE ENCUENTREN VIGENTES --->
                        <cfquery name="tbSesionesCeUpeidVig" datasource="#vOrigenDatosSAMAA#">
                            SELECT ssn_id, CONVERT(varchar,ssn_fecha,103) AS ssn_fecha FROM sesiones 
                            WHERE ssn_clave = 20
                            AND ssn_fecha >= '#vFechaHoy#'
                            ORDER BY ssn_fecha DESC
                        </cfquery>
                        
                        <!--- NUEVO ASUNTO --->
                        <cfoutput>
                            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/ajax_lista_academicos.js"></script>
                        </cfoutput>
            
                        <!--- JQUERY --->
						<script language="JavaScript" type="text/JavaScript">
                            $(function() {
                               $('#cmdGuardaAsunto').click(function(){
                                    $.ajax({
                                        async: false,
                                        url: "guardar_registros.cfm",
                                        type:'POST',
                                        data: new FormData($('#frmAsunto')[0]),
                                        processData: false,
                                        contentType: false,
                                        success: function(data) {
                                            if (data == '')
                                                $('#cmdGuardaAsunto').addClass('disabled');
                                                $('#vAcadNom').attr('disabled','disabled');
                                                $('#mov_clave').attr('disabled','disabled');
                                                $('#ssn_id').attr('disabled','disabled');
                                                //alert(data);
                                            if (data != '')
                                                alert('OCURRI&Oacute; UN ERROR AL AGREGAR EL ASUNTO' + data);
                                            //fSesionLista();
                                        },
                                        error: function(data) {
                                            alert('ERROR AL AGREGAR EL ASUNTO' + data);
                                            //location.reload();
                                        },
                                    });
                                });
                            });
							$("#CierraModalAbajo").click(function (e) {
								window.location.reload();
								//fSesionLista();
							});	
			
							$("#CierraModalArriba").click(function (e) {
								window.location.reload();
								//fSesionLista();
							});
                        </script>
                       
                        <cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
                        <!--- <cfinput type="#vTipoInput#" id="comision_acd_id" name="comision_acd_id" value="#tbMiembrosCeUpeid.vComisionAcdId#"> --->
                        <cfinput type="#vTipoInput#" id="vUrlSelAcad" name="vUrlSelAcad" value="#vCarpetaRaizLogicaSistema#/comun/seleccion_academico.cfm">
                        <div class="form-group">
                            <div class="col-sm-12">
                                <cfinput type="text" name="vAcadNom" id="vAcadNom" value="" placeholder="Escriba el nombre a buscar, presione ENTER y seleccione de la lista a desplegar" class="form-control" onKeyUp="fBuscaAcademicoNombre();"/>
                                <div id="lstAcad_dynamic" style="position:fixed; width:95%">
                                    <!-- AJAX: Lista desplegable de académicos -->
                                </div>
                                <cfinput type="#vTipoInput#" id="vAcadId" name="vAcadId" value="">
                            </div>
                        </div>
                        <p>
                            <div id="datos_academico_dynamy"></div>
                        </p>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Tipo de asunto a evaluar:</label>
                            <div class="col-sm-8">
                                <cfselect name="mov_clave" id="mov_clave" query="ctMovimientos" queryPosition="below" display="mov_titulo" value="mov_clave" class="form-control">
                                </cfselect>
                            </div>                            
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Sesi&oacute;n asignada:</label>
                            <div class="col-sm-8">
                                <cfselect name="ssn_id" id="ssn_id" query="tbSesionesCeUpeidVig" queryPosition="below" display="ssn_fecha" value="ssn_id" class="form-control">
                                </cfselect>                            
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Adjuntar documentos digitalizados:</label>
                            <div class="col-sm-8"><cfinput type="file" name="selecciona_pdf" id="selecciona_pdf" class="form-control"></div>
                        </div>
                    <cfelse>
                  
                        <!--- CONSULTA ASUNTO --->
                        <cfquery name="tbAsuntoCeUpeid" datasource="#vOrigenDatosSAMAA#">
                            SELECT 
                            T1.asunto_id, T1.evalua_status, T1.ssn_id,
                            T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
                            C1.dep_nombre,
                            C2.cn_siglas,
                            T2.con_clave,
                            C3.mov_titulo
                            FROM evaluaciones_comision_upeid AS T1
                            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                            LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave
                            LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave
                            LEFT JOIN catalogo_movimiento AS C3 ON T1.mov_clave = C3.mov_clave                        
                            WHERE asunto_id = #vAsuntoId#
                        </cfquery>
                        <!--- JQUERY --->
						<script language="JavaScript" type="text/JavaScript">
                            $(function() {
                               $('#cmdEliminarAsunto').click(function(){
                                    $.ajax({
                                        async: false,
                                        url: "guardar_registros.cfm",
                                        type:'POST',
                                        data: new FormData($('#frmAsunto')[0]),
                                        processData: false,
                                        contentType: false,
                                        success: function(data) {
                                            if (data == '')
												window.location.reload();
                                                //alert(data);
                                            if (data != '')
                                                alert('OCURRI&Oacute; UN ERROR AL ELIMINAR EL ASUNTO' + data);
                                            //fSesionLista();
                                        },
                                        error: function(data) {
                                            alert('ERROR AL ELIMINAR EL ASUNTO' + data);
                                            //location.reload();
                                        },
                                    });
                                });
                            });
                        </script>                         
                        
                        <cfoutput query="tbAsuntoCeUpeid">
                                                
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Acad&eacute;mico:</label>
                                <div class="col-sm-8">
                                    <cfinput type="text" name="vAcadNom" id="vAcadNom" value="#acd_apepat# #acd_apemat#, #acd_nombres#" class="form-control"/>
                                    <cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
                                    <cfinput type="#vTipoInput#" id="vAcadId" name="vAcadId" value="#acd_id#">
                                    <cfinput type="#vTipoInput#" id="vAsuntoId" name="vAsuntoId" value="#asunto_id#">                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Proyecto:</label>
                                <div class="col-sm-8"><cfinput type="text" name="vDepNombre" id="vDepNombre" value="#dep_nombre#" class="form-control"/></div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Tipo de asunto a evaluar:</label>
                                <div class="col-sm-8"><cfinput type="text" name="vMovNombre" id="vMovNombre" value="#mov_titulo#" class="form-control"/></div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Asignar a comisi&oacute;n:</label>
                                <div class="col-sm-8"><cfinput type="text" name="vSsnId" id="vSsnId" value="#ssn_id#" class="form-control"/></div>
                            </div>                        
                       </cfoutput>
    <!---
                            <cfif #con_clave# GTE 1 AND #con_clave# LTE 3>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label">Ccn:</label>
                                    <div class="col-sm-8">#con_clave#</div>
                                </div>
                            </cfif>
    
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Adjuntar documentos digitalizados:</label>
                                <div class="col-sm-8"></div>
                            </div>
    --->						

    	            </cfif>
				</cfform>
			</div>
            <div class="modal-footer">
				<cfif vTipoComando EQ 'NV'>
					<button id="cmdGuardaAsunto" type="button" class="btn btn-primary">Agregar</button>
                <cfelseif vTipoComando EQ 'ED' AND #tbAsuntoCeUpeid.ssn_id# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
					<button id="cmdGuardaAsunto" type="button" class="btn btn-success">Guardar</button>
                <cfelseif vTipoComando EQ 'EL' AND #tbAsuntoCeUpeid.ssn_id# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #Session.CeUpeidFiltro.SsnIdCeUpeid# GTE #vNomArchivoFecha#>
					<button id="cmdEliminarAsunto" type="button" class="btn btn-danger">Eliminar</button>
                </cfif>
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
            </div>