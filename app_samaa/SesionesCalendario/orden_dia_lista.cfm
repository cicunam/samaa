					<!--- CREADO: ARAM PICHARDO DURÁN--->
					<!--- EDITO: ARAM PICHARDO DURÁN --->
					<!--- FECHA CREA: 16/06/2015 --->
					<!--- FECHA MOD: 16/06/2015 --->
					<!--- LISTA DE SESIONES DEL CTIC (ORDEN DEL DÍA) --->
					
					<cfparam name="vpAnio" default=0>
					<cfparam name="vRPP" default=25>
					<cfparam name="vpSesionTipo" default='O'>
					<cfparam name="vPagina" default=1>

					<!--- Registrar paginación --->
                    <cfif IsDefined('vPagina')>
                        <cfset Session.OrdenDiaFiltro.vPagina = #vPagina#>
                    <cfelse>
                        <cfset PageNum = #Session.OrdenDiaFiltro.vPagina#>
                    </cfif>
                    <cfif IsDefined('vRPP')><cfset Session.OrdenDiaFiltro.vRPP = #vRPP#></cfif>
					<cfset Session.OrdenDiaFiltro.vAnioConsulta = #vpAnio#>
					
					<cfset Session.sTipoSesionCel = #vpSesionTipo#>
					
					<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM sesiones 
						WHERE 1 = 1
							<cfif #Session.sTipoSesionCel# EQ "O">
								AND ssn_clave = 1 AND ssn_id <= #Session.sSesion#
							<cfelseif #Session.sTipoSesionCel# EQ "E">
								AND ssn_clave = 2 
							</cfif>
							<cfif #vpAnio# GT 0>
								AND YEAR(ssn_fecha) = #vpAnio#
							</cfif>
						ORDER BY ssn_id DESC
					</cfquery>
                    
					<!-- Liste de registros -->
					<div align="center">
						<h4>
                        <strong>
						<cfif #Session.sTipoSesionCel# EQ "O">
							SESIONES ORDINARIAS
						<cfelseif #Session.sTipoSesionCel# EQ "E">
							SESIONES EXTRAORDINARIAS
						</cfif>
						</strong>
						</h4>                        
					</div>

					</div>
					<!--- Variables de paginación --->
                    <cfset vConsultaTabla = tbSesionOrden>
                    <cfset vConsultaFiltro = Session.OrdenDiaFiltro>
                    <cfset vConsultaFuncion = "fListarOrdenDia">
					<cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_variables.cfm">

					<!--- Controles de paginación --->
                    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_bs.cfm">

                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <td width="10%"><strong>SESI&Oacute;N</strong></td>
                                <td width="40%"><strong>LUGAR</strong></td>
                                <td width="30%"><strong>FECHA</strong></td>
                                <td width="10%" align="center"><strong>PUNTOS</strong></td>
                                <td width="3%"></td>
                                <td width="3%"></td>
                            </tr>
                        </thead>
						<tbody>
							<cfoutput query="tbSesionOrden" startRow="#StartRow#" maxRows="#MaxRows#">
                                <cfset vIdSsn = #tbSesionOrden.ssn_id#>
                                <cfset vCarpetaArchivoOd = ''>
                                <cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_' & #ssn_id# & '.pdf'>
                                <cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #ssn_id# & '.pdf'>                        
        
                                <cfquery name="tbOrdenDia" datasource="#vOrigenDatosSAMAA#">
                                    SELECT COUNT(*) AS numero FROM sesiones_orden WHERE ssn_id = #vIdSsn#
                                </cfquery>
                                <tr <cfif #ssn_id# EQ #Session.sSesion#>style="background-color:##FFFFCC; color:##FF3300;"</cfif>>
                                    <td><span class="Sans10Ne">#tbSesionOrden.ssn_id#</span></td>
                                    <td><span class="Sans10Ne">#tbSesionOrden.ssn_sede#</span></td>
                                    <td><span class="Sans10Ne">#LSDateFormat(tbSesionOrden.ssn_fecha,'MMMM dd, yyyy')#</span></td>
                                    <td align="center"><span class="Sans10Ne">#tbOrdenDia.numero#</span></td>
                                    <!-- Botón VER -->
                                    <td>
                                        <cfif FileExists(#vCarpetaArchivoOd#)>
											<a href="#vWebArchivoOd#" target="WIN_ORDENDIA"><span class="glyphicon glyphicon-open-file" title="#tbSesionOrden.ssn_id#"></a>
                                        </cfif>
                                    </td>
                                    <td>
                                        <a href="?vMenuActivoM8=2&vSsnId=#tbSesionOrden.ssn_id#&vTipoComando=C">
											<span class="glyphicon glyphicon-open" title="#tbSesionOrden.ssn_id#"></span>
										</a>
                                    </td>
                                </tr>
                            </cfoutput>                        
						</tbody>
					</table>

					<!--- Controles de paginación --->
                    <cfinclude template="#vCarpetaRaizLogica#/includes/paginacion_bs.cfm">

					<cfoutput>
                        <input id="vPagAct" type="hidden" value="#vRPP#">
                        <input id="vRegRan" type="hidden" value="<cfif tbSesionOrden.RecordCount GT 0>#StartRow# al #EndRow#<cfelse>0</cfif>">
                        <input id="vRegTot" type="hidden" value="#tbSesionOrden.RecordCount#">
                    </cfoutput>