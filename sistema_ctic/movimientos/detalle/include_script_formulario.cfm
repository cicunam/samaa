<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/19/2009 --->
<!--- FECHA ÚLTIMA MOD.: 06/10/2016 --->
<!--- ESTE CÓDIGO ESTABA INSERTO EN EL FORMULARIO Y SE DECIDIÓ INCLUIRLO EN UN INCLUDE (ARAM) --->

		<script language="JavaScript" type="text/JavaScript">
			// Actualizar el formulario:
			function fActualizar()
			{
				// Obtener ubicación actual: 
				<cfswitch expression="#mov_clave#">
					<cfcase value="5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,25,26,27,28,29,36,38,39,42,70,71,74">
						fObtenerUbicaciones('dep_clave','ubicacion_dynamic','<cfoutput>#dep_ubicacion#</cfoutput>');
					</cfcase>
				</cfswitch>		
				<cfif #mov_clave# IS 13>
					// Obtener ubicación a la que cambia (otra dependencia):
					fObtenerUbicaciones('mov_dep_clave','ubicacion_dynamic_mov','<cfoutput>#mov_dep_ubicacion#</cfoutput>');
				</cfif>
				<cfif #mov_clave# IS 29>
					// Obtener ubicación a la que cambia (misma dependencia):
					fObtenerUbicaciones('dep_clave','ubicacion_dynamic_mov','<cfoutput>#mov_dep_ubicacion#</cfoutput>','mov_dep_ubicacion');
				</cfif>
				<cfswitch expression="#mov_clave#">
						<cfcase value="1,3,4,26,38,40,41">
							// Obtener estados (México, USA):
							fObtenerEstados();	
						</cfcase>	
				</cfswitch>
				<cfif #mov_clave# NEQ 22 AND #mov_clave# NEQ 23>
					// Desglosar duración en:
					fDesglosarDuracion();	
				</cfif>
				<cfif #mov_clave# NEQ 14>
					// Abrir la historia del asuntos para edición:
					fHistoriaAsunto('CONSULTA');
				</cfif>
				<cfif #vTipoComando# EQ 'CORRECCION'>
					// Mostrar mensaje de corrección a oficio (FT-CTIC-31):
					alert("En el formulario aparecen los cambios especificados en la solicitud de corrección a oficio (FT-CTIC-31), si los cambios no son los correctos puede editar el registro de manera manual. Para aplicar los cambios seleccione la opción \"Guardar\" del menú, si no desea aplicar los cambios seleccione la opción \"Cancelar\".");
				</cfif>
			}
			// Validar los datos ingresados por el usuario:
			function fValidar()
			{
				var vOk;
				var vMensaje = '';
				//fLimpiaValida();
				if (document.getElementById('mov_fecha_inicio') && document.getElementById('mov_fecha_inicio').value != '') vMensaje += fValidaFecha('mov_fecha_inicio', '<cfoutput>#ctMovimiento.etq_mov_fecha_inicio#</cfoutput>');
				if (document.getElementById('mov_fecha_final') && document.getElementById('mov_fecha_final').value != '') vMensaje += fValidaFecha('mov_fecha_final', '<cfoutput>#ctMovimiento.etq_mov_fecha_final#</cfoutput>');
				if (document.getElementById('mov_fecha_1') && document.getElementById('mov_fecha_1').value != '') vMensaje += fValidaFecha('mov_fecha_1', '<cfoutput>#ctMovimiento.etq_mov_fecha_1#</cfoutput>');
				if (document.getElementById('mov_fecha_2') && document.getElementById('mov_fecha_2').value != '') vMensaje += fValidaFecha('mov_fecha_2', '<cfoutput>#ctMovimiento.etq_mov_fecha_2#</cfoutput>');
				//if (!hay_decision_CTIC) vMensaje += 'Debe agregar el registro de la decisión del CTIC a la HISTORIA DEl ASUNTO.\n'; /* SE ELIMINO YA QUE PARA AGREGAR SE DEBE GUARDAR PRIMERO EL REGISTRO */
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
			// Reordenar los campos según el movimiento:
			function fReordenar() 
			{
				var Academico = document.getElementById('DatosAcademico');
				var Movimiento = document.getElementById('DatosMovimiento');
				
				var linea_1, linea_2, linea_3, linea_4, linea_5, linea_6, linea_7, linea_8, linea_9, linea_10, linea_11, linea_12, linea_13, linea_14, linea_15, linea_16, linea_17, linea_18, linea_19, linea_20, linea_21, linea_22, linea_23, linea_24, linea_25, linea_26, linea_27, linea_28, linea_29, linea_30, linea_31, linea_32;
				
				if (document.getElementById('linea_1')) linea_1 = document.getElementById('linea_1');		// Dependencia
				if (document.getElementById('linea_2')) linea_2 = document.getElementById('linea_2');		// Ubicación
				if (document.getElementById('linea_3')) linea_3 = document.getElementById('linea_3');		// Académico
				if (document.getElementById('linea_4')) linea_4 = document.getElementById('linea_4');		// Categoría y nivel
				if (document.getElementById('linea_5')) linea_5 = document.getElementById('linea_5');		// Tipo de contrato
				if (document.getElementById('linea_6')) linea_6 = document.getElementById('linea_6');		// Duración (Fechas)
				if (document.getElementById('linea_7')) linea_7 = document.getElementById('linea_7');		// Dependencia (movimiento)
				if (document.getElementById('linea_8')) linea_8 = document.getElementById('linea_8');		// Ubicación (movimiento)
				if (document.getElementById('linea_9')) linea_9 = document.getElementById('linea_9');		// Asesor
				if (document.getElementById('linea_10')) linea_10 = document.getElementById('linea_10');	// Número de Plaza		
				if (document.getElementById('linea_11')) linea_11 = document.getElementById('linea_11');	// Categoría y nivel (movimiento)
				if (document.getElementById('linea_12')) linea_12 = document.getElementById('linea_12');	// Institución
				if (document.getElementById('linea_13')) linea_13 = document.getElementById('linea_13');	// País
				if (document.getElementById('linea_14')) linea_14 = document.getElementById('linea_14');	// Estado
				if (document.getElementById('linea_15')) linea_15 = document.getElementById('linea_15');	// Ciudad
				if (document.getElementById('linea_16')) linea_16 = document.getElementById('linea_16');	// Tipo de cambio
				if (document.getElementById('linea_17')) linea_17 = document.getElementById('linea_17');	// Cargo/Nombramiento 
				if (document.getElementById('linea_18')) linea_18 = document.getElementById('linea_18');	// Periodo (Año/Semestre)
				if (document.getElementById('linea_19')) linea_19 = document.getElementById('linea_19');	// Prorroga
				if (document.getElementById('linea_20')) linea_20 = document.getElementById('linea_20');	// Programa
				if (document.getElementById('linea_21')) linea_21 = document.getElementById('linea_21');	// Causa de baja
				if (document.getElementById('linea_22')) linea_22 = document.getElementById('linea_22');	// Actividad
				if (document.getElementById('linea_23')) linea_23 = document.getElementById('linea_23');	// Texto (variable)
				if (document.getElementById('linea_24')) linea_24 = document.getElementById('linea_24');	// Horas	
				if (document.getElementById('linea_25')) linea_25 = document.getElementById('linea_25');	// Numero (variable)
				if (document.getElementById('linea_26')) linea_26 = document.getElementById('linea_26');	// Goce de sueldo
				if (document.getElementById('linea_27')) linea_27 = document.getElementById('linea_27');	// Erogación
				if (document.getElementById('linea_28')) linea_28 = document.getElementById('linea_28');	// Fecha 1 (variable)
				if (document.getElementById('linea_29')) linea_29 = document.getElementById('linea_29');	// Fecha 2 (variable)
				if (document.getElementById('linea_30')) linea_30 = document.getElementById('linea_30');	// Lógico variable
				if (document.getElementById('linea_31')) linea_31 = document.getElementById('linea_31');	// Memo 1
				if (document.getElementById('linea_32')) linea_32 = document.getElementById('linea_32');	// Memo 2
				if (document.getElementById('linea_33')) linea_33 = document.getElementById('linea_33');	// Movimiento relacionado

				switch (parseInt(document.getElementById('mov_clave').value))
				{
					case 1:
						Movimiento.insertBefore(linea_12,linea_6);
						Movimiento.insertBefore(linea_13,linea_6);
						Movimiento.insertBefore(linea_14,linea_6);
						Movimiento.insertBefore(linea_15,linea_6);
						Movimiento.insertBefore(linea_22,linea_6);
						Movimiento.insertBefore(linea_31,linea_6);
						Movimiento.insertBefore(linea_32,linea_27);
						break;
					case 2:
						Movimiento.insertBefore(linea_31,linea_6);
						Movimiento.insertBefore(linea_12,linea_6);
						break;
					case 3:
						Movimiento.insertBefore(linea_31,linea_6);
						Movimiento.insertBefore(linea_12,linea_6);
						Movimiento.insertBefore(linea_13,linea_6);
						Movimiento.insertBefore(linea_14,linea_6);
						Movimiento.insertBefore(linea_15,linea_6);
						break;
					case 4:
						Movimiento.insertBefore(linea_19,linea_6);
						Movimiento.insertBefore(linea_23,linea_6);
						Movimiento.insertBefore(linea_31,linea_6);
						Movimiento.insertBefore(linea_12,linea_6);
						Movimiento.insertBefore(linea_13,linea_6);
						Movimiento.insertBefore(linea_14,linea_6);
						Movimiento.insertBefore(linea_15,linea_6);
						break;
					case 5:
						Movimiento.insertBefore(linea_6,linea_4);	
						Movimiento.insertBefore(linea_28,linea_25);	
						Movimiento.insertBefore(linea_31,linea_25);
						break;
					case 6:
						Movimiento.insertBefore(linea_24,linea_10);	
						Movimiento.insertBefore(linea_31,linea_20);
						Movimiento.insertBefore(linea_32,linea_20);
						Movimiento.insertBefore(linea_30,linea_20);
						Movimiento.insertBefore(linea_25,linea_20);
						Movimiento.insertBefore(linea_23,linea_20);
						break;
					case 9:
					case 10:
						Movimiento.insertBefore(linea_11,linea_6);	
						break;
					case 11:
						Movimiento.insertBefore(linea_31,linea_6);	
						Movimiento.insertBefore(linea_30,linea_31);	
						break;
					case 12:
						Movimiento.insertBefore(linea_11,linea_6);
						Movimiento.insertBefore(linea_10,linea_6);
						break;
					case 13:
						<cfif #mov_logico# IS 'Si'>
							Movimiento.insertBefore(linea_6,linea_16);
							Movimiento.insertBefore(linea_16,linea_6);
						<cfelse>
							Movimiento.insertBefore(linea_1,linea_6);
							Movimiento.insertBefore(linea_2,linea_6);
							Academico.insertBefore(linea_7,linea_3);
							Academico.insertBefore(linea_8,linea_3);
							Movimiento.insertBefore(linea_6,linea_16);
							Movimiento.insertBefore(linea_16,linea_6);
						</cfif>
						break;
					case 14:
						Movimiento.insertBefore(linea_21,linea_6);
						Movimiento.insertBefore(linea_33,linea_6);
						break;
					case 15:
						Movimiento.insertBefore(linea_10,linea_6);
						Movimiento.insertBefore(linea_11,linea_6);
						Movimiento.insertBefore(linea_25,linea_32);
						Movimiento.insertBefore(linea_32,linea_25);
						break;
					case 17:
						Movimiento.insertBefore(linea_11,linea_6);
						Movimiento.insertBefore(linea_10,linea_11);
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_31,linea_25);
						Movimiento.insertBefore(linea_6,linea_4);
						break;	
					case 19:	
						Movimiento.insertBefore(linea_11,linea_6);
						break;	
					case 20:
						Movimiento.insertBefore(linea_28,linea_4);
						Movimiento.insertBefore(linea_16,linea_6);
						break;
					case 21:
					case 30:
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_18,linea_6);
						Movimiento.insertBefore(linea_31,linea_27);
						break;
					case 22:
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_16,linea_6);
						break;	
					case 23:
						Movimiento.insertBefore(linea_18,linea_6);
						break;
					case 25:
						Movimiento.insertBefore(linea_11,linea_6);
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_29,linea_6);
						break;
					case 26:
						Movimiento.insertBefore(linea_12,linea_6);
						Movimiento.insertBefore(linea_6,linea_31);
						break;	
					case 27:
						Movimiento.insertBefore(linea_24,linea_11);
						Movimiento.insertBefore(linea_31,linea_30);
						break;	
					case 28:
						Movimiento.insertBefore(linea_29,linea_6);
						Movimiento.insertBefore(linea_10,linea_6);
						Movimiento.insertBefore(linea_11,linea_6);
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_31,linea_6);
						Movimiento.insertBefore(linea_25,linea_6);
						break;
					case 29:
						Movimiento.insertBefore(linea_2,linea_8);
						Movimiento.insertBefore(linea_6,linea_16);
						Movimiento.insertBefore(linea_16,linea_6);
						break;
					case 35:
						Movimiento.insertBefore(linea_6,linea_33);
						break;	
					case 36:
						Movimiento.insertBefore(linea_28,linea_4);
						Movimiento.insertBefore(linea_11,linea_6);
						break;	
					case 37:
						Movimiento.insertBefore(linea_6,linea_33);
						break;	
					case 38:
						Movimiento.insertBefore(linea_28,linea_6);
						Movimiento.insertBefore(linea_13,linea_6);
					case 39:	
						Movimiento.insertBefore(linea_24,linea_9);
						break;
					case 40:
					case 41:
						Movimiento.insertBefore(linea_22,linea_6);
						Movimiento.insertBefore(linea_31,linea_6);
						break;
					case 44:
						Movimiento.insertBefore(linea_30,linea_25);					
						break;
				}
			}
			// El usuario selecciona un académico de la lista:
			function fSeleccionAcademico(vCampo)
			{
				// Mostrar el nombre del académico asesor:
				document.getElementById(vCampo).value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].value;
				document.getElementById(vCampo + '_txt').value = document.getElementById('selAcadLista').options[document.getElementById('selAcadLista').selectedIndex].text;
				// Ocultar la lista de académicos:
				document.getElementById('academico_dynamic_' + vCampo).innerHTML = '';
			}
			
			// Ocultar la lista de destinos/instituciones:
			function fOcultarDestinos()
			{
				document.getElementById('destinos_dynamic').innerHTML = '';
				document.getElementById('b_destinos_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fMostrarDestinos('<cfoutput>#sol_id#</cfoutput>');\">";
			}
			// Ocultar la lista de oponentes:
			function fOcultarOponentes()
			{
				document.getElementById('oponentes_dynamic').innerHTML = '';
				document.getElementById('b_oponentes_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fMostrarOponentes('<cfoutput>#vIdMov#</cfoutput>','<cfoutput>#coa_id#</cfoutput>');\">";
			}
			// Ocultar la lista de historia del asunto:
			function fOcultarHistoriaAsunto()
			{
				document.getElementById('historia_asunto_dynamic').innerHTML = '';
				document.getElementById('b_historia_asunto_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fHistoriaAsunto('CONSULTA');\">";
			}
			// Ocultar la lista de correcciones a oficio:
			function fOcultarCorreccionesOficio()
			{
				document.getElementById('correcciones_oficio_dynamic').innerHTML = '';
				document.getElementById('b_correcciones_oficio_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/ir_abajo_15.jpg\" style=\"border:none;\" onclick=\"fMostrarCorreccionesOficio('<cfoutput>#mov_id#</cfoutput>','<cfoutput>#mov_clave#</cfoutput>');\">";
			}
		</script>        