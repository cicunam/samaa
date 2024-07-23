<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 11/08/2021 --->
<!--- FECHA ÚLTIMA MOD.: 30/08/2022 --->
<!--- FILTROS DE DE MÓDULO DE COA'S  --->
<cfinclude template="comun/include_ColsAncho.cfm">
<div id="divFiltrosSolCoa" style="padding-left:10px;" class="collapse table-responsive"><!---  --->
    <cfform name="formFiltro" id="formFiltro" class="form-inline" role="form">
        <cfoutput>        
            <table id="tbFiltros" class="table">
                <thead>
                    <tr class="header warning">
                        <td class="small hidden-xs hidden-sm" style="width: #vColRow#%;"></td>
                        <cfif #Session.sTipoSistema# EQ 'stctic'>
                            <td class="small" style="width: #vColEntidad#%;">
                                <div class="form-group">
                                    <cfquery name="ctEntidades" datasource="#vOrigenDatosCATALOGOS#">
                                        SELECT dep_siglas, MID(dep_clave,1,4) AS dep_clave
                                        FROM catalogo_dependencias
                                        WHERE dep_clave LIKE '03%' 
                                        AND dep_status = 1
                                        AND dep_tipo <> 'PRO'
                                        ORDER BY dep_tipo, dep_siglas
                                    </cfquery>
                                    <cfselect name="selDepClave" id="selDepClave" query="ctEntidades" queryPosition="below" value="dep_clave" display="dep_siglas" selected="#iif(vAppConCoaMenu IS 1, DE(Session.ConCoaFiltro.vDepClave), DE(Session.ConCoaFiltro.vDepClave))#" onChange="fListarRegistros(1);" class="form-control input-sm"> <!--- <cfif #vAppConCoaMenu# EQ '1'>#Session.ConCoaFiltroVig.vDepClave#<cfelse>#Session.ConCoaFiltro.vDepClave#</cfif> --->
                                        <option value="">TODAS</option>
                                    </cfselect>
                                </div>
                            </td>
                        <cfelse>
                            <cfinput id="selDepClave" name="selDepClave" type="hidden" class="form-control input-sm" value="#Session.sIdDep#">
                        </cfif>
                        <td class="small" style="width: #vColPlaza#%;">
                            <div id="divNoPlaza" class="input-group">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
                                <cfinput id="txtBuscaNoPlaza" name="txtBuscaNoPlaza" type="text" class="form-control input-sm" placeholder="No. plaza" onkeypress="fBuscaTexto();" value="#iif(vAppConCoaMenu IS 1, DE(Session.ConCoaFiltro.vNoPlaza), DE(Session.ConCoaFiltro.vNoPlaza))#" size="10" maxlength="8"><!--- <cfif #vAppConCoaMenu# EQ '1'>#Session.ConCoaFiltroVig.vNoPlaza#<cfelse>#Session.ConCoaFiltro.vNoPlaza#</cfif> --->
                            </div>
                        </td>
                        <td class="small hidden-xs hidden-sm" style="width: #vColActa#%;">
                            <div id="divSsnId" class="input-group">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
                                <cfinput id="txtBuscaSsnId" name="txtBuscaSsnId" type="text" class="form-control input-sm" placeholder="No. acta" onkeypress="fBuscaTexto();" value="#iif(vAppConCoaMenu IS 1, DE(Session.ConCoaFiltro.vSsnId), DE(Session.ConCoaFiltro.vSsnId))#" size="5" maxlength="4"><!--- <cfif #vAppConCoaMenu# EQ '1'>#Session.ConCoaFiltroVig.vSsnId#<cfelse>#Session.ConCoaFiltro.vSsnId#</cfif> --->
                            </div>
                        </td>
                        <td class="small hidden-xs hidden-sm" style="width: #vColPublica#%;">
                            <div id="divNoGaceta" class="input-group">
                                <span class="input-group-addon"><i class="glyphicon glyphicon-search"></i></span>
                                <cfinput id="txtBuscaNoGaceta" name="txtBuscaNoGaceta" type="text" class="form-control input-sm" placeholder="No. gaceta" onkeypress="fBuscaTexto();" value="#iif(vAppConCoaMenu IS 1, DE(Session.ConCoaFiltro.vNoGaceta), DE(Session.ConCoaFiltro.vNoGaceta))#" size="5" maxlength="4"> <!--- <cfif #vAppConCoaMenu# EQ '1'>#Session.ConCoaFiltroVig.vNoGaceta#<cfelse>#Session.ConCoaFiltro.vNoGaceta#</cfif> --->
                            </div>
                        </td>
                        <td class="small hidden-xs hidden-sm" style="width: #vColSolicita#%;"></td>
                    </tr>
                </thead>
            </table>
        </cfoutput>
    </cfform>
</div>
