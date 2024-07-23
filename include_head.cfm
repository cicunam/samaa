		<table class="Encabezado">
			<tr>
				<!--- Nombre de la UNAM --->
				<td class="EncabezadoUNAM" colspan="3">
                	UNIVERSIDAD NACIONAL AUT�NOMA DE M�XICO
                    <cfif #CGI.SERVER_PORT# IS '31221'>
						<cfoutput>#REMOTE_ADDR#</cfoutput>
					</cfif>
				</td>
				<!--- Si ya se entr� al sistema mostrar el la opci�n SALIR --->
				<cfif IsDefined("Session.sLoginSistema")>
					<td class="EncabezadoCerrarV2">
						<cfoutput>
                            <a href="#vCarpetaVAL#/cierra.cfm" target="_top" style="color:white;">
                                <div style="width:30px; position:absolute; top:3px; left:945px">
                                    <img src="#vCarpetaICONO#/apagar_15_blanco.png" style="width:15px; height:15px" title="cerrar sesi�n" />
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
						<span class="Arial16Blanca">SAMAA (DESARROLLO)<br></span> <!---SISTEMA PARA LA ADMINISTRACI�N DE MOVIMIENTOS ACAD�MICO-ADMINISTRATIVOS--->
						<span class="Arial16Blanca">Coordinaci�n de la Investigaci�n Cient�fica</span>
					</td>
				<cfelse>
					<td class="EncabezadoTitulo" <cfif NOT IsDefined("Session.sLoginSistema")>colspan="2"</cfif>>
						<span class="Arial16BlancaN">SISTEMA PARA LA ADMINISTRACI�N DE MOVIMIENTOS ACAD�MICO-ADMINISTRATIVOS (SAMAA)<br></span>
						<span class="Arial16Blanca">Coordinaci�n de la Investigaci�n Cient�fica</span>
					</td>
				</cfif>
				<!--- SOLUCI�N TEMPORAL: S�lo as� logro 140px de ancho �por qu�? --->
				<cfif IsDefined("Session.sLoginSistema")>
					<td style="width:70px; background-color: <cfif #CGI.SERVER_PORT# IS '31221'>#d9232f<cfelse>#507aaa</cfif>;"></td>
					<td style="width:70px; background-color: <cfif #CGI.SERVER_PORT# IS '31221'>#d9232f<cfelse>#507aaa</cfif>;">
						<cfif (IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')) AND #CGI.SERVER_PORT# IS '31221'>
							<!--- �cono para importar datos del sistema que est� en producci�n --->
                            <div style="float:right; margin:0; padding:0;">
                                <cfoutput>
                                    <img id="importar_datos" src="#vCarpetaICONO#/importar.png" style="cursor:pointer; height:30px; padding:5px 10px 5px 10px;" title="Importar datos de producci�n">
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
                                    COMISI�N DE BECAS POSDOCTORALES
                                <cfelseif #Session.sDep# EQ 'caaa'>
                                    COMISI�N DE ASUNTOS ACADEMICO-ADMINISTRATIVOS
                                <cfelseif #Session.sDep# EQ 'pleno'>
                                    CONSEJO T�CNICO DE LA INVESTIGACI�N CIENT�FICA
                                <cfelse>
                                    <cfoutput>#Session.sDep#</cfoutput>
                                </cfif>
                            </cfif>
						</em>
					</span>
				</td>
				<cfif IsDefined("Session.sLoginSistema") AND (#Session.sLoginSistema# IS NOT 'pleno' AND #Session.sLoginSistema# IS NOT 'caaa' AND #Session.sLoginSistema# IS NOT 'cbp' AND #Session.sLoginSistema# IS NOT 'inicio')>
					<td class="EncabezadoMenu" colspan="2">
						<a <cfoutput>href="#vCarpetaRaizLogica#/sistema_ctic/" target="_top"</cfoutput>>MEN� PRINCIPAL</a>
					</td>
				<cfelse>
					<td class="EncabezadoCintillo" colspan="2"></td>
				</cfif>
			</tr>
		</table>