<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 26/02/2010 --->

<cfparam name="vIdSol" default=0>

<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud WHERE sol_id = #vIdSol#
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <!---<title>SAMAA Envio Archivo Orden del Día para la sesión (<cfoutput>#vIdSsn#</cfoutput>)</title>--->
		<title>Envio de documentaci&oacute;n digitalizada</title>
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			// Valida que el archivo se seleccionó:
			function fValidaArchivo(vAccion)
			{
				if (document.getElementById('selecciona_pdf').value == '')
				{
					alert('No ha seleccionado ningún archivo.')
				}
				else
				{
					document.forms['formEnviaArchivo'].submit();
				}
			}
		</script>		
    </head>
	<body style="margin:auto;">
	<cfform name="formEnviaArchivo" id="formEnviaArchivo" enctype="multipart/form-data" method="post" action="ft_archivo_envia.cfm">
		<!-- Campos ocultos -->
		<cfinput type="hidden" name="vIdDep" id="vIdDep" value="#tbSolicitudes.sol_pos1#">
		<cfinput type="hidden" name="vAcd_id" id="vacd_id" value="#tbSolicitudes.sol_pos2#"><!--- Corregir el valor de la variable: vIdAcad --->
		<cfinput type="hidden" name="vIdSol" id="vIdSol" value="#tbSolicitudes.sol_id#">
		<cfinput type="hidden" name="vStatusId" id="vStatusId" value="#tbSolicitudes.sol_status#">    
		<table border="0" class="cuadros" bgcolor="#CCCCCC">
			<tr>
				<td width="385"><span class="Sans10NeNe">Seleccione el archivo a enviar</span></td>
			</tr>
			<tr>
				<td><cfinput type="file" name="selecciona_pdf" class="datos" id="selecciona_pdf" size="50"></td>
			</tr>
			<tr>
				<td>
					<span class="Sans9GrNe">Recuerde que los archivos deben ser enviados en:</span>
	                <br>
	                <span class="Sans10NeNe">Formato: </span>Adobe Acrobat (PDF)<br />
	                <span class="Sans10NeNe">Tipo de salida: </span>Blanco y negro<br />
	                <span class="Sans10NeNe">Resoluci&oacute;n: </span>300 dpi
				</td>
			</tr>
			<tr>	
				<td align="center">
					<cfinput type="button" name="cmdEnvia_pdf" id="cmdEnvia_pdf" value="Enviar archivo" class="botones" onclick="fValidaArchivo();">
					<cfinput type="button" name="cmdCancelar" id="cmdCancelar" value="Cancelar" class="botones" onclick="parent.document.getElementById('ifrmSelArchivo').style.display='none';//parent.window.location.reload(true);">
				</td>
			</tr>
		</table>
	</cfform>
	</body>
</html>
