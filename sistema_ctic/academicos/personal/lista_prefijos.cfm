<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 04/05/2009 --->
<!--- AJAX para filtrar la lista de prefijos, según el grado académico --->

<!---
<cfif #vGrado# IS ""><cfset vGrado=0></cfif>
--->

<cfquery name="ctPrefijo" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_grado_prefijo
	WHERE 1 = 1
    AND grado_clave = <cfif #vGrado# NEQ "">#vGrado#<cfelse>99</cfif>
	ORDER BY grado_prefijo
</cfquery>

<select name="acd_prefijo" id="acd_prefijo" class="datos" <cfif #vDisabled# IS TRUE>disabled</cfif>>
	<option value="">SELECCIONE</option>
	<cfoutput query="ctPrefijo">
		<option value="#ctPrefijo.grado_prefijo#" <cfif #ctPrefijo.grado_prefijo# EQ #vPrefijo#>selected</cfif>>#ctPrefijo.grado_prefijo_txt#</option>
	</cfoutput>
</select>