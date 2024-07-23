<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2016 --->
<!--- FECHA ÚLTIMA MOD.: 08/05/2024 --->
<!--- 
	NOTA: Deshabilité la asignación a una sesión desde este menú porque se complicaba demasiado el código, 
	debido a la validación necesaria para no asignar el asunto a una reunión de la CAAA ya celebrada
--->

<!--- Obtener los artículos del EPA en los que se fundamenta el movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art 
    WHERE mov_clave = #vFt# 
    ORDER BY mov_articulo
</cfquery>

	<!--- Archivo PDF de documentación --->
    <cfif #vTipoComando# EQ 'CONSULTA'>
        <cfset vArchivoPdf = #tbSolicitudes.sol_pos2# & '_' & #tbSolicitudes.sol_id# & '.pdf'>
        <cfif #vSolStatus# GTE "3">
            <cfset vArchivoSolicitudPdf = #vCarpetaENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '\' & #vArchivoPdf#>
            <cfset vArchivoSolicitudPdfWeb = #vWebENTIDAD# & #MID(tbSolicitudes.sol_pos1,1,4)# & '/' & #vArchivoPdf#>
        <cfelse>
            <cfset vArchivoSolicitudPdf = #vCarpetaCAAA# & #vArchivoPdf#>
            <cfset vArchivoSolicitudPdfWeb = #vWebCAAA# & #vArchivoPdf#>
        </cfif>
        <cfif FileExists(#vArchivoSolicitudPdf#)>
            <cfset vTextoArchivo = "Reenviar archivo">
        <cfelse>
            <cfset vTextoArchivo = "Enviar archivo">
        </cfif>
    </cfif>
		<!-- Menú -->
		<table width="180" border="0" cellpadding="1" cellspacing="1">
			<tr>
				<td><div class="linea_menu"></div></td>
			</tr>
			<tr>
				<td><span class="Sans10NeNe">Men&uacute;:</span></td>
			</tr>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'NUEVO'>
				<!-- Opción: Guardar -->
				<tr>
					<td><input type="button" id="cmdGuardarSol" name="cmdGuardarSol" class="botones" value="Guardar" onClick="fEnviarComando('<cfoutput>#vTipoComando#</cfoutput>', true);"></td>
				</tr>
				<!---
				<!-- Restablecer -->
				<tr>
					<td>
						<input type="button" id="cmdRestSol" name="cmdRestSol" class="botones" value="Reestablecer" onclick="fEnviarComando('LIMPIA', false)">
					</td>
				</tr>
				--->
				<!-- Opción: Cancelar -->
				<tr>
					<td>
						<input type="button" id="cmdCancelaSol" name="cmdCancelaSol" class="botones" value="Cancelar" onClick="fEnviarComando('CANCELA', false);">
					</td>
				</tr>
			</cfif>
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!-- Opción: Corregir -->
				<tr>
					<td>
						<input type="button" id="cmdEditaSol" name="cmdEditaSol" class="botones" value="Corregir" onClick="fEnviarComando('EDITA', false);" <cfif (#Session.sTipoSistema# IS 'sic' AND #vSolStatus# IS NOT 4 AND #tbSolicitudes.sol_devuelve_edita# EQ 0) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>>
					</td>
				</tr>
				<cfif #vFt# NEQ '40' AND #vFt# NEQ '41'>
                    <!-- Opción: Imprimir -->
                    <tr>
                        <td>
                            <input type="button" id="cmdImprimeSol" name="cmdImprimeSol" class="botones" value="Imprimir FT" onClick="fEnviarComando('IMPRIME', false);" <cfif (#Session.sTipoSistema# IS 'sic' AND #vSolStatus# LTE 2 AND #tbSolicitudes.sol_devuelve_edita# EQ 0) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>>
                        </td>
                    </tr>
				</cfif>
				<cfif #Session.sTipoSistema# IS 'stctic' AND #vFt# NEQ '40' AND #vFt# NEQ '41'>
					<!-- Opción: Imprimir FT en blanco-->
					<tr>
						<td>
							<input type="button" id="cmdImgEjemSol" name="cmdImgEjemSol" class="botones" value="Imprimir FT EJEMPLO" onClick="fEnviarComando('IMPRIMEEJEMPLO', false);">
						</td>
					</tr>
				</cfif>
				<!-- Opción: Regresar -->
				<tr>
					<td>
						<input type="button" id="cmdRegresaSol" name="cmdRegresaSol" class="botones" value="Regresar" onClick="fEnviarComando('REGRESA', false);">
					</td>
				</tr>
				<!--- SE CAMBIÓ DE POSICIÓN EL BOTÓN DE ELIMINAR PARA EVITAR ELIMINAR EL REGISTRO POR ERROR 03/04/2019 --->
				<tr height="20px"><td></td></tr>
				<!-- Opción: Eliminar -->
				<tr>
					<td>
						<input type="button" id="cmdEliminaSol" name="cmdEliminaSol" class="botones" value="Eliminar" onClick="fEnviarComando('BORRA', false);" <cfif (#Session.sTipoSistema# IS 'sic' AND #vSolStatus# IS NOT 4) OR (#Session.sTipoSistema# IS 'stctic' AND #vSolStatus# LT 3) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>>
					</td>
				</tr>
				<!-- Comando sobre la solicitud/asunto -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td>
						<span class="Sans10NeNe"><cfif #vSolStatus# GT 2>Solicitud:<cfelse>Asunto:</cfif></span>
					</td>
				</tr>
				<!-- Nueva solicitud -->
				<cfif #vSolStatus# GT 2>
					<tr>
						<td>
							<input type="button" id="cmdNuevaSol" name="cmdNuevaSol" class="botones" value="Nueva solicitud" onClick="NuevaSolicitud();" <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GT 2>disabled</cfif>>
						</td>
					</tr>
				</cfif>
				<!-- Enviar solicitud  -->
				<cfif #Session.sTipoSistema# IS 'sic'>
					<tr>
						<td>
							<input type="button" id="cmdEnviaSol" name="cmdEnviaSol" class="botones" value="Enviar solicitd" onClick="fEnviarComando('ENVIA', false);" 
							<cfif #vSolStatus# IS NOT 4>disabled</cfif>
							>
						</td>
					</tr>
				</cfif>
				<cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 2>
					<!-- Retirar asunto -->
					<cfif #vSolStatus# LT 3>
						<tr>
							<td>
								<input type="button" id="cmdRetiraSol" name="cmdRetiraSol" class="botones" value="Retirar el asunto" onClick="fRetirarAsunto();">
							</td>
						</tr>
					</cfif>
					<!-- Devolver solicitud a la entidad -->
					<cfif #vSolStatus# EQ 3>
					<tr>
						<td>
							<input type="button" id="cmdDevEntidadSol" name="cmdDevEntidadSol" class="botones" value="Devolver a la entidad" onClick="fDevolverSolicitud(4,'ENTIDAD');">
						</td>
					</tr>
                    </cfif>
					<!-- Devolver solicitud a revisión -->
					<cfif #vSolStatus# LT 3>
						<tr>
							<td><input type="button" id="cmdDevRecibidaSol" name="cmdDevRecibidaSol" class="botones" value="Devolver a recibidas" onClick="fDevolverSolicitud(3,'RECIBIDA');"></td>
						</tr>
						<!-- Permitir a la entidad -->
						<tr height="5"><td></td></tr>
						<tr>
							<td>
								<span class="Sans9NeNe">Permitir a la entidad:</span>
							</td>
						</tr>
						<tr>
							<td class="Sans9Vi">
								<input name="chkImprime" id="chkImprime" type="checkbox" value="Imprimir" style="margin:0px;" onClick="fDevolverSolicitud(3,'IMPRIME');" <cfif #tbSolicitudes.sol_devuelve_edita# EQ 1>checked</cfif>> Editar e imprimir<br>
								<input name="chkArchivo" id="chkArchivo" type="checkbox" value="Archivo" style="margin:0px;" onClick="fDevolverSolicitud(3,'ARCHIVO');" <cfif #tbSolicitudes.sol_devuelve_archivo# EQ 1>checked</cfif>> Reeneviar archivo PDF
							</td>
						</tr>
					</cfif>
				</cfif>
				<!--- Include para consutar o anexar documento(s) en PDF --->
                <cfif #Session.sTipoSistema# IS 'stctic' OR #Session.sTipoSistema# IS 'sic'>
                    <cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="SOL" AcdId="#vIdAcad#" NumRegistro="#vIdSol#" SsnId="" DepClave="#vCampoPos1#" SolStatus="#vSolStatus#" SolDevolucionSatus="#tbSolicitudes.sol_devuelve_archivo#" vCarpetaINCLUDE="#vCarpetaINCLUDE#">
                </cfif>
				<!---
				<!-- Navegación -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
				</tr>
				<!-- Ir al Menú principal -->
				<tr>
					<td>
						<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
					</td>
				</tr>
				--->
			</cfif>
			<!-- Aplicar corrección a oficio -->
			<cfif #Session.sTipoSistema# IS 'stctic' AND #vFt# IS 31 AND #vTipoComando# IS 'CONSULTA' AND #vSolStatus# LTE 1>
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td valign="top"><div align="left" class="Sans10NeNe">Correcci&oacute;n a oficio:</div></td>
				</tr>
				<tr>
					<td class="Sans9Vi">
						<cfif #vSolStatus# EQ 1>
							Aplicar las correcciones indicadas en la solicitud al movimiento asociado.
						<cfelse>
							Ya se aplicaron las correcciones indicadas al movimiento asociado.
						</cfif>	
					</td>
				</tr>
				<cfif #vSolStatus# EQ 1>
					<tr>
						<td>
							<input type="button" value="Aplicar correcciones" class="botones" onClick="fAplicarCorreccionOficio();">
						</td>
					</tr>
				</cfif>	
			</cfif>
			<!-- Lista de documentos que se deben anexar -->
			<cfif  #vFt# IS NOT 40 AND #vFt# IS NOT 41 AND #vSolStatus# GT 2>
				<tr><td height="15"></td></tr>
				<tr>
					<td><div class="linea_menu"></div></td>
				</tr>
				<tr>
					<td><span class="Sans10NeNe">Documentos:</span><br></td>
				</tr>
				<tr>
					<td><span class="Sans9Vi" align="justify">Lista de documentos que debe anexar.</span></td>
				</tr>
				<tr>
					<td><input name="cmdDocsAnexos" id="cmdDocsAnexos" type="button" class="botones" value="Consultar"></td>
				</tr>
			</cfif>
			<cfif #vFt# IS NOT 15 AND #vFt# IS NOT 16>
				<tr><td height="15"></td></tr>
				<tr>
					<td><div class="linea_menu"></div></td>
				</tr>
				<tr>
					<td><span class="Sans10NeNe">Movimientos anteriores:</span><br></td>
				</tr>
				<tr>
					<td><span class="Sans9Vi" align="justify">Historia de movimientos del académico.</span></td>
				</tr>
				<tr>
					<td><input name="cmdMovHistoria" id="cmdMovHistoria" type="button" class="botones" value="Consultar"><!---onClick="$('#ListaMovimientos').dialog('open');"---></td>
				</tr>
			</cfif>
		</table>
        <!--- VENTANA EMERGENTE QUE DESPLIEGA LA HISTORIA DE MOVIMIENTOS --->
		<div id="ListaMovimientos_jQuery" title="Historia de movimientos" style="background-color:#fafafa; display:none;"></div>

        <!--- VENTANA EMERGENTE QUE DESPLIEGA LOS DOCUMENTOS QUE DEBE ANEXAR --->
		<div id="ListaDocumentosAnexos_jQuery" title="Lista de documentos anexos" style="background-color:#fafafa; display:none;"></div>
        
        
        <!--- DESPLIEGA LA INFORMACIÓN DEL SISTEMA DE LA SOLICITUD --->
		<div style="position:fixed; left:910px; top:30px; width:120px; vertical-align:middle;"  align="center">
            <table width="120" border="0" cellpadding="1" cellspacing="1">
                <!-- Artículos del EPA -->
                <cfoutput>
	                <tr><td><span class="Sans12NeNe">FT-CTIC-#vFt#</span></td></tr>
				</cfoutput>
				<tr><td height="15"></td></tr>
				<!-- LÍNEA SEPARA --->
                <tr><td><div class="linea_menu"></div></td></tr>
                <tr>
                    <td><span class="Sans10NeNe">Art&iacute;culo(s) del EPA:</span><br></td>
                </tr>
                <tr>
                    <td>
						<cfif #ctMovimientoArt.RecordCount# GT 0>
                            <span class="Sans9Vi">
                            <cfoutput query="ctMovimientoArt">
                                #ctMovimientoArt.mov_ley# Art.#ctMovimientoArt.mov_articulo# #ctMovimientoArt.mov_incisos#<br>
                            </cfoutput>
                            </span>
                            <br />
							<div class="divConsultaEpa">
								<span class="Sans9NeNe">
									<a href="http://abogadogeneral.unam.mx/legislacion/abogen/documento.html?doc_id=36" target="winAbogadoGeneral"> CONSULTAR EL E.P.A.</a>
								</span>
							</div>								
                        <cfelse>
                            No aplica
                        </cfif>
                    </td>
                </tr>
                <!-- Más información acerca de la solicitud -->
                <tr><td height="15"></td></tr>
                <cfoutput>
					<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA'>
                        <!-- LÍNEA SEPARA --->
                        <tr>
                            <td><div class="linea_menu"></div></td>
                        </tr>
                        <tr>
                            <td><span class="Sans10NeNe">Inf. del registro</span><br></td>
                        </tr>
                        <tr>
                            <td><span class="Sans9GrNe">Número de solicitud:</span><br><span class="Sans9ViNe">#tbSolicitudes.sol_id#</span></td>
                        </tr>                                                
                        <!-- Número de solicitud -->
                        <cfif #tbSolicitudes.cap_fecha_crea# NEQ "">
                            <!-- Fecha de alta -->
                            <tr>
                                <td><span class="Sans9GrNe">Alta:</span><br><span class="Sans9Vi">#LSDateFormat(tbSolicitudes.cap_fecha_crea,"DD/MM/YYYY")# #LSTimeFormat(tbSolicitudes.cap_fecha_crea,"HH:mm")#hrs</span></td>
                            </tr>
                        </cfif>
                        <cfif #tbSolicitudes.cap_fecha_mod# NEQ ''>
                            <!-- Feha de la última modificación -->
                            <tr>
                                <td><span class="Sans9GrNe">&Uacute;ltima modificaci&oacute;n: </span><br><span class="Sans9Vi">#LSDateFormat(tbSolicitudes.cap_fecha_mod,'DD/MM/YYYY')# #LSTimeFormat(tbSolicitudes.cap_fecha_mod,'HH:mm')#hrs</span></td>
                            </tr>
                        </cfif>
                        <!-- Estado de la solicitud -->
                        <tr>
                            <td>
                                <span class="Sans9GrNe">Estatus de la solicitud:</span>
                                <br>
                                <span class="Sans9Vi">
                                    <cfif #tbSolicitudes.sol_status# IS 4>
                                        <cfif  #tbSolicitudes.sol_devuelta# IS FALSE>
                                            EN CAPTURA
                                        <cfelse>
                                            DEVUELTA
                                        </cfif>
                                    <cfelseif #tbSolicitudes.sol_status# IS 3>
                                        ENVIADA	
                                    <cfelseif #tbSolicitudes.sol_status# IS 2 OR #tbSolicitudes.sol_status# IS 1>
                                        EN PROCESO
                                    <cfelseif #tbSolicitudes.sol_status# IS 0>
                                        ASUNTO RESUELTO
                                    </cfif>
                                </span>
                            </td>
                        </tr>
                        <cfif #tbSolicitudes.sol_fecha_firma# NEQ ''>
                            <tr>
                                <td>
                                    <span class="Sans9GrNe">Fecha firma:</span>
                                    <br>
                                    <span class="Sans9Vi">#LSDateFormat(tbSolicitudes.sol_fecha_firma,'DD/MM/YYYY')# #LSTimeFormat(tbSolicitudes.sol_fecha_firma,"HH:mm")#hrs</span>
                                </td>
                            </tr>
                        </cfif>
                    </cfif>
                </cfoutput>
            </table>
		</div>