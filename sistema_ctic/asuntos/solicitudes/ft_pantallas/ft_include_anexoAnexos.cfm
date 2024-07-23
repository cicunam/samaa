<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/05/2024 --->
<!--- FECHA ULTIMA MOD.: 20/05/2024 --->
<!--- INCLUDE para listar nos documentos anexos requeridos --->

<!--- Obtener datos los dictámenes solicitados en la FT --->
<cfquery name="tbMovAnexos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_anexos
    WHERE mov_clave = #vFt#
	AND mov_anexo_dictamen = 0
	AND mov_anexo_anexos = 1
	AND GETDATE() BETWEEN mov_anexo_FechaInicio AND mov_anexo_FechaFinal
	AND mov_anexo_status = 1
    ORDER BY mov_anexo_orden
</cfquery>

					<cfif #tbMovAnexos.RecordCount# GT 0>
						<table width="100%" border="0" cellpadding="0" class="cuadrosFormularios">
							<tr bgcolor="#CCCCCC">
								<td width="85%"></td>
								<td width="15%">
									<div align="center" class="Sans9GrNe">Se anexa</div>
								</td>
							</tr>
							<!-- Lista los anexos requeridos -->
                        	<cfoutput query="tbMovAnexos">
								<tr id="#mov_anexo_idTr#">
									<td><span class="Sans9GrNe">#mov_anexo_descrip#</span></td>
									<td>
										<div align="center">
											<cfinput type="checkbox" name="pos#mov_anexo_anexosCampo#" id="pos#mov_anexo_anexosCampo#" value="Si" disabled='#vActivaCampos#' checked="#Iif(vCampoPos32 EQ "Si",DE("yes"),DE("no"))#">
										</div>
									</td>
								</tr>
							</cfoutput>
						</table>
					</cfif>