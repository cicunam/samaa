<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 27/05/2022 --->
<!--- INCLUDE DE MENÚ DEL MÓDULO  --->


						<div class="panel-heading">
							<label>MEN&Uacute;</label>
							<input type="hidden" name="vAppEstDgapaMenu" id="vAppEstDgapaMenu" value="<cfoutput>#vAppEstDgapaMenu#</cfoutput>">
						</div>
						<cfif #vAppEstDgapaMenu# EQ 'subAgSesVig'>
                            <div class="panel-body">

								<label>Asignar a sesi&oacute;n:</label>
    							<cfif (#Session.sUsuarioNivel# EQ 0 AND #vAppEstDgapaMenu# EQ 'subAgSesVig') OR #vAppEstDgapaMenu# EQ 'subEstHis'>
    								<cfoutput>
	    								<input id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" value="#Session.EstimulosDgapaFiltroVig.vSsnId#" maxlength="4" onkeyup="fListarRegistros(1);">
		    						</cfoutput>                                    
		                		<cfelse>
                                    <!--- Obtener información del periodo de sesión ordinaria --->
                                    <cfquery name="tbSesionGrupo" datasource="#vOrigenDatosSAMAA#">
                                        SELECT ssn_id FROM sesiones 
                                        WHERE ssn_id BETWEEN (#tbSesion.ssn_id#-2) AND (#tbSesion.ssn_id#+2)
                                        AND ssn_clave = 1
                                        ORDER BY ssn_id DESC
                                    </cfquery>
                                    <select id="txtBuscaSsnId" name="txtBuscaSsnId" class="form-control" onChange="fListarRegistros(1);">
                                        <cfoutput query="tbSesionGrupo">
                                            <option <cfif #Session.EstimulosDgapaFiltroVig.vSsnId# EQ #ssn_id#>selected</cfif>>#ssn_id#</option>
                                        </cfoutput>
                                    </select>
                			    </cfif>
<!---                                
    							<cfif #Session.sUsuarioNivel# EQ 0>
              						<cfset vSsnIdTipoInput = ''>
		                		<cfelse>
						        	<cfset vSsnIdTipoInput = 'disabled'>
							    </cfif>
                                <cfoutput>
                                    <input id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" value="#Session.EstimulosDgapaFiltroVig.vSsnId#" maxlength="4" onkeyup="fListarRegistros(1);">
                                </cfoutput>
--->
				                <hr />
                                <div class="conteiner">
   					    			<label>Asignar no. de oficio:</label>
                                    <div class="col-sm-6">                                
                                        <input name="asigna_no_oficio" type="text" class="form-control input-sm" id="asigna_no_oficio" onKeyPress="return MascaraEntrada(event, '999999');">
                                    </div>                                    
                                    <button id="cmdAsignaNoAcdEst" name="cmdAsignaNoAcdEst" type="button" class="btn btn-basic btn-sm" onclick="fAsignaNoOficioAcdEst();"><strong>ASIGNAR</strong></button>
                                </div>
				                <hr />
                                <div class="conteiner">
                                    <label>Generar oficios: </label>
                                    <select id="selTipoOficios" name="selTipoOficios" class="form-control" onChange="">
                                        <option value="0">Seleccione</option>
                                        <option value="105">Iniciaci&oacute;n (PEI)</option>
                                        <option value="104">Por equivalanecia</option>
                                        <option value="101I">Ingreso</option>
                                        <option value="101R">Renovaci&oacute;n</option>
                                        <option value="102">Propuesta para nivel D</option>
                                        <option value="106">Dictamen no favorable</option>
                                    </select>
                                    <br/>
                                    <button id="cmdGenerarOficios" name="cmdGenerarOficios" type="button" class="btn btn-basic btn-sm" style="width:80%;" onclick="fGeneraOficiosMsWord();">
                                        <span class="glyphicon glyphicon-print"></span> <strong>Generar en MsWord</strong>
                                    </button>
                                </div>
								<hr />
                                <button id="cmdGenerarListadoXls" name="cmdGenerarListadoXls" type="button" class="btn btn-basic btn-sm" style="width:80%;" onclick="fGeneraListadoXls();">
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
						<div class="panel-footer">
							<!--- Contador de registros --->
                            <cfmodule template="#vCarpetaINCLUDE#/contador_registros_bs.cfm">
							<cfif #vAppEstDgapaMenu# EQ 'subAgSesVig'>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.EstimulosDgapaFiltroVig.vRPP#</cfoutput>">
							<cfelse>
	                            <input type="hidden" name="vRPP" id="vRPP" value="<cfoutput>#Session.EstimulosDgapaFiltro.vRPP#</cfoutput>">
							</cfif>
						</div>
