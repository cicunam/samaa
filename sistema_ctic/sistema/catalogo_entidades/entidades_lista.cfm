
<cfquery name="ctEntidades" datasource="#vOrigenDatosSAMAA#">
    SELECT dep_nombre, dep_siglas, dep_clave, dep_orden
	FROM catalogo_dependencia
	WHERE dep_clave LIKE '03%'
	AND dep_status = 1
	ORDER BY dep_orden, dep_nombre
</cfquery>

<script language="JavaScript" type="text/JavaScript">
	$(function() {
		$("#TablaDatos tbody").not("#TablaDatos tbody:first-child").not("#TablaDatos tbody:last-child").sortable({
			alert('hola');
			update: function (e, ui) {
					// Reordenar físicamente los registros:
					<cfoutput>ordenarRegistros("catalogo_dependencia", "dep_clave", "dos", ui.item.attr('registro'), ui.item.attr('posicion'), ui.item.index() + 1);</cfoutput>
					// Recargar la página:
					 fListarEntidades(1);
			}
		});
		$("#TablaDatos tbody").disableSelection();
	});
</script>

<div align="center">
	<table id="TablaDatos" style="width:90%; margin:2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<tr valign="middle" bgcolor="#CCCCCC">
			<td width="3%" height="18px"><!-- Selector de registro --></td>
			<td width="10%" title="Número de asunto"><span class="Sans9GrNe">ORDEN LISTADO</span></td>
			<td width="12%" title="Número de asunto"><span class="Sans9GrNe">DEP CLAVE</span></td>
			<td width="12%" title="Número de asunto"><span class="Sans9GrNe">SIGLASaa</span></td>
			<td width="60%" title="Número de asunto"><span class="Sans9GrNe">ENTIDAD</span></td>
			<td width="3%"><!-- Elimina registro --></td>
		</tr>
		<tbody>        
			<cfoutput query="ctEntidades">
                <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'" registro="#dep_orden#" id="#dep_clave#" posicion="">
                    <td></td>
                    <td>#dep_orden#</td><!--- <input name="#dep_clave#" type="text" id="#dep_clave#" value="#dep_orden#" size="3" maxlength="3"> --->
                    <td>#dep_clave#</td>
                    <td>#dep_siglas#</td>
                    <td>#dep_nombre#</td>
                    <td></td>
                </tr>        
            </cfoutput>
		</tbody>
	</table>
</div>    		