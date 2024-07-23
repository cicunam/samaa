<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 04/06/2019 --->
<!--- LISTA LA RELACIÓN DE ESTÍMULOS  --->


						<div class="panel-heading">
							<label>MEN&Uacute;</label>
						</div>
						<cfif #vSubMenuActivo# EQ '1'>
							<cfif #Session.sUsuarioNivel# EQ 0>
								<cfset vSsnIdTipoInput = ''>
							<cfelse>                
								<cfset vSsnIdTipoInput = 'disabled'>
							</cfif>

                            <div class="panel-body">
								<label>Asignar a sesi&oacute;n:</label>
								<cfoutput>
									<input id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" value="#Session.EstimulosDgapaFiltroVig.vSsnId#" maxlength="4" #vSsnIdTipoInput# onkeyup="fListarRegistros(1);">
								</cfoutput>                                    
                            </div>                        
                            <div class="panel-body">
   								<label>Asignar no. de oficio:</label>
                                <input type="text" id="asigna_no_oficio" name="asigna_no_oficio" value="" class="form-control input-sm" onKeyPress="return MascaraEntrada(event, '99999');">
                                <button id="cmdAsignaNoAcdEst" name="cmdAsignaNoAcdEst" type="button" class="btn btn-basic btn-sm" onclick="fAsignaNoOficioAcdEst();"><strong>ASIGNAR</strong></button>
                            </div>
                            <div class="panel-body">
                                <label>Generar</label>
                                <button id="cmdGenerarListadoPdf" name="cmdGenerarListadoPdf" type="button" class="btn btn-basic btn-sm" style="width:80%;" onclick="fGeneraOficiosMsWord();">
									<span class="glyphicon glyphicon-print"></span> <strong>OFICIOS MsWord</strong>
                                </button>
								<hr />
                                <button id="cmdGenerarListadoPdf" name="cmdGenerarListadoPdf" type="button" class="btn btn-basic btn-sm" style="width:80%;" onclick="fGeneraListadoXls();">
									<span class="glyphicon glyphicon-print"></span> <strong>TABLA MsExcel</strong>
                                </button>
                                <br/><br/>
                                <button id="cmdGenerarListadoPdf" name="cmdGenerarListadoPdf" type="button" class="btn btn-basic btn-sm" style="width:80%;" onclick="fGeneraListadoPdf();">
									<span class="glyphicon glyphicon-print"></span> <strong>TABLA Pdf</strong>
                                </button>
                                <h6><input type="checkbox" id="chkFirmaCoord" name="chkFirmaCoord" /> <strong>Firma coordinador (PDF)</strong></h6>
                            </div>
                        <cfelseif #vSubMenuActivo# EQ '2'>
                            <div class="panel-body">
                                <div class="input-group">
									<label>Filtrar por sesi&oacute;n:</label>
								</div>
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i> </span>
                                    <cfoutput>
                                    <input id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" placeholder="Escriba el n&uacute;mero de acta y presione ENTER" onkeypress="fBuscaTexto(); return MascaraEntrada(event, '9999');" value="#Session.EstimulosDgapaFiltro.vSsnId#" maxlength="4">
									</cfoutput>
                                </div>

                            </div>
                        </cfif>
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
							<cfif #vSubMenuActivo# EQ '1'>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.EstimulosDgapaFiltroVig.vRPP#</cfoutput>">
							<cfelse>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.EstimulosDgapaFiltro.vRPP#</cfoutput>">
							</cfif>
						</div>
