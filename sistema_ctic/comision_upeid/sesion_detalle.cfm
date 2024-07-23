<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 09/11/2017 --->

            <cfquery name="tbSesionCeUpeid" datasource="#vOrigenDatosSAMAA#">
                SELECT * FROM sesiones 
                WHERE ssn_clave = 20
				AND ssn_id = #vSsnId#
			</cfquery>

			<cfif #vTipoComando# EQ 'NV'>
				<cfset vSsnFecha  = ''>
				<cfset vSsnNota  = ''>
				<cfset vTituloModal = '<strong>Comisi&oacute;n Especial de Evaluaci&oacute;n UPEID</strong><br/>Agregar nueva fecha de reuni&oacute;n '>
			<cfelseif #vTipoComando# EQ 'ED'>
				<cfset vSsnFecha  = #LsDateFormat(tbSesionCeUpeid.ssn_fecha,'dd/mm/yyyy')#>
				<cfset vSsnNota  = #tbSesionCeUpeid.ssn_nota#>
				<cfset vTituloModal = '<strong>Comisi&oacute;n Especial de Evaluaci&oacute;n UPEID</strong><br/>Consulta / Edici&oacute;n de fecha de reuni&oacute;n'>                
			</cfif>
            
			<!--- JQUERY --->
            <script language="JavaScript" type="text/JavaScript">
                $(function() {
                   $('#cmdGuardaSesion').click(function(){
                        $.ajax({
                            async: false,
                            url: "guardar_registros.cfm",
                            type:'POST',
                            data: new FormData($('#frmSsn')[0]),
                            processData: false,
                            contentType: false,
                            success: function(data) {
								if (data == '')
									$('#cmdGuardaSesion').addClass('disabled');
									$('#ssn_fecha').attr('disabled','disabled');
									$('#ssn_nota').attr('disabled','disabled');
								if (data != '')
									alert('OCURRI&Oacute; UN ERROR AL GUARDAR LA INFORMACI&Oacute;N: ' + data);
								//fSesionLista();
                            },
                            error: function(data) {
                                alert('ERROR AL AGREGAR EL FECHA DE COMISI&Oacute;N');
            					//location.reload();
                            },
                        });
                    });
                });
				
				$("#CierraModalAbajo").click(function (e) {
					window.location.reload();
				});	

				$("#CierraModalArriba").click(function (e) {
					window.location.reload();
				});
            </script>
            
            
			<div class="modal-header modal-header-primary">
				<button id="CierraModalArriba" type="button" class="close" data-dismiss="modal">&times;</button>
				<h4 class="modal-title"><cfoutput>#vTituloModal#</cfoutput></h4>
			</div>
			<div class="modal-body">
				<cfform id="frmSsn" name="frmSsn" class="form-horizontal">
					<cfinput type="#vTipoInput#" id="vTipoComando" name="vTipoComando" value="#vTipoComando#">
					<cfinput type="#vTipoInput#" id="ssn_clave" name="ssn_clave" value="20">
					<cfinput type="#vTipoInput#" id="ssn_id" name="ssn_id" value="#vSsnId#">
					<cfoutput>
                        <div class="form-group">
                            <label class="col-sm-4 control-label">Fecha comisi&oacute;n:</label>
							<div class="col-xs-3">
								<cfinput type="text" name="ssn_fecha" id="ssn_fecha" class="form-control" value="#vSsnFecha#" size="10" maxlength="10" placeholder="dd/mm/yyyy" onkeypress="return MascaraEntrada(event, '99/99/9999');"/>
							</div>
                        </div>
                        <div class="form-group">
							<label class="col-sm-4 control-label">Nota:</label>
							<div class="col-sm-8">
								<cfinput type="text" name="ssn_nota" id="ssn_nota" value="#vSsnNota#" class="form-control" />
							</div>
                        </div>
					</cfoutput>
                </cfform>
			</div>
			<div class="modal-footer">
				<button id="cmdGuardaSesion" type="button" class="btn btn-primary">Guardar</button>				
				<button id="CierraModalAbajo" type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
			</div>
