<!--- CREADO: ARAM PICHARDO DURÁN--->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/06/2015 --->
<!--- FECHA MOD: 16/06/2015 --->
<!--- LISTA DE SESIONES DEL CTIC (ORDEN DEL DÍA) --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_tbSesionOrden" default="1">
<cfset vNuevoRegistro = 0>

<cfif NOT IsDefined('Session.sTipoSesionCel') OR #Session.sTipoSesionCel# EQ ''>
	<cfset Session.sTipoSesionCel = 'O'>
<cfelseif IsDefined('vTipoSesionCel')>
	<cfset Session.sTipoSesionCel = #vTipoSesionCel#>
</cfif>

<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE 
		<cfif #Session.sTipoSesionCel# EQ "O">
    		ssn_clave = 1 AND ssn_id <= #Session.sSesion#
		<cfelseif #Session.sTipoSesionCel# EQ "E">
			ssn_clave = 2 
        </cfif> 
    ORDER BY ssn_id DESC
</cfquery>

<cfif #Session.sTipoSesionCel# EQ "O">
	<cfset vNuevoRegistro = #Session.sSesion#>
<cfelseif #Session.sTipoSesionCel# EQ "E">
	<cfloop query="tbSesionOrden">
		<cfif #ssn_fecha# GTE #now()#>
			<cfset vNuevoRegistro = #ssn_id#>
		</cfif>
	</cfloop>
</cfif> 

<cfset MaxRows_tbSesionOrden=20>
<cfset StartRow_tbSesionOrden=Min((PageNum_tbSesionOrden-1)*MaxRows_tbSesionOrden+1,Max(tbSesionOrden.RecordCount,1))>
<cfset EndRow_tbSesionOrden=Min(StartRow_tbSesionOrden+MaxRows_tbSesionOrden-1,tbSesionOrden.RecordCount)>
<cfset TotalPages_tbSesionOrden=Ceiling(tbSesionOrden.RecordCount/MaxRows_tbSesionOrden)>
<cfset QueryString_tbSesionOrden=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_tbSesionOrden,"PageNum_tbSesionOrden=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_tbSesionOrden=ListDeleteAt(QueryString_tbSesionOrden,tempPos,"&")>
</cfif>

		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ADMINISTRACI&Oacute;N DE SESIONES &gt;&gt; </span><span class="Sans9Gr">ORDEN DEL D&Iacute;A</span></td>
				<td align="right"><span class="Sans9Gr">Sesi&oacute;n vigente: <cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput></span></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="1024" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="180" valign="top" class="bordesmenu">
					<!-- Controles -->
					<table width="180" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Nueva orden del día -->
						<tr>
							<td valign="top">
								<input name="cmdNueva" type="button" class="botones" value="Nueva orden del d&iacute;a" onclick="window.location.replace('orden_dia.cfm?vIdSsn=<cfoutput>#vNuevoRegistro#</cfoutput>&vTipoComando=NUEVO')" <cfif #Session.sTipoSistema# IS 'sic' OR #vNuevoRegistro# EQ 0>disabled</cfif>>
							</td>
						</tr>
						<!---
						<!-- Navegación -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td><span class="Sans10NeNe">Navegaci&oacute;n:</span></td>
						</tr>
						<!-- Menú principal -->
						<tr>
							<td>
								<input type="button" class="botones" value="Menú principal" onclick="top.location.replace('../../<cfoutput>#Session.sTipoSistema#</cfoutput>_index.cfm');">
							</td>
						</tr>
						--->
						<!-- Filtrar por -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Ver sesiones:</div></td>
						</tr>
						<tr>
							<td valign="top">
								<input type="radio" name="vTipoSesion" id="vTipoSesionO" value="O" onClick="fTipoSesionFiltro('O');" <cfif #Session.sTipoSesionCel# EQ "O">checked="checked"</cfif>> <span class="Sans10Ne">Ordinarias</span><br>
								<input type="radio" name="vTipoSesion" id="vTipoSesionE" value="E" onClick="fTipoSesionFiltro('E');" <cfif #Session.sTipoSesionCel# EQ "E">checked="checked"</cfif>> <span class="Sans10Ne">Extraordinarias</span><br>
							</td>
						</tr>
						<!-- Contador de registros -->
						<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top">
								<span class="Sans9GrNe">Registros: </span>
								<span class="Sans9Gr">
									<cfoutput>#StartRow_tbSesionOrden# al #EndRow_tbSesionOrden#</cfoutput>
								</span>
								<br>
								<span class="Sans9GrNe">Total: </span>
								<span class="Sans9Gr">
									<cfoutput>#tbSesionOrden.RecordCount#</cfoutput>
								</span>
							</td>
						</tr>
					</table>
				</td>
				<!-- Columna derecha -->
				<td width="844" valign="top">
						<!-- Liste de registros -->
					<div align="center">
						<span class="Sans12NeNe">ORDEN DEL DÍA</span>
						<br>
						<cfif #Session.sTipoSesionCel# EQ "O">
							<span class="Sans12NeNe">SESIONES ORDINARIAS</span>
							<br>
						<cfelseif #Session.sTipoSesionCel# EQ "E">
							<span class="Sans12NeNe">SESIONES EXTRAORDINARIAS</span>
							<br>
						</cfif>
						<br>
					</div>
                    
					<table style="width: 780px; padding: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1" align="center">
						<tr bgcolor="#CCCCCC">
							<td width="55" height="20" class="Sans9GrNe">SESI&Oacute;N</td>
						  <td class="Sans9GrNe">LUGAR</td>
							<td class="Sans9GrNe">FECHA</td>
							<td class="Sans9GrNe" align="center">PUNTOS</td>
							<td width="15" bgcolor="#FFBC81"></td>
							<td width="15" bgcolor="#0066FF"></td>
						</tr>
						<cfoutput query="tbSesionOrden" startRow="#StartRow_tbSesionOrden#" maxRows="#MaxRows_tbSesionOrden#">
						<cfset vIdSsn = #tbSesionOrden.ssn_id#>
                        <cfset vCarpetaArchivoOd = ''>
						<cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_' & #ssn_id# & '.pdf'>
						<cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #ssn_id# & '.pdf'>                        

						<cfquery name="tbOrdenDia" datasource="#vOrigenDatosSAMAA#">
							SELECT COUNT(*) AS numero FROM sesiones_orden WHERE ssn_id = #vIdSsn#
						</cfquery>
						<!---<cfif #tbOrdenDia.recordcount# GT 0>--->
							<tr <cfif #tbSesionOrden.ssn_id# EQ session.sSesion> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse>onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
								<td class="Sans10Ne">#tbSesionOrden.ssn_id#</td>
								<td class="Sans10Ne">#tbSesionOrden.ssn_sede#</td>
								<td class="Sans10Ne">#LSDateFormat(tbSesionOrden.ssn_fecha,'MMMM dd, yyyy')#</td>
								<td align="center" class="Sans10Ne">#tbOrdenDia.numero#</td>
								<!-- Botón VER -->
								<td>
									<cfif FileExists(#vCarpetaArchivoOd#)>
									<a href="#vWebArchivoOd#" target="WIN_ORDENDIA"><img src="#vCarpetaIMG#/pdf_icon_2017.png" width="15px" style="border:none;" title="#tbSesionOrden.ssn_id#"></a>
									</cfif>
								</td>
								<td>
									<a href="orden_dia.cfm?vIdSsn=#tbSesionOrden.ssn_id#&vTipoComando=CONSULTA"><img src="#vCarpetaIMG#/detalle_15.jpg" style="border:none;" title="#tbSesionOrden.ssn_id#"></a>
                                </td>
							</tr>
						<!---</cfif>--->
						</cfoutput>
					</table>
					<!-- Paginación de la lista (inferior) -->
				  <table border="0" width="50%" align="center">
						<cfoutput>
						<tr>
							<td width="25%" align="center">
								<span class="Sans10ViNe">
									<a 
									<cfif NOT PageNum_tbSesionOrden GT 1>
										disabled="true" style="color:grey;" 
									<cfelse>
										disabled="false" href="#CurrentPage#?PageNum_tbSesionOrden=1#QueryString_tbSesionOrden#"
									</cfif>
									>Primero</a>
								</span>
							</td>
							<td width="25%" align="center">
								<span class="Sans10ViNe">
									<a 
									<cfif NOT PageNum_tbSesionOrden GT 1>
										disabled="true" style="color:grey;" 
									<cfelse>
										disabled="false" href="#CurrentPage#?PageNum_tbSesionOrden=#Max(DecrementValue(PageNum_tbSesionOrden),1)##QueryString_tbSesionOrden#"
									</cfif>
									>Anterior</a>
								</span>
							</td>
							<td width="25%" align="center">
								<span class="Sans10ViNe">
									<a 
									<cfif NOT PageNum_tbSesionOrden LT TotalPages_tbSesionOrden>
										disabled="true" style="color:grey;" 
									<cfelse>
										disabled="false" href="#CurrentPage#?PageNum_tbSesionOrden=#Min(IncrementValue(PageNum_tbSesionOrden),TotalPages_tbSesionOrden)##QueryString_tbSesionOrden#" 
									</cfif>
									>Siguiente</a>
								</span>
							</td>
							<td width="25%" align="center">
								<span class="Sans10ViNe">
									<a 
									<cfif NOT PageNum_tbSesionOrden LT TotalPages_tbSesionOrden>
										disabled="true" style="color:grey;" 
									<cfelse>
										disabled="false" href="#CurrentPage#?PageNum_tbSesionOrden=#TotalPages_tbSesionOrden##QueryString_tbSesionOrden#"
									</cfif>
									>&Uacute;ltimo</a>
								</span>
							</td>
						</tr>
						</cfoutput>
					</table>
				</td>
			</tr>
		</table>