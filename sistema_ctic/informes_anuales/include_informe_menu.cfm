<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/06/2016 --->
<!--- FECHA ÚLTIMA MOD: 27/04/2018 --->
 

		<script language="JavaScript" type="text/JavaScript">
			function fEnviarComando(vTipoComando)
			{
				if (vTipoComando == 'EDT') window.location = 'informe.cfm?vTipoComando=EDITA' + '&vInformeAnualId=' + <cfoutput>#vInformeAnualId#</cfoutput>;
				if (vTipoComando == 'CAN') window.location = 'informe.cfm?vTipoComando=CONSULTA' + '&vInformeAnualId=' + <cfoutput>#vInformeAnualId#</cfoutput>;
				if (vTipoComando == 'GUA') document.forms[0].submit();
				if (vTipoComando == 'ELM') 
					if (confirm('¿En realidad desea eliminar permanentemente de la base de datos el registro seleccionado, y todos los registros relacionados?'))
						window.location = 'informe_acciones.cfm?vTipoComando=ELIMINA' + '&informe_anual_id=' + <cfoutput>#vInformeAnualId#</cfoutput>;
				if (vTipoComando == 'IMP') alert('EN PROCESO ELIMINA');
				if (vTipoComando == 'REG')
				{
					if (document.getElementById('moduloActual').value == 'INF') window.location = '<cfoutput>#vCarpetaRaizLogicaSistema#/informes_anuales/consulta_informes.cfm?vInformeStatus=#Session.InformesFiltro.vInformeStatus#</cfoutput>';
					if (document.getElementById('moduloActual').value == 'CON') window.location = '<cfoutput>#vCarpetaRaizLogicaSistema#/movimientos/consultas/consulta_informes.cfm</cfoutput>';
				}
			}
		</script>
        
		<!--- JQUERY USO LOCAL --->
		<script language="JavaScript" type="text/JavaScript">
			// AJAX Asigna los informes a una sesión
			function fAsignarSesion()
			{
				//document.getElementById("loader").style.display = "block";
				alert('ASIGNA SESION');
				$.ajax({
					//async: false,
					method: "POST",
					data: {vpActa:$("#vSsnId").val(),vpInformeAnio:$("#vInformeAnio").val(),vpInformeAnualId:$("#informe_anual_id").val()},
					url: "ajax/asignar_sesion.cfm",
					success: function(data) {
						alert(data);						
					},
					error: function(data) {
						alert('ERROR AL ASIGNAR LA SESIÓN');
						//alert(data);
					}
				});
			}		
		</script>
		<table width="180" border="0">
			<tr>
				<td><div class="linea_menu"></div></td>
			</tr>
			<tr>
				<td>
					<span class="Sans10NeNe">Men&uacute;:</span>
					<input type="hidden" name="moduloActual" id="moduloActual" value="<cfif FIND('informes_anuales', #Session.sModulo#)>INF<cfelseif FIND('consultas',#Session.sModulo#)>CON</cfif>">
					<input type="hidden" name="informe_anual_id" id="informe_anual_id" value="<cfoutput>#vInformeAnualId#</cfoutput>">
					<input type="hidden" id="vInformeAnio" name="vInformeAnio" value="<cfoutput>#Session.InformesFiltro.vInformeAnio#</cfoutput>">
				</td>
			</tr>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'NUEVO' OR #vTipoComando# EQ 'CORRECCION'>
				<!-- Opción: Guardar -->
				<tr>
					<td><input type="button" class="botones" value="Guardar" onClick="fEnviarComando('GUA')"></td>
				</tr>
				<!-- Opción: Cancelar -->
				<tr>
					<td><input type="button" class="botones" value="Cancelar" onClick="fEnviarComando('CAN');"></td>
				</tr>
				<tr>
					<td>
						<input type="hidden" name="vTipoComando" id="vTipoComando" value="GUARDA">
					</td>
				</tr>
			</cfif>
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!-- Opción: Corregir -->
				<tr>
					<td><input type="button" name="cmdInformeCorr" id="cmdInformeCorr" class="botones" value="Editar" onClick="fEnviarComando('EDT');" <cfif #Session.sTipoSistema# IS 'sic' AND #tbInformesAnuales.informe_status# GT 0>disabled</cfif>></td>
				</tr>
				<!-- Opción: Eliminar -->
				<tr>
					<td><input type="button" class="botones" value="Eliminar" onClick="fEnviarComando('ELM');" <cfif #Session.sTipoSistema# IS 'sic' AND #tbInformesAnuales.informe_status# GT 0>disabled</cfif>></td>
				</tr>
				<!-- Opción: Regresar -->
				<tr>
					<td><input type="button" class="botones" value="Regresar" onClick="fEnviarComando('REG', false);"></td>
				</tr>

				<cfif #tbInformesAnuales.dec_clave_ci# EQ 4 OR  #tbInformesAnuales.dec_clave_ci# EQ 49>
					<!--- Include para consutar o anexar documento(s) en PDF (ORDEN DEL DÍA) --->
					<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="INFORME" AcdId="#tbInformesAnuales.acd_id#" NumRegistro="#tbInformesAnuales.informe_anual_id#" SsnId="#tbInformesAnuales.informe_anio#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
				</cfif>
				<cfif #tbInformesAnuales.informe_status# EQ 1>
                    <!-- Asignar sesión -->
					<tr><td><div class="linea_menu"></div></td></tr>
                    <tr>
                        <td valign="top"><div align="left" class="Sans10NeNe">Asignar a sesión:</div></td>
                    </tr>
                    <tr>
                        <td valign="top">
							<cfmodule template="#vCarpetaINCLUDE#/module_catalogo_sesiones.cfm" SsnId="#Session.sSesion#">
							<input type="button" value="ASIGNAR" class="botones" style="width:60px;" onClick="fAsignarSesion();">
						</td>
					</td>
				</cfif>
			</cfif>
		</table>