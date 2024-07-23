<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 17/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 24/02/2022 --->
<!--- Impresión de las FTs --->


<!--- Obtener información de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT sol_id, mov_clave, sol_pos2, sol_pos1, sol_status, sol_fecha_firma, acd_id_firma
	FROM movimientos_solicitud 
	<!--- LEFT JOIN academicos ON academicos.acd_id = movimientos_solicitud.acd_id_firma --->
	WHERE sol_id = #vIdSol#
</cfquery>

<!--- Actualiza la base de datos de SOLICITUD al imprimir la forma telegramica final en caso de no tener información de fecha de impresion y/o académico que firma --->
<cfif #tbSolicitudes.sol_status# EQ 3>
	<!--- Actualiza la firma en caso de estar vacia --->
	<cfif #tbSolicitudes.sol_fecha_firma# EQ ''>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_fecha_firma = GETDATE()
			WHERE sol_id = #vIdSol#
		</cfquery>
    </cfif>
	<cfif #tbSolicitudes.acd_id_firma# EQ 0 OR #tbSolicitudes.acd_id_firma# EQ ''>
		<!--- Actualiza la firma en caso de estar vacia --->
        <cfquery name="tbDirector" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM academicos_cargos
            WHERE 1 = 1
            <cfif #pos1# EQ '030101' OR #Session.sIdDep# EQ '034201' OR #Session.sIdDep# EQ '034301' OR #Session.sIdDep# EQ '034401' OR #Session.sIdDep# EQ '034501'>
				AND academicos_cargos.dep_clave = '030101'
				AND academicos_cargos.adm_clave = 100
			<cfelse>
				AND academicos_cargos.dep_clave = '#pos1#'
	            AND academicos_cargos.adm_clave = 32
			</cfif>
            AND academicos_cargos.caa_status = 'A'       
<!---
            AND academicos_cargos.caa_fecha_inicio <= GETDATE() <!--- SE DESACTIVA TEMPORALMENTE --->
            AND academicos_cargos.caa_fecha_final >= GETDATE()
---->
        </cfquery>
		<cfset vAcdIdFirma = #tbDirector.acd_id#>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET acd_id_firma = #vAcdIdFirma#
			WHERE sol_id = #vIdSol#
		</cfquery>
    </cfif>

    <cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
        SELECT sol_id, mov_clave, sol_pos2, sol_pos1, sol_status, sol_fecha_firma, acd_id_firma
        FROM movimientos_solicitud 
        <!--- LEFT JOIN academicos ON academicos.acd_id = movimientos_solicitud.acd_id_firma --->
        WHERE sol_id = #vIdSol#
    </cfquery>
   
</cfif>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>

<!--- Obtener los artículos del EPA en los que se fundamenta el movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art 
    WHERE mov_clave = #vFt# ORDER BY mov_articulo
</cfquery>

<!--- Obtener la ubicación principal de la entidad que está capturando --->
<cfquery name="ctDepUbica" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_dependencia_ubica 
    WHERE dep_clave = '#pos1#' AND dbo.TRIM(ubica_clave) = '01'
</cfquery>

<!--- Obtener el nombre del director --->
<cfquery name="tbDirector" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud 
	LEFT JOIN academicos ON academicos.acd_id = movimientos_solicitud.acd_id_firma
    WHERE movimientos_solicitud.sol_id = #vIdSol#
</cfquery>

<!--- ANTERIOR AL 29/11/2017 
<cfoutput>#vIdSol# - #vFt# - #vIdAcad# - #vSolStatus#</cfoutput>
<cfhttp url="#vCarpetaRaizWebSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#?vTipoComando=IMPRIME&vIdAcad=#vIdAcad#&vFt=#vFt#&vSolStatus=#vSolStatus#&vIdSol=#vIdSol#" method="get" resolveurl="true">
	<cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
	<cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">

	<cfhttpparam type="formfield" name="vTipoComando" value="IMPRIME">
	<cfhttpparam type="formfield" name="vIdAcad" value="#vIdAcad#">
</cfhttp>
--->

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
    <cfhttp url="#vCarpetaRaizWebSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#" method="post" resolveurl="true">
        <cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
        <cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
        <cfhttpparam type="formfield" name="vTipoComando" value="IMPRIME">
        <cfhttpparam type="formfield" name="vIdSol" value="#vIdSol#">
        <cfhttpparam type="formfield" name="vFt" value="#vFt#">
        <cfhttpparam type="formfield" name="vIdAcad" value="#vIdAcad#">
        <cfhttpparam type="formfield" name="vSolStatus" value="#vSolStatus#">
    </cfhttp>

	<!--- Cuerpo de la FT --->
	<div style="padding-top:10px; margin-left:auto; margin-right:auto;"><cfoutput>#cfhttp.fileContent#</cfoutput></div>

	<!--- Pie de página de la FDT --->
	<cfdocumentitem type="footer">
    	<!--- NOTA: a partir del 30/06/2016 cambié de posición el texto de firma al pie de página ARAM --->
		<!--- Espacio para la firma del director (solo si la solicitud ya fue enviada) --->
        <cfif #vSolStatus# LTE 3>
            <div style="margin-top:10px; width:100%;"> <!--- Probar  page-break-inside:avoid; para que la firme quede en una sola página --->
                <table width="100%" border="0">
                    <tr>
                        <td align="center">
                            <cfoutput>                                
                            <span class="Sans9Gr">
                                <br>
                                <cfif #ctDepUbica.ubica_lugar# EQ "CIUDAD UNIVERSITARIA">Ciudad Universitaria, Cd. Mx.<cfelse>#ctDepUbica.ubica_lugar#</cfif>, <cfoutput>#LsDateFormat(tbSolicitudes.sol_fecha_firma, 'd')# DE #UCase(LsDateFormat(tbSolicitudes.sol_fecha_firma, 'mmmm'))# DE #LsDateFormat(tbSolicitudes.sol_fecha_firma, 'yyyy')#</cfoutput>
                                <br><br><br><br><br>
                            </span>
                            <span style="">______________________________________________________________</span><br />
                            <!--- <hr style="line-height:1px; color:##000000;" width="50%"> --->
                            <span class="Sans9GrNe"><cfoutput>#Ucase(tbDirector.acd_prefijo)# #Ucase(tbDirector.acd_nombres)# #Ucase(tbDirector.acd_apepat)# #Ucase(tbDirector.acd_apemat)#</cfoutput></span>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </div>
  
            <!--- Información adicional --->
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
        </cfif>
	</cfdocumentitem>
</cfdocument>
