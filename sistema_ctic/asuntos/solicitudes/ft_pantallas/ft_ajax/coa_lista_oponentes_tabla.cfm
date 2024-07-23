<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/03/2022 --->
<!--- FECHA ÚLTIMA MOD.: 02/06/2022 --->
<!--- INCLUDE PARA INSERTAR LA TABLA O TABLAS PARA LISTAR OPONENTES --->            
            <table width="100%" align="center">
                <tr>
                    <td></td>
                    <td><span class="Sans9Gr"><strong>Nombre</strong></span></td>
                    <td align="center">
                        <div class="NoImprimir">
                            <cfif #vActivaCampos# NEQ "disabled"><strong>Eliminar oponente</strong></cfif>
                        </div>
                    </td>
                </tr>        
                <cfoutput query="tbCoaOponentes" startrow="#vRegInicio#" maxrows="#vRegFinal#">
                    <tr>
                        <td width="5%"><span class="Sans9Gr"><strong>#CurrentRow#.-</strong></span></td>
                        <td width="85%"><span class="Sans9Gr">#acd_nombres# #acd_apepat# #acd_apemat#</span></td><!--- CAMBIO DE ORDEN, DE AP, AM, NOMBRE A NOMBRE, AP, AM (02/05/2022) --->
                        <td width="10%" align="center">
                            <div class="NoImprimir">
                                <cfif #vActivaCampos# NEQ "disabled">
                                    <img src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar oponente" onclick="fOponentesAdm('E', #id#)">
                                </cfif>
                            </div>
                        </td>
                    </tr>
                </cfoutput>
            </table>