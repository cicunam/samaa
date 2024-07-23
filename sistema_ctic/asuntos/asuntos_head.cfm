<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/09/2016 --->
<!--- FECHA ÚLTIMA MOD.: 28/02/2022 --->

<!--- FRAME SUPERIOR DEL SISTEMA PARA LA ADMINISTACIÓN DE SOLICITUDES Y ASUNTOS  --->

<cfheader name="Expires" value="#Now()#">
<cfheader name="Pragma" value="no-cache">

<cfif #Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 3>
	<cfset vMarcaInicioMenu = 2>
<cfelseif #Session.sTipoSistema# EQ 'sic' OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# GTE 3)>
	<cfset vMarcaInicioMenu = 1>
</cfif>

<!--- LLAMADO A LA TABLA DE SUBMENÚ --->
<cfset vMenuClave = 1>
<cfinclude template="#vCarpetaCOMUN#/include_db_submenu.cfm">

<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSSGlobal#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSSGlobal#/encabezados.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/herramientas.css" rel="stylesheet" type="text/css">
            <script type="text/javascript" src="#vCarpetaRaizLogicaSistema#/comun/java_script/mascara_entrada.js"></script>
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
			function fBuscaSolicitud()
			{
				if (document.getElementById('txtBuscaSol').value > 0)
				{
					parent.frames[2].location.replace('solicitudes/busqueda_solicitud.cfm?vSolIdBusqueda=' + document.getElementById('txtBuscaSol').value);
				}
			}
        </script>
	</head>

	<body onLoad="MarcarModulo(<cfoutput query="tbSistemaSubMenu" startrow="#vMarcaInicioMenu#" maxrows="1">'#submenu_control_id#'</cfoutput>)">
		<!--- Encabezado base --->
        <cfinclude template="#vCarpetaRaizLogica#/head.cfm">
		<!--- Menú del módulo para entidades --->
		<cfif #Session.sTipoSistema# IS 'stctic' AND #Session.sUsuarioNivel# LT 5>
			<cfoutput>
                <div id="AsuntosBusqueda" class="MenuBusqueda" style="position:fixed; left:830px; top:95px;"><!---Buscar solicitud:---><input type="text" name="txtBuscaSol" id="txtBuscaSol" value="" size="17" maxlength="10" class="textosBusqueda" onKeyPress="return MascaraEntrada(event, '9999999');" placeholder="Buscar solicitud..."></div>
                <div id="AsuntosBusqueda" class="MenuBusqueda" style="position:fixed; left:950px; top:92px;"><img style="cursor:pointer; border:none;" src="#vCarpetaICONO#/busqueda_20.png" title="Iniciar búsqueda" onClick="fBuscaSolicitud();"></div>
            </cfoutput>
		</cfif>        
        <table class="MenuEncabezado" cellpadding="0" cellspacing="0">
            <tr>
				<cfoutput query="tbSistemaSubMenu">            
                    <td width="20%"><div id="#submenu_control_id#" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('#ruta_liga#'); MarcarModulo('#submenu_control_id#');">#submenu_nombre#</div></td>
				</cfoutput>
                <td class="MenuEncabezadoBotonMenu">
                    <a onClick="window.open('solicitudes/ft_pantallas/ft_doc_art.cfm?vTipoVista=1', '_blank', 'modal=yes,location=no,menubar=no,titlebar=no,width=635,height=550,resizable=yes,scrollbars=yes,status=no');">Ayuda</a>
                </td>
            </tr>
        </table>
	</body>
</html>	

