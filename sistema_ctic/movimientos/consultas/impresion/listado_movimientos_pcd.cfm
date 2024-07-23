<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/02/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/07/2019 --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 02/11/2009 --->
<!--- IMPRESION DE LA LISTA DE SOLICITUDES --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="3.1" unit="cm">
	<!--- Obtener la lista de solicitudes enviadas por las entidades académicas del SIC --->
    <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
        SELECT DISTINCT
        T1.*, 
        T2.acd_id, T2.acd_apepat, T2.acd_nombres,
        C1.mov_titulo_corto,
        C4.cn_siglas,
        C2.dep_siglas,
        C3.dec_super,
        T3.*,
        C5.parte_romano + '.' + LTRIM(STR(T3.asu_numero)) AS SeccionNumero
        FROM ((((((movimientos AS T1
        LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
        LEFT JOIN movimientos_asunto AS T3 ON T1.sol_id = T3.sol_id)
        LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave) <!---CATALOGOS GENERALES MYSQL --->
        LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave)
        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave <!---CATALOGOS GENERALES MYSQL --->
        LEFT JOIN catalogo_listado AS C5 ON T3.asu_parte = C5.parte_numero)
        WHERE asu_reunion = 'CTIC'
        AND (T1.mov_clave = 15 OR T1.mov_clave = 16)
        <cfif #vCn# NEQ ''>AND T1.mov_cn_clave = '#vCn#'</cfif>
        <!--- <cfif #vActa# NEQ ''>AND T3.ssn_id = #vActa#</cfif>--->
        <cfif #Session.sTipoSistema# IS 'sic'>
            AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
        <cfelseif #vDep# NEQ '0'>
            AND T1.dep_clave LIKE '#Left(vDep,4)#%'
        </cfif>
        <!--- Ordenamiento --->
        <cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
    </cfquery>
	<html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
            <title>Documento sin título</title>
			<cfoutput>
				<link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
                <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">    
			</cfoutput>
        </head>

		<body>
			<cfdocumentitem type="header">
				<!-- Titulo da la página --->
				<center>
					<span class="PdfTitulo">
						<br>
						<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
						<br>
						<cfoutput>#Session.sDep#</cfoutput>
						<br><br>
					</span>
					<span class="PdfSubtitulo">                    
						<i>ASUNTOS DE PLAZAS / CONCURSOS DESIERTOS</i>
						<br>
						<br>
					</span>
				</center>
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<!-- Línea -->
					<tr><td colspan="6" height="3px;"><hr class="LineaHr"></td></tr>
					<!-- Encabezados -->
					<tr>
						<cfif #Session.sTipoSistema# IS 'stctic'><td class="TablaEncabeza" width="10%">Entidad</td></cfif>
						<td class="TablaEncabeza" width="40%">Movimiento</td>
						<td class="TablaEncabeza" width="20%">Categor&iacute;a</td>
						<td class="TablaEncabeza" width="10%">Plaza</td>
						<td class="TablaEncabeza" width="10%">Sesi&oacute;n</td>
						<td class="TablaEncabeza" width="10%">Dec.</td>
					</tr>
					<!-- Línea -->
					<tr><td colspan="6" height="3px;"><hr class="LineaHr"></td></tr>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbMovimientos"> 			
					<tr>
						<cfif #Session.sTipoSistema# IS 'stctic'><td class="TablaContenido" width="10%">#tbMovimientos.dep_siglas#</td></cfif>
						<td class="TablaContenido" width="40%">
                        	#Ucase(tbMovimientos.mov_titulo_corto)#</span>
                            <span class="TablaContenido">
								<cfif #tbMovimientos.mov_clave# EQ 6 OR #tbMovimientos.mov_clave# EQ 25>(#tbMovimientos.mov_numero#)</cfif> <cfif #tbMovimientos.mov_cancelado# IS 1>(CANCELADO)</cfif> <cfif #tbMovimientos.mov_modificado# IS 1>(MODIFICADO)</cfif>
							</span>
						</td>
						<td class="TablaContenido" width="20%">#CnSinTiempo(tbMovimientos.cn_siglas)#</td>
						<td class="TablaContenido" width="10%">#mov_plaza#</td>
						<td class="TablaContenido" width="10%">#ssn_id#</td>
						<td class="TablaContenido" width="10%"><span class="Sans10Ne">#tbMovimientos.dec_super#</span></td>
					</tr>
				</cfoutput>
			</table>
			<!--- Pie de página --->
			<cfset #vModuloImp# = 'PCD'>
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
        </body>
    </html>
</cfdocument>