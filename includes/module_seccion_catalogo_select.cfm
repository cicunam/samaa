					<!--- CREADO: ARAM PICHARDO --->
					<!--- EDITO: ARAM PICHARDO --->
					<!--- FECHA CREA: 29/06/2017 --->
					<!--- FECHA ULTIMA MOD.: 29/06/2017 --->
					
					<!--- CONTROLES PARA PODER REALIZAR FILTROS POR SECCION DEL LISTADO --->

					<cfset vFuncionScriptAjax = "#attributes.funcion#">
					<cfset vfSeccion = #attributes.sFiltrovSeccion#>

                    <cfquery name="ctSeccionListado" datasource="samaa">
                        SELECT * FROM catalogo_listado
                        WHERE parte_status = 1
                        ORDER BY parte_numero
					</cfquery>
					<span class="Sans9ViNe">Filtrar por secci&oacute;n:</span><br>
                    <select name="vSeccion" id="vSeccion" class="datos" style="width:95%;" onChange="fListarSolicitudes(1);">
                        <option value="" <cfif #vfSeccion# EQ ''>selected</cfif>>Todas</option>
                        <cfoutput query="ctSeccionListado">
	                        <option value="#parte_numero#" <cfif #vfSeccion# EQ #parte_numero#>selected</cfif>>Secci&oacute;n No. #parte_romano#</option>                        
						</cfoutput>
					</select>