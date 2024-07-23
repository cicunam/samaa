<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 21/01/2010 --->
<!--- LISTA DE SESIONES DEL CTIC --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_sesiones" default="1">
<cfparam name="vSesionesTipo" default="Anterior">
<cfset vMes = val(LsDateFormat(now(),"mm"))>
<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
<cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>

<cfif NOT IsDefined('Session.sTipoSesionCel') OR #Session.sTipoSesionCel# EQ ''>
	<cfset Session.sTipoSesionCel = 'O'>
<cfelseif IsDefined('vTipoSesionCel')>
	<cfset Session.sTipoSesionCel = #vTipoSesionCel#>
</cfif>

<cfquery name="tbCatalogoSesiones" datasource="#vOrigenDatosSAMAA#">
	<cfif #Session.sTipoSesionCel# EQ 'O'>
		SELECT ssn_id FROM sesiones WHERE (ssn_clave <> 2 AND ssn_clave <> 6) AND (
		<cfif #vMes# LTE 7>
			MONTH(ssn_fecha) < 9 AND YEAR(ssn_fecha) = #vAnio#)
		<cfelseif #vMes# GTE 8>
			MONTH(ssn_fecha) > 8 AND YEAR(ssn_fecha) = #vAnio#) OR (MONTH(ssn_fecha) = 1 AND YEAR(ssn_fecha) = #vAnioPost#)
		</cfif>
		GROUP BY ssn_id
	</cfif>
    
	<cfif #Session.sTipoSesionCel# EQ 'E'>
		SELECT * FROM sesiones WHERE 
        ssn_clave = 2
        ORDER BY ssn_id DESC
	</cfif>
</cfquery>

<cfset MaxRows_sesiones=30>
<cfset StartRow_sesiones=Min((PageNum_sesiones-1)*MaxRows_sesiones+1,Max(tbCatalogoSesiones.RecordCount,1))>
<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,tbCatalogoSesiones.RecordCount)>
<cfset TotalPages_sesiones=Ceiling(tbCatalogoSesiones.RecordCount/MaxRows_sesiones)>
<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_sesiones=","&")>
<cfif tempPos NEQ 0>
	<cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
</cfif>
<html>
	<head>
		<title>SAMAA - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			function fTipoSesionFiltro(vValorTipoSes)
			{
				window.location = 'sesiones_lista.cfm?vTipoSesionCel=' + vValorTipoSes
			}
			// Mostrar la lista de asuntos en formato PDF:
			function fClickMenu(vTipoAccion)
			{
				if (vTipoAccion == 'IMPRIME')
				{
					window.open("sesiones_lista_imprime.cfm", "_blank", "modal=yes,location=no,menubar=no,titlebar=no,width=800,height=600,resizable=yes,scrollbars=yes,status=no");
				}
				else if (vTipoAccion == 'NUEVAO')
				{
					window.location = 'sesion_ordinaria.cfm?vTipoComando=NUEVO';
				}
				else if (vTipoAccion == 'NUEVAE')
				{
					window.location = 'sesion_extraordinaria.cfm?vTipoComando=NUEVO';
				}
				else if (vTipoAccion == 'SESIONANT')
				{
					alert('Lo sentimos, la opción no esta disponible')
				}
			}
		</script>
	</head>
	<body>
		<!-- Cintillo con nombre del módulo y filtro--> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">ADMINISTRACI&Oacute;N DE SESIONES &gt;&gt; </span><span class="Sans9Gr">CALENDARIO DE SESIONES</span>
					<cfif #vSesionesTipo# IS "Posterior"><cfoutput>#vAnioPost#</cfoutput></cfif></td>
				<td align="right"><span class="Sans9Gr">Sesi&oacute;n vigente: <cfoutput>#LsNumberFormat(Session.sSesion,'9999')#</cfoutput></span></td>
			</tr>
		</table>
		<!-- Contenido -->
		<table width="100%" border="0">
			<tr>
				<!-- Columna izquierda (comandos) --> 
				<td width="18%" valign="top" class="bordesmenu">
					<!-- Comandos -->
					<table width="95%" border="0">
						<!-- Menú de la lista de sesiones -->
						<tr>
                        	<td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<cfif #Session.sTipoSesionCel# EQ 'O'>
						<!-- Opción: Nueva sesion ordinaria -->
						<tr>
							<td height="20"><input onClick="fClickMenu('NUEVAO');" name="Submit2" type="button" class="botones" value="Nueva ordinaria" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>></td>
						</tr>
                        </cfif>
						<cfif #Session.sTipoSesionCel# EQ 'E'>
						<!-- Opción: Nueva sesion extraordinaria -->
						<tr>
							<td height="20">
								<input onClick="fClickMenu('NUEVAE');" name="Submit22" type="button" class="botones" value="Nueva extraordinaria" <cfif #Session.sTipoSistema# IS 'sic'>disabled</cfif>>
							</td>
						</tr>
                        </cfif>
						<!-- Opción: Imprimir -->
						<tr>
							<td valign="top"><input onClick="fClickMenu('IMPRIME');" name="Submit" type="button" class="botones" value="Imprimir calendario" <cfif #Session.sTipoSesionCel# IS 'E'>disabled</cfif>></td>
						</tr>
						<!---
						<!-- Opción: Sesiones anteriores -->
						<tr>
							<td valign="top">
								<input onclick="fClickMenu('SESIONANT');" name="Submit3" type="button" class="botones" value="Sesiones anteriores">
							</td>
						</tr>
						--->
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
									<cfoutput>#StartRow_sesiones# al #EndRow_sesiones#</cfoutput>
								</span>
								<br>
								<span class="Sans9GrNe">Total: </span>
								<span class="Sans9Gr">
									<cfoutput>#tbCatalogoSesiones.RecordCount#</cfoutput>
								</span>
							</td>
						</tr>
						<!---
						<tr>
						  <td valign="top"><cfoutput>#Session.sTipoSesionCel#</cfoutput></td>
						</tr>
						--->
					</table>
		    	</td>
				<!-- Columna derecha (listado) -->
				<td width="844" valign="top">
					<!-- Titulo -->
					<table width="800" border="0" align="center" class="CuadrosMarron">
						<tr>
							<td>
								<div align="center">
									<span class="Sans12NeNe">CALENDARIO DE SESIONES DEL CTIC</span>
									<br>
									<cfif #Session.sTipoSesionCel# EQ "O">
										<span class="Sans12NeNe">SESIONES ORDINARIAS</span>
										<br>
										<cfoutput>
										<span class="Sans12ViNe">
											<cfif #vMes# LT 7>
												Enero a Julio de #vAnio#
											<cfelseif #vMes# GT 6>
												Junio de #vAnio# a Enero de #vAnioPost#	
										</cfif>
										</span>
										</cfoutput>
									<cfelseif #Session.sTipoSesionCel# EQ "E">
										<span class="Sans12NeNe">SESIONES EXTRAORDINARIAS</span>
									</cfif>
									<br>
								</div>
							</td>
						</tr>
					</table>
					<br>
					<cfif #Session.sTipoSesionCel# EQ "O">
						<table style="width: 800px;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
							<!-- Encabezados -->
							<tr bgcolor="#CCCCCC">
								<td width="135" align="center" bgcolor="#CCCCCC" class="Sans9GrNe">RECEPCI&Oacute;N DE DOCUMENTOS</td>
								<td width="135" align="center" class="Sans9GrNe">REUNI&Oacute;N DE LA CAAA</td>
								<td width="135" align="center" class="Sans9GrNe">ENTREGA DE CORRESPONDENCIA</td>
								<td width="135" align="center" class="Sans9GrNe">SESI&Oacute;N DEL PLENO</td>
								<td width="115" align="center" class="Sans9GrNe">ACTA</td>
								<td width="20" bgcolor="#0066FF"></td>
							</tr>
							<tr><td colspan="6" align="center"><hr></td></tr>
							<!-- Datos -->
							<cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
							<cfset vssnId = #tbCatalogoSesiones.ssn_ID#>
							<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
								SELECT * FROM sesiones WHERE ssn_id = #vssnId# ORDER BY ssn_clave DESC
							</cfquery>
							<tr <cfif #tbSesiones.ssn_id# EQ session.sSesion> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse> onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
								<cfloop query="tbSesiones" startrow="1" endrow="1">
									<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
								</cfloop>
								<cfloop query="tbSesiones" startrow="2" endrow="2">
									<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
								</cfloop>
								<cfloop query="tbSesiones" startrow="3" endrow="3">
									<td align="center"><span class="Sans10Ne">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
								</cfloop>
								<cfloop query="tbSesiones" startrow="4" endrow="4">
									<td align="center" <cfif IsDate(#tbSesiones.ssn_fecha_m#)>bgcolor="##FF9900"</cfif>>
										<span class="Sans10Ne">
											<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
												#LSDateFormat(tbSesiones.ssn_fecha_m,'MMMM dd, yyyy')#
											<cfelse>
												#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#
										</cfif>
										</span>
									</td>
								</cfloop>
								<td align="center"><span class="Sans10Ne">#LSNUMBERFORMAT(tbSesiones.ssn_id,'9999')#</span></td>
								<td colspan="2" align="right">
									<a href="sesion_ordinaria.cfm?vIdSesion=#tbSesiones.ssn_id#&vTipoComando=CONSULTA"><img src="#vCarpetaIMG#/detalle_15.jpg" width="15" height="15" style="border:none;"></a>
								</td>
							</tr>
							<tr><td colspan="7" align="center"><hr></td></tr>
							</cfoutput>
						</table>
					<cfelseif #Session.sTipoSesionCel# EQ "E">
						<table style="width:800px; margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
							<!-- Encabezados -->
							<tr bgcolor="#CCCCCC">
								<td height="20" class="Sans9GrNe">FECHA</td>
							  <td class="Sans9GrNe">LUGAR</td>
								<td width="15" bgcolor="#0066FF"></td>
							</tr>
							<tr><td colspan="7" align="center"><hr></td></tr>
							<!-- Datos -->
							<cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
								<tr <cfif #tbCatalogoSesiones.ssn_id# EQ #Session.sSesion#> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse> onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
									<td class="Sans10Ne">#LSDateFormat(tbCatalogoSesiones.ssn_fecha,'MMMM, dd yyyy')#</td>
									<td class="Sans10Ne">#tbCatalogoSesiones.ssn_sede#</td>
									<!-- Botón VER -->
									<td>
										<a href="sesion_extraordinaria.cfm?vIdSesion=#tbCatalogoSesiones.ssn_id#&vTipoComando=CONSULTA"><img src="#vCarpetaIMG#/detalle_15.jpg" style="border:none;" title="#tbCatalogoSesiones.ssn_id#"></a>
									</td>
								</tr>
								<tr><td colspan="7" align="center"><hr></td></tr>
							</cfoutput>
						</table>
					</cfif>
					<br>
					<cfif #tbCatalogoSesiones.recordcount# GT 6>
						<table width="50%" border="0" align="center" class="CuadrosMarron">
							<cfoutput>
							<tr>
								<td width="23%" align="center">
									<cfif PageNum_sesiones GT 1>
										<a href="#CurrentPage#?PageNum_sesiones=1#QueryString_sesiones#" class="Sans10ViNe">Primero</a>
									</cfif>
								</td>
								<td width="31%" align="center">
									<cfif PageNum_sesiones GT 1>
										<a href="#CurrentPage#?PageNum_sesiones=#Max(DecrementValue(PageNum_sesiones),1)##QueryString_sesiones#" class="Sans10ViNe">Anterior</a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_sesiones LT TotalPages_sesiones>
										<a href="#CurrentPage#?PageNum_sesiones=#Min(IncrementValue(PageNum_sesiones),TotalPages_sesiones)##QueryString_sesiones#" class="Sans10ViNe">Siguiente</a>
									</cfif>
								</td>
								<td width="23%" align="center">
									<cfif PageNum_sesiones LT TotalPages_sesiones>
										<a href="#CurrentPage#?PageNum_sesiones=#TotalPages_sesiones##QueryString_sesiones#" class="Sans10ViNe">Último</a>
									</cfif>
								</td>
							</tr>
							</cfoutput>
						</table>
					</cfif>
				</td>
			</tr>
		</table>
	</body>
</html>
