<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 13/10/2009 --->
<!--- ACTUALIZAR EL REGISTRO DE UN MOVIMIENTO --->
<!--- Verifica que se esté editando el registro --->
<cfif IsDefined("vTipoComando") AND (vTipoComando EQ "EDITA" OR #vTipoComando# EQ 'CORRECCION')>
	<!--- Generación y ejecución de la instrucción SQL UPDATE --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos SET 
		mov_id = <cfif IsDefined("vIdMov") AND #vIdMov# NEQ "">#vIdMov#<cfelse>NULL</cfif>,
		sol_id = <cfif IsDefined("sol_id") AND #sol_id# NEQ "">#sol_id#<cfelse>NULL</cfif>,  
		dep_clave = <cfif IsDefined("dep_clave") AND #dep_clave# NEQ "">'#dep_clave#'<cfelse>NULL</cfif>,
		dep_ubicacion = <cfif IsDefined("dep_ubicacion") AND #dep_ubicacion# NEQ "">'#dep_ubicacion#'<cfelse>NULL</cfif>,
		acd_id = <cfif IsDefined("acd_id") AND #acd_id# NEQ "">#acd_id#<cfelse>NULL</cfif>,
		cn_clave = <cfif IsDefined("cn_clave") AND #cn_clave# NEQ "">'#cn_clave#'<cfelse>NULL</cfif>,
		con_clave = <cfif IsDefined("con_clave") AND #con_clave# NEQ "">#con_clave#<cfelse>NULL</cfif>,
		mov_clave = <cfif IsDefined("mov_clave") AND #mov_clave# NEQ "">#mov_clave#<cfelse>NULL</cfif>, 
		mov_fecha_inicio = <cfif IsDefined("mov_fecha_inicio") AND #mov_fecha_inicio# NEQ "">'#LsDateFormat(mov_fecha_inicio,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		mov_fecha_final = <cfif IsDefined("mov_fecha_final") AND #mov_fecha_final# NEQ "">'#LsDateFormat(mov_fecha_final,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		mov_dep_clave = <cfif IsDefined("mov_dep_clave") AND #mov_dep_clave# NEQ "">'#mov_dep_clave#'<cfelse>NULL</cfif>,
		mov_dep_ubicacion = <cfif IsDefined("mov_dep_ubicacion") AND #mov_dep_ubicacion# NEQ "">'#mov_dep_ubicacion#'<cfelse>NULL</cfif>,
		acd_id_asesor = <cfif IsDefined("acd_id_asesor") AND #acd_id_asesor# NEQ "">#acd_id_asesor#<cfelse>NULL</cfif>,
		mov_cn_clave = <cfif IsDefined("mov_cn_clave") AND #mov_cn_clave# NEQ "">'#mov_cn_clave#'<cfelse>NULL</cfif>,
		mov_plaza = <cfif IsDefined("mov_plaza") AND #mov_plaza# NEQ "">'#mov_plaza#'<cfelse>NULL</cfif>,
		coa_id = <cfif IsDefined("coa_id") AND #coa_id# NEQ "">'#coa_id#'<cfelse>NULL</cfif>,
		pais_clave = <cfif IsDefined("pais_clave") AND #pais_clave# NEQ "">'#pais_clave#'<cfelse>NULL</cfif>,
		edo_clave = <cfif IsDefined("edo_clave") AND #edo_clave# NEQ "">'#SinAcentos(Ucase(edo_clave),0)#'<cfelse>NULL</cfif>,
		mov_ciudad = <cfif IsDefined("mov_ciudad") AND #mov_ciudad# NEQ "">'#SinAcentos(Ucase(mov_ciudad),0)#'<cfelse>NULL</cfif>,
		mov_institucion = <cfif IsDefined("mov_institucion") AND #mov_institucion# NEQ "">'#SinAcentos(Ucase(mov_institucion),0)#'<cfelse>NULL</cfif>,
		mov_cargo = <cfif IsDefined("mov_cargo") AND #mov_cargo# NEQ "">'#SinAcentos(Ucase(mov_cargo),0)#'<cfelse>NULL</cfif>,
		mov_periodo = <cfif IsDefined("mov_periodo") AND #mov_periodo# NEQ "">'#mov_periodo#'<cfelse>NULL</cfif>,
		cam_clave = <cfif IsDefined("cam_clave") AND #cam_clave# NEQ "">#cam_clave#<cfelse>NULL</cfif>,
		mov_prorroga = <cfif IsDefined("mov_prorroga") AND #mov_prorroga# NEQ ""><cfif #mov_prorroga# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		prog_clave = <cfif IsDefined("prog_clave") AND #prog_clave# NEQ "">#prog_clave#<cfelse>NULL</cfif>,
		baja_clave = <cfif IsDefined("baja_clave") AND #baja_clave# NEQ "">#baja_clave#<cfelse>NULL</cfif>,
		activ_clave = <cfif IsDefined("activ_clave") AND #activ_clave# NEQ "">#activ_clave#<cfelse>NULL</cfif>,
		mov_texto = <cfif IsDefined("mov_texto") AND #mov_texto# NEQ "">'#SinAcentos(Ucase(mov_texto),0)#'<cfelse>NULL</cfif>,
		mov_horas = <cfif IsDefined("mov_horas") AND #mov_horas# NEQ "">#mov_horas#<cfelse>NULL</cfif>,
		mov_numero = <cfif IsDefined("mov_numero") AND #mov_numero# NEQ "">#mov_numero#<cfelse>NULL</cfif>,
		mov_sueldo = <cfif IsDefined("mov_sueldo") AND #mov_sueldo# NEQ "">#mov_sueldo#<cfelse>NULL</cfif>,
		mov_erogacion = <cfif IsDefined("mov_erogacion") AND #mov_erogacion# NEQ "">#mov_erogacion#<cfelse>NULL</cfif>,
		mov_fecha_1 = <cfif IsDefined("mov_fecha_1") AND #mov_fecha_1# NEQ "">'#LsDateFormat(mov_fecha_1,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		mov_fecha_2 = <cfif IsDefined("mov_fecha_2") AND #mov_fecha_2# NEQ "">'#LsDateFormat(mov_fecha_2,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		mov_logico = <cfif IsDefined("mov_logico") AND #mov_logico# NEQ ""><cfif #mov_logico# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		mov_memo_1 = <cfif IsDefined("mov_memo_1") AND #mov_memo_1# NEQ "">'#SinAcentos(mov_memo_1,1)#'<cfelse>NULL</cfif>,
		mov_memo_2 = <cfif IsDefined("mov_memo_2") AND #mov_memo_2# NEQ "">'#SinAcentos(mov_memo_2,1)#'<cfelse>NULL</cfif>,
		mov_opinion_ci = <cfif IsDefined("mov_opinion_ci") AND #mov_opinion_ci# NEQ ""><cfif #mov_opinion_ci# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		mov_opinion_dir = <cfif IsDefined("mov_opinion_dir") AND #mov_opinion_dir# NEQ ""><cfif #mov_opinion_dir# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,			
		mov_dictamen_cd = <cfif IsDefined("mov_dictamen_cd") AND #mov_dictamen_cd# NEQ ""><cfif #mov_dictamen_cd# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,			
		mov_relacionado = <cfif IsDefined("mov_relacionado") AND #mov_relacionado# NEQ "">#mov_relacionado#<cfelse>NULL</cfif>,
		<!--- Si se reliza una corrección marcar el movimiento como modificado --->
		<cfif #vTipoComando# EQ 'CORRECCION'>
			mov_modificado = 1,
		<cfelse>
			mov_modificado = <cfif IsDefined("mov_modificado") AND #mov_modificado# NEQ ""><cfif #mov_modificado# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		</cfif>
		mov_cancelado = <cfif IsDefined("mov_cancelado") AND #mov_cancelado# NEQ ""><cfif #mov_cancelado# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		mov_observaciones = <cfif IsDefined("mov_observaciones") AND #mov_observaciones# NEQ "">'#SinAcentos(mov_observaciones,1)#'<cfelse>NULL</cfif>,
		cap_fecha_mod = GETDATE() 
		WHERE mov_id = #vIdMov#
	</cfquery>
	<!--- Si se está realizando una corrección a oficio (FT-CTIC-31) --->
	<cfif #vTipoComando# EQ 'CORRECCION'>
		<!--- Corregir el nombre del académico, si es necesario --->
		<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_correccion
			WHERE sol_id = #vIdSolCO# AND co_tipo = 'DEBE DECIR' AND co_campo = 'NOMBRE'
		</cfquery>
		<cfif #tbCorrecciones.RecordCount# IS 1>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE academicos
				SET 
				acd_apepat = '#tbCorrecciones.co_apepat#',
				acd_apemat = '#tbCorrecciones.co_apemat#',
				acd_nombres = '#tbCorrecciones.co_nombres#',
				cap_fecha_mod = GETDATE()
				WHERE acd_id = #acd_id#
			</cfquery>
		</cfif>
		<!--- Marcar la solicitud como aprobada (asunto resuelto) --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_status = 0
			WHERE sol_id = #vIdSolCO#
		</cfquery>
		<!--- NOTA: Aquí sería mejor redireccionar a la solicitud FT-CTIC-31 correspondiente --->
	</cfif>	
	<!--- Redireccionar al formlario de captura de la forma telegrámica	--->
	<cflocation url="movimiento.cfm?vIdMov=#vIdMov#&vTipoComando=CONSULTA&vIdAcad=#acd_id#" addtoken="no">
</cfif>
