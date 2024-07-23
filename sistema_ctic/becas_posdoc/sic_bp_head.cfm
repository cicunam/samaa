<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ÚLTIMA MOD.: 18/02/2022--->

<!--- FRAME SUPERIOR DEL SISTEMA PARA MOVER LOS ARCHIVOS ENVIADOS POR LAS ENTIDADES DEL SUBSISTEMA--->
<cfquery name="Recordset1" datasource="#vOrigenDatosACCESO#">
	SELECT * FROM acceso WHERE Clave = '#Session.sLoginSistema#' 
</cfquery>

<cfset vMenuClave = 5>

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSSGlobal#/encabezados.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSSGlobal#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
		<script type="text/javascript">
			function MarcarModulo(MS)
			{
				document.getElementById('bpVencer').className = "MenuEncabezadoBoton";
				document.getElementById('bpInforme').className = "MenuEncabezadoBoton";
				document.getElementById(MS).className = "MenuEncabezadoBotonSeleccionado";
			}
		</script>
	</head>
	<body>
		<!--- Encabezado base --->
		<cfinclude template="../../include_head.cfm">
		<!--- Menú del módulo --->
		<table class="MenuEncabezado" cellpadding="0" cellspacing="0">
			<tr>
				<td><div id="bpVencer" class="MenuEncabezadoBotonSeleccionado" onClick="parent.frames[2].location.replace('consulta_vencer.cfm'); MarcarModulo('bpVencer');">Primera beca por finalizar</div></td>
				<td><div id="bpInforme" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('consulta_informe.cfm'); MarcarModulo('bpInforme');">Presentar informe anual o final</div></td>
				<td class="MenuEncabezadoBotonMenu">
					<a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a>
				</td>
			</tr>
		</table>
	</body>
</html>
