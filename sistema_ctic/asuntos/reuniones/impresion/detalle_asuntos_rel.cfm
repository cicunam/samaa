<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 26/07/2019 --->
<!--- IMPRESION DE LA LISTA DE ASUNTOS RELACIONADOS (SECCIÓN VI) --->
<cffunction name="DetalleAsuntoRelacionado" description="Genera el detalle del asunto dentro de la lista de asuntos CAAA/CTIC, pero tomando la información de la tabla de movimientos.">
	<cfargument name="tbSolicitudes">
	<cfoutput>
		<!--- Obtener información del asunto relacionado --->
		<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
			SELECT *, movimientos_asunto.ssn_id AS acta FROM (((movimientos 
			LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
			LEFT JOIN catalogo_dependencia ON movimientos.dep_clave = catalogo_dependencia.dep_clave)
			LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave) 
			LEFT JOIN academicos ON movimientos.acd_id = academicos.acd_id
			WHERE movimientos_asunto.asu_reunion = 'CTIC'
			AND movimientos.mov_id = #tbSolicitudes.sol_pos12#
		</cfquery>
		<!--- Dependencia, número de asunto, movimiento --->
		<tr>
			<cfif #tbSolicitudes.mov_clave# EQ 31>
				<td width="10%">#tbSolicitudes.dep_siglas#</td>
				<td width="4%">#tbSolicitudes.asu_numero#</td>
			<cfelse>
				<td colspan="2"></td>
			</cfif>	
			<td>
				<!--- Tipo de movimiento --->
				<cfif #tbMovimientos.mov_clave# EQ 2 OR #tbMovimientos.mov_clave# EQ 3 OR #tbMovimientos.mov_clave# EQ 4><!--- Comisión mayor a 22 días, comisión encomandada por el rector --->
					<cfif #tbMovimientos.mov_clave# EQ 4 AND tbMovimientos.mov_prorroga IS 1>
						PRORROGA DE
					</cfif>
					#UCase(tbMovimientos.mov_titulo_listado)#
					<cfif #tbMovimientos.mov_sueldo# EQ 0>
						SIN GOCE DE SUELDO
					<cfelseif #tbMovimientos.mov_sueldo# GT 0 AND #tbMovimientos.mov_sueldo# LT 100>	
						CON GOCE DE SUELDO PARCIAL (#Trim(LsNumberFormat(tbMovimientos.mov_sueldo,99))#%)
					</cfif>	
				<cfelseif #tbMovimientos.mov_clave# EQ 13 OR #tbMovimientos.mov_clave# EQ 29><!--- Cambio de dependencia, cambio de ubicación --->
					#UCase(tbMovimientos.mov_titulo_listado)# 
					<cfif #tbMovimientos.cam_clave# EQ 1>
						DEFINITIVO
					<cfelseif #tbMovimientos.cam_clave# EQ 2 OR #tbMovimientos.cam_clave# EQ 3>
						TEMPORAL
					</cfif>
				<cfelseif #tbMovimientos.mov_clave# EQ 21 OR #tbMovimientos.mov_clave# EQ 23 OR #tbMovimientos.mov_clave# EQ 30><!--- Sabático, informe de sabático --->
					<cfif #tbMovimientos.mov_clave# EQ 23>INFORME DE</cfif>
					<cfif #tbMovimientos.mov_periodo# IS 'A'>
						A&Ntilde;O
					<cfelse>
						SEMESTRE
					</cfif>
					SAB&Aacute;TICO
					<cfif #tbMovimientos.mov_clave# EQ 30>CON BECA DE DGAPA</cfif>
				<cfelseif #tbMovimientos.mov_clave# EQ 39><!--- Revonación de beca posdoctoral --->	
					BECA POSDOCTORAL
				<cfelse>
					#UCase(tbMovimientos.mov_titulo_listado)#
				</cfif>
				<!--- Determinar si el nuevo dictámen es "APROBATORIO" o "NO APROBATORIO"  --->
				<cfif #tbMovimientos.mov_clave# EQ 17 OR #tbMovimientos.mov_clave# EQ 18 OR #tbMovimientos.mov_clave# EQ 19>
					<cfif #tbMovimientos.mov_dictamen_cd# IS 0>NO </cfif>APROBATORIO
				</cfif>
			</td>
		</tr>
		<!--- Movimiento relacionado --->
		<cfif #tbMovimientos.mov_clave# EQ 15 OR #tbMovimientos.mov_clave# EQ 16>
			<tr>
				<td colspan="2"></td>
				<td>Concurso de oposici&oacute;n abierto (Contrato)</td>
			</tr>
		<cfelseif #tbMovimientos.mov_clave# EQ 17>
			<tr>
				<td colspan="2"></td>
				<td>Concurso de oposici&oacute;n abierto <!--- PENDIENTE: No hay de donde obtener el siguiente dato ---></td>
			</tr>
		<cfelseif #tbMovimientos.mov_clave# EQ 18>
			<tr>
				<td colspan="2"></td>
				<td>Concurso de oposici&oacute;n cerrado (Definitividad)</td>
			</tr>
		<cfelseif #tbMovimientos.mov_clave# EQ 19>
			<tr>
				<td colspan="2"></td>
				<td>Concurso de oposici&oacute;n cerrado (Promoci&oacute;n)</td>
			</tr>
		<cfelseif #tbMovimientos.mov_clave# EQ 42>
			<tr>
				<td colspan="2"></td>
				<td>Concurso desierto</td>
			</tr>
		</cfif>
		<!--- OPINIÓN NEGATIVA --->
		<cfif #tbMovimientos.mov_clave# EQ 2 OR #tbMovimientos.mov_clave# EQ 3 OR #tbMovimientos.mov_clave# EQ 11 OR #tbMovimientos.mov_clave# EQ 20 OR #tbMovimientos.mov_clave# EQ 21 OR #tbMovimientos.mov_clave# EQ 29 OR #tbMovimientos.mov_clave# EQ 30 OR #tbMovimientos.mov_clave# EQ 34 OR #tbMovimientos.mov_clave# EQ 36>
			<cfif #tbMovimientos.mov_opinion_ci# EQ 0>
				<tr>
					<td colspan="2"></td>
					<td>OPINI&Oacute;N NEGATIVA</td>
				</tr>
			</cfif>
		</cfif>
		<!--- DICTAMEN NO APROBATORIO --->
		<cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 7 OR #tbMovimientos.mov_clave# EQ 8 OR #tbMovimientos.mov_clave# EQ 9 OR #tbMovimientos.mov_clave# EQ 10 OR #tbMovimientos.mov_clave# EQ 12 OR #tbMovimientos.mov_clave# EQ 13>
			<cfif #tbMovimientos.mov_dictamen_cd# EQ 0>
				<tr>
					<td colspan="2"></td>
					<td>DICTAMEN NO APROBATORIO</td>
				</tr>
			</cfif>
		</cfif>
		<!--- Nombre del académico --->
		<cfif #tbMovimientos.mov_clave# NEQ 15 AND #tbMovimientos.mov_clave# NEQ 16 AND #tbMovimientos.mov_clave# NEQ 42>
			<tr>
				<td colspan="2"></td>
				<td>#Trim(tbMovimientos.acd_prefijo)# #Trim(tbMovimientos.acd_nombres)# #Trim(tbMovimientos.acd_apepat)# #Trim(tbMovimientos.acd_apemat)#</td>
			</tr>
		</cfif>
		<!--- Categoría y nivel  (del asunto relacionado) --->
		<cfif #tbMovimientos.mov_clave# NEQ 6 AND #tbMovimientos.mov_clave# NEQ 23 AND #tbMovimientos.mov_clave# NEQ 26 AND #tbMovimientos.mov_clave# NEQ 27 AND #tbMovimientos.mov_clave# NEQ 38 AND #tbMovimientos.mov_clave# NEQ 39>
			<!--- Categoría y nivel del académico --->
			<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbMovimientos.cn_clave#'
			</cfquery>
			<!--- Categoría y nivel del movimiento --->
			<cfquery name="ctCategoriaMov" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbMovimientos.mov_cn_clave#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #tbMovimientos.mov_clave# EQ 5 OR #tbMovimientos.mov_clave# EQ 15 OR #tbMovimientos.mov_clave# EQ 16 OR #tbMovimientos.mov_clave# EQ 17 OR #tbMovimientos.mov_clave# EQ 20 OR #tbMovimientos.mov_clave# EQ 28 OR #tbMovimientos.mov_clave# EQ 36 OR #tbMovimientos.mov_clave# EQ 42>
						<cfif #tbMovimientos.mov_clave# NEQ 20 AND #tbMovimientos.mov_clave# NEQ 36>Como </cfif>#ctCategoriaMov.cn_siglas#
					<cfelseif #tbMovimientos.mov_clave# EQ 9 OR #tbMovimientos.mov_clave# EQ 10 OR #tbMovimientos.mov_clave# EQ 12 OR #tbMovimientos.mov_clave# EQ 19>
						De #ctCategoria.cn_siglas# a #ctCategoriaMov.cn_siglas#
					<cfelse>
						<cfif #tbMovimientos.mov_clave# EQ 25>Como </cfif>#ctCategoria.cn_siglas#
					</cfif>
				</td>
			</tr>
		</cfif>
		<!--- Cambio de tiempo --->
		<cfif #tbSolicitudes.mov_clave# EQ 12>
			<cfquery name="ctCategoriaNueva" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn WHERE cn_clave = '#tbMovimientos.mov_cn_clave#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #Right(Trim(ctCategoriaNueva.cn_siglas),2)# IS 'MT'>
						De TIEMPO COMPLETO a MEDIO TIEMPO
					<cfelse>	
						De MEDIO TIEMPO a TIEMPO COMPLETO
					</cfif>
				</td>
			</tr>		
		</cfif>
		<!--- Datos de la convocatoria --->
		<cfif #tbMovimientos.mov_clave# EQ 15 OR #tbMovimientos.mov_clave# EQ 16 OR #tbMovimientos.mov_clave# EQ 42>
			<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM convocatorias_coa WHERE coa_id = '#tbMovimientos.coa_id#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Plaza n&uacute;mero: #tbMovimientos.mov_plaza#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>Publicado en Gaceta el #FechaCompleta(tbMovimientos.mov_fecha_1)#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>Area: #UCase(tbConvocatorias.coa_area)#</td>
			</tr>
		</cfif>
		<!--- Número de contrato --->
		<cfif #tbMovimientos.mov_clave# EQ 6 AND tbMovimientos.mov_numero IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>CONTRATO N&Uacute;MERO: #LsNumberFormat(tbMovimientos.mov_numero + 1, 99)#</td>
			</tr>
		</cfif>
		<!--- Cambio de adscripción --->
		<cfif #tbMovimientos.mov_clave# EQ 13 AND tbMovimientos.mov_dep_clave IS NOT ''>
			<!--- Obtener la adscripción secundaria (puede ser origen o destino) --->
			<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia WHERE dep_clave = '#tbMovimientos.mov_dep_clave#'
			</cfquery>
			<!--- Determinar si el cambio es de la entidad a otra o al revés --->
			<cfif #tbMovimientos.mov_logico# IS 1>
				<tr>
					<td colspan="2"></td>
					<td><cfif #Left(tbMovimientos.dep_nombre,2)# IS 'CE' OR #Left(tbMovimientos.dep_nombre,2)# IS 'CC' OR #Left(tbMovimientos.dep_nombre,2)# IS 'IN' OR #Left(tbMovimientos.dep_nombre,2)# IS 'PR'>DEL<cfelse>DE LA</cfif> #tbMovimientos.dep_nombre#</td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td><cfif #Left(ctDependencia.dep_nombre,2)# IS 'CE' OR #Left(ctDependencia.dep_nombre,2)# IS 'CC' OR #Left(ctDependencia.dep_nombre,2)# IS 'IN' OR #Left(ctDependencia.dep_nombre,2)# IS 'PR'>AL<cfelse>A LA</cfif> #ctDependencia.dep_nombre#</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="2"></td>
					<td><cfif #Left(ctDependencia.dep_nombre,2)# IS 'CE' OR #Left(ctDependencia.dep_nombre,2)# IS 'CC' OR #Left(ctDependencia.dep_nombre,2)# IS 'IN' OR #Left(ctDependencia.dep_nombre,2)# IS 'PR'>DEL<cfelse>DE LA</cfif> #ctDependencia.dep_nombre#</td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td><cfif #Left(tbMovimientos.dep_nombre,2)# IS 'CE' OR #Left(tbMovimientos.dep_nombre,2)# IS 'CC' OR #Left(tbMovimientos.dep_nombre,2)# IS 'IN' OR #Left(tbMovimientos.dep_nombre,2)# IS 'PR'>AL<cfelse>A LA</cfif> #tbMovimientos.dep_nombre#</td>
				</tr>
			</cfif>	
		</cfif>
		<!--- Fecha de renuncia --->
		<cfif #tbMovimientos.mov_clave# EQ 20 AND tbMovimientos.mov_fecha_1 IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de renuncia: #FechaCompleta(tbMovimientos.mov_fecha_1)#</td>
			</tr>
		</cfif>
		<!--- Fecha de ingreso a la UNAM --->
		<cfif #tbMovimientos.mov_clave# EQ 34 AND tbMovimientos.mov_fecha_1 IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de ingreso a la UNAM: #FechaCompleta(tbMovimientos.mov_fecha_1)#</td>
			</tr>
		</cfif>
		<!--- Fecha de jubilación --->
		<cfif #tbMovimientos.mov_clave# EQ 36 AND tbMovimientos.mov_fecha_1 IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de jubilaci&oacute;n: #FechaCompleta(tbMovimientos.mov_fecha_1)#</td>
			</tr>
		</cfif>
		<!--- Número de revovación --->
		<cfif #tbMovimientos.mov_clave# EQ 25 AND tbMovimientos.mov_numero IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>#LsNumberFormat(tbMovimientos.mov_numero,99)#<sup>a</sup> RENOVACI&Oacute;N</td>
			</tr>
		</cfif>
			<!--- País de procedencia de investigador visitante --->
		<cfif #tbMovimientos.mov_clave# EQ 26>
			<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais WHERE pais_clave = '#tbMovimientos.pais_clave#'
			</cfquery>
			<!--- Obtener el estado --->
			<cfquery name="ctEstado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#tbMovimientos.edo_clave#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>#tbMovimientos.mov_institucion#, #Trim(tbMovimientos.mov_ciudad)#<cfif #tbMovimientos.pais_clave# IS NOT 'MEX'><cfif #tbMovimientos.edo_clave# IS NOT ''>, <cfif #tbMovimientos.pais_clave# IS 'USA'>#Trim(ctEstado.edo_nombre)#, <cfelse>#Trim(tbMovimientos.edo_clave)#, </cfif></cfif>#Trim(ctPais.pais_nombre)#</cfif></td>
			</tr>
		</cfif>
		<!--- Cambio de ubicación --->
		<cfif #tbMovimientos.mov_clave# EQ 29 AND tbMovimientos.dep_ubicacion IS NOT '' AND tbSolicitudes.mov_dep_ubica IS NOT ''>
			<!--- Ubicación actual --->
			<cfquery name="ctUbicacionActual" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia_ubica 
				WHERE dep_clave = '#tbMovimientos.dep_clave#' AND ubica_clave = '#tbMovimientos.dep_ubica#'
			</cfquery>
			<!--- Ubicación a la que aspira --->
			<cfquery name="ctUbicacionAspira" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia_ubica 
				WHERE dep_clave = '#tbMovimientos.dep_clave#' AND ubica_clave = '#tbMovimientos.mov_dep_ubica#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #ctUbicacionActual.ubica_tipo# IS 'OBSERVATORIO' OR #ctUbicacionActual.ubica_tipo# IS 'LABORATORIO'>DEL<cfelse>DE LA</cfif>
					#ctUbicacionActual.ubica_nombre# #ctUbicacionActual.ubica_lugar#
				</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #ctUbicacionAspira.ubica_tipo# IS 'OBSERVATORIO' OR #ctUbicacionAspira.ubica_tipo# IS 'LABORATORIO'>AL<cfelse>A LA</cfif>
					#ctUbicacionAspira.ubica_nombre# #ctUbicacionAspira.ubica_lugar#
				</td>
			</tr>
		</cfif>
		<!--- Número de beca --->
		<cfif (#tbMovimientos.mov_clave# EQ 38 OR #tbMovimientos.mov_clave# EQ 39) AND tbMovimientos.acd_id IS NOT ''>
			<!--- Obtener número de becas anteriores --->
			<cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
				SELECT COUNT(*) AS numero_becas
				FROM (movimientos 
				LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
				WHERE acd_id = #tbMovimientos.acd_id# 
				AND mov_clave = 38 <!--- Beca posdoctoral --->
				AND asu_reunion = 'CTIC'
				AND dec_super = 'AP' <!--- Asuntos aprobados --->
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>BECA N&Uacute;MERO: #LsNumberFormat(tbMovimientosBecas.numero_becas + 1,99)#</td>
			</tr>
		</cfif>
		<!--- Duración --->
		<cfif #tbMovimientos.mov_clave# NEQ 15 AND #tbMovimientos.mov_clave# NEQ 16 AND #tbMovimientos.mov_clave# NEQ 22 AND #tbMovimientos.mov_clave# NEQ 31 AND #tbMovimientos.mov_clave# NEQ 42>
			<!--- Duración fija de un año --->
			<cfif #tbMovimientos.mov_clave# EQ 5>	
				<tr>
					<td colspan="2"></td>
					<td>
						Duraci&oacute;n: 1 a&ntilde;o a partir del #FechaCompleta(DateAdd('d',1,tbSesiones.ssn_fecha))#
					</td>
				</tr>	
			<!--- Hasta el término de su cargo --->
			<cfelseif #tbMovimientos.mov_fecha_inicio# NEQ '' AND #tbMovimientos.mov_fecha_final# EQ '' AND #tbMovimientos.cam_clave# EQ 3>
				<tr>
					<td colspan="2"></td>
					<td>
						Duraci&oacute;n: HASTA EL T&Eacute;RMINO DE SU #tbMovimientos.mov_cargo#
					</td>
				</tr>		
			<!--- Hay las dos fechas --->    
			<cfelseif #tbMovimientos.mov_fecha_final# NEQ ''>
				<!--- Duración --->
				<cfif #tbMovimientos.mov_clave# EQ 23>
					<cfset vAnios = 0>
					<cfset vMeses = 0>
					<cfset vDias = 0>
				<cfelse>
					<!--- Desglosar el periodo en años, meses y días --->
					<cfset vFF = #DateAdd('d',1,tbMovimientos.mov_fecha_final)#>
					<cfset vF1 = #tbMovimientos.mov_fecha_inicio#> 
					<cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
					<cfset vF2 = #DateAdd('yyyy',vAnios,vF1)#>
					<cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
					<cfset vF3 = #DateAdd('m',vMeses,vF2)#>			
					<cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
				</cfif>
				<!--- Construir la cadena de texto que se mostrará --->
				<!--- SE ELIMINÓ LA DURACIÓN EN PROMOCIONES DE NO DEFINITIVOS A SOLICITUD DE LA STCTIC 26/07/2019 --->
				<cfif (#vAnios# GT 0 OR #vMeses# GT 0 OR #vDias# GT 0) AND (#tbSolicitudes.mov_clave# NEQ 8 AND #tbSolicitudes.mov_clave# NEQ 10)>
					<tr>
						<td colspan="2"></td>
						<td>
							<!--- Duración con fecha en la misma línea --->
							<cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 21 OR #tbMovimientos.mov_clave# EQ 25 OR #tbMovimientos.mov_clave# EQ 26 OR #tbMovimientos.mov_clave# EQ 30 OR #tbMovimientos.mov_clave# EQ 36 OR #tbMovimientos.mov_clave# EQ 38 OR #tbMovimientos.mov_clave# EQ 39 OR #tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41>
								Duraci&oacute;n: 
								<cfif #vAnios# GT 0>
									#vAnios# año,
								</cfif>
								<cfif #vMeses# GT 0>
									#vMeses# <cfif #vMeses# EQ 1>mes,<cfelse>meses,</cfif>
								</cfif>
								<cfif #vDias# GT 0>
									#vDias# <cfif #vDias# EQ 1>día,<cfelse>días,</cfif>
								</cfif>
								a partir del #FechaCompleta(tbMovimientos.mov_fecha_inicio)#
							<!--- Solo duración ---> 
							<cfelse>
								Duraci&oacute;n: 
								<cfif #vAnios# GT 0>
									#vAnios# año<cfif #vMeses# GT 0>, </cfif>
								</cfif>
								<cfif #vMeses# GT 0>
									#vMeses# <cfif #vMeses# EQ 1>mes<cfelse>meses</cfif><cfif #vDias# GT 0>, </cfif>
								</cfif>
								<cfif #vDias# GT 0>
									#vDias# <cfif #vDias# EQ 1>día<cfelse>días</cfif>
								</cfif>
							</cfif>
						</td>
					</tr>		
				</cfif>
			</cfif>
		</cfif>
		<!--- Fecha --->
		<cfif #tbMovimientos.mov_clave# NEQ 5 AND #tbMovimientos.mov_clave# NEQ 6 AND #tbMovimientos.mov_clave# NEQ 15 AND #tbMovimientos.mov_clave# NEQ 16 AND #tbMovimientos.mov_clave# NEQ 21 AND #tbMovimientos.mov_clave# NEQ 25 AND #tbMovimientos.mov_clave# NEQ 26 AND #tbMovimientos.mov_clave# NEQ 30 AND #tbMovimientos.mov_clave# NEQ 36 AND #tbMovimientos.mov_clave# NEQ 31 AND #tbMovimientos.mov_clave# NEQ 38 AND #tbMovimientos.mov_clave# NEQ 39 AND #tbMovimientos.mov_clave# NEQ 40 AND #tbMovimientos.mov_clave# NEQ 41 AND #tbMovimientos.mov_clave# NEQ 42>
			<tr>
				<td colspan="2"></td>
				<td>
					<!--- Movimientos que inician al día siguiente de la sesión de CTIC --->
					<cfif #tbMovimientos.mov_clave# EQ 17 OR #tbMovimientos.mov_clave# EQ 28>
						A partir del #FechaCompleta(tbMovimientos.mov_fecha_inicio)# <!--- SOLUCIÓN TEMPORAL --->
					<!--- Reincorporaciones a la UNAM --->
					<cfelseif #tbMovimientos.mov_clave# EQ 20>
						Fecha de reincorporaci&oacute;n: #FechaCompleta(tbMovimientos.mov_fecha_inicio)#
					<!--- Movimientos que solo tienen fecha de inicio --->
					<cfelseif #tbMovimientos.mov_fecha_inicio# NEQ '' AND #tbMovimientos.mov_fecha_final# EQ ''>
						<cfif #tbMovimientos.mov_clave# EQ 22 AND #tbMovimientos.cam_clave# EQ 3>
							Del #FechaCompleta(tbMovimientos.mov_fecha_inicio)# HASTA EL T&Eacute;RMINO DE SU #tbMovimientos.mov_cargo#
						<cfelse>	
							A partir del #FechaCompleta(tbMovimientos.mov_fecha_inicio)#
						</cfif>	
					<!--- Movimientos que tienen las dos fechas --->    
					<cfelseif #tbMovimientos.mov_fecha_final# NEQ ''>
						<!--- Del, hasta el --->
						<cfif #tbMovimientos.mov_clave# EQ 22>
							Del #FechaCompleta(tbMovimientos.mov_fecha_inicio)# hasta el #FechaCompleta(tbMovimientos.mov_fecha_final)#
						<!--- Informe de periodo sabático --->
						<cfelseif #tbMovimientos.mov_clave# EQ 23>
							Informe del periodo sab&aacute;tico concedido del #FechaCompleta(tbMovimientos.mov_fecha_inicio)# al #FechaCompleta(tbMovimientos.mov_fecha_final)#
						<!--- a partir del (siguiente línea) --->
						<cfelse>
							A partir del #FechaCompleta(tbMovimientos.mov_fecha_inicio)#
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfif>
		<!--- Horas a la semana --->
		<cfif (#tbMovimientos.mov_clave# EQ 1 OR #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 38 OR #tbMovimientos.mov_clave# EQ 39) AND tbMovimientos.mov_horas IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>#LsNumberFormat(tbMovimientos.mov_horas, 99)# horas a la semana</td>
			</tr>
		</cfif>
		<!--- Sueldo mensual equivalente --->
		<cfif #tbMovimientos.mov_clave# EQ 6 AND tbMovimientos.mov_cn_clave IS NOT ''>
			<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbMovimientos.mov_cn_clave#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					Sueldo mensual: equivalente a #ctCategoria.cn_siglas#
				</td>
			</tr>
		</cfif>
		<!--- Por motivos personales --->
		<cfif #tbMovimientos.mov_clave# EQ 11 AND #tbMovimientos.mov_logico# IS 1>
			<tr>
				<td colspan="2"></td>
				<td>POR MOTIVOS PERSONALES</td>
			</tr>
		</cfif>
		<!--- Nombre del asesor --->
		<cfif #tbMovimientos.acd_id_asesor# IS NOT '' AND (#tbMovimientos.mov_clave# EQ 38 OR #tbMovimientos.mov_clave# EQ 39)>
			<cfquery name="tbAcademicosAsesor" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM academicos
				LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave 
				WHERE acd_id = #tbMovimientos.acd_id_asesor#
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>ASESOR: #Trim(tbAcademicosAsesor.acd_prefijo)# #Trim(tbAcademicosAsesor.acd_nombres)# #Trim(tbAcademicosAsesor.acd_apepat)# #Trim(tbAcademicosAsesor.acd_apemat)#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>#tbAcademicosAsesor.cn_siglas#</td>
			</tr>
		</cfif>
		<!--- Lugar y actividad de licencias y comisiones --->
		<cfif #tbMovimientos.mov_clave# EQ 40 OR #tbMovimientos.mov_clave# EQ 41>
			<!--- Obtener el país --->
			<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais WHERE pais_clave = '#tbMovimientos.pais_clave#'
			</cfquery>
			<!--- Obtener el estado --->
			<cfquery name="ctEstado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#tbMovimientos.edo_clave#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Lugar: #tbMovimientos.mov_ciudad#, <cfif #tbMovimientos.edo_clave# IS NOT ''><cfif #tbMovimientos.pais_clave# IS 'MEX' OR #tbMovimientos.pais_clave# IS 'USA'>#ctEstado.edo_nombre#, <cfelse>#tbMovimientos.edo_clave#, </cfif></cfif>#ctPais.pais_nombre#</td>
			</tr>
			<!--- Obtener tipo de actividad --->
			<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_actividad WHERE activ_clave = '#tbMovimientos.activ_clave#' <!--- Si no hace la conversión automática probar esto: CONVERT(INT,'#tbMovimientos..activ_clave#') --->
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Actividad: #ctActividad.activ_descrip#</td>
			</tr>			
		</cfif>
		<!--- Sintesis --->
		<cfif #tbMovimientos.mov_sintesis# IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>#tbMovimientos.mov_sintesis#</td>
			</tr>
		<!--- NOTA: Los movimientos anteriores a la liberación del SAMAA no tienen síntesis y en su lugar se desplegará el campo Memo 1 --->	
		<cfelseif #tbMovimientos.mov_memo_1# IS NOT ''>
			<!--- Excepciones --->
			<cfif #tbMovimientos.mov_clave# NEQ 5 AND #tbMovimientos.mov_clave# NEQ 17 AND #tbMovimientos.mov_clave# NEQ 28>
				<tr>
					<td colspan="2"></td>
					<td>#tbMovimientos.mov_memo_1#</td>
				</tr>
			</cfif>	
		</cfif>	
		<!--- Información adicional desplegada correcciones a oficio (FT-CTIC-31) --->
		<cfif #tbSolicitudes.mov_clave# EQ 31><!--- NOTA: No hay error, se toma la clave del movimiento del registro de solicitudes --->
			<!--- Decisión del CTIC --->
			<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM movimientos_asunto
				INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
				WHERE sol_id = #tbMovimientos.sol_id# AND asu_reunion = 'CTIC'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>#tbAsuntosCTIC.dec_descrip#</td>
			</tr>
			<!--- Número de acta --->
			<tr>
				<td colspan="2"></td>
				<td>ACTA #tbMovimientos.acta# <cfif #tbMovimientos.asu_numero# IS NOT ''>(ASUNTO #tbMovimientos.asu_numero#)</cfif></td>
			</tr>
			<!--- Lista de correcciones --->
			<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM movimientos_correccion 
				WHERE sol_id = #tbSolicitudes.sol_id#
				ORDER BY co_campo, co_tipo DESC
			</cfquery>
			<cfloop query="tbCorrecciones">	
				<!--- Cambios --->
				<tr>
					<td colspan="2"></td>
					<td>
						<cfoutput>#tbCorrecciones.co_tipo#: #DescripcionCambio(tbCorrecciones,tbMovimientos)#</cfoutput>
					</td>
				</tr>
			</cfloop>
			<!--- Oficio --->
			<tr>
				<td colspan="2"></td>
				<td>
					Oficio #tbSolicitudes.asu_oficio#
				</td>
			</tr>
		</cfif>
	</cfoutput>
</cffunction>
<!--- Función para generar la descripción de los cambios en la sección VI (correcciones a oficio)--->	
<cffunction name="DescripcionCambio" description="Genera la descripción del tipo de cambio">
	<cfargument name="tbCorrecciones">
	<cfargument name="tbMovimientos">
	<cfif #tbCorrecciones.co_campo# IS 'NOMBRE'>
		<cfreturn #tbMovimientos.acd_prefijo# & #tbCorrecciones.co_nombres# & ' ' & #tbCorrecciones.co_apepat# & ' ' & #tbCorrecciones.co_apemat#>
	<cfelseif #tbCorrecciones.co_campo# IS 'DURACION'>
			<cfif #tbCorrecciones.co_fecha_final# EQ ''>
				<cfif #tbMovimientos.mov_clave# EQ 22>
					<cfset vDuracion = "Diferir de la fecha " & #FechaCompleta(tbCorrecciones.co_fecha_inicio)#>
				<cfelse>
					<cfset vDuracion = "A partir del " & #FechaCompleta(tbCorrecciones.co_fecha_inicio)#>
				</cfif>
			<cfelse>
				<cfif #tbMovimientos.mov_clave# NEQ 22>
					<!--- Desglosar el periodo en años, meses y días --->
					<cfset vFF = #dateadd('d',1,tbCorrecciones.co_fecha_final)#>
					<cfset vF1 = #tbCorrecciones.co_fecha_inicio#>
					<cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
					<cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
					<cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
					<cfset vF3 = #dateadd('m',vMeses,vF2)#>			
					<cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
					<cfset vDuracion = "Duración: ">
					<cfif #vAnios# GT 0>
						<cfset vDuracion = vDuracion & #ToString(vAnios)# & " año,">
					</cfif>
					<cfif #vMeses# GT 0>
						<cfset vDuracion = vDuracion & #ToString(vMeses)#><cfif #vMeses# EQ 1><cfset vDuracion = vDuracion & " mes,"><cfelse><cfset vDuracion = vDuracion & " meses,"></cfif>
					</cfif>
					<cfif #vDias# GT 0>
						<cfset vDuracion = vDuracion & #ToString(vDias)#><cfif #vDias# EQ 1><cfset vDuracion = vDuracion & " día,"><cfelse><cfset vDuracion = vDuracion & " días,"></cfif>
					</cfif>
				</cfif>
				<cfif #tbMovimientos.mov_clave# EQ 22> 
					<cfset vDuracion = vDuracion & "Diferir del " & #FechaCompleta(tbCorrecciones.co_fecha_inicio)#> 
				<cfelse> 
					<cfset vDuracion = vDuracion & Chr(8) & " a partir del " & #FechaCompleta(tbCorrecciones.co_fecha_inicio)#>
				</cfif>
				<cfif #tbMovimientos.mov_clave# EQ 22> 
					<cfset vDuracion = vDuracion & " hasta el " & #FechaCompleta(tbCorrecciones.co_fecha_final)#>
				<cfelse> 
					<!---<cfset vDuracion = vDuracion & " al " & #FechaCompleta(tbCorrecciones.co_fecha_final)#>--->
				</cfif>
			</cfif>
			<cfreturn #vDuracion#>
	<cfelse>
		<cfreturn #tbCorrecciones.co_texto#>
	</cfif>
</cffunction>