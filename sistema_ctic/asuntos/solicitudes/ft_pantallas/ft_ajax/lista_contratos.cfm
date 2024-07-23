<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 20/02/2013--->
<!--- FECHA ULTIMA MOD.: 25/03/2022 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR EL NÚMERO DE CONTRATOS PARA OBRA DETERMINADA--->

	<!--- Verificar si los campos relacionados ya tienen un valor --->
	<cfset vFechas_COD = ''>
    <cfset vDepIdCod = ''>
	<cfset vFechas_COD_ini = ''>
	<cfset vFechas_COD_fin = ''>
	<cfset vCcnIdCod = ''>
    <cfset vContratos_COD = ''>
    <cfset vContratos_CODn = ''>    
	<cfset vNoContratos = 0>
    <cfset vNoContratosDiasSuma = 0>

	<cfif #vDepClave# EQ '030101' OR #vDepClave# EQ '034201' OR #vDepClave# EQ '034301' OR #vDepClave# EQ '034401' OR #vDepClave# EQ '034501'>
		<!--- Obtener datos del catálogo de movimientos --->
        <cfquery name="tbMovCambioAdscDef" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM movimientos 
            WHERE mov_clave = 13
            AND cam_clave = 4 <!--- Se agregó la clave 4 para trasferencia de plaza por creación de Centro 07/10/2011 --->
            AND acd_id  = #vIdAcad#
            ORDER BY mov_fecha_inicio DESC
        </cfquery>
		<cfif #tbMovCambioAdscDef.recordCount# GT 0>
            <cfset vDepClaveAnt = #tbMovCambioAdscDef.dep_clave#>
        </cfif>
	<cfelse>
		<!--- Obtener datos del catálogo de movimientos --->
        <cfquery name="tbMovCambioAdscDef" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM movimientos 
            WHERE mov_clave = 13
            AND cam_clave = 4 <!--- Se agregó la clave 4 para trasferencia de plaza por creación de Centro 07/10/2011 --->
            AND acd_id  = #vIdAcad#
            ORDER BY mov_fecha_inicio DESC
        </cfquery>
		<cfif #tbMovCambioAdscDef.recordCount# GT 0>
            <cfset vDepClaveAnt = #tbMovCambioAdscDef.dep_clave#>
        </cfif>
	</cfif>	
		

	<!--- Obtener datos del catálogo de movimientos --->
    <cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
   		SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
    </cfquery>

	<!--- Selecciona los contratos anteriores --->    
    <cfquery name="tbMovimientosCOD" datasource="#vOrigenDatosSAMAA#">
	    SELECT 
        dep_clave, mov_clave, mov_cn_clave, mov_fecha_inicio, mov_fecha_final
        FROM (movimientos 
	    LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	    WHERE acd_id = #vIdAcad# 
	    AND asu_reunion = 'CTIC'
	    AND
	    ((
	    (mov_clave = 6 OR mov_clave = 37) <!--- Se agragó el movimiento 37 para ingresar los RECURSOS DE RECONISDERACIÓN --->
	    AND dec_super = 'AP'
        AND (mov_cancelado IS NULL OR mov_cancelado = 0) <!--- Omitir movimientos cancelados 25/03/2022 --->
	    AND mov_cn_clave = '#vCcnActual#'
	    AND (mov_plaza IS NULL OR dbo.TRIM(mov_plaza) = '00000-00' OR dbo.TRIM(mov_plaza) = '#Trim(vNoPlaza)#') <!--- Por alguna razón algunos números de plaza tienen un espacio al iniciar la cadema, por eso se utiliza TRIM(), 28/01/2015 las plazas 00000-00 son del subprograma de incorporación --->
	    )
	    OR 
	    (
	    mov_clave = 14
	    ))
		<cfif #vProgramaClave# GT 0>
        	AND prog_clave = #vProgramaClave# <!--- Se agregó para contar los contratos por programa --->
		<cfelse>
        	AND prog_clave IS NULL
		</cfif>        
		<!---
		<cfif #Session.sIdDep# EQ '034101'> <!--- SOLUCION TEMPORAL PARA EL CCM --->
			AND SUBSTRING(dep_clave,1,4) = '0307'
		<cfelse>
		</cfif>
		--->
		<cfif #tbMovCambioAdscDef.recordCount# EQ 0>
			<cfif #vDepClave# EQ '030101' OR #vDepClave# EQ '034201' OR #vDepClave# EQ '034301' OR #vDepClave# EQ '034401' OR #vDepClave# EQ '034501'>
				AND (SUBSTRING(dep_clave,1,4) = '#MID(vDepClave,1,4)#' OR SUBSTRING(dep_clave,1,4) = '0301') <!--- CASO PARA LA UPEID (RAI, LIIGH, C3 Y CVIcom), Se actualizó el 08/06/2016 --->
            <cfelse>
				AND SUBSTRING(dep_clave,1,4) = '#MID(vDepClave,1,4)#' <!--- PROBAR ESTA OPCION ARAM 20/06/2011, Se actualizó el 16/08/2011 para aquellas entidades que pasan de centro a instituto o cambio de nombre --->
            </cfif>
		<cfelse>
			<cfif #vDepClave# EQ '030101' OR #vDepClave# EQ '034201' OR #vDepClave# EQ '034301' OR #vDepClave# EQ '034401' OR #vDepClave# EQ '034501'>
				AND (SUBSTRING(dep_clave,1,4) = '#MID(vDepClave,1,4)#' OR SUBSTRING(dep_clave,1,4) = '0301') <!--- CASO PARA LA UPEID (RAI, LIIGH, C3 Y CVIcom), Se actualizó el 08/06/2016 --->
            <cfelse>        
				AND (SUBSTRING(dep_clave,1,4) = '#MID(vDepClave,1,4)#' OR SUBSTRING(dep_clave,1,4) = '#MID(vDepClaveAnt,1,4)#') <!---SE AGREGO OPCION ARAM 05/10/2011, 	Para aquellos académicos que tienen un cambio de adscripción definitivo a otra entidad del subsistema --->
			</cfif>                
		</cfif>
		ORDER BY mov_fecha_inicio, mov_clave DESC
    </cfquery>
		
	<!--- Carga los contratos anteriores de la misma cantagorí­a y nivel --->
    <cfloop query="tbMovimientosCOD">

			<!--- Si el movimiento es COD (6) incrementar el contador --->
			<cfif #tbMovimientosCOD.mov_clave# IS 6 OR #tbMovimientosCOD.mov_clave# IS 37>
			
				<cfif #vFechas_COD# EQ ''>
		
		            <cfset vFechas_COD = #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
			        <cfset vNoContratosDiasSuma =  #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
					<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
		            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
		            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>
		
		        <cfelse>

					<!--- <cfif (#DateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')# EQ #DateFormat(vFechas_COD_fin, 'dd/mm/yyyy')#) AND #vCcnIdCod# EQ #tbMovimientosCOD.mov_cn_clave#> ---> <!--- PRIEMRA VERSIÓN --->
					<cfif (#DateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')# LTE #DateFormat(vFechas_COD_fin, 'dd/mm/yyyy')#) AND #vCcnIdCod# EQ #tbMovimientosCOD.mov_cn_clave#> <!--- MODIFICO ARAM, 30/05/2013 --->
			            <cfset vFechas_COD = #vFechas_COD# & ", " & #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
				        <cfset vNoContratosDiasSuma =  vNoContratosDiasSuma + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
						<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
			            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
			            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>
					<cfelse>
			            <cfset vFechas_COD = #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
				        <cfset vNoContratosDiasSuma =  #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
						<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
			            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
			            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>
					</cfif>

        		</cfif>			
			<!--- Si el movimiento es BAJA (14) reiniciar el conteo --->
			<cfelse>

				<cfset vNoContratosDiasSuma = 0>
				<cfset vFechas_COD = ''>
			
			</cfif>
    
	</cfloop>
		
	<!--- Si el conteo regresó algún valor --->
	<cfif #vNoContratosDiasSuma# GT 0>
		<cfset vContratos_CODn = LsNumberFormat(vNoContratosDiasSuma / 365,'99.99')>
        <cfif #vContratos_CODn# GT #LsNumberFormat(vContratos_CODn,'99')#>
			<cfset vContratos_CODn = LsNumberFormat(vContratos_CODn + 1,'99')>
        <cfelse>
			<cfset vContratos_CODn = LsNumberFormat(vContratos_CODn,'99')>
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
							<span class="Sans9Gr"><cfif #vHistoria# IS NOT 2>#vContratos_CODn#<cfelse>#LsNumberFormat(vCampoPos17,'99')#</cfif></span><!--- DATO QUE SE UTILIZABA PARA IMPRIMIR--->
						<cfelse>
							<input name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="3" value="#Trim(vContratos_CODn)#" disabled>
						</cfif>
			        </td>
		        </tr>
		        <tr>
		            <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o# </span></td>
		            <td>
						<cfif #vTipoComando# IS 'IMPRIME'>
							<span class="Sans9Gr"><cfif #vHistoria# IS NOT 2>#vFechas_COD#<cfelse>#vCampoPos12_o#</cfif></span><!--- SE AGREGÓ ESTE CAMBIO PARA IMPRIMIR FT ORIGINAL--->
						<cfelse>
							<textarea name="pos12_o" id="pos12_o" class="datos100" rows="2" disabled>#vFechas_COD#</textarea>
						</cfif>	
					</td>
		        </tr>
			</cfif>
		</table>
		<!--- HOLA #vNoContratosDiasSuma#, #tbMovimientosCOD.RecordCount#, #vIdAcad#, #vCcnActual#, #Trim(vNoPlaza)# --->
	</cfoutput>
	

<!---

NOTA: Así estaba antes del cambio...

<!--- Verificar si los campos relacionados ya tienen un valor --->
	
	<cfset vFechas_COD = ''>
    <cfset vDepIdCod = ''>
	<cfset vFechas_COD_ini = ''>
	<cfset vFechas_COD_fin = ''>
	<cfset vCcnIdCod = ''>
    <cfset vContratos_COD = ''>
    <cfset vContratos_CODn = ''>    
	<cfset vNoContratos = 0>
    <cfset vNoContratosDiasSuma = 0>

	<!--- Obtener datos del catálogo de movimientos --->
    <cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
   		SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
    </cfquery>

	<!--- Selecciona los contratos anteriores --->    
    <cfquery name="tbMovimientosCOD" datasource="#vOrigenDatosSAMAA#">
	    SELECT * FROM (movimientos 
	    LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
	    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	    WHERE acd_id = #vIdAcad# 
	    AND mov_cn_clave = '#vCcnActual#' 
	    AND mov_clave = 6
	    AND asu_reunion = 'CTIC'
        AND (mov_plaza IS NULL OR mov_plaza = '#vNoPlaza#')
	    AND dec_super = 'AP' <!--- Asuntos aprobados --->
	    ORDER BY mov_fecha_inicio
    </cfquery>

	<!--- Carga los contratos anteriores de la misma cantagorí­a y nivel --->
    <cfloop query="tbMovimientosCOD">

        <cfif #vFechas_COD# EQ ''>

            <cfset vFechas_COD = #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
	        <cfset vNoContratosDiasSuma =  #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
			<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>

        <cfelse>

			<cfif (#DateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')# EQ #DateFormat(vFechas_COD_fin, 'dd/mm/yyyy')#) AND #vCcnIdCod# EQ #tbMovimientosCOD.mov_cn_clave#>
	            <cfset vFechas_COD = #vFechas_COD# & ", " & #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
		        <cfset vNoContratosDiasSuma =  vNoContratosDiasSuma + #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
				<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
	            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
	            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>
			<cfelse>
	            <cfset vFechas_COD = #LsDateFormat(tbMovimientosCOD.mov_fecha_inicio, 'dd/mm/yyyy')#>
		        <cfset vNoContratosDiasSuma =  #datediff('d',LsParseDateTime(mov_fecha_inicio),LsParseDateTime(mov_fecha_final))#>
				<cfset vFechas_COD_fin = #tbMovimientosCOD.mov_fecha_final# + 1>
	            <cfset vDepIdCod = #tbMovimientosCOD.dep_clave#>
	            <cfset vCcnIdCod = #tbMovimientosCOD.mov_cn_clave#>
			</cfif>

        </cfif>

    </cfloop>
    
	<cfdump var="#tbMovimientosCOD.RecordCount#">
	
	<cfif #tbMovimientosCOD.RecordCount# GT 0>
		<cfset vContratos_CODn = LsNumberFormat(vNoContratosDiasSuma / 365,'99.99')>
        <cfif #vContratos_CODn# GT #LsNumberFormat(vContratos_CODn,'99')#>
			<cfset vContratos_CODn = LsNumberFormat(vContratos_CODn + 1,'99')>
        <cfelse>
			<cfset vContratos_CODn = LsNumberFormat(vContratos_CODn,'99')>
        </cfif>
	</cfif>

	<!--- Mostrar los controles relacionados --->
	<cfoutput>
		<table width="100%" border="0">
	        <tr> 
	            <td colspan="2">
	                <span class="Sans9GrNe">#ctMovimiento.mov_pos20#</span>
	                <input name="pos20" id="pos20_s" type="radio" value="Si" <cfif #tbMovimientosCOD.RecordCount# GT 0>checked</cfif> <!---<cfif #vActivaCampos# EQ "disabled">disabled</cfif>--->disabled><span class="Sans9GrNe"> S&iacute;</span>
	                <input name="pos20" id="pos20_n" type="radio" value="No" <cfif #tbMovimientosCOD.RecordCount# EQ 0>checked</cfif> <!---<cfif #vActivaCampos# EQ "disabled">disabled</cfif>--->disabled><span class="Sans9GrNe"> No</span> 
	            </td>
	        </tr>
	        <tr> 
	            <td width="20%"><span class="Sans9GrNe">#ctMovimiento.mov_pos17#</span></td>
	            <td width="80%">
					<cfif #vTipoComando# IS 'IMPRIME'>
						<span class="Sans9Gr">#vContratos_CODn#</span>
					<cfelse>
						<input name="pos17" type="text" class="datos" id="pos17" size="3" maxlength="3" value="#Trim(vContratos_CODn)#" <!---<cfif #vActivaCampos# EQ "disabled">disabled</cfif>--->disabled>
					</cfif>
		        </td>
	        </tr>
	        <tr>
	            <td><span class="Sans9GrNe">#ctMovimiento.mov_pos12_o# </span></td>
	            <td>
					<cfif #vTipoComando# IS 'IMPRIME'>
						<span class="Sans9Gr">#vFechas_COD#</span>
					<cfelse>
						<textarea name="pos12_o" id="pos12_o" class="datos100" rows="2" <!---<cfif #vActivaCampos# EQ "disabled">disabled</cfif>--->disabled>#vFechas_COD#</textarea>
					</cfif>	
				</td>
	        </tr>
		</table>
	</cfoutput>

--->