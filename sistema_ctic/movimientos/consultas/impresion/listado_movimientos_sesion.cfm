<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 25/07/2019 --->
<!--- IMPRESIÓN DE LA LISTA DE MOVIMIENTOS POR SESIÓN O AÑO --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<cfif #vTipoSesionAnio# EQ 'S'>
	<cfset vColWidth_1 = '5%'>
	<cfset vColWidth_2 = '30%'>
	<cfset vColWidth_3 = '30%'>
	<cfset vColWidth_4 = '8%'>
	<cfset vColWidth_5 = '8%'>
	<cfset vColWidth_6 = '14%'>
	<cfset vColWidth_7 = ''>
	<cfset vColWidth_8 = '5%'>
	<cfif #Session.sTipoSistema# IS 'stctic'>
		<cfset vColSpan = '7'>
	<cfelse>
		<cfset vColSpan = '6'>    
	</cfif>
<cfelseif #vTipoSesionAnio# EQ 'A'>
	<cfset vColWidth_1 = '5%'>
	<cfset vColWidth_2 = '30%'>
	<cfset vColWidth_3 = '26%'>
	<cfset vColWidth_4 = '8%'>
	<cfset vColWidth_5 = '8%'>
	<cfset vColWidth_6 = '14%'>
	<cfset vColWidth_7 = '4%'>
	<cfset vColWidth_8 = '5%'>
	<cfif #Session.sTipoSistema# IS 'stctic'>
		<cfset vColSpan = '8'>
	<cfelse>
		<cfset vColSpan = '7'>
	</cfif>
</cfif>


<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="4.2" marginleft="1" marginright="1" unit="cm">		
	<!--- Parámetros de filtrado --->
	<cfparam name="vFt" default="#Session.MovimientosSesionFiltro.vFt#">
	<cfparam name="vActa" default="#Session.MovimientosSesionFiltro.vActa#">
	<cfparam name="vAcadNom" default="#Session.MovimientosSesionFiltro.vAcadNom#">
	<cfparam name="vDep" default="#Session.MovimientosSesionFiltro.vDep#">
	<cfparam name="vOrden" default="#Session.MovimientosSesionFiltro.vOrden#">
	<cfparam name="vOrdenDir" default="#Session.MovimientosSesionFiltro.vOrdenDir#">
	<html>
		<head>
			<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<cfoutput>
				<link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
                <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">    
			</cfoutput>
		</head>
		<body>
			<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
			<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
                SELECT * FROM consulta_movimientos_sesion
                WHERE asu_reunion = 'CTIC'
				<cfif #vTipoSesionAnio# EQ 'S'>
                    AND ssn_id = #vSesionAnio#
                <cfelseif #vTipoSesionAnio# EQ 'A'>
                    AND YEAR(mov_fecha_inicio) = #vSesionAnio#
                </cfif>
				<cfif #vAcadNom# NEQ ''>
                    AND 
                    (
                        ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                        CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                        ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
                        CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
                        ISNULL(dbo.SINACENTOS(acd_nombres),'') LIKE '%#NombreSinAcentos(vAcadNom)#%'
                        OR 
                        ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                        CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                        ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                        CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                        ISNULL(dbo.SINACENTOS(acd_apemat),'') LIKE '%#NombreSinAcentos(vAcadNom)#%' 
                    )	        
                    <!--- AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'--->
                </cfif>
				<cfif IsDefined('vFt') AND #vFt# NEQ 0>	
					<cfif #vFt# EQ 100>
                        AND (mov_clave <> 40 AND mov_clave <> 41)
                    <cfelseif #vFt# EQ 101>
                        AND (mov_clave = 40 OR mov_clave = 41)
                    <cfelse>	
                        AND mov_clave = #vFt#
                    </cfif>	
                </cfif>
                <cfif #Session.sTipoSistema# IS 'sic'>
                    AND dep_clave LIKE '#Left(Session.sIdDep,4)#%'
                <cfelseif #vDep# NEQ '0'>
                    AND dep_clave LIKE '#Left(vDep,4)#%'
                </cfif>
				<cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
			</cfquery>

			<!--- Encabezado --->
			<cfdocumentitem type="header">
				<!-- Titulo da la página --->
				<center>
					<span class="Titulo">
						<br>
						<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
						<br>
						<cfoutput>
						#Session.sDep#<br><br>
					</span>
					<span class="Subtitulo">
						<cfif #vTipoSesionAnio# EQ 'S'>
							<i>ASUNTOS RESUELTOS EN LA SESION #vSesionAnio#</i>
                        <cfelseif #vTipoSesionAnio# EQ 'A'>
							<i>ASUNTOS RESUELTOS EN EL AÑO #vSesionAnio#</i>
                        </cfif>
						<br>
						<br>
						</cfoutput>                        
					</span>
				</center>
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<cfoutput>
                        <!-- Línea -->
                        <tr><td colspan="#vColSpan#" height="3px;"><hr class="LineaHr"></td></tr>
                        <!-- Encabezados -->
                            <tr>
                                <cfif #Session.sTipoSistema# IS 'stctic'><td class="TablaEncabeza" width="#vColWidth_1#">Entidad</td></cfif>
                                <td	class="TablaEncabeza" width="#vColWidth_2#">Nombre</td>
                                <td	class="TablaEncabeza" width="#vColWidth_3#">Movimiento</td>
                                <td	class="TablaEncabeza" width="#vColWidth_4#">Inicio</td>
                                <td	class="TablaEncabeza" width="#vColWidth_5#">T&eacute;rmino</td>
                                <td	class="TablaEncabeza" width="#vColWidth_6#">Categor&iacute;a</td>
                                <cfif #vTipoSesionAnio# EQ 'A'>
                                    <td class="TablaContenido" width="#vColWidth_7#" style="text-align:center;">Acta</td>
                                </cfif>                        
                                <td	class="TablaEncabeza" width="#vColWidth_8#" style="text-align:center;">Dec.</td>
                            </tr>
                        <!-- Línea -->
                        <tr><td colspan="#vColSpan#" height="3px;"><hr class="LineaHr"></td></tr>
					</cfoutput>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbMovimientos"> 			
					<tr>
						<cfif #Session.sTipoSistema# IS 'stctic'><td class="TablaContenido" width="#vColWidth_1#">#tbMovimientos.dep_siglas#</td></cfif>
						<td class="TablaContenido" width="#vColWidth_2#">#acd_apepat# #acd_apemat# #acd_nombres#</td>
						<td class="TablaContenido" width="#vColWidth_3#">
							#Ucase(tbMovimientos.mov_titulo_corto)#
                            <strong>
							<cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 25>(#tbMovimientos.mov_numero#)</cfif>
							<cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif> 
							<cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif>
							<cfif #tbMovimientos.prog_clave# IS 3> (SIJAC)</cfif>
                            </strong>
						</td>
						<td class="TablaContenido"  width="#vColWidth_4#">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</td>
						<td class="TablaContenido" width="#vColWidth_5#">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>
						<td class="TablaContenido" width="#vColWidth_6#">#tbMovimientos.cn_siglas_nom#</td>
						<cfif #vTipoSesionAnio# EQ 'A'>
							<td class="TablaContenido" width="#vColWidth_7#" style="text-align:center;">#tbMovimientos.ssn_id#</td>
						</cfif>
						<td class="TablaContenido" width="#vColWidth_8#" style="text-align:center;">#tbMovimientos.dec_super#</td>
					</tr>
				</cfoutput>
			</table>
			<!--- Pie de página --->
			<cfset #vModuloImp# = 'MOV_SESION'>
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>