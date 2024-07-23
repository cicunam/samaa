<!--- CREADO: JOS� ANTONIO ESTEVA --->
<!--- FECHA: 29/04/2014 --->
<!--- SELECCI�N DE N�MERO DE REGISTROS POR P�GINA --->

<!--- Guardar los atributos en variables --->

<cfset vFiltro = "#Session[attributes.filtro]#">
<cfset vFuncion = "#attributes.funcion#">

<!--- Control para selecci�nar el n�emro de registros por p�gina --->

<!-- Divisi�n -->
<tr><td valign="top"><br><div class="linea_menu"></div></td></tr>
<!-- Contador de registros -->
<tr>
	<td valign="top">
		<span class="Sans9GrNe">N�mero de registros por p�gina:</span><br/>
		<cfif attributes.ordenable IS TRUE>
        	
			<select id="vRPP" class="datos" <cfoutput>onchange="#vFuncion#(#vFiltro.vPagina#,'#vFiltro.vOrden#','#vFiltro.vOrdenDir#')"</cfoutput>>
		<cfelse>
			<select id="vRPP" class="datos" <cfoutput>onchange="#vFuncion#(#vFiltro.vPagina#)"</cfoutput>>
		</cfif>
			<option value="25" <cfif vFiltro.vRPP IS 20>selected</cfif>>25</option>
			<option value="50" <cfif vFiltro.vRPP IS 50>selected</cfif>>50</option>
			<option value="100" <cfif vFiltro.vRPP IS 100>selected</cfif>>100</option>
			<option value="500" <cfif vFiltro.vRPP IS 500>selected</cfif>>500</option>
		</select>
	</td>
</tr>



