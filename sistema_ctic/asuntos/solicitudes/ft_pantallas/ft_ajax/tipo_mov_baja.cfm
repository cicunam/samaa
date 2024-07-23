							<!--- CREADO: ARAM PICHARDO--->
							<!--- EDITO: ARAM PICHARDO--->
							<!--- FECHA CREA: 03/04/2014 --->
							<!--- FECHA ÚLTIMA MOD.: 21/06/2017 --->                            
							<!--- AJAX LIGADO A LA FT-CTIC-14.-Baja--->

                            <cfparam name="vAcdId" default="0">
                            <cfparam name="vBajaClave" default="0">
                            <cfparam name="vCampoPos12_o" default="0">
                            <cfparam name="txtMov_pos12_o" default="0">
                            <cfparam name="vActivaCampos" default="">

							<!--- Fecha máxima para búsqueda de movimiento al que se desea renunciar  (SE AMLIÓ EL RANGO DE 10 A 18 MESES, YA QUE LAS ENTIDES TARDAN DEMASIADO EN LAS BAJAS)--->
                            <cfset vFechaAnterior = LsDateFormat(DateAdd("m", -18, Now()),"dd/mm/yyyy")>
                            
							<!--- Obtener ID y nombre del movimiento que se interrumpe --->
                            <cfquery name="tbMovimientoInterrumpido" datasource="#vOrigenDatosSAMAA#">
                                SELECT 
                                <!--- TOP 1 --->
                                * 
                                FROM ((movimientos T1 
                                LEFT JOIN movimientos_asunto T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CTIC')
                                LEFT JOIN catalogo_decision C1 ON T2.dec_clave = C1.dec_clave)
                                LEFT JOIN catalogo_movimiento C2 ON T1.mov_clave = C2.mov_clave
                                WHERE acd_id = #vAcdId#
                                AND (C1.dec_super = 'AP' OR C1.dec_super = 'CO')
								<cfif #vBajaClave# EQ 6>AND T1.mov_clave = 38</cfif>
								<cfif #vBajaClave# EQ 9>AND T1.mov_clave = 39</cfif>
								<cfif #vBajaClave# EQ 4>
									AND (T1.mov_clave = 6)
									AND ((mov_fecha_final BETWEEN '#vFechaAnterior#' AND GETDATE()) OR (mov_fecha_inicio BETWEEN '#vFechaAnterior#' AND GETDATE()))   <!--- Movimiento vigente o definitivo --->
                                </cfif>
								<cfif #vBajaClave# EQ 5>
									AND (T1.mov_clave = 5 OR T1.mov_clave BETWEEN 7 AND 10 OR T1.mov_clave BETWEEN 17 AND 19 OR T1.mov_clave = 25 OR T1.mov_clave = 28 OR T1.mov_clave = 42)
									<!--- AND ((mov_fecha_final BETWEEN '#vFechaAnterior#' AND GETDATE()) OR (mov_fecha_final IS NULL))---> <!--- Movimiento vigente o definitivo --->
								</cfif>
								<cfif #vBajaClave# EQ 1>
									AND (T1.mov_clave BETWEEN 5 AND 10 OR T1.mov_clave BETWEEN 17 AND 19 OR T1.mov_clave = 25 OR T1.mov_clave = 28 OR T1.mov_clave BETWEEN 38 AND 39 OR T1.mov_clave = 42)
									AND ((mov_fecha_final BETWEEN '#vFechaAnterior#' AND GETDATE()) OR (mov_fecha_final IS NULL) OR (mov_fecha_inicio BETWEEN '#vFechaAnterior#' AND GETDATE()))   <!--- Movimiento vigente o definitivo --->
								</cfif>
                                ORDER BY T1.mov_fecha_inicio DESC
                            </cfquery>
 
							<cfif #tbMovimientoInterrumpido.RecordCount# GT 0>
								<select name="pos12_o" id="pos12_o" class="datos" onchange="fHabilitaDesAjax();" <cfif #vActivaCampos# EQ "disabled">disabled="disabled"</cfif>>
									<option value="0">SELECCIONE EL MOVIMIENTO DE REFERENCIA</option>
									<cfoutput query="tbMovimientoInterrumpido">
										<option value="#mov_id#" movClave="#mov_clave#" <cfif #mov_id# EQ #vCampoPos12_o#>selected</cfif>>#UCASE(mov_titulo_corto)# #LsDateFormat(mov_fecha_inicio,'dd/mm/yyyy')# - #LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#</option>
									</cfoutput>
								</select>
                            </cfif>