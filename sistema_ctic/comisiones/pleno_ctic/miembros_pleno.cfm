<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/04/2020 --->
<!--- FECHA ÚLTIMA MOD.: 27/04/2020 --->

<!--- MIEMBROS DEL PLENO --->

<!-- LLMADO A LA COSULTA DE CARGOS ACADEMICO-ADMINISTRATIVOS Y CONTIENE A LOS MIEMBROS DEL CTIC -->
<cfinclude template="include_llamado_bd.cfm"></cfinclude>

<cfform name="frmCorreo" method="post" action="">
	<table width="95%" border="0">
		<tr>
			<td><span class="Sans10GrNe">Asunto:</span></td>
			<td colspan="2">
				<cfinput type="text" name="txtAsunto" class="datos" id="txtAsunto" value="Asuntos para reuni&oacute;n del Pleno del CTIC (#vSesionActualPleno#)" size="100" maxlength="254">
				<cfinput id="vSesionActualPleno" name="vSesionActualPleno" type="hidden" value="#vSesionActualPleno#"></cfinput>
			</td>
		</tr>
		<tr>
			<td valign="top"><span class="Sans10GrNe">Descripci&oacute;n:</span></td>
			<td colspan="2" bgcolor="#E5E5E5">
				<span class="Sans9GrNe">
					Estimado(a) miembro del consejo t&eacute;cnico:
					<br><br>
					Por este medio le notifico que los asuntos para la sesi&oacute;n <cfoutput>#vSesionActualPleno#</cfoutput> del Pleno del CTIC se encuentran disponibles. Para acceder a ellos de un click en la siguiente liga:
					<br><br>
					LIGA PARA ACCEDER A LA INFORMACI&Oacute;N DEL PLENO DEL CTIC
					<br><br>o copie y pegue la siguiente liga en el navegador:
					<br><br>
				</span>
				<cftextarea name="txtDescripcion" id="txtDescripcion" cols="120" rows="6" class="datos"></cftextarea>
				<br><br>
				<span class="Sans9GrNe">
					Sin m&aacute;s por el momento, reciba un cordial saludo.
				</span>
			</td>
		</tr>
	</table>
	<div align="center">
		<cfinput type="button" name="Submit" value="Enviar" class="botonesstandar" onClick="vValidaCorreo();">
		<cfinput type="reset" name="Submit" value="Limpiar" class="botonesstandar">
	</div>	
</cfform>

<table style="width: 90%;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
	<tr valign="middle" style="height: 18px; background-color: #CCCCCC;">
		<td width="8%"><span class="Sans9GrNe">Entidad</td>		
		<td width="40%"><span class="Sans9GrNe">NOMBRE</span></td>
		<td width="22%"><span class="Sans9GrNe">CARGO</span></td>
		<td width="15%"><span class="Sans9GrNe">CORREO PERSONAL</span></td>
		<td width="15%"><span class="Sans9GrNe">CORREO </span></td>
	</tr>
	<cfoutput query="csMiembrosPleno">
		<tr style="height: 18px;" onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">	
			<td><span class="Sans9Gr">#dep_siglas#</span></td>
			<td><span class="Sans9Gr">#nombre_completo_pmn#</span></td>
			<td><span class="Sans9Gr">#adm_descrip#</span></td>
			<td>#acd_email#</td>
			<td><cfif #acd_email# NEQ #caa_email#>#caa_email#</cfif></td>
		</tr>
	</cfoutput>
</table>
		 