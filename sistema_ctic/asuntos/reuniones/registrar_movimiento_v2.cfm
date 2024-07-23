<!------------------------------------------------------->
<!--- REGISTRAR MOVIMIENTOS ACADÉMICO-ADMINISTRATIVOS --->
<!------------------------------------------------------->
<!--- CREADO: JOSÉ ANTONIO ESTEVA 	--->
<!--- EDITO: ARAM PICHARDO        	--->
<!--- FECHA CREA: 04/12/2009 	  	--->
<!--- FECHA ÚLTIMA MOD.: 17/04/2023 --->
<!------------------------------------->
<!--- Obtener todos los asuntos excepto licencias y comisiones--->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM (((((movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CTIC')
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
	<!--- Aquí debe ir la lista de concursantes --->
	LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave)
	LEFT JOIN catalogo_movimiento AS C2 ON T1.mov_clave = C2.mov_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C3 ON T1.sol_pos1 = C3.dep_clave)  <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON T1.sol_pos3 = C4.cn_clave  <!---CATALOGOS GENERALES MYSQL --->
	WHERE T1.sol_status = 0 <!--- Sólo asuntos resueltos --->
	AND T2.asu_reunion = 'CTIC'
	AND T2.ssn_id = #vActa#
    AND T2.dec_clave > 0
    AND T2.asu_oficio IS NOT NULL <!--- NO ENVIAR ASUNTOS SIN NUMERO DE OFICIO --->
	ORDER BY
	T2.asu_parte,
	T2.asu_numero,
	C3.dep_orden,
	T3.acd_apepat,
	T3.acd_apemat,
	T3.acd_nombres,
	T1.sol_pos14
</cfquery>
<!--- Contadores para generar un reporte de asuntos registrados --->
<cfset cRetirados = 0>
<cfset cPendientes = 0>
<cfset cCorrecciones = 0>
<cfset cRegistrados = 0>

<!--- Registrar los asuntos --->
<cfoutput query="tbSolicitudes">
	<!--- Verificar si ya existe el registro en la tabla de movimientos --->
	<cfquery name="tbMovimientosVerifica" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos 
        WHERE movimientos.sol_id = #tbSolicitudes.sol_id# <!--- ID de la solicitud --->
	</cfquery>
	<!--- Si no se ha agregado el registro, agregarlo --->
	<cfif #tbMovimientosVerifica.RecordCount# IS 0>
		<!--- ********** ASUNTOS RETIRADOS ********** --->
		<cfif #tbSolicitudes.dec_super# IS 'RE'>
			<!--- Marcar la solicitud como retirada --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_solicitud SET sol_retirada = 1, cap_fecha_mod = GETDATE()
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>
			<!--- Copiar la solicitud en el historial de solicitudes --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO movimientos_solicitud_historia
				SELECT * FROM movimientos_solicitud
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>

			<!--- Eliminar la solicitud de la tabla --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				DELETE FROM movimientos_solicitud
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>
			<!--- Incrementar el contador de asuntos pendientes --->
			<cfset cRetirados = cRetirados + 1>
		<cfelseif #tbSolicitudes.dec_super# IS 'OB' OR #tbSolicitudes.dec_super# IS 'PE'>
	   		<!--- ********** ASUNTOS QUE PASAN A LA SIGUIENTE SESIÓN (OBJETADOS Y PENDIENTES POR AUSENCIA) ********** --->
	
    		<!--- Asignar el asunto al siguiente periodo de sesión en la sección correspondiente --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte, asu_numero, asu_oficio)
				VALUES (#tbSolicitudes.sol_id#, #vActa# + 1, 'CAAA', #ReasignarSeccionEnListado(tbSolicitudes.dec_super, tbSolicitudes.asu_parte)#, #Iif(tbSolicitudes.asu_numero IS '',0,tbSolicitudes.asu_numero)#, '#tbSolicitudes.asu_oficio#')
			</cfquery>
			<!--- Cambiar el status de la solicitud a 2 (en la CAAA) --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_solicitud SET sol_status = 2 
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>
			<!--- Si el asunto quedó pendiente por ausencia en el pleno ---><!--- NOTA: Esto no se aplica a los asuntos objetados --->
			<cfif #tbSolicitudes.dec_clave# IS 24>
				<!--- Pasar el asunto automáticamente a la sesión del pleno --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, asu_parte, asu_numero, asu_oficio)
					VALUES (#tbSolicitudes.sol_id#, #vActa# + 1, 'CTIC', #ReasignarSeccionEnListado(tbSolicitudes.dec_super, tbSolicitudes.asu_parte)#, #Iif(tbSolicitudes.asu_numero IS '',0,tbSolicitudes.asu_numero)#, '#tbSolicitudes.asu_oficio#')
				</cfquery>
				<!--- Cambiar el status de la solicitud a 1 (en el pleno) --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_solicitud SET 
					sol_status = 1 
					WHERE sol_id = #tbSolicitudes.sol_id#
				</cfquery>
			</cfif>
			<!--- Incrementar el contador de asuntos pendientes --->
			<cfset cPendientes = cPendientes + 1>
		<cfelse>
			<!--- ********** ASUNTOS QUE SE REGISTRAN EN LA TABLA DE MOVIMIENTOS ********** --->

			<!--- Omitir FT-CTIC-31 --->
			<cfif #tbSolicitudes.mov_clave# IS NOT 31>
				<!--- Obtener el siguiente número de movimiento disponible --->
				<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM contadores;
					EXEC INCREMENTAR_CONTADOR 'MOV';
				</cfquery>
				<!--- Registrar número de solicitud --->
				<cfset vIdMov = #tbContadores.c_movimientos#>
				<!--- Obtener la fecha de la sesión para los movimientos que inician un día después de ésta --->
				<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM sesiones 
                    WHERE ssn_clave = 1 
                    AND ssn_id = #vActa#
				</cfquery>
				<!--- Registrar el asunto en la tabla de movimientos --->
				<cfquery datasource="#vOrigenDatosSAMAA#">
					INSERT INTO movimientos (
					mov_id,
					sol_id,
					dep_clave,
					dep_ubicacion,
					acd_id,
					cn_clave,
					con_clave,
					mov_clave,
					mov_fecha_inicio,
					mov_fecha_final,
					mov_dep_clave,
					mov_dep_ubicacion,
					acd_id_asesor,
					mov_cn_clave,
					mov_plaza,
					coa_id,
					pais_clave,
					edo_clave,
					mov_ciudad,
					mov_institucion,
					mov_cargo,
					mov_periodo,
					cam_clave,
					mov_prorroga,
					prog_clave,
					baja_clave,
					activ_clave,
					mov_texto,
					mov_horas,
					mov_numero,
					mov_sueldo,
					mov_erogacion,
					mov_fecha_1,
					mov_fecha_2,
					mov_logico,
					mov_memo_1,
					mov_memo_2,
					mov_opinion_ci,
					mov_opinion_dir,
					mov_dictamen_cd,
					mov_dictamen_ce,
					mov_modificado,
					mov_relacionado,
					mov_observaciones,
					mov_sintesis,
					cap_fecha_crea,
					cap_fecha_mod
					) VALUES (
					<!--- mov_id --->
					#vIdMov#,
					<!--- sol_id --->
					<cfif #tbSolicitudes.sol_id# IS NOT ''><!--- Si el campo no está vacío --->
						#tbSolicitudes.sol_id#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- dep_clave --->
					<cfif #tbSolicitudes.sol_pos1# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos1#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- dep_ubicacion --->
					<cfif #tbSolicitudes.sol_pos1_u# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos1_u#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- acd_id --->
					<cfif #tbSolicitudes.sol_pos2# IS NOT '' AND #tbSolicitudes.sol_pos2# GT 0 ><!--- Si el campo no está vacío --->
						#tbSolicitudes.sol_pos2#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- cn_clave --->
					<cfif #tbSolicitudes.sol_pos3# IS NOT '' AND #tbSolicitudes.mov_clave# IS NOT 25><!--- Si el campo no está vacío y no es una renovación de contrato --->
						'#tbSolicitudes.sol_pos3#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- con_clave --->
					<cfif #tbSolicitudes.sol_pos5# IS NOT ''><!--- Si el campo no está vacío --->
						<!--- NOTA: Falta determinar bien el caso FT-CTIC-17 --->
						<cfif #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# EQ 1) OR #tbSolicitudes.mov_clave# IS 18>
							1 <!--- Definitivo --->
						<cfelseif #tbSolicitudes.mov_clave# IS 5 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# NEQ 1)>
							2 <!--- Interino --->
						<cfelseif #tbSolicitudes.mov_clave# IS 6>
							3 <!--- COD --->
						<cfelseif #tbSolicitudes.mov_clave# IS 38>
							6 <!--- Beca Posdoctoral --->
						<cfelse>
							#tbSolicitudes.sol_pos5# <!--- Mantiene su tipo de contrato --->
						</cfif>
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_clave --->
					<cfif #tbSolicitudes.mov_clave# IS NOT ''><!--- Si el campo no está vacío --->
						#tbSolicitudes.mov_clave#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_fecha_inicio --->

					<!--- NOTA: Alejandro Villanueva solicitó que se desactivara el ajuste de fechas de definitividades.
					<cfif #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19><!--- Definitividades y promociones --->
					--->
					<cfif #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 19><!--- Definitividades y promociones --->
						<!--- Si la fecha solicitada es posterior a la fecha del CTIC, la fecha solicitada permanece sin cambio --->
						<cfif DateCompare(#tbSolicitudes.sol_pos14#, #tbSesiones.ssn_fecha#, "d") IS 1>
							'#LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#'
						<!--- Si la fecha solicitada es anterior a la fecha del CTIC, la fecha solicitada cambia y se pone la fecha del CTIC --->
						<cfelse>
							<cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
								'#LsDateFormat(tbSesiones.ssn_fecha,"dd/mm/yyyy")#'
							<cfelse>
								 '#LsDateFormat(tbSesiones.ssn_fecha_m,"dd/mm/yyyy")#'
							</cfif>
						</cfif>
					<cfelseif (#tbSolicitudes.mov_clave# IS 5 AND #tbSolicitudes.sol_pos17# EQ 1) <!--- Sólo los COA sin oponente se le asigna como fecha de inicio el día después de la sesión del pleno --->
								OR #tbSolicitudes.mov_clave# IS 17 
								OR #tbSolicitudes.mov_clave# IS 28><!--- Movimientos que inicina un día un día despues de la reunión de pleno --->
						<cfif #tbSesiones.ssn_fecha_m# IS ''><!--- Si no cambió la fecha de la sesión --->
							'#LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha),"dd/mm/yyyy")#'
						<cfelse>
							 '#LsDateFormat(DateAdd("d",1,tbSesiones.ssn_fecha_m),"dd/mm/yyyy")#'
						</cfif>
					<cfelseif #tbSolicitudes.sol_pos14# IS NOT ''><!--- Si el campo no está vacío --->
						'#LsDateFormat(tbSolicitudes.sol_pos14,"dd/mm/yyyy")#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_fecha_final --->
					<cfif #tbSolicitudes.mov_clave# IS 5 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# IS NOT 1)><!--- Si el movimiento no es para personal interino --->
						<cfif #tbSesiones.ssn_fecha_m# IS ''>
							'#LsDateFormat(DateAdd("yyyy",1,tbSesiones.ssn_fecha),"dd/mm/yyyy")#'
						<cfelse>
							 '#LsDateFormat(DateAdd("yyyy",1,tbSesiones.ssn_fecha_m),"dd/mm/yyyy")#'
						</cfif>
					<cfelseif #tbSolicitudes.sol_pos15# IS NOT ''><!--- Si el campo no está vacío --->
						'#LsDateFormat(tbSolicitudes.sol_pos15,"dd/mm/yyyy")#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_dep_clave --->
					<cfif #tbSolicitudes.sol_pos11# IS NOT '' AND #tbSolicitudes.mov_clave# IS 13><!--- Si se trata de un cambio de adscripción --->
						'#tbSolicitudes.sol_pos11#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_dep_ubicacion --->
					<cfif #tbSolicitudes.sol_pos11_u# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 13 OR #tbSolicitudes.mov_clave# IS 29)><!--- Si se trata de un cambio de adscripción o ubicación --->
						'#tbSolicitudes.sol_pos11_u#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- acd_id_asesor --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 38 OR #tbSolicitudes.mov_clave# IS 39)><!--- Si se trata de una beca posdoctoral --->
						#tbSolicitudes.sol_pos12#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_cn_clave --->
					<cfif #tbSolicitudes.sol_pos3# IS NOT '' AND #tbSolicitudes.mov_clave# IS 25><!--- Si es una renovación de contrato --->
						'#tbSolicitudes.sol_pos3#'
					<cfelseif #tbSolicitudes.sol_pos8# IS NOT ''><!--- Los demás casos --->
						'#tbSolicitudes.sol_pos8#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_plaza --->
					<cfif #tbSolicitudes.sol_pos9# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos9#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- coa_id --->
					<cfif #tbSolicitudes.sol_pos23# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos23#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- pais_clave --->
					<cfif #tbSolicitudes.sol_pos11_p# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos11_p#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- edo_clave --->
					<cfif #tbSolicitudes.sol_pos11_e# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos11_e#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_ciudad --->
					<cfif #tbSolicitudes.sol_pos11_c# IS NOT ''><!--- Si el campo no está vacío --->
						'#tbSolicitudes.sol_pos11_c#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_institucion --->
					<cfif #tbSolicitudes.sol_pos11# IS NOT '' AND #tbSolicitudes.mov_clave# IS NOT 13><!--- Si el campo no está vacío y no se trata de un cambio de adscripción --->
						'#tbSolicitudes.sol_pos11#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_cargo --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 13 OR #tbSolicitudes.mov_clave# IS 22 OR #tbSolicitudes.mov_clave# IS 29)>
						'#tbSolicitudes.sol_pos12#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_periodo --->
					<cfif #tbSolicitudes.sol_pos13# IS NOT ''>
						'#tbSolicitudes.sol_pos13#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- cam_clave --->
					<cfif #tbSolicitudes.sol_pos10# IS NOT ''>
						#tbSolicitudes.sol_pos10#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_prorroga --->
					<cfif #tbSolicitudes.sol_pos12# IS 'PRORROGA' AND #tbSolicitudes.mov_clave# IS 4>
						1
					<cfelse>
						NULL
					</cfif>
					,
					<!--- prog_clave --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 6 OR #tbSolicitudes.mov_clave# IS 12)>
						#tbSolicitudes.sol_pos12#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- baja_clave --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND #tbSolicitudes.mov_clave# IS 14>
						#tbSolicitudes.sol_pos12#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- activ_clave --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 1 OR #tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41)>
						#tbSolicitudes.sol_pos12#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_texto --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 2 OR #tbSolicitudes.mov_clave# IS 3 OR #tbSolicitudes.mov_clave# IS 32)>
						'#tbSolicitudes.sol_pos12#'
					<cfelseif #tbSolicitudes.sol_pos12_o# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 4 OR #tbSolicitudes.mov_clave# IS 6 OR #tbSolicitudes.mov_clave# IS 40 OR #tbSolicitudes.mov_clave# IS 41)>
						'#tbSolicitudes.sol_pos12_o#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_horas --->
					<cfif #tbSolicitudes.sol_pos16# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 1 OR #tbSolicitudes.mov_clave# IS 6 OR #tbSolicitudes.mov_clave# IS 38 OR #tbSolicitudes.mov_clave# IS 39)>
						#tbSolicitudes.sol_pos16#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_numero --->
					<cfif #tbSolicitudes.sol_pos17# IS NOT '' AND VAL(#tbSolicitudes.sol_pos17#) GT 0>
						#tbSolicitudes.sol_pos17#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_sueldo --->
					<cfif #tbSolicitudes.mov_clave# IS 41>
						100
					<cfelseif #tbSolicitudes.sol_pos17# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 2 OR #tbSolicitudes.mov_clave# IS 3 OR #tbSolicitudes.mov_clave# IS 4)>
						#tbSolicitudes.sol_pos17#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_erogacion --->
					<cfif #tbSolicitudes.sol_pos19# IS NOT '' AND VAL(#tbSolicitudes.sol_pos19#) GT 0>
						#tbSolicitudes.sol_pos19#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_fecha_1 --->
					<cfif #tbSolicitudes.sol_pos21# IS NOT ''>
						'#LsDateFormat(tbSolicitudes.sol_pos21,"dd/mm/yyyy")#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_fecha_2 --->
					<cfif #tbSolicitudes.sol_pos22# IS NOT ''>
						'#LsDateFormat(tbSolicitudes.sol_pos22,"dd/mm/yyyy")#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_logico --->
					<cfif #tbSolicitudes.sol_pos20# IS NOT ''>
						#tbSolicitudes.sol_pos20#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_memo_1 --->
					<cfif #tbSolicitudes.sol_memo1# IS NOT ''>
						'#tbSolicitudes.sol_memo1#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_memo_2 --->
					<cfif #tbSolicitudes.sol_memo2# IS NOT ''>
						'#tbSolicitudes.sol_memo2#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_opinion_ci --->
					<cfif #tbSolicitudes.sol_pos26# IS NOT ''>
						#tbSolicitudes.sol_pos26#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_opinion_dir --->
					<cfif #tbSolicitudes.sol_pos28# IS NOT ''>
						#tbSolicitudes.sol_pos28#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_dictamen_cd --->
					<cfif #tbSolicitudes.sol_pos30# IS NOT ''>
						#tbSolicitudes.sol_pos30#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_dictamen_ce (PENDIENTE) --->
					NULL,
					<!--- mov_modificado (se actualiza posteriormente si hay una modificación al movimiento) --->
					NULL,
					<!--- mov_relacionado --->
					<cfif #tbSolicitudes.sol_pos12# IS NOT '' AND (#tbSolicitudes.mov_clave# IS 3 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19 OR #tbSolicitudes.mov_clave# IS 23 OR #tbSolicitudes.mov_clave# IS 25 OR #tbSolicitudes.mov_clave# IS 35 OR #tbSolicitudes.mov_clave# IS 37 OR #tbSolicitudes.mov_clave# IS 42 OR #tbSolicitudes.mov_clave# IS 43)>
						#tbSolicitudes.sol_pos12#
					<cfelseif #tbSolicitudes.sol_pos12_o# IS NOT '' AND #tbSolicitudes.mov_clave# IS 14>
						#tbSolicitudes.sol_pos12_o#
					<cfelse>
						NULL
					</cfif>
					,
					<!--- mov_observaciones (PENDIENTE) --->
					NULL,
					<!--- mov_sintesis --->
					<cfif #tbSolicitudes.sol_sintesis# IS NOT ''>
						'#tbSolicitudes.sol_sintesis#'
					<cfelse>
						NULL
					</cfif>
					,
					<!--- cap_fecha_crea --->
					GETDATE(),
					<!--- cap_fecha_mod --->
					GETDATE()
					)
				</cfquery>
				<!--- Incrementar el contados de asuntos registrados --->
				<cfset cRegistrados = cRegistrados + 1>
			<!--- Correcciones a oficio --->
			<cfelse>
				<!--- Incrementar el contador de correcciones a oficio enviadas al historial --->
				<cfset cCorrecciones = cCorrecciones + 1>
			</cfif>
			<!--- Pasar el archivo digitalizado (PDF) al historial de archivos --->
			<cfset vNomArchActual = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
			<cfset vNomArchNuevo = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '_' & #vActa# & '.pdf'>
			<cfif FileExists(#vCarpetaCAAA# & #vNomArchActual#)>
				<cffile action="move" source="#vCarpetaCAAA##vNomArchActual#" destination="#vCarpetaAcademicos#">
				<cffile action="rename" source="#vCarpetaAcademicos##vNomArchActual#" destination="#vNomArchNuevo#">
			</cfif>
			<!--- Copiar la solicitud en el historial de solicitudes --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO movimientos_solicitud_historia
				SELECT * FROM movimientos_solicitud
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>
			<!--- Eliminar la solicitud de la tabla --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				DELETE FROM movimientos_solicitud
				WHERE sol_id = #tbSolicitudes.sol_id#
			</cfquery>
		</cfif>
	<cfelse>
		<!--- LISTAR LAS SOLICITUDES QUE YA SE REGISTRATON (25/09/2017)--->
	</cfif>
</cfoutput>
<!--- Actualizar la tabla de académicos con los movimientos que ya iniciaron, los pendientes se actualizarán el día en que inician --->
<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
	EXEC ACTUALIZAR_TABLA_ACADEMICOS #vActa#;
</cfquery>
<!--- Informe de registro de movimientos --->
<cfoutput>
	<div class="Sans10Ne" style="width:800px; margin: 10px 0px 10px 15px; border: none">
		<span class="Sans11NeNe" >Informe de registro de movimientos:<br></span>
		<hr>
		<ul>
			<li>Se registraron <span class="Sans10NeNe">#cRegistrados#</span> movimientos acad&eacute;mico-administrativos.</li>
			<li>Se pasaron <span class="Sans10NeNe">#cPendientes#</span> asuntos pendientes a la sesi&oacute;n #Val(vActa) + 1#.</li>
			<li>Se enviaron al historial de solicitudes <span class="Sans10NeNe">#cCorrecciones#</span> correcciones a oficio y <span class="Sans10NeNe">#cRetirados#</span> asuntos retirados.	</li>
		</ul>
		<a style="cursor:pointer;" onclick="fListarSolicitudes(1);" >Regresar a la lista de movimientos</a>
	</div>
</cfoutput>
<!--- Función que determina la sección del listado que corresponde a un asunto objetado o pendiente por ausencia --->
<cffunction name="ReasignarSeccionEnListado">
	<cfargument name="aSD"><!--- Decisión en la sesión actual --->
	<cfargument name="aPT"><!--- Parte en la sesión actual --->
	<!--- Asignar nueva sección --->
	<cfif #aSD# IS 'OB'><!--- Objetados --->
		<cfif Val(#aPT#) EQ 1 OR Val(#aPT#) EQ 2.1 OR Val(#aPT#) EQ 4.1>
			<cfreturn 4.1>
		<cfelseif Val(#aPT#) EQ 3 OR Val(#aPT#) EQ 2.2 OR Val(#aPT#) EQ 4.2>
			<cfreturn 4.2>
		<cfelseif Val(#aPT#) EQ 3.4><!--- AGREGUÉ ESTE CÓDIGO PARA LOS OBJETADOS DE CÁTEDRAS CONACyT 12/06/2015 --->
			<cfreturn 4.4>
		</cfif>
	<cfelseif #aSD# IS 'PE'><!--- Pendientes por ausencia --->
			<cfif Val(#aPT#) EQ 1 OR Val(#aPT#) EQ 2.1>
			<cfreturn 2.1>
		<cfelseif Val(#aPT#) EQ 3 OR Val(#aPT#) EQ 2.2>
			<cfreturn 2.2>
		<cfelseif Val(#aPT#) EQ 2.5> <!--- LICENCIAS CON GOCE DE SUELDO PENDIENTES 17/04/2024 --->
			<cfreturn 2.5>
		<cfelseif Val(#aPT#) EQ 4.1>
			<cfreturn 4.1>
		<cfelseif Val(#aPT#) EQ 4.2>
			<cfreturn 4.2>
		</cfif>
	<cfelse>
		<cfreturn 7>
	</cfif>
</cffunction>
