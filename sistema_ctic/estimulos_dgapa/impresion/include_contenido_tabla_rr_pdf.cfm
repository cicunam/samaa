<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 08/02/2023 --->
<!--- FECHA ÚLTIMA MOD.: 09/02/2023 --->
<!--- INCLUDE CON LA TABLA CON LA RELACIÓN DE ESTÍMULOS PARA LA SESIÓN VIGENTE --->


			<table width="100%" class="tbBorde" border="0" cellspacing="0" cellpadding="0">
				<tr class="tbLineaEncabeza">
					<td class="tbLineaEncabezaDer" width="4%"><span class="TablaPdfEstDgapa">No.</span></td>
					<td class="tbLineaEncabeza" width="6%"><span class="TablaPdfEstDgapa">DEP</span></td>
					<td class="tbLineaEncabeza" width="7%"><span class="TablaPdfEstDgapa">GRADO</span></td>
					<td class="tbLineaEncabeza" width="15%"><span class="TablaPdfEstDgapa">NOMBRE</span></td>
					<td class="tbLineaEncabeza" width="18%"><span class="TablaPdfEstDgapa">APELLIDOS</span></td>
					<td class="tbLineaEncabeza" width="13%"><span class="TablaPdfEstDgapa">RFC</span></td>
					<td class="tbLineaEncabeza" width="13%"><span class="TablaPdfEstDgapa">CCyN</span></td>
            		<td class="tbLineaEncabeza" style="text-align:center;" width="7%"><span class="TablaPdfEstDgapa">DICTAMEN<br>ANTERIOR</span></td>
            		<td class="tbLineaEncabeza" style="text-align:center;" width="7%"><span class="TablaPdfEstDgapa">DICTAMEN<br>ACTUAL</span></td>                    
					<td class="tbLineaEncabeza" style="text-align:center;" width="10%"><span class="TablaPdfEstDgapa">No. DE OFICIO</span></td>                    
				</tr>
				<tr>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
            		<td class="tbLineaInicio"></td>
            		<td class="tbLineaInicio"></td>
					<td class="tbLineaInicio"></td>
				</tr>
				<cfoutput query="tbRegistros">
                    <tr>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#vCuentaRegEstAcd#</span></td>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#dep_siglas#</span></td>
                        <td class="tbLineaDerecha">
							<span class="TablaPdfEstDgapa">
								<cfif FIND('LIC.',#acd_prefijo#) OR FIND('ING.',#acd_prefijo#)>
									#MID(acd_prefijo,1,4)#
								<cfelse>#acd_prefijo#</cfif>
							</span>
						</td>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#acd_nombres#</span></td>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#nombre_completo_pm#</span></td>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#acd_rfc#</span></td>
                        <td class="tbLineaDerecha"><span class="TablaPdfEstDgapa">#cn_siglas#</span></td>
	                    <td class="tbLineaDerecha" style="text-align:center;"><span class="TablaPdfEstDgapa">#pride_nivel_ant#</span></td>
	                    <td class="tbLineaDerecha" style="text-align:center;"><span class="TablaPdfEstDgapa">#pride_nivel#<cfif #propuesto_pride_d# EQ 1>*</cfif></span></td>
                        <td class="tbLineaAmbos" style="text-align:center;"><span class="TablaPdfEstDgapa">#estimulo_oficio#</span></td>                    
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
			<cfset #vModuloImp# = 'ESTDGAPA'>
            <cfset #vTipoReporte# = 'ESTDGAPA'>
            <cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">

			<cfif #tbRegistros.orden_samaa# EQ '1'>
				<cfdocumentitem type="pagebreak" />
			<cfelse>
	            <br/><br/>
			</cfif>               