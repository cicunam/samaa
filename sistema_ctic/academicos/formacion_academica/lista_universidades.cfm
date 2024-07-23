<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 04/05/2009 --->
<!--- LISTA DE UNIVERSIDADES DE UN PAÍS --->
<!--- Obtener la lista de universidades --->
<cfquery name="ctUniversidad" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_instituciones
	WHERE pais_clave = '#vPais#'
	ORDER BY institucion_nombre
</cfquery>
<!--- Crear el control para seleccionar la universidad --->
<select name="institucion_clave" id="institucion_clave" class="datos100" onchange="fActualizar();" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	<option value="">SELECCIONE</option>
	<cfoutput query="ctUniversidad">
		<option value="#institucion_clave#" <cfif IsDefined('vInstitucionClave') AND #vInstitucionClave# IS #institucion_clave#>selected</cfif>>
			#institucion_nombre# <cfif #institucion_ubica# NEQ ''> - #institucion_ubica#</cfif>
		</option>
	</cfoutput>
</select>

