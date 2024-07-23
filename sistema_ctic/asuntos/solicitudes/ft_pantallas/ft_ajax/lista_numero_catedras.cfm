<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 26/08/2015 --->
<!--- FECHA ULTIMA MOD.: 04/10/2022 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR EL NÚMERO DE CÁTEDRAS CONACyT DEL ACADÉMICO--->

	<!--- Verificar si los campos relacionados ya tienen un valor --->
	<cfset vFechas_COD = ''>
    <cfset vDepIdCod = ''>
	<cfset vFechas_COD_ini = ''>
	<cfset vFechas_COD_fin = ''>
	<cfset vCcnIdCod = ''>
    <cfset vContratos_COD = ''>
    <cfset vContratos_CODn = ''>
	<cfset vCuentaCatedras = 0>
	<cfset vNoContratos = 0>
    <cfset vNoContratosDiasSuma = 0>

	<!--- Obtener datos del catálogo de movimientos --->
    <cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM catalogo_movimiento 
        WHERE mov_clave = #vFt#
    </cfquery>
	<cfif #vTipoComando# EQ 'NUEVO' OR #vTipoComando# EQ 'EDITA'>
        <!--- Selecciona los contratos anteriores --->
        <cfquery name="tbMovimientosCatedras" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE acd_id = #vIdAcad#
            AND asu_reunion = 'CTIC'
            AND mov_clave = 44
            AND dec_super = 'AP'
            <!--- AND SUBSTRING(dep_clave,1,4) = '#MID(vDepClave,1,4)#' SE ELIMINA, YA QUE LAS CÁTEDRAS SE CONTABILIZAN EN CUALQUIER ENTIDAD 04/10/2022 --->
            ORDER BY mov_fecha_inicio, mov_clave DESC
        </cfquery>

        <!--- Carga los contratos anteriores de la misma cantagorí­a y nivel --->
        <cfloop query="tbMovimientosCatedras">
            <cfset vNoContratosDiasSuma =  vNoContratosDiasSuma + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
            <cfset vFechas_COD_fin = #tbMovimientosCatedras.mov_fecha_final# + 1>
            <cfset vDepIdCod = #tbMovimientosCatedras.dep_clave#>
            <cfset vCcnIdCod = #tbMovimientosCatedras.mov_cn_clave#>
			<cfset vCuentaCatedras = #vCuentaCatedras# + 1>
			<cfset vFechas_COD = "#vFechas_COD##LsDateFormat(tbMovimientosCatedras.mov_fecha_inicio, 'dd/mm/yyyy')#">
			<cfif #vCuentaCatedras# LT #tbMovimientosCatedras.RecordCount#>
				<cfset vFechas_COD = "#vFechas_COD#, ">
			</cfif>
        </cfloop>

		<cfset vContratos_CODn = LsNumberFormat(#vCuentaCatedras#,'99')>
	<cfelse>
    	<cfif #vCampoPos17# EQ ''>
			<cfset vNoContratosDiasSuma = 0>
		<cfelse>
			<cfset vNoContratosDiasSuma = #vCampoPos17#>
        </cfif>
	</cfif>

	<!--- Mostrar los controles relacionados --->
	<cfoutput>
		<table width="100%" border="0">
	        <tr>
	            <td colspan="2">
	                <span class="Sans9GrNe">#ctMovimiento.mov_pos20#</span>
	                <input name="pos20" id="pos20_s" type="radio" value="Si" <cfif #vNoContratosDiasSuma# GT 0>checked</cfif> disabled><span class="Sans9GrNe"> S&iacute;</span>
	                <input name="pos20" id="pos20_n" type="radio" value="No" <cfif #vNoContratosDiasSuma# EQ 0>checked</cfif> disabled><span class="Sans9GrNe"> No</span>
	            </td>
	        </tr>

	        <!--- Si el conteo regresó algún valor, mostrar los datos correspondientes --->
	        <cfif #vNoContratosDiasSuma# GT 0>
		        <tr>
		            <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
		            <td width="80%">
						<cfif #vTipoComando# IS 'IMPRIME'>
							<span class="Sans9Gr">#LsNumberFormat(vCampoPos17,'99')#</span><!--- DATO QUE SE UTILIZABA PARA IMPRIMIR--->
						<cfelseif #vTipoComando# IS 'CONSULTA'>
							<input name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="3" value="#LsNumberFormat(vCampoPos17,'99')#" disabled>
						<cfelse>
							<input name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="3" value="#Trim(vContratos_CODn)#" disabled>
						</cfif>
			        </td>
		        </tr>
		        <tr>
		            <td valign="top"><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o# </span></td>
		            <td>
						<cfif #vTipoComando# IS 'IMPRIME'>
							<span class="Sans9Gr">#vCampoPos12_o#</span><!--- SE AGREGÓ ESTE CAMBIO PARA IMPRIMIR FT ORIGINAL--->
						<cfelseif #vTipoComando# IS 'CONSULTA'>
							<textarea name="pos12_o" id="pos12_o" class="datos100" rows="2" disabled>#vCampoPos12_o#</textarea>
						<cfelse>
							<textarea name="pos12_o" id="pos12_o" class="datos100" rows="2" disabled>#vFechas_COD#</textarea>
						</cfif>
					</td>
		        </tr>
			</cfif>
		</table>
		<!--- HOLA #vNoContratosDiasSuma#, #tbMovimientosCatedras.RecordCount#, #vIdAcad#, #vCcnActual#, #Trim(vNoPlaza)# --->
	</cfoutput>
