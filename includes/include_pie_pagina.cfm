<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 11/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/08/2018 --->
<!--- CÓDIGO PARA FORMULARIO DE ENVÍO DE CORREO ELECTRÓNICO DE COMENTARIOS Y SUGERENCIAS --->
		<style>
			/* Set black background color, white text and some padding */
			footer {
				background-color: #F4F4F4;
				color: #666;
			}
			.hola-left {
				float: left;
				width: 80%;
				margin:-5px;
				padding-left:20px;
			}
			.hola-right {
				text-align: right;
				padding-right:20px;
			}			
		</style>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>        
		<script language="JavaScript" type="text/JavaScript">
            $(function() {
               $('#cmdEnvia_Comenta').click(function(){
					//alert('HOLA');
 					var vErroresFormulario = '';

					if ($("#vComentarioNombre").val() == '') 
					{
						$("#divComentarioNombre").addClass('has-error has-feedback');
						$("#spanComentarioNombre").addClass('glyphicon glyphicon-remove form-control-feedback');
						if (vErroresFormulario == '')
							vErroresFormulario = 'Los siguientes campos son requeridos:\n'
						vErroresFormulario = vErroresFormulario + "- Nombre\n";
					}

					if ($("#vComentarioCorreo").val() == '')
					{
						$("#divComentarioCorreo").addClass('has-error has-feedback');
						$("#spanComentarioCorreo").addClass('glyphicon glyphicon-remove form-control-feedback');
						if (vErroresFormulario == '')
							vErroresFormulario = 'Los siguientes campos son requeridos:\n'
						vErroresFormulario = vErroresFormulario + "- Correo electronico\n";
					}
					
					if ($("#vComentarioTexto").val() == '') 
					{
						$("#divComentarioTexto").addClass('has-error has-feedback');
						$("#spanComentarioTexto").addClass('glyphicon glyphicon-remove form-control-feedback');
						if (vErroresFormulario == '')
							vErroresFormulario = 'Los siguientes campos son requeridos:\n'
						vErroresFormulario = vErroresFormulario + "- Comentario\n";
					}

					if (vErroresFormulario.length > 0)
					{
						alert(vErroresFormulario);
						//$.alert({
						//	title: 'Los siguentes campos obligatorios:',
						//	content: vErroresFormulario,
						//});
						//alert(vErroresLogin);
						return;
					}
					else if (vErroresFormulario.length == 0)
					{
						$.ajax({
							url: "<cfoutput>#vCarpetaINCLUDE#</cfoutput>/ajax_envia_comentario.cfm",
							type:'POST',
							async: false,
							data: {vComentarioNombre:$("#vComentarioNombre").val(),vComentarioCorreo:$("#vComentarioCorreo").val(),vComentarioTexto:$("#vComentarioTexto").val()},
							success: function(data) {
								//alert(data);
								alert('Su comentario y/o sugerencia se envió satisfactoriamente');
								$('#modalCorreo').modal('hide');
							},
							error: function(data) {
								alert('ERROR AL ENVIAR COMENTARIO');
								$('#modalCorreo').modal('hide');
							},
						});
					}
				});
            });
        </script>        
		<footer style="background-color:#FFFFFF;">
			<div class="well well-sm">
                <div class="hola-left"><h6><strong>&copy; UNAM, CIC, SA, STS / SAMAA V.2</strong></h6></div>
                <div class="hola-right">
                    <span class="glyphicon glyphicon-envelope" style="font-size:18px; cursor:pointer;" title="Comentarios" data-toggle="modal" data-target="#modalCorreo"></span>
                    <span class="glyphicon glyphicon-question-sign" style="font-size:18px; cursor:pointer;" title="Acerca del SAMAA" data-toggle="modal" data-target="#modalAcercaDe"></span>
				</div>
			</div>
			<!--- MODAL PARA ENVIO DE COMNETARIOS Y SUGERENCIAS --->
			<div id="modalCorreo" class="modal fade" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title">Comentarios y sugerencias</h4>
						</div>
						<div class="modal-body">
							<form id="formEnviaComentario" name="formEnviaComentario">
								<div id="divComentarioNombre" class="form-group">
									<label for="nombre">Nombre:</label>
									<input id="vComentarioNombre" type="text" class="form-control" maxlength="254">
									<span id="spanComentarioNombre" class=""></span>
								</div>
								<div id="divComentarioCorreo" class="form-group">
									<label for="correo">Correo electr&oacute;nico:</label>
									<input id="vComentarioCorreo" type="text" class="form-control" maxlength="254">
									<span id="spanComentarioCorreo" class=""></span>
								</div>
								<div id="divComentarioTexto" class="form-group">
									<label for="comentarios">Comentarios:</label>
									<textarea id="vComentarioTexto" class="form-control" rows="5"></textarea>
									<span id="spanComentarioTexto" class=""></span>
								</div>
							</form>
						</div>
						<div class="modal-footer">
							<button id="cmdEnvia_Comenta" type="button" class="btn btn-primary">Enviar comentario</button>
							<button type="button" class="btn" data-dismiss="modal">Cerrar</button>
						</div>
					</div>
				</div>
			</div>
            <!--- MODAL PARA ACERCA DEL SAMAA --->
			<div id="modalAcercaDe" class="modal fade" role="dialog">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal">&times;</button>
							<h4 class="modal-title">Acerca del SAMAA</h4>
						</div>
						<div class="modal-body">
							<p>Sistema para la Administraci&oacute;n de Movimientos Acad&eacute;mico-Administrativos</p>
							<p>Dise&ntilde;ado y desarrollado por personal de la Secretar&iacute;a T&eacute;cnica de Seguimiento</p>
							<p>Versi&oacute;n 2.0</p>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
						</div>
					</div>
				</div>
			</div>
		</footer>