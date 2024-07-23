					<!--- CREADO: ARAM PICHARDO DURÁN--->
					<!--- EDITO: ARAM PICHARDO DURÁN --->
					<!--- FECHA CREA: 16/06/2015 --->
					<!--- FECHA MOD: 29/08/2018 --->
					<!--- LISTA DE SESIONES DEL CTIC (ORDEN DEL DÍA) --->
					
					<cfparam name="vpAnio" default=0>
					<cfparam name="vpSsnId" default=0>
					<cfparam name="vRPP" default=25>
					<cfparam name="vpSesionTipo" default='1'>
					<cfparam name="vPagina" default=1>

					<!--- Registrar paginación --->
                    <cfif IsDefined('vPagina')>
                        <cfset Session.OrdenDiaFiltro.vPagina = #vPagina#>
                    <cfelse>
                        <cfset PageNum = #Session.OrdenDiaFiltro.vPagina#>
                    </cfif>
                    <cfif IsDefined('vRPP')><cfset Session.OrdenDiaFiltro.vRPP = #vRPP#></cfif>
					
					<cfset Session.sTipoSesionCel = #vpSesionTipo#>
					
					<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM sesiones 
						WHERE 1 = 1
							<cfif #Session.sTipoSesionCel# EQ "1">
								AND ssn_clave = 1 AND ssn_id <= #Session.sSesion#
							<cfelseif #Session.sTipoSesionCel# EQ "2">
								AND ssn_clave = 2 
							</cfif>
							<cfif #vpAnio# GT 0>
								AND YEAR(ssn_fecha) = #vpAnio#
							</cfif>
							<cfif #vpSsnId# GT 0> <!--- SE AGREGÓ LA BÚSQUEDA POR SESIÓN (29/08/2018)--->
								AND ssn_id = #vpSsnId#
							</cfif>
						ORDER BY ssn_id DESC
					</cfquery>
					
					<!-- Liste de registros -->
					<div align="center">
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
					<!--- Variables de paginación --->
                    <cfset vConsultaTabla = tbSesionOrden>
                    <cfset vConsultaFiltro = Session.OrdenDiaFiltro>
                    <cfset vConsultaFuncion = "fListarOrdenDia">
					<cfinclude template="#vCarpetaINCLUDE#/paginacion_variables.cfm">
					<!--- Controles de paginación --->
                    <cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">
					<table style="width: 90%; padding: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1" align="center">
						<tr bgcolor="#CCCCCC">
							<td width="10%" height="20"><span class="Sans9GrNe">SESI&Oacute;N</span></td>
							<td width="46%"><span class="Sans9GrNe">LUGAR</span></td>
							<td width="30%"><span class="Sans9GrNe">FECHA</span></td>
							<td width="10%" align="center"><span class="Sans9GrNe">PUNTOS</span></td>
							<td width="2%" bgcolor="#FFBC81"></td>
							<td width="2%" bgcolor="#0066FF"></td>
						</tr>
						<cfoutput query="tbSesionOrden" startRow="#StartRow#" maxRows="#MaxRows#">
							<cfset vIdSsn = #tbSesionOrden.ssn_id#>
                            <cfset vCarpetaArchivoOd = ''>
                            <cfquery name="tbOrdenDia" datasource="#vOrigenDatosSAMAA#">
                                SELECT COUNT(*) AS numero FROM sesiones_orden WHERE ssn_id = #vIdSsn#
                            </cfquery>
							<tr <cfif #tbSesionOrden.ssn_id# EQ session.sSesion> bgcolor="##FFCC00" onMouseOver="this.style.backgroundColor='##D8D8D8'" onMouseOut="this.style.backgroundColor='##FFCC00'"<cfelse>onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'"</cfif>>
								<td height="18"><span class="Sans10Ne">#tbSesionOrden.ssn_id#</span></td>
								<td><span class="Sans10Ne">#tbSesionOrden.ssn_sede#</span></td>
								<td><span class="Sans10Ne">#LSDateFormat(tbSesionOrden.ssn_fecha,'MMMM dd, yyyy')#</span></td>
								<td align="center"><span class="Sans10Ne">#tbOrdenDia.numero#</span></td>
								<!-- Botón VER -->
								<td>
		                            <cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_#ssn_id#.pdf'>
        		                    <cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #ssn_id# & '.pdf'>
									<cfif FileExists(#vCarpetaArchivoOd#)>
										<img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15px" style="border:none;cursor:pointer;" title="Ver documentos en PDF" onclick="fPdfAbrir('ORDENDIA_#ssn_id#.pdf','ORDENDIA','', '');">
                                        <!---
										<a href="#vWebArchivoOd#" target="WIN_ORDENDIA"><img src="#vCarpetaICONO#/pdf_icon_2017.png" width="15" style="border:none;" title="#tbSesionOrden.ssn_id#"></a>
										--->
									</cfif>
								</td>
								<td>
									<a href="orden_dia.cfm?vIdSsn=#tbSesionOrden.ssn_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;" title="#tbSesionOrden.ssn_id#"></a>
                                </td>
							</tr>
						</cfoutput>
					</table>

					<!--- Controles de paginación --->
                    <cfinclude template="#vCarpetaINCLUDE#/paginacion.cfm">
					<!--- Total de registros --->
					<cfoutput>
                        <input id="vPagAct" type="hidden" value="#vRPP#">
                        <input id="vRegRan" type="hidden" value="<cfif tbSesionOrden.RecordCount GT 0>#StartRow# al #EndRow#<cfelse>0</cfif>">
                        <input id="vRegTot" type="hidden" value="#tbSesionOrden.RecordCount#">
                    </cfoutput>
