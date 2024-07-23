<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 10/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 10/08/2021 --->
<!--- LISTA LA RELACIÓN DE ESTÍMULOS  --->


						<div class="panel-heading">
							<label>MEN&Uacute;</label>
							<!--- <input type="hidden" name="vAppEstDgapaMenu" id="vAppEstDgapaMenu" value="<cfoutput>#vAppEstDgapaMenu#</cfoutput>"> --->
						</div>
                        <div class="panel-body">
                            <cfoutput>                            
                                <a href="impresion/imprime_coa.cfm?vAppConCoaMenu=#vAppConCoaMenu#" target="winImpCoa">                            
                                    <div id="divImpListaCoa">
                                    <span class="glyphicon glyphicon-print" style="cursor:pointer;" title="Ver detalle"></span> Imprimir listado
                                    </div>
                                </a>
                            </cfoutput>
                        </div>
                		<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
							<cfif #vAppConCoaMenu# EQ '1' OR #vAppConCoaMenu# EQ '2'>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.ConCoaFiltroVig.vRPP#</cfoutput>">
							<cfelseif #vAppConCoaMenu# GTE '3'>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.ConCoaFiltro.vRPP#</cfoutput>">
							</cfif>
						</div>
<!---
						<cfif #vAppEstDgapaMenu# EQ 'subAgSesVig'>
							<cfif #Session.sUsuarioNivel# EQ 0>
								<cfset vSsnIdTipoInput = ''>
							<cfelse>                
								<cfset vSsnIdTipoInput = 'disabled'>
							</cfif>
                            <div class="panel-body">
								<label>Asignar a sesi&oacute;n:</label>
                            </div>                        
                            <div class="panel-body">
   								<label>Asignar no. de oficio:</label>
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
                        <cfelseif #vAppEstDgapaMenu# EQ 'subEstHis'>
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
--->
