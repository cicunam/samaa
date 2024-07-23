<!--- CREADO: ARAM PICHARDO --->
<!--- CREADO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 23/03/2017 --->
<!--- AJAX PARA LISTAR LA HISTORIA DEL INFORME ANTE LAS DIFERENTES INSTANCIAS ACADÉMICO-ADMINISTRATIVAS  --->

<cfparam name="vActivaCampos" default="">

<!------------------------------------------------------->
<!---Seleccionar los registros de historia del asunto --->
<!------------------------------------------------------->
<cfquery name="tbInformeAsunto" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_informes_asunto AS T1
	LEFT JOIN catalogo_decision AS C1 ON T1.dec_clave = C1.dec_clave
	WHERE informe_anual_id = #vInformeAnualId#
	ORDER BY ssn_id, informe_reunion
</cfquery>

<!----------------------------------->
<!--- Mostrar la lista de asuntos --->
<!----------------------------------->
<table width="100%" border="0" cellpadding="0" align="center">
	<tr id="lista_destinos_enc">
		<td style="width:8%;"><span class="Sans9GrNe">SESI&Oacute;N</span><input id="vSelAsuntoId" type="hidden" value="" /></td>
		<td style="width:10%;"><span class="Sans9GrNe">REUNI&Oacute;N</span></td>
		<td style="width:30%;"><span class="Sans9GrNe">RECOMENDACI&Oacute;N / DECISI&Oacute;N</span></td>
		<td style="width:%;"><span class="Sans9GrNe">COMENTARIO / OFICIO</span></td>
		<td style="width:7%;"><!-- Botón para eliminar el registro --></td>
	</tr>
	<cfoutput query="tbInformeAsunto">
		<tr>
			<td><span class="Sans9Gr">#ssn_id#</span></td>
			<td>
				<span class="Sans9Gr">#informe_reunion#</span>
				<cfif #informe_reunion# IS 'CTIC'><input id="hay_decision_CTIC" type="hidden" value="Si"></cfif>
			</td>
			<td><span class="Sans9Gr">#Trim(dec_descrip)#</span></td>
			<td><span class="Sans9Gr"><cfif #informe_reunion# IS 'CAAA'>#UCASE(comentario_texto)#<cfelse>#informe_oficio#</cfif></span></td>
			<cfif #vActivaCampos# NEQ 'disabled' AND #Session.sTipoSistema# IS 'stctic'>
                <td class="NoImprimir" align="right" valign="middle">
                    <img id="#id#" src="#vCarpetaICONO#/nuevo_15.jpg" style="border:none; cursor:pointer;" title="Editar" onclick="fVentanaAsunto(#id#);">
					<img id="#id#" src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar" onclick="fVentanaAsunto(#id#);">
                </td>
			</cfif>
		</tr>
	</cfoutput>
	<!-- Botón que habilita el formulario para agregar asuntos -->
	<cfif #vActivaCampos# EQ '' AND #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LTE 1>
		<tr><td colspan="5" align="center" class="NoImprimir"><div class="linea_gris"></div></td></tr>
		<tr id="cmd_agregar_asunto">
			<cfoutput>        
                <td colspan="4" class="NoImprimir"><span class="AgregarRegTexto"><em>AGREGAR NUEVA REUNIÓN...</em></span></td>
                <td align="right">
					<img id="0" src="#vCarpetaICONO#/agregar_15.jpg" style="border:none; cursor:pointer;" title="Agregar" onclick="fVentanaAsunto(0);">
                </td>
            </cfoutput>
		</tr>
	</cfif>	
</table>