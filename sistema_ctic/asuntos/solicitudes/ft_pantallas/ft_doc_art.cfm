<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 16/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 24/11/2016 --->

<!--- Obtener los datos sobre los documentos que se requieren anexar a la FT --->

<cfparam name="vFt" default="0">
<cfparam name="vTipoVista" default=0>

<cfquery name="ctMovimientoTemp" datasource="#vOrigenDatosSAMAA#">
	SELECT mov_noft + '.- ' + mov_titulo as vcTitulo, mov_clave as vcMovClave 
    FROM catalogo_movimiento
    WHERE mov_status = 1
</cfquery>

<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>

<!--- Obtener la documentación de movimiento --->
<cfquery name="ctMovimientoDoc" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_doc 
    WHERE mov_clave = #vFt#
    ORDER BY mov_doc_orden
</cfquery>
<!--- Obtener la legislación del movimiento --->
<cfquery name="ctMovimientoArt" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_art 
    WHERE mov_clave = #vFt# 
    ORDER BY mov_articulo
</cfquery>
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!---
		<cfoutput>
			<link href=">#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">	
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
		</cfoutput>
---->
		<style type="text/css">
			body {
				margin: 0px;
				padding: 0px;
				width:829px;
			}
			ul {
				margin: 10px 5px 10px 5px;
			}
			@media print {
				.botones {
					display: none;
				}
			}
		</style>
		<script type="text/javascript">
			// Solución temporal hasta que ColdFusion permita procesar javascript con CFDOCUMENT:
			function fImprimir()
			{
				if (print) 
				{
					focus();
					print();
				} 
				else 
				{
					var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
					focus();
					document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
					WebBrowser1.ExecWB(6, 1); // Utilizar "2" en lugar de "1" para que no aparezca la ventana de diálogo de impresión.
				}
			}
			function fSelSolicitud()
			{
				document.forms[0].submit();
			}
		</script>
	</head>
	<body>
		<cfif #vTipoVista# EQ 1>
			<cfform name="formFt" method="post" action="ft_doc_art.cfm">
			<table width="100%" cellspacing="0" cellpadding="1">
				<tr>
					<td height="14" style="padding: 5px; background-color: #FFCC66">
	                    <cfselect name="vFt" id="vFt" query="ctMovimientoTemp" queryPosition="below" value="vcMovClave" display="vcTitulo" selected="#vFt#" onChange="document.forms[0].submit();" class="datos100">
							<option value="0">Seleccione la solicitud para ver los documentos para realizar tramites</option>
	                    </cfselect>
		                <cfinput type="hidden" name="vTipoVista" id="vTipoVista" value="#vTipoVista#">
					</td>
	            </tr>
			</table>
			</cfform>
        </cfif>

		<cfif #vFt# NEQ '0'>
			<!-- Información sobre la FT -->
			<cfoutput>
				<center>
					<span class="Sans10GrNe"></span><br>
					<span class="Sans10NeNe">#ctMovimiento.mov_titulo# (#ctMovimiento.mov_noft#)</span><br>
					<span class="Sans10Gr">#ctMovimiento.mov_subtitulo#</span><br><br>
				</center>
			</cfoutput>
			<!-- Contenido -->
			<table width="100%" border="0" cellpadding="2" cellspacing="1">
				<!-- Especificaciones generales -->
				<tr bgcolor="#CCCCCC">
					<td align="center" class="Sans10ViNe">Especificaciones generales</td>
				</tr>	
				<tr>
					<td class="Sans10Gr">
						<ul>
							<li>
								La documentaci&oacute;n completa del asunto (sin probatorios) debe digitalizarse y enviarse a trav&eacute;s del sistema. 
								En papel, deben enviarse los documentos originales<cfif #vFt# NEQ 14>y una copia fotost&aacute;tica.</cfif>
							</li>	
						</ul>
					</td>	
				</tr>
				<!-- Documentos que debe anexar -->
				<tr bgcolor="#CCCCCC">
					<td align="center" class="Sans10ViNe">Documentos que debe anexar</td>
				</tr>
				<tr>
					<td valign="top">
						<ul>
							<li class="Sans10Gr">Forma telegrámica</li>
							<cfoutput query="ctMovimientoDoc">
								<cfif #ctMovimientoDoc.mov_doc_tipo# IS 'DOC'>
									<li class="Sans10Gr">#ctMovimientoDoc.mov_doc_descrip#</li>
								</cfif>
							</cfoutput>
						</ul>
					</td>
				</tr>
				<!-- Articulos del EPA -->
				<cfif #ctMovimientoArt.RecordCount# GT 0>
					<tr bgcolor="#CCCCCC">
						<td align="center"><span class="Sans10ViNe">Art&iacute;culo(s) del E.P.A.</span></td>
					</tr>
					<tr>
						<td valign="top">
							<ul>
								<cfoutput query="ctMovimientoArt">
									<li class="Sans10Gr">
										#ctMovimientoArt.mov_ley#
										#ctMovimientoArt.mov_articulo# #ctMovimientoArt.mov_incisos#
									</li>
								</cfoutput>
							</ul>
                            <br /><br />
                            <div align="center">
								<span class="Sans10NeNe">
	                            *<a href="http://www.abogadogeneral.unam.mx/legislacion/abogen/documento.html?doc_id=36" target="winAbogadoGeneral">CONSULTAR EL E.P.A. EN LÍNEA</a>*
								</span>
							</div>
						</td>
					</tr>
				</cfif>	
			</table>
			<br>
			<!-- Notas -->
			<cfoutput query="ctMovimientoDoc">
				<cfif #ctMovimientoDoc.mov_doc_tipo# IS 'NOT'>
					<span class="Sans10ViNe">Nota:</span>
					<span class="Sans10Vi">
						#ctMovimientoDoc.mov_doc_descrip#
					</span>
					<br>
				</cfif>
			</cfoutput>
		</cfif>        
<!---
		<br><br>
		<center>
		<cfif #vFt# NEQ '0'>
			<input type="button" onClick="fImprimir();" value="Imprimir" class="botones">
		</cfif>
			<input type="button" onClick="window.close();" value="Cerrar" class="botones">
		</center>	
---->
	</body>
</html>

