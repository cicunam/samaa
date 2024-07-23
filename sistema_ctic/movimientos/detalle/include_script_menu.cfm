		<script type="text/javascript">
			// Ejecutar un comando:
			function fEnviarComando(comando, vValida)
			{
				if (comando == 'NUEVO' || comando == 'EDITA' || comando == 'CORRECCION')
				{
					var vValidaOK = true;
					// Validar los datos del formulario:
					if (vValida) vValidaOK = fValidar();
					// Si pasa todas la validación, enviar el comando y los datos del formulario:
					if (vValidaOK) 
					{
						// Actualizar los campos "vTipoComando":
						document.getElementById('vTipoComando').value = comando;
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<document.forms[0].elements.length; c++)
						{
							if (document.forms[0].elements[c].type != 'hidden') document.forms[0].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						document.forms[0].submit();
					}	
				}
				else if (comando == "LIMPIA")
				{
					document.forms[0].reset();
				}
				else if (comando == "ARCHIVOPDF")
				{
					var posTop = document.getElementById('cmdEnvioPdf').offsetTop;
					var posleft = document.getElementById('cmdEnvioPdf').offsetLeft;					
					document.getElementById('ifrmSelArchivo').width = 515;
					document.getElementById('ifrmSelArchivo').height = 200;
					document.getElementById('ifrmSelArchivo').style.top = posTop + 'px';
					document.getElementById('ifrmSelArchivo').style.left = '150px';
					document.getElementById('ifrmSelArchivo').style.display = '';
				}
				else if (comando == "IMPRIME")
				{
					// Solución temporal hasta que ColdFusion permita procesar javascript con CFDOCUMENT:
					if (print) 
					{
						focus();
						print();
					} 
					else 
					{
						var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
						focus();
						document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
						WebBrowser1.ExecWB(6, 1); // Utilizar "1" en lugar de "2" para que aparezca la ventanita de dialogo de impresión.
					}
					// Recargar la página:
					location.reload(false);
					/*
					// Guardar los valores originales de action y target:					
					var vAction = parent.document.forms[0].action;
					var vTarget = parent.document.forms[0].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresión:
					parent.document.forms[0].action = 'mov_imprime.cfm';
					parent.document.forms[0].target = 'vista_preliminar_' + id
					parent.document.forms[0].submit();
					// Reestablecer los valores originales de action y target:
					parent.document.forms[0].action = vAction;
					parent.document.forms[0].target = vTarget;
					*/
				}
				else if (comando == "CANCELA")
				{
					<cfif #vTipoComando# IS 'NUEVO'>
						document.forms[0].action = 'mov_elimina.cfm';
						document.forms[0].submit();
					<cfelseif #vTipoComando# IS 'EDITA'>
						document.getElementById('vTipoComando').value = "CONSULTA";
						document.forms[0].action = 'movimiento.cfm';
						document.forms[0].submit();
					<cfelse>
						// Regresar al módulo actual:
						window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					</cfif>
				}
				else if (comando == "REGRESA")
				{
					// Regresar al módulo actual:
					//alert('<cfoutput>#Session.sModulo#</cfoutput>');
					window.location.assign('<cfoutput>#Session.sModulo#?vAcadId=#vIdAcad#</cfoutput>');
				}
				<!----------------------------------------------------------------------------------------------------------------------->
				<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
				<!----------------------------------------------------------------------------------------------------------------------->
				<!--- Habilitar esta opción sólo si no es un registro nuevo y hay una solicitud relacionada (sino causa error) --->
				<cfif  #vTipoComando# NEQ 'NUEVO' AND #tbSolicitudes.RecordCount# GT 0>
					else if (comando == "SOLICITUD")
					{
						//alert('<cfoutput>#Application.vCarpetaRaiz#/sistema_ctic/asuntos/solicitudes/' + document.getElementById('vFt').value + '?vIdSol=#tbSolicitudes.sol_id#</cfoutput>')
						window.open('<cfoutput>#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/' + document.getElementById('vFt').value + '?vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vIdSol=#tbSolicitudes.sol_id#&vTipoComando=CONSULTA&vHistoria=1&vActa=0</cfoutput>','solicitud_relacionada', 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no')
					}
					else if (comando == "SOLICITUDIMP")
					{
						window.open('<cfoutput>#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/ft_pantallas/ft_imprime_historia.cfm?vIdSol=#tbSolicitudes.sol_id#&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#</cfoutput>','solicitud_relacionada', 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					}
				</cfif>
			}
			// FUNCIÓN PARA ELIMINAR REGISTROS
			function EliminaRegistro()
			{
				if (confirm('¿En realidad desea eliminar permanentemente el movimiento que aparece en pantalla?'))
				{
					document.forms[0].action = 'mov_elimina.cfm';
					document.forms[0].submit();
				}
			}
			// Preparar el formulario para enviar a impersión:
			function PrepararImpresion()
			{
				// Reemplazar los controles TEXT y TEXTAREA por un SPAN (para evitar que se trunquen los datos):
				c = 0
				while (c < document.forms[0].elements.length)
				{
					if (document.forms[0].elements[c].type == 'text' || document.forms[0].elements[c].type == 'textarea') 
					{
						var cInput = document.forms[0].elements[c];
						var cSpan = document.createElement("span");
						// Crear un SPAN con el contenido original:
						cSpan.className = "Sans9Gr";
						cSpan.innerHTML = document.forms[0].elements[c].value;
						// Remplazar el control anterior por el nuevo control:
						cInput.parentNode.replaceChild(cSpan, cInput);
					}
					else
					{
						c++;
					}
				}
			}
		</script>

		<!--- ******* JQUERY ******* --->
        <script language="JavaScript" type="text/JavaScript">
			// Mostrar el formulario para cargar archivos:
			function fCancelaMovimiento() {
				$('#divCancelaMov_jquery').dialog('open');
			}

			// Ventana del diálogo (jQuery) para LIBERAR EL REGISTRO
			$(function() {
				$('#dialog:ui-dialog').dialog('destroy');
				$('#divCancelaMov_jquery').dialog({
					autoOpen: false,
					height: 200,
					width: 500,
					modal: true,
					maxHeight: 250,
					title:'CANCELAR MOVIMIENTO',
					open: function() {
						$(this).load('mov_ajax/cancela_movimiento.cfm', {vSolId:$('#sol_id').val(), vValorChk:$('#mov_cancelado').is(':checked') ? 1 : 0})
					}
				});
			});				
		</script>        