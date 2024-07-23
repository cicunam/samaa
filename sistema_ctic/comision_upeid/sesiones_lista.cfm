<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 24/01/2018 --->

					<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
					<cfparam name="PageNum_sesiones" default="1">
					<cfparam name="vpAnio" default="0">

					<cfquery name="tbSesionesCeUpeid" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM sesiones 
                        WHERE ssn_clave = 20
                        <cfif #vpAnio# NEQ 0>
							AND YEAR(ssn_fecha) = #vpAnio#
						</cfif>
                        ORDER BY ssn_fecha DESC
					</cfquery>

					<cfset MaxRows_sesiones=50>
					<cfset StartRow_sesiones=Min((PageNum_sesiones-1)*MaxRows_sesiones+1,Max(tbSesionesCeUpeid.RecordCount,1))>
					<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,tbSesionesCeUpeid.RecordCount)>
					<cfset TotalPages_sesiones=Ceiling(tbSesionesCeUpeid.RecordCount/MaxRows_sesiones)>
					<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
					<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_sesiones=","&")>
					<cfif tempPos NEQ 0>
						<cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
					</cfif>
                    
					<div class="container table_responsive" style="width:80%;">
                        <table class="table table-striped table-hover table-condensed">
                            <thead>
                                <tr class="header">
                                    <td width="45%"><strong>Fecha de Reuni&oacute;n de la Comisi&oacute;n Especial</strong></td>
                                    <td width="50%"><strong>Notas / comentarios</strong></td>
                                    <td width="5%"></td>                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="tbSesionesCeUpeid" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
                                    <tr>
										<td>#LSDateFormat(tbSesionesCeUpeid.ssn_fecha,'MMMM dd, yyyy')#</td>
										<td>#ssn_nota#</td>                                        
										<td align="center">
											<cfif #ssn_id# EQ #Session.CeUpeidFiltro.SsnIdCeUpeid# AND #ssn_fecha# GTE #NOW()#>
                                                <a href="sesion_detalle.cfm?vSsnId=#ssn_id#&vTipoComando=ED" data-toggle="modal" data-target="###ssn_id#">
                                                    <span class="glyphicon glyphicon-edit"></span>
                                                </a>
                                                <div id="#ssn_id#" class="modal fade" role="dialog">
                                                    <div class="modal-dialog">
                                                        <div class="modal-content">
                                                            <!-- Content will be loaded here from "remote.php" file -->
                                                        </div>
                                                    </div>
                                                </div>
											</cfif>
										</td>
                                    </tr>
                                </cfoutput>
								<tr class="success">
                                	<td colspan="2"><strong><em>Agregar nueva reuni&oacute;n de la comisi&oacute;n...</em></strong></td>
	                                <td align="center">
										<a href="sesion_detalle.cfm?vSsnId=0&vTipoComando=NV" data-toggle="modal" data-target="#0">
											<span class="glyphicon glyphicon-plus"></span>
										</a>
                                        <div id="0" class="modal fade" role="dialog">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <!-- Content will be loaded here from "remote.php" file -->
                                                </div>
                                            </div>
                                        </div>
									</td>
    	                        </tr>
                            </tbody>
                        </table>
					</div>