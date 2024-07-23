<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA.: 30/01/2017 --->
<!--- FECHA ÚLTIMA MOD.: 30/01/2017 --->

<!--- Abrir el catálogo de paises (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPaisEdo" datasource="#vOrigenDatosCATALOGOS#">
	SELECT *
    FROM catalogo_paises_edo 
	WHERE pais_clave = 'MEX'
    ORDER BY edo_nombre ASC
</cfquery>

<select name="edo_clave" id="edo_clave" class="datos" <cfif #vHabilitaDes# IS TRUE>disabled</cfif>>
	<option value="">SELECCIONE</option>
	<cfoutput query="ctPaisEdo">
		<cfif #vTipoClaveEdo# EQ 'INEGI'>
			<option value="#inegi_edo_nac_clave#" <cfif #inegi_edo_nac_clave# EQ #vEdoClave#>selected</cfif>>#edo_nombre#</option>
		<cfelseif #vTipoClave# EQ 'ISO3'>
			<option value="#edo_clave#" <cfif #edo_clave# EQ #vEdoClave#>selected</cfif>>#edo_nombre#</option>
		</cfif>
	</cfoutput>
</select>