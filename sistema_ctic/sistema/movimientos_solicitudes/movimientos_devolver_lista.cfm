<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 20/11/2015 --->
<!--- FECHA ÚLTIMA MOD.: 04/09/2018 --->

<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT
    T1.mov_id, T1.sol_id, T1.mov_dep_clave, T1.acd_id, T1.mov_clave, T1.mov_numero, T1.mov_fecha_inicio, T1.mov_fecha_final, T1.prog_clave, T1.coa_id, T1.mov_cancelado, T1.mov_modificado,
	T2.acd_id, T2.acd_apepat, T2.acd_nombres,
	C1.mov_titulo_corto,
	C4.cn_siglas,
	C2.dep_siglas,
	C3.dec_super,
    T3.*,
	C5.parte_romano + '.' + LTRIM(STR(T3.asu_numero)) AS SeccionNumero
	FROM ((((((movimientos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id AND T3.asu_reunion = 'CTIC')
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
	LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
	LEFT JOIN catalogo_listado AS C5 ON T3.asu_parte = C5.parte_numero)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE 
	<cfif #vTipoDevolucion# EQ 'SSNID'>
        asu_reunion = 'CTIC'
        AND T3.ssn_id = #vActa#
        <!--- Filtro por tipo de movimiento --->
        <cfif IsDefined('vFt') AND #vFt# NEQ 0>	
            <cfif #vFt# EQ 100>
                AND (T1.mov_clave <> 40 AND T1.mov_clave <> 41)
            <cfelseif #vFt# EQ 101>
                AND (T1.mov_clave = 40 OR T1.mov_clave = 41)
            </cfif>	
        </cfif>
	<cfelseif #vTipoDevolucion# EQ 'SOLID'>
		T1.sol_id = #vpSolId#    
	</cfif>	
	<!--- Ordenamiento --->
	ORDER BY C5.parte_romano, T3.asu_numero
</cfquery>

<!--- VER LOS REGISTROS COMO TABLA --->
<table style="width:800px; margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
	<!-- Encabezados -->
	<cfoutput>
		<tr valign="middle" bgcolor="##CCCCCC">
			<td class="Sans9GrNe" height="18px">No.</td>
			<td class="Sans9GrNe" height="18px">Parte y No. asunto</td>            
			<td class="Sans9GrNe">ENTIDAD </td>
			<td class="Sans9GrNe">NOMBRE</td>
			<td class="Sans9GrNe">MOVIMIENTO</td>
		</tr>
	</cfoutput>
	<!-- Datos -->
	<cfoutput query="tbMovimientos">
		<!--- Documentación digitalizada --->
		<cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
		<cfset vArchivoMovPdf = #vCarpetaAcademicos# & '\' & #vArchivoPdf#>			
		<cfset vArchivoMovPdfWeb = #vWebAcademicos# & '/' & #vArchivoPdf#>
		<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor=''">
			<td><span class="Sans9Gr">#CurrentRow#</span></td>
			<td><span class="Sans9Gr">#SeccionNumero#</span></td>
			<td><span class="Sans9Gr">#tbMovimientos.dep_siglas#</span></td>
			<td><span class="Sans9Gr"><cfif #tbMovimientos.acd_nombres# IS NOT ''>#tbMovimientos.acd_apepat#, #PrimeraPalabra(tbMovimientos.acd_nombres)#</cfif></span></td>
			<td>
				<span class="Sans9Gr">#Ucase(tbMovimientos.mov_titulo_corto)#</span>
			</td>
		</tr>
	</cfoutput>
</table>