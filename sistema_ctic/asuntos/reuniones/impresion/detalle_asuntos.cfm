<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 18/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 26/07/2019 --->
<!--- IMPRESION DEL DETALLE DEL ASUNTO DEL LISTADO DE LA CAAA/CTIC --->
<cffunction name="DetalleAsunto" description="Genera el detalle del asunto dentro de la lista de asuntos CAAA/CTIC.">
	<cfargument name="tbSolicitudes">
	<cfoutput>
		<!--- Programa asociado a una obra determinada --->
		<cfif #tbSolicitudes.mov_clave# EQ 6 AND #tbSolicitudes.sol_pos12# IS NOT ''>
			<cfquery name="ctPrograma" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_programa WHERE prog_clave = #tbSolicitudes.sol_pos12#
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>#ctPrograma.prog_nombre#</td>
			</tr>
		</cfif>
		<!--- Dependencia, número de asunto, movimiento --->
		<cfif #tbSolicitudes.mov_clave# NEQ 31>
			<tr>
				<td width="10%">#tbSolicitudes.dep_siglas#</td>
				<td width="4%">
					<cfif #tbSolicitudes.mov_clave# EQ 40 OR #tbSolicitudes.mov_clave# EQ 41>
						#tbSolicitudes.currentRow#
					<cfelse>
						#tbSolicitudes.asu_numero#
					</cfif>
				</td>
				<td>
					<!--- Tipo de movimiento --->
					<cfif #tbSolicitudes.mov_clave# EQ 2 OR #tbSolicitudes.mov_clave# EQ 3 OR #tbSolicitudes.mov_clave# EQ 4><!--- Comisión mayor a 22 días, comisión encomandada por el rector --->
						<cfif #tbSolicitudes.mov_clave# EQ 4 AND tbSolicitudes.sol_pos12 IS 'PRORROGA'>
							PRORROGA DE
						</cfif>
						#UCase(tbSolicitudes.mov_titulo_listado)#
						<cfif #tbSolicitudes.sol_pos17# EQ 0>
							SIN GOCE DE SUELDO
						<cfelseif #tbSolicitudes.sol_pos17# GT 0 AND #tbSolicitudes.sol_pos17# LT 100>
							CON GOCE DE SUELDO PARCIAL (#Trim(LsNumberFormat(tbSolicitudes.sol_pos17,99))#%)
						</cfif>
					<cfelseif #tbSolicitudes.mov_clave# EQ 13 OR #tbSolicitudes.mov_clave# EQ 29><!--- Cambio de dependencia, cambio de ubicación --->
						#UCase(tbSolicitudes.mov_titulo_listado)#
						<cfif #tbSolicitudes.sol_pos10# EQ 1>
							DEFINITIVO
						<cfelseif #tbSolicitudes.sol_pos10# EQ 2 OR #tbSolicitudes.sol_pos10# EQ 3>
							TEMPORAL
						</cfif>
					<cfelseif #tbSolicitudes.mov_clave# EQ 21 OR #tbSolicitudes.mov_clave# EQ 23 OR #tbSolicitudes.mov_clave# EQ 30><!--- Sabático, informe de sabático --->
						<cfif #tbSolicitudes.mov_clave# EQ 23>INFORME DE</cfif>
						<cfif #tbSolicitudes.sol_pos13# IS 'A'>
							A&Ntilde;O
						<cfelse>
							SEMESTRE
						</cfif>
						SAB&Aacute;TICO
						<cfif #tbSolicitudes.mov_clave# EQ 30>CON BECA DE DGAPA</cfif>
<!---				SE INCORPORARON LOS TÍTULOS EN LA TABLA DE CATALOGO_MOVIMIENTOS (06/06/2019)
					<cfelseif #tbSolicitudes.mov_clave# EQ 39><!--- Revonación de beca posdoctoral --->
						BECA POSDOCTORAL
					<cfelseif #tbSolicitudes.mov_clave# EQ 43><!--- Evaluación de informe de beca posdoctoral --->
						<cfif #tbSolicitudes.sol_pos10# EQ 6>
							EVALUACI&Oacute;N DE PRIMER INFORME SEMESTRAL
						<cfelseif #tbSolicitudes.sol_pos10# EQ 12>
							EVALUACI&Oacute;N DE INFORME FINAL
						<cfelseif #tbSolicitudes.sol_pos10# EQ 18>
							EVALUACI&Oacute;N DE TERCER INFORME SEMESTRAL
						<cfelseif #tbSolicitudes.sol_pos10# EQ 24>
							EVALUACI&Oacute;N DE INFORME FINAL
						</cfif>
--->						
					<cfelse>
						#UCase(tbSolicitudes.mov_titulo_listado)#
					</cfif>
					<!--- Determinar si el movimeitno es extemporaneo ---><!--- SE AGREGARON LAS PROMOCIONES Y DEFINITIVIDADES 29/04/2019 --->
					<cfif (#tbSolicitudes.mov_clave# NEQ 7 AND #tbSolicitudes.mov_clave# NEQ 8 AND #tbSolicitudes.mov_clave# NEQ 9 AND #tbSolicitudes.mov_clave# NEQ 10 AND #tbSolicitudes.mov_clave# NEQ 22 AND #tbSolicitudes.mov_clave# NEQ 23 AND #tbSolicitudes.mov_clave# NEQ 43) AND #tbSolicitudes.sol_pos14# NEQ '' AND DateCompare(#tbSolicitudes.sol_pos14#, #tbSesiones.ssn_fecha#, "d") IS -1>
						(EXTEMPOR&Aacute;NEO)
					</cfif>
					<!--- Determinar si el nuevo dictámen es "APROBATORIO" o "NO APROBATORIO"  --->
					<cfif #tbSolicitudes.mov_clave# EQ 17 OR #tbSolicitudes.mov_clave# EQ 18 OR #tbSolicitudes.mov_clave# EQ 19>
						<cfif #tbSolicitudes.sol_pos30# IS 0>NO </cfif>APROBATORIO
					</cfif>
				</td>
			</tr>
			<!--- Subtitulo del asunto --->
			<cfif #tbSolicitudes.mov_clave# EQ 15 OR #tbSolicitudes.mov_clave# EQ 16>
				<tr>
					<td colspan="2"></td>
					<td>Concurso de oposici&oacute;n abierto (Contrato)</td>
				</tr>
			<cfelseif #tbSolicitudes.mov_clave# EQ 17>
				<tr>
					<td colspan="2"></td>
					<td>Concurso de oposici&oacute;n abierto <!--- PENDIENTE: No hay de donde obtener el siguiente dato ---></td>
				</tr>
			<cfelseif #tbSolicitudes.mov_clave# EQ 18>
				<tr>
					<td colspan="2"></td>
					<td>Concurso de oposici&oacute;n cerrado (Definitividad)</td>
				</tr>
			<cfelseif #tbSolicitudes.mov_clave# EQ 19>
				<tr>
					<td colspan="2"></td>
					<td>Concurso de oposici&oacute;n cerrado (Promoci&oacute;n)</td>
				</tr>
			<cfelseif #tbSolicitudes.mov_clave# EQ 42>
				<tr>
					<td colspan="2"></td>
					<td>Concurso desierto</td>
				</tr>
			</cfif>
			<!--- OPINIÓN NEGATIVA --->
			<cfif #tbSolicitudes.mov_clave# EQ 2 OR #tbSolicitudes.mov_clave# EQ 3 OR #tbSolicitudes.mov_clave# EQ 11 OR #tbSolicitudes.mov_clave# EQ 20 OR #tbSolicitudes.mov_clave# EQ 21 OR #tbSolicitudes.mov_clave# EQ 29 OR #tbSolicitudes.mov_clave# EQ 30 OR #tbSolicitudes.mov_clave# EQ 34 OR #tbSolicitudes.mov_clave# EQ 36>
				<cfif #tbSolicitudes.sol_pos27# EQ 1 AND #tbSolicitudes.sol_pos26# EQ 0>
					<tr>
						<td colspan="2"></td>
						<td>OPINI&Oacute;N NEGATIVA</td>
					</tr>
				</cfif>
			</cfif>
			<!--- DICTAMEN NO APROBATORIO --->
			<cfif #tbSolicitudes.mov_clave# EQ 6 OR #tbSolicitudes.mov_clave# EQ 7 OR #tbSolicitudes.mov_clave# EQ 8 OR #tbSolicitudes.mov_clave# EQ 9 OR #tbSolicitudes.mov_clave# EQ 10 OR #tbSolicitudes.mov_clave# EQ 12 OR #tbSolicitudes.mov_clave# EQ 13>
				<cfif #tbSolicitudes.sol_pos31# EQ 1 AND #tbSolicitudes.sol_pos30# EQ 0>
					<tr>
						<td colspan="2"></td>
						<td>DICTAMEN NO APROBATORIO</td>
					</tr>
				</cfif>
			</cfif>
			<!--- DIFERENCIA DE OPINIÓN --->
			<cfif (#Trim(tbSolicitudes.mov_pos26)# IS NOT '' AND #Trim(tbSolicitudes.mov_pos30)# IS NOT '') AND (#tbSolicitudes.sol_pos26# EQ 1 AND #tbSolicitudes.sol_pos30# EQ 0) OR (#tbSolicitudes.sol_pos26# EQ 0 AND #tbSolicitudes.sol_pos30# EQ 1)>
				<tr>
					<td colspan="2"></td>
					<td>
						DIFERENCIA DE OPINI&Oacute;N
					</td>
				</tr>
			</cfif>
		</cfif>
		<!--- Desplegar la información del movimiento relacionado (Correcciones a oficio y recursos de reconsideración) --->
		<cfif #tbSolicitudes.mov_clave# EQ 31 OR #tbSolicitudes.mov_clave# EQ 37>
			#DetalleAsuntoRelacionado(tbSolicitudes)#
		</cfif>
		<!--- Nombre del académico --->
		<cfif #tbSolicitudes.mov_clave# NEQ 15 AND #tbSolicitudes.mov_clave# NEQ 16 AND #tbSolicitudes.mov_clave# NEQ 31 AND #tbSolicitudes.mov_clave# NEQ 37 AND #tbSolicitudes.mov_clave# NEQ 42>
			<tr>
				<td colspan="2"></td>
				<td>#Trim(tbSolicitudes.acd_prefijo)# #nombre_comp#<!--- #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)# ---></td>
			</tr>
		</cfif>
		<!--- Categoría y nivel --->
		<cfif #tbSolicitudes.mov_clave# NEQ 6 AND 
				#tbSolicitudes.mov_clave# NEQ 23 AND 
				#tbSolicitudes.mov_clave# NEQ 26 AND 
				#tbSolicitudes.mov_clave# NEQ 27 AND 
				#tbSolicitudes.mov_clave# NEQ 31 AND 
				#tbSolicitudes.mov_clave# NEQ 37 AND 
				#tbSolicitudes.mov_clave# NEQ 38 AND 
				#tbSolicitudes.mov_clave# NEQ 39 AND 
				#tbSolicitudes.mov_clave# NEQ 43 AND 
				#tbSolicitudes.mov_clave# NEQ 44>
			<!--- Categoría y nivel del académico --->
			<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbSolicitudes.sol_pos3#'
			</cfquery>
			<!--- Categoría y nivel del movimiento --->
			<cfquery name="ctCategoriaMov" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbSolicitudes.sol_pos8#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #tbSolicitudes.mov_clave# EQ 5 OR #tbSolicitudes.mov_clave# EQ 15 OR #tbSolicitudes.mov_clave# EQ 16 OR #tbSolicitudes.mov_clave# EQ 17 OR #tbSolicitudes.mov_clave# EQ 20 OR #tbSolicitudes.mov_clave# EQ 28 OR #tbSolicitudes.mov_clave# EQ 36 OR #tbSolicitudes.mov_clave# EQ 42>
						<cfif #tbSolicitudes.mov_clave# NEQ 20 AND #tbSolicitudes.mov_clave# NEQ 36>Como </cfif>#ctCategoriaMov.cn_siglas#
					<cfelseif #tbSolicitudes.mov_clave# EQ 9 OR #tbSolicitudes.mov_clave# EQ 10 OR #tbSolicitudes.mov_clave# EQ 19>
						De #ctCategoria.cn_siglas# a #ctCategoriaMov.cn_siglas#
					<cfelse>
						<cfif #tbSolicitudes.mov_clave# EQ 25>Como </cfif>#ctCategoria.cn_siglas#
					</cfif>
				</td>
			</tr>
		</cfif>
		<!--- Cambio de tiempo --->
		<cfif #tbSolicitudes.mov_clave# EQ 12>
			<cfquery name="ctCategoriaNueva" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn WHERE cn_clave = '#tbSolicitudes.sol_pos8#'
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
		<cfif #tbSolicitudes.mov_clave# EQ 15 OR #tbSolicitudes.mov_clave# EQ 16 OR #tbSolicitudes.mov_clave# EQ 42>
			<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM convocatorias_coa WHERE coa_id = '#tbSolicitudes.sol_pos23#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Plaza n&uacute;mero: #tbSolicitudes.sol_pos9#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>Publicado en Gaceta el #FechaCompleta(tbSolicitudes.sol_pos21)#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>Area: #UCase(tbConvocatorias.coa_area)#</td>
			</tr>
		</cfif>
		<!--- Número de contrato / SE AGREGÓ ETIQUETA NÚMERO DE CÁTEDRA CONACyT 04/11/2016 --->
		<cfif #tbSolicitudes.mov_clave# EQ 6>
			<tr>
				<td colspan="2"></td>
				<td>CONTRATO N&Uacute;MERO: #LsNumberFormat(tbSolicitudes.sol_pos17 + 1,99)#</td>
			</tr>
		</cfif>
		<!--- Número de cátedra --->
		<cfif #tbSolicitudes.mov_clave# EQ 44>
			<tr>
				<td colspan="2"></td>
				<td>Cátedra N&uacute;mero: #LsNumberFormat(tbSolicitudes.sol_pos17 + 1,99)#</td>
			</tr>
		</cfif>
		<!--- Cambio de adscripción --->
		<cfif #tbSolicitudes.mov_clave# EQ 13>
			<!--- Obtener la adscripción secundaria (puede ser origen o destino) --->
			<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia WHERE dep_clave = '#tbSolicitudes.sol_pos11#'
			</cfquery>
			<!--- Determinar si el cambio es de la entidad a otra o al revés --->
			<cfif #tbSolicitudes.sol_pos20# IS 1>
				<tr>
					<td colspan="2"></td>
					<td><cfif #Left(tbSolicitudes.dep_nombre,2)# IS 'CE' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'CC' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'IN' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'PR'>DEL<cfelse>DE LA</cfif> #tbSolicitudes.dep_nombre#</td>
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
					<td><cfif #Left(tbSolicitudes.dep_nombre,2)# IS 'CE' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'CC' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'IN' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'PR'>AL<cfelse>A LA</cfif> #tbSolicitudes.dep_nombre#</td>
				</tr>
			</cfif>
		</cfif>
		<!--- Fecha de renuncia --->
		<cfif #tbSolicitudes.mov_clave# EQ 20>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de renuncia: #FechaCompleta(tbSolicitudes.sol_pos21)#</td>
			</tr>
		</cfif>
		<!--- Fecha de ingreso a la UNAM --->
		<cfif #tbSolicitudes.mov_clave# EQ 34>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de ingreso a la UNAM: #FechaCompleta(tbSolicitudes.sol_pos21)#</td>
			</tr>
		</cfif>
		<!--- Fecha de jubilación --->
		<cfif #tbSolicitudes.mov_clave# EQ 36 AND #tbSolicitudes.sol_pos21# IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>Fecha de jubilaci&oacute;n: #FechaCompleta(tbSolicitudes.sol_pos21)#</td>
			</tr>
		</cfif>
		<!--- Instituciones de procedencia --->
		<cfif #tbSolicitudes.mov_clave# EQ 34>
			<cfquery name="tbAntiguedad" datasource='#vOrigenDatosSAMAA#'>
				SELECT * FROM movimientos_antiguedad WHERE sol_id = #tbSolicitudes.sol_id# ORDER BY antig_fecha_final DESC
		    </cfquery>
		    <tr>
				<td colspan="2"></td>
				<td>INSTITUCIONES DE PROCEDENCIA:
			</td>
			</tr>
		    <tr>
				<td colspan="2"></td>
				<td>
				    <cfloop query="tbAntiguedad">
					 	#tbAntiguedad.antig_institucion#<br><!--- Podrían ir en una lista separada por comas --->
				    </cfloop>
				</td>
			</tr>
		</cfif>
		<!--- Antigüedad a reconocer --->
		<cfif #tbSolicitudes.mov_clave# EQ 34>
			<tr>
				<td colspan="2"></td>
				<td>
					Antig&uuml;edad a reconocer:
					<cfif #tbSolicitudes.sol_pos13_a# GT 0>
						#tbSolicitudes.sol_pos13_a# <cfif #tbSolicitudes.sol_pos13_a# EQ 1>a&ntilde;o<cfelse>a&ntilde;os</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0>, </cfif>
					</cfif>
					<cfif #tbSolicitudes.sol_pos13_m# GT 0>
						#tbSolicitudes.sol_pos13_m# <cfif #tbSolicitudes.sol_pos13_m# EQ 1>mes<cfelse>meses</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0>, </cfif>
					</cfif>
					<cfif #tbSolicitudes.sol_pos13_d# GT 0>
						#tbSolicitudes.sol_pos13_d# <cfif #tbSolicitudes.sol_pos13_d# EQ 1>día<cfelse>días</cfif>
					</cfif>
				</td>
			</tr>
		</cfif>
		<!--- Número de revovación --->
		<cfif #tbSolicitudes.mov_clave# EQ 25>
			<tr>
				<td colspan="2"></td>
				<td>#LsNumberFormat(tbSolicitudes.sol_pos17,99)#<sup>a</sup> RENOVACI&Oacute;N</td>
			</tr>
		</cfif>
		<!--- País de procedencia de investigador visitante --->
		<cfif #tbSolicitudes.mov_clave# EQ 26>
			<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais WHERE pais_clave = '#tbSolicitudes.sol_pos11_p#'
			</cfquery>
			<!--- Obtener el estado --->
			<cfquery name="ctEstado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#tbSolicitudes.sol_pos11_e#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>#tbSolicitudes.sol_pos11#, #Trim(tbSolicitudes.sol_pos11_c)#<cfif #tbSolicitudes.sol_pos11_p# IS NOT 'MEX'><cfif #tbSolicitudes.sol_pos11_e# IS NOT ''>, <cfif #tbSolicitudes.sol_pos11_p# IS 'USA'>#Trim(ctEstado.edo_nombre)#, <cfelse>#Trim(tbSolicitudes.sol_pos11_e)#, </cfif></cfif>#Trim(ctPais.pais_nombre)#</cfif></td>
			</tr>
		</cfif>
		<!--- Cambio de ubicación --->
		<cfif #tbSolicitudes.mov_clave# EQ 29>
			<!--- Ubicación actual --->
			<cfquery name="ctUbicacionActual" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia_ubica
				WHERE dep_clave = '#tbSolicitudes.sol_pos1#' AND ubica_clave = '#tbSolicitudes.sol_pos1_u#'
			</cfquery>
			<!--- Ubicación a la que aspira --->
			<cfquery name="ctUbicacionAspira" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_dependencia_ubica
				WHERE dep_clave = '#tbSolicitudes.sol_pos1#' AND ubica_clave = '#tbSolicitudes.sol_pos11_u#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #ctUbicacionActual.ubica_tipo# IS 'UNIDAD' OR #ctUbicacionActual.ubica_tipo# IS 'ESTACION' OR #ctUbicacionActual.ubica_tipo# IS 'DEPENDENCIA'  OR #ctUbicacionActual.ubica_tipo# IS 'PLATAFORMA'>DE LA<cfelse>DEL</cfif>
					#ctUbicacionActual.ubica_nombre# #ctUbicacionActual.ubica_lugar#
				</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>
					<cfif #ctUbicacionAspira.ubica_tipo# IS 'UNIDAD' OR #ctUbicacionAspira.ubica_tipo# IS 'ESTACION' OR #ctUbicacionAspira.ubica_tipo# IS 'DEPENDENCIA'  OR #ctUbicacionAspira.ubica_tipo# IS 'PLATAFORMA'>A LA<cfelse>AL</cfif>
					#ctUbicacionAspira.ubica_nombre# #ctUbicacionAspira.ubica_lugar#
				</td>
			</tr>
		</cfif>
		<!--- Número de beca --->
		<cfif #tbSolicitudes.mov_clave# EQ 38 OR #tbSolicitudes.mov_clave# EQ 39>
			<!--- Obtener número de becas anteriores --->
			<cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
				SELECT COUNT(*) AS numero_becas
				FROM (movimientos
				LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
				LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
				WHERE acd_id = #tbSolicitudes.sol_pos2#
				AND mov_clave = 38 <!--- Beca posdoctoral --->
				AND asu_reunion = 'CTIC'
				AND (dec_super = 'AP' OR dec_super = 'CO') <!--- Asuntos aprobados o condicionados a obtención de grado --->
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>BECA N&Uacute;MERO: #LsNumberFormat(tbMovimientosBecas.numero_becas + 1,99)#</td>
			</tr>
		</cfif>
		<!--- Duración --->
		<cfif #tbSolicitudes.mov_clave# NEQ 15 AND #tbSolicitudes.mov_clave# NEQ 16 AND #tbSolicitudes.mov_clave# NEQ 22 AND #tbSolicitudes.mov_clave# NEQ 31 AND #tbSolicitudes.mov_clave# NEQ 42 AND #tbSolicitudes.mov_clave# NEQ 43>
			<!--- Duración fija de un año a partir de un día después de la fecha de la sesión --->
			<cfif #tbSolicitudes.mov_clave# EQ 5>
				<tr>
					<td colspan="2"></td>
					<td>
						Duraci&oacute;n: 1 a&ntilde;o a partir del #FechaCompleta(tbSolicitudes.sol_pos14)#<!---#FechaCompleta(DateAdd('d',1,tbSesiones.ssn_fecha))# EL 06/06/2019 SE CAMBIÓ LA FECHA DE INICIO ---->
					</td>
				</tr>
			<!--- Hasta el término de su cargo --->
			<cfelseif #tbSolicitudes.sol_pos14# NEQ '' AND #tbSolicitudes.sol_pos15# EQ '' AND #tbSolicitudes.sol_pos10# EQ 3>
				<tr>
					<td colspan="2"></td>
					<td>
						Duraci&oacute;n: HASTA EL T&Eacute;RMINO DE SU #tbSolicitudes.sol_pos12#
					</td>
				</tr>
			<!--- Hay las dos fechas --->
			<cfelseif #tbSolicitudes.sol_pos15# NEQ ''>
				<!--- Duración --->
				<cfif #tbSolicitudes.mov_clave# EQ 23>
					<cfset vAnios = 0>
					<cfset vMeses = 0>
					<cfset vDias = 0>
				<cfelse>
					<!--- Desglosar el periodo en años, meses y días --->
					<cfset vFF = #DateAdd('d',1,tbSolicitudes.sol_pos15)#>
					<cfset vF1 = #tbSolicitudes.sol_pos14#>
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
							<cfif #tbSolicitudes.mov_clave# EQ 6 OR #tbSolicitudes.mov_clave# EQ 21 OR #tbSolicitudes.mov_clave# EQ 25 OR #tbSolicitudes.mov_clave# EQ 26 OR #tbSolicitudes.mov_clave# EQ 30 OR #tbSolicitudes.mov_clave# EQ 36 OR #tbSolicitudes.mov_clave# EQ 38 OR #tbSolicitudes.mov_clave# EQ 39 OR #tbSolicitudes.mov_clave# EQ 40 OR #tbSolicitudes.mov_clave# EQ 41 OR #tbSolicitudes.mov_clave# EQ 44>
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
								a partir del #FechaCompleta(tbSolicitudes.sol_pos14)#
							<!--- Sólo duración --->
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
		<!--- Nota acerca de la duración --->
		<cfif #tbSolicitudes.mov_clave# EQ 2 AND #tbSolicitudes.sol_pos12_o# IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td>#tbSolicitudes.sol_pos12_o#</td>
			</tr>
		</cfif>
		<!--- Fecha --->
		<cfif #tbSolicitudes.mov_clave# NEQ 5 AND #tbSolicitudes.mov_clave# NEQ 6 AND #tbSolicitudes.mov_clave# NEQ 15 AND #tbSolicitudes.mov_clave# NEQ 16 AND #tbSolicitudes.mov_clave# NEQ 21 AND #tbSolicitudes.mov_clave# NEQ 25 AND #tbSolicitudes.mov_clave# NEQ 26 AND #tbSolicitudes.mov_clave# NEQ 30 AND #tbSolicitudes.mov_clave# NEQ 36 AND #tbSolicitudes.mov_clave# NEQ 31 AND  #tbSolicitudes.mov_clave# NEQ 38 AND #tbSolicitudes.mov_clave# NEQ 39 AND #tbSolicitudes.mov_clave# NEQ 40 AND #tbSolicitudes.mov_clave# NEQ 41 AND #tbSolicitudes.mov_clave# NEQ 42 AND #tbSolicitudes.mov_clave# NEQ 44>
			<tr>
				<td colspan="2"></td>
				<td>
					<!--- Promociones --->
					<cfif #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 19>
						<!--- Si la fecha solicitada es posterior a la fecha del CTIC, la fecha solicitada permanece sin cambio --->
						<cfif DateCompare(#tbSesiones.ssn_fecha#, #tbSolicitudes.sol_pos14#, "d") GT 0>
							A partir del #FechaCompleta(tbSolicitudes.sol_pos14)#
						<!--- Si la fecha solicitada es anterior a la fecha del CTIC, la fecha solicitada cambia y se pone la fecha del CTIC --->
						<cfelse>
							A partir del #FechaCompleta(tbSesiones.ssn_fecha)#
						</cfif>
					<!--- Definitividades ---><!---  SE SEPARÓ EL CÓDIGO PARA IDENTIFICAR SI EXISTE UNA PROMOCIÓN A LA PAR (05/06/2019) --->
					<cfelseif #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 18>
						<cfquery name="tbSolicitudesProm" datasource="#vOrigenDatosSAMAA#">
                            SELECT *
                            FROM consulta_solicitudes_listados
                            WHERE sol_status = 2 <!--- Asuntos que pasan a la CAAA ---> 
                            AND asu_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
                            AND ssn_id = #tbSolicitudes.ssn_id#
                            AND sol_pos2 = #tbSolicitudes.sol_pos2#
							<cfif #tbSolicitudes.mov_clave# EQ 7>
								AND mov_clave = 9
							<cfelseif #tbSolicitudes.mov_clave# EQ 8>
								AND mov_clave = 10
							</cfif>
						</cfquery>
                    
						<!--- Si la fecha solicitada es posterior a la fecha del CTIC, la fecha solicitada permanece sin cambio --->
						<cfif DateCompare(#tbSesiones.ssn_fecha#, #tbSolicitudes.sol_pos14#, "d") GT 0 AND #tbSolicitudesProm.RecordCount# EQ 0>
							A partir del #FechaCompleta(tbSolicitudes.sol_pos14)#
						<!--- Si la fecha solicitada es anterior a la fecha del CTIC, la fecha solicitada cambia y se pone la fecha del CTIC --->
						<cfelse>
							A partir del #FechaCompleta(tbSesiones.ssn_fecha)#
						</cfif>
					<!--- Movimientos que inician al día siguiente de la sesión de CTIC --->
					<cfelseif #tbSolicitudes.mov_clave# EQ 5 OR #tbSolicitudes.mov_clave# EQ 17 OR #tbSolicitudes.mov_clave# EQ 28>
						A partir del #FechaCompleta(DateAdd('d',1,tbSesiones.ssn_fecha))#
					<!--- Reincorporaciones a la UNAM --->
					<cfelseif #tbSolicitudes.mov_clave# EQ 20>
						Fecha de reincorporaci&oacute;n: #FechaCompleta(tbSolicitudes.sol_pos14)#
					<!--- Evaluación de beca posdoctoral --->
					<cfelseif #tbSolicitudes.mov_clave# EQ 43>
						#Ucase(LsDateFormat(tbSolicitudes.sol_pos14,"mmmm"))# #LsDateFormat(tbSolicitudes.sol_pos14,"yyyy")# - #Ucase(LsDateFormat(tbSolicitudes.sol_pos15,"mmmm"))# #LsDateFormat(tbSolicitudes.sol_pos15,"yyyy")#
					<!--- Movimientos que solo tienen fecha de inicio --->
					<cfelseif #tbSolicitudes.sol_pos14# NEQ '' AND #tbSolicitudes.sol_pos15# EQ ''>
						<cfif #tbSolicitudes.mov_clave# EQ 22 AND #tbSolicitudes.sol_pos10# EQ 3>
							Del #FechaCompleta(tbSolicitudes.sol_pos14)# HASTA EL T&Eacute;RMINO DE SU #tbSolicitudes.sol_pos12#
						<cfelse>
							A partir del #FechaCompleta(tbSolicitudes.sol_pos14)#
						</cfif>
					<!--- Movimientos que tienen las dos fechas --->
					<cfelseif #tbSolicitudes.sol_pos15# NEQ ''>
						<!--- Del, hasta el --->
						<cfif #tbSolicitudes.mov_clave# EQ 22>
							Del #FechaCompleta(tbSolicitudes.sol_pos14)# hasta el #FechaCompleta(tbSolicitudes.sol_pos15)#
						<!--- Informe de periodo sabático ---><!--- se cambió CONCEDIDO por COMPRENDIDO (29/04/2019)--->
						<cfelseif #tbSolicitudes.mov_clave# EQ 23>
							Informe del periodo sab&aacute;tico comprendido del #FechaCompleta(tbSolicitudes.sol_pos14)# al #FechaCompleta(tbSolicitudes.sol_pos15)#
						<!--- A partir del (siguiente línea) --->
						<cfelse>
							A partir del #FechaCompleta(tbSolicitudes.sol_pos14)#
						</cfif>
					</cfif>
				</td>
			</tr>
		</cfif>
		<!--- Horas a la semana --->
		<cfif #tbSolicitudes.mov_clave# EQ 1 OR #tbSolicitudes.mov_clave# EQ 6 OR #tbSolicitudes.mov_clave# EQ 38 OR #tbSolicitudes.mov_clave# EQ 39>
			<tr>
				<td colspan="2"></td>
				<td>#LsNumberFormat(tbSolicitudes.sol_pos16,99)# horas a la semana</td>
			</tr>
		</cfif>
		<!--- Sueldo mensual equivalente --->
		<cfif #tbSolicitudes.mov_clave# EQ 6>
			<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_cn
				WHERE cn_clave = '#tbSolicitudes.sol_pos8#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>
					Sueldo mensual: equivalente a #ctCategoria.cn_siglas#
				</td>
			</tr>
		</cfif>
		<!--- Por motivos personales --->
		<cfif #tbSolicitudes.mov_clave# EQ 11 AND #tbSolicitudes.sol_pos20# IS 'Si'>
			<tr>
				<td colspan="2"></td>
				<td>POR MOTIVOS PERSONALES</td>
			</tr>
		</cfif>
		<!--- Nombre del asesor / SE AGREGÓ ETIQUETA PARA CÁTEDRAS CONACyT 04/11/2016 --->
		<cfif #tbSolicitudes.mov_clave# EQ 38 OR #tbSolicitudes.mov_clave# EQ 39 OR #tbSolicitudes.mov_clave# EQ 44>
			<cfquery name="tbAcademicosAsesor" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM academicos
				LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave
				WHERE acd_id = #tbSolicitudes.sol_pos12#
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td><cfif #tbSolicitudes.mov_clave# EQ 44>RESPONSABLE TÉCNICO<cfelse>ASESOR</cfif>: #Trim(tbAcademicosAsesor.acd_prefijo)# #Trim(tbAcademicosAsesor.acd_nombres)# #Trim(tbAcademicosAsesor.acd_apepat)# #Trim(tbAcademicosAsesor.acd_apemat)#</td>
			</tr>
			<tr>
				<td colspan="2"></td>
				<td>#tbAcademicosAsesor.cn_siglas#</td>
			</tr>
		</cfif>
		<!--- Lugar y actividad de licencias y comisiones --->
		<cfif #tbSolicitudes.mov_clave# EQ 40 OR #tbSolicitudes.mov_clave# EQ 41>
			<!--- Obtener el país --->
			<cfquery name="ctPais" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais WHERE pais_clave = '#tbSolicitudes.sol_pos11_p#'
			</cfquery>
			<!--- Obtener el estado --->
			<cfquery name="ctEstado" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_pais_edo WHERE edo_clave = '#tbSolicitudes.sol_pos11_e#'
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Lugar: #Trim(tbSolicitudes.sol_pos11_c)#, <cfif #tbSolicitudes.sol_pos11_e# IS NOT ''><cfif #tbSolicitudes.sol_pos11_p# IS 'MEX' OR #tbSolicitudes.sol_pos11_p# IS 'USA'>#Trim(ctEstado.edo_nombre)#, <cfelse>#Trim(tbSolicitudes.sol_pos11_e)#, </cfif></cfif>#Trim(ctPais.pais_nombre)#</td>
			</tr>
			<!--- Obtener tipo de actividad --->
			<cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM catalogo_actividad WHERE activ_clave = '#tbSolicitudes.sol_pos12#' <!--- Si no hace la conversión automática probar esto: CONVERT(INT,'#tbSolicitudes.sol_pos12#') --->
			</cfquery>
			<tr>
				<td colspan="2"></td>
				<td>Actividad: #ctActividad.activ_descrip#</td>
			</tr>
		</cfif>
		<!--- Proyecto --->
		<cfif #tbSolicitudes.mov_clave# EQ 44>
			<tr>
				<td colspan="2"></td>
				<td>
					Proyecto: &ldquo;#Ucase(tbSolicitudes.sol_memo1)#&rdquo;
				</td>
			</tr>
		</cfif>
		<!--- Sintesis --->
		<!--- NOTA: Lo dejé siempre que existe para que el sistema tenga la flexibilidad de siempre incluir una síntesis o comentario,
			  si no se desea que aparezca solamente hay que dejar vacío el campo sol_sintesis  --->
		<cfif #tbSolicitudes.mov_clave# NEQ 44 AND #Trim(tbSolicitudes.sol_sintesis)# IS NOT ''>
			<tr>
				<td colspan="2"></td>
				<td><cfif #tbSolicitudes.mov_clave# EQ 44>Proyecto: </cfif>#tbSolicitudes.sol_sintesis#</td><!--- SE AGREGÓ ETIQUETA PROYECTO PARA CÁTEDRAS CONACyT --->
			</tr>
		</cfif>
		<!--- Listar la historia del asunto para las secciones II y IV --->
		<cfif #Int(tbSolicitudes.asu_parte)# EQ 2 OR #Int(tbSolicitudes.asu_parte)# EQ 4>
			<!--- Obtener la historia del asunto --->
			<cfquery name="tbAsuntosHistoria" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM (movimientos_asunto
				LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave)
				LEFT JOIN sesiones ON movimientos_asunto.ssn_id = sesiones.ssn_id
				WHERE sol_id = #tbSolicitudes.sol_id#
				AND asu_reunion = 'CTIC'
				AND ssn_clave = 1
				AND movimientos_asunto.ssn_id < #vActa# <!--- Solo sesiones anteriores --->
				ORDER BY movimientos_asunto.ssn_id
			</cfquery>
			<cfloop query="tbAsuntosHistoria">
				<tr>
					<td colspan="2">ACTA #tbAsuntosHistoria.ssn_id#</td>
					<td>DEL #FechaCompleta(tbAsuntosHistoria.ssn_fecha)#</td>
				</tr>
				<tr>
					<td colspan="2"></td>
					<td>#tbAsuntosHistoria.dec_descrip#</td>
				</tr>
			</cfloop>
			<tr>
				<td colspan="2">ACTA #vActa#</td>
				<td>DEL #FechaCompleta(tbSesiones.ssn_fecha)#</td>
			</tr>
		</cfif>
		<!--- Recomendación/Decisión --->
		<cfif #Int(tbSolicitudes.asu_parte)# NEQ 5 AND #Int(tbSolicitudes.asu_parte)# NEQ 6>
			<cfif #vTipo# IS 'REC'>
				<!--- Obtener el registro de la CAAA --->
				<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_asunto
					INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CAAA'
				</cfquery>
				<tr>
					<td colspan="2"></td>
					<td>RECOMENDACI&Oacute;N: #tbAsuntosCAAA.dec_descrip#</td>
				</tr>
			<cfelseif #vTipo# IS 'ACTA'>
				<!--- Obtener el registro de la CTIC --->
				<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_asunto
					INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CTIC'
				</cfquery>
				<tr>
					<td colspan="2"></td>
					<td>DECISI&Oacute;N: #tbAsuntosCTIC.dec_descrip#</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="2"></td>
					<td>RECOMENDACI&Oacute;N:</td>
				</tr>
			</cfif>
		</cfif>
		<!--- División --->
		<tr><td colspan="3" height="10"></td></tr>
	</cfoutput>
</cffunction>