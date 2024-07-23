<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO--24/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 24/06/2016 --->
<!--- COMPLEMENTO DE PARA USAR UN CONTROL Y DESPLEGAR UN AJAX O JQUERY DE INSTITUCIONES --->



<cfparam name="vTextoInstBusqueda" default="">
<cfparam name="vPaisClave" default="MEX">
<cfparam name="vTipoVista" default="L">

<!--- Obtener datos del catalogo de países  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctInstituciones" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_instituciones
	WHERE 1 = 1
	<cfif #vTextoInstBusqueda# NEQ '' AND #vTipoVista# EQ 'L'>
        AND
        (institucion_nombre LIKE '%#vTextoInstBusqueda#' OR institucion_nombre LIKE '%#vTextoInstBusqueda#%' OR institucion_nombre LIKE '#vTextoInstBusqueda#%')
        OR
        (institucion_nombre_org LIKE '%#vTextoInstBusqueda#' OR institucion_nombre_org LIKE '%#vTextoInstBusqueda#%' OR institucion_nombre_org LIKE '#vTextoInstBusqueda#%')
	</cfif>
	<cfif vPaisClave NEQ ''>
    	pais_clave = '#vPaisClave#'
	</cfif>
	ORDER BY institucion_nombre
</cfquery>

<cfif #vTipoVista# EQ 'L'>
	<select name="lstAcad" id="lstAcad" size="5" class="datos100" onchange="fSeleccionInstitucion();" style="width:500px;">
		<option value="">-- OTRA INSTITUCION QUE NO APARECE EN CATÁLOGO --</option>
		<cfoutput query="ctInstituciones">
			<option value="#institucion_clave#">#institucion_nombre#</option>
		</cfoutput>
	</select>
<cfelseif #vTipoVista# EQ 'S'>
	<select name="lstAcad" id="lstAcad" class="datos100" onchange="fSeleccionInstitucion();" style="width:500px;">
		<option value="">-- OTRA INSTITUCION QUE NO APARECE EN CATÁLOGO --</option>
		<cfoutput query="ctInstituciones">
			<option value="#institucion_clave#">#institucion_nombre#</option>
		</cfoutput>
	</select>
</cfif>