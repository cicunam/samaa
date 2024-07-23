<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2016 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2016 --->
<!--- JAVASCRIPT para el manejo de el  MENÚ izquerdo de las FT --->

		<style type="text/css">
			body {
				width: 160px;
				margin: 0px;
				padding: 0px;
			}
			table {
				margin: 0px;
				padding: 0px;
			}
		</style>
		<script type="text/javascript">
			// Ejecutar un comando:
			function fEnviarComando(comando, vValida)
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				
				if (comando == 'NUEVO' || comando == 'EDITA')
				{
					// Si existe la función de validación, ejecutarla:
					if (fValidaCamposFt && vValida == true) ValidaOK = fValidaCamposFt();
						
					// Si pasa todas la validación, enviar el comando y los datos del formulario:
					if (ValidaOK) 
					{
						// Actualizar los campos "vTipoComando":
						document.getElementById('vTipoComando').value = comando;
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<document.forms['formFt'].elements.length; c++)
						{
							if (document.forms['formFt'].elements[c].type != 'hidden') document.forms['formFt'].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						if (comando == 'NUEVO') document.getElementById('vTipoComando').value = "NUEVO";
						document.forms['formFt'].submit();
					}
				}
				else if (comando == "LIMPIA")
				{
					fLimpiaValida();
					document.forms['formFt'].reset();
				}
/*				SE REPLAZÓ POR UN MÓDULO GENERAR PARA EL ENVÍO DE LOS ARCHIVOS DE TODO EL SISTEMA
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
*/
				else if (comando == "IMPRIME")
				{
					// Guardar los valores originales de action y target:					
					var vAction = document.forms['formFt'].action;
					var vTarget = document.forms['formFt'].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresión:
					document.forms['formFt'].action = 'ft_imprime.cfm';
					document.forms['formFt'].target = 'vista_preliminar_' + id
					document.forms['formFt'].submit();
					// Reestablecer los valores originales de action y target:
					document.forms['formFt'].action = vAction;
					document.forms['formFt'].target = vTarget;
				}
				else if (comando == "IMPRIMEEJEMPLO")
				{
					// Guardar los valores originales de action y target:					
					var vAction = document.forms['formFt'].action;
					var vTarget = document.forms['formFt'].target;
					// Generar el ID de la vista preliminar:
					var fecha = new Date();
					var id = fecha.getHours().toString() + fecha.getMinutes().toString() + fecha.getSeconds().toString();
					// Abrir la ventana donde se va a desplegar la FT:
					var w = window.open('','vista_preliminar_' + id, 'modal=yes,location=no,menubar=no,titlebar=no,resizable=yes,scrollbars=yes,status=no');
					// Abrir la FT para impresión:
					document.forms['formFt'].action = 'ft_imprime_ejemplo.cfm';
					document.forms['formFt'].target = 'vista_preliminar_' + id
					document.forms['formFt'].submit();
					// Reestablecer los valores originales de action y target:
					document.forms['formFt'].action = vAction;
					document.forms['formFt'].target = vTarget;
				}
				else if (comando == "ENVIA")
				{
					fEnviarSolicitud();
				}
				else if (comando == "CANCELA")
				{
					if ("<cfoutput>#vTipoComando#</cfoutput>" == "NUEVO")
					{
						document.forms['formFt'].action = 'ft_ctic_elimina.cfm';
						document.forms['formFt'].submit();
					}
					else
					{
						document.forms['formFt'].reset();
						// Actualizar los campos "vTipoComando":
						document.getElementById('vTipoComando').value = "EDITA";
						// Habilitar todos los campos del formulario antes de enviar los datos:
						for (c=0; c<document.forms['formFt'].elements.length; c++)
						{
							if (document.forms['formFt'].elements[c].type != 'hidden') document.forms['formFt'].elements[c].disabled = false; 
						}
						// Enviar los datos del formulario:
						document.forms['formFt'].submit();
					}	
				}
				else if (comando == "BORRA")
				{
					if (confirm('¿En realidad desea eliminar permanentemente la solicitud que aparece en pantalla?'))
					{
						document.forms['formFt'].action = 'ft_ctic_elimina.cfm';
						document.forms['formFt'].submit();
					}
				}
				else if (comando == "REGRESA")
				{
					// Regresar al módulo actual:
					window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>'); 
				}
			}
			
			// Ingresar una nueva solicitud:
			function NuevaSolicitud()
			{
				window.location.replace('../ft_selecciona/select_ft_acad.cfm'); 
			}

			<cfif #vTipoComando# EQ 'CONSULTA'>
				// Enviar solicitud:
				function fEnviarSolicitud()
				{
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petición HTTP:
					xmlHttp.open("POST", "../enviar_solicitud.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
					// Regresar al módulo actual:
					//window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					window.location.reload();
				}
				// Devolver solicitud:
				function fDevolverSolicitud(vSituacion, vTipoDevolucion)
				{
					var vValorDevuelve = 0
					var vRazonDevuelve = '';
					// Permitir a la entidad editar y/o imprimir:
					if (vTipoDevolucion == 'IMPRIME' && document.getElementById('chkImprime').checked == true)
					{
						vValorDevuelve = 1
						vRazonDevuelve = 'Para editar y/o imprimir.';
					}
					// Permitir a la entidad re-enviar archivo PDF.
					if (vTipoDevolucion == 'ARCHIVO' && document.getElementById('chkArchivo').checked == true)
					{
						vValorDevuelve = 1
						vRazonDevuelve = 'Para re-enviar documentación anexa (PDF).';
					}
					// En caso de una devolución completa, capturar la razón de la devolución:				
					if (vSituacion == 4) vRazonDevuelve = prompt('Describa brevemente la razón por la que se devuelve la Forma Telegrámica.','');
					// Crear un objeto XmlHttpRequest:
					var xmlHttp = XmlHttpRequest();
					// Generar una petición HTTP:
					xmlHttp.open("POST", "../devolver_solicitud.cfm", false);
					xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
					// Crear la lista de parámetros:
					parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
					parametros += "&vSituacion=" + encodeURIComponent(vSituacion);
					parametros += "&vTipoDevolucion=" + encodeURIComponent(vTipoDevolucion);
					parametros += "&vValorDevuelve=" + encodeURIComponent(vValorDevuelve);
					parametros += "&vRazonDevuelve=" + encodeURIComponent(vRazonDevuelve);
					// Enviar la petición HTTP:
					xmlHttp.send(parametros);
					// Regresar al módulo actual:
					if (vTipoDevolucion == 'IMPRIME' || vTipoDevolucion == 'ARCHIVO')
					{
						window.location.reload();
					}
					else
					{
						window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					}
				}
				// Retirar asunto:
				function fRetirarAsunto()
				{
					if (confirm('¿Está seguro que desea retirar el asunto?'))
					{
						// Crear un objeto XmlHttpRequest:
						var xmlHttp = XmlHttpRequest();
						// Generar una petición HTTP:
						xmlHttp.open("POST", "../../reuniones/retirar_asunto.cfm", false);
						xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
						// Crear la lista de parámetros:
						parametros = "vIdSol=" + encodeURIComponent('<cfoutput>#vIdSol#</cfoutput>');
						// Enviar la petición HTTP:
						xmlHttp.send(parametros);
						// Regresar al módulo actual:
						window.location.replace('<cfoutput>#Session.sModulo#</cfoutput>');
					}	
				}
				// Aplicar corrección a oficio:
				function fAplicarCorreccionOficio()
				{
					window.location.replace('<cfoutput>#vCarpetaRaiz#/sistema_ctic/movimientos/detalle/movimiento.cfm?vIdAcad=#tbSolicitudes.sol_pos2#&vIdMov=#tbSolicitudes.sol_pos12#&vTipoComando=CORRECCION&vIdSolCO=#tbSolicitudes.sol_id#</cfoutput>');
				}
			</cfif>
		</script>