<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 06/09/2017 --->
<!--- FECHA ULTIMA MOD.: 06/09/2017 --->
<!--- LISTA DE SESIONES DEL CTIC --->

<cfparam name="vSsnClave" default="0">
<cfparam name="vSesionAnioConsulta" default="0">


<cfquery name="tbCatalogoAnios" datasource="#vOrigenDatosSAMAA#">
	SELECT YEAR(ssn_fecha) as vAnios FROM sesiones
	<cfif #vSsnClave# NEQ 0>
	    WHERE ssn_clave = #vSsnClave#
	</cfif>
	GROUP BY YEAR(ssn_fecha)
	ORDER BY YEAR(ssn_fecha) DESC
</cfquery>

<cfform name="frmAnio" id="frmAnio">
    <span class="Sans10Ne">A&ntilde;o: </span>
    <cfselect name="vAnio" id="vAnio" query="tbCatalogoAnios" queryPosition="below" selected="#vSesionAnioConsulta#" display="vAnios" label="vAnios" onChange="fSesionFiltro();" class="datos">
		<cfif #vSsnClave# GT 1>
        	<option value="0">TODOS</option>
		</cfif>
    </cfselect>
</cfform>