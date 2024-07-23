<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA: 25/11/2009 --->
<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Parámetros --->
<cfparam name="vIdAcad" default="">
<cfparam name="vRfcAcad" default="">
<cfparam name="vSelAcad" default="">
<cfparam name="PageNum_tbMovimientos" default="1">
<cfset vAnioActual = #VAL(LsDateFormat(now(),'yyyy'))#>
<!--- Obtener datos del académico --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((academicos
	LEFT JOIN catalogo_dependencia ON academicos.dep_clave = catalogo_dependencia.dep_clave)
	LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave)
	LEFT JOIN catalogo_contrato ON academicos.con_clave = catalogo_contrato.con_clave
	<cfif IsDefined("vIdAcad") AND #vIdAcad# IS NOT ''>
		WHERE acd_id = #vIdAcad#
	<cfelseif IsDefined("vRfcAcad") AND #vRfcAcad# IS NOT ''>
		WHERE acd_rfc = '#vRfcAcad#'
	<cfelseif IsDefined("vSelAcad") AND #vSelAcad# IS NOT ''>
		WHERE acd_id = #vSelAcad#
	<cfelse>
		WHERE 1 = 0
	</cfif>
</cfquery>
<cfquery name="dbLicencias" datasource="#vOrigenDatosSAMAA#">
	SELECT SUM(DATEDIFF(day, mov_fecha_inicio, mov_fecha_final) + 1) AS vDiasLic 
	FROM (movimientos
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE acd_id = #vIdAcad# 
	AND (mov_clave = 24 OR mov_clave = 41) 
	AND YEAR(mov_fecha_inicio) = #vAnioActual# 
	AND asu_reunion = 'CTIC'
	AND dec_super = 'AP'
</cfquery>
<!---
<cfset Session.MovimientosAcadFiltro.vIdAcad = '#tbAcademicos.acd_id#'>
<cfset Session.MovimientosAcadFiltro.vPagina = '#vPagina#'>
--->
<!--- Obtener la cadena de texto de la antiguedad académica --->	
<cfif #tbAcademicos.fecha_pc# NEQ "">
	<cfset vF1 = #tbAcademicos.fecha_pc#>
	<cfset vFF = #Now()#>
	<!--- Calcular años, meses y días --->
	<cfset vAntigAcadAnios = #DateDiff('yyyy',#vF1#, vFF)#>
	<cfset vF2 = #dateadd('yyyy',vAntigAcadAnios,vF1)#>
	<cfset vAntigAcadMeses = #DateDiff('m',#vF2#, vFF)#>
	<cfset vF3 = #dateadd('m',vAntigAcadMeses,vF2)#>			
	<cfset vAntigAcadDias = #DateDiff('d',#vF3#, vFF)#>
	<!--- Construir la cadena de texto que se mostrará --->
	<cfset vAntiguedad = "">
	<cfif #vAntigAcadAnios# GT 0><cfset vAntiguedad = #vAntigAcadAnios# & " año(s) "></cfif>
	<cfif #vAntigAcadMeses# GT 0><cfset vAntiguedad = #vAntiguedad# & #vAntigAcadMeses# & " mes(es) "></cfif>
	<cfif #vAntigAcadDias# GT 0><cfset vAntiguedad = #vAntiguedad#  & #vAntigAcadDias# & " día(s)"></cfif>
<cfelse>
	<cfset vAntiguedad = "">
</cfif>
<!--- Datos del académico --->
<cfif #tbAcademicos.RecordCount# GT 0>
	<cfoutput>
	<table style="width:800px; margin: 10px 0px 2px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Nombre del académico -->
		<tr>
			<td colspan="4">
				<span class="Sans12GrNe">#tbAcademicos.acd_prefijo# #tbAcademicos.acd_nombres# #tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat#</span>
			</td>
		</tr>
		<!-- Dependencia de adscripción -->
		<tr>
			<td colspan="4">
				<cfif #tbAcademicos.dep_nombre# IS NOT ''>
					<span class="Sans12GrNe"><i>#Ucase(tbAcademicos.dep_nombre)#</i></span>
				</cfif>
			</td>
		</tr>
		<!-- Información académica (encabezados) -->
		<tr>
			<td><span class="Sans10NeNe">Categor&iacute;a y nivel:</span></td>
			<td><span class="Sans10NeNe">Tipo de contrato:</span></td>
			<td><span class="Sans10NeNe">Antig&uuml;edad acad&eacute;mica:</span></td>
			<td align="right"><span class="Sans10NeNe">ID:</span></td>
		</tr>
		<!-- Información académica (datos) -->
		<tr>
			<!-- Categoría y nivel -->
			<td>
				<cfif #tbAcademicos.cn_siglas# IS NOT ''>
					<span class="Sans10Ne">#tbAcademicos.cn_siglas#</span>
					<br />
				</cfif>
			</td>
			<!-- Tipo de contrato -->
			<td>
				<cfif #tbAcademicos.con_descrip# IS NOT ''>
					<span class="Sans10Ne">#tbAcademicos.con_descrip#</span>
				</cfif>
			</td>
			<!-- Antiguedad académica -->
			<td>
				<cfif #vAntiguedad# IS NOT ''>
					<span class="Sans10Ne">#vAntiguedad#</span>
				</cfif>
			</td>
			<!-- Identificador -->
			<td align="right">
				<span class="Sans10Ne">#tbAcademicos.acd_id#</span>
			</td>
		</tr>
		<tr height="2"><td></td></tr>
		<!-- Días de licencia disfrutados durante el año -->
		<tr bgcolor="##F6F6F6">
			<td colspan="4" align="center">
				<i>
				<span class="Sans11Ne">Días de licencias con goce de sueldo disfrutados durante el a&ntilde;o:&nbsp;</span>
				<span class="Sans11ViNe"><cfif #dbLicencias.vDiasLic# GT 0><cfoutput>#dbLicencias.vDiasLic#</cfoutput><cfelse>0</cfif></span>
				</i>
			</td>
		</tr>
	</table>
	</cfoutput>
</cfif>
