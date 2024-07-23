				<!--- CREADO: ARAM PICHARDO--->
                <!--- EDITO: ARAM PICHARDO--->
                <!--- FECHA CREA: 13/06/2016 --->
                <!--- FECHA ULTIMA MOD.: 17/03/2017 --->
                <!--- CÓDIGO GENERAL QUE PERMITE ENVIAR Y/O VISUALIZAR LOS ARCHIVOS QUE SE ADMINISTRAN EN EL SERVIDOR EN LOS DIFERENTES MÓDULOS   --->

				<cfset vModuloConsulta = "#attributes.ModuloConsulta#">
				<cfset vAcdId = "#attributes.AcdId#">
                <cfset vNumRegistro = "#attributes.NumRegistro#">
                <cfset vSsnIdArchivo = "#attributes.SsnId#">
                <cfset vDepClave = "#attributes.DepClave#">
                <cfset vSolStatus = "#attributes.SolStatus#">
                <cfset vSolDevolucionSatus = "#attributes.SolDevolucionSatus#">
				<cfset vUsuarioId = "#attributes.UsuarioId#">
				<cfset vCarpetaINCLUDE = "#attributes.vCarpetaINCLUDE#">

				<cfset vHttpAdjuntaArchivos = "#vCarpetaINCLUDE#/archivopdf_selecciona_bs.cfm?vpModuloConsulta=#vModuloConsulta#&vpAcdId=#vSsnIdArchivo#&vpNumRegistro=#vNumRegistro#&vpSsnIdArchivo=#vSsnIdArchivo#&vpDepClave=#vDepClave#&vpSolStatus=#vSolStatus#&vCarpetaINCLUDE=#vCarpetaINCLUDE#">

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
					<cfset vTituloModulo = 'SOLICITUD'>
				<cfelseif #vModuloConsulta# EQ 'MOV'>
					<!--- PARA MOVIMIENTOS --->
					<cfif #vAcdId# EQ ''>
						<cfset vArchivoPdfTemp = '0_#vNumRegistro#_#vSsnIdArchivo#.pdf'>
					<cfelse>
						<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#_#vSsnIdArchivo#.pdf'>                    
                    </cfif>
                    <cfset vArchivoPdf = #vCarpetaAcademicos# & #vArchivoPdfTemp#><!--- & #vAcdId# & '\'  --->
                    <cfset vArchivoPdfWeb = #vWebAcademicos# & #vArchivoPdfTemp#><!--- & #vAcdId# & '/'  --->
                    <cfset vTituloModulo = 'MOVIMIENTO'>
				<cfelseif #vModuloConsulta# EQ 'MCTIC'>
					<!--- PARA CARGOS ACADÉMICO-ADMINISTRATIVOS --->
					<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaCargosAA# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebCargosAA# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = 'OFICIO DE CARGO'>
				<cfelseif #vModuloConsulta# EQ 'ORDENDIA'>
					<!--- PARA ODEN DEL DÍA --->
					<cfset vArchivoPdfTemp = 'ORDENDIA_#vSsnIdArchivo#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaSesionHistoria# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebSesionHistoria# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = 'Orden del día'>
				<cfelseif #vModuloConsulta# EQ 'ESTDGAPA'>
					<!--- PARA ESÍMULOS DGAPA--->
					<cfset vArchivoPdfTemp = 'ESTIMULOS_DGAPA_#vSsnIdArchivo#.pdf'>
                    <cfset vArchivoPdf = #vCarpetaSesionOtros# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebSesionOtros# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = 'Estímulos DGAPA'>
				<cfelseif #vModuloConsulta# EQ 'INFORME'>
					<cfset vArchivoPdfTemp = '#vAcdId#_#vNumRegistro#_#attributes.SsnId#.pdf'> <!--- attributes.SsnId EQUIVALE AL AÑO DE INFORME --->
                    <cfset vArchivoPdf = #vCarpetaInforme# & #vArchivoPdfTemp#>
                    <cfset vArchivoPdfWeb = #vWebInforme# & #vArchivoPdfTemp#>
                    <cfset vTituloModulo = 'Informe anual'>
				</cfif>

                <cfif FileExists(#vArchivoPdf#)>
					<cfset vTextoArchivo = "Reenviar archivo">
                <cfelse>
					<cfset vTextoArchivo = "Enviar archivo">
                </cfif>


                <div class="row">
					<cfoutput>
	                    <div class="col-sm-7 col-md-7 text-left"><h6 class="small"><strong>#vTituloModulo#</strong></h6></div>
    	                <div class="col-sm-2 col-md-2 text-left">
							<!-- Indicador de la existencia de la documentación digitalizada -->
                            <cfif FileExists(#vArchivoPdf#)>
                                <a id="LigaArchivoPDF" href="#vArchivoPdfWeb#" target="_blank">
                                    <img src="#vCarpetaICONO#/pdf.png" width="30" style="border:none; cursor:pointer;" title="Documento disponible">
                                </a>
                                <!--- <span class="Sans9ViNe">Documento disponible</span> --->
                            <cfelseif NOT FileExists(#vArchivoPdf#)>
                                <img src="#vCarpetaICONO#/pdfx.png" width="30" style="border:none;" title="Documento NO disponible">
                                <!--- <span class="Sans9ViNe">Documento NO disponible</span> --->
                            </cfif>
						</div>
					</cfoutput>
   	                <div class="col-sm-3 col-md-3 text-left">
						<cfoutput>
                            <cfif #vModuloConsulta# EQ 'SOL'>
                                <cfif #vSolStatus# GTE 3 OR (#vSolStatus# LTE 3 AND #vSolDevolucionSatus# EQ 1)>
                                    <a href="#vHttpAdjuntaArchivos#" data-toggle="modal" data-target="###vModuloConsulta#">
                                        <span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
                                    </a>
                                </cfif>
                            <cfelseif #vModuloConsulta# EQ 'MOV'>
                                <a href="#vHttpAdjuntaArchivos#" data-toggle="modal" data-target="###vModuloConsulta#">
                                    <span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
                                </a>
                            <cfelseif #vModuloConsulta# EQ 'MCTIC'>
                                <cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <a href="#vHttpAdjuntaArchivos#" data-toggle="modal" data-target="###vModuloConsulta#">
                                        <span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
                                    </a>
                                </cfif>
                            <cfelseif #vModuloConsulta# EQ 'ORDENDIA'>
                                <cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <cfif (#vSsnIdArchivo# EQ #Session.sSesion# AND #Session.sTipoSesionCel# EQ 'O') OR (#vSsnIdArchivo# GTE #LsDateFormat(now(),'YYYYMMDD')# AND #Session.sTipoSesionCel# EQ 'E') OR (#Session.sUsuarioNivel# LTE 0)>
										<a href="#vHttpAdjuntaArchivos#" data-toggle="modal" data-target="###vModuloConsulta#">
	                                		<span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
										</a>                                    </cfif>
                                </cfif>
                            <cfelseif #vModuloConsulta# EQ 'ESTDGAPA'>
                                <cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LTE 1>
                                    <cfif (#vSsnIdArchivo# EQ #Session.sSesion# AND #Session.sTipoSesionCel# EQ 'O') OR (#vSsnIdArchivo# GTE #LsDateFormat(now(),'YYYYMMDD')# AND #Session.sTipoSesionCel# EQ 'E') OR (#Session.sUsuarioNivel# LTE 0)>
										<a href="#vHttpAdjuntaArchivos#" data-toggle="modal" data-target="###vModuloConsulta#">
	                                		<span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
										</a>
                                    </cfif>
                                </cfif>
                            <cfelseif #vModuloConsulta# EQ 'INFORME'>
                                <span class="glyphicon glyphicon-cloud-upload" style="font-size:25px;" title="#vTextoArchivo#"></span>
                                <!--- <input id="cmdCargaPdf" type="button" class="btn btn-basic btn-block btn-sm" value="#vTextoArchivo#"> --->
                            </cfif>
                        </cfoutput>
					</div>
                    <cfoutput>
                        <div id="#vModuloConsulta#" class="modal fade" role="dialog">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <!-- Content will be loaded here from "remote.php" file -->
                                </div>
                            </div>
                        </div>
                    </cfoutput>
				</div>