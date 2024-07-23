<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 05/05/2009 --->
<!--- AJAX: LISTA DE DESTINOS/INSTITUCIONES --->
<!--- Obtener la lista de destinos/instituciones --->
<cfquery name="tbDestinos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM 
	(movimientos_destino LEFT JOIN catalogo_pais ON movimientos_destino.pais_clave = catalogo_pais.pais_clave)
	LEFT JOIN catalogo_pais_edo ON movimientos_destino.edo_clave = catalogo_pais_edo.edo_clave
	WHERE sol_id = #vIdSol#
</cfquery>
<!--- Generar la lista de destinos/instituciones --->
<table width="100%" border="0" cellpadding="0" align="center">
	<tr id="lista_destinos_enc">
		<td class="Sans9GrNe">Instituci&oacute;n</td>
		<td class="Sans9GrNe">Pa&iacute;s</td>
		<td class="Sans9GrNe">Estado</td>
		<td class="Sans9GrNe">Ciudad</td>
	</tr>
	<cfoutput query="tbDestinos">
	<tr>
		<td class="Sans9Gr">#tbDestinos.des_institucion#</td>
		<td class="Sans9Gr">#tbDestinos.pais_nombre#</td>
		<cfif #tbDestinos.pais_clave# EQ 'MEX' OR #tbDestinos.pais_clave# EQ 'USA'>
			<td class="Sans9Gr">#tbDestinos.edo_nombre#</td>
		<cfelse>
			<td class="Sans9Gr">#tbDestinos.edo_clave#</td>
		</cfif>
		<td class="Sans9Gr">#tbDestinos.des_ciudad#</td>
	</tr>
	</cfoutput>
</table>
