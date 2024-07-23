					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 01/06/2016 --->
					<!--- FECHA ULTIMA MOD.: 01/06/2016 --->
					<!--- M�DULO QUE GENERA UN C�TALOGO INSERTO EN UN SELECT CON LA LISTA DE LA CLASE, CATEGOR�A Y NIVEL DE LOS ACAD�MICOS --->

							<cfset vFiltro = "#Session[attributes.filtro]#">
                            <cfset vFuncion = "#attributes.funcion#">
                            <cfset vOrigenDatosCATALOGOS = "#attributes.origendatos#">

							<!--- Obtener informaci�n del cat�logo de categor�a y nivel (CAT�LOGOS GENERALES MYSQL) --->
                            <cfquery name="ctCategoria" datasource="#vOrigenDatosCATALOGOS#">
                                SELECT * FROM catalogo_cn 
                                WHERE cn_status = 1
                                ORDER BY cn_clave
                            </cfquery>
                    
                            <!-- Categor�a y Nivel -->
                            <tr>
                                <td valign="top">
                                    <span class="Sans9Gr">Categor&iacute;a y nivel:<br></span>
                                    <select name="vCn" id="vCn" class="datos" style="width:95%;" <cfoutput>onchange="#vFuncion#(#vFiltro.vPagina#,'#vFiltro.vOrden#','#vFiltro.vOrdenDir#')"</cfoutput>>
                                        <option value="">-- SELECCIONE --</option>
                                        <option value="">-----------------------------------</option>
                                        <option value="INV">INVESTIGADORES</option>
                                        <option value="TEC">TECNICOS ACAD�MICOS</option>
                                        <option value="">-----------------------------------</option>
                                        <cfoutput query="ctCategoria">
                                            <option value="#cn_clave#" <cfif #cn_clave# EQ #Session.AcademicosFiltro.vCn#>selected</cfif>>#CnSinTiempo(cn_siglas)#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>