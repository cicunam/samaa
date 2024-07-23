<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 26/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 25/05/2022 --->
<!--- AJAX PARA ASIGNAR NÚMERO DE OFICIO --->
<!--- Obtener información del periodo de sesión --->

<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vActa# 
    AND ssn_clave = 1
</cfquery>
<!--- Obtener la fecha de la sesión --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
	<cfset AnioCTIC = YEAR(tbSesiones.ssn_fecha_m)>
<cfelse>
	<cfset AnioCTIC = YEAR(tbSesiones.ssn_fecha)>
</cfif>
<!--- Determinar que tipo de números de oficio se van a asignar --->
<cfif #vTipo# IS 'RES'>
	<!--- Obtener la lista de asuntos que pasan al pleno, excepto licencias y comisiones --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT movimientos_solicitud.sol_id, catalogo_dependencia.dep_clave FROM (((movimientos_solicitud 
		LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
		LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id
		WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
		AND movimientos_asunto.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
		AND movimientos_asunto.ssn_id = #vActa# <!--- Del acta seleccionada --->
		AND (movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41) <!--- Todos los asuntos excepto licencias y comisiones --->
		AND movimientos_asunto.asu_parte < 7 <!--- No incluir asuntos que no pasan al listado --->
		ORDER BY 
		movimientos_asunto.asu_parte,
		movimientos_asunto.asu_numero
	</cfquery>
	<!--- Asignar números de oficio a los asuntos seleccionados --->
	<cfoutput query="tbSolicitudes">
		<!--- Verificar que el asunto ya haya sido marcado por el usuario --->
		<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #sol_id#) IS TRUE>
			<!--- Generar el número de oficio e incrementar el contador --->
			<cfset vNoOficio_txt = "CJIC/CTIC/" & #NumberFormat(vNoOficio,'0000')# & "/" & #AnioCTIC#>
			<!--- Registrar el número de oficio en la historia del asunto --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_asunto
                SET asu_oficio = '#vNoOficio_txt#'
				WHERE sol_id = #tbSolicitudes.sol_id#
                AND asu_reunion = 'CTIC'
			</cfquery>
			<!--- Incrementar el contador de número de oficio --->
			<cfset vNoOficio = #vNoOficio# + 1>
		</cfif>
	</cfoutput>	
<cfelseif #vTipo# IS 'LYC'>
	<!--- Obtener la lista de licencias y comisiones --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT movimientos_solicitud.sol_id, catalogo_dependencia.dep_clave FROM ((((movimientos_solicitud 
		LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
		LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
		LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave
		WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
		AND movimientos_asunto.ssn_id = #vActa#
		AND movimientos_asunto.asu_reunion = 'CTIC'
		AND (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41) <!--- Sólo licencias y comisiones --->
		ORDER BY 
		catalogo_dependencia.dep_orden,
		movimientos_solicitud.mov_clave DESC,
		academicos.acd_apepat,
		academicos.acd_apemat,
		academicos.acd_nombres,
		movimientos_solicitud.sol_pos14
	</cfquery>
	<!--- Asignar números de oficio a los asuntos seleccionados --->
	<cfoutput query="tbSolicitudes" group="dep_clave">
		<cfset ACK = 0>
		<!--- Generar el número de oficio e incrementar el contador --->
		<cfset vNoOficio_txt = "CJIC/CTIC/LC/" & #NumberFormat(vNoOficio,'0000')# & "/" & #AnioCTIC#>
		<!--- Registrar el mismo número de oficio a todos los asuntos de la entidad --->
		<cfoutput>
			<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #sol_id#) IS TRUE>
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_asunto 
                    SET asu_oficio = '#vNoOficio_txt#'
					WHERE sol_id = #tbSolicitudes.sol_id# 
					AND asu_reunion = 'CTIC'
				</cfquery>
				<cfset ACK = 1>
			</cfif>	
		</cfoutput>
		<!--- Incrementar el contador de número de oficio si existió algún asunto marcado --->
		<cfif ACK IS 1>
			<cfset vNoOficio = #vNoOficio# + 1>
		</cfif>
	</cfoutput>
<cfelseif #vTipo# IS 'OFDGAPA'>
    <!--- ASIGNA OFICIOS PARA LA DGAPA --->
    <!--- FECHA CREA: 24/05/2022 --->
    <!--- FECHA ÚLTIMA MOD.: 24/05/2022 --->    
	<!--- Obtener la lista de los sabáticos con beca DGAPA --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT movimientos_solicitud.sol_id, catalogo_dependencia.dep_clave
        FROM ((((movimientos_solicitud 
		LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave)
		LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
		LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave
		WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
		AND movimientos_asunto.ssn_id = #vActa#
		AND movimientos_asunto.asu_reunion = 'CTIC'
		AND movimientos_solicitud.mov_clave = 30 <!--- Sólo sabáticos con beca DGAPA --->
		ORDER BY 
		catalogo_dependencia.dep_orden,
		movimientos_solicitud.mov_clave DESC,
		academicos.acd_apepat,
		academicos.acd_apemat,
		academicos.acd_nombres,
		movimientos_solicitud.sol_pos14
	</cfquery>
	<cfoutput query="tbSolicitudes" group="dep_clave">
		<!--- Verificar que el asunto ya haya sido marcado por el usuario --->
		<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #sol_id#) IS TRUE>
			<!--- Generar el número de oficio e incrementar el contador --->
			<cfset vNoOficio_txt = "CJIC/CTIC/" & #NumberFormat(vNoOficio,'0000')# & "/" & #AnioCTIC#>
			<!--- Registrar el número de oficio en la historia del asunto --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_asunto SET
				asu_oficio_dgapa = '#vNoOficio_txt#'
				WHERE sol_id = #tbSolicitudes.sol_id#
				AND asu_reunion = 'CTIC'
			</cfquery>
			<!--- Incrementar el contador de número de oficio --->
			<cfset vNoOficio = #vNoOficio# + 1>
		</cfif>
	</cfoutput>
<cfelseif #vTipo# IS 'COAOP'>
    <!--- ASIGNA OFICIOS A LOS OPONENTES DE COA --->
    <!--- FECHA CREA: 24/05/2022 --->
    <!--- FECHA ÚLTIMA MOD.: 24/05/2022 --->
	<cfquery name="tbCoaOponente" datasource="#vOrigenDatosSAMAA#">
		SELECT T3.id 
        FROM movimientos_solicitud AS T1
		LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
        LEFT JOIN convocatorias_coa_concursa AS T3 ON T1.sol_id = T3.sol_id
        LEFT JOIN academicos AS T4 ON T3.acd_id = T4.acd_id
		WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
		AND T2.ssn_id = #vActa#
		AND T2.asu_reunion = 'CTIC'
		AND T1.mov_clave = 5
        AND T3.coa_ganador = 0
		ORDER BY 
        T2.asu_parte, T2.asu_numero, T4.acd_apepat, T4.acd_apemat, T4.acd_nombres
	</cfquery>
	<cfoutput query="tbCoaOponente">
        <!--- Generar el número de oficio e incrementar el contador --->
        <cfset vNoOficio_txt = "CJIC/CTIC/" & #NumberFormat(vNoOficio,'0000')# & "/" & #AnioCTIC#>
        <!--- Registrar el número de oficio en la historia del asunto --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE convocatorias_coa_concursa 
            SET asu_oficio_ctic = '#vNoOficio_txt#'
            WHERE id = #id#
        </cfquery>
        <!--- Incrementar el contador de número de oficio --->
        <cfset vNoOficio = #vNoOficio# + 1>
	</cfoutput>    
</cfif>