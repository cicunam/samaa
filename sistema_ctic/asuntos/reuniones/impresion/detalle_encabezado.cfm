<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 17/04/2009 --->
<!--- FECHA ÚLTIMA MOD: 17/05/2019 --->
<!--- DETALLE DE ENCABEZADO--->
<cfoutput>
	<!--- Titulo de la sección --->
	<tr>
		<td colspan="3">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2" align="left" style="text-align:left;">
						#ctListado.parte_titulo#
					</td>
				</tr>
				<tr>
					<td align="left" style="text-align:left;">RELACION DEL #LsDateFormat(tbSesiones.ssn_fecha, 'dd/mm/yyyy')#</td>
					<td align="right" style="text-align:right;">ACTA #vActa#</td>
				</tr>
			</table>
		</td>
	</tr>
	<!--- Línea --->
	<tr><td colspan="3"><hr class="doble"></td></tr>
	<!--- Separación --->
	<tr><td colspan="3" height="10"></td></tr>
</cfoutput>	
