<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/09/2017 --->
<!--- FECHA ÚLTIMA MOD: 25/09/2017 --->

<!--- SE HIZO ESTE AJAX PARA PODER SACAR EL VALOR DE LA VARIABLE DE SESIÓN SIN NECESIDAD DE REFRESCAR TODO EL SITIO --->

	<cfif #vSubmenuActivo# EQ 1>
    	<cfset vArrayLen = #ArrayLen(Session.AsuntosCTICFiltro.vMarcadas)#>
	<cfelseif #vSubmenuActivo# EQ 2>
    	<cfset vArrayLen = #ArrayLen(Session.AsuntosCAAAFiltro.vMarcadas)#>
	</cfif>    

	<cfoutput>
		<input type="hidden" id="hiddRegMarcados" name="hiddRegMarcados" value="#vArrayLen#" />
	</cfoutput>        