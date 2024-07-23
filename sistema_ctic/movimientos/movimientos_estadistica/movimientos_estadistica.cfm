<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 11/01/2017 --->
<!--- FECHA ÚLTIMA MOD.: 13/03/2024--->

<!--- Obtener la lista de movimientos disponibles (CATÁLOGOS LOCAL SAMAA) --->
<cfquery name="ctMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
	WHERE mov_status = 1 
	ORDER BY mov_titulo
</cfquery>

<div align="center">
	
	<cfif #vCnClase# EQ 'INV'><span class="Sans9GrNe">Investigadores</span><cfelseif #vCnClase# EQ 'TEC'><span class="Sans9GrNe">Técnicos académicos</span></cfif>
    <table width="80%">
        <tr bgcolor="#CCCCCC">
            <td width="70%" height="18px"><span class="Sans9GrNe">MOVIMIENTO</span></td>
            <td width="10%" align="center"><span class="Sans9GrNe">NÚMERO</span></td>
			<cfif #Session.sTipoSistema# IS 'stctic'>
	            <td width="10%" align="center"><span class="Sans9GrNe">DELAGADOS A CI</span></td>
    	        <td width="10%" align="center"><span class="Sans9GrNe">SUJETOS A DEC. CTIC</span></td>
			</cfif>
        </tr>

        <cfoutput query="ctMovimientos">
			<cfset vMovClave = #mov_clave#>
			<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	            <cfif #vMovClave# EQ 31>
                    SELECT *
                    FROM movimientos_correccion AS T1
                    LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id  AND T2.asu_reunion = 'CTIC'
                    LEFT JOIN sesiones AS T3 ON T2.ssn_id = T3.ssn_id AND YEAR(T3.ssn_fecha) = #vAnio# AND ssn_clave = 1
                    WHERE YEAR(T3.ssn_fecha) = #vAnio#
<!---
					<cfif #Session.sTipoSistema# IS 'sic'>
                    	AND T1.dep_clave = '#Session.sIdDep#'
					</cfif>
--->
				<cfelse>
                    SELECT *
                    FROM movimientos AS T1
                    LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id  AND T2.asu_reunion = 'CTIC'
                    LEFT JOIN sesiones AS T3 ON T2.ssn_id = T3.ssn_id AND YEAR(T3.ssn_fecha) = #vAnio# AND ssn_clave = 1
					LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C1 ON T1.cn_clave = C1.cn_clave
                    WHERE T1.mov_clave = #vMovClave#
                    AND YEAR(T3.ssn_fecha) = #vAnio#
					<cfif #vCnClase# NEQ ''>
						AND C1.cn_clase = '#vCnClase#'
					</cfif> 					
                    <cfif #vMovClave# EQ 14>
                        AND baja_clave = 1 AND con_clave = 6
					<cfelse>
						AND T2.asu_parte NOT LIKE '4%'
						AND T2.asu_parte NOT LIKE '2%'
                    </cfif>
					<cfif #Session.sTipoSistema# IS 'sic'>
						AND T1.dep_clave = '#Session.sIdDep#'
					</cfif>                    
				</cfif>
			</cfquery>

			<cfquery name="tbMovimientosTot" dbtype="query">
            	SELECT COUNT(*) AS vCuenta
                FROM tbMovimientos
            </cfquery>

			<cfif #Session.sTipoSistema# IS 'stctic'>
                <cfquery name="tbMovimientosCi" dbtype="query">
                    SELECT COUNT(*) AS vCuenta
                    FROM tbMovimientos
                    WHERE asu_parte = 1
                </cfquery>
                
                <cfquery name="tbMovimientosCtic" dbtype="query">
                    SELECT COUNT(*) AS vCuenta
                    FROM tbMovimientos
                    WHERE asu_parte = 3
                </cfquery>
			</cfif>
			<tr>
                <td>
                	<span class="Sans9Gr">
		                <cfif #vMovClave# EQ 14>
                        	RENUNCIA A BECA POSDOCTORAL
                        <cfelse>
							#UCASE(mov_titulo)#<cfif #LEN(mov_clase)# GT 0>#mov_clase#</cfif>
						</cfif>
					</span>
				</td>
                <td align="center"><span class="Sans9Gr">#tbMovimientosTot.vCuenta#</span></td>
				<cfif #Session.sTipoSistema# IS 'stctic'>
                    <td align="center"><span class="Sans9Gr">#tbMovimientosCi.vCuenta#</span></td>                
                    <td align="center"><span class="Sans9Gr">#tbMovimientosCtic.vCuenta#</span></td>
				</cfif>
            </tr>
			<cfif #vMovClave# EQ 10>
                <cfquery name="tbMovimientosTitC" dbtype="query">
                    SELECT COUNT(*) AS vCuenta
                    FROM tbMovimientos
                    WHERE mov_cn_clave = 'I6696'
				</cfquery>
                <tr>
                    <td align="right">
                        <span class="Sans9Gr">PROMOCIÓN A INVESTIGADOR TUTLAR C</span>
                    </td>
                    <td align="center"><span class="Sans9Gr">#tbMovimientosTitC.vCuenta#</span></td>
                    <td align="center">&nbsp;</td>                
                    <td align="center">&nbsp;</td>
                </tr>
			</cfif>
        </cfoutput>
    </table>
</div>