<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 10/11/2017 --->

			<cfoutput>
	            <script type="text/javascript" src="#vCarpetaRaizLogica#/sistema_ctic/comun/java_script/ajax_lista_academicos.js"></script>
			</cfoutput>

			<div class="modal-header modal-header-primary">
				<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title">
					<strong>Comisi&oacute;n Especial de Evaluaci&oacute;n UPEID</strong><br />
					<cfif #vTipoComando# EQ 'NV'>
	                    Agregar nuevo acad&eacute;mico a la comisi&oacute;n especial
                    <cfelseif #vTipoComando# EQ 'ED'>
						Consulta / Edici&oacute;n acad&eacute;mico a la comisi&oacute;n especial
                    <cfelseif #vTipoComando# EQ 'EL'>
						Eliminar acad&eacute;mico a la comisi&oacute;n especial
                    </cfif>
				</h4>
			</div>
			<div class="modal-body" align="left">
				<cfform id="frmMiembroCom" name="frmMiembroCom" class="form-horizontal">
					<cfif #vTipoComando# EQ 'NV'>
                        <cfquery name="tbMiembrosCeUpeid" datasource="#vOrigenDatosSAMAA#">
                            SELECT TOP 1 comision_acd_id + 1 AS vComisionAcdId
                            FROM academicos_comisiones
                            ORDER BY comision_acd_id DESC
                        </cfquery>
                        <!--- JQUERY --->
                        <script language="JavaScript" type="text/JavaScript">
                            $(function() {
                               $('#cmdGuardaMiembro').click(function(){
                                    $.ajax({
                                        async: false,
                                        url: "guardar_registros.cfm",
                                        type:'POST',
                                        data: new FormData($('#frmMiembroCom')[0]),
                                        processData: false,
                                        contentType: false,
                                        success: function(data) {
                                            if (data == '')
                                                $('#cmdGuardaMiembro').addClass('disabled');
                                                $('#vAcadNom').attr('disabled','disabled');
                                                $('#ssn_nota').attr('disabled','disabled');
                                                //alert(data);
                                            if (data != '')
                                                alert('OCURRI&Oacute; UN ERROR AL AGREGAR MIEMBRO DE LA COMISI&Oacute;N' + data);
                                            //fSesionLista();
                                        },
                                        error: function(data) {
                                            alert('ERROR AL AGREGAR MIEMBRO DE LA COMISI&Oacute;N' + data);
                                            //location.reload();
                                        },
                                    });
                                });
                            });
                            
                            $("#CierraModalAbajo").click(function (e) {
                                if ($('#vTipoComando').val() == 'NV')
                                window.location.reload();
                                //fSesionLista();
                            });	
            
                            $("#CierraModalArriba").click(function (e) {
                                if ($('#vTipoComando').val() == 'NV')
                                window.location.reload();
                                //fSesionLista();
                            });
                        </script>
    
                        <cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
                        <cfinput type="#vTipoInput#" id="comision_clave" name="comision_clave" value="20">
                        <!--- <cfinput type="#vTipoInput#" id="comision_acd_id" name="comision_acd_id" value="#tbMiembrosCeUpeid.vComisionAcdId#"> --->
                        <cfinput type="#vTipoInput#" id="vUrlSelAcad" name="vUrlSelAcad" value="#vCarpetaRaizLogicaSistema#/comun/seleccion_academico.cfm">
                        <div class="form-group">
                            <div class="col-sm-12">
                                <cfinput type="text" name="vAcadNom" id="vAcadNom" value="" placeholder="Escriba el nombre a buscar, presione ENTER y seleccione de la lista a desplegar" class="form-control"  onKeyUp="fBuscaAcademicoNombre();"/>
                                <cfinput type="#vTipoInput#" id="vAcadId" name="vAcadId" value="">
                                <div id="lstAcad_dynamic" style="position:absolute; display:block; width:95%">
                                    <!-- AJAX: Lista desplegable de académicos -->
                                </div>
                            </div>
                        </div>
                        <p>
                            <div id="datos_academico_dynamy"></div>
                        </p>
                    <cfelseif #vTipoComando# EQ 'ED' OR #vTipoComando# EQ 'EL'>
                        <cfquery name="tbMiembrosCeUpeid" datasource="#vOrigenDatosSAMAA#">
                            SELECT 
                            T1.comision_acd_id, T1.presidente,
                            T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
                            C1.dep_nombre,
                            C2.cn_siglas
                            FROM academicos_comisiones AS T1
                            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                            LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave
                            LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave                        
                            WHERE comision_clave = 20
                            AND comision_acd_id = #vComisionAcdId#
                        </cfquery>
    
                        <!--- JQUERY --->
                        <script language="JavaScript" type="text/JavaScript">
                            $(function() {
                               $('#cmdEliminarMiembro').click(function(){
                                    $.ajax({
                                        async: false,
                                        url: "guardar_registros.cfm",
                                        type:'POST',
                                        data: new FormData($('#frmMiembroCom')[0]),
                                        processData: false,
                                        contentType: false,
                                        success: function(data) {
                                            if (data == '')
												window.location.reload();
                                                //alert(data);
                                            if (data != '')
                                                alert('OCURRI&Oacute; UN ERROR AL ELIMINAR AL MIEMBRO DE LA COMISI&Oacute;N' + data);
                                            //fSesionLista();
                                        },
                                        error: function(data) {
                                            alert('ERROR AL ELIMINAR AL MIEMBRO DE LA COMISI&Oacute;N' + data);
                                            //location.reload();
                                        },
                                    });
                                });
                            });
                        </script>
    
                    
                        <cfoutput query="tbMiembrosCeUpeid">
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Acad&eacute;mico:</label>
                                <div class="col-sm-8">
                                    <cfinput type="text" name="vAcadNom" id="vAcadNom" value="#acd_apepat# #acd_apemat#, #acd_nombres#" class="form-control"/>
                                    <cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
                                    <cfinput type="#vTipoInput#" id="vAcadId" name="vAcadId" value="#acd_id#">
                                    <cfinput type="#vTipoInput#" id="vComisionAcdId" name="vComisionAcdId" value="#comision_acd_id#">                                
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Entidad:</label>
                                <div class="col-sm-8"><cfinput type="text" name="vDepNombre" id="vDepNombre" value="#dep_nombre#" class="form-control"/></div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-4 control-label">Presindente:</label>
                                <div class="col-sm-8"><input type="checkbox" name="presidente" id="presidente" value="" <cfif #presidente# EQ 'true'>checked</cfif>></div>
                            </div>
                        </cfoutput>
                    </cfif>
				</cfform>
			</div>
			<div class="modal-footer">
				<cfif #vTipoComando# EQ 'NV'>            
					<button id="cmdGuardaMiembro" type="button" class="btn btn-primary">Agregar</button>
				<cfelseif #vTipoComando# EQ 'EL'>
					<button id="cmdEliminarMiembro" type="button" class="btn btn-danger">Eliminar</button>                
				</cfif>
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>