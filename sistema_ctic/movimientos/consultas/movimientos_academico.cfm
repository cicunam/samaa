<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 16/05/2022 --->

<!--- LISTA DE MOVIMIENTOS DE UN ACADÉMICO --->
<!--- Registrar el filtro --->

<cfset Session.MovimientosAcadFiltro.vIdAcad = #vIdAcad#>
<cfset Session.MovimientosAcadFiltro.vNomAcad = '#vNomAcad#'>
<cfset Session.MovimientosAcadFiltro.vRfcAcad = '#vRfcAcad#'>
<cfset Session.MovimientosAcadFiltro.vFt = '#vFt#'>
<cfset Session.MovimientosAcadFiltro.vAnioMov = #vAniosMov#>
<cfset Session.MovimientosAcadFiltro.vPagina = #vPagina#>
<cfset Session.MovimientosAcadFiltro.vRPP = #vRPP#>
<cfset Session.MovimientosAcadFiltro.vOrden = '#vOrden#'>
<cfset Session.MovimientosAcadFiltro.vOrdenDir = '#vOrdenDir#'>

<cfset vModuloConsutla = 'MOV'>
<!---  INCLUDE PARA LISTAR LOS MOVIMIENTOS DEL ACADÉMICO --->
<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/include_movimientos_academico.cfm">


<!---
<cfif #FindNoCase('/sistema_ctic/movimientos/consultas/consulta_academico.cfm', Session.sModulo)# IS NOT 0>
	<cfset Session.MovimientosAcadFiltro.vIdAcad = #vIdAcad#>
	<cfset Session.MovimientosAcadFiltro.vNomAcad = '#vNomAcad#'>
	<cfset Session.MovimientosAcadFiltro.vRfcAcad = '#vRfcAcad#'>
	<cfset Session.MovimientosAcadFiltro.vFt = '#vFt#'>
	<cfset Session.MovimientosAcadFiltro.vAnioMov = #vAniosMov#>
	<cfset Session.MovimientosAcadFiltro.vPagina = #vPagina#>
	<cfset Session.MovimientosAcadFiltro.vRPP = #vRPP#>
	<cfset Session.MovimientosAcadFiltro.vOrden = '#vOrden#'>
	<cfset Session.MovimientosAcadFiltro.vOrdenDir = '#vOrdenDir#'>
<cfelse>
	<cfset Session.AcademicosMovFiltro.vIdAcad = #vIdAcad#>
	<cfset Session.AcademicosMovFiltro.vNomAcad = '#vNomAcad#'>
	<cfset Session.AcademicosMovFiltro.vRfcAcad = '#vRfcAcad#'>
	<cfset Session.AcademicosMovFiltro.vFt = '#vFt#'>
	<cfset Session.AcademicosMovFiltro.vAnioMov = #vAniosMov#>
	<cfset Session.AcademicosMovFiltro.vPagina = #vPagina#>
	<cfset Session.AcademicosMovFiltro.vRPP = #vRPP#>
	<cfset Session.AcademicosMovFiltro.vOrden = '#vOrden#'>
	<cfset Session.AcademicosMovFiltro.vOrdenDir = '#vOrdenDir#'>
</cfif>

<!--- Obtener la lista de movimientos del académico --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT DISTINCT
	T1.*,
	T2.acd_id,
	T4.coa_id AS coa_acd_id,
    T4.coa_ganador,    
	T3.ssn_id, T3.asu_oficio,
	C1.mov_titulo, C1.mov_titulo_corto,
	C2.dep_siglas, C2.dep_nombre,
	C3.dec_super,
	C4.cn_siglas
	FROM
	(((((( movimientos AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
	LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id AND (T3.ssn_id = (SELECT MAX(ssn_id) FROM movimientos_asunto WHERE sol_id = T1.sol_id) OR T3.ssn_id IS NULL))<!--- IMPORTANTE: Obtener el registro más reciente de la tabla de asuntos --->
	LEFT JOIN convocatorias_coa_concursa AS T4 ON T1.coa_id = T4.coa_id AND T4.acd_id = #vIdAcad#)
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE asu_reunion = 'CTIC'
	AND (T1.acd_id = #vIdAcad# OR T4.acd_id = #vIdAcad#)
	<!--- Filtro por tipo de movimiento --->
	<cfif IsDefined('vFt') AND #vFt# NEQ 0>
	 	<cfif #vFt# EQ 100>
			AND (T1.mov_clave <> 40 AND T1.mov_clave <> 41)
        <cfelseif #vFt# EQ 101>
			AND (T1.mov_clave = 40 OR T1.mov_clave = 41)
        <cfelse>
			AND T1.mov_clave = #vFt#
		</cfif>
	</cfif>
	<!--- Filtro por año de movimiento --->
    <cfif IsDefined("vAniosMov") AND #vAniosMov# GT 0>
    	AND YEAR(T1.mov_fecha_inicio) = #vAniosMov#
    </cfif>
	<!--- Ordenamiento --->
	<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
</cfquery>
<!--- Variables de paginación --->
<cfset vConsultaTabla = tbMovimientos>
<cfif #FindNoCase('/sistema_ctic/movimientos/consultas/consulta_academico.cfm', Session.sModulo)# IS NOT 0>
	<cfset vConsultaFiltro = Session.MovimientosAcadFiltro>
<cfelse>
	<cfset vConsultaFiltro = Session.AcademicosMovFiltro>
</cfif>
<cfset vConsultaFuncion = "fListarMovimientos">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- VER LOS REGISTROS COMO TABLA --->
<cfif #tbMovimientos.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:98%;  margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
			<tr valign="middle" bgcolor="##CCCCCC">
				<td class="Sans9GrNe" height="18px" style="cursor:pointer; width:30%;" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif>>
					MOVIMIENTOS <cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
                <td class="Sans9GrNe" style="width:5%;" title="Duración/Número de contrato">D/C</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:10%;" title="Fecha de inicio" <cfif #vOrden# IS 'mov_fecha_inicio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_inicio','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_inicio','DESC');"</cfif>>
					F. INICIO <cfif #vOrden# IS 'mov_fecha_inicio'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:10%;" title="Fecha de término" <cfif #vOrden# IS 'mov_fecha_final' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_final','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_final','DESC');"</cfif>>
					F. TÉRMINO <cfif #vOrden# IS 'mov_fecha_final'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:10%;" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif>>
					CATEGORÍA <cfif #vOrden# IS 'cn_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:7%;" <cfif #vOrden# IS 'dep_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'dep_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'dep_siglas','DESC');"</cfif>>
					ENTIDAD <cfif #vOrden# IS 'dep_siglas'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:5%;" <cfif #vOrden# IS 'ssn_id' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'ssn_id','ASC');"<cfelse>onclick="fListarMovimientos(1,'ssn_id','DESC');"</cfif>>
					ACTA <cfif #vOrden# IS 'ssn_id'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:14%" <cfif #vOrden# IS 'asu_oficio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'asu_oficio','ASC');"<cfelse>onclick="fListarMovimientos(1,'asu_oficio','DESC');"</cfif>>
					NÚMERO DE OFICIO <cfif #vOrden# IS 'asu_oficio'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="width:5%;" title="Decisión del CTIC">DEC.</td>
				<cfif (#Session.sTipoSistema# EQ 'sic') OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 3)>
                    <td width="15" style="width:2%;" bgcolor="##FF9933"><!-- Ver PDF --></td>
                    <td width="15"  style="width:2%;"bgcolor="##0066FF"><!-- Ver detalle --></td>
				</cfif>
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
			<!--- Si es movimiento de Concurso Abierto se verifíca si es ganador o no --->
			<cfif #tbMovimientos.mov_clave# EQ 5>
				<cfquery name="tbCoaTmp" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM convocatorias_coa_concursa 
                    WHERE coa_id = '#tbMovimientos.coa_id#' AND acd_id = #vIdAcad# AND coa_ganador = 0
				</cfquery>
			</cfif>
			<!--- Documentación digitalizada --->
			<cfif #mov_clave# EQ 15 OR #mov_clave# EQ 16>
				<cfset vArchivoPdf = '0_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
			<cfelse>
				<cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>            
			</cfif>                
			<cfset vArchivoMovPdf = #vCarpetaAcademicos# & '\' & #vArchivoPdf#> <!--- & #vAcdId# & '\'  --->
			<cfset vArchivoMovPdfWeb = #vWebAcademicos# & '/' & #vArchivoPdf#> <!--- & #vAcdId# & '/'  --->

			<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA DECISIÓN --->
            <cfif (#dec_super# IS 'AP' AND #mov_clave# NEQ 5) OR (#dec_super# IS 'AP' AND #mov_clave# EQ 5 AND #coa_ganador# EQ 1)>
                <cfset vFuenteDec = 'Sans9Gr'>
            <cfelse>
                <cfset vFuenteDec = 'Sans9Vi'>
            </cfif>                
            <!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA CATEGORÍA Y NIVEL O SI FUE OPONENTE EN UN COA --->
            <cfif #mov_clave# EQ 5 AND #coa_ganador# EQ 0>
                <cfset vFuenteCCn = 'Sans9Vi'>
            <cfelse>
                <cfset vFuenteCCn = 'Sans9Gr'>
            </cfif>

			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td class="Sans9Gr">
					#Ucase(tbMovimientos.mov_titulo_corto)# 
					<span class="Sans9Vi">
						<cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif>
                        <cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif>
                        <!---<cfif #tbMovimientos.mov_clave# EQ 5><cfif #tbCoaTmp.RecordCount# EQ 1>(OPONENTE)</cfif></cfif>--->
					</span>                    
				</td>
				<td class="Sans9Gr"><cfif #tbMovimientos.mov_clave# EQ 6>#IIF(tbMovimientos.mov_numero IS '', 0, tbMovimientos.mov_numero)  + 1#<cfelseif #tbMovimientos.mov_clave# EQ 25>#tbMovimientos.mov_numero#</cfif><cfif (#tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41) AND (#mov_fecha_inicio# NEQ '' AND #mov_fecha_final# NEQ '')>#DateDiff('d',mov_fecha_inicio, mov_fecha_final) + 1#</cfif></td>
				<td class="Sans9Gr">
					<cfif #tbMovimientos.mov_clave# EQ 5>
						<cfif #tbCoaTmp.RecordCount# EQ 1>
						<cfelse>#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#
						</cfif>
					<cfelse>#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#
					</cfif>
				</td>
				<td class="Sans9Gr">
					<cfif #tbMovimientos.mov_clave# EQ 5>
						<cfif #tbCoaTmp.RecordCount# EQ 1>
						<cfelse>
							#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#
						</cfif>
					<cfelse>#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#
					</cfif>
				</td>
				<td class="#vFuenteCCn#">
					<cfif #mov_clave# EQ 5 AND #coa_ganador# EQ 0>
                        OPONENTE                            
                    <cfelseif #mov_clave# EQ 38 OR #mov_clave# EQ 39 OR #mov_clave# EQ 44>
                        &nbsp;
                    <cfelse>
                        #CnSinTiempo(tbMovimientos.cn_siglas)#
                    </cfif>
				</td>
				<td class="Sans9Gr">#tbMovimientos.dep_siglas#<cfif #tbMovimientos.mov_clave# EQ 13>-#ctDepTmp.dep_siglas#</cfif></td>
				<td class="Sans9Gr">#tbMovimientos.ssn_id#</td>
				<td class="Sans9Gr">#SoloNumeroOficio(tbMovimientos.asu_oficio)#</td>
				<!--- NOTA: Este código era para mostrar NA cuando el académico no había ganado el COA, pero no está funcionando bien y por eso lo deshbilité.
				<td class=<cfif #tbMovimientos.dec_super# IS 'AP' AND  #tbMovimientos.coa_acd_id# IS ''>"Sans9Gr"<cfelse>"Sans9Vi"</cfif>><cfif #tbMovimientos.coa_acd_id# IS ''>#tbMovimientos.dec_super#<cfelse>NA</cfif> #tbMovimientos.coa_acd_id#</td>
				--->
				<td class="#vFuenteDec#">
					<cfif #mov_clave# NEQ 5>
                        #dec_super#
                    <cfelse>
                        <cfif #mov_clave# EQ 5 AND #coa_ganador# EQ 1>
                            #dec_super#
                        <cfelse>
                            NA
                        </cfif>
                    </cfif>
<!---
					<cfif #tbMovimientos.mov_clave# EQ 5>
						<cfif #tbCoaTmp.RecordCount# EQ 1>
						<cfelse>
							#tbMovimientos.dec_super#
						</cfif>
					<cfelse>
						#tbMovimientos.dec_super#
					</cfif>
--->
				</td>
				<cfif (#Session.sTipoSistema# EQ 'sic') OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 3)>
                    <td>
                        <cfif FileExists(#vArchivoMovPdf#)>
                            <a href="#vArchivoMovPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_15.jpg" onclick="" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
                        </cfif>
                    </td>
                    <td><a href="#vCarpetaRaizLogicaSistema#/movimientos/detalle/movimiento.cfm?vIdAcad=#tbMovimientos.acd_id#&vIdMov=#tbMovimientos.mov_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>
				</cfif>
			</tr>
		</cfoutput>
  </table>
</cfif>
<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">
<!--- Total de registros --->
<cfoutput>
	<input id="vPagAct" type="hidden" value="#PageNum#">
	<input id="vRegRan" type="hidden" value="#StartRow# al #EndRow#">
	<input id="vRegTot" type="hidden" value="#tbMovimientos.RecordCount#">
</cfoutput>
--->