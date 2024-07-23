<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 04/05/2009 --->

<!--- Generar la lista de estados de la República Mexicana --->
<cfif #vPais# EQ 'MEX' OR #vPais# EQ 'USA'>
    <cfquery name="ctEstados" datasource="#vOrigenDatosSAMAA#">
    	SELECT * FROM catalogo_pais_edo WHERE pais_clave = '#vPais#' ORDER BY edo_nombre
    </cfquery>
	<select name="edo_clave" id="edo_clave" class="datos" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
		<option value="">SELECCIONE</option>
		<cfoutput query="ctEstados">
			<option value="#ctEstados.edo_clave#" <cfif #ctEstados.edo_clave# EQ #vEstado#>selected</cfif>>#ctEstados.edo_nombre#</option>
		</cfoutput>
	</select>
<cfelse>
	<cfoutput>
		<input name="edo_clave" id="edo_clave" type="text" class="datos" size="50" maxlength="254" value="#vEstado#" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	</cfoutput>
</cfif>	
