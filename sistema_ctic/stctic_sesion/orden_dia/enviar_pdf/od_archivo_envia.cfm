<cfset vFechaHoy=#LsDateFormat(Now(), "dd/mm/yyyy")#>
<cfset vNombreArchivoNuevo = 'ORDENDIA_' & #vIdSsn# & ".pdf">

<cffile action="UPLOAD" filefield="selecciona_pdf" destination="#vCarpetaSesionHistoria#" nameconflict="overwrite">

<cfset vMimeArchivo = #cffile.contentType# & "/" & #cffile.clientFileExt#>

<cfif #vMimeArchivo# EQ "application/pdf">
	<cfset vNomArchivoAnt = #cffile.attemptedServerFile#>

	<cffile action="RENAME" source="#vCarpetaSesionHistoria##cffile.attemptedServerFile#" destination="#vCarpetaSesionHistoria##vNombreArchivoNuevo#" nameconflict="overwrite">

	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (0 ,'E','#vNombreArchivoNuevo#', '#vNomArchivoAnt#', GETDATE(), '#CGI.REMOTE_ADDR#')
	</cfquery>
    <cfset vStatusArchivo = "OK">
<cfelse>
	<cffile action="delete" file="#vCarpetaSesionHistoria##cffile.attemptedServerFile#">

	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (0 ,'B','#cffile.attemptedServerFile#', 'NO ES UN ARCHIVO DE ADOBE ACROBAT', GETDATE(), '#CGI.REMOTE_ADDR#')
	</cfquery>
    <cfset vStatusArchivo = "NOPDF">
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>SAMAA Envio Archivo Orden del Día para la sesión (<cfoutput>#vIdSsn#</cfoutput>)</title>
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
		<script type="text/javascript">
			// Valida que el archivo se seleccionó:
			function fCierraVentana()
			{
//				window.frames['mainFrame'].reload()
				parent.window.location.reload()
			}
            </script>
	</head>
	<body>
	<table width="500" border="0" class="cuadros" bgcolor="#CCCCCC">
<tr>
                <td>
					<div align="center"><br><br>
                    <cfif #vStatusArchivo# EQ "OK">
                        EL ARCHIVO SE ENVIO CORRECTAMENTE		
                    <cfelseif #vStatusArchivo# EQ "NOPDF">
                        EL ARCHIVO NO ES DEL FORMATO REQUERIDO
                    </cfif>
                    </div><br><br>
                </td>
            </tr>
            <tr>
                <td>
                	<br>
					<div align="center">
                    <cfif #vStatusArchivo# EQ "NOPDF">
						<input type="button" value="     REGRESAR    " class="botones" onclick="window.history.go('-1')">
                    </cfif>
                    <input type="button" value="CERRAR VENTANA" class="botones" onclick="fCierraVentana();">
					</div>
                    <br>
                </td>
            </tr>
        </table>
	</body>
</html>
