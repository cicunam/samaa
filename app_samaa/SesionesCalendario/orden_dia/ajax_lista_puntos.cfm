
					<!--- Obtener la lista de punto del orden del día --->
                    <cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM sesiones_orden 
                        WHERE ssn_id = #vIdSsn# 
                        ORDER BY punto_num
                    </cfquery>

					<!-- Lista de puntos -->
					<table width="80%" align="center">
						<cfset CC = 1><!--- Lo inicio en 1 porque quiero obtener el siguiente número del último número --->
						<cfoutput query="tbSesionOrden">
							<!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF --->
							<cfset vArchivoPdf = ''>
							<cfif #punto_pdf# NEQ ''>
								<cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
									<cfset vArchivoPdf = #vCarpetaSesionHistoria# & #punto_pdf#>
									<cfset vWebPdf = #vWebSesionHistoria# & #punto_pdf#>
								<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
									<cfset vArchivoPdf = #vCarpetaAcademicos# & #punto_pdf#>
									<cfset vWebPdf = #vWebAcademicos# & #punto_pdf#>
								<cfelseif #RTrim(punto_clave)# EQ 'OTRO'>
									<cfset vArchivoPdf = #vCarpetaSesionOtros# & #punto_pdf#>
									<cfset vWebPdf = #vWebSesionOtros# & #punto_pdf#>
								</cfif>
							</cfif>
							<!--- Aquí se deben mostrar los archivos históricos del campo PUNTO_PDF_2 --->
							<cfset vArchivoPdf2 = ''>
							<cfif #punto_pdf_2# NEQ ''>
								<cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
                                   	<cfset vArchivoPdf2 = #vCarpetaSesionHistoria# & #punto_pdf_2#>
  	                               	<cfset vWebPdf2 = #vWebSesionHistoria# & #punto_pdf_2#>
								<cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
									<cfset vArchivoPdf2 = #vCarpetaAcademicos# & #punto_pdf_2#>
									<cfset vWebPdf2 = #vWebAcademicos# & #punto_pdf_2#>
								<cfelse>		
									<cfset vArchivoPdf2 = #vCarpetaSesionOtros# & #punto_pdf_2#>
									<cfset vWebPdf2 = #vWebSesionOtros# & #punto_pdf_2#>
								</cfif>
							</cfif>	                        
							<tr valign="top">
								<td width="3%" valign="top">
									<span class="Sans12Gr">#punto_num#</span>
								</td>
								<td width="77%" valign="top" style="padding-right:10px;">
									<div align="justify"><span class="Sans12Gr">#punto_texto#</span></div>
								</td>
								<cfif #Session.sTipoSistema# IS 'stctic' AND (#vIdSsn# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>
									<td width="3%"><img src="#vCarpetaIMG#/ir_arriba_15.jpg" onclick="fEnviarComando('SUBE','#punto_num#')" style="cursor:pointer;" title="Subir posición" /></td>
									<td width="3%"><img src="#vCarpetaIMG#/ir_abajo_15.jpg" onclick="fEnviarComando('BAJA','#punto_num#')" style="cursor:pointer;"  title="Bajar posición"></td>
									<td width="3%"><img src="#vCarpetaIMG#/detalle_15.jpg" onclick="fRempValoresPunto('E','#punto_num#');" style="cursor:pointer;" title="Editar punto"></td>
									<td width="3%"><img src="#vCarpetaIMG#/elimina_15.jpg" onclick="fEnviarComando('ELIMINA','#punto_num#','#punto_clave#');" style="cursor:pointer;" title="Eliminar punto"></td>
								</cfif>
								<td width="8%" align="right" <cfif #Session.sTipoSistema# IS 'stctic' AND (#vIdSsn# GTE #Session.sSesion# AND #tbSesion.ssn_clave# EQ 1) OR (#tbSesion.ssn_fecha# GTE #NOW()# AND #tbSesion.ssn_clave# EQ 2)>width="15"<cfelse>width="40"</cfif>>
					                <cfif FileExists(#vArchivoPdf#)>
										<a href="#vWebPdf#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" width="20" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf#"></a>
									</cfif>
					                <cfif FileExists(#vArchivoPdf2#)>
										<a href="#vWebPdf2#" target="_blank"><img src="#vCarpetaIMG#/pdf.png" width="20" onclick="" style="border:none;cursor:pointer;" title="#punto_pdf_2#"></a>
									</cfif>
                                </td>
							</tr>
							<tr>
								<td <cfif (#vIdSsn# GTE #Session.sSesion#) OR (#Session.sTipoSistema# IS 'stctic' AND #Session.sUsuario# EQ 'aram_st')>colspan="7"<cfelse>colspan="4"</cfif> align="center">
									<hr>
								</td>
							</tr>
							<cfset CC = CC + 1>
						</cfoutput>
					</table>