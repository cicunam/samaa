<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 05/06/2009--->
<!--- FRAME SUPERIOR DEL SISTEMA PARA MOVER LOS ARCHIVOS ENVIADOS POR LAS ENTIDADES DEL SUBSISTEMA--->

<cfset vMenuClave = 4>

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
				//alert(MS);
				document.getElementById('PersonalA').className = "MenuEncabezadoBoton";
				//document.getElementById('Visitante').className = "MenuEncabezadoBoton";
				//document.getElementById('Becarios').className = "MenuEncabezadoBoton";
				document.getElementById('Ayuda').className = "MenuEncabezadoBotonMenu";
				document.getElementById(MS).className = "MenuEncabezadoBotonSeleccionado";
			}
		</script>
	</head>
	<body>
		<!--- Encabezado base --->
		<cfinclude template="#vCarpetaRaizLogica#/include_head.cfm">
		<!--- Menú del módulo --->
		<table class="MenuEncabezado" cellpadding="0" cellspacing="0">
			<tr> 
				<td><div id="PersonalA" class="MenuEncabezadoBotonSeleccionado" onClick="parent.frames[2].location.replace('consulta_academicos.cfm'); MarcarModulo('PersonalA');">Personal Acad&eacute;mico</div></td>
<!---
				<td><div id="Visitante" class="MenuEncabezadoBoton" onClick="alert('Lo sentimos, la opción seleccionada aún no está disponible.'); // MarcarModulo('Visitante');">Personal Visitante</div></td>
				<td><div id="Becarios" class="MenuEncabezadoBoton" onClick="alert('Lo sentimos, la opción seleccionada aún no está disponible.'); // MarcarModulo('Becario');">Becarios</div></td>
--->
				<td id="Ayuda" class="MenuEncabezadoBotonMenu">
					<a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a>
				</td>
			</tr>
		</table>
	</body>
</html>
