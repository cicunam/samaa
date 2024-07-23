<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 12/10/2009 --->
<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Obtener la lista de movimientos del académico --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT DISTINCT 
	movimientos.*, 
	academicos.acd_id, 
	convocatorias_coa_concursa.coa_id AS coa_acd_id,
	movimientos_asunto.ssn_id, movimientos_asunto.asu_oficio,
	catalogo_movimiento.mov_titulo, catalogo_movimiento.mov_titulo_corto,
	catalogo_dependencia.dep_siglas, catalogo_dependencia.dep_nombre,
	catalogo_decision.dec_super,
	catalogo_cn.cn_siglas
	FROM 
	(((((( movimientos 
	LEFT JOIN academicos ON movimientos.acd_id = academicos.acd_id)
	LEFT JOIN convocatorias_coa_concursa ON movimientos.coa_id = convocatorias_coa_concursa.coa_id AND coa_ganador = 0)
	LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id AND (movimientos_asunto.ssn_id = (SELECT MAX(ssn_id) FROM movimientos_asunto WHERE sol_id = movimientos.sol_id) OR movimientos_asunto.ssn_id IS NULL))<!--- IMPORTANTE: Obtener el registro más reciente de la tabla de asuntos --->
	LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN catalogo_dependencia ON movimientos.dep_clave = catalogo_dependencia.dep_clave)
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave)
	LEFT JOIN catalogo_cn ON CASE WHEN movimientos.mov_cn_clave IS NULL THEN movimientos.cn_clave ELSE movimientos.mov_cn_clave END = catalogo_cn.cn_clave
	WHERE asu_reunion = 'CTIC'
	AND (movimientos.acd_id = #vIdAcad# OR convocatorias_coa_concursa.acd_id = #vIdAcad#)
	<!--- Ordenamiento --->
    ORDER BY movimientos_asunto.ssn_id DESC
	<!--- <cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif> --->
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbMovimientos>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaINCLUDE#/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">
<!--- Tabla de datos --->
<cfif #tbMovimientos.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="height:auto; width:100%; margin:5px; border:none;" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
			<tr valign="middle" bgcolor="##CCCCCC">
				<td height="15" class="Sans10GrNe" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif> style="cursor:pointer;">MOVIMIENTO</td>
                <td class="Sans10GrNe">D/C</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'mov_fecha_inicio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_inicio','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_inicio','DESC');"</cfif> style="cursor:pointer;">INICIO</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'mov_fecha_final' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_final','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_final','DESC');"</cfif> style="cursor:pointer;">TÉRMINO</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif> style="cursor:pointer;">CCN</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif> style="cursor:pointer;">ENTIDAD</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'ssn_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'ssn_id','ASC');"<cfelse>onclick="fListarMovimientos(1,'ssn_id','DESC');"</cfif> style="cursor:pointer;">SESIÓN</td>
				<td class="Sans10GrNe" <cfif #vOrden# IS 'asu_oficio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'asu_oficio','ASC');"<cfelse>onclick="fListarMovimientos(1,'asu_oficio','DESC');"</cfif> style="cursor:pointer;">OFICIO</td>
				<td class="Sans10GrNe">DEC.</td>
			</tr>
		</cfoutput>
		<!-- Datos -->
		<cfoutput query="tbMovimientos" startrow="#StartRow#" maxrows="#MaxRows#"> 			
		<!--- Siglas de la dependencia a la que se cambia (FT-CTIC-13) --->
		<cfif #tbMovimientos.mov_clave# EQ 13>
			<cfquery name="ctDepTmp" datasource="#vOrigenDatosSAMAA#">
				SELECT dep_siglas FROM catalogo_dependencia 
                WHERE dep_clave = '#tbMovimientos.mov_dep_clave#'
			</cfquery>
		</cfif>
		<!--- Documentación digitalizada --->
		<cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
		<cfset vArchivoMovPdf = #vCarpetaAcademicos# & '\' & #vArchivoPdf#>			
		<cfset vArchivoMovPdfWeb = #vWebAcademicos# & '/' & #vArchivoPdf#>
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##fafafa'">
			<td class="Sans10Gr">#Ucase(tbMovimientos.mov_titulo_corto)# <span class="Sans10Vi"><cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif> <cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif></span></td>
			<td class="Sans10Gr"><cfif #tbMovimientos.mov_clave# EQ 6>#IIF(tbMovimientos.mov_numero IS '', 0, tbMovimientos.mov_numero)  + 1#<cfelseif #tbMovimientos.mov_clave# EQ 25>#tbMovimientos.mov_numero#</cfif><cfif (#tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41) AND (#mov_fecha_inicio# NEQ '' AND #mov_fecha_final# NEQ '')>#DateDiff('d',mov_fecha_inicio, mov_fecha_final) + 1#</cfif></td>
			<td class="Sans10Gr">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</td>
			<td class="Sans10Gr">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>
			<td class="Sans10Gr">#CnSinTiempo(tbMovimientos.cn_siglas)#</td>
			<td class="Sans10Gr">#tbMovimientos.dep_siglas#<cfif #tbMovimientos.mov_clave# EQ 13>-#ctDepTmp.dep_siglas#</cfif></td>
			<td class="Sans10Gr">#tbMovimientos.ssn_id#</td>
			<td class="Sans10Gr">#SoloNumeroOficio(tbMovimientos.asu_oficio)#</td>
			<td class=<cfif #tbMovimientos.dec_super# IS 'AP' AND  #tbMovimientos.coa_acd_id# IS ''>"Sans10Gr"<cfelse>"Sans10Vi"</cfif>><cfif #tbMovimientos.coa_acd_id# IS ''>#tbMovimientos.dec_super#<cfelse>NA</cfif></td>
		</tr>
		</cfoutput>
  </table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">
<!--- Contador de regstros --->
<cfoutput>
	<center>
		<span class="Sans10ViNe" style="margin:5px;"><cfif #tbMovimientos.RecordCount# GT 0>Registros #StartRow# al #EndRow# de #tbMovimientos.RecordCount#<cfelse>No se encontr&oacute; ning&uacute;n movimiento en el historial del acad&eacute;mico.</cfif></span>
	</center>
</cfoutput>
