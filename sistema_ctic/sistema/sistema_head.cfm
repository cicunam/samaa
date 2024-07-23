<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/01/2010 --->
<!--- FECHA ÚLTIMA MOD.: 04/09/2018 --->


<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="9">

<cfif #Session.sUsuarioNivel# LTE 1 >
	<cfset vMarcaInicioMenu = 1>
<cfelseif #Session.sUsuarioNivel# EQ 0>
	<cfset vMarcaInicioMenu = 4>
</cfif>

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
	<body onLoad="MarcarModulo(<cfoutput query="tbSistemaSubMenu" startrow="#vMarcaInicioMenu#" maxrows="1">'#submenu_control_id#'</cfoutput>)">
		<!--- Encabezado base --->
		<cfinclude template="#vCarpetaRaizLogica#/include_head.cfm">
		<!--- Menú del módulo --->
		<table class="MenuEncabezado" cellpadding="0" cellspacing="0">
			<tr>
				<cfoutput query="tbSistemaSubMenu">            
                    <td width="20%"><div id="#submenu_control_id#" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('#ruta_liga#'); MarcarModulo('#submenu_control_id#');">#submenu_nombre#</div></td>
				</cfoutput>            
				<td class="MenuEncabezadoBotonMenu">
					<!--- <a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a> --->
				</td>
			</tr>
		</table>
	</body>
</html>
