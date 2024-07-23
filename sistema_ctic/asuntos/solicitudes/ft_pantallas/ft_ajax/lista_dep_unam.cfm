<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 22/06/2009 --->
<!--- FECHA ÚLTIMA MOD.: 26/02/2024 --->

	<!--- Obtener la lista de las dependencias del subsistema seleccionado--->
	<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
		SELECT * FROM catalogo_dependencias
		WHERE dep_clave LIKE '#vSubsistema#%' 
		AND dep_status = 1 
		ORDER BY dep_nombre
    </cfquery>
	<!--- Generar la lista de dependencias --->
	<select name="pos11" id="pos11" class="datos" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> style="width:480px;" <cfif #vSubsistema# EQ '03'>onChange="fObtenerUbicaSIC();"</cfif>>
		<option value="">SELECCIONE</option>
		<cfoutput query="ctDependencia">
			<option value="#ctDependencia.dep_clave#" <cfif #ctDependencia.dep_clave# EQ #vCampoPos11#>selected</cfif>>#ctDependencia.dep_nombre#</option>
		</cfoutput>
	</select>
