<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 25/05/2010 --->
<!--- Obtener datos del usuario actual --->
<cfquery name="ruta_archivo" datasource="#vOrigenDatosACCESO#">
	SELECT * FROM acceso WHERE clave = '#Session.sLoginSistema#'
</cfquery>

<!--- Definición de variables --->
<cfset vFechaHoy=#LsDateFormat(Now(), "dd/mm/yyyy")#>
<cfset vUsuarioId = #ruta_archivo.Usuario_id#>
<cfset vNombreArchivoNuevo = #vacd_id# & "_" & #vIdSol# & ".pdf">

<!--- Verifica el status de la solicitud para determinar el envio de la solicitud --->
<cfif #vStatusId# EQ 4 OR #vStatusId# EQ 3>
	<cfset vCarpetaTemporal = #vCarpetaEntidad# & #MID(vIdDep,1,4)#>
<cfelseif #vStatusId# EQ 2 OR #vStatusId# EQ 1 OR #vStatusId# EQ 0>
	<cfset vCarpetaTemporal = #vCarpetaCAAA#>
</cfif>    

<!--- Envia el archivo al servidor si el status de la solicitud es 4 o 3 lo envia a la carpeta de la entidad si es 2 o 1 lo envia a la de sesión --->
<cffile action="UPLOAD" filefield="selecciona_pdf" destination="#vCarpetaTemporal#" nameconflict="overwrite">
<!---<cffile action="UPLOAD" filefield="selecciona_pdf" destination="#vCarpetaEntidad##MID(vIdDep,1,4)#" nameconflict="overwrite">--->

<!--- Verifica que el archivo sea PDF --->
<cfset vMimeArchivo = #cffile.contentType# & "/" & #cffile.clientFileExt#>
<cfif #vMimeArchivo# EQ "application/pdf">
	<cfset vNomArchivoAnt = #cffile.attemptedServerFile#>
	<cffile action="RENAME" source="#vCarpetaTemporal#\#cffile.attemptedServerFile#" destination="#vCarpetaTemporal#\#vNombreArchivoNuevo#" nameconflict="overwrite">
	<!---<cffile action="RENAME" source="#vCarpetaEntidad##MID(vIdDep,1,4)#\#cffile.attemptedServerFile#" destination="#vCarpetaEntidad##MID(vIdDep,1,4)#\#vNombreArchivoNuevo#" nameconflict="overwrite">---->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (#vUsuarioId# ,'E','#vNombreArchivoNuevo#', '#vNomArchivoAnt#', GETDATE(), '#CGI.REMOTE_ADDR#')
	</cfquery>
    <cfset vStatusArchivo = "OK">
<cfelse>
	<cffile action="delete" file="#vCarpetaTemporal#\#cffile.attemptedServerFile#">
	<!---<cffile action="delete" file="#vCarpetaEntidad##MID(vIdDep,1,4)#\#cffile.attemptedServerFile#">--->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_archivos (usuario_id, archivo_tipo_mov, archivo_nombre, archivo_nombre_ant, archivo_fecha, archivo_ip)
		VALUES (#vUsuarioId# ,'B','#cffile.attemptedServerFile#', 'NO ES UN ARCHIVO DE ADOBE ACROBAT', GETDATE(), '#CGI.REMOTE_ADDR#')
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
			function fCierraVentana()
			{
				// ...
				parent.document.getElementById('ifrmSelArchivo').src = 'enviar_pdf/ft_archivo_selecciona.cfm?&vIdSol=<cfoutput>#vIdSol#</cfoutput>';
				parent.document.getElementById('ifrmSelArchivo').style.display = 'none';
				// Actualizar menú:
				parent.frames[1].document.getElementById('ExisteArchivoPDF').style.display = '';
				parent.frames[1].document.getElementById('NoExisteArchivoPDF').style.display = 'none';
				parent.frames[1].document.getElementById('cmdEnvioPdf').value = 'Reenviar archivo';
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
