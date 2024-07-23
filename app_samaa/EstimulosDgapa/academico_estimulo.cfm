<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 06/06/2022 --->
<!--- FORMULARIO PARA AGREGAR ESTÍMULO A ACADÉMICO  --->
			<cfparam name="vAcdId" default="">

			<cfif #vTipoComando# EQ 'NV'>
                <cfquery name="tbAcademicosEstimulo" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM consulta_academicos_busqueda
                    WHERE acd_id = #vAcdId#
                </cfquery>
			<cfelse>

			</cfif>
                        
			<cfquery name="ctEstimulosDgapa" datasource="#vOrigenDatosCATALOGOS#">
				SELECT * FROM catalogo_pride
				WHERE pride_nivel <> '0'
			</cfquery>
            
			<cfquery name="ctEstimulosDgapaAnt" datasource="#vOrigenDatosCATALOGOS#">
				SELECT * FROM catalogo_pride
				WHERE pride_nivel <> '0' 
				AND orden_samaa = 1
			</cfquery>
            
			<script>
				function fOpcionesHabDes()
				{
					if ($('#pride_clave').val() == '00' || $('#pride_clave').val() == '06' || $('#pride_clave').val() == '07'  || $('#pride_clave').val() == '10')
					{
						$('#divEstimuloIngreso').attr("style","display: none");
						$('#divRenovacion').attr("style","display: none");
						$('#divReingreso').attr("style","display: none");
					}
					else
					{
						$('#divEstimuloIngreso').attr("style","display:");
						$('#divRenovacion').attr("style","display:");
						$('#divReingreso').attr("style","display:");
					}
					//alert($('#ingreso').checked);
					if ($('#pride_clave').val() != '04' || ($('#pride_clave').val() == '04' && $('#ingreso').is(':checked')))
					{$('#divPropuestoND').attr("style","display:none");}
					else
					{$('#divPropuestoND').attr("style","display:");}


					if (($('#pride_clave').val() != '04' && $('#pride_clave').val() != '05') || (($('#pride_clave').val() == '04' || $('#pride_clave').val() == '05') && $('#ingreso').is(':checked')))
					{$('#divRatCaaND').attr("style","display:none");}
					else
					{$('#divRatCaaND').attr("style","display:");}

					if (($('#pride_clave').val() == '06' || $('#pride_clave').val() == '07') ||  (($('#pride_clave').val() != '06' || $('#pride_clave').val() != '07') && $('#ingreso').is(':checked')))
					{
						$('#divRecursoRev').attr("style","display: none");
						$('#recurso_revision').attr('checked', false);
						$('#divDictamenAnt').attr("style","display: none");
					}
					else
					{
						$('#divRecursoRev').attr("style","display:");
					}

					if ($('#recurso_revision').is(':checked')) // && $('#recurso_revision').val('checked')
					{$('#divDictamenAnt').attr("style","display:");}
					else
					{$('#divDictamenAnt').attr("style","display: none");}

					if ($('#pride_clave').val() == '00')
					{
						$('#divEstimuloIngreso').attr("style","display: none");
							$('#ingreso').attr('checked', false);						
						$('#divPropuestoND').attr("style","display: none");
							$('#propuesto_pride_d').attr('checked', false);
						$('#divRatCaaND').attr("style","display: none");
							$('#ratifica_caa_pride_d').attr('checked', false);						
						$('#divRecursoRev').attr("style","display: none");
							$('#recurso_revision').attr('checked', false);						
						$('#divDictamenAnt').attr("style","display: none");						
					}
				}
				
				$(function() {
				   $('#cmdGuardaEstimulo').click(function(){
						var vValidaCampo = false;
											   
						if ($('#pride_clave').val() == '00') vValidaCampo = true;
						if ($('#pride_clave_ant').is(':visible') == true && $('#pride_clave_ant').val() == '00') vValidaCampo = true;

						if(vValidaCampo == false)
						{
							$.ajax({
								async: false,
								url: "ajax/guarda_acd_estimulo.cfm",
								type:'POST',
								data: new FormData($('#frmAcadEstimulo')[0]),
								processData: false,
								contentType: false,
								success: function(data) {
									if (data == '')
										window.location.reload();
									if (data != '')
										alert('OCURRI&Oacute; UN ERROR AL AGREGAR EL ACADEMICO Y ESTIMULO' + data);
									//fSesionLista();
								},
								error: function(data) {
									alert('ERROR AL AGREGAR MIEMBRO DE LA COMISI&Oacute;N' + data);
									//location.reload();
								},
							});
						}
						else
						{
							if ($('#pride_clave').val() == '00')
								alert('DEBE INDICAR EL DICTAMEN DEL ACADEMICO');
							if ($('#pride_clave_ant').val() == '00')
								alert('DEBE INDICAR EL DICTAMEN ANTERIOR DEL ACADEMICO');							
						}
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
			<div class="modal-header modal-header-primary">
				<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title" align="center">
					AGREGAR DICTAMEN DE EST&Iacute;MULO DGAPA<br/> A ACAD&Eacute;MICO
				</h4>                
			</div>
			<div class="modal-body" align="left">
				<cfform id="frmAcadEstimulo" name="frmMiembroCom" class="form-horizontal">
					<cfoutput query="tbAcademicosEstimulo">
                        <cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Asignado al ACTA:</label>
                            <div class="col-sm-8">
								<p class="form-control-static">#vSsnId#</p>
								<cfinput type="#vTipoInput#" id="ssn_id" name="ssn_id" value="#vSsnId#">
							</div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Acad&eacute;mico:</label>
                            <div class="col-sm-8">
								<p class="form-control-static">#nombre_completo_busqueda#</p>
								<cfinput type="#vTipoInput#" id="acd_id" name="acd_id" value="#acd_id#">
							</div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">RFC:</label>
                            <div class="col-sm-8">
								<p class="form-control-static">#acd_rfc#</p>
								<cfinput type="#vTipoInput#" id="acd_rfc" name="acd_rfc" value="#acd_rfc#">
							</div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Entidad:</label>
                            <div class="col-sm-8">
								<p class="form-control-static">#dep_siglas#</p>
								<cfinput type="#vTipoInput#" id="dep_clave" name="dep_clave" value="#dep_clave#">
								<cfinput type="#vTipoInput#" id="dep_ubicacion" name="dep_ubicacion" value="#dep_ubicacion#">                                
							</div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">CCN:</label>
                            <div class="col-sm-8">
								<p class="form-control-static">#cn_siglas#</p>
								<cfinput type="hidden" id="cn_clave" name="cn_clave" value="#cn_clave#">
								<cfinput type="hidden" id="con_clave" name="con_clave" value="#con_clave#">
							</div>
                        </div>
<!---
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Contrato:</label>
                            <div class="col-sm-8"><cfinput type="hidden" id="con_clave" name="con_clave" value="#con_clave#">
                            </div>
                        </div>
--->						
					</cfoutput>                    
					<div class="form-group">
                    	<label class="col-sm-4 control-label">Dictamen:</label>
						<div class="col-sm-8">
							<cfselect id="pride_clave" name="pride_clave" query="ctEstimulosDgapa" display="pride_nombre" value="pride_clave" queryPosition="below" class="form-control" onChange="fOpcionesHabDes();">
								<option value="00">SELECCIONE</option>
							</cfselect>
						</div>
					</div>
					<div id="divEstimuloIngreso" class="form-group" style="display:none;" onChange="fOpcionesHabDes();">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="ingreso" name="ingreso" value="Si" onChange="fOpcionesHabDes();"> Ingreso</label>
						</div>
					</div>
					<div id="divPropuestoND" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="propuesto_pride_d" name="propuesto_pride_d" value="Si"> 
							Propuesto para nivel D</label>
						</div>
					</div>
					<div id="divRatCaaND" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="ratifica_caa_pride_d" name="ratifica_caa_pride_d" value="Si"> 
							Ratificaci&oacute;n de los CAA a popuesta de nivel D</label>
						</div>
					</div>
					<div id="divRecursoRev" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="recurso_revision" name="recurso_revision" value="Si" onChange="fOpcionesHabDes();"> Recurso de revisi&oacute;n</label>
						</div>
					</div>
					<div id="divRenovacion" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="renovacion" name="renovacion" value="Si" onChange="fOpcionesHabDes();"> Renovaci&oacute;n</label>
						</div>
					</div>
					<div id="divReingreso" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label"></label>
						<div class="col-sm-8">
							<label><cfinput type="checkbox" id="reingreso" name="reingreso" value="Si" onChange="fOpcionesHabDes();"> Reingreso</label>
						</div>
					</div>
					<div id="divDictamenAnt" class="form-group" style="display:none;">
                    	<label class="col-sm-4 control-label">Dictamen anterior:</label>
						<div class="col-sm-8">
							<cfselect id="pride_clave_ant" name="pride_clave_ant" query="ctEstimulosDgapaAnt" display="pride_nombre" value="pride_clave" queryPosition="below" class="form-control">
								<option value="00">SELECCIONE</option>
							</cfselect>
						</div>
					</div>                    
					<div class="form-group">
                    	<label class="col-sm-4 control-label">Nota:</label>
						<div class="col-sm-8">
                        	<cfinput type="text" id="estimulo_nota" name="estimulo_nota" value="" class="form-control">
						</div>
					</div>
				</cfform>
			</div>
			<div class="modal-footer">
				<cfif #vTipoComando# EQ 'NV'>            
					<button id="cmdGuardaEstimulo" type="button" class="btn btn-primary">Agregar</button>
				<cfelseif #vTipoComando# EQ 'EL'>
					<button id="cmdEliminarEstimulo" type="button" class="btn btn-danger">Eliminar</button>                
				</cfif>
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>