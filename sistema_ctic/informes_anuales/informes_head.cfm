<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 06/09/2018 --->
<!--- FRAME SUPERIOR DEL SISTEMA PARA CONSULTA DE LOS INFORMES ANUALES DE LOS ACADÉMICOS --->

<!--- PARÁMETROS --->
<cfparam name="vMenuClave" default="3">

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

<html>
	<head>
		<title>SAMAA - Informes Anuales</title>
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
					<!--- <a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a> --->
				</td>
<!---            
				<cfif #Session.sTipoSistema# IS 'stctic'>
                    <td><div id="InformesRec" class="MenuEncabezadoBotonSeleccionado" onClick="parent.frames[2].location.replace('consulta_informes.cfm?vInformeStatus=1'); MarcarModulo('InformesRec');">Informes recibidos</div></td>
                    <td><div id="InformesCaaa" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('consulta_informes.cfm?vInformeStatus=2'); MarcarModulo('InformesCaaa');">Informes en la CAAA</div></td>
                    <td><div id="InformesPleno" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('consulta_informes.cfm?vInformeStatus=3'); MarcarModulo('InformesPleno');">Informes en el Pleno</div></td>
				<cfelse>
					<td><div id="InformesEntidad" class="MenuEncabezadoBotonSeleccionado" onClick="parent.frames[2].location.replace('consulta_informes.cfm?vInformeStatus=0');">Informes anuales</div></td>
				</cfif>
				<td id="Ayuda" class="MenuEncabezadoBotonMenu">
					<a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a>
				</td>
--->				
			</tr>
		</table>
	</body>
</html>
