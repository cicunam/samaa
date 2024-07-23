<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 10/06/2010--->
<!--- AJAX PARA GENERAR EL FORMULARIO PARA AGREGAR/EDITAR LA LISTA DE ASUNTOS --->
<!------------------>
<!--- Parámetros --->
<!------------------>
<cfparam name="vSesion" default="">
<cfparam name="vReunion" default="CAAA">
<cfparam name="vDecision" default="">
<cfparam name="vNotas" default="">
<cfparam name="vOficio" default="">
<!------------------------------------------------>
<!--- Obtener datos del catálogo de decisiones --->
<!------------------------------------------------>
<cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_decision ORDER BY dec_clave
</cfquery>
<!---------------------------->
<!--- Formulario de captura--->
<!---------------------------->
<table>
	<!-- Sesión -->
	<tr>
		<td width="130" class="Sans9GrNe">Sesi&oacute;n</td>
		<td><input id="frm_ssn_id" name="frm_ssn_id" value="<cfoutput>#vSesion#</cfoutput>" type="text" class="datos" size="5" maxlength="5"></td>
	</tr>
	<!-- Reunión -->
	<tr>
		<td class="Sans9GrNe">Reuni&oacute;n</td>
		<td>
			<select id="frm_asu_reunion" name="frm_asu_reunion" class="datos" onchange="if (this.value == 'CTIC') {hidden_row = 'dynamic_row_notas'; visible_row= 'dynamic_row_oficio'} else {hidden_row = 'dynamic_row_oficio'; visible_row= 'dynamic_row_notas'}; document.getElementById(hidden_row).style.display ='none'; document.getElementById(visible_row).style.display ='';">
				<option value="CAAA" <cfif #vReunion# IS 'CAAA'>selected</cfif>>CAAA</option>
				<option value="CTIC" <cfif #vReunion# IS 'CTIC'>selected</cfif>>CTIC</option>
			</select>
		</td>
	</tr>
	<!-- Reunión -->
	<tr>
		<td class="Sans9GrNe">Decisi&oacute;n</td>
		<td>
			<select id="frm_dec_clave" name="frm_dec_clave" class="datos100">
				<cfoutput query="ctDecision">
					<option value="#ctDecision.dec_clave#" <cfif #vDecision# IS #ctDecision.dec_clave#>selected</cfif>>#ctDecision.dec_descrip#</option>
				</cfoutput>	
			</select>
		</td>
	</tr>
	<!-- Comentario de la CAAA -->
	<tr id="dynamic_row_notas" <cfif #vReunion# IS NOT 'CAAA'>style="display:none;"</cfif>>
		<td width="130" class="Sans9GrNe">Comentario</td>
		<td><input id="frm_asu_notas" name="frm_asu_notas" value="<cfoutput>#vNotas#</cfoutput>" type="text" class="datos100" maxlength="254"></td>
	</tr>
	<!-- Númeor de Oficio -->
	<tr id="dynamic_row_oficio" <cfif #vReunion# IS NOT 'CTIC'>style="display:none;"</cfif>>
		<td width="130" class="Sans9GrNe">Oficio</td>
		<td><input id="frm_asu_oficio" name="frm_asu_oficio" value="<cfoutput>#vOficio#</cfoutput>" type="text" class="datos" size="20" maxlength="60"></td>
	</tr>
	<!-- Separador -->
	<tr><td colspan="2" align="center"><hr></td></tr>
	<!-- Botones -->
	<tr>
		<td colspan="2" align="center">
			<input type="button" class="botonesStandar" value="ACEPTAR" onclick="<cfif #IsDefined('vKey')# AND #vKey# IS NOT ''>fHistoriaAsunto('EDITA','<cfoutput>#vKey#</cfoutput>')<cfelse>fHistoriaAsunto('INSERTA')</cfif>; fMostrarFormularioAsuntos(false);">
			<input type="button" class="botonesStandar" value="CANCELAR" onclick="fMostrarFormularioAsuntos(false);">
		</td>
	</tr>
</table>
