					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 30/05/2016 --->
					<!--- FECHA ULTIMA MOD.: 31/05/2016 --->
					<!--- MÓDULO QUE GENERA UN CÁTALOGO INSERTO EN UN SELECT CON LA LISTA DE LAS ENTIDADES DE SUBSISTEMA --->

							<cfset vFiltro = "#Session[attributes.filtro]#">
                            <cfset vFuncion = "#attributes.funcion#">
                            <cfset vOrigenDatosCATALOGOS = "#attributes.origendatos#">

							<!--- Obtener la lista de dependencias del SIC (CATÁLOGOS GENERALES MYSQL) --->
                            <cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
                                SELECT dep_clave, dep_siglas
                                FROM catalogo_dependencias
                                WHERE dep_clave LIKE '03%'
                                <cfif #Session.sUsuario# NEQ 'aram_st' AND #Session.sUsuarioNivel# LT 5>
									AND dep_tipo <> 'PRO'<!--- AND (dep_tipo = 'CEN' OR dep_tipo = 'INS' OR dep_tipo = 'UPE') --->
									AND dep_status = 1
								<cfelseif #Session.sUsuarioNivel# EQ 20> 
									AND (dep_clave = '030101' OR dep_tipo = 'UPE')
									AND dep_status = 1                                
                                </cfif>
								<!--- AND dep_tipo <> 'PRO' --->
                                AND dep_status = 1
                                ORDER BY dep_tipo, dep_siglas
                            </cfquery>
                    
							<!-- Entidades -->
							<tr>
								<td valign="top">
									<span class="Sans9GrNe">Entidad:<br></span>
									<select name="vDepClave" id="vDepClave" class="datos" style="width:95%;" <cfoutput>onchange="#vFuncion#(1,'#vFiltro.vOrden#','#vFiltro.vOrdenDir#')"</cfoutput>>
										<option value="">-- TODAS LAS ENTIDADES ---</option>
										<cfoutput query="ctDependencia">
											<option value="#dep_clave#" <cfif isDefined("vFiltro.vDep") AND #dep_clave# EQ #vFiltro.vDep#>selected</cfif>>#dep_siglas#</option>
										</cfoutput>
									</select>
								</td>
							</tr>                    