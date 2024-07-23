					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 01/06/2016 --->
					<!--- FECHA ULTIMA MOD.: 01/06/2016 --->
					<!--- MÓDULO QUE GENERA UN CÁTALOGO INSERTO EN UN SELECT CON LA LISTA DE LA CLASE, CATEGORÍA Y NIVEL DE LOS ACADÉMICOS --->

							<cfset vFiltro = "#Session[attributes.filtro]#">
                            <cfset vFuncion = "#attributes.funcion#">
                            <cfset vOrigenDatosCATALOGOS = "#attributes.origendatos#">

							<!--- Obtener información del catálogo de categoría y nivel (CATÁLOGOS GENERALES MYSQL) --->
                            <cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
                                SELECT * FROM catalogo_cn 
                                WHERE cn_status = 1
                                ORDER BY cn_clave
                            </cfquery>
                    
                            <!-- Categoría y Nivel -->
                            <tr>
                                <td valign="top">
                                    <span class="Sans9Gr">Categor&iacute;a y nivel:<br></span>
                                    <select name="vCn" id="vCn" class="datos" style="width:95%;" <cfoutput>onchange="#vFuncion#(#vFiltro.vPagina#,'#vFiltro.vOrden#','#vFiltro.vOrdenDir#')"</cfoutput>>
                                        <option value="">-- SELECCIONE --</option>
                                        <option value="">-----------------------------------</option>
                                        <option value="INV">INVESTIGADORES</option>
                                        <option value="TEC">TECNICOS ACADÉMICOS</option>
                                        <option value="">-----------------------------------</option>
                                        <cfoutput query="ctCategoria">
                                            <option value="#cn_clave#" <cfif #cn_clave# EQ #Session.AcademicosFiltro.vCn#>selected</cfif>>#CnSinTiempo(cn_siglas)#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>