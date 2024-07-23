<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 08/02/2023 --->
<!--- FECHA ÚLTIMA MOD.: 09/02/2023 --->
<!--- INCLUDE CON LA TABLA CON LA RELACIÓN DE ESTÍMULOS RECURSOS DE REVISIÓN PARA LA SESIÓN VIGENTE --->


			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfloop from="1" to="15" index="I">&nbsp;</cfloop></td>
					<td><cfloop from="1" to="30" index="I">&nbsp;</cfloop></td>
					<td><cfloop from="1" to="35" index="I">&nbsp;</cfloop></td>
					<td><cfloop from="1" to="80" index="I">&nbsp;</cfloop></td>
					<td><cfloop from="1" to="80" index="I">&nbsp;</cfloop></td>
					<td><cfloop from="1" to="60" index="I">&nbsp;</cfloop></td>
					<td <cfif #tbRegistros.orden_samaa# EQ '3'>colspan="2"</cfif>><cfloop from="1" to="60" index="I">&nbsp;</cfloop></td>
					<cfif #tbRegistros.orden_samaa# NEQ '3'>
						<td><cfloop from="1" to="30" index="I">&nbsp;</cfloop></td>
					</cfif>
					<td><cfloop from="1" to="50" index="I">&nbsp;</cfloop></td>                    
				</tr>
			</table>
			<table class="tbBorde" border="0" cellspacing="0" cellpadding="0">
				<tr class="tbLineaEncabeza">
					<td class="tbLineaEncabezaDer"><span class="XlsTablaContenidoEncabeza">No.</span></td>
					<td class="tbLineaEncabeza"><span class="XlsTablaContenidoEncabeza">DEP</span></td>
					<td class="tbLineaEncabeza"><span class="XlsTablaContenidoEncabeza">GRADO</span></td>
					<td class="tbLineaEncabeza"><span class="XlsTablaContenidoEncabeza">NOMBRE</span></td>
					<td class="tbLineaEncabeza"><span class="XlsTablaContenidoEncabeza">APELLIDOS</span></td>
					<td class="tbLineaEncabeza"><span class="XlsTablaContenidoEncabeza">RFC</span></td>
					<td class="tbLineaEncabeza" <cfif #tbRegistros.orden_samaa# EQ '3'>colspan="2"</cfif>><span class="XlsTablaContenidoEncabeza">CCyN</span></td>
            		<td class="tbLineaEncabeza" style="text-align:center;" width="100px"><span class="XlsTablaContenidoEncabeza">DICTAMEN<br>ANTERIOR</span></td>
            		<td class="tbLineaEncabeza" style="text-align:center;" width="100px"><span class="XlsTablaContenidoEncabeza">DICTAMEN<br>ACTUAL</span></td>
					<td class="tbLineaEncabeza" style="text-align:center;" width="200px"><span class="XlsTablaContenidoEncabeza">No. DE OFICIO</span></td>                    
				</tr>
				<cfoutput query="tbRegistros">
                    <tr>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#vCuentaRegEstAcd#</span></td>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#dep_siglas#</span></td>
                        <td class="tbLineaDerecha">
							<span class="XlsTablaContenido">
								<cfif FIND('LIC.',#acd_prefijo#) OR FIND('ING.',#acd_prefijo#)>
									#MID(acd_prefijo,1,4)#
								<cfelse>#acd_prefijo#</cfif>
							</span>
						</td>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#acd_nombres#</span></td>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#nombre_completo_pm#</span></td>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#acd_rfc#</span></td>
                        <td class="tbLineaDerecha"><span class="XlsTablaContenido">#cn_siglas#</span></td>
	                    <td class="tbLineaDerecha" style="text-align:center;"><span class="XlsTablaContenido">#pride_nivel_ant#</span></td>
	                    <td class="tbLineaDerecha" style="text-align:center;"><span class="XlsTablaContenido">#pride_nivel#<cfif #propuesto_pride_d# EQ 1>*</cfif></span></td>                        
                        <td class="tbLineaAmbos" style="text-align:center;"><span class="XlsTablaContenido">#estimulo_oficio#</span></td>                    
                    </tr>
					<cfset vCuentaRegEstAcd = #vCuentaRegEstAcd# + 1>
				</cfoutput>
			</table>

			<cfif #tbRegistros.orden_samaa# EQ 'true'>
                <cfquery name="tbRegPropuesto" dbtype="query">
					SELECT COUNT(*) AS vCuenta 
					FROM tbRegistros
					WHERE propuesto_pride_d = 1
				</cfquery>
                <cfif #tbRegPropuesto.vCuenta# GT 0>
		            <br /><span class="PiePaginaEstDgapa">C* Propuesto para nivel D</span>
				</cfif>
			</cfif>

			<!--- Pie de página --->
			<cfif #vFirmaCoord# EQ 1>
                <cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
                    SELECT caa_firma FROM academicos_cargos
                    WHERE adm_clave = 84
                    AND caa_status = 'A'
                </cfquery>
                <div align="center">
                    <span class="TablaEncabeza">
                        <cfoutput>#tbAcademicosCargos.caa_firma#</cfoutput><br />
                        Presidente del Consejo Técnico de la Investigación Científica
                    </span>
                </div><br /><br />
            </cfif>
            <cfoutput>
            <table width="100%">
                <tr>
                    <td colspan="3" align="left" class="XlsPiePagina" width="30%">Acta #vpSsnId# WL/#Session.SiglasStCtic#/stc</td>
                    <td colspan="3" align="center" class="XlsPiePagina" width="40%">#FechaCompleta(tbSesionesCtic.ssn_fecha)#</td>
                    <td colspan="3" align="right" class="XlsPiePagina" width="30%"></td>
                </tr>
            </table>
            </cfoutput>
            <table width="100%">
                <tr>
                    <td colspan="9" align="left" class="XlsPiePagina" width="30%"></td>
                </tr>
            </table>
