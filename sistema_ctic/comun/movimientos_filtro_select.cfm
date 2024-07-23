<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 03/12/2015--->
<!--- FECHA ULTIMA MOD.: 03/12/2015 --->

<!--- CONTROLES PARA PODER REALIZAR FILTROS POR TIPO DE MOVIMIENTO SEGÚN LOS MOVIMIENTOS DEL ACADÉMICO  --->

					<!---
					<cfparam name="vAcadId" default="1">
					--->

					<cfif #FindNoCase('/sistema_ctic/movimientos/consultas/consulta_academico.cfm', Session.sModulo)# IS NOT 0>	
                        <cfparam name="vAniosMov" default="#Session.MovimientosAcadFiltro.vAnioMov#">
                        <cfparam name="vFt" default="#Session.MovimientosAcadFiltro.vFt#">
                    <cfelse>
                        <cfparam name="vAniosMov" default="#Session.AcademicosMovFiltro.vAnioMov#">        
                        <cfparam name="vFt" default="#Session.AcademicosMovFiltro.vFt#">
                    </cfif>	

<!--- CAUSA RUIDO EN MOVIMIENTOS POR ACADÉMICO 13/03/2018
					<cfif NOT IsDefined('Session.MovimientosAcadFiltro.vFt')>
						<cfset Session.MovimientosAcadFiltro.vFt = '0'>
					</cfif>
--->
                    <cfquery name="ctAniosMov" datasource="#vOrigenDatosSAMAA#">
                        SELECT YEAR(mov_fecha_inicio) AS vAnios
                        FROM movimientos
                        WHERE movimientos.acd_id = #vAcadId# 
                        GROUP BY YEAR(mov_fecha_inicio)
                        ORDER BY  YEAR(mov_fecha_inicio) DESC
                    </cfquery>
                    
                    <cfquery name="ctMovimientos" datasource="#vOrigenDatosSAMAA#">
                        SELECT DISTINCT
                        C1.mov_clave,
                        C1.mov_noft,
                        C1.mov_titulo,
                        C1.mov_clase                    
                        FROM movimientos AS T1
                        LEFT JOIN convocatorias_coa_concursa AS T2 ON T1.coa_id = T2.coa_id AND T2.acd_id = #vAcadId#
                        LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave
                        WHERE 1 = 1
                        AND (T1.acd_id = #vAcadId# OR T2.acd_id = #vAcadId#)
                        ORDER BY C1.mov_clave
                    </cfquery>
                    
                    <cfif isDefined("Session.AcademicosMovFiltro")>
						<cfset vfFt = #Session.AcademicosMovFiltro.vFt#>
						<cfset vfOrden = #Session.AcademicosMovFiltro.vOrden#>
						<cfset vfOrdenDir = #Session.AcademicosMovFiltro.vOrdenDir#>
                    <cfelseif isDefined("Session.MovimientosAcadFiltro")>
						<cfset vfFt = #Session.MovimientosAcadFiltro.vFt#>
						<cfset vfOrden = #Session.MovimientosAcadFiltro.vOrden#>
						<cfset vfOrdenDir = #Session.MovimientosAcadFiltro.vOrdenDir#>                    
                    </cfif>

					<!-- Filtro por tipo de movimiento --> 
					<table id="FiltroMovimiento" style="width:800px;  margin:0px 0px 0px 15px; border:none;" cellspacing="0">
						<tr bgcolor="#D9D9D9">
							<!-- Ingreso de parámetros -->
							<td style="padding: 0px 5px 5px 5px; background-color: #D9D9D9" width="80%">
								<span class="Sans9NeNe">Filtrar por tipo de movimiento</span><br/>
								<select name="vFt" id="vFt" class="datos100" onChange="fListarMovimientos(1,'<cfoutput>#vfOrden#</cfoutput>', '<cfoutput>#vfOrdenDir#</cfoutput>');">
									<option value="0">Todos los movimientos</option>
									<option value="100" <cfif 100 EQ #vfFt#>selected</cfif>>Todos los movimientos excepto licencias con sueldo y comisiones menores a 22 días</option>
								    <option value="101" <cfif 101 EQ #vfFt#>selected</cfif>>S&oacute;lo licencias con sueldo y comisiones menores a 22 días</option>
									<cfoutput query="ctMovimientos">
										<option value="#mov_clave#" <cfif #mov_clave# EQ #vfFt#>selected</cfif>>#mov_noft#.-#mov_titulo# <cfif #mov_clase# NEQ ''>#mov_clase#</cfif></option>
									</cfoutput>
								</select>
							</td>
							<td width="20%">
                            	<span class="Sans9NeNe">Año inicio movimientos</span><br/>
								<select name="vAniosMov" id="vAniosMov" class="datos" onChange="fListarMovimientos(1,'<cfoutput>#vfOrden#</cfoutput>', '<cfoutput>#vfOrdenDir#</cfoutput>');">
									<option value="0">Todos los años</option>
									<cfoutput query="ctAniosMov">
										<option value="#vAnios#" <cfif #vAnios# EQ #vAniosMov#>selected</cfif>>#vAnios#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
					</table>