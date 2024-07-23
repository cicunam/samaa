					<!--- CREADO: ARAM PICHARDO--->
					<!--- EDITO: ARAM PICHARDO--->
					<!--- FECHA CREA: 08/09/2022 --->
					<!--- FECHA ULTIMA MOD.: 08/09/2022 --->
					<!--- M�DULO QUE GENERA UN C�TALOGO INSERTO EN UN SELECT CON LA LISTA DE LA CLASE, CATEGOR�A Y NIVEL DE LOS ACAD�MICOS --->

							<cfset vFiltro = "#Session[attributes.filtro]#">
                            <cfset vFuncion = "#attributes.funcion#">
                            <cfset vOrigenDatosSAMAA = "#attributes.origendatos#">
                            <cfset vTipoReunion = "#attributes.tiporeunion#">

							<!--- Obtener informaci�n del cat�logo de categor�a y nivel (CAT�LOGOS GENERALES MYSQL) --->
                            <cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
                                SELECT * FROM catalogo_decision
                                <cfif #vFuncion# EQ 'fListarInformes'>
                                    WHERE dec_marca_ci = 1
                                </cfif>
                                ORDER BY dec_orden
                            </cfquery>
                            <cfif #vTipoReunion# EQ 'Ctic'>
                                <cfset vTextoDec = "Decisi&oacute;n CTIC:">
                                <cfset vSelectDec = #Session.InformesConsultaFiltro.vDecCtic#>
                            <cfelseif #vTipoReunion# EQ 'Ci'>
                                <cfset vTextoDec = "Evaluaci�n Consejo Interno:">
                                <cfset vSelectDec = #Session.InformesConsultaFiltro.vDecCi#>
                            </cfif>
                            <!-- Cat�logo de decisiones -->
                            <tr>
                                <td valign="top">
                                    <span class="Sans9GrNe">
                                        <cfoutput>#vTextoDec#</cfoutput>
                                        <!--- <cfoutput>#attributes.tiporeunion# - #vTipoReunion#</cfoutput> --->
                                    </span>
                                    <br>
                                    <select name="vDecClave<cfoutput>#vTipoReunion#</cfoutput>" id="vDecClave<cfoutput>#vTipoReunion#</cfoutput>" class="datos" style="width:95%;" <cfoutput>onchange="#vFuncion#(1,'#vFiltro.vOrden#','#vFiltro.vOrdenDir#')"</cfoutput>>
                                        <option value="">-- SELECCIONE --</option>
                                        <cfoutput query="ctDecision">
                                            <option value="#dec_clave#" <cfif #dec_clave# EQ #vSelectDec#>selected</cfif>>#dec_descrip#</option>
                                        </cfoutput>
                                    </select>
                                </td>
                            </tr>
