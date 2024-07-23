					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 03/12/2015--->
					<!--- FECHA ULTIMA MOD.: 03/11/2016 --->
					
					<!--- CONTROLES PARA PODER REALIZAR FILTROS POR TIPO DE MOVIMIENTO CATÁLOGO COMPLETO --->

					<cfset vMovFiltro = "#attributes.filtro#">
					<cfset vFuncionScriptAjax = "#attributes.funcion#">
					<cfset vfFt = #attributes.sFiltrovFt#>
					<cfset vfOrden = #attributes.sFiltrovOrden#>
					<cfset vfOrdenDir = #attributes.sFiltrovOrdenDir#>

					<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
                    <cfquery name="ctMovimiento" datasource="samaa">
                        SELECT * FROM catalogo_movimiento 
                        WHERE 1 = 1
                        <cfif #vMovFiltro# EQ 1>
                        	AND (mov_clave = 5 OR mov_clave = 6 OR mov_clave = 25 OR mov_clave = 38) 
						</cfif>
                        AND mov_status = 1
						<cfif #Session.sTipoSistema# IS 'sic'><!--- SI ES ENTIDAD DEL SUBSISTEMA NO PERMITE DESPLEGAR LA FT-35 RECURSO DE REVISION --->
                            AND mov_clave <> 35
                        </cfif>
                        ORDER BY mov_orden
                    </cfquery>

					<!-- Filtro de la lista por tipo de movimiento --> 
					<table style="width:98%;  margin:5px 0px 15px 15px;" cellspacing="0" cellpadding="1">
						<tr>
							<td style="padding: 5px; background-color: #FFCC66"><span class="Sans9ViNe">Filtrar por tipo de solicitud:</span></td>
						</tr>
						<tr>
							<td style="padding: 5px; background-color: #FFCC66">
								<select name="vFt" id="vFt" class="datos100" onChange="<cfoutput>#vFuncionScriptAjax#(1,'#vfOrden#','#vfOrdenDir#');</cfoutput>">
									<option value="0">Todos los movimientos</option>
									<option value="100" <cfif 100 EQ #vfFt#>selected</cfif>>Todos los movimientos excepto licencias con sueldo y comisiones menores a 22 días</option>
								    <option value="101" <cfif 101 EQ #vfFt#>selected</cfif>>S&oacute;lo licencias con sueldo y comisiones menores a 22 días</option>
									<cfoutput query="ctMovimiento">
										<option value="#mov_clave#" <cfif #mov_clave# EQ #vfFt#>selected</cfif>>#mov_noft#.-#mov_titulo# <cfif #mov_clase# NEQ ''>#mov_clase#</cfif></option>
									</cfoutput>
								</select>
							</td>
						</tr>
					</table>