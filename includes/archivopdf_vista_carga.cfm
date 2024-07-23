				<!--- CREADO: ARAM PICHARDO--->
                <!--- EDITO: ARAM PICHARDO--->
                <!--- FECHA CREA: 13/06/2016 --->
                <!--- FECHA ULTIMA MOD.: 03/10/2023 --->
                <!--- CÓDIGO GENERAL QUE PERMITE ENVIAR Y/O VISUALIZAR LOS ARCHIVOS QUE SE ADMINISTRAN EN EL SERVIDOR EN LOS DIFERENTES MÓDULOS   --->

				<cfset vModuloConsulta = "#attributes.ModuloConsulta#">
				<cfset vAcdId = "#attributes.AcdId#">
				<cfset vNumRegistro = "#attributes.NumRegistro#">
				<cfset vSsnIdArchivo = "#attributes.SsnId#">
				<cfset vDepClave = "#attributes.DepClave#">
				<cfset vSolStatus = "#attributes.SolStatus#">
				<cfset vSolDevolucionSatus = "#attributes.SolDevolucionSatus#">
				<cfset vCarpetaINCLUDE = "#attributes.vCarpetaINCLUDE#">
                    
				<cfif #vModuloConsulta# EQ 'ESTDGAPA'>
                	<!--- PARA SUBIR O MOSTRAR ARCHIVOS ESTÍMULOS DGAPA --->
					<script language="JavaScript" type="text/JavaScript">
						$(function() {
							$('#dialog:ui-dialog').dialog('destroy');
							$('#divCargaArchivo_jqueryEd').dialog({
								autoOpen: false,
								height: 245,
								width: 450,
								modal: true,
								maxHeight: 250,
								maxWidth: 460,
								title: $('#vTitulojQueryVentanaEd').val(),
								open: function() {
									$(this).load('<cfoutput>#vCarpetaINCLUDE#</cfoutput>/archivopdf_selecciona.cfm', 
									{
										vpModuloConsulta:$('#vModuloConsultaEd').val(), 
										vpAcdId:$('#vAcdIdEd').val(),
										vpNumRegistro:$('#vNumRegistroEd').val(),
										vpSsnIdArchivo:$('#vSsnIdArchivoEd').val(),
										vpDepClave:$('#vDepClaveEd').val(),
										vpSolStatus:$('#vSolStatusEd').val(),
									});
								}
							});						
							$('#cmdCargaPdfEd').click(function(){
								$('#divCargaArchivo_jqueryEd').dialog('open');
							});						
						});				
					</script>
					<!--- EN CASO DE QUE EL ARCHIVO QUE SE MOSTRARÁ O SUBIRÁ SE DE LOS ESTÍMULOS DGAPA SE PONEN LAS SIGUIENTES ETIQUETAS EN LOS HIDDEN´S --->
					<cfset divCargaArchivo_jquery = "divCargaArchivo_jqueryEd">
                    <cfset vTitulojQueryHidden = "vTitulojQueryVentanaEd">
                    <cfset vModuloConsultaHidden = "vModuloConsultaEd">
                    <cfset vAcdIdHidden = "vAcdIdEd">
                    <cfset vNumRegistroHidden = "vNumRegistroEd">
                    <cfset vSsnIdArchivoHidden = "vSsnIdArchivoEd">
                    <cfset vDepClaveHidden = "vDepClaveEd">
                    <cfset vSolStatusHidden = "vSolStatusEd">
				<cfelseif #vModuloConsulta# EQ 'OFICIOSG'>
                	<!--- PARA SUBIR O MOSTRAR ARCHIVOS OFICIOS EN GENERAL --->
					<script language="JavaScript" type="text/JavaScript">
						$(function() {
							$('#dialog:ui-dialog').dialog('destroy');
							$('#divCargaArchivo_jqueryOfg').dialog({
								autoOpen: false,
								height: 245,
								width: 450,
								modal: true,
								maxHeight: 250,
								maxWidth: 460,
								title: $('#vTitulojQueryVentanaOfg').val(),
								open: function() {
									$(this).load('<cfoutput>#vCarpetaINCLUDE#</cfoutput>/archivopdf_selecciona.cfm', 
									{
										vpModuloConsulta:$('#vModuloConsultaOfg').val(), 
										vpAcdId:$('#vAcdIdOfg').val(),
										vpNumRegistro:$('#vNumRegistroOfg').val(),
										vpSsnIdArchivo:$('#vSsnIdArchivoOfg').val(),
										vpDepClave:$('#vDepClaveOfg').val(),
										vpSolStatus:$('#vSolStatusOfg').val(),
									});
								}
							});						
							$('#cmdCargaPdfOfg').click(function(){
								$('#divCargaArchivo_jqueryOfg').dialog('open');
							});						
						});				
					</script>
					<!--- EN CASO DE QUE EL ARCHIVO QUE SE MOSTRARÁ O SUBIRÁ SE DE LOS ESTÍMULOS DGAPA SE PONEN LAS SIGUIENTES ETIQUETAS EN LOS HIDDEN´S --->
					<cfset divCargaArchivo_jquery = "divCargaArchivo_jqueryOfg">
                    <cfset vTitulojQueryHidden = "vTitulojQueryVentanaOfg">
                    <cfset vModuloConsultaHidden = "vModuloConsultaOfg">
                    <cfset vAcdIdHidden = "vAcdIdOfg">
                    <cfset vNumRegistroHidden = "vNumRegistroOfg">
                    <cfset vSsnIdArchivoHidden = "vSsnIdArchivoOfg">
                    <cfset vDepClaveHidden = "vDepClaveOfg">
                    <cfset vSolStatusHidden = "vSolStatusOfg">                    
				<cfelse>
                	<!--- PARA SUBIR O MOSTRAR ARCHIVOS DE EL RESTO DE ARCHIVOS --->
					<script language="JavaScript" type="text/JavaScript">
                        // Ventana del diálogo (jQuery) para CARGAR EL ARCHIVO SELECCIONADO
                        $(function() {
                            $('#dialog:ui-dialog').dialog('destroy');
                            $('#divCargaArchivo_jquery').dialog({
                                autoOpen: false,
                                height: 245,
                                width: 450,
                                modal: true,
                                maxHeight: 250,
                                maxWidth: 460,
                                title: $('#vTitulojQueryVentana').val(),
                                open: function() {
                                    $(this).load('<cfoutput>#vCarpetaINCLUDE#</cfoutput>/archivopdf_selecciona.cfm', 
                                    {
                                        vpModuloConsulta:$('#vModuloConsulta').val(), 
                                        vpAcdId:$('#vAcdId').val(),
                                        vpNumRegistro:$('#vNumRegistro').val(),
                                        vpSsnIdArchivo:$('#vSsnIdArchivo').val(),
                                        vpDepClave:$('#vDepClave').val(),
                                        vpSolStatus:$('#vSolStatusSol').val()
                                    });
                                }
                            });
                            $('#cmdCargaPdf').click(function(){
								//alert($('#vIdSol').val());
								//alert($('#vSolStatusSol').val());
								//alert($('#vAcdId').val());                                
                                $('#divCargaArchivo_jquery').dialog('open');
                            });
                        });						
					</script>
					<!--- EN CASO DE QUE EL ARCHIVO QUE SE MOSTRARÁ O SUBIRÁ NO SE DE LOS ESTÍMULOS DGAPA SE PONEN LAS SIGUIENTES ETIQUETAS EN LOS HIDDEN´S --->
					<cfset divCargaArchivo_jquery = "divCargaArchivo_jquery">
                    <cfset vTitulojQueryHidden = "vTitulojQueryVentana">
                    <cfset vModuloConsultaHidden = "vModuloConsulta">
                    <cfset vAcdIdHidden = "vAcdId">
                    <cfset vNumRegistroHidden = "vNumRegistro">
                    <cfset vSsnIdArchivoHidden = "vSsnIdArchivo">
                    <cfset vDepClaveHidden = "vDepClave">
                    <cfset vSolStatusHidden = "vSolStatusSol">
				</cfif>

                <cfset vTitulojQuery = 'SELECCIONAR ARCHIVO PARA ENVIAR AL SAMAA '>

                <cfset vCarpetaICONO = 'http://www.cic-ctic.unam.mx:31220/images/iconos'>
                
				<!---  INCLUDE CON LAS CARPETAS Y RUTAS WEB PARA UBICAR Y ACCESAR A LOS DIFERENTES ARCHIVOS PDF'S --->
				<cfinclude template="#vCarpetaINCLUDE#/include_ruta_archivos.cfm">

				<!--- Archivo PDF de documentación --->
				<cfif #vModuloConsulta# EQ 'SOL'>
					<!--- PARA SOLICITUDES --->
					<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#.pdf'>
					<cfif #vSolStatus# GTE "3">
						<cfset vArchivoPdf = #vCarpetaEntidad# & #MID(vDepClave,1,4)# & '\' & #vArchivoPdfTemp#>
						<cfset vArchivoPdfWeb = #vWebEntidad# & #MID(vDepClave,1,4)# & '/' & #vArchivoPdfTemp#>
					<cfelse>
						<cfset vArchivoPdf = #vCarpetaCAAA# & #vArchivoPdfTemp#>
						<cfset vArchivoPdfWeb = #vWebCAAA# & #vArchivoPdfTemp#>
					</cfif>
					<cfset vTituloModulo = ' (SOLICITUD)'>
				<cfelseif #vModuloConsulta# EQ 'MOV'>
					<!--- PARA MOVIMIENTOS --->
					<cfif #vAcdId# EQ ''>
						<cfset vArchivoPdfTemp = '0_#vNumRegistro#_#vSsnIdArchivo#.pdf'>
					<cfelse>
						<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#_#vSsnIdArchivo#.pdf'>                    
                    </cfif>
                    <cfset vArchivoPdf = #vCarpetaAcademicos# & #vArchivoPdfTemp#><!--- & #vAcdId# & '\'  --->
                    <cfset vArchivoPdfWeb = #vWebAcademicos# & #vArchivoPdfTemp#><!--- & #vAcdId# & '/'  --->
                    <cfset vTituloModulo = ' (MOVIMIENTO)'>
				<cfelseif #vModuloConsulta# EQ 'MCTIC'>
					<!--- PARA CARGOS ACADÉMICO-ADMINISTRATIVOS --->
					<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaCargosAA# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebCargosAA# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (OFICIO DE CARGO)'>
				<cfelseif #vModuloConsulta# EQ 'ORDENDIA'>
					<!--- PARA ODEN DEL DÍA --->
					<cfset vArchivoPdfTemp = 'ORDENDIA_#vSsnIdArchivo#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaSesionHistoria# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebSesionHistoria# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (ORDEN DEL DÍA)'>
				<cfelseif #vModuloConsulta# EQ 'ESTDGAPA'>
					<!--- PARA ESÍMULOS DGAPA --->
					<cfset vArchivoPdfTemp = 'ESTIMULOS_DGAPA_#vSsnIdArchivo#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaSesionOtros# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebSesionOtros# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (ESTIMULOS DGAPA)'>
				<cfelseif #vModuloConsulta# EQ 'INFORME'>
					<!--- PARA INFORMES ANUALES --->
					<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#_#attributes.SsnId#.pdf'> <!--- attributes.SsnId EQUIVALE AL AÑO DE INFORME --->
                    <cfset vArchivoPdf = #vCarpetaInforme# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebInforme# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (INFORME ANUAL)'>
				<cfelseif #vModuloConsulta# EQ 'OFICIOSG'>
					<!--- OFICIOS GENERALES --->
					<cfset vArchivoPdfTemp = '#vSsnIdArchivo#_oficiosg.pdf'>
                    <cfset vArchivoPdf = #vCarpetaOficios# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebOficios# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (OFICIOS)'>
				<cfelseif #vModuloConsulta# EQ 'GRADOACAD'>
					<!--- OFICIOS GENERALES --->
					<cfset vArchivoPdfTemp = '#vAcdId#_#vSolStatus#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaGradoAcad# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebGradoAcad# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = ' (GRADO ACADEMICO)'>                        
				</cfif>

                <cfif FileExists(#vArchivoPdf#)>
					<cfset vTextoArchivo = "Reenviar archivo">
                <cfelse>
					<cfset vTextoArchivo = "Enviar archivo">
                </cfif>
				<cfif #vNumRegistro# NEQ 1><!---  #vModuloConsulta# NEQ 'ESTDGAPA' --->
					<tr id="ArchivoPDFEspacio"><td height="15"></td></tr>
					<tr id="ArchivoPDFLinea"><td><div class="linea_menu"></div></td></tr>
				</cfif>                    
				<tr id="ArchivoPDFEncabeza">
					<td>
						<cfif #vNumRegistro# NEQ 1><!---  #vModuloConsulta# NEQ 'ESTDGAPA' --->
							<span class="Sans9NeNe">Documento(s) digitalizado(s):</span>
							<br />
						</cfif>
						<div align="center"><cfoutput><span class="Sans9ViNe">#vTituloModulo#</span></cfoutput></div>
					</td>
				</tr>
				<!-- Indicador de la existencia de la documentación digitalizada -->
				<tr id="ArchivoPDF">
					<td align="center" style="height:70px;">
						<cfoutput>
							<div id="divGacetaPdf" class="divPdfCons" align="center">
							<cfif FileExists(#vArchivoPdf#)>
								<img src="#vCarpetaICONO#/pdf_2015.png" width="40px" style="border:none;cursor:pointer;" title="Abrir documentos en PDF" onclick="fPdfAbrir('#vArchivoPdfTemp#','#vModuloConsulta#','#vSolStatus#','#MID(vDepClave,1,4)#');">
								<!---
								--->
                                <!--- <span class="Sans9ViNe">Documento disponible</span> --->
                            <cfelseif NOT FileExists(#vArchivoPdf#)>
                                <!--- <img src="#vCarpetaICONO#/pdfx.png" width="30" style="border:none;" title="Documento NO disponible">--->
                                <br />
                                <!--- <span class="Sans9ViNe">Documento NO disponible</span> --->
                            </cfif>
							</div>
						</cfoutput>
					</td>
				</tr>
				<cfoutput>
					<cfif #vModuloConsulta# EQ 'SOL'>
                        <cfif (#Session.sTipoSistema# EQ 'sic' AND (#vSolStatus# GTE 3 OR (#vSolStatus# LTE 3 AND #vSolDevolucionSatus# EQ 1)))  OR (#Session.sTipoSistema# EQ 'stctic' AND #vSolStatus# LTE 3)>
                        <!--- <cfif #vSolStatus# GTE 3 OR (#vSolStatus# LTE 3 AND #vSolDevolucionSatus# EQ 1)> --->
                            <tr>
                                <td>
                                    <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#" <cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GT 2>disabled</cfif>>
                                </td>
                            </tr>
                        </cfif>
					<cfelseif #vModuloConsulta# EQ 'MOV'>
						<cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                            <tr>
                                <td>
                                    <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                                </td>
                            </tr>
						</cfif>
                    <cfelseif #vModuloConsulta# EQ 'MCTIC'>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                            <tr>
                                <td>
                                    <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                                </td>
                            </tr>
						</cfif>
                    <cfelseif #vModuloConsulta# EQ 'ORDENDIA'>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
							<cfif (#vSsnIdArchivo# EQ #Session.sSesion# AND #Session.sTipoSesionCel# EQ 'O') OR (#vSsnIdArchivo# GTE #LsDateFormat(now(),'YYYYMMDD')# AND #Session.sTipoSesionCel# EQ 'E') OR (#Session.sUsuarioNivel# LTE 0)>
                                <tr>
                                    <td>
                                        <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                                    </td>
                                </tr>
                            </cfif>
						</cfif>
					<cfelseif #vModuloConsulta# EQ 'ESTDGAPA'>
						<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
							<cfif (#vSsnIdArchivo# EQ #Session.sSesion# AND #Session.sTipoSesionCel# EQ 'O') OR (#vSsnIdArchivo# GTE #LsDateFormat(now(),'YYYYMMDD')# AND #Session.sTipoSesionCel# EQ 'E') OR (#Session.sUsuarioNivel# LTE 0)>
                                <tr>
                                    <td>
                                        <input id="cmdCargaPdfEd" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                                    </td>
                                </tr>
                            </cfif>
						</cfif>
					<cfelseif #vModuloConsulta# EQ 'INFORME'>
                        <tr>
                            <td>
                                <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                            </td>
                        </tr>
					<cfelseif #vModuloConsulta# EQ 'OFICIOSG'>
                        <tr id="ArchivoPDFCmd">
                            <td>
                                <input id="cmdCargaPdfOfg" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                            </td>
                        </tr>
					<cfelseif #vModuloConsulta# EQ 'GRADOACAD'>
                        <tr id="ArchivoPDFCmd">
                            <td>
                                <input id="cmdCargaPdf" type="button" class="botones" style="position:relative;" value="#vTextoArchivo#">
                            </td>
                        </tr>                        
					</cfif>
				</cfoutput>
                <cfif #CGI.SERVER_PORT# EQ '31221'>
                    <cfif isDefined('Session.sUsuarioNivel') AND #Session.sUsuarioNivel# EQ 0>
                        <cfset vTipoInput = 'text'>
                    <cfelse>                
                        <cfset vTipoInput = 'hidden'>
                    </cfif>
                <cfelse>
                    <cfset vTipoInput = 'hidden'>
                </cfif>
                        
                <tr>
                    <td>
						<cfoutput>
                            <cfif #CGI.SERVER_PORT# EQ '31221'>                            
                                #divCargaArchivo_jquery#
                            </cfif>
							<div id="#divCargaArchivo_jquery#"><!-- DIV QUE PERIMTE ABRIR JQUERY PARA CARGAR ARCHIVOS AL SERVIDOR --></div>
							<input id="#vTitulojQueryHidden#" type="#vTipoInput#" value="#vTitulojQuery# #vTituloModulo#">
							<input id="#vModuloConsultaHidden#" type="#vTipoInput#" value="#vModuloConsulta#">
							<input id="#vAcdIdHidden#" type="#vTipoInput#" value="#vAcdId#">
							<input id="#vNumRegistroHidden#" type="#vTipoInput#" value="#vNumRegistro#">
							<input id="#vSsnIdArchivoHidden#" type="#vTipoInput#" value="#vSsnIdArchivo#">
							<input id="#vDepClaveHidden#" type="#vTipoInput#" value="#vDepClave#">
							<input id="#vSolStatusHidden#" type="#vTipoInput#" value="#vSolStatus#">
						</cfoutput>
					</td>
				</tr>			