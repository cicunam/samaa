<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 13/11/2019 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="4.2" marginleft="1" marginright="1" unit="cm">		
	<!--- Parámetros de filtrado --->
	<cfif #FindNoCase('/sistema_ctic/movimientos/consultas/consulta_academico.cfm', Session.sModulo)# IS NOT 0>	
		<cfparam name="vIdAcad" default="#Session.MovimientosAcadFiltro.vIdAcad#">
		<cfparam name="vNomAcad" default="#Session.MovimientosAcadFiltro.vNomAcad#">
		<cfparam name="vRfcAcad" default="#Session.MovimientosAcadFiltro.vRfcAcad#">
		<cfparam name="vAniosMov" default="#Session.MovimientosAcadFiltro.vAnioMov#">
		<cfparam name="vFt" default="#Session.MovimientosAcadFiltro.vFt#">
		<cfparam name="vOrden" default="#Session.MovimientosAcadFiltro.vOrden#">
		<cfparam name="vOrdenDir" default="#Session.MovimientosAcadFiltro.vOrdenDir#">
	<cfelse>
		<cfparam name="vIdAcad" default="#Session.AcademicosMovFiltro.vIdAcad#">
		<cfparam name="vNomAcad" default="#Session.AcademicosMovFiltro.vNomAcad#">
		<cfparam name="vRfcAcad" default="#Session.AcademicosMovFiltro.vRfcAcad#">
		<cfparam name="vAniosMov" default="#Session.AcademicosMovFiltro.vAnioMov#">        
		<cfparam name="vFt" default="#Session.AcademicosMovFiltro.vFt#">
		<cfparam name="vOrden" default="#Session.AcademicosMovFiltro.vOrden#">
		<cfparam name="vOrdenDir" default="#Session.AcademicosMovFiltro.vOrdenDir#">
	</cfif>	
	<html><head>
			<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<cfoutput>
				<link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
                <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
			</cfoutput>
		</head>
		<body>
			<!--- <cfoutput>#vIdAcad# - #vFt# - #vAniosMov#</cfoutput> --->
			<!--- Obtener la lista de movimientos del académico --->
			<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
				SELECT *
                FROM (((((movimientos AS T1
				LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
				LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id AND T3.asu_reunion = 'CTIC')
				LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
				LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON T1.mov_cn_clave = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
				WHERE T3.asu_reunion = 'CTIC'
				<cfif #vIdAcad# IS NOT ''>AND T1.acd_id = #vIdAcad#</cfif>
<!---
				<cfif #vRfcAcad# IS NOT ''>AND acd_rfc LIKE '%#vRfcAcad#%'</cfif>
				<cfif #vNomAcad# IS NOT ''>AND ISNULL(acd_apepat,'') + ' ' + ISNULL(acd_apemat,'') + ' ' + ISNULL(acd_nombres,'') LIKE '%#vNomAcad#%'</cfif>
--->
				<!--- Filtro por tipo de movimiento --->
				<cfif IsDefined('vFt') AND #vFt# NEQ 0>	
				 	<cfif #vFt# EQ 100>
						AND (T1.mov_clave <> 40 AND T1.mov_clave <> 41)
			        <cfelseif #vFt# EQ 101>
						AND (T1.mov_clave = 40 OR T1.mov_clave = 41)
			        <cfelse>	
						AND T1.mov_clave = #vFt#
					</cfif>	
				</cfif>

				<!--- Filtro por año de movimiento --->
				<cfif IsDefined("vAniosMov") AND #vAniosMov# GT 1900>
                    AND YEAR(T1.mov_fecha_inicio) = #vAniosMov#
                </cfif>

				<!--- Ordenamiento --->
				<cfif #vOrden# IS NOT ''>ORDER BY #vOrden#</cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>

			</cfquery>
			<!--- Encabezado --->
			<cfdocumentitem type="header">
	            <cfset vModuloImp = 'MOVIMIENTOS'>
				<cfset vTipoReporte = 'IND'>                
				<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_encabeza.cfm">            
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<!-- Línea -->
					<tr><td colspan="8"><hr class="LineaHr"></td></tr>
					<!-- Encabezados -->
					<tr valign="middle">
						<td class="TablaEncabeza" width="30%">Movimiento</td>
						<td class="TablaEncabeza" width="10%">Inicio</td>
						<td class="TablaEncabeza" width="10%">T&eacute;rmino</td>
						<td class="TablaEncabeza" width="15%">Categor&iacute;a</td>
						<td class="TablaEncabeza" width="10%">Entidad</td>
						<td class="TablaEncabeza" width="5%">Acta</td>
						<td class="TablaEncabeza" width="15%">Oficio</td>
						<td class="TablaEncabeza" width="5%">Dec.</td>
					</tr>
					<!-- Línea -->
					<tr><td colspan="8"><hr class="LineaHr"></td></tr>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbMovimientos"> 			
					<tr>
						<td class="TablaContenido" width="30%">#Ucase(tbMovimientos.mov_titulo_corto)# <span class="Sans9Vi"><cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 25>(#tbMovimientos.mov_numero#)</cfif> <cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif> <cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif></span></td>
						<td class="TablaContenido" width="10%">#LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#</td>
						<td class="TablaContenido" width="10%">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>
						<td class="TablaContenido" width="15%">#CnSinTiempo(tbMovimientos.cn_siglas)#</td>
						<td class="TablaContenido" width="10%">#tbMovimientos.dep_siglas#</td>
						<td class="TablaContenido" width="5%">#tbMovimientos.ssn_id#</td>
						<td class="TablaContenido" width="15%">#tbMovimientos.asu_oficio#</td>
						<td class="TablaContenido" width="5%">#tbMovimientos.dec_super#</td>
					</tr>
				</cfoutput>
			</table>
			<!--- Pie de página --->
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>