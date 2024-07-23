<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/04/2017 --->
<!--- FECHA �LTIMA MOD.: 10/04/2024 --->
<!--- SELECCI�N DE N�MERO DE REGISTROS POR P�GINA ****SABDO BOOTSTRAP***** --->

<!--- Guardar los atributos en variables --->

<cfset vFiltro = "#Session[attributes.filtro]#">
<cfset vFuncion = "#attributes.funcion#">

					<!--- Control para selecci�nar el n�emro de registros por p�gina --->
                    <div class="form-group">
						<label for="sel1">Registros por p�gina:</label>
						<select id="vRPP" class="form-control input-sm" style="width: 60%;" <cfoutput>onchange="#vFuncion#(#vFiltro.vPagina#)"</cfoutput>>
							<option value="25" <cfif vFiltro.vRPP IS 20>selected</cfif>>25</option>
							<option value="50" <cfif vFiltro.vRPP IS 50>selected</cfif>>50</option>
							<option value="100" <cfif vFiltro.vRPP IS 100>selected</cfif>>100</option>
							<option value="150" <cfif vFiltro.vRPP IS 500>selected</cfif>>150</option>
							<option value="200" <cfif vFiltro.vRPP IS 500>selected</cfif>>200</option>
						</select>
					</div>
