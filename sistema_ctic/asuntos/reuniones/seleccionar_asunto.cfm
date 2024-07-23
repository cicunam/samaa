<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 05/05/2009--->

<!--- AJAX PARA MARCAR REGISTROS DE LA LISTA DE ASUNTOS --->
<!--- NOTA: Esta rutina es casi idéntica a la de solicitudes y se podría utilizar una sola --->
<!--- Marcar asuntos --->
<cfif #vValor# IS 'TRUE'>
	<!--- Obtener todas las solicitudes filtradas --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM (movimientos_solicitud
		LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
		LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id 
		<cfif #vIdSol# IS 'TODAS'>
			<cfif #vTipo# IS 1><!--- 1=CTIC --->
				<!---
				WHERE 
				movimientos_solicitud.sol_status <= 1
				AND asu_reunion = 'CTIC'
				--->
				WHERE 
				(movimientos_solicitud.sol_status = 0 OR (movimientos_solicitud.sol_status = 1 AND movimientos_asunto.dec_clave IS NULL)) <!--- Se adecuó para no desplegar los asuntos objetados que están en el pleno en la siguiente sesión --->
				AND movimientos_asunto.asu_reunion = 'CTIC'
			<cfelseif #vTipo# IS 2><!--- 2=CAAA --->
				<!---
				WHERE 
				movimientos_solicitud.sol_status = 2			
				AND asu_reunion = 'CAAA'
				--->
				WHERE 
				movimientos_solicitud.sol_status = 2 <!--- Asuntos que pasan a la CAAA --->
				AND movimientos_asunto.asu_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
				AND movimientos_asunto.dec_clave IS NULL <!--- Solo desplegar asuntos sin recomendación, para que no aparezcan los pendientes de la siguiente sesión --->
			</cfif>
			<!--- Filtro por tipo de movimiento --->
			<cfif #vFt# NEQ 0>
				AND
				<cfif #vFt# IS 100>
					(movimientos_solicitud.mov_clave <> 40 AND movimientos_solicitud.mov_clave <> 41)
				<cfelseif #vFt# IS 101>
					(movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41)	
				<cfelse>
					movimientos_solicitud.mov_clave = #vFt#
				</cfif>	
			</cfif>
			<!--- Filtro por acta --->
			<cfif #vActa# IS NOT ''>AND movimientos_asunto.ssn_id = #vActa#</cfif>
			<!--- Filtro por sección --->
			<cfif #vSeccion# IS NOT ''>AND movimientos_asunto.asu_parte = #vSeccion#</cfif>
			<!--- Filtro por dependencia --->
			<cfif #vDepId# IS NOT ''>AND sol_pos1 = '#vDepId#'</cfif>
			<!--- Filtro por académico --->
			<cfif #vAcadNom# IS NOT ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
		<cfelse>
			WHERE movimientos_solicitud.sol_id = #vIdSol#
		</cfif>
	</cfquery>
	<!--- Agregar los identificadores de las solicitudes al arreglo de solicitudes marcadas --->
	<cfloop query="tbSolicitudes">
		<cfif #vTipo# IS 2>
			<!--- Solicitudes en la CAAA --->
			<cfif ArrayContainsValue(Session.AsuntosCAAAFiltro.vMarcadas,tbSolicitudes.sol_id) IS FALSE><cfoutput>#ArrayAppend(Session.AsuntosCAAAFiltro.vMarcadas,tbSolicitudes.sol_id)#</cfoutput></cfif>
		<cfelseif #vTipo# IS 1>
			<!--- Solicitudes en el pleno --->
			<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas,tbSolicitudes.sol_id) IS FALSE><cfoutput>#ArrayAppend(Session.AsuntosCTICFiltro.vMarcadas,tbSolicitudes.sol_id)#</cfoutput></cfif>
		</cfif>
	</cfloop>
<!--- Desmarcar asuntos --->
<cfelseif #vValor# IS 'FALSE'><!--- Debe ser 'FALSE' porque puede enviarse un valor adicional 'CONSULTA' --->
	<cfif #vIdSol# IS 'TODAS'>
		<!--- Vaciar el arreglo de solicitudes marcadas --->
		<cfif #vTipo# IS 2>
			<!--- Solicitudes en la CAAA --->
			<cfoutput>#ArrayClear(Session.AsuntosCAAAFiltro.vMarcadas)#</cfoutput>
		<cfelseif #vTipo# IS 1>
			<!--- Solicitudes en el pleno --->
			<cfoutput>#ArrayClear(Session.AsuntosCTICFiltro.vMarcadas)#</cfoutput>
		</cfif>
	<cfelse>
		<!--- Eliminar el elemento seleccionado --->
		<cfif #vTipo# IS 2>
			<!--- Solicitudes en la CAAA --->
			<cfoutput>#ArrayDeleteAt(Session.AsuntosCAAAFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosCAAAFiltro.vMarcadas,vIdSol))#</cfoutput>
		<cfelseif #vTipo# IS 1>
			<!--- Solicitudes en el pleno --->
			<cfoutput>#ArrayDeleteAt(Session.AsuntosCTICFiltro.vMarcadas,ArrayIndexOf(Session.AsuntosCTICFiltro.vMarcadas,vIdSol))#</cfoutput>
		</cfif>
	</cfif>
</cfif>
<!--- Determinar que solicitudes han sido seleccionadas --->
<cfif #vTipo# IS 1>
	<!--- Determinar hay solicitudes distintas a FT-CTIC-40/FT-CTIC-41 seleccionadas --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#">
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud
			WHERE (mov_clave <> 40 AND mov_clave <> 41)
			AND sol_id = #Session.AsuntosCTICFiltro.vMarcadas[E]#
		</cfquery>
		<cfif #tbSolicitudes.RecordCount# GT 0>
			SELECCION-OTRAS
			<cfbreak>
		</cfif>	
	</cfloop>
	<!--- Determinar hay solicitudes FT-CTIC-40/FT-CTIC-41 seleccionadas --->
	<cfloop index="E" from="1" to="#ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#">
		<cfquery name="tbSolicitudesLYC" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud
			WHERE (mov_clave = 40 OR mov_clave = 41)
			AND sol_id = #Session.AsuntosCTICFiltro.vMarcadas[E]#
		</cfquery>
		<cfif #tbSolicitudesLYC.RecordCount# GT 0>
			SELECCION-LYC
			<cfbreak>
		</cfif>	
	</cfloop>
</cfif> 
