<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 04/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/03/2017 --->
<!--- Generar la lista de estados --->

<cfif #vFt# EQ 1 OR #vFt# EQ 3 OR #vFt# EQ 4 OR #vFt# EQ 113 OR #vFt# EQ 26 OR #vFt# EQ 40 OR #vFt# EQ 41>
	<cfset vNombreCampoEdo = 'pos11_e'>
<cfelse>
	<cfset vNombreCampoEdo = 'edo_clave'>
</cfif>
    
<cfif #vPais# EQ 'MEX' OR #vPais# EQ 'USA'>
    <cfquery name="ctEstados" datasource="#vOrigenDatosCATALOGOS#">
    	SELECT * FROM catalogo_paises_edo 
        WHERE pais_clave = '#vPais#' 
        ORDER BY edo_nombre
    </cfquery>
	<select name="<cfoutput>#vNombreCampoEdo#</cfoutput>" id="<cfoutput>#vNombreCampoEdo#</cfoutput>" class="datos" <cfif #vActivaCampos# EQ "disabled">disabled</cfif> <cfif #vPais# IS 'MEX'>onchange="fDetectarDF(this.value);"</cfif>>
		<option value="">SELECCIONE</option>
		<cfoutput query="ctEstados">
			<option value="#ctEstados.edo_clave#" <cfif #ctEstados.edo_clave# EQ #vCampoPos11_e#>selected</cfif>>#ctEstados.edo_nombre#</option>
		</cfoutput>
	</select>
<cfelse>
	<cfoutput>
		<input name="<cfoutput>#vNombreCampoEdo#</cfoutput>" id="<cfoutput>#vNombreCampoEdo#</cfoutput>" type="text" class="datos" size="50" maxlength="254" value="<cfif #vFt# EQ "FT-CTIC-2"><cfelse>#vCampoPos11_e#</cfif>" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	</cfoutput>
</cfif>
<!---
<cfoutput>#vNombreCampoEdo#</cfoutput>
--->