<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 06/05/2010 --->
<!--- SELECCIONAR UN ARCHIVO PDF PARA ENVIARLO AL SERVIDOR --->
<!------------------------------------------------------------>
<cfparam name="vIdSol" default=0>
<!--- Obtener datos del movimiento relacionado --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id
	WHERE movimientos.sol_id = #vIdSol# AND asu_reunion = 'CTIC'
</cfquery>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Envio de documentaci&oacute;n digitalizada</title>
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/formularios.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
		<script type="text/javascript">
			// Enviar el archivo seleccionado al servidor:
			function fEnviarArchivo(vAccion)
			{
				if (document.getElementById('selecciona_pdf').value == '')
				{
					alert('Por favor, seleccione el archivo que desea enviar al servidor.')
				}
				else
				{
					document.forms[0].submit();
				}
			}
		</script>		
    </head>
	<!-- Ventana de diálogo para seleccionar el archivo que se enviará al servidor -->
	<body style="margin:auto;">
		<cfform enctype="multipart/form-data" method="post" action="mov_archivo_envia.cfm">
			<!-- Campos ocultos -->
			<cfinput type="hidden" name="vIdAcd" value="#tbMovimientos.acd_id#">
			<cfinput type="hidden" name="vIdSol" value="#tbMovimientos.sol_id#">
			<cfinput type="hidden" name="vIdSes" value="#tbMovimientos.ssn_id#">
			<table border="0" class="cuadros" bgcolor="#CCCCCC">
				<!-- Leyenda -->
				<tr>
					<td width="385"><span class="Sans10NeNe">Seleccione el archivo a enviar</span></td>
				</tr>
				<!-- Control para seleccionar archivo -->
				<tr>
					<td><cfinput type="file" name="selecciona_pdf" class="datos" id="selecciona_pdf" size="50"></td>
				</tr>
				<!-- Indicaciones -->
				<tr>
					<td>
						<span class="Sans9GrNe">Recuerde que los archivos deben ser enviados en:</span>
		                <br>
		                <span class="Sans10NeNe">Formato: </span>Adobe Acrobat (PDF)<br />
		                <span class="Sans10NeNe">Tipo de salida: </span>Blanco y negro<br />
		                <span class="Sans10NeNe">Resoluci&oacute;n: </span>300 dpi
					</td>
				</tr>
				<!-- Botones de comando -->
				<tr>	
					<td align="center">
						<cfinput type="button" name="cmdEnvia_pdf" id="cmdEnvia_pdf" value="Enviar archivo" class="botones" onclick="fEnviarArchivo();">
						<cfinput type="button" name="cmdCancelar" id="cmdCancelar" value="Cancelar" class="botones" onclick="parent.document.getElementById('ifrmSelArchivo').style.display='none';">
					</td>
				</tr>
			</table>
		</cfform>
	</body>
</html>
