<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 06/05/2010 --->
<!--- ENVIAR UN ARCHIVO AL SERVIDOR --->
<!------------------------------------->
<!--- Obtener información del usuario para los registros en la bitácora de envío de archivos --->
<cfquery name="ruta_archivo" datasource="#vOrigenDatosACCESO#">
	SELECT * FROM acceso WHERE clave = '#Session.sLoginSistema#'
</cfquery>
<!--- Definir algunas variables locales --->
<cfset vUsuario = #ruta_archivo.Usuario_id#>
<cfset vNombreArchivoNuevo = #vIdAcd# & "_" & #vIdSol# & "_" & #vIdSes# & ".pdf">
<!--- Subir al servidor el archivo seleccionado por el usuario --->
<cffile action="UPLOAD" filefield="selecciona_pdf" destination="#vCarpetaAcademicos#" nameconflict="overwrite">
<!--- Verificar que se haya subido un archivo PDF --->
<cfif #cffile.clientFileExt# IS "pdf">
	<!--- Registrar el nombre de archivo original --->
	<cfset vNomArchivoAnt = #cffile.attemptedServerFile#>
	<!--- Renombrar el archivo subido al servidor --->
	<cffile action="RENAME" source="#vCarpetaAcademicos & cffile.attemptedServerFile#" destination="#vCarpetaAcademicos & vNombreArchivoNuevo#" nameconflict="overwrite">
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (#vUsuario# ,'E','#vNombreArchivoNuevo#', '#vNomArchivoAnt#', GETDATE(), '#CGI.REMOTE_ADDR#')
	</cfquery>
    <cfset vStatusArchivo = "OK">
<cfelse>
	<cffile action="DELETE" file="#vCarpetaAcademicos & cffile.attemptedServerFile#">
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (#vUsuario# ,'B','#cffile.attemptedServerFile#', 'NO ES UN ARCHIVO DE ADOBE ACROBAT', GETDATE(), '#CGI.REMOTE_ADDR#')
	</cfquery>
    <cfset vStatusArchivo = "NOPDF">
</cfif>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Envio de documentaci&oacute;n digitalizada</title>
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			// Cerrar la ventana de envío de archivos:
			function fCierraVentana()
			{
				parent.document.getElementById('ifrmSelArchivo').style.display = 'none';
				parent.frames[1].document.getElementById('ExisteArchivoPDF').style.display = '';
			}
            </script>
	</head>
	<body <cfif #vStatusArchivo# EQ "OK">onload="fCierraVentana();"</cfif>>
		<table width="500" border="0" class="cuadros" bgcolor="#CCCCCC">
			<tr>
				<td align="center">
					<br>
					<cfif #vStatusArchivo# EQ "NOPDF">
						EL ARCHIVO NO ES DEL FORMATO REQUERIDO
					<cfelse>
						HUBO UN ERROR AL TRATAR DE ENVIAR EL ARCHIVO
					</cfif>
					<br>
				</td>
			</tr>
			<tr>
				<td align="center">
					<cfif #vStatusArchivo# EQ "NOPDF">
						<input type="button" value="REGRESAR" class="botones" onclick="window.history.go('-1')">
					</cfif>
					<input type="button" value="CERRAR VENTANA" class="botones" onclick="fCierraVentana();">
				</td>
			</tr>
		</table>
	</body>
</html>
