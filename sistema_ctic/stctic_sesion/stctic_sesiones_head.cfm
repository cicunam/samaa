<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 11/01/2017--->
<!--- FECHA ÚLTIMA MOD.: 17/01/2018 --->

<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="8">

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
            <link href="#vCarpetaCSSGlobal#/encabezados.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSSGlobal#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
        <!--- JAVASCRIT LOCAL --->
		<script type="text/javascript">
            function MarcarModulo(MS)
            {
                <cfoutput query="tbSistemaSubMenu">
                    document.getElementById('#submenu_control_id#').className = "MenuEncabezadoBoton";
                </cfoutput>
                document.getElementById(MS).className = "MenuEncabezadoBotonSeleccionado";
            }
        </script>
	</head>

	<body onLoad="MarcarModulo(<cfoutput query="tbSistemaSubMenu" startrow="1" maxrows="1">'#submenu_control_id#'</cfoutput>)">
		<!--- Encabezado base --->
		<cfinclude template="#vCarpetaRaizLogica#/include_head.cfm">
		<!--- Menú del módulo --->
        <table class="MenuEncabezado" cellpadding="0" cellspacing="0">
            <tr>
				<cfoutput query="tbSistemaSubMenu">            
                    <td width="20%"><div id="#submenu_control_id#" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('#ruta_liga#'); MarcarModulo('#submenu_control_id#');">#submenu_nombre#</div></td>
				</cfoutput>
                <td class="MenuEncabezadoBotonMenu">
<!---
					<a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a>
--->					
				</td>
			</tr>
		</table>
	</body>
</html>
