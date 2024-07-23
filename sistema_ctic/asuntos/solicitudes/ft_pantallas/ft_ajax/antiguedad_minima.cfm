<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 06/05/2024 --->
<!--- FECHA ÚLTIMA MOD.: 09/05/2024 --->
<!--- CALCULA LA ANTIGÜEDAD MÍNIMA REQUERIDA --->

<cfparam name="vAcadId" default="11948">
<cfparam name="vMovFechaInicio" default="15/05/2024">

<cfquery name="tbCalculaAntig" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	<!--- mov_clave, mov_fecha_inicio, mov_fecha_final  --->
	FROM ((movimientos 
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave)
	LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave  <!--- ESTE SE DEBE ELIMINAR --->
	WHERE acd_id = #vAcadId#
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'
	AND catalogo_movimiento.mov_antig_filtro = 1
	AND (mov_cancelado IS NULL OR mov_cancelado = 0)
	AND (movimientos.mov_clave = 5 OR movimientos.mov_clave = 6 OR movimientos.mov_clave = 25 OR movimientos.mov_clave = 17 OR movimientos.mov_clave = 46)
	ORDER BY movimientos.mov_fecha_inicio ASC
</cfquery>
	
<cfset vDiasMovimiento = 0>

<cfif CGI.SERVER_PORT IS "31221">
	<br/>Calcula la antigüedad:<br/>
</cfif>
	
<cfoutput query="tbCalculaAntig">
	
	<cfset vMovFechaInicio = #LsDateFormat(mov_fecha_inicio,'yyyy-mm-dd')#>
	<cfset vMovFechaFinal = #LsDateFormat(mov_fecha_final,'yyyy-mm-dd')#>
	<cfset vSolFechaInicio = #LsDateFormat(vSolFechaInicio,'yyyy-mm-dd')#>		
	
	<cfset vDiasDif = #DateDiff('d', vMovFechaFinal, vSolFechaInicio)#>
		
	<cfif #vDiasDif# LT 0>
		<cfset vDiasMovimiento = #vDiasMovimiento# + #DateDiff('d',vMovFechaInicio, vSolFechaInicio)#> <!--- mov_fecha_inicio --->
		<!--- menor a 0 -  --->
	<cfelse>
		<cfset vDiasMovimiento = #vDiasMovimiento# + #DateDiff('d',vMovFechaInicio, vMovFechaFinal)# + 1> <!--- mov_fecha_inicio, mov_fecha_final --->
		<!--- mayor a 0 -  --->
	</cfif>
	<cfif CGI.SERVER_PORT IS "31221">
		#vMovFechaInicio# - #vMovFechaFinal# - #vSolFechaInicio# - #vDiasDif# - #vDiasMovimiento#<br/>
	</cfif>
</cfoutput>

<cfset vAnios = #vDiasMovimiento# / 365>
<cfoutput>
	<input type="#vTipoInput#" id="txtAniosMinimos" name="txtAniosMinimos" value="#vAnios#">
<!---	
	<cfif #vAnios# LT 2>
		<span class="">No cuenta con la antigüedad mínima requerida</span>
	</cfif>
--->
</cfoutput>
