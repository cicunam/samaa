<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 11/11/2019 --->
<!--- FECHA ULTIMA MOD.: 12/11/2019 --->
<!--- INCLUDE CON CONTROLES NECESARIOS PARA LISTAR ACADÉMICO EN LAS BÚSQUEDAS --->


                                            <cfoutput>
    				                            <input type="#vTipoInput#" id="vCuentaIntervalo" name="vCuentaIntervalo" value="0">
                                                <input type="#vTipoInput#" id="vTipoBusquedaAcd" name="vTipoBusquedaAcd" value="#vTipobusquedaValor#">
                                                <cfif #vTipobusquedaValor# EQ 'SelAcdCons' OR #vTipobusquedaValor# EQ 'SelAcdMov' OR #vTipobusquedaValor# EQ 'SelAcdDgapa'>
                                                    <input type="#vTipoInput#" name="vLigaAjax" id="vLigaAjax" value="#vAjaxListaAcademicos#">
                                                </cfif>
                                            </cfoutput>