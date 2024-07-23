<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ULTIMA MOD.: 04/12/2023 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="3.1" unit="cm">		
	<!--- Parámetros de filtrado --->
	<cfparam name="vAcadId" default="#Session.AcademicosFiltro.vAcadId#">
	<cfparam name="vAcadNom" default="#Session.AcademicosFiltro.vAcadNom#">
	<cfparam name="vAcadRfc" default="#Session.AcademicosFiltro.vAcadRfc#">
	<cfparam name="vCn" default="#Session.AcademicosFiltro.vCn#">
	<cfparam name="vContrato" default="#Session.AcademicosFiltro.vContrato#">
	<cfparam name="vAcadDep" default="#Session.AcademicosFiltro.vAcadDep#">
	<cfparam name="vActivo" default="#Session.AcademicosFiltro.vActivo#">
	<cfparam name="vOrden" default="#Session.AcademicosFiltro.vOrden#">
	<cfparam name="vOrdenDir" default="#Session.AcademicosFiltro.vOrdenDir#">
	<html>
		<head>
			<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<!--- Obtener la lista de académicos --->
			<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM ((academicos AS T1
					LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave)
					LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave)
					LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_contratos')# AS C3 ON T1.con_clave = C3.con_clave
					WHERE 1=1
					<cfif #vAcadId# IS NOT ''> AND acd_id = #vAcadId#</cfif>
					<cfif #vAcadRfc# IS NOT ''> AND acd_rfc LIKE '%#vAcadRfc#%'</cfif>
					<!---<cfif #vAcadNom# IS NOT ''> AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vAcadNom#%'</cfif>--->
					<cfif isDefined('vAcadDep') AND #vAcadDep# IS NOT ''> AND  T1.dep_clave = '#vAcadDep#'</cfif>
					<cfif #vCn# IS NOT ''>
						<cfif #vCn# EQ 'INV' OR #vCn# EQ 'TEC'>
							AND C2.cn_clase = '#vCn#'
						<cfelse>
							AND T1.cn_clave = '#vCn#'
						</cfif>
					</cfif>
					<cfif #vContrato# IS NOT ''> AND T1.con_clave = #vContrato#</cfif>
					<cfif #Session.sTipoSistema# IS 'stctic' AND #vAcadDep# IS NOT ''>
						AND T1.dep_clave = '#vAcadDep#'
					<cfelseif #Session.sTipoSistema# IS 'sic'>	
						AND T1.dep_clave = '#Session.sIdDep#'
					</cfif>
					<cfif #vActivo# IS 1>AND T1.activo = 1</cfif>
					<!--- Ordenamiento --->
					<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
				</cfquery>
				<!--- Encabezado --->
				<cfdocumentitem type="header">
					<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
					<!-- Titulo da la página --->
					<center>
						<span style="font-size:9pt;">
							<br>
							<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
							<br>
							<b><cfoutput>#Session.sDep#</cfoutput></b>
							<br><br>
							<i>LISTA DE ACAD&Eacute;MICOS</i>
							<br>
							<br>
						</span>
					</center>
					<!-- Encabezados de las columnas -->
					<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
						<!-- Línea -->
						<tr><td colspan="5"><hr class="doble"></td></tr>
						<!-- Encabezados -->
						<tr valign="middle">
							<td class="Sans9GrNe" width="40">ID</td>
							<td class="Sans9GrNe">Nombre</td>
							<td class="Sans9GrNe" width="180">Contrato</td>
							<td class="Sans9GrNe" width="120">Categor&iacute;a</td>
							<cfif #Session.sTipoSistema# IS 'stctic'><td class="Sans9GrNe" width="50">Entidad</td></cfif>
						</tr>
						<!-- Línea -->
						<tr><td colspan="5"><hr class="doble"></td></tr>
					</table>
				</cfdocumentitem>
				<!-- Tabla de datos -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<cfoutput query="tbAcademicos"> 	
						<tr>
							<td class="Sans9Gr" width="40" align="right">#acd_id#</td>
							<td class="Sans9Gr">#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</td>
							<td class="Sans9Gr" width="180">#con_descrip#</td>
							<td class="Sans9Gr" width="120">#CnSinTiempo(cn_siglas)#</td>
							<cfif #Session.sTipoSistema# IS 'stctic'><td class="Sans9Gr" width="50">#dep_siglas#</td></cfif>
						</tr>
					</cfoutput>
				</table>
				<!--- Pie de página --->
				<cfdocumentitem type="footer">
					<table width="100%">
						<tr>
							<td align="left" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>#FechaCompleta(Now())#</cfoutput></td>	
							<td align="right" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
						</tr>
					</table>		
				</cfdocumentitem>
			</body>
		</html>
	</cfdocument>