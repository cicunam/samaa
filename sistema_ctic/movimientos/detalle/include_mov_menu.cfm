<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/06/2016 --->
<!--- FECHA �LTIMA MOD: 03/10/2023 --->
 
		<table width="180" border="0">
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><span class="Sans10NeNe">Men&uacute;:</span></td>
			</tr>
			<cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'NUEVO' OR #vTipoComando# EQ 'CORRECCION'>
				<!-- Opci�n: Guardar -->
				<tr>
					<td><input type="button" class="botones" value="Guardar" onClick="fEnviarComando('<cfoutput>#vTipoComando#</cfoutput>', true)"></td>
				</tr>
				<!-- Opci�n: Cancelar -->
				<tr>
					<td><input type="button" class="botones" value="Cancelar" onClick="fEnviarComando('CANCELA', false);"></td>
				</tr>
			</cfif>
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!-- Opci�n: Corregir -->
				<tr>
					<td><input type="button" class="botones" value="Corregir" onClick="fEnviarComando('EDITA', false)" <cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>></td>
				</tr>
				<!-- Opci�n: Imprimir -->
				<tr>
					<td><input type="button" class="botones" value="Imprimir" onClick="fEnviarComando('IMPRIME', false);"></td>
				</tr>
				<!--- 
				PENDIENTE: Lo implementar� despu�s, por ahora solo se pueden editar los registros existentes.
				<!-- Nuevo -->
				<tr>
					<td><input type="button" class="botones" value="Nuevo" onclick="NuevoRegistro();"></td>
				</tr>
				--->
				<!---
				<!-- Navegaci�n -->
				<tr><td><br><div class="linea_menu"></div></td></tr>
				<tr>
					<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
				</tr>
				<!-- Men� principal -->
				<tr>
					<td>
						<input type="button" class="botones" value="Men� principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
					</td>
				</tr>
				--->
				<!-- Opci�n: Regresar -->
				<tr>
					<td><input type="button" class="botones" value="Regresar" onClick="fEnviarComando('REGRESA', false);"></td>
				</tr>
				<!--- SE CAMBI� DE POSICI�N EL BOT�N DE ELIMINAR PARA EVITAR ELIMINAR EL REGISTRO POR ERROR 03/04/2019 --->
				<tr height="20px"><td></td></tr>
				<!-- Opci�n: Eliminar -->
				<tr>
					<td><input type="button" class="botones" value="Eliminar" onClick="EliminaRegistro();" <cfif #Session.sTipoSistema# IS 'sic' OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GT 2)>disabled</cfif>></td>
				</tr>
                <!-- Documentaci�n digitalizada -->
                <cfif #tbMovimientos.mov_clave# IS NOT 40 AND #tbMovimientos.mov_clave# IS NOT 41>
                    <!--- SE ELIMIN� PARA PODER CARGAR ARCHIVOS DE LICENCIAS Y COMISIONES --->                    
                </cfif>                    
                    <!--- M�dulo para consultar y/o anexar documento(s) en PDF --->
                    <cfif #Session.sTipoSistema# IS 'stctic' ></cfif>
					<cfmodule template="#vCarpetaINCLUDE#/archivopdf_vista_carga.cfm" ModuloConsulta="MOV" AcdId="#tbMovimientos.acd_id#" NumRegistro="#tbMovimientos.sol_id#" SsnId="#tbMovimientos.ssn_id#" DepClave="" SolStatus="" SolDevolucionSatus="" vCarpetaINCLUDE="#vCarpetaINCLUDE#">

				<!-- Situaci�n del movimiento (MOVIMIENTO CANCELADO) -->
				<tr><td><div class="linea_menu"></div></td></tr>
				<tr><td height="15"></td></tr>
				<tr>
					<td>
						<div class="cuadrosMovCanMod">
							<input name="mov_cancelado" id="mov_cancelado" type="checkbox" value="Si" onclick="fCancelaMovimiento();" <cfoutput>#mov_cancelado#</cfoutput> <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
							<span class="Sans9GrNe">Movimiento cancelado</span>
						</div>
						<div id="divCancelaMov_jquery"></div>
                    </td>
				</tr>
				<!-- Situaci�n del movimiento (MOVIMIENTO MODIFICADO) -->
				<tr>
					<td>
						<div class="cuadrosMovCanMod">
							<input name="mov_modificado" id="mov_modificado" type="checkbox" value="Si" disabled="disabled" <cfoutput>#mov_modificado#</cfoutput>>
							<span class="Sans9GrNe">Movimiento modificado</span>                            
						</div>
                    </td>
				</tr>                
			</cfif>
			<!--- Datos relacionados gurdados en otras tablas --->
			<cfif #vTipoComando# EQ 'CONSULTA'>
				<!------------------------------------------------------------------------------------------------------------------------------------->
				<!--- DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO DESHABILITADO --->
				<!------------------------------------------------------------------------------------------------------------------------------------->
				<!--- La consulta de la FT relacionada es redundante pues exite una copia id�ntica en la documentaci�n del asunto. Adem�s, al generar 
					  la FT ""al vuelo" los datos calculados se generan considerando la fecha de la consulta. Por esta raz�n, se ha deshabilitado esta 
					  opci�n de la consulta. --->
				
				<!-- Solicitud relaciondada -->
				<cfif #tbSolicitudes.RecordCount# GT 0 AND #Session.sTipoSistema# IS 'stctic'>
					<!--- Obtener informaci�n del movimiento --->
					<cfquery name="ctMovimientos" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM catalogo_movimiento 
						WHERE mov_clave = #tbMovimientos.mov_clave# 
					</cfquery>
					<tr><td><div class="linea_menu"></div></td></tr>
					<tr><td height="15"></td></tr>
					<!-- T�tulo de la opci�n -->
					<tr>
						<td><span class="Sans9NeNe">Solicitud original relacionada:</span><br></td>
					</tr>
					<!-- Descripci�n -->
					<tr>
						<td><span class="Sans9Vi" align="justify">Est&aacute; disponible la solicitud que dio origen al movimiento.</span></td>
					</tr>
					<!-- Bot�n -->
					<tr>
						<td>
							<input type="button" class="botones" value="Consultar" onClick="fEnviarComando('SOLICITUD', false);">
							<input type="hidden" name="vFt" id="vFt" value="<cfoutput>#ctMovimientos.mov_ruta#</cfoutput>">
						</td>
					</tr>
					<tr>
						<td>
							<input type="button" class="botones" value="Imprimir" onClick="fEnviarComando('SOLICITUDIMP', false);">
						</td>
					</tr>
				</cfif>
				<!-- Convocatoria COA relacionada -->
				<cfif #tbConvocatorias.RecordCount# GT 0>
					<tr><td height="15"></td></tr>
					<tr><td><div class="linea_menu"></div></td></tr>
					<!-- T�tulo de la opci�n -->
					<tr>
						<td><span class="Sans9NeNe">Convocatoria relacionada:</span><br></td>
					</tr>
					<!-- Descripci�n -->
					<tr>
						<td><span class="Sans9Vi" align="justify">Est&aacute; disponible la convocatoria relacionada al movimiento.</span></td>
					</tr>
					<!-- Bot�n -->
					<tr>
						<td>
							<input type="button" class="botones" value="Consultar" onClick="alert('Lo sentimos, la opci�n seleccionada a�n no est� disponible.');">
						</td>
					</tr>
				</cfif>
			</cfif>
		</table>
		<div style="position:fixed; left:910px; top:30px; width:120px; vertical-align:middle;"  align="center">
            <table width="120" border="0" cellpadding="1" cellspacing="1">
                <!-- Art�culos del EPA -->
                <cfoutput>
					<tr><td><span class="Sans12NeNe">FT-CTIC-#mov_clave#</span></td></tr>
                    <!-- Otros datos -->
                    <tr><td height="15"></td></tr>
                    <cfif #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'CORRECCION'>
                        <cfif #tbMovimientos.cap_fecha_crea# NEQ "">
                            <!-- Fecha de alta -->
                            <tr><td><div class="linea_menu"></div></td></tr>
                            <tr>
                                <td><span class="Sans9GrNe">Alta:</span><br><span class="Sans9Vi">#LSDateFormat(tbMovimientos.cap_fecha_crea,"DD/MM/YYYY")# #LSTimeFormat(tbMovimientos.cap_fecha_crea,"HH:mm")#hrs</span></td>
                            </tr>
                        </cfif>
                        <cfif #tbMovimientos.cap_fecha_mod# NEQ ''>
                            <!-- �ltima modificaci�n -->
                            <tr>
                                <td><span class="Sans9GrNe">&Uacute;ltima modificaci&oacute;n: </span><br><span class="Sans9Vi">#LSDateFormat(tbMovimientos.cap_fecha_mod,'DD/MM/YYYY')# #LSTimeFormat(tbMovimientos.cap_fecha_mod,'HH:mm')#hrs</span></td>
                            </tr>
                        </cfif>
                        <!-- N�mero de registro -->
                        <tr>
                            <td><span class="Sans9GrNe">N�mero de registro:</span><br><span class="Sans9Vi">#tbMovimientos.mov_id#</span></td>
                        </tr>	
                        <!-- Solicitud relacionada -->
                        <tr>
                            <td><span class="Sans9GrNe">Solicitud relacionada:</span><br><span class="Sans9Vi"><cfif #tbMovimientos.sol_id# IS NOT ''>#tbMovimientos.sol_id#<cfelse>No existe</cfif></span></td>
                        </tr>	
                    </cfif>
                </cfoutput>
            </table>
		</div>