<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 03/12/2015--->
<!--- FECHA ULTIMA MOD.: 03/12/2015 --->

<!--- CONTROLES PARA PODER REALIZAR FILTROS POR TIPO DE MOVIMIENTO CATÁLOGO COMPLETO --->


					<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
                    <cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM catalogo_movimiento 
                        WHERE mov_status = 1 
                        ORDER BY mov_orden
                    </cfquery>

                    <cfif isDefined("Session.MovimientosSesionFiltro")>
						<!--- VARIABLES DEL MÓDULO: CONSULTA MOVIMIENTOS, MENÚ: CONSULTA MOVIMIENTOS POR SESIÓN --->
						<cfset vfFt = #Session.MovimientosSesionFiltro.vFt#>
						<cfset vfOrden = #Session.MovimientosSesionFiltro.vOrden#>
						<cfset vfOrdenDir = #Session.MovimientosSesionFiltro.vOrdenDir#>
					<cfelseif isDefined("Session.AsuntosEntidadFiltro")>
						<!--- VARIABLES DEL MÓDULO: SOLICITUDES, MENÚ: ASUNTOS QUE SE ENCUENTRANE EN LA ENTIDAD --->
						<cfset vfFt = #Session.AsuntosEntidadFiltro.vFt#>
						<cfset vfOrden = #Session.AsuntosEntidadFiltro.vOrden#>
						<cfset vfOrdenDir = #Session.AsuntosEntidadFiltro.vOrdenDir#>                    
					<cfelseif isDefined("")>
					<cfelseif isDefined("")>
					</cfif>

					<!-- Filtro de la lista por tipo de movimiento --> 
					<table style="width:800px;  margin:5px 0px 15px 15px;" cellspacing="0" cellpadding="1">
						<tr>
							<td style="padding: 5px; background-color: #FFCC66"><span class="Sans9ViNe">Filtrar por tipo de asunto:</span></td>
						</tr>
						<tr>
							<td style="padding: 5px; background-color: #FFCC66">
								<select name="vFt" id="vFt" class="datos100" onChange="fListarMovimientos(1,'<cfoutput>#vfOrden#</cfoutput>','<cfoutput>#vfOrdenDir#</cfoutput>');">
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