<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 02/11/2009 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="3.1" unit="cm">		
	<!--- Parámetros de filtrado --->
	<cfparam name="vFt" default="#Session.MovimientosVenceFiltro.vFt#">
	<cfparam name="vAcadNom" default="#Session.MovimientosVenceFiltro.vAcadNom#">
	<cfparam name="vCn" default="#Session.MovimientosVenceFiltro.vCn#">
	<cfparam name="vDep" default="#Session.MovimientosVenceFiltro.vDep#">
	<cfparam name="vOrden" default="#Session.MovimientosVenceFiltro.vOrden#">
	<cfparam name="vOrdenDir" default="#Session.MovimientosVenceFiltro.vOrdenDir#">
	<html>
		<head>
			<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
		</head>
		<body>
			<!--- Obtener la lista de movimientos por vencer en los próximos tres meses --->
			<cfset vFechaActual = LsDateFormat(Now(),"dd/mm/yyyy")>
			<cfset vFechaPosterior = LsDateFormat(DateAdd("m", 3, Now()),"dd/mm/yyyy")>
			<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM (((((movimientos AS T1 
				LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
				LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id)
				LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
				LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON T1.mov_cn_clave = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE asu_reunion = 'CTIC'
				AND (T2.con_clave = 2 OR T2.con_clave = 3)
				AND (T1.mov_clave = 5 OR T1.mov_clave = 6 OR T1.mov_clave = 25) 
				AND (T1.mov_fecha_final > '#vFechaActual#' AND T1.mov_fecha_final < '#vFechaPosterior#')
				<cfif #vAcadNom# NEQ ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
				<cfif #vCn# NEQ ''>AND T1.mov_cn_clave = '#vCn#'</cfif>
				<cfif #vFt# NEQ 0>AND T1.mov_clave = #vFt#</cfif>
				<cfif #Session.sTipoSistema# IS 'sic'>
					AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
				<cfelseif #vDep# NEQ '0'>
					AND T1.dep_clave LIKE '#Left(vDep,4)#%'
				</cfif>
				<!--- Ordenamiento --->
				<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''>#vOrdenDir#</cfif>
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
						<cfoutput>#Session.sDep#</cfoutput>
						<br><br>
						<i>MOVIMIENTOS POR VENCER EN LOS PR&Oacute;XIMOS 3 MESES</i>
						<br>
						<br>
					</span>
				</center>
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<!-- Línea -->
					<tr><td colspan="7"><hr class="doble"></td></tr>
					<!-- Encabezados -->
					<tr valign="middle">
						<cfif #Session.sTipoSistema# IS 'stctic'><td class="Sans9GrNe" width="50">Entidad</td></cfif>
						<td class="Sans9GrNe" width="360">Nombre</td>
						<td class="Sans9GrNe">Movimiento</td>
						<td class="Sans9GrNe" width="70">Inicio</td>
						<td class="Sans9GrNe" width="70">T&eacute;rmino</td>
						<td class="Sans9GrNe" width="120">Categor&iacute;a</td>
						<td class="Sans9GrNe" width="20">NC</td>
					</tr>
					<!-- Línea -->
					<tr><td colspan="7"><hr class="doble"></td></tr>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbMovimientos"> 			
					<tr>
						<cfif #Session.sTipoSistema# IS 'stctic'><td class="Sans9Gr" width="50">#tbMovimientos.dep_siglas#</td></cfif>
						<td class="Sans9Gr" width="360">#acd_apepat# #acd_apemat# #acd_nombres#</td>
						<td class="Sans9Gr">#Ucase(tbMovimientos.mov_titulo_corto)# <cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif></td>
						<td class="Sans9Gr" width="70">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</td>
						<td class="Sans9Gr" width="70">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>
						<td class="Sans9Gr" width="120">#CnSinTiempo(tbMovimientos.cn_siglas)#</td>
						<td class="Sans9Gr" width="20">#tbMovimientos.mov_numero#</td>
					</tr>
				</cfoutput>
			</table>
            <cfset #vModuloImp# = ''>
			<!--- Pie de página --->
			<cfset #vModuloImp# = 'MOV_VENCER'>
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>