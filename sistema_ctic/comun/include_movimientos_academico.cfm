<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/10/2009 --->
<!--- FECHA ÚLTIMA MOD.: 27/11/2023 --->
<!--- APARTIR DEL 02/10/2017 SE USA COMO INCLUDE YA QUE SE USA EN DOS LUGARES DISTINTOS A) ACADEMICOS -> CONSULTA MOVIMIENTOS B) CONSULTA DE MOVIMIENTOS -> MOVIMIENTOS POR ACADÉMICO --->
<!--- APARTIR DEL 02/10/2017 SE CAMBIÓ DE UBICACIÓN A LA CARPETA DE COMÚN --->


<!--- Obtener la lista de movimientos del académico --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM consulta_movimientos AS T1
	WHERE asu_reunion = 'CTIC'
	AND acd_id = #vIdAcad#
	AND (dec_super <> 'OB' AND dec_super <> 'PE') <!--- AND (dec_super = 'AP' OR dec_super = 'NA' OR dec_super = 'CO') --->
	<!--- Filtro por tipo de movimiento --->
	<cfif IsDefined('vFt') AND #vFt# NEQ 0>
	 	<cfif #vFt# EQ 100>
			AND (mov_clave <> 40 AND mov_clave <> 41)
        <cfelseif #vFt# EQ 101>
			AND (mov_clave = 40 OR mov_clave = 41)
        <cfelse>
			AND T1.mov_clave = #vFt#
		</cfif>
	</cfif>
	<!--- Filtro por año de movimiento --->
    <cfif IsDefined("vAniosMov") AND #vAniosMov# GT 0>
    	AND YEAR(mov_fecha_inicio) = #vAniosMov#
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

<!--- Controles de paginación --->
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">
<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion.cfm">

<!--- VER LOS REGISTROS COMO TABLA --->
<cfif #tbMovimientos.RecordCount# GT 0>
	<!-- MOVIMIENTOS EN MODO TABLA -->
	<table style="width:98%;  margin:2px 0px 10px 15px; border:none;" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<cfoutput>
			<tr valign="middle" bgcolor="##CCCCCC">
				<td class="Sans9GrNe" height="18px" style="cursor:pointer; width:25%;" <cfif #vOrden# IS 'mov_titulo_corto' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_titulo_corto','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_titulo_corto','DESC');"</cfif>>
					MOVIMIENTOS <cfif #vOrden# IS 'mov_titulo_corto'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
                <td class="Sans9GrNe" style="width:5%;" title="Duración/Número de contrato">D/C</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:10%;" title="Fecha de inicio" <cfif #vOrden# IS 'mov_fecha_inicio' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_inicio','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_inicio','DESC');"</cfif>>
					F. INICIO <cfif #vOrden# IS 'mov_fecha_inicio'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:10%;" title="Fecha de término" <cfif #vOrden# IS 'mov_fecha_final' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'mov_fecha_final','ASC');"<cfelse>onclick="fListarMovimientos(1,'mov_fecha_final','DESC');"</cfif>>
					F. TÉRMINO <cfif #vOrden# IS 'mov_fecha_final'><cfif #vOrdenDir# IS 'DESC'><img src="#vCarpetaICONO#/orden_desc.gif" style="border:none;"><cfelse><img src="#vCarpetaICONO#/orden_asc.gif" style="border:none;"></cfif></cfif>
				</td>
				<td class="Sans9GrNe" style="cursor:pointer; width:15%;" <cfif #vOrden# IS 'cn_siglas' AND #vOrdenDir# IS 'DESC'>onclick="fListarMovimientos(1,'cn_siglas','ASC');"<cfelse>onclick="fListarMovimientos(1,'cn_siglas','DESC');"</cfif>>
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
				<td class="Sans9GrNe" style="width:5%;" title="Decisión del CTIC" align="center">DEC.</td>
				<cfif (#Session.sTipoSistema# EQ 'sic') OR (#Session.sTipoSistema# EQ 'stctic' AND (#Session.sUsuarioNivel# LT 3 OR #Session.sUsuarioNivel# EQ 20))>
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
			<cfset mov_fecha_inicio_temp = #LsDateFormat(mov_fecha_inicio,'dd/mm/yyyy')#>
            <cfset mov_fecha_final_temp = #LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#>
			<cfset cn_siglas_temp = #cn_siglas#>
            <cfset dec_super_temp = #dec_super#>

            <!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA CATEGORÍA Y NIVEL O SI FUE OPONENTE EN UN COA --->
			<cfset vFuenteCCn = 'Sans9Gr'>

			<!--- SELECCIONA TIPO DE FUENTE PARA MARCAR LA DECISIÓN --->
			<cfif #dec_super# IS 'NA'>
                <cfset vFuenteDec = 'Sans9ViNe'>
            <cfelseif #dec_super# IS 'OB'>
                <cfset vFuenteDec = 'Sans9NaNe'>
            <cfelse>
                <cfset vFuenteDec = 'Sans9GrNe'>
            </cfif>

			<cfif #tbMovimientos.mov_clave# EQ 5 OR #tbMovimientos.mov_clave# EQ 17>
				<cfquery name="tbCoaTmp" datasource="#vOrigenDatosSAMAA#">
					SELECT coa_ganador FROM convocatorias_coa_concursa 
                    WHERE coa_id = '#tbMovimientos.coa_id#' 
                    AND acd_id = #vIdAcad#
                    <cfif #tbMovimientos.ssn_id# GTE 1619> <!--- SE INCORPORO PARA IDENTIFICAR LOS OPONENTES VS LAS SOLICITUDES (27/11/2023)  --->
                        AND sol_id = #tbMovimientos.sol_id#
                    </cfif>

				</cfquery>
                <cfif #tbCoaTmp.coa_ganador# EQ 0>
                	<cfset mov_fecha_inicio_temp = ''>
                    <cfset mov_fecha_final_temp = ''>
					<cfset cn_siglas_temp = 'OPONENTE'>
					<cfset dec_super_temp = 'NA'>
					<cfset vFuenteCCn = 'Sans9Vi'>
					<cfset vFuenteDec = 'Sans9Vi'>                    
                </cfif>                
			</cfif>
			<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
				<td class="Sans9Gr">
					#Ucase(tbMovimientos.mov_titulo_corto)#
					<span class="Sans9Vi">
						<strong>
						<cfif #tbMovimientos.mov_cancelado# IS 1> (CANCELADO)</cfif>
                        <cfif #tbMovimientos.mov_modificado# IS 1> (MODIFICADO)</cfif>
						<cfif #tbMovimientos.prog_clave# IS 3> (SIJAC)</cfif>
						</strong>
					</span>
				</td>
				<td class="Sans9Gr"><cfif #tbMovimientos.mov_clave# EQ 6>#IIF(tbMovimientos.mov_numero IS '', 0, tbMovimientos.mov_numero)  + 1#<cfelseif #tbMovimientos.mov_clave# EQ 25>#tbMovimientos.mov_numero#</cfif><cfif (#tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41) AND (#mov_fecha_inicio# NEQ '' AND #mov_fecha_final# NEQ '')>#DateDiff('d',mov_fecha_inicio, mov_fecha_final) + 1#</cfif></td>
				<td class="Sans9Gr">#mov_fecha_inicio_temp#</td>
				<td class="Sans9Gr">#mov_fecha_final_temp#</td>
				<td class="#vFuenteCCn#"><cfif #mov_clave# NEQ 38 AND #mov_clave# NEQ 39>#cn_siglas_temp#</cfif></td>
				<td class="Sans9Gr">#tbMovimientos.dep_siglas#<cfif #tbMovimientos.mov_clave# EQ 13>-#ctDepTmp.dep_siglas#</cfif></td>
				<td class="Sans9Gr">#tbMovimientos.ssn_id#</td>
				<td class="Sans9Gr">#SoloNumeroOficio(tbMovimientos.asu_oficio)#</td>
				<!--- NOTA: Este código era para mostrar NA cuando el académico no había ganado el COA, pero no está funcionando bien y por eso lo deshbilité.
				<td class=<cfif #tbMovimientos.dec_super# IS 'AP' AND  #tbMovimientos.coa_acd_id# IS ''>"Sans9Gr"<cfelse>"Sans9Vi"</cfif>><cfif #tbMovimientos.coa_acd_id# IS ''>#tbMovimientos.dec_super#<cfelse>NA</cfif> #tbMovimientos.coa_acd_id#</td>
				--->
				<td class="#vFuenteDec#" align="center">#dec_super_temp#</td>
				<cfif (#Session.sTipoSistema# EQ 'sic') OR (#Session.sTipoSistema# EQ 'stctic' AND (#Session.sUsuarioNivel# LT 3 OR #Session.sUsuarioNivel# EQ 20 OR #Session.sUsuarioNivel# EQ 91))>
                    <td>
						<!--- Documentación digitalizada --->
						<cfif #mov_clave# EQ 15 OR #mov_clave# EQ 16>
                            <cfset vArchivoPdf = '0_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>
                        <cfelse>
                            <cfset vArchivoPdf = #tbMovimientos.acd_id# & '_' & #tbMovimientos.sol_id# & '_' & #tbMovimientos.ssn_id# & '.pdf'>            
                        </cfif>                
                        <cfset vArchivoMovPdf = #vCarpetaAcademicos# & '\' & #vArchivoPdf#> <!--- & #vAcdId# & '\'  --->
                        <cfset vArchivoMovPdfWeb = #vWebAcademicos# & '/' & #vArchivoPdf#> <!--- & #vAcdId# & '/'  --->
                        <cfif FileExists(#vArchivoMovPdf#)>
							<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('#vArchivoPdf#','MOV','', '');">
                            <!---
							<a href="#vArchivoMovPdfWeb#" target="WINARCHIVO"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF"></a>
							--->
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
