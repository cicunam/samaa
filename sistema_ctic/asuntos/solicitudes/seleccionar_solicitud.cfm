<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 05/05/2009--->
<!--- AJAX PARA SELECCIONAR UN REGISTRO DE LA LISTA DE SOLICITUDES --->
<cfif #vValor# IS 'TRUE'>
	<!--- Obtener todas las solicitudes filtradas --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id 
		<cfif #vIdSol# IS 'TODAS'>
			<cfif #vTipo# IS 4>
				WHERE (sol_status = 4 OR (sol_status = 3 AND (mov_clave = 40 OR mov_clave = 41)))
			<cfelse>
				WHERE movimientos_solicitud.sol_status = #vTipo# <!--- 3=Solicitud enviada, 4=Solicitud en captura --->
			</cfif>
			<!--- Filtro por tipo de movimiento --->
			<cfif #vFt# NEQ 0>
				AND 
		        <cfif #vFt# EQ 100>
					(movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41)
		        <cfelseif #vFt# EQ 101>
					(movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)
		        <cfelse>
					movimientos_solicitud.mov_clave = #vFt#
		        </cfif>
			</cfif>
			<!--- Filtro por académico --->
			<cfif #vAcadNom# IS NOT ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
			<!--- Filtro por dependencia --->
			<cfif #Session.sTipoSistema# IS 'sic'>
				AND sol_pos1 = '#Session.sIdDep#'
			<cfelse>
				<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
			</cfif>
			<!--- Filtro por número de solicitud --->
			<cfif #vNumSol# IS NOT ''>AND sol_id = #vNumSol#</cfif>
			<!--- Filtro por status de la solicitud --->
			<cfif #vTipo# IS 4>
				<cfif #vStatus# IS NOT ''>
			    	AND (
					<cfset vActivaOr = FALSE>
					<cfif Find('C','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 0)
						<cfset vActivaOr = TRUE>
					</cfif>	
					<cfif Find('D','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 4 AND movimientos_solicitud.sol_devuelta = 1)
						<cfset vActivaOr = TRUE>	
					</cfif>
					<cfif Find('E','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							movimientos_solicitud.sol_status = 3
						<cfset vActivaOr = TRUE>
					</cfif>
					<cfif Find('P','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							(movimientos_solicitud.sol_status = 2 OR movimientos_solicitud.sol_status = 1)
						<cfset vActivaOr = TRUE>		
					</cfif>
					<cfif Find('R','#vStatus#')>
						<cfif vActivaOr IS TRUE> OR </cfif>
							movimientos_solicitud.sol_status = 0
						<cfset vActivaOr = TRUE>		
					</cfif>
					)
				<cfelse>
					AND 1=0	
				</cfif>
			</cfif>	
		<cfelse>
			WHERE movimientos_solicitud.sol_id = #vIdSol#
		</cfif>
	</cfquery>
	<!--- Agregar los identificadores de las solicitudes al arreglo de solicitudes marcadas --->
	<cfloop query="tbSolicitudes">
		<cfif #vTipo# EQ 4>
			<!--- Solicitudes en captura --->
			<cfif NOT ArrayContainsValue(Session.AsuntosSolicitudFiltro.vMarcadas,tbSolicitudes.sol_id)><cfoutput>#ArrayAppend(Session.AsuntosSolicitudFiltro.vMarcadas,tbSolicitudes.sol_id)#</cfoutput></cfif>
		<cfelseif #vTipo# EQ 3>
			<!--- Solicitudes en revision --->
			<cfif NOT ArrayContainsValue(Session.AsuntosRevisionFiltro.vMarcadas,tbSolicitudes.sol_id)><cfoutput>#ArrayAppend(Session.AsuntosRevisionFiltro.vMarcadas,tbSolicitudes.sol_id)#</cfoutput></cfif>
		</cfif>
	</cfloop>
<cfelse>
	<cfif #vIdSol# IS 'TODAS'>
		<!--- Vaciar el arreglo de solicitudes marcadas --->
		<cfif #vTipo# IS 4>
			<!--- Solicitudes en captura --->
			<cfoutput>#ArrayClear(Session.AsuntosSolicitudFiltro.vMarcadas)#</cfoutput>
		<cfelseif #vTipo# IS 3>
			<!--- Solicitudes en revision --->
			<cfoutput>#ArrayClear(Session.AsuntosRevisionFiltro.vMarcadas)#</cfoutput>
		</cfif>
	<cfelse>
		<!--- Eliminar el elemento seleccionado --->
		<cfif #vTipo# IS 4>
			<!--- Solicitudes en captura --->
			<cfoutput>#ArrayDeleteAt(Session.AsuntosSolicitudFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosSolicitudFiltro.vMarcadas,vIdSol))#</cfoutput>
		<cfelseif #vTipo# IS 3>
			<!--- Solicitudes en revision --->
			<cfoutput>#ArrayDeleteAt(Session.AsuntosRevisionFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosRevisionFiltro.vMarcadas,vIdSol))#</cfoutput>
		</cfif>
	</cfif>
</cfif>
<!--- Determinar si se hay solicitudes seleccionadas --->
<cfif IsDefined('Session.AsuntosSolicitudFiltro') AND NOT #ArrayIsEmpty(Session.AsuntosSolicitudFiltro.vMarcadas)#>
	SOLICITUDESCONSELECCION
	<!--- Determinar si alguna de las solicitudes seleccionadas es FT-CTIC-40 o FT-CTIC-41 y ya está impresa --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosSolicitudFiltro.vMarcadas)#">
		<cfquery name="tbSolicitudesLYCI" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud
			WHERE (mov_clave = 40 OR mov_clave = 41)
			AND sol_status = 3
			AND sol_id = #Session.AsuntosSolicitudFiltro.vMarcadas[E]#
		</cfquery>
		<cfif #tbSolicitudesLYCI.RecordCount# GT 0>
			LYCENVIADA
			<cfbreak>
		</cfif>	
	</cfloop>
</cfif>
<!--- Determinar si hay asuntos que pasan a la CAAA seleccionados --->
<cfif IsDefined('Session.AsuntosRevisionFiltro') AND NOT #ArrayIsEmpty(Session.AsuntosRevisionFiltro.vMarcadas)#>
	REVISIONESCONSELECCION
	<!--- Determinar si alguna de las solicitudes pasa a la CAAA --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosRevisionFiltro.vMarcadas)#">
		<cfquery name="tbSolicitudesCAAA" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud
			WHERE (mov_clave <> 14 AND mov_clave <> 31 AND mov_clave <> 35 AND mov_clave <> 40 AND mov_clave <> 41 AND mov_clave <> 61 AND mov_clave <> 62)
			AND sol_id = #Session.AsuntosRevisionFiltro.vMarcadas[E]#
		</cfquery>
		<cfif #tbSolicitudesCAAA.RecordCount# GT 0>
			ASUNTOSCAAA
			<cfbreak>
		</cfif>	
	</cfloop>
</cfif>