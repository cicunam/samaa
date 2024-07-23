<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM_PICHARDO --->
<!--- FECHA CREA: 22/02/2017 --->
<!--- FECHA ULTIMA MOD.: 22/02/2017 --->
<!--- LISTA DE ASUNTOS A CONSIDERAR EN LA REUNIÓN DE LA CAAA --->

<!--- Parámetros --->
<cfparam name="PageNum" default="1">
<cfparam name="vPagina" default=1>

<!--- Obtener la lista de direcciones IP registradas en el sistema --->
<cfquery name="tbSistemaDirIp" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM samaa_sistema_ip
	ORDER BY direccion_ip
</cfquery>
<br/><br/><br/>
<div align="center">
	<table style="width:70%; margin:2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
		<!-- Encabezados -->
		<tr valign="middle" bgcolor="#CCCCCC">
			<td width="3%" height="18px"><!-- Selector de registro --></td>
			<td width="40%" title="Número de asunto"><span class="Sans9GrNe">DIRECCIÓN IP</span></td>
			<td width="18%" align="center" title=""><span class="Sans9GrNe" title="Sesiones del Pleno">VÁLIDA PARA PLENO</span></td>
			<td width="18%" align="center" title=""><span class="Sans9GrNe" title="Comisión de Asuntos Académico Administrativos">VÁLIDA PARA CAAA</span></td>
			<td width="18%" align="center" title=""><span class="Sans9GrNe" title="Comisión de Becas Posdoctorales">VÁLIDA PARA CBP</span></td>
			<td width="3%"><!-- Elimina registro --></td>
		</tr>
        <cfoutput query="tbSistemaDirIp">
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
            	
                <td>#CurrentRow#</td>
                <td><span class="Sans9GrNe">#direccion_ip#</span></td>
                <td align="center"><input type="checkbox" id="status_pleno_#ip_id#" name="status_pleno_#ip_id#" value="#ip_id#" onclick="fActualizaDirIp('M','status_pleno',#ip_id#);" <cfif #status_pleno# EQ 1>checked</cfif>></td>
                <td align="center"><input type="checkbox" id="status_caaa_#ip_id#" name="status_caaa_#ip_id#" value="#ip_id#" onclick="fActualizaDirIp('M','status_caaa',#ip_id#);"  <cfif #status_caaa# EQ 1>checked</cfif>></td>
                <td align="center"><input type="checkbox" id="status_cbp_#ip_id#" name="status_cbp_#ip_id# value="#ip_id#"" onclick="fActualizaDirIp('M','status_cbp',#ip_id#);" <cfif #status_cbp# EQ 1>checked</cfif>></td>
                <td>
                    <img src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar dirección IP" onclick="fActualizaDirIp('E','',#ip_id#);">
                </td>
            </tr>
		</cfoutput>
		<cfoutput>
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td colspan="5"><span class="Sans10ViNe"><em>AGREGAR NUEVO DEIRECCIÓN IP....</em></span></td>
                <td>
                    <img name="cmdAgregaIp" id="cmdAgregaIp" src="#vCarpetaICONO#/agregar_15.jpg" style="border:none; cursor:pointer;" title="Agregar dirección IP" onclick="ventanaAgregaIp();">
                </td>
			</tr>
		</cfoutput>
	</table>        
</div>