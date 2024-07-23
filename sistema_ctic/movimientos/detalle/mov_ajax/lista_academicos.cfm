<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 06/05/2009--->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->

<!--- Obtener datos de los concursantes a las convocatorias --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos WHERE ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vFiltraNombre#%' ORDER BY acd_apepat, acd_apemat, acd_nombres
</cfquery>
<!--- Lista desplegable --->
<table width="430" align="center">
	<tr>
		<td>
		<select name="selAcadLista" id="selAcadLista" size="5" class="datos100" style="margin:0px; border-style:solid; border-width:1px;" onchange="fSeleccionAcademico('<cfoutput>#vCampo#</cfoutput>');">
			<cfoutput query="tbAcademicos">
				<option value="#tbAcademicos.acd_id#">#tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#</option>
			</cfoutput>
		</select>
		</td>
	</tr>
</table>
