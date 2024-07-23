<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA: 22/06/2009 --->
<!--- Generar la lista de ubicaciones de las dependencias del subsistema --->
	
<!--- Obtener la lista de ubicaciones de la dependencia --->
   <cfquery name="ctUbicacion" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM catalogo_dependencia_ubica 
    <cfif #vDep# IS NOT ''>WHERE dep_clave = '#vDep#'</cfif> 
       ORDER BY ubica_clave
   </cfquery>

<!--- Generar la lista de ubicaciones --->
<select name="<cfoutput>#vCampo#</cfoutput>" id="<cfoutput>#vCampo#</cfoutput>" class="datos100" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	<cfif #ctUbicacion.recordcount# GT 1>
		<option value="">SELECCIONE</option>
	</cfif>
	<cfoutput query="ctUbicacion">
		<option value="#ctUbicacion.ubica_clave#" <cfif #ctUbicacion.ubica_clave# EQ #vUbica#>selected</cfif>>#ctUbicacion.ubica_nombre#, #ctUbicacion.ubica_lugar#</option>
	</cfoutput>
</select>