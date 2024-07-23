<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 02/03/2023 --->
<!--- PIE DE PÁGINA GENERAL PARA LA IMPRESIÓN DE LISTADOS DE INFORMACIÓN DE LOS ACADÉMICOS --->
<!--- IMPRESIÓN DE LISTADO INDIVIDUAL DE: INFORMES ANUALES, MOVIMIENTOS, ETC..  --->


			<cfdocumentitem type="footer">
				<cfoutput>
                    <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
					<cfif #vModuloImp# EQ 'ASUNTOS'>
                        <cfif #vTipoReporte# EQ 'LEXPEDIENTE'>
                            <table width="100%">
                                <tr>
                                    <td align="left" class="PiePagina" width="40%">Solicitante: _________________________</td>
                                    <td align="left" class="PiePagina" width="30%">Entrega expedientes:   ______________</td>
                                    <td align="left" class="PiePagina" width="30%">Recibe expedientes: ______________</td>
                                </tr>
                                <tr>
                                    <td align="left" class="PiePagina" width="40%">Firma: _______________</td>
                                    <td align="left" class="PiePagina" width="30%">Firma: _______________</td>
                                    <td align="left" class="PiePagina" width="30%">Firma: _______________</td>
                                </tr>
                                <tr>
                                    <td align="left" class="PiePagina" width="40%">Fecha: _______________</td>
                                    <td align="left" class="PiePagina" width="30%">Fecha: _______________</td>
                                    <td align="left" class="PiePagina" width="30%">Fecha: _______________</td>
                                </tr>                            
                            </table>
                        </cfif>
                    <cfelseif #vModuloImp# EQ 'ESTDGAPA'>
						<cfif #vFirmaCoord# EQ 1>
							<cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
								SELECT caa_firma FROM academicos_cargos
                                WHERE adm_clave = 82
                                AND caa_status = 'A'
							</cfquery>
                            <div align="center">
                                <span class="TablaEncabeza">
                                    <cfoutput>#tbAcademicosCargos.caa_firma#</cfoutput><br />
                                    Presidente del Consejo Técnico de la Investigación Científica
                                </span>
                            </div><br /><br />
						</cfif>
                        <table width="100%">
                            <tr>
                                <td align="left" class="PiePaginaEstDgapa" width="30%">Acta #vpSsnId# WL/#Session.SiglasStCtic#/stc</td>
                                <td align="center" class="PiePaginaEstDgapa" width="40%">#FechaCompleta(tbSesionesCtic.ssn_fecha)#</td>
                                <td align="right" class="PiePaginaEstDgapa" width="30%">#cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                            </tr>
                        </table>
                    <cfelseif #vModuloImp# EQ 'SICLISTAACUSE'><!--- ACUSE DE RECIBO DE INFORMES ENTIDADES ACADÉMICAS 02/03/2023--->
                        <cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
                            SELECT acd_prefijo, nombre_completo_npm, dep_nombre_may_min
                            FROM consulta_cargos_acadadm
                            WHERE adm_clave = 32
                            AND caa_status = 'A'
                            AND dep_clave = '#Session.sIdDep#'
                        </cfquery>
                        <div align="center">
                            <span class="TablaEncabeza">
                                #tbAcademicosCargos.acd_prefijo# #tbAcademicosCargos.nombre_completo_npm#<br />
                                Director del #tbAcademicosCargos.dep_nombre_may_min#
                            </span>
                        </div>
                        <br />
                        <table width="100%">
                            <tr>
                                <td align="left" class="PiePagina" width="30%">#FechaCompleta(Now())#</td>
                                <td align="center" class="PiePagina" width="40%"><b>SAMAA</b></td>
                                <td align="right" class="PiePagina" width="30%">P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                            </tr>
                        </table>                        
					<cfelse>
                        <table width="100%">
                            <tr>
                                <td align="left" class="PiePagina" width="30%">#FechaCompleta(Now())#</td>
                                <td align="center" class="PiePagina" width="40%"><b>SAMAA</b></td>
                                <td align="right" class="PiePagina" width="30%">P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</td>
                            </tr>
                        </table>
                    </cfif>
                </cfoutput>                
			</cfdocumentitem>
            
<!---                    
				<cfelseif  #vModuloImp# EQ 'ARCHIVO_ENTREGA'>
                    <table width="100%">
                        <tr>
                            <td align="left" class="PiePagina" width="40%">Nombre y firma de quien entrega: _________________________</td>
                            <td align="left" class="PiePagina" width="30%">Nombre y firma de quien recibe:  _________________________</td>
                            <td align="left" class="PiePagina" width="30%">Fecha: ______________</td>
                        </tr>
					</table>
				</cfif>
--->	            