<cfparam name="vDepClave" default="0">
<cfparam name="vUbicaClave" default="0">
<cfparam name="vHabilitaDes" default="">
<cfparam name="vTipoConsulta" default="">


<!--- Abrir el catálogo de ubicación de dependencias (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctSubdependencia" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_dependencias_ubica
	WHERE 1 = 1 
	<cfif #vTipoConsulta# NEQ 'T'>AND  ubica_status = 1</cfif>
	<cfif #vDepClave# NEQ "0">AND dep_clave = '#vDepClave#'</cfif>
	ORDER BY ubica_clave ASC 
</cfquery>

<select name="dep_ubicacion" id="dep_ubicacion" class="datos" tabindex="5" style="width: 450px;" <cfif #vHabilitaDes# IS true>disabled</cfif>>
	<cfif #ctSubdependencia.recordcount# GT 1><option value="0">SELECCIONE</option></cfif>
	<cfoutput query="ctSubdependencia">
		<option value="#ubica_clave#" <cfif #ubica_clave# EQ #vUbicaClave#>selected</cfif>>
			<cfif #ubica_nombre# EQ "CAMPUS">#ubica_lugar#<cfelse>#ubica_nombre# #ubica_lugar#</cfif>
		</option>
	</cfoutput>
</select>