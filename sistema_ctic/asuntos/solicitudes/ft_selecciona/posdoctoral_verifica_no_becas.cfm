<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/08/2015 --->
<!--- FECHA ULTIMA MOD.: 29/06/2016 --->
<!--- AJAX que permite identificar si el solicitante a beca posdoctoral DGAPA NO CUENTA CON BECA Y RENOVACIÓN DE BECA o verifica que no se duplique la RENOVACIÓN --->

<cfparam name="vIdAcad" default=0>

<cfif #vIdAcad# GT 0>
    <cfquery name="tbMovimientosBecas" datasource="#vOrigenDatosSAMAA#">
        SELECT C1.mov_titulo, T1.mov_fecha_inicio, T1.mov_fecha_final, T2.ssn_id, C3.dep_siglas, C2.dec_super, C2.dec_descrip, T1.mov_cancelado
        FROM (((movimientos AS T1
        LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
        LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id) 
        LEFT JOIN catalogo_decision AS C2 ON T2.dec_clave = C2.dec_clave)
        LEFT JOIN catalogo_dependencia AS C3 ON T1.dep_clave = C3.dep_clave
        WHERE T1.acd_id = #vIdAcad#
		<cfif #vpFt# EQ 38>
	        AND (T1.mov_clave = 38 OR T1.mov_clave = 39)
	        AND (C2.dec_super = 'AP' OR C2.dec_super = 'CO') <!--- Asuntos aprobados --->
		<cfelseif #vpFt# EQ 39>
	        AND T1.mov_clave = 39
			AND C2.dec_super = 'AP'            
		</cfif>
        AND T2.asu_reunion = 'CTIC'
        AND  (T1.mov_cancelado = 0 OR T1.mov_cancelado IS NULL)
        ORDER BY T1.mov_fecha_inicio, T1.sol_id DESC
    </cfquery>
    
    <cfif #tbMovimientosBecas.RecordCount# GTE 1>
		<br />
		<hr /> 
    	<table width="85%">
			<tr>
				<td colspan="5">
					<cfif #vpFt# EQ 38>
                        <span class="Sans10ViNe">NO SE PUEDE ASIGNAR AL SOLICITANTE UNA NUEVA BECA POSDOCTORAL YA QUE CUENTA CON DOS AÑOS DE BECA CONCLUIDAS EN TIEMPO Y FORMA.</span>
                        <br />
                        <span class="Sans10Vi">(Reglas de Operación del Programa de Becas Posdoctorales UNAM 2015, inciso V numeral 2)</span>
					<cfelseif #vpFt# EQ 39>
                        <span class="Sans10ViNe">EL BECARIO YA CUENTA CON RENOVACIÓN DE BECA.</span>
					</cfif>
				</td>
			</tr>
            <tr>
                <td><span class="Sans10NeNe">Entidad</span></td>
                <td><span class="Sans10NeNe">Solicitud</span></td>
                <td><span class="Sans10NeNe">Fechas</span></td>
                <td><span class="Sans10NeNe">Sesión CTIC</span></td>
                <td><span class="Sans10NeNe">Decisión CTIC</span></td>
            </tr>
			<cfoutput query="tbMovimientosBecas">
				<tr>
					<td><span class="Sans10Ne">#dep_siglas#</span></td>
					<td><span class="Sans10Ne">#mov_titulo#</span></td>
					<td><span class="Sans10Ne">#LsDateFormat(mov_fecha_inicio,'dd/mm/yyyy')# - #LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#</span></td>
					<td><span class="Sans10Ne">#ssn_id#</span></td>
					<td title="#dec_descrip#">
						<span class="Sans10Ne">#dec_super#</span>
						<cfif #mov_cancelado# EQ 1><span class="Sans10Vi">CANCELADO</span></cfif>
					</td>
				</tr>
            </cfoutput>
		</table>
    </cfif>
	<input type="hidden" name="CuentaRegistrosBecas" id="CuentaRegistrosBecas" value="<cfoutput>#tbMovimientosBecas.RecordCount#</cfoutput>" />
</cfif>