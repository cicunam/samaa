<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 04/05/2009 --->
<!--- FECHA CREA: 04/05/2009 --->
<!--- LISTA CARRERAS UNAM --->
<!--- Obtener la lista de universidades --->

<cfquery name="ctCarrera" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_unam_carreras
	WHERE grado_clave = '#vGrado#'
	ORDER BY car_nombre
</cfquery>
<!---
<cfquery name="ctCarrera" datasource="#vOrigenDatosCURRICULUM#">
	SELECT * FROM catalogo_carrera
	WHERE grado_clave = '#vGrado#'
	ORDER BY car_nombre
</cfquery>
--->
<!--- Crear el control para seleccionar la universidad --->
<select name="car_clave" id="car_clave" class="datos100" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	<option value="">SELECCIONE</option>
	<cfoutput query="ctCarrera">
		<option value="#car_clave#" <cfif #vCarrera# IS #car_clave#>selected</cfif>>#car_nombre#</option>
	</cfoutput>
</select>

