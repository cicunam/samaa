<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 13/10/2009 --->
<!--- FECHA ULTIMA MOD.: 16/05/2022 --->
<!--- ACTUALIZAR EL REGISTRO DE UN MOVIMIENTO --->
<cfif IsDefined("vTipoComando") AND vTipoComando EQ "NUEVO">
<!---    
	<!--- Obtener el siguiente número de movimiento disponible --->
	<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
		SELECT c_movimientos FROM contadores;
		EXEC INCREMENTAR_CONTADOR 'MOV';
	</cfquery>
	<!--- Registrar número de solicitud --->
	<cfset vIdMov = #tbContadores.c_movimientos#>
    <cfoutput>#vIdMov#</cfoutput>        
--->        
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos (mov_id, sol_id, dep_clave, dep_ubicacion, acd_id, cn_clave, con_clave, mov_clave, mov_fecha_inicio, mov_fecha_final, mov_dep_clave, mov_dep_ubicacion, acd_id_asesor, mov_cn_clave, mov_plaza, coa_id, pais_clave, edo_clave, mov_ciudad, mov_institucion, mov_cargo, mov_periodo, cam_clave, mov_prorroga, prog_clave, baja_clave, activ_clave, mov_texto, mov_horas, mov_numero, mov_sueldo, mov_erogacion, mov_fecha_1, mov_fecha_2, mov_logico, mov_memo_1, mov_memo_2, mov_opinion_ci, mov_opinion_dir, mov_dictamen_cd, mov_relacionado, mov_modificado, mov_cancelado, mov_observaciones, cap_fecha_crea)
		VALUES (
		#vIdMov#,
		<cfif IsDefined("sol_id") AND #sol_id# NEQ "">'#sol_id#'<cfelse>NULL</cfif>, 
		<cfif IsDefined("dep_clave") AND #dep_clave# NEQ "">'#dep_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("dep_ubicacion") AND #dep_ubicacion# NEQ "">'#dep_ubicacion#'<cfelse>NULL</cfif>,
		<cfif IsDefined("acd_id") AND #acd_id# NEQ "">#acd_id#<cfelse>NULL</cfif>,
		<cfif IsDefined("cn_clave") AND #cn_clave# NEQ "">'#cn_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("con_clave") AND #con_clave# NEQ "">#con_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_clave") AND #mov_clave# NEQ "">#mov_clave#<cfelse>NULL</cfif>, 
		<cfif IsDefined("mov_fecha_inicio") AND #mov_fecha_inicio# NEQ "">'#LsDateFormat(mov_fecha_inicio,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_fecha_final") AND #mov_fecha_final# NEQ "">'#LsDateFormat(mov_fecha_final,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_dep_clave") AND #mov_dep_clave# NEQ "">'#mov_dep_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_dep_ubicacion") AND #mov_dep_ubicacion# NEQ "">'#mov_dep_ubicacion#'<cfelse>NULL</cfif>,
		<cfif IsDefined("acd_id_asesor") AND #acd_id_asesor# NEQ "">#acd_id_asesor#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_cn_clave") AND #mov_cn_clave# NEQ "">'#mov_cn_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_plaza") AND #mov_plaza# NEQ "">'#mov_plaza#'<cfelse>NULL</cfif>,
		<cfif IsDefined("coa_id") AND #coa_id# NEQ "">'#coa_id#'<cfelse>NULL</cfif>,
		<cfif IsDefined("pais_clave") AND #pais_clave# NEQ "">'#pais_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("edo_clave") AND #edo_clave# NEQ "">'#SinAcentos(Ucase(edo_clave),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_ciudad") AND #mov_ciudad# NEQ "">'#SinAcentos(Ucase(mov_ciudad),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_institucion") AND #mov_institucion# NEQ "">'#SinAcentos(Ucase(mov_institucion),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_cargo") AND #mov_cargo# NEQ "">'#SinAcentos(Ucase(mov_cargo),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_periodo") AND #mov_periodo# NEQ "">'#mov_periodo#'<cfelse>NULL</cfif>,
		<cfif IsDefined("cam_clave") AND #cam_clave# NEQ "">#cam_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_prorroga") AND #mov_prorroga# NEQ ""><cfif #mov_prorroga# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("prog_clave") AND #prog_clave# NEQ "">#prog_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("baja_clave") AND #baja_clave# NEQ "">#baja_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("activ_clave") AND #activ_clave# NEQ "">#activ_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_texto") AND #mov_texto# NEQ "">'#SinAcentos(Ucase(mov_texto),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_horas") AND #mov_horas# NEQ "">#mov_horas#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_numero") AND #mov_numero# NEQ "">#mov_numero#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_sueldo") AND #mov_sueldo# NEQ "">#mov_sueldo#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_erogacion") AND #mov_erogacion# NEQ "">#mov_erogacion#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_fecha_1") AND #mov_fecha_1# NEQ "">'#LsDateFormat(mov_fecha_1,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_fecha_2") AND #mov_fecha_2# NEQ "">'#LsDateFormat(mov_fecha_2,"dd/mm/yyyy")#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_logico") AND #mov_logico# NEQ ""><cfif #mov_logico# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("mov_memo_1") AND #mov_memo_1# NEQ "">'#SinAcentos(mov_memo_1,1)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_memo_2") AND #mov_memo_2# NEQ "">'#SinAcentos(mov_memo_2,1)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_opinion_ci") AND #mov_opinion_ci# NEQ ""><cfif #mov_opinion_ci# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("mov_opinion_dir") AND #mov_opinion_dir# NEQ ""><cfif #mov_opinion_dir# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,			
		<cfif IsDefined("mov_dictamen_cd") AND #mov_dictamen_cd# NEQ ""><cfif #mov_dictamen_cd# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,			
		<cfif IsDefined("mov_relacionado") AND #mov_relacionado# NEQ "">#mov_relacionado#<cfelse>NULL</cfif>,
		<cfif IsDefined("mov_modificado") AND #mov_modificado# NEQ ""><cfif #mov_modificado# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("mov_cancelado") AND #mov_cancelado# NEQ ""><cfif #mov_cancelado# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("mov_observaciones") AND #mov_observaciones# NEQ "">'#SinAcentos(mov_observaciones,1)#'<cfelse>NULL</cfif>,
		GETDATE()
        ) 
	</cfquery>
            
	<!--- Redireccionar al formlario de captura de la forma telegrámica --->
	<cflocation url="movimiento.cfm?vIdAcad=#acd_id#&vIdMov= #vIdMov#&vTipoComando=CONSULTA" addtoken="no">

</cfif>
