<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 05/05/2009--->
<!--- Función que determina la sección del listado que corresponde a cada asunto --->
<cffunction name="SeccionEnListado">
	<cfargument name="aLS"><!--- Tipo de listado: CAAA/CTIC --->
	<cfargument name="aFT"><!--- Tipo de asunto --->
	<cfargument name="aAC"><!--- ID del académico (para determinar si hay una solicitud de definitividad) --->
	<cfargument name="aCN3"><!--- Categoría y nivel del academico --->
	<cfargument name="aCN8"><!--- Categoría y nivel del movimiento --->
	<cfargument name="aNC"><!--- Número de COD anteriores --->
	<cfargument name="aBP"><!--- Beca posdoctoral por declieclinación --->
	<!--- NOTA IMPORTANTE: Falta enviar parámetro espacial para las reasignaciones de becas posdoctorales --->
	<!--- Obtener la categoría y nivel en modo texto --->
	<cfif #aCN8# IS NOT ''><cfset aCN = #aCN8#><cfelse><cfset aCN = #aCN3#></cfif><!--- Si hay categoría y nivel del movimiento utilizarla, sino utilizar la del académico --->
	<cfif #aCN# IS NOT ''>
		<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM catalogo_cn WHERE cn_clave = '#aCN#'
		</cfquery>
	</cfif>
	<!--- Determinar la parte del listado donde debe colocarse el asunto --->
	<cfswitch expression="#aFT#">
		<!--- Asuntos que siempre caen en la parte I --->
		<cfcase value="1,2,3,4,11,12,13,15,16,21,22,23,25,26,29,30,32,39">
			<!--- Falta caso especial para FT-CTIC-38 que no se entiende bien --->
			<cfreturn 1>
		</cfcase>
		<!---
		NOTA: Faltan los asuntos que caen en la parte II (el documento que envió Alejandro no incluye ninguno en esta sección)
		--->
		<!--- Asuntos que siempre caen en la parte III --->
		<cfcase value="7,8,17,18,19,20,34,36,37,42,46">
			<cfreturn 3>
		</cfcase>
		<!--- Sesión de becas (1a beca) --->
		<cfcase value="38">
			<cfif #aBP# IS 1><!--- Beca posdoctoral por declinación de otro becario --->
				<cfreturn 1>
			<cfelse>
				<cfreturn 3.1>
			</cfif>
		</cfcase>
		<!--- Sesión de inoformes de becas --->
		<cfcase value="43">
			<cfreturn 3.2>
		</cfcase>
		<!--- Sesión de cátedras Conacyt --->
		<cfcase value="44">
			<cfreturn 3.4>
		</cfcase>
		<!---
		NOTA: Faltan los asuntos que caen en la parte IV (el documento que envió Alejandro no incluye ninguno en esta sección)
		--->
		<!--- Asuntos que siempre caen en la parte V --->
		<cfcase value="40,41">
			<cfreturn 5>
		</cfcase>
		<!--- Asuntos que siempre caen en la parte VI --->
		<cfcase value="31">
			<cfreturn 6>
		</cfcase>
		<!--- Caso especial: COA, puede caer en las secciones I o III --->
		<cfcase value="5,28">
			<cfif #Left(ctCategoria.cn_siglas,3)# IS 'TEC' OR #Find('INV TIT C',ctCategoria.cn_siglas)# IS NOT 0>
				<cfreturn 3>
			<cfelse>
				<cfreturn 1>
			</cfif>
		</cfcase>
		<!--- Caso especial: COD, puede caer en las secciones I o III --->
		<cfcase value="6">
			<cfif #Left(ctCategoria.cn_siglas,3)# IS 'TEC' AND (#aNC# IS '' OR #aNC# IS 0)>
				<cfreturn 3>
			<cfelse>
				<cfreturn 1>
			</cfif>
		</cfcase>
		<!--- Caso especial: PROMOCIÓN DE TÉCNICO, puede caer en la sección I o III del listado CAAA (si se ingresa al mismo tiempo que su definitividad) --->
		<cfcase value="9">
			<!--- Buscar definitividad --->
			<cfquery name="tbSolicitudesDef" datasource="#vOrigenDatosSAMAA#">
				SELECT COUNT(*) FROM movimientos_solicitud WHERE sol_pos2 = #aAC# AND mov_clave = 7
			</cfquery>
			<cfif #tbSolicitudesDef.RecordCount# GT 0 AND #aLS# IS 'CAAA'>
				<cfreturn 3>
			<cfelse>
				<cfreturn 1>
			</cfif>
		</cfcase>
		<!--- Caso especial: PROMOCIÓN DE INVESTIGADOR, puede caer en la sección I o III del listado CAAA (si se ingresa al mismo tiempo que su definitividad) --->
		<cfcase value="10">
			<!--- Buscar definitividad --->
			<cfquery name="tbSolicitudesDef" datasource="#vOrigenDatosSAMAA#">
				SELECT COUNT(*) FROM movimientos_solicitud WHERE sol_pos2 = #aAC# AND mov_clave = 8
			</cfquery>
			<cfif #Find('TIT C',ctCategoria.cn_siglas)# GT 0 OR (#tbSolicitudesDef.RecordCount# GT 0 AND #aLS# IS 'CAAA')>
				<cfreturn 3>
			<cfelse>
				<cfreturn 1>
			</cfif>
		</cfcase>
		<!--- Asuntos que no aparecen en los listados --->
		<cfdefaultcase>
			<cfreturn 7>
		</cfdefaultcase>
	</cfswitch>
</cffunction>
