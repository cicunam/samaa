<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 17/11/2009 --->
<!--- Impresión de los datos de un movimiento --->
<!--- 
	NOTA IMPORTANTE:
	No es posible imprimir en con esta técnica porque el formulario requiere de javascript para acomodar los campos del formulario
	y <cfdocument> no procesa el código en javascript. Esperamos que en futuras versiones de ColdFusion esto cambie.
--->
<!--- Obtener datos del movimiento --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos WHERE mov_id = #vIdMov#
</cfquery>

<!--- Obtener el HTML del detalle del movimiento --->
<cfhttp url="#vCarpetaRaiz#/sistema_ctic/movimientos/detalle/movimiento.cfm?vIdAcad=#tbMovimientos.acd_id#&vIdMov=#tbMovimientos.mov_id#&vTipoComando=CONSULTA" method="get" resolveurl="true">
	<cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
	<cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
</cfhttp>

<!--- Mostrar el contenido en un PDF --->
<cfdocument format="PDF" fontembed="yes" marginleft="2.5" marginright="2" marginbottom="1" unit="cm" orientation="portrait" pagetype="letter" backgroundvisible="yes">
	<!--- Encabezado de la FT --->
	<cfdocumentitem type="header">
		<table width="100%" border="0">
			<tr>
				<td><span style="font-family:sans-serif; font-size=15px; font-color=black;"><br><cfoutput>No. Registro <b>#tbMovimientos.mov_id#</b></cfoutput></span></td>
				<td align="right"><span style="font-family:sans-serif; font-size=15px; font-color=black;"><br><cfoutput>No. Solicitud #tbMovimientos.sol_id#</cfoutput></span></td>
			</tr>
		</table>
		<center><span style="font-family:sans-serif; font-size=24px; font-color=black;"><br>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</span></center>
	</cfdocumentitem>
	<!--- Datos del movimiento --->
	<cfoutput><div style="padding-top:32px">#cfhttp.fileContent#</div></cfoutput>
	<!--- Pie de página de la FDT --->
	<cfdocumentitem type="footer">
		<!--- Información adicional --->
		<div style="position:absolute; bottom:10px; width:100%;">
			<table border="0" width="100%">
				<tr valign="bottom">
					<td><span style="font-family:sans-serif; font-size=15px; font-color=black;">CIC-CTIC-SAMAA</span></td>
					<td align="right"><span style="font-family:sans-serif; font-size=15px; font-color=black;">#FechaCompleta(Now())#</span></td>
				</tr>
			</table>
		</div>
	</cfdocumentitem>
</cfdocument>
