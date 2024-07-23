<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 06/05/2009--->
<!--- FECHA ÚLTIMA MOD.: 23/02/2024 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
<!--- Obtener datos de los concursantes a las convocatorias --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_academicos_busqueda
    WHERE
	dbo.SINACENTOS(nombre_completo_busqueda) LIKE '%#NombreSinAcentos(vTexto)#%'
	<cfif #Session.sTipoSistema# IS 'sic' AND #Session.sUsuarioNivel# NEQ 26>
		AND dep_clave = '#Session.sIdDep#'    
    </cfif>
    <cfif #vFT# EQ 38> <!--- SE AGREGÓ PARA FILTRAR INVESTIGADORES TITULARES ACTIVOS 18/10/2023 --->
        AND (cn_siglas LIKE 'INV TIT%' OR cn_siglas LIKE 'INV EME%')
        AND activo = 1
    </cfif>
	ORDER BY nombre_completo_pmn    
<!--- SE ELIMINÓ YA QUE NO PERMITE SELECCIONAR ACADÉMICOS QUE NO SON DE LA UPEID O DE OTRAS ENTIDADES
	<cfif IsDefined("Session.sTipoSistema") AND #Session.sTipoSistema# EQ 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	<cfelseif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# EQ 20>
		AND (dep_clave = '030101' OR dep_clave = '034201' OR dep_clave = '034301' OR dep_clave = '034401' OR dep_clave = '034501')
	</cfif>
--->

</cfquery>
<cfif CGI.SERVER_PORT IS "31221">
    <cfoutput>FT: #vFT#</cfoutput>
</cfif>
<!--- Lista de académcos encontrados --->
<table width="430" align="center">
	<tr>
		<td>
			<select name="selAcadLista" id="selAcadLista" size="5" class="datos" style="width:400px;border-style:solid; border-width:1px;" onchange="fSeleccionaAcad('<cfoutput>#vRegreso#</cfoutput>');">
				<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 17 OR #vFt# EQ 42>
					<option value="NUEVO">NUEVO OPONENTE</option>
				</cfif>
				<cfoutput query="tbAcademicos">
					<option value="#acd_id#">#nombre_completo_pmn#</option><!---#tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#--->
				</cfoutput>
			</select>
		</td>
	</tr>
</table>
