<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/05/2024 --->
<!--- FECHA ULTIMA MOD.: 20/05/2024 --->
<!--- INCLUDE para listar nos documentos de dictámenes requeridos --->

<!--- Obtener datos los dictámenes solicitados en la FT --->
<cfquery name="tbMovDictamen" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_anexos
    WHERE mov_clave = #vFt#
	AND mov_anexo_dictamen = 1
	AND mov_anexo_anexos = 1
	AND GETDATE() BETWEEN mov_anexo_FechaInicio AND mov_anexo_FechaFinal
	AND mov_anexo_status = 1
    ORDER BY mov_anexo_orden
</cfquery>
					<cfif #tbMovDictamen.RecordCount# GT 0>
						<table width="100%" border="0" cellpadding="0" class="cuadrosFormularios">
							<tr bgcolor="#CCCCCC">
								<td width="65%"></td>
								<td width="20%"><div align="center" class="Sans9GrNe">Aprobatoria</div></td>
								<td width="15%"><div align="center" class="Sans9GrNe">Se anexa</div></td>
							</tr>
							<!-- Lista los dictámens requeridos -->
                        	<cfoutput query="tbMovDictamen">							
								<tr id="#mov_anexo_idTr#">
									<td><span class="Sans9GrNe">#mov_anexo_descrip#</span></td>
									<td>
										<div align="center">
											<!--- <cfset vDictamen = variables["vCampoPos#mov_anexo_dictamenCampo#"]> SE GENERA UNA VARIABLE A PARTIR DE UN TEXTO Y UN CAMPO 17/05/2024 EJEMPLO--->
											<span class="Sans9GrNe">
												<cfinput type="radio" name="pos#mov_anexo_dictamenCampo#" id="pos#mov_anexo_dictamenCampo#_s" value="Si" disabled="#vActivaCampos#" checked="#Iif(variables["vCampoPos#mov_anexo_dictamenCampo#"] EQ "Si",DE("yes"),DE("no"))#">S&iacute;
												<cfinput type="radio" name="pos#mov_anexo_dictamenCampo#" id="pos#mov_anexo_dictamenCampo#_n" value="No" disabled="#vActivaCampos#" checked="#Iif(variables["vCampoPos#mov_anexo_dictamenCampo#"] EQ "No",DE("yes"),DE("no"))#">No
											</span>
										</div>
									</td>
									<td>
										<div align="center">
											<!--- <cfset vAnexo = variables["vCampoPos#mov_anexo_anexosCampo#"]> SE GENERA UNA VARIABLE A PARTIR DE UN TEXTO Y UN CAMPO 17/05/2024 EJEMPLO --->
											<cfinput type="checkbox" name="pos#mov_anexo_anexosCampo#" id="pos#mov_anexo_anexosCampo#" value="Si" disabled="#vActivaCampos#" checked="#Iif(variables["vCampoPos#mov_anexo_anexosCampo#"] EQ "Si",DE("yes"),DE("no"))#">
										</div>
									</td>
								</tr>
                        	</cfoutput>
						</table>
					</cfif>
