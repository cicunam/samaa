<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/09/2017 --->
<!--- FECHA ÚLTIMA MOD.: 10/10/2017 --->

<!--- IMPRESION DE LA LISTA DE DOCUMENTOS TURNADOS AL DEPARTAMENTO DE ARCHIVO --->
<!--- Enviar el contenido a un archivo MS Excel --->
<cfheader name="Content-Disposition" value="inline; filename=relacion_documentos_turnados_archivo_#vSsnId#_seccion_#Replace(Session.AsuntosCTICFiltro.vSeccion,'.','_','ALL')#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">

<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
	WHERE ssn_id = #vSsnId# 
	AND ssn_clave = 1
</cfquery>

<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM (((movimientos_solicitud AS T1
    LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id)
    LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id)
    LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
    LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave <!---CATALOGOS GENERALES MYSQL --->
    WHERE sol_status <= 1 <!--- Asuntos que pasan al pleno y asuntos resueltos --->
    AND T2.asu_reunion = 'CTIC' <!--- Registro de asunto CTIC --->
    AND T2.ssn_id = #vSsnId# <!--- Del acta seleccionada --->
    AND T2.asu_parte = #Session.AsuntosCTICFiltro.vSeccion# <!--- De la Sección seleccionada --->
    ORDER BY
    T2.asu_parte,
    T2.asu_numero
</cfquery>

<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:excel"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<!--- <link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados.css" rel="stylesheet" type="text/css"> --->
	</head>
	<body>
		<!--- Encabezado del listado del documento --->
        <table id="encabezado" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 10pt; font-family:'Times New Roman'">
			<tr>
                <td colspan="10" align="center">
                    <strong>CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA</strong>
                    <br />
                    <strong>RELACIÓN DE LOS DOCUMENTOS TURNADOA AL DEPARTAMENTO DE ARCHIVO</strong>
                </td>
            </tr>
            <tr>
                <td colspan="9">
					<cfoutput>
	                    <strong>ACTA: #tbSesiones.ssn_id# Aprobada el #FechaCompleta(tbSesiones.ssn_fecha)#</strong>
					</cfoutput>
                </td>
                <td colspan="1">
					<cfoutput>
	                    <strong>#LsDateFormat(now(),'dd/mm/yyyy')#</strong>
					</cfoutput>
                </td>
            </tr>
        </table>
		<!--- Generar oficios de respuesta --->
		<cfoutput query="tbSolicitudes" group="dep_clave">
			<!--- Si hay asuntos generar el oficio y lista anexa --->
			<cfif #tbSolicitudes.RecordCount# GT 0>
                <table id="encabezado" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 10pt; font-family:'Times New Roman'">
                    <!--- Encabezados --->
                    <tr style="border:##FFF">
                        <td colspan="3"><strong>#dep_nombre#</strong></td>
                        <td align="center"><strong>No. Exp.</strong></td>
                        <td align="center"><strong>Anexados</strong></td>
                        <td align="center"><strong>Rubricados</strong></td>
                        <td align="center"><strong>Folios</strong></td>
                        <td align="center"><strong>Fecha</strong></td>
                        <td align="center"><strong>Rúbrica</strong></td>
                        <td align="center"><strong>Número de documentos</strong></td>
                    </tr>
                </table>
				<!--- GENERA LISTA DE LOS DOCUMENTOS A TURNAR AL ARCHIVO --->
				<cfoutput group="sol_id">
                    <!--- Solo inclir las solicitudes seleccionadas --->
                    <cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #tbSolicitudes.sol_id#) IS TRUE>
						<table id="listado" width="100%" border="1" cellspacing="0" cellpadding="0" style="font-size: 10pt; font-family:'Times New Roman'">
							<tr style="border:##000">
								<!--- Nombre del académico --->
								<td>#MID(tbSolicitudes.asu_oficio,11,35)#</td>
								<!--- Nombre del académico --->
								<td>#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#</td>
								<!--- Categoría y nivel --->
								<td>#tbSolicitudes.mov_titulo#</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
                        </table>
                    </cfif>
                </cfoutput>
				<!--- Espacio --->
				<br />
			</cfif>
		</cfoutput>
        <table width="100%">
            <tr>
                <td align="left" class="PiePagina" width="40%">Nombre y firma de quien entrega: _________________________</td>
                <td align="left" class="PiePagina" width="30%">Nombre y firma de quien recibe:  _________________________</td>
                <td align="left" class="PiePagina" width="30%">Fecha: ______________</td>
            </tr>
        </table>
	</body>
</html>