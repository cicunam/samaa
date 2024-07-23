<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 17/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 24/02/2022 --->
<!--- Impresión de las FTs --->

<!--- Obtener información de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud_historia 
	LEFT JOIN academicos ON movimientos_solicitud_historia.acd_id_firma = academicos.acd_id
    WHERE movimientos_solicitud_historia.sol_id = #vIdSol#
</cfquery>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento WHERE mov_clave = #tbSolicitudes.mov_clave#
</cfquery>

<!--- Obtener los artículos del EPA en los que se fundamenta el movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art WHERE mov_clave = #tbSolicitudes.mov_clave# ORDER BY mov_articulo
</cfquery>

<!--- Obtener la ubicación principal de la entidad que está capturando --->
<cfquery name="ctDepUbica" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia_ubica WHERE dep_clave = '#tbSolicitudes.sol_pos1#' AND dbo.TRIM(ubica_clave) = '01'
</cfquery>

<!--- Obtener el nombre del director --->
<cfquery name="tbDirector" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud_historia 
	LEFT JOIN academicos ON movimientos_solicitud_historia.acd_id_firma = academicos.acd_id
    WHERE sol_id = #vIdSol#
</cfquery>

<!--- Mostrar el contenido en un PDF --->
<cfdocument format="PDF"  pagetype="letter" orientation="portrait" fontembed="yes" marginleft="1.3" marginright="1" margintop="1.5" marginbottom="4.5"  unit="cm" scale="64" backgroundvisible="yes" saveAsName="FT-CTIC-#vFt#_#vIdSol#.pdf" overwrite="yes">        
	<!--- Encabezado de la FT --->
	<cfdocumentitem type="header">
		<table width="100%" border="0">
			<tr>
				<td><span style="font-family:sans-serif; font-size=10px; font-color=black;"><br><cfoutput>#ctMovimientoArt.mov_ley#</cfoutput> <cfoutput query="ctMovimientoArt">Art.#ctMovimientoArt.mov_articulo##ctMovimientoArt.mov_incisos#; </cfoutput></span></td>
				<td align="right"><span style="font-family:sans-serif; font-size=10px; font-color=black;"><br>FT-CTIC-<cfoutput>#vFT#</cfoutput></span></td>
			</tr>
		</table>
	</cfdocumentitem>
	<!--- Titulo general --->
	<center>
		<span style="font-family:sans-serif; font-size=24px; font-color=black;"><br>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</span>
	</center>    
    
    <!--- Obtener el HTML de la FT --->
    <cfhttp url="#vCarpetaRaiz#/sistema_ctic/asuntos/solicitudes/#ctMovimiento.mov_ruta#" method="post" resolveurl="false">
    <!--- <cfhttp url="#vCarpetaRaiz#/sistema_ctic/asuntos/solicitudes/#ctMovimiento.mov_ruta#?vTipoComando=IMPRIME&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vSolStatus=0&vIdSol=#vIdSol#&vHistoria=2" method="get" resolveurl="true"> --->
        <cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
        <cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
        <cfhttpparam type="formfield" name="vTipoComando" value="IMPRIME">
        <cfhttpparam type="formfield" name="vIdAcad" value="#tbSolicitudes.sol_pos2#">
        <cfhttpparam type="formfield" name="vFt" value="#tbSolicitudes.mov_clave#">
        <cfhttpparam type="formfield" name="vSolStatus" value="0">
        <cfhttpparam type="formfield" name="vIdSol" value="#vIdSol#">
        <cfhttpparam type="formfield" name="vHistoria" value="2">
    </cfhttp>
	<!--- Cuerpo de la FT --->
	<div style="padding-top:10px; margin-left:auto; margin-right:auto;"><cfoutput>#cfhttp.fileContent#</cfoutput></div>            
	<!--- <cfoutput><div style="padding-top:10px">#cfhttp.fileContent#</div></cfoutput> 24/02/2022--->

    <!--- Pie de página de la FDT --->
	<cfdocumentitem type="footer">
    	<!--- NOTA: a partir del 30/06/2016 cambié de posición el texto de firma al pie de página ARAM --->
		<!--- Espacio para la firma del director (solo si la solicitud ya fue enviada) --->
        <div style="margin-top:10px; width:100%;"> <!--- Probar  page-break-inside:avoid; para que la firme quede en una sola página --->
            <table width="100%" border="0">
                <tr>
                    <td align="center">
                        <cfoutput>
                        <span style="font-family:sans-serif; font-size=12px; font-color=black;">
                            <br>
                            <cfif #ctDepUbica.ubica_lugar# EQ "CIUDAD UNIVERSITARIA">Ciudad Universitaria, Cd. Mx.<cfelse>#ctDepUbica.ubica_lugar#</cfif>, <cfoutput>#LsDateFormat(tbSolicitudes.sol_fecha_firma, 'd')# DE #UCase(LsDateFormat(tbSolicitudes.sol_fecha_firma, 'mmmm'))# DE #LsDateFormat(tbSolicitudes.sol_fecha_firma, 'yyyy')#</cfoutput>
                            <br><br><br>
                        </span>
                        <span style="">______________________________________________________________</span>
                        <br/><br/>
                        <span style="font-family:sans-serif; font-size=12px; font-color=black;"><cfoutput>#Ucase(tbDirector.acd_prefijo)# #Ucase(tbDirector.acd_nombres)# #Ucase(tbDirector.acd_apepat)# #Ucase(tbDirector.acd_apemat)#</cfoutput></span>
                        </cfoutput>	                            
                    </td>
                </tr>
            </table>
        </div>	
		<!--- Información adicional --->
		<div style="position:absolute; bottom:10px; width:100%;">
			<table border="0" width="100%">
				<tr valign="bottom">
					<td><span style="font-family:sans-serif; font-size=10px; font-color=black;">CIC-CTIC-SAMAA</span></td>
					<td align="right">
                        <span style="font-family:sans-serif; font-size=10px; font-color=black;">
                            <cfoutput query="tbSolicitudes">
                                No. Solicitud: <b>FT_CTIC_#mov_clave#_#sol_id#_#sol_pos2#_#sol_pos1#_#LsDateFormat(sol_fecha_firma,'yyyymmdd')#</b>
                            </cfoutput>                            
                        </span>
                    </td>
				</tr>
			</table>
		</div>
	</cfdocumentitem>
</cfdocument>
