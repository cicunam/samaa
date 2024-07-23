<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 08/02/2024 --->
<!--- FECHA ULTIMA MOD.: 09/02/2024 --->
<!--- CÓDIGO QUE PERIMTE EXPORTAR EL DIRECTORIO CON FILTROS SELECCIONADOS  --->

<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
<cfquery name="tbConsejeros" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_cargos_acadadm
	WHERE 1 = 1
	<cfif #Session.ConsejerosFiltro.vActivos# EQ 'checked'>
		AND caa_status = 'A'
	</cfif>
	<cfif #Session.ConsejerosFiltro.vAdmClave# NEQ ''>
		AND adm_clave = '#Session.ConsejerosFiltro.vAdmClave#'
	</cfif>
	<cfif #Session.ConsejerosFiltro.vDep# NEQ ''>
		AND dep_clave LIKE '#Session.ConsejerosFiltro.vDep#%'
	</cfif>
	ORDER BY adm_clave DESC, dep_siglas ASC
</cfquery>

<cfif #Session.ConsejerosFiltro.vAdmClave# EQ ''>
	<cfset vDirectorio = 'CTIC'>
<cfelseif #Session.ConsejerosFiltro.vAdmClave# EQ '32'>
	<cfset vDirectorio = 'directores'>
<cfelseif #Session.ConsejerosFiltro.vAdmClave# EQ '1'>
	<cfset vDirectorio = 'consejerosrep'>
<cfelseif #Session.ConsejerosFiltro.vAdmClave# EQ '82'>
	<cfset vDirectorio = 'secacad'>		
</cfif>

<cfheader name="Content-Disposition" value="attachment; filename=#DateFormat(Now(),"yymmdd")#_SAMAA_DIRECTORIO_#vDirectorio#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">
	
<html
	xmlns:o="urn:schemas-microsoft-com:office:office"
	xmlns:x="urn:schemas-microsoft-com:office:excel"
	xmlns="http://www.w3.org/TR/REC-html40">

	<table style="margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<tr valign="middle" height="18px" bgcolor="#CCCCCC">
			<td class="Sans9GrNe">ENTIDAD</td>
			<td class="Sans9GrNe">NOMBRE</td>
			<td class="Sans9GrNe">CARGO</td>
			<td class="Sans9GrNe">Correo electrónico personal</td>
			<td class="Sans9GrNe">Correo electrónico</td>
			<td class="Sans9GrNe">PERIODO / A PARTIR DE</td>
		</tr>
		<cfoutput query="tbConsejeros">
			<!--- Crea variable de archivo de solicitud --->
			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td valign="top"><span class="Sans9Gr">#dep_nombre_may_min#</span></td>
				<td valign="top"><span class="Sans9Gr">#acd_prefijo# #nombre_completo_npm#</span></td>
				<td valign="top" title="#adm_descrip#"><span class="Sans9Gr">#adm_descrip# <cfif adm_clave EQ 13> T.A.</cfif></span></td>
				<td valign="top"><span class="Sans9Gr">#acd_email#</span></td>
				<td valign="top"><span class="Sans9Gr">#caa_email#</span></td>
				<td valign="top"><span class="Sans9Gr">#LsDateFormat(caa_fecha_inicio, 'dd/mm/yyyy')# - #LsDateFormat(caa_fecha_final, 'dd/mm/yyyy')#</span></td>
			</tr>
		</cfoutput>
	</table>|
</html>