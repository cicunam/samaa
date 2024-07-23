<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 28/01/2016--->
<!--- FECHA ULTIMA MOD.: 20/06/2022 --->

<!--- PENDIENTE --->

<cfset vAcadId = #Session.AcademicosFiltro.vAcadId#>

<!--- INCLUDE que abre la tabla de academicos e inserta en hidden tres datos --->
<cfinclude template="../include_datos_academico.cfm">

<!--- Llama las tablas del SNI --->
<cfquery name="ctSniAnios" datasource="#vOrigenDatosSNI#">
	SELECT * FROM catalogo_tablas_sni
    WHERE tabla_status = 1
	ORDER BY anio DESC
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
				document.getElementById('mPaSni').className = 'MenuEncabezadoBotonSeleccionado';
				fDatosAcademico(); 
			}
		</script>	
	</head>
	<body onLoad="fInicioCargaPagina();">
		<!-- Cintillo con nombre del módulo y filtro --> 
		<table class="Cintillo">
			<tr>
				<td><span class="Sans9GrNe">PERSONAL ACAD&Eacute;MICO &gt;&gt; </span><span class="Sans9Gr">SISTEMA NACIONAL DE INVESTIGADORES</span></td>
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
<!---
						<!-- Número de académico -->
						<tr>
							<td>
								<span class="Sans9GrNe">Registros: </span>
								<span class="Sans9Gr">
									<cfoutput>#LSNumberFormat(tbSni.RecordCount,'99999')#</cfoutput> de <cfoutput>#LSNumberFormat(tbSni.RecordCount,'99999')#</cfoutput>
								</span>
								<br>
								<span class="Sans9GrNe">Total: </span>
								<span id="vRegTot_dynamic" class="Sans9Gr">
									<cfoutput>#LSNumberFormat(tbSni.RecordCount,'99999')#</cfoutput>
								</span>
							</td>
						</tr>
--->				
					</table>
				</td>
				<td width="844" valign="top">
					<!-- Datos del académico -->
					<div id="AcadDatos_dynamic"><!-- AJAX: Lista Datos Académico --></div>
					<!-- Menú -->
					<cfset vTituloModulo = 'SISTEMA NACIONAL DE INVESTIGADORES'>
                    <cfinclude template="../include_menus.cfm">
                    <table style="width:98%; margin: 2px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1" align="center">
                        <!-- Encabezados -->
                        <tr valign="middle" bgcolor="#CCCCCC" height="18px">
                            <td><span class="Sans9GrNe">AÑO</span></td>
                            <td><span class="Sans9GrNe">ADSCRIPCIÓN</span></td>
                            <td align="center"><span class="Sans9GrNe">ÁREA</span></td>
                            <td><span class="Sans9GrNe">CAMPO</span></td>
                            <td align="center"><span class="Sans9GrNe">NIVEL</span></td>
                            <td width="15" bgcolor="#0066FF"><!-- Ver detalle --></td>
                        </tr>
                        <cfoutput query="ctSniAnios">
                            <!--- Llama las tablas del SNI --->
                            <cfquery name="tbSni" datasource="#vOrigenDatosSNI#">
                                SELECT exp, nivel, area, campo, adscripcion, #ctSniAnios.anio# AS vAnio 
                                FROM #ctSniAnios.tabla_sni_nombre#
                                WHERE 
                                <cfif #anio# LTE 2019>
                                    exp = #tbAcademico.sni_exp#
                                <cfelse>
                                    cvu = #tbAcademico.cvu#
                                </cfif>
                            </cfquery>
							<cfif #tbSni.RecordCount# GT 0>
                                <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">	
                                    <td><span class="Sans9Gr">#tbSni.vAnio#</span></td>
                                    <td><span class="Sans9Gr">#tbSni.adscripcion#</span></td>
                                    <td align="center"><span class="Sans9Gr">#tbSni.area#</span></td>
                                    <td><span class="Sans9Gr">#tbSni.campo#</span></td>
                                    <td align="center"><span class="Sans9Gr">#tbSni.nivel#</span></td>
                                    <td>
                                        <a href=""><img src="#vCarpetaICONO#/detalle_15.jpg" width="15" height="15" style="border:none;" title="Detalle"></a>
                                    </td>
    	                        </tr>
							</cfif>
						</cfoutput>
                    </table>
				</td>
			</tr>
		</table>
	</body>
</html>
