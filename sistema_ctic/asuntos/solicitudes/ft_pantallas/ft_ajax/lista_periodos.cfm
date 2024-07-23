<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 05/05/2009--->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR PERIODOS DE ANTIGÜEDAD --->

<!--- Parámetros urilizados --->
<cfparam name="vComandoAntig" default="">

	<cfif #vComandoAntig# EQ 'INSERTA'>
	    <!--- Calcular años, meses y días --->
		<cfset vF1 = #LSParseDateTime(vFechaIni)#>
		<cfset vFF = #DateAdd('d',LSParseDateTime(vFechaFin),1)#>
		<cfset vAntigAnios = #DateDiff('yyyy',#vF1#, vFF)#>
		<cfset vF2 = #DateAdd('yyyy',vAntigAnios,vF1)#>
	    <cfset vAntigMeses = #DateDiff('m',#vF2#, vFF)#>
		<cfset vF3 = #DateAdd('m',vAntigMeses,vF2)#>			
	    <cfset vAntigDias = #DateDiff('d',#vF3#, vFF)#>
	    <!--- Crear el registro correspondiente --->
	    <cfquery datasource='#vOrigenDatosSAMAA#'>
            INSERT INTO movimientos_antiguedad (sol_id, acd_id, antig_institucion, antig_fecha_inicio, antig_fecha_final, antig_anios, antig_meses, antig_dias)
            VALUES (
              <cfif #vIdSol# NEQ "">
                #vIdSol#<cfelse>NULL</cfif>
                ,
              <cfif #vIdAcad# NEQ "">
                #vIdAcad#<cfelse>NULL</cfif>
                ,
              <cfif #vInstitucion# NEQ "">
                '#Ucase(vInstitucion)#'<cfelse>NULL</cfif>
                ,
              <cfif #vFechaIni# NEQ "">
                '#LsDateFormat(vFechaIni,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
                ,
			  <cfif #vFechaFin# NEQ "">
                '#LsDateFormat(vFechaFin,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
                ,
              <cfif #vAntigAnios# NEQ "">
                #vAntigAnios#<cfelse>NULL</cfif>
                ,
              <cfif #vAntigMeses# NEQ "">
                #vAntigMeses#<cfelse>NULL</cfif>
                ,
              <cfif #vAntigDias# NEQ "">
                #vAntigDias#<cfelse>NULL</cfif>
            )
        </cfquery>
    </cfif>
    
	<!--- Eliminar un registro previamente capturado --->
    <cfif #vComandoAntig# EQ 'ELIMINA'>
        <cfquery datasource='#vOrigenDatosSAMAA#'>
            DELETE FROM movimientos_antiguedad WHERE (dbo.TRIM(STR(sol_id)) + dbo.TRIM(STR(acd_id)) + dbo.TRIM(antig_institucion) + CONVERT(varchar, antig_fecha_inicio, 112)) = '#vIdRegAntig#'
        </cfquery>
    </cfif>
    
	<!--- Seleccionar los periodos relacionados a la solicitud --->
    <cfquery name="tbAntiguedad" datasource='#vOrigenDatosSAMAA#'>
		SELECT * FROM movimientos_antiguedad WHERE sol_id = #vIdSol# ORDER BY antig_fecha_inicio
    </cfquery>

	<!--- Lista de periodos a reconocer --->
    <table width="100%" border="0" cellpadding="0" align="center">
      <tr id="lista_destinos_enc">
        <td><span class="Sans9GrNe">Instituci&oacute;n</span></td>
        <td><span class="Sans9GrNe">Desde</span></td>
        <td><span class="Sans9GrNe">Hasta</span></td>
        <td><span class="Sans9GrNe">A&ntilde;os</span></td>
		<td><span class="Sans9GrNe">Meses</span></td>
		<td><span class="Sans9GrNe">D&iacute;as</span></td>
		<td>&nbsp;</td>
      </tr>
      <cfoutput query="tbAntiguedad">
	      <!--<tr><td colspan="5"><div class="linea_gris"></td></tr>-->
	      <tr>
	        <td><span class="Sans9Gr">#tbAntiguedad.antig_institucion#</span></td>
	        <td><span class="Sans9Gr">#LsDateFormat(tbAntiguedad.antig_fecha_inicio,"dd/mm/yyyy")#</span></td>
	        <td><span class="Sans9Gr">#LsDateFormat(tbAntiguedad.antig_fecha_final,"dd/mm/yyyy")#</span></td>
	        <td><span class="Sans9Gr">#tbAntiguedad.antig_anios#</span></td>
	        <td><span class="Sans9Gr">#tbAntiguedad.antig_meses#</span></td>
	        <td><span class="Sans9Gr">#tbAntiguedad.antig_dias#</span></td>
	        <td class="NoImprimir" align="right">
				<input type="button" value="X" class="botonesStandar" onclick="fAgregarAntiguedad('ELIMINA', '#tbAntiguedad.sol_id##tbAntiguedad.acd_id##tbAntiguedad.antig_institucion##LsDateFormat(tbAntiguedad.antig_fecha_inicio,"yyyymmdd")#');" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
	        </td>
	      </tr>
      </cfoutput>
    </table>

	<span class="NoImprimir"><div class="linea_gris"></span>
		
	<!--- Calcular sumatoria de años, meses y días considerando meses estándares de 30 días --->
	<cfset vTotalAnios = 0>
	<cfset vTotalMeses = 0>
	<cfset vTotalDias = 0>
	<cfloop query="tbAntiguedad">
		<cfset vTotalDias = vTotalDias + #tbAntiguedad.antig_dias#>
		<cfif vTotalDias GT 29>
			<cfset vTotalMeses = vTotalMeses + (vTotalDias \ 30)>
			<cfset vTotalDias = vTotalDias MOD 30>
		</cfif>
		<cfset vTotalMeses = vTotalMeses + #tbAntiguedad.antig_meses#>
		<cfif vTotalMeses GT 11>
			<cfset vTotalAnios = vTotalAnios + (vTotalMeses \ 12)>
			<cfset vTotalMeses = vTotalMeses MOD 12>
		</cfif>
		<cfset vTotalAnios = #vTotalAnios# + #tbAntiguedad.antig_anios#>
	</cfloop>
	
    <input type="hidden" name="antig_suma_anios" id="antig_suma_anios" value="<cfoutput>#vTotalAnios#</cfoutput>">
	<input type="hidden" name="antig_suma_meses" id="antig_suma_meses" value="<cfoutput>#vTotalMeses#</cfoutput>">
	<input type="hidden" name="antig_suma_dias" id="antig_suma_dias" value="<cfoutput>#vTotalDias#</cfoutput>">
	
	<!--- Obtener la última fecha para validar que sea anterior a la de ingreso --->
    <cfquery name="tbAntiguedad" datasource='#vOrigenDatosSAMAA#'>
		SELECT * FROM movimientos_antiguedad WHERE sol_id = #vIdSol# ORDER BY antig_fecha_final DESC
    </cfquery>

	<input type="hidden" name="antig_ultima_fecha" id="antig_ultima_fecha" value="<cfoutput>#LsDateFormat(tbAntiguedad.antig_fecha_final,'dd/mm/yyyy')#</cfoutput>">
	
	