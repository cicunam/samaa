<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 26/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 13/11/2019 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
<!--- NOTA: Pendiente hacer que pasen bien las Ñ en Microsoft Internet Explorer --->
<!--- Obtener datos de los académicos encontrados --->

<cfparam name="vCss" default="datos100">
<cfparam name="vpAcdActivo" default="0">

<cfquery name="tbAcademicoLista" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_academicos_busqueda
    WHERE
	<cfif #vTipoBusq# EQ 'NAME'>
		dbo.SINACENTOS(nombre_completo_busqueda) LIKE '%#NombreSinAcentos(vTexto)#%' <!--- SE REMPLAZÓ EL --->
	<cfelseif #vTipoBusq# EQ 'RFC'>
		acd_rfc LIKE '%#vTexto#%'
	<cfelseif #vTipoBusq# EQ 'CLAVE'>
		acd_id = #vTexto#
	</cfif>
	<cfif IsDefined("Session.sTipoSistema") AND #Session.sTipoSistema# EQ 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	<cfelseif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# EQ 20>
		AND (dep_clave = '030101' OR dep_clave = '034201' OR dep_clave = '034301' OR dep_clave = '034401' OR dep_clave = '034501')
	</cfif>
	<cfif #vpAcdActivo# EQ 1>
		AND activo = 1
	</cfif>
	ORDER BY nombre_completo_pmn
</cfquery>

<select name="lstAcad" id="lstAcad" size="5" <cfif #vCss# EQ 'datos100'> class="datos100" style="width:450px;"<cfelse>class="form-control" style="background-color:#FFFFFF"</cfif>>
	<cfoutput query="tbAcademicoLista">
    	<option value="#acd_id#" onclick="fSeleccionAcademico();">
			#nombre_completo_pmn#<cfif #Session.sTipoSistema# EQ 'stctic'> - (#dep_siglas#)</cfif>
		</option>
	</cfoutput>
</select>
