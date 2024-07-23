<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 22/05/2019 --->
<!--- FECHA ULTIMA MOD.: 16/06/2022 --->
<!--- INCLUDE QUE PERMITE LISTAR LOS INFORMES ANUALES QUE REVISARÁ EL CTIC --->


						<cfquery name="tbAsuntosInformesTemp" dbtype="query">
							SELECT * FROM tbAsuntosInformes
							WHERE
							<cfif #vDecClaveCi# EQ 'NE'>
	                             dec_clave_ci BETWEEN 50 AND 60
							<cfelse>								
								dec_clave_ci = #vDecClaveCi#
							</cfif>
						</cfquery>
                        <cfif #tbAsuntosInformesTemp.RecordCount# GT 0>
                            <div class="row">
                                <div class="col-sm-1 col-md-1 col-lg-1"></div>
                                <div class="col-sm-11 col-md-11 col-lg-11">
                                    <ol class="breadcrumb text-center" style="background-color:#FFC">
                                        <li>
                                            <h6>
                                                <strong>
                                                    <cfif #vDecClaveCi# EQ 1>Aprobados
                                                    <cfelseif #vDecClaveCi# EQ 49>Aprobados con comentario
                                                    <cfelseif #vDecClaveCi# EQ 4>No aprobados
                                                    <cfelseif #vDecClaveCi# EQ 'NE'>No evaluados
                                                    </cfif>
                                                </strong>
                                                <span data-toggle="collapse" data-target="#<cfoutput>#vDecClaveCi#</cfoutput>" class="glyphicon glyphicon-folder-open" style="cursor:pointer;" title="Expandir"></span>
                                            </h6>
                                        </li>
                                    </ol>
                                    <div id="<cfoutput>#vDecClaveCi#</cfoutput>" class="collapse">
                                        <table id="#pleno_id#" class="table table-striped table-hover table-condensed">
                                            <thead>
                                                <tr class="header">
                                                    <th width="60%">Nombre</th>
                                                    <th width="10%">Entidad</th>
                                                    <th width="25%" align="center">CCN</th>
                                                    <th width="5%" align="center"><cfif #vDecClaveCi# EQ 4>PDF</cfif></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <cfoutput query="tbAsuntosInformesTemp">
                                                    <cfset vArchivoPdf = '#acd_id#_#informe_anual_id#_#informe_anio#.pdf'>
                                                    <cfset vArchivoInformePdf = #vCarpetaInformesAnuales# & #vArchivoPdf#>
                                                    <cfset vArchivoInformePdfWeb = #vWebInformesAnuales# & #vArchivoPdf#>
                                                    <tr>
                                                        <td align="left">#acd_prefijo# #acd_nombres# #acd_apepat# #acd_apemat#</td>
                                                        <td>#dep_siglas#</td>
                                                        <td>#cn_siglas_nom#</td>                                                    
                                                        <td align="center">
                                                            <cfif FileExists(#vArchivoInformePdf#)>
                                                                <a href="#vArchivoInformePdfWeb#" target="winPdfOrden">
                                                                    <span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span>
                                                                </a>
                                                            </cfif>
                                                        </td>
                                                    </tr>
                                                </cfoutput>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </cfif>

