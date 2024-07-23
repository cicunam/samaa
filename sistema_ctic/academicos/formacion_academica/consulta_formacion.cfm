<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/06/2009--->
<!--- FECHA ULTIMA MOD.: 25/11/2015 --->

<!--- PENDIENTE --->

<cfset vAcadId = #Session.AcademicosFiltro.vAcadId#>

<cfinclude template="../include_datos_academico.cfm">
<!---
	<!--- Llama la tabla de ACADEMICO --->
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM academicos 
		WHERE acd_id = #vAcadId#
	</cfquery>
--->

<!--- Llama la tabla de FORMACION ACADEMICA --->
<cfquery name="tbFormacion" datasource="#vOrigenDatosCURRICULUM#">
	SELECT * FROM (formacion_academica AS T1
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_instituciones')# AS C1 ON T1.institucion_clave = C1.institucion_clave) <!---CATALOGOS GENERALES MYSQL --->
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_grados')# AS C2 ON T1.grado_clave = C2.grado_clave <!---CATALOGOS GENERALES MYSQL --->
	WHERE T1.acd_id = #vAcadId#
	ORDER BY C2.grado_clave, T1.cap_fecha_crea
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<script type="text/javascript" src="#vHttpWebGlobal#/xmlHttpRequest.js"></script>
		</cfoutput>
		<!--- JAVA SCRIPT USO LOCAL EN EL MÓDULO ACADÉMICOS --->
		<cfinclude template="../javaScript_academicos.cfm">
		<script type="text/javascript">
			<!-- LLAMADO DE INICIO -->
	        function fInicioCargaPagina()
	        {
				document.getElementById('mPaFa').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico(); 
			}
		</script>	
	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">FORMACI&Oacute;N ACAD&Eacute;MICA</span></td>
			</tr>
		</table>
		<table width="97%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="180" height="233" valign="top">
					<table width="180" border="0">
						<!-- Menú del submódulo -->
						<tr><td><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Men&uacute;:</div></td>
						</tr>
						<!-- Opción: Imprimir -->
						<tr>
							<td>
								<input type="button" class="botones" value="Imprimir">
							</td>
						</tr>
						<!-- Opción: Regresar -->
						<tr>
							<td>
								<input type="button" value="Regresar" class="botones" onClick="window.location.replace('../consulta_academicos.cfm');">
							</td>
						</tr>
                        <!---
						<!-- Nuevo registro -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<tr>
							<td valign="top"><div align="left" class="Sans10NeNe">Nuevo registro:</div></td>
						</tr>
						<tr>
							<td align="justify"><span class="Sans9Vi">Agregar un nuevo registro a la formaci&oacute;n del acad&eacute;mico:</span></td>
						</tr>
						<tr>
							<td>
								<input type="button" class="botones" value="Agregar" onClick="window.location.replace('formacion.cfm?vAcadId=<cfoutput>#vAcadId#</cfoutput>&vTipoComando=NUEVO');">
							</td>
						</tr>
						--->
						<!-- Más información -->
						<tr><td><br><div class="linea_menu"></div></td></tr>
						<!-- Número de académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Registros: </span>
								<span class="Sans9Gr">
									<cfoutput>#LSNumberFormat(tbFormacion.RecordCount,'99999')#</cfoutput> de <cfoutput>#LSNumberFormat(tbFormacion.RecordCount,'99999')#</cfoutput>
								</span>
								<br>
								<span class="Sans9GrNe">Total: </span>
								<span id="vRegTot_dynamic" class="Sans9Gr">
									<cfoutput>#LSNumberFormat(tbFormacion.RecordCount,'99999')#</cfoutput>
								</span>
							</td>
						</tr>
					</table>
				</td>
				<td width="844" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'FORMACIÓN ACADÉMICA'>
                    <cfinclude template="../include_menus.cfm">
                    <br/>
					<!-- MOVIMIENTOS EN MODO TABLA -->
					<cfif #tbFormacion.RecordCount# GT 0>
						<table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1" align="center">
							<!-- Encabezados -->
							<tr valign="middle" bgcolor="#CCCCCC" height="18px">
								<td class="Sans9GrNe">NIVEL</td>
								<td class="Sans9GrNe">INSTITUCIÓN</td>
								<td class="Sans9GrNe" align="center">GRADO OBTENIDO</td>
								<td class="Sans9GrNe">FECHA</td>
								<td width="15" bgcolor="#0066FF"><!-- Ver detalle --></td>
							</tr>
							<!-- Datos -->
							<cfoutput query="tbFormacion">
								<tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">	
									<td class="Sans9Gr">#grado_descrip#</td>
									<td class="Sans9Gr">#institucion_nombre#</td>
									<td align="center">
										<cfif #grado_obtenido# EQ 1>
											<img src="#vCarpetaICONO#/palomita_15.jpg" width="15" height="15" style="border:none;">
										</cfif>
									</td>
									<td class="Sans9Gr"><cfif #tbFormacion.fecha_grado# IS NOT ''>#LsDateFormat(tbFormacion.fecha_grado,'dd/mm/yyyy')#</cfif></td>
									<!-- Botón VER -->
									<cfset vFechaCreacion = '#LSDateFormat(tbFormacion.cap_fecha_crea,'dd/mm/yyyy')# #LSTimeFormat(tbFormacion.cap_fecha_crea,'HH:mm:ss')#'>
									<td>
										<a href="formacion.cfm?vAcadId=#vAcadId#&vFechaCreacion=#vFechaCreacion#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" width="15" height="15" style="border:none;" title="Detalle"></a>
									</td>
							</cfoutput>
						</table>
					</cfif>
					<cfif (#Session.sTipoSistema# EQ 'sic') OR (#Session.sTipoSistema# EQ 'stctic' AND #Session.sUsuarioNivel# LT 3)>                    
                        <table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1" align="center">
                            <cfoutput>
                                <tr>
                                    <td width="98%"><span class="AgregarRegTexto"><i>AGREGAR NUEVO REGISTRO DE FORMACI&Oacute;N ACAD&Eacute;MICA ...</i></span></td>
                                  <td width="2%"><img src="#vCarpetaICONO#/agregar_15.jpg" width="15" height="15" style="border:none; cursor:pointer;" title="Nuevo registro" onClick="window.location.replace('formacion.cfm?vAcadId=#vAcadId#&vTipoComando=NUEVO');"></td>
                                </tr>
                            </cfoutput>
                        </table>
					</cfif>
				</td>
			</tr>
		</table>
	</body>
</html>
