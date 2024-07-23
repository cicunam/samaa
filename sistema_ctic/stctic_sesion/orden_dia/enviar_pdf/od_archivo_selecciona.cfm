<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 26/02/2010 --->

<cfparam name="vIdSsn" default=0>

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
			function fValidaArchivo()
			{
				if (document.getElementById('selecciona_pdf').value == '')
				{
					alert('No se ha seleccionado el archivo')
				}
				else
				{
					document.forms['formEnviaArchivo'].action = 'od_archivo_envia.cfm';
					document.forms['formEnviaArchivo'].submit();
				}
			}
		</script>		
    </head>
<body>
<cfform name="formEnviaArchivo" id="formEnviaArchivo" enctype="multipart/form-data" method="post" action="">
	<table width="500" border="0" class="cuadros" bgcolor="#CCCCCC">
		<tr>
			<td width="385"><span class="Sans10NeNe">Seleccione el archivo a enviar</span></td>
			<td width="96" align="center">
            	CANCELAR
				<cfinput type="hidden" name="vIdSsn" id="vIdSsn" value="#vIdSsn#"><br />
			</td>
		</tr>
		<tr>
			<td><cfinput type="file" name="selecciona_pdf" class="datos" id="selecciona_pdf" size="50"></td>
			<td><cfinput type="button" name="cmdEnvia_pdf" id="cmdEnvia_pdf" value="Enviar archivo" class="botones" onClick="fValidaArchivo();"></td>
		</tr>
		<tr>
			<td colspan="2">
				<p><span class="Sans9GrNe">Recuerde que los archivos deben ser enviados en:</span><br />
                <br>
                <span class="Sans10NeNe">Formato: </span>Adobe Acrobat (PDF)<br />
                <span class="Sans10NeNe">Tipo de salida: </span>Blanco y negro<br />
                <span class="Sans10NeNe">Resoluci&oacute;n: </span>300 dpi</p>
			</td>
		</tr>
	</table>
</cfform>
</body>
</html>
