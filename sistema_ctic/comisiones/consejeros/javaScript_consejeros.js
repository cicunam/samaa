/*
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 05/03/2010 --->
<!--- FECHA ULTIMA MOD.: 04/10/2023--->
*/

//Función para activar o desactivar elementos del forumario
			function vActivaDesCampos()
			{
				document.getElementById('trApartir').style.display = 'none'
				document.getElementById('trPeriodo').style.display = 'none'
				document.getElementById('trJefeDepto').style.display = 'none'
				document.getElementById('trOficio').style.display = 'none'
				document.getElementById('trRenunacia').style.display = 'none'
				document.getElementById('trActa').style.display = 'none'
				switch (document.getElementById('adm_clave').value)
				{
					case "01":
						document.getElementById('trActa').style.display = '';
						document.getElementById('trPeriodo').style.display = '';
						if (document.getElementById('vTipoComando').value != 'NUEVO')
						{
							document.getElementById('trRenunacia').style.display = '';
						}
						break
					case "11":
						if (document.getElementById('caa_status').value == 'A')
						{
							document.getElementById('trApartir').style.display = '';
						}
						if (document.getElementById('caa_status').value == 'F')
						{
							document.getElementById('trPeriodo').style.display = '';
						}
						document.getElementById('trOficio').style.display = '';						
						break                        
					case "13":
						document.getElementById('trActa').style.display = '';
						document.getElementById('trPeriodo').style.display = '';
						break
					case "32":
						document.getElementById('trPeriodo').style.display = '';
						document.getElementById('trOficio').style.display = '';
						if (document.getElementById('vTipoComando').value != 'NUEVO')
						{
							document.getElementById('trRenunacia').style.display = '';
						}
						break
					case "82":
						if (document.getElementById('caa_status').value == 'A')
						{
							document.getElementById('trApartir').style.display = '';
						}
						if (document.getElementById('caa_status').value == 'F')
						{
							document.getElementById('trPeriodo').style.display = '';
						}
						document.getElementById('trOficio').style.display = '';						
						break
					case "84":
						document.getElementById('trPeriodo').style.display = '';
						document.getElementById('trOficio').style.display = '';
						document.getElementById('dep_clave').value = '030101';
//						document.getElementById('trNombreFirma').style.display = '';
//						document.getElementById('trNombreSiglas').style.display = '';
						break
				}
				switch (document.getElementById('adm_clave').value.substring(0,1))
				{
					case "5":
						document.getElementById('trJefeDepto').style.display = '';
						document.getElementById('trApartir').style.display = '';
						document.getElementById('trActa').style.display = '';
						break
				}
			}
			// FUNCIÓN PARA DIRECCIONAR LA ACCION DE LOS BOTONES:
			function fSubmitFormulario(vComandoSel)
			{
				var ValidaOK = true; // El valor predeterminado de la validación es VERDADERO;
				if (vComandoSel == 'EDITA')
				{
					document.getElementById('vTipoComando').value = 'EDITA'
					document.forms[0].method = 'get';	
					document.forms[0].action = 'consejero_ctic.cfm';
					document.forms[0].submit();
				}
				if (vComandoSel == 'GUARDA')
				{
					if (fValidaCamposConsejerosCtic) ValidaOK = fValidaCamposConsejerosCtic();
					if (ValidaOK)
					{
						document.forms[0].action = 'consejero_ctic_guarda.cfm';
						document.forms[0].method = 'post';
						document.forms[0].submit();
					}
				}
				if (vComandoSel == 'ELIMINAR')
				{
					if (confirm('¿Desea eliminar el registro?'))
					{
						document.getElementById('vTipoComando').value = 'ELIMINAR'
						document.forms[0].action = 'consejero_ctic_guarda.cfm';
						document.forms[0].submit();
					}
				}
				if (vComandoSel == 'CANCELA')
				{
					if (document.getElementById('vTipoComando').value == 'NUEVO')
					{
						window.location = 'consejeros_ctic_inicio.cfm';
					}
					else if (document.getElementById('vTipoComando').value == 'EDITA')
					{
						window.history.go(-1);
					}
				}
				if (vComandoSel == 'REGRESA')	
				{
					window.location = 'consejeros_ctic_inicio.cfm';
				}
			}

			// FUNCIÓN PARA VALIDAR LOS CAMPOS DEL FORMULARIO:
			function fValidaCamposConsejerosCtic()
			{
				var vOk;
				var vMensaje = '';
				fLimpiaValida();
				if (document.getElementById('vAcadNom').value == '' || document.getElementById('vSelAcad').value == '')
				{
					document.getElementById('vAcadNom').style.backgroundColor = '#FC8C8B'
					vMensaje += 'Campo: ACADÉMICO es requerido.\n'
				}			
				vMensaje += fValidaCampoLleno('adm_clave','CARGO');
				vMensaje += fValidaCampoLleno('dep_clave','ENTIDAD');
				if (document.getElementById('trApartir').style.display == '')
				{
					vMensaje += fValidaCampoLleno('caa_apartir','A PARTIR DEL');
					vMensaje += fValidaFecha('caa_apartir','A PARTIR DEL');
				}
				if (document.getElementById('trPeriodo').style.display == '')
				{
					vMensaje += fValidaCampoLleno('caa_fecha_inicio','PERIODO DEL');
					vMensaje += fValidaFecha('caa_fecha_inicio','PERIODO DEL');
					vMensaje += fValidaFecha('caa_fecha_final','PERIODO AL');			
				}
				if (document.getElementById('trActa').style.display == '')		
				{
					vMensaje += fValidaCampoLleno('ssn_id','ACTA');
				}
				if (document.getElementById('trOficio').style.display == '')			
				{
					vMensaje += fValidaCampoLleno('caa_oficio','NÚMERO DE OFICIO');
				}
				if (vMensaje.length > 0) 
				{
					alert(vMensaje);
					return false;
				}
				else
				{
					return true;
				}
			}
			// CALCULA LA FECHA FINAL DEL PERIODO:
			function CalcularSiguienteFecha()
			{
				if (document.getElementById("adm_clave").value != '84')
				{
					var dia;
					var mes;
					var ano;
					// Verificar que haya una fecha con que trabajar:
					if (document.getElementById("caa_fecha_inicio").value == '')
					{
						return;
					}
					else
					{
						dia = document.getElementById("caa_fecha_inicio").value.substring(0,2);
						mes = document.getElementById("caa_fecha_inicio").value.substring(3,5);
						ano = document.getElementById("caa_fecha_inicio").value.substring(6,10);
					}
					// Crear un objeto tipo date:
					ff = new Date(ano, mes-1, dia);
					// Sumar años:
					if (document.getElementById("adm_clave").value == '01' || document.getElementById("adm_clave").value == '13' || document.getElementById("adm_clave").value == '32' || document.getElementById("adm_clave").value == '84')
					{
						if (('' + ff.getYear()).length < 4) aa = ff.getYear() + 1900; else aa = ff.getYear();
						ff.setYear(aa + 4);
					}	
/*
					else if (document.getElementById("adm_clave").value == '01')
					{
						if (('' + ff.getYear()).length < 4) aa = ff.getYear() + 1900; else aa = ff.getYear();
						ff.setYear(aa + 4);
					}
					else
					{
					}
*/
					// Restar un día a la fecha obtenida:
					ff.setDate(ff.getDate() - 1);
					//alert(ff)			
					// TEMPORAL -->
					// if (document.getElementById("caa_fecha_final")) document.getElementById("caa_fecha_final").value = dateFormat(ff);
					// <-- TEMPORAL
					// Actualizar el siguiente campo:
					document.getElementById("caa_fecha_final").value = dateFormat(ff);
				}
				else if (document.getElementById("adm_clave").value == '01')
				{
					document.getElementById("caa_fecha_final").value = document.getElementById("vConsejeroPeriodo").value;
				}	
			}
			function dateFormat(dd)
			{
				var dia = '00' + dd.getDate();
				var mes = '00' + (dd.getMonth() + 1);
				// Obtener el año de la fecha:
				if (('' + dd.getYear()).length < 4) aa = dd.getYear() + 1900; else aa = dd.getYear();
				// Regresar la fecha en formato "dd/mm/aaaa":
				return dia.substring(dia.length - 2) + '/' + mes.substring(mes.length - 2) + '/' + aa;
			}

			function fChkRenuncia()
			{
				if ($('#renuncia').prop("checked") == true)
				{$('#caa_status').val('R');}
				else
				{$('#caa_status').val('A');}
			}