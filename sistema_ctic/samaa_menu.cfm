<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 01/08/2009--->
<!--- FECHA ÚLTIMA MOD.: 15/03/2017--->
<!--- PÁGINA PRINCIPAL PARA LOS ACCESOS DE LA COORDINACIÓN--->

<!--- INCLUDE PARA EL LLAMADO DE LAS BASES DE DATOS QUE SE REQUIEREN --->
<cfinclude template="menu_db.cfm">

<html>
	<head>
		<title>SAMAA - menus</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/herramientas.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/menus.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<script language="JavaScript" type="text/JavaScript">
			// Generar el calendario de sesiones:
			function fActualizarCalendario(mLink)
			{
				// Crear un objeto XmlHttpRequest:
				var xmlHttp = XmlHttpRequest();
				document.getElementById('calendario_dynamic').innerHTML = "<img src=\"<cfoutput>#vCarpetaIMG#</cfoutput>/wait.gif\">";
				// Función de atención a las petición HTTP:
				xmlHttp.onreadystatechange = function(){
					if (xmlHttp.readyState == 4) {
						document.getElementById('calendario_dynamic').innerHTML = xmlHttp.responseText;
					}
				}
				// Generar una petición HTTP:
				xmlHttp.open("POST", "calendario.cfm", true);
				xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=iso-8859-1');
				// Crear la lista de parámetros:		
				parametros = "mLink=" + encodeURIComponent(mLink); 
				// Enviar la petición HTTP:
				xmlHttp.send(parametros);
			}

			function fMenuLocation(vRuta)
			{
				window.parent.location = vRuta;
			}
		</script>
	</head>
	<body class="MenuPrincipal" onLoad="fActualizarCalendario('0');">
		<!-- Menú principal -->
		<cfoutput query="tbMenus">
            <div class="MenuPrincipalItem">
                <div class="MenuPrincipalItemTitulo">
					#UCASE(menu_nombre)#
                </div>
                <div class="MenuPrincipalItemModulos" style="cursor:pointer;" onClick="fMenuLocation('#ruta_liga#');">
					#menu_descrip# <!--- <a href="#ruta_liga#" target="_parent"></a> --->
                </div>
            </div>                
        </cfoutput>
        <!--- División por secciones --->
		<div style="float:left; margin-top:10px; width: 100%;"></div>
		<!--- Menú despliega de fechas --->
        <cfoutput>
            <div class="MenuPrincipalItem">
                <div class="MenuPrincipalItemTituloFechas">
                    Recepci&oacute;n de documentos
                </div>
                <div class="MenuPrincipalItemContenido">
                    Fecha l&iacute;mite de recepci&oacute;n de documentos:<br>
                    #ReReplace(LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionDoc.ssn_fecha, 'MMMM')#,
                    para la sesi&oacute;n #LSNUMBERFORMAT(tbSesionDoc.ssn_id,'9999')#.
                </div>
            </div>
            <div class="MenuPrincipalItem">
                <div class="MenuPrincipalItemTituloFechas">
                    Reuni&oacute;n de la CAAA
                </div>
                <div class="MenuPrincipalItemContenido">
                    Pr&oacute;xima reunión de la CAAA (#LSNUMBERFORMAT(tbSesionCAAA.ssn_id,'9999')#):<br>
                    <cfif IsDate(#tbSesion.ssn_fecha_m#)>
                        #ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
                    <cfelse>
                        #ReReplace(LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesionCAAA.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
                    </cfif>
                    #tbSesionCAAA.ssn_sede#
                </div>
            </div>
            <div class="MenuPrincipalItem">
                <div class="MenuPrincipalItemTituloFechas">
                    Sesi&oacute;n del Pleno
                </div>
                <div class="MenuPrincipalItemContenido">
                    Pr&oacute;xima Sesi&oacute;n <strong>Ordinaria</strong> del pleno (#vSesionVig#):<br>
                    <cfif IsDate(#tbSesion.ssn_fecha_m#)>
                        #ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha_m, 'MMMM')# a las 10:00 hrs.<br>
                    <cfelse>
                        #ReReplace(LSDATEFORMAT(tbSesion.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LSDATEFORMAT(tbSesion.ssn_fecha, 'DD')# de #LSDATEFORMAT(tbSesion.ssn_fecha, 'MMMM')# a las 10:00 hrs.<br>
                    </cfif>
                    #tbSesion.ssn_sede#
				  <cfif #tbSesionExtra.RecordCount# GT 0>
                        <br><br>
                            Pr&oacute;xima Sesi&oacute;n <strong>Extraordinaria</strong> del Pleno:<br>
                            #ReReplace(LsDateFormat(tbSesionExtra.ssn_fecha, 'DDDD'),"(.)","\u\1")# #LsDateFormat(tbSesionExtra.ssn_fecha, 'DD')# de #LsDateFormat(tbSesionExtra.ssn_fecha, 'MMMM')# a las #LsTimeFormat(tbSesionExtra.ssn_fecha, 'HH:mm')# hrs.<br>
                    </cfif>
                </div>
            </div>
		</cfoutput>
        <!--- División por secciones --->
		<div style="float:left; margin-top:10px; width: 100%;"></div>
		<!--- Menú de otros --->
        <cfoutput>
            <div class="MenuPrincipalItemCalendario">
                <div class="MenuPrincipalItemGrisTitulo">
					Calendario de Sesiones
                </div>
                <div class="MenuPrincipalItemContenido">
					<div id="calendario_dynamic" width="50%" style="margin-top:25px;"><!-- AJAX: Calendario de sesiones --></div>
                </div>
            </div>
            <div class="MenuPrincipalItemOtros">
                <div class="MenuPrincipalItemGrisTitulo">
					Avisos importantes
                </div>
                <div class="MenuPrincipalItemContenido">
					<cfinclude template="include_avisos.cfm">
                </div>
            </div>
            <div class="MenuPrincipalItemOtros">
                <div class="MenuPrincipalItemGrisTitulo">
					Contacto
                </div>
                <div class="MenuPrincipalItemContenido">
					<br />
					<span class="Sans11Ne">Correo electr&oacute;nico:</span><br>
					<span class="Sans10Ne"><a href="mailto:samaa@cic-ctic.unam.mx">samaa@cic.unam.mx</a></span>
					<br><br>
					<span class="Sans11Ne">Tel&eacute;fonos: </span><br>
					<span class="Sans10Ne">5622-4168 y 5622-4170</span><br>
					<br><br>
					<span class="Sans10Ne">Aram Pichardo Durán</span><br>
					<span class="Sans10Ne">José Antonio Esteva Ramírez</span><br>
                </div>
            </div>
		</cfoutput>
        <cfinclude template="#Application.vCarpetaRaizLogica#/include_pie.cfm">
	</body>
</html>