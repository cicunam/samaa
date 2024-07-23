<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 29/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 29/05/2017 --->
<!--- INCRUSTA POR FILA LOS MANÚS QUE SE ENCUANTRAN EN LA BASE DE DATOS --->

							<cfoutput>
							<div class="#vSizeScreenMenu#">
								<div class="well" style="padding-top:12px;" align="center">
									<div class="alert alert-info fade in text-center" style="background-color:##7BA7D2; height:35px; padding-top:1px;">
										<h6 style="color:##FFFFFF;"><span class="glyphicon glyphicon-th-list"></span> <strong>#UCASE(menu_nombre)#</strong></h6>
									</div>
                                    <div class="alert alert-info fade in text-center" style="cursor:pointer; width:90%; height:80px; background-color:##FFFFFF;" onClick="fMenuLocation('#ruta_liga#');">
										<cfif #menu_clave# EQ 3 AND #Session.sTipoSistema# EQ 'sic'>
	                                        <h6 style="color:##333;">#menu_descrip#</h6><!--- EL MÓDULO DE INFORMES SE ABRE TEMPORALMENTE --->
                                        <cfelse>
	                                        <h6 style="color:##333;">#menu_descrip#</h6>
										</cfif>                                            
                                    </div>
                            	</div>
							</div>
							</cfoutput>