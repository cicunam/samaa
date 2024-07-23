<!--- CREADO: ARAM PICHARDO --->
<!--- CREADO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/03/2017 --->
<!--- FECHA �LTIMA MOD.: 16/05/2022 --->
<!--- AJAX PARA LISTAR LA HISTORIA DEL INFORME ANTE LAS DIFERENTES INSTANCIAS ACAD�MICO-ADMINISTRATIVAS  --->


<cfparam name="vActivaCampos" default="">
<cfparam name="vTipoAsunto" default="">
<cfif #vTipoAsunto# EQ 'MOV' OR #vTipoAsunto# EQ 'SOL'>
	<cfset vRegistroId = #vSolMovId#>
<cfelseif  #vTipoAsunto# EQ 'INF'>
	<cfset vRegistroId = #vInformeAnualId#>
</cfif>

<!---
<cfoutput>#vTipoAsunto#</cfoutput>
--->

<!------------------------------------------------------->
<!---Seleccionar los registros de historia del asunto --->
<!------------------------------------------------------->
<cfquery name="tbAsunto" datasource="#vOrigenDatosSAMAA#">
	<cfif #vTipoAsunto# EQ 'MOV' OR #vTipoAsunto# EQ 'SOL'>
		SELECT 
        id, ssn_id, T1.asu_reunion AS reunion, asu_numero, dec_descrip, T1.asu_comentario AS comentario, T1.asu_oficio AS oficio
		FROM movimientos_asunto AS T1
        LEFT JOIN catalogo_decision AS C1 ON T1.dec_clave = C1.dec_clave
		WHERE sol_id = #vSolMovId#
        ORDER BY ssn_id, asu_reunion
	<cfelseif  #vTipoAsunto# EQ 'INF'>
        SELECT 
        id, ssn_id, T1.informe_reunion AS reunion, asu_numero, dec_descrip, T1.comentario_texto AS comentario, T1.informe_oficio AS oficio
        FROM movimientos_informes_asunto AS T1
        LEFT JOIN catalogo_decision AS C1 ON T1.dec_clave = C1.dec_clave
        WHERE informe_anual_id = #vInformeAnualId#
        ORDER BY ssn_id, informe_reunion
	</cfif>
</cfquery>

		<!--- JQUERY --->
		<script language="JavaScript" type="text/JavaScript">
			function fVentanaAsunto(vAsuntoId, vAsuntoReunion) {
				document.getElementById('asu_numero').value = vAsuntoId;
				document.getElementById('asu_reunion').value = vAsuntoReunion;				
				$('#divAsunto_jQuery').dialog('open');
			}
			// Ventana del di�logo (jQuery)
			$(function() {
				$('#dialog-confirm').dialog('destroy');
				$('#divAsunto_jQuery').dialog({
					autoOpen: false,
					height: '280',
					width: '650',
					modal: true,
					//title: "DETALLE DE ASUNTO",
					dialogClass: 'ui-widget',
					open: function() {
						//$('#divPunto').load('orden_dia_punto.cfm');
						$(this).load('<cfoutput>#vCarpetaRaizLogicaSistema#</cfoutput>/comun/movimientos_asunto_detalle.cfm',
							{
								vpAsuntoId:$('#asu_numero').val(),
								vpTipoAsunto:'<cfoutput>#vTipoAsunto#</cfoutput>', 
								vpRegistroId:'<cfoutput>#vRegistroId#</cfoutput>', 
								vpInformeStatus:$('#informe_status').val(), 
								vpAsuReunion:$('#asu_reunion').val()
								//vFt:'0'
							}
						);
						//alert($('#vPunto').val());
					}
				});
			});
		</script>
<!----------------------------------->
<!--- Mostrar la lista de asuntos --->
<!----------------------------------->

	<cfoutput>
        <input type="hidden" id="ssn_id" name="ssn_id" value="#tbAsunto.ssn_id#" />
        <input type="hidden" id="asu_numero" name="asu_numero" value="" />
        <input type="hidden" id="asu_reunion" name="asu_reunion" value="" />        
	</cfoutput>    
    <table width="100%" border="0" cellpadding="0" align="center">
		<tr id="lista_destinos_enc">
            <td style="width:8%;"><span class="Sans9GrNe">SESI&Oacute;N</span></td>
            <td style="width:10%;"><span class="Sans9GrNe">REUNI&Oacute;N</span></td>
            <td style="width:30%;"><span class="Sans9GrNe">RECOMENDACI&Oacute;N / DECISI&Oacute;N</span></td>
            <td style="width:%;"><span class="Sans9GrNe">COMENTARIO / OFICIO</span></td>
            <td style="width:7%;"><!-- Bot�n para eliminar el registro --></td>
        </tr>
		<tr><td colspan="5"><hr /></td>
		</tr>
        <cfoutput query="tbAsunto">
            <tr style="height:16px;">
                <td><span class="Sans9Gr">#ssn_id#</span></td>
                <td>
                    <span class="Sans9Gr">#reunion#</span>
                    <cfif #reunion# IS 'CTIC'><input id="hay_decision_CTIC" type="hidden" value="Si"></cfif>
                </td>
                <td><span class="Sans9Gr">#Trim(dec_descrip)#</span></td>
                <td><span class="Sans9Gr"><cfif #reunion# IS 'CAAA'>#UCASE(comentario)#<cfelse>#oficio#</cfif></span></td>
                <cfif #vActivaCampos# EQ 'disabled' AND #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                    <td class="NoImprimir" align="right" valign="middle">
                        <img id="#id#" src="#vCarpetaICONO#/nuevo_15.jpg" style="border:none; cursor:pointer;" title="Editar" onclick="fVentanaAsunto(#id#, '#reunion#');">
                        <img id="#id#" src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar" onclick="fVentanaAsunto(#id#, '#reunion#');">
                    </td>
                </cfif>
            </tr>
        </cfoutput>
        <!-- Bot�n que habilita el formulario para agregar asuntos -->
        <cfif #vActivaCampos# EQ 'disabled' AND #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LTE 1>
            <tr><td colspan="5" align="center" class="NoImprimir"><div class="linea_gris"></div></td></tr>
            <tr id="cmd_agregar_asunto">
                <cfoutput>        
                    <td colspan="4" class="NoImprimir"><span class="AgregarRegTexto"><em>AGREGAR NUEVO ASUNTO EN ACTA...</em></span></td>
                    <td align="right">
                        <img id="0" src="#vCarpetaICONO#/agregar_15.jpg" style="border:none; cursor:pointer;" title="Agregar" onclick="fVentanaAsunto(0);">
                    </td>
                </cfoutput>
            </tr>
        </cfif>	
    </table>
<!---    
<cfif #tbAsunto.RecordCount# GT 0>    
</cfif>
--->