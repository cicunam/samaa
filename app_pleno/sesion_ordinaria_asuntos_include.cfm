<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 26/04/2017 --->
<!--- FECHA ULTIMA MOD.: 03/12/2019--->
<!--- INCLUDE QUE PERMITE VER LA INFORMACIÓN DE UNA O MÁS SESIONES --->


		<cfset vDiasLimite = 5.50>
        <cfset vDiasCtic = (#tbSesion.ssn_fecha# - #NOW()#)>
		<br /><br />
		<cfif #CGI.SERVER_PORT# IS '31221'>
			<cfoutput> DIAS DIFERENCIA: #vDiasCtic# - LÍMITE DÍAS: #vDiasLimite#</cfoutput>
		</cfif>			
		<div class="row text-center">
            <ol class="breadcrumb" style="background-color:#FF9;">                
				<cfoutput>
                <li><h4><strong>Documentos digitalizados de los asuntos que pasan a la Sesi&oacute;n<cfif #tbSesionDoble.RecordCount# EQ 1> #vSesionMuestra# <a name="#vSesionMuestra#"></a></cfif></strong></h4></li>
				</cfoutput>
            </ol>
		</div>
		<br />
		<cfif #vDiasCtic# LTE #vDiasLimite#><!--- SE VALIDAN LOS DÍAS PARA DESPLEGAR LA INFORMACIÓN EN CASO DE NO TENER EL ORDEN DEL DÍA 09/04/2019 ---> <!---#tbOrdenDia.recordCount# GT 0 AND --->
            <cfoutput query="tbPlenoSesion">
                <cfif #pleno_id# EQ "02" OR #pleno_id# EQ "03" OR #pleno_id# EQ "06" OR #pleno_id# EQ "10" OR #pleno_id# EQ "09" OR #pleno_id# EQ "12" >
                    <cfquery name="tbAsuntosPleno" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM ((((movimientos_solicitud 
                        LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
                        LEFT JOIN catalogo_cn ON
                        CASE
                            WHEN movimientos_solicitud.sol_pos3 IS NULL OR movimientos_solicitud.sol_pos8 IS NOT NULL THEN
                                movimientos_solicitud.sol_pos8
                            ELSE
								movimientos_solicitud.sol_pos3
                        END
                            = catalogo_cn.cn_clave
                        )
                        LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
                        LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave)
                        LEFT JOIN catalogo_dependencia ON movimientos_solicitud.sol_pos1 = catalogo_dependencia.dep_clave
                        WHERE movimientos_asunto.ssn_id = #vSesionMuestra# 
						AND movimientos_asunto.asu_reunion = 'CTIC'
                        <cfif #pleno_id# EQ '02'> <!--- INVESTIGADORES --->
                            AND catalogo_cn.cn_siglas LIKE 'INV%' 
                            AND (movimientos_asunto.asu_parte = 3 OR movimientos_asunto.asu_parte = 2.2) 
							<!--- se agregaron asuntos por ausencia 2.2 (II.III) 11/11/2015 --->
                            <!--- AND movimientos_solicitud.mov_clave <> 19)---> <!--- SE ELIMINÓ A SOLICITUD DE LA ST-CTIC 30/08/2017 --->
							<!--- AND movimientos_solicitud.mov_clave <> 10) ---> 
							<!--- SE ANEXARON LAS SEMBLANZAS DE PROMOCIONES A TITULAR C A SOLICITUD DE BEATRIZ CRUZ 20/11/2019 --->
                        <cfelseif #pleno_id# EQ '03'> <!--- TÉCNICOS --->
                            AND catalogo_cn.cn_siglas LIKE 'TEC%' 
                            AND (movimientos_asunto.asu_parte = 3 OR movimientos_asunto.asu_parte = 2.2) <!--- se agregaron asuntos por ausencia 2.2 (II.III) 11/11/2015 --->
                        <cfelseif #pleno_id# EQ '06'> <!--- OBJETADOS --->
                            AND movimientos_asunto.asu_parte BETWEEN 4.1 AND 4.4
                        <cfelseif #pleno_id# EQ '09'> <!--- SEMBLANZAS ---> 
                            AND (movimientos_solicitud.mov_clave = 10 OR movimientos_solicitud.mov_clave = 19) 
                            AND movimientos_solicitud.sol_pos8 = 'I6696' <!--- se agregaron los nuevos dictamenes 11/11/2015 --->
                            AND movimientos_asunto.asu_parte = 3 <!--- se agregó para ver solo las promociones en la parte 3 21/02/2017 --->
                        <cfelseif #pleno_id# EQ '10'> <!--- SABÁTICOS --->
                            AND (movimientos_solicitud.mov_clave = 30 OR movimientos_solicitud.mov_clave = 32)
                        <cfelseif #pleno_id# EQ '12'> <!--- CÁTEDRAS CONACyT --->
                            AND movimientos_solicitud.mov_clave = 44
                        </cfif>
                        ORDER BY catalogo_dependencia.dep_siglas, academicos.acd_apepat, academicos.acd_apemat, academicos.acd_nombres
                    </cfquery>
                    <cfif #tbAsuntosPleno.RecordCount# GT 0>                
                        <div class="row text-center">
                            <ol class="breadcrumb" style="background-color:##E8E8E8;">                
                                <li><h5><strong>#tbPlenoSesion.nombre#</strong></h5></li>
                            </ol>
                        </div>
                        <div class="row">
                            <table id="#pleno_id#" class="table table-striped table-hover table-condensed">
                                <thead>
                                    <tr class="header">
                                        <th width="50%">Nombre</th>
                                        <th width="10%">Entidad</th>
                                        <th width="30%">Movimiento</th>
                                        <th width="5%">PDF</th>
                                        <th width="5%"></th>                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop query="tbAsuntosPleno">
                                        <cfset vArchivoPdf = #sol_pos2# & '_' & #sol_id# & '.pdf'>
                                        <cfset vArchivoPlenoPdf = #vCarpetaCAAA# & #vArchivoPdf#>
                                        <cfset vArchivoPlenoPdfWeb = #vWebCAAA# & #vArchivoPdf#>
                                        <tr>
                                            <td>#acd_prefijo# #acd_nombres# #acd_apepat# #acd_apemat#</td>
                                            <td>#dep_siglas#</td>
                                            <td>
												#mov_titulo_corto#
												<cfif #mov_clave# EQ 9 OR #mov_clave# EQ 10 OR #mov_clave# EQ 19>
													<span class="small"><strong>(#cn_siglas_nom#)</strong></span>
												</cfif>
											</td>
                                            <td align="center">
                                                <cfif FileExists(#vArchivoPlenoPdf#)>
                                                    <a href="#vArchivoPlenoPdfWeb#" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span></a>
                                                </cfif>
                                            </td>
                                            <td align="center">
                                                <!--- #Session.sTipoSistema# #Session.sUsuarioNivel# --->
                                                <cfif #Session.sTipoSistema# EQ 'sic' AND (#Session.sUsuarioNivel# EQ 1 OR #Session.sUsuarioNivel# EQ 32)>
                                                    <cfinclude template="voto_asuntos/voto_AsuntosPleno.cfm">
                                                </cfif>
                                                <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# EQ 0>
                                                    <cfinclude template="voto_asuntos/voto_SeleccionAsuntos.cfm">                                           
                                                </cfif>
                                                
                                            </td>
                                        </tr>
                                    </cfloop>
                                    <cfif #vSesionMuestra# EQ 1535 AND #tbPlenoSesion.pleno_id# EQ '06'>
<!---
                                        <tr>
                                            <td>DR. HECTOR GERARDO RIVEROS ROTGE</td>
                                            <td>IF</td>
                                            <td>Informe anual</td>
                                            <td align="center">
                                                <cfif FileExists('#vCarpetaCAAA#/1318_16692_2016.pdf')>
                                                    <a href="#vWebCAAA#/1318_16692_2016.pdf" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span></a>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>LUIS RODOLFO MEZA PEREDO</td>
                                            <td>CCA</td>
                                            <td>Informe anual</td>
                                            <td align="center">
                                                <cfif FileExists('#vCarpetaCAAA#/984_18184_2016.pdf')>
                                                    <a href="#vWebCAAA#/984_18184_2016.pdf" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span></a>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>ROSALBA JUAREZ GARDUÑO</td>
                                            <td>CCADET</td>
                                            <td>Informe anual</td>
                                            <td align="center">
                                                <cfif FileExists('#vCarpetaCAAA#/4759_18316_2016.pdf')>
                                                    <a href="#vWebCAAA#/4759_18316_2016.pdf" target="winPdf"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span></a>
                                                </cfif>
                                            </td>
                                        </tr>
--->										
									</cfif>
                                </tbody>
                            </table>
                        </div>
                    </cfif>
                </cfif>
                <!--- ************ MUESTRA LAS BECAS POSDOCTORALES ************ --->
                <cfif #pleno_id# EQ '04' AND #tbSesionBP.RecordCount# EQ 1>
                    <div class="row text-center">
                        <ol class="breadcrumb" style="background-color:##E8E8E8;">                
                            <li>
                                <h5><strong>#tbPlenoSesion.nombre#</strong></h5>
                            </li>
                        </ol>
                    </div>
                    <div class="row">
                        <table id="#pleno_id#" class="table table-striped table-hover table-condensed">
                            <tbody>
                                <tr>
                                    <td width="96%">LISTADO DE BECARIOS POSDOCTORALES</td>
                                    <td width="4%"><a href="posdoctorales_lista.cfm" target="winPosdoc"><span class="glyphicon glyphicon-folder-open" style="cursor:pointer;" title="Abrir listado"></span></a></td>
                                </tr>
                            </tbody>
                        </table>
					</div>
                </cfif>
                <!--- ************ MUESTRA LOS INFORMES ANUALES ************ --->
                <cfif #pleno_id# EQ '07' AND #tbSesionInformeAnual.RecordCount# EQ 1>
                    <cfquery name="tbAsuntosInformes" datasource="#vOrigenDatosSAMAA#">
                        SELECT
                        T1.informe_anual_id, T1.informe_anio, T1.dec_clave_ci,
                        T3.asu_numero,
                        T2.acd_id, T2.acd_prefijo, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres,
                        C2.cn_siglas_nom,
                        C1.dep_siglas
                        FROM movimientos_informes_anuales AS T1
                        LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                        LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.informe_reunion = 'CTIC'
                        LEFT JOIN catalogo_dependencia AS C1 ON T1.dep_clave = C1.dep_clave
                        LEFT JOIN catalogo_cn AS C2 ON T1.cn_clave = C2.cn_clave
						WHERE T3.ssn_id = #Session.sSesion#
					    AND T1.informe_status = 3
                        ORDER BY C1.dep_orden, T2.acd_apepat, T2.acd_apemat
					</cfquery>
					<cfif #tbAsuntosInformes.RecordCount# GT 0>
                        <div class="row text-center">
                            <ol class="breadcrumb" style="background-color:##E8E8E8;">
                                <li>
                                    <h5><strong>#tbPlenoSesion.nombre#</strong></h5>
                                </li>
                            </ol>
                        </div>
						<cfset vDecClaveCi = 1>
                        <cfinclude template="informes_anuales_lista.cfm">
						<cfset vDecClaveCi = 49>
						<cfinclude template="informes_anuales_lista.cfm">
						<cfset vDecClaveCi = 4>
						<cfinclude template="informes_anuales_lista.cfm">
						<cfset vDecClaveCi = 'NE'>
						<cfinclude template="informes_anuales_lista.cfm">                                                						
<!---
                        <div class="row">
                            <table id="#pleno_id#" class="table table-striped table-hover table-condensed">
                                <thead>
                                    <tr class="header">
                                        <th width="50%">Nombre</th>
                                        <th width="10%">Entidad</th>
                                        <th width="35%">Movimiento</th>
                                        <th width="5%" align="center">PDF</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop query="tbAsuntosInformes">
                                        <cfset vArchivoPdf = '#tbAsuntosInformes.acd_id#_#tbAsuntosInformes.informe_anual_id#_#tbAsuntosInformes.informe_anio#.pdf'>
                                        <cfset vArchivoInformePdf = #vCarpetaInformesAnuales# & #vArchivoPdf#>
                                        <cfset vArchivoInformePdfWeb = #vWebInformesAnuales# & #vArchivoPdf#>
                                        <tr>
                                            <td>#tbAsuntosInformes.acd_prefijo# #tbAsuntosInformes.acd_nombres# #tbAsuntosInformes.acd_apepat# #tbAsuntosInformes.acd_apemat#</td>
                                            <td>#tbAsuntosInformes.dep_siglas#</td>
                                            <td>INFORME ANUAL</td>
                                            <td align="center">
												<cfif FileExists(#vArchivoInformePdf#)>
                                                    <a href="#vArchivoInformePdfWeb#" target="winPdfOrden">
                                                        <span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span>
                                                    </a>
												</cfif>
                                            </td>
                                        </tr>
									</cfloop>
								</tbody>
							</table>
						</div>
--->						
					</cfif>
				</cfif>
                <!--- ************ MUESTRA LOS ESTÍMULOS ACADÉMICOS DE LA DGAPA ************ --->
                <cfif #pleno_id# EQ "15">
                    <cfset vSesionPlenoPdf1 = #vCarpetaSesionOtros# & 'ESTIMULOS_DGAPA_' & #tbSesion.ssn_id# & '.pdf'>
                    <cfset vSesionPlenoPdfWeb1 = #vWebSesionOtros#  & 'ESTIMULOS_DGAPA_' & #tbSesion.ssn_id# & '.pdf'>
                    <cfif FileExists(#vSesionPlenoPdf1#)>
                        <div class="row text-center">
                            <ol class="breadcrumb" style="background-color:##E8E8E8;">                
                                <li>
                                    <h5><strong>#tbPlenoSesion.nombre#</strong>
                                    </h5>
                                </li>
                            </ol>
                        </div>
                        <div class="row">
                            <table id="#pleno_id#" class="table table-striped table-hover table-condensed">
<!---
                                <thead>
                                    <tr class="header">
                                        <th width="95%">Nombre</th>
                                        <th width="5%">PDF</th>
                                    </tr>
                                </thead>
--->
                                <tbody>
                                    <tr>
                                        <td width="96%">LISTADO DE LOS PROGRAMAS DE ESTÍMULOS DEL PERSONAL ACADÉMICO</td>
                                        <td width="4%">
                                        	<a href="#vSesionPlenoPdfWeb1#" target="winPdfOrden">
                                            	<span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="Abrir archivo"></span>
											</a>
										</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </cfif>
                </cfif>
            </cfoutput>
        </cfif>
