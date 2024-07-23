<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 26/04/2017 --->
<!--- FECHA ULTIMA MOD.: 25/05/2018 --->
<!--- INCLUDE QUE PERMITE VER LA INFORMACIÓN DE UNA O MÁS SESIONES --->

		<div class="container-fluid text-center">
			<div class="row content">
				<div class="col-sm-1 col-md-1 col-lg-2"></div>
				<div class="col-sm-10 col-md-10 col-lg-8 text-justify">
					<div class="row content">
                        <h4>
                            <cfoutput>
                            Agradecer&eacute; a ustedes su asistencia a la #vTipoSesionCtic# del Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica, que se llevar&aacute; a cabo el
                            <strong>#LsDateFormat(tbSesion.ssn_fecha,'dddd')# #LsDateFormat(tbSesion.ssn_fecha,'dd')# de #LsDateFormat(tbSesion.ssn_fecha,'mmmm')#</strong>, 
                            a partir de las <strong>#LsTimeFormat(tbSesion.ssn_fecha,'hh:mm')# horas</strong>, <strong>#tbSesion.ssn_sede#</strong>, de acuerdo con el siguiente:
                            </cfoutput>
                        </h4>
					</div>
					<br><br>
                    <div class="row content text-center">
						<ol class="breadcrumb" style="background-color:#FF9;">
							<li><h4><strong>Orden del d&iacute;a</strong></h4></li>
						</ol>
                    </div>
					<br>
					<div class="row content">
                        <table id="tOrdenDia" class="table table-striped table-hover">
<!---
                            <thead>
                                <tr class="header">
                                    <th colspan="3" class="text-center"><h4><strong>Orden del día</strong></h4></th>
                                </tr>
                            </thead>
--->
							<tbody>
								<cfoutput query="tbOrdenDia">

                                    <cfset vSesionPlenoPdf1 = ''>
                                    <cfif #punto_pdf# NEQ ''>
                                        <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                            <cfset vSesionPlenoPdf1 = #vCarpetaSesionHistoria# & #punto_pdf#>
                                            <cfset vSesionPlenoPdfWeb1 = #vWebSesionHistoria# & #punto_pdf#>
										<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
                                            <cfset vSesionPlenoPdf1 = #vCarpetaAcademicos# & #punto_pdf#>
                                            <cfset vSesionPlenoPdfWeb1 = #vWebAcademicos# & #punto_pdf#>
										<cfelse>
                                            <cfset vSesionPlenoPdf1 = #vCarpetaSesionOtros# & #punto_pdf#>
                                            <cfset vSesionPlenoPdfWeb1 = #vWebSesionOtros# & #punto_pdf#>
                                        </cfif>
                                    </cfif>
                                    <!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF_2 --->
                                    <cfset vSesionPlenoPdf2 = ''>
                                    <cfif #punto_pdf_2# NEQ ''>
                                        <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                            <cfset vSesionPlenoPdf2 = #vCarpetaSesionHistoria# & #punto_pdf_2#>
                                            <cfset vSesionPlenoPdfWeb2 = #vWebSesionHistoria# & #punto_pdf_2#>
										<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
                                            <cfset vSesionPlenoPdf2 = #vCarpetaAcademicos# & #punto_pdf_2#>
                                            <cfset vSesionPlenoPdfWeb2 = #vWebAcademicos# & #punto_pdf_2#>
										<cfelse>
                                            <cfset vSesionPlenoPdf2 = #vCarpetaSesionOtros# & #punto_pdf_2#>
                                            <cfset vSesionPlenoPdfWeb2 = #vWebSesionOtros# & #punto_pdf_2#>
                                        </cfif>
                                    </cfif>                            
                                    <tr>
                                        <td width="5%" valign="top">#punto_num#.</td>
                                        <td width="85%" valign="top">#punto_texto#</td>
                                        <td width="10%" valign="top">
											<cfif FileExists(#vSesionPlenoPdf1#)>
												<a href="#vSesionPlenoPdfWeb1#" target="winPdfOrden"><span class="glyphicon glyphicon-open-file glyphicon-adjust" style="cursor:pointer;" title="#tbOrdenDia.punto_pdf#"></span></a>
											</cfif>
											<cfif FileExists(#vSesionPlenoPdf2#)>
												<a href="#vSesionPlenoPdfWeb2#" target="winPdfOrden"><span class="glyphicon glyphicon-open-file" style="cursor:pointer;" title="#tbOrdenDia.punto_pdf_2#"></span></a>
											</cfif>
                                        </td>
                                    </tr>
								</cfoutput>
							</tbody>
                        </table>
					</div>
					<!--- ORDEN DEL DÍA DIGITALIZADO Y DISPONIBLE EN PDF --->
					<div class="row content text-right">
						<cfset vWebArchivoOd = #vWebSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
                        <cfset vCarpetaArchivoOd = #vCarpetaSesionHistoria# & 'ORDENDIA_' & #tbSesion.ssn_id# & '.pdf'>
						<cfif FileExists(#vCarpetaArchivoOd#)>
							<div class="col-11 col-sm-11"><h5>ORDEN DEL D&Iacute;A DISPONIBLE EN PDF</h5></div>
							<div class="col-1 col-sm-1" align="center">
								<cfoutput>
                                    <a href="#vWebArchivoOd#" target="_blank"> <img src="#vCarpetaIMG#/pdf.png" width="30" style="border:none; cursor:pointer;" title="Orden del dia en original"> </a>
                                </cfoutput>
							</div>
                        </cfif>
					</div>

					<cfif #tbSesion.ssn_clave# EQ 1>
                    	<!--- --->
                        <cfquery name="tbPlenoSesion" datasource="#vOrigenDatosSAMAA#">
                            SELECT * FROM ruta_carpetas_ctic
                            WHERE ruta_status = '1'
                            ORDER BY pleno_id
                        </cfquery>

						<!--- VERIFICA SI ALGUNA SESIÓN SE JUNTA --->							
                        <cfset vFechaSesionVigente = #LsDateFormat(#tbSesion.vSsnFechaCorta#,'dd/mm/yyyy')#>
                        <cfquery name="tbSesionDoble" datasource="#vOrigenDatosSAMAA#">
                            SELECT * FROM sesiones
                            WHERE CONVERT(date, ssn_fecha) = #tbSesion.vSsnFechaCorta# <!--- CONVERT(smalldatetime, ssn_fecha, 101) = CONVERT(smalldatetime,'#tbSesion.ssn_fecha#', 101) --->
                            AND ssn_clave = 1 AND ssn_id <> #tbSesion.ssn_id#<!--- #Session.sSesion# --->
                        </cfquery>
						<cfif #CGI.SERVER_PORT# IS '31221'>
							<cfoutput>SESI&Oacute;N DOBLE: #tbSesionDoble.RecordCount# - SESI&Oacute;N VIGENTE: #tbSesion.ssn_id# - #vFechaSesionVigente# - #tbSesion.ssn_fecha#</cfoutput>
						</cfif>
						
						<!--- VERIFICA SI EN LA SESIÓN VIGENTE SE VEN BECAS POSDOCTORALES --->
                        <cfquery name="tbSesionBP" datasource="#vOrigenDatosSAMAA#">
                            SELECT * FROM sesiones 
                            WHERE ssn_clave = 7 
                            AND ssn_id = #Session.sSesion#
                        </cfquery>

						<!--- VERIFICA SI EN LA SESIÓN VIGENTE SE VEN INFORMES ANUALES --->
                        <cfquery name="tbSesionInformeAnual" datasource="#vOrigenDatosSAMAA#">
                            SELECT ssn_id FROM movimientos_informes_asunto
                            WHERE informe_reunion = 'CTIC'
                            AND ssn_id = #Session.sSesion#
                            GROUP BY ssn_id
                        </cfquery>

						<!--- ********** EN CASO DE JUNTARSE DOS SESIONES, MUESTRA LOS ASUNTOS DE LA SESIÓN ANTERIOR ********** --->
						<cfif #tbSesionDoble.RecordCount# EQ 1>
							<cfset vSesionMuestra = #tbSesionDoble.ssn_id#>
							<cfinclude template="sesion_ordinaria_asuntos_include.cfm">
						</cfif> 

						<!--- ********** MUESTRA LO ASUNTOS DE LA SESIÓN VIGENTE ********** --->
						<cfset vSesionMuestra = #tbSesion.ssn_id#>
						<cfinclude template="sesion_ordinaria_asuntos_include.cfm">
					</cfif>
				</div>
				<div class="col-sm-1 col-md-1 col-lg-2">
                    <!--- LIGA PARA ACCEDER VÍA ZOOM A LA REUNIÓN EN CASO DE QUE SE ENCUENTRE REGISTRADA EN LA BASE DE DATOS --->
                    <cfif isDefined('Session.sUsuarioNivel') AND #find("zoom.us",tbSesion.videoconferencia_zoom)# GT 0>
                        <cfif #Session.sUsuarioNivel# EQ 0 OR #Session.sUsuarioNivel# EQ 1 OR #Session.sUsuarioNivel# EQ 13 OR #Session.sUsuarioNivel# EQ 32>
                            <cfoutput>
                                <a href="#tbSesion.videoconferencia_zoom#" target="winZoomCtic">
                                    <img src="#vCarpetaICONO#/zoom.jpg" width="50%" title="Ingresar a la Sesi&oacute;n del Pleno">
                                </a>
	                            <cfif CGI.SERVER_PORT IS "31221">
                                    <br/>Usuario nivel: #Session.sUsuarioNivel#
                                    <br/>Liga sesion: #tbSesion.videoconferencia_zoom#
                                </cfif>
                            </cfoutput>
                        </cfif>
                    </cfif>
                </div>
			</div>
		</div>