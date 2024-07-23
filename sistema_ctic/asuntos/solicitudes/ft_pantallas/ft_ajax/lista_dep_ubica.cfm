<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA: 22/06/2009 --->
<!--- Generar la lista de ubicaciones de las dependencias del subsistema --->
	
	<!--- Obtener la lista de ubicaciones de la dependencia --->
    <cfquery name="ctUbicacion" datasource="#vOrigenDatosSAMAA#">
	    SELECT * FROM catalogo_dependencia_ubica 
	    WHERE dep_clave = '#vPos11#' AND ubica_status = 1
        ORDER BY ubica_clave
    </cfquery>

	<!--- Generar la lista de ubicaciones --->
	<select name="pos11_u" id="pos11_u" class="datos" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> style="width:480px;">
		<cfif #ctUbicacion.recordcount# GT 1>
			<option value="">SELECCIONE</option>
		</cfif>
		<cfoutput query="ctUbicacion">
			<option value="#ctUbicacion.ubica_clave#" <cfif #ctUbicacion.ubica_clave# EQ #vCampopos11_u#>selected</cfif>>#ctUbicacion.ubica_nombre#, #ctUbicacion.ubica_lugar#</option>
		</cfoutput>
	</select>
