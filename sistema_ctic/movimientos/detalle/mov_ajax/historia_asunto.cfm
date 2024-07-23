<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 26/01/2010--->
<!--- AJAX PARA LISTAR LA HISTORIA DE UN ASUNTO --->
<!---------------------------------->
<!--- Insertar un nuevo registro --->
<!---------------------------------->
<cfif #vComando# EQ 'INSERTA'>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos_asunto (sol_id, ssn_id, asu_reunion, dec_clave, asu_notas, asu_oficio, asu_editable)
		VALUES (
			<cfif #vIdSol# NEQ ''>#vIdSol#<cfelse>NULL</cfif>,
			<cfif #vSesion# NEQ ''>#vSesion#<cfelse>NULL</cfif>,
			<cfif #vReunion# NEQ ''>'#vReunion#'<cfelse>NULL</cfif>,
			<cfif #vDecision# NEQ ''>#vDecision#<cfelse>NULL</cfif>,
			<cfif #vNotas# NEQ ''>'#vNotas#'<cfelse>NULL</cfif>,
			<cfif #vOficio# NEQ ''>'#vOficio#'<cfelse>NULL</cfif>,
			1 <!--- Permitir posteriormente eliminar este registro --->
		)
	</cfquery>
</cfif>
<!------------------------------------>
<!--- Editar un registro existente --->
<!------------------------------------>
<cfif #vComando# EQ 'EDITA'>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_asunto 
		SET 
		<cfif #vSesion# NEQ ''>ssn_id = #vSesion#, </cfif>
		<cfif #vReunion# NEQ ''>asu_reunion = '#vReunion#', </cfif>
		<cfif #vDecision# NEQ ''>dec_clave = #vDecision#, </cfif>
		<cfif #vNotas# NEQ ''>asu_notas = '#vNotas#', </cfif>
		<cfif #vOficio# NEQ ''>asu_oficio = '#vOficio#', </cfif>
		asu_editable = 1
		WHERE LTRIM(RTRIM(STR(sol_id))) + LTRIM(RTRIM(STR(ssn_id))) + LTRIM(RTRIM(asu_reunion)) = '#vKey#'
	</cfquery>
</cfif>
<!---------------------------->
<!--- Eliminar un registro --->
<!---------------------------->
<cfif #vComando# EQ 'ELIMINA'>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		 DELETE FROM movimientos_asunto 
		 WHERE LTRIM(RTRIM(STR(sol_id))) + LTRIM(RTRIM(STR(ssn_id))) + LTRIM(RTRIM(asu_reunion)) = '#vKey#'
	</cfquery>
</cfif>
<!------------------------------------------------------->
<!---Seleccionar los registros de historia del asunto --->
<!------------------------------------------------------->
<cfquery name="tbMovimientosAsunto" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_asunto 
	LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
	WHERE sol_id = #vIdSol#
	ORDER BY ssn_id, asu_reunion
</cfquery>
<!----------------------------------->
<!--- Mostrar la lista de asuntos --->
<!----------------------------------->
<table width="100%" border="0" cellpadding="0" align="center">
	<tr id="lista_destinos_enc">
		<td style="width:8%;"><span class="Sans9GrNe">Sesi&oacute;n</span></td>
		<td style="width:10%;"><span class="Sans9GrNe">Reuni&oacute;n</span></td>
		<td style="width:50%;"><span class="Sans9GrNe">Rec/Dec</span></td>
		<td style="width:30%;"><span class="Sans9GrNe">Oficio/Comentario</span></td>
		<td style="width:2%;"><!-- Botón para eliminar el registro --></td>
	</tr>
	<cfoutput query="tbMovimientosAsunto">
		<tr>
			<td><span class="Sans9Gr">#tbMovimientosAsunto.ssn_id#</span></td>
			<td>
				<span class="Sans9Gr">#tbMovimientosAsunto.asu_reunion#</span>
				<cfif #tbMovimientosAsunto.asu_reunion# IS 'CTIC'><input id="hay_decision_CTIC" type="hidden" value="Si"></cfif>
			</td>
			<td><span class="Sans9Gr">#Trim(tbMovimientosAsunto.dec_descrip)#</span></td>
			<td><span class="Sans9Gr"><cfif #tbMovimientosAsunto.asu_reunion# IS 'CAAA'>#UCASE(tbMovimientosAsunto.asu_notas)#<cfelse>#tbMovimientosAsunto.asu_oficio#</cfif></span></td>
			<td class="NoImprimir" align="right">
				<cfif #vActivaCampos# IS NOT 'disabled' AND #tbMovimientosAsunto.asu_editable# EQ 1 AND #Session.sTipoSistema# IS 'stctic'>
					<input type="button" value="EDITAR" class="botonesStandar" onclick="fMostrarFormularioAsuntos(true, '#tbMovimientosAsunto.ssn_id#','#tbMovimientosAsunto.asu_reunion#','#tbMovimientosAsunto.dec_clave#','#tbMovimientosAsunto.asu_notas#','#tbMovimientosAsunto.asu_oficio#');" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
					<input type="button" value="X" class="botonesStandar" onclick="fHistoriaAsunto('ELIMINA','#Trim(tbMovimientosAsunto.sol_id) & Trim(tbMovimientosAsunto.ssn_id) & Trim(tbMovimientosAsunto.asu_reunion)#');" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
				</cfif>
	        </td>
		</tr>
	</cfoutput>
	<!-- Botón que habilita el formulario para agregar asuntos -->
	<cfif #vActivaCampos# IS NOT 'disabled' AND #Session.sTipoSistema# IS 'stctic'>
		<tr><td colspan="6" align="center" class="NoImprimir"><div class="linea_gris"></div></td></tr>
		<tr id="cmd_agregar_asunto">
			<td colspan="6" align="center" class="NoImprimir">
				<input type="button" class="botonesStandar" value="AGREGAR ASUNTO" onclick="fMostrarFormularioAsuntos(true);">
			</td>
		</tr>
	</cfif>	
</table>
