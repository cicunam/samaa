		<table class="Encabezado">
			<tr>
				<!--- Nombre de la UNAM --->
				<td class="EncabezadoUNAM" colspan="3">
                	UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO
                    <cfif #CGI.SERVER_PORT# IS '31221'>
						<cfoutput>#REMOTE_ADDR#</cfoutput>
					</cfif>
				</td>
				<!--- Si ya se entró al sistema mostrar el la opción SALIR --->
				<cfif IsDefined("Session.sLoginSistema")>
					<td class="EncabezadoCerrarV2">
						<cfoutput>
                            <a href="#vCarpetaVAL#/cierra.cfm" target="_top" style="color:white;">
                                <div style="width:30px; position:absolute; top:3px; left:945px">
                                    <img src="#vCarpetaICONO#/apagar_15_blanco.png" style="width:15px; height:15px" title="cerrar sesión" />
                                </div>
                                <div style="width:30px; position:absolute; top:6px; left:970px">CERRAR</div>
                            </a>
						</cfoutput>
<!---
						<a href="<cfoutput>#vCarpetaVAL#</cfoutput>/cierra.cfm" target="_top" style="color:white;">SALIR</a>
--->
					</td>
				</cfif>
			</tr>
			<tr>
				<!--- Logotipo --->
				<td class="EncabezadoLogo">
					<img src="<cfoutput>#vCarpetaIMG#</cfoutput>/cic_logo_50.png" style="width:50px; height:50px" />
				</td>
				<!--- Titulo del sistema --->
				<cfif #CGI.SERVER_PORT# IS '31221'>
					<td class="EncabezadoTituloDesarrollo" <cfif NOT IsDefined("Session.sLoginSistema")>colspan="2"</cfif>>
						<span class="Arial16Blanca">SAMAA (DESARROLLO)<br></span> <!---SISTEMA PARA LA ADMINISTRACIÓN DE MOVIMIENTOS ACADÉMICO-ADMINISTRATIVOS--->
						<span class="Arial16Blanca">Coordinación de la Investigación Científica</span>
					</td>
				<cfelse>
					<td class="EncabezadoTitulo" <cfif NOT IsDefined("Session.sLoginSistema")>colspan="2"</cfif>>
						<span class="Arial16BlancaN">SISTEMA PARA LA ADMINISTRACIÓN DE MOVIMIENTOS ACADÉMICO-ADMINISTRATIVOS (SAMAA)<br></span>
						<span class="Arial16Blanca">Coordinación de la Investigación Científica</span>
					</td>
				</cfif>
				<!--- SOLUCIÓN TEMPORAL: Sólo así logro 140px de ancho ¿por qué? --->
				<cfif IsDefined("Session.sLoginSistema")>
					<td style="width:70px; background-color: <cfif #CGI.SERVER_PORT# IS '31221'>#d9232f<cfelse>#507aaa</cfif>;"></td>
					<td style="width:70px; background-color: <cfif #CGI.SERVER_PORT# IS '31221'>#d9232f<cfelse>#507aaa</cfif>;">
						<cfif (IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')) AND #CGI.SERVER_PORT# IS '31221'>
							<!--- Ícono para importar datos del sistema que está en producción --->
                            <div style="float:right; margin:0; padding:0;">
                                <cfoutput>
                                    <img id="importar_datos" src="#vCarpetaICONO#/importar.png" style="cursor:pointer; height:30px; padding:5px 10px 5px 10px;" title="Importar datos de producción">
                                    <img id="importar_datos_wait" src="#vCarpetaIMG#/wait.gif" style="display:none; cursor:pointer; height:30px; padding:5px 10px 5px 10px;">
                                </cfoutput>
                            </div>
						</cfif>                    
                    </td>
				</cfif>
			</tr>
			<!--- Cintillo --->
			<tr>
				<td class="EncabezadoCintillo" colspan="2">
                	<span class="Arial10NegraN">
						<em>
							<cfif IsDefined("Session.sLoginSistema") AND IsDefined("Session.sDep")>
                                <cfif #Session.sDep# EQ 'cbp'>
                                    COMISIÓN DE BECAS POSDOCTORALES
                                <cfelseif #Session.sDep# EQ 'caaa'>
                                    COMISIÓN DE ASUNTOS ACADEMICO-ADMINISTRATIVOS
                                <cfelseif #Session.sDep# EQ 'pleno'>
                                    CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA
                                <cfelse>
                                    <cfoutput>#Session.sDep#</cfoutput>
                                </cfif>
                            </cfif>
						</em>
					</span>
				</td>
				<cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')>
					<td class="EncabezadoMenu" colspan="2">
						<a <cfoutput>href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"</cfoutput>>MENÚ PRINCIPAL</a>
					</td>
				<cfelse>
					<td class="EncabezadoCintillo" colspan="2"></td>
				</cfif>
			</tr>
		</table>