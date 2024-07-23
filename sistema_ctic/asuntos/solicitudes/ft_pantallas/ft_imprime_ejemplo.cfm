<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 17/11/2019 --->
<!--- FECHA ULTIMA MOD.: 17/11/2019 --->
<!--- Impresión de las FTs --->

<cfparam name="vIdSol" default="0">
<cfparam name="vFt" default="42">

<!--- Obtener información de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud 
	<!--- LEFT JOIN academicos ON academicos.acd_id = movimientos_solicitud.acd_id_firma--->
    WHERE movimientos_solicitud.sol_id = #vIdSol#
</cfquery>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>

<!--- Obtener los artículos del EPA en los que se fundamenta el movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art 
    WHERE mov_clave = #vFt# 
    ORDER BY mov_articulo
</cfquery>

<!--- Mostrar el contenido en un PDF --->
<cfdocument format="PDF" pagetype="letter" orientation="portrait" fontembed="yes" marginleft="1.3" marginright="1" margintop="1.5" marginbottom="4.5" unit="cm" scale="64" backgroundvisible="yes" saveAsName="FT-CTIC-#vFt#_ejemplo.pdf">
	<!--- Encabezado de la FT --->
	<cfdocumentitem type="header">
		<table width="100%" border="0">
			<tr>
				<td><span style="font-family:sans-serif; font-size=15px; font-color=black;"><br><cfoutput>#ctMovimientoArt.mov_ley#</cfoutput> <cfoutput query="ctMovimientoArt">Art.#ctMovimientoArt.mov_articulo##ctMovimientoArt.mov_incisos#; </cfoutput></span></td>
				<td align="right"><span style="font-family:sans-serif; font-size=15px; font-color=black;"><br>FT-CTIC-<cfoutput>#vFT#</cfoutput></span></td>
			</tr>
		</table>
	</cfdocumentitem>
	<!--- Titulo general --->
	<center>
		<span style="font-family:sans-serif; font-size=24px; font-color=black;"><br>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</span>
	</center>
    <!--- Obtener el HTML de la FT --->
    <cfhttp url="#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#" method="post" resolveurl="true">
        <cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
        <cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
        <cfhttpparam type="formfield" name="vTipoComando" value="IMPRIME_EJEMPLO">
        <cfhttpparam type="formfield" name="vIdAcad" value="0">
        <cfhttpparam type="formfield" name="vFt" value="#vFt#">
        <cfhttpparam type="formfield" name="vSolStatus" value="0">
        <cfhttpparam type="formfield" name="vIdSol" value="0">    
    </cfhttp>
	<!--- Cuerpo de la FT --->
	<cfoutput><div style="padding-top:10px; margin-left:auto; margin-right:auto;">#cfhttp.fileContent#</div></cfoutput>
	<!--- Pie de página de la FDT --->
	<cfdocumentitem type="footer">
		<!--- Espacio para la firma del director (solo si la solicitud ya fue enviada) --->
        <cfoutput>
			<div style="margin-top:10px; width:100%;">
                <table width="100%" border="0">
                    <tr>
                        <td align="center">
                            <span class="Sans9Gr">
                                <br>
                                Ciudad Universitaria, Cd. Mx., A <cfoutput>#LsDateFormat(now(), 'd')# DE #UCase(LsDateFormat(now(), 'mmmm'))# DE #LsDateFormat(now(), 'yyyy')#</cfoutput>
                                <br><br><br><br><br>
                            </span>
                                <span style="">______________________________________________________________</span><br />
                                <!--- <hr style="line-height:1px; color:##000000;" width="50%"> --->
                            <span class="Sans9GrNe">NOMBRE Y FIRMA DEL DIRECTOR</span>
                        </td>
                    </tr>
                </table>
            </div>	
            <!--- Información adicional --->
            <table border="0" width="100%">
                <tr valign="bottom">
                    <td><span style="font-family:sans-serif; font-size=15px; font-color=black;">CIC-CTIC-SAMAA</span></td>
                    <td align="right"><span style="font-family:sans-serif; font-size=15px; font-color=black;">No. Solicitud <b>ft_ctic_x_xxxxxxxxxxxx_xxx_xxx_xxx</b></span></td>
                </tr>
            </table>
        </cfoutput>
	</cfdocumentitem>
</cfdocument>
