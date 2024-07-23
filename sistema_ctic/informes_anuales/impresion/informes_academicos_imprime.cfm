<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2016 --->
<!--- IMPRESION DE LA LISTA GENERAL DE LOS INFORMES ANUALES REGISTRADOS EN EL SISTEMA --->

<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="4.2" marginleft="1" marginright="1" unit="cm">		
	<html>
		<head>
			<title>SAMAA</title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<cfoutput>
                <link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
                <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
			</cfoutput>
		</head>
		<body>

			<!--- Obtener la lista de movimientos del académico --->
            <cfquery name="tbInformesAnual" datasource="#vOrigenDatosSAMAA#">
                SELECT
                T1.informe_anio,
                T1.informe_anual_id,
                T1.acd_id,
				(
                	ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
					CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
					CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
					ISNULL(dbo.SINACENTOS(acd_nombres),'')
				) AS nombre_comp,
                T2.ssn_id,
                T2.informe_oficio,
                C1.dep_siglas,
                C2.cn_siglas,
                C3.dec_super,
                C3.dec_descrip,
                C4.dec_descrip AS dec_descrip_ci
                FROM
                movimientos_informes_anuales AS T1 
                LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND informe_reunion = 'CTIC'
                LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id
                LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave <!---CATALOGOS GENERALES MYSQL --->
                LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave <!---CATALOGOS GENERALES MYSQL --->
                LEFT JOIN catalogo_decision AS C3 ON T2.dec_clave = C3.dec_clave
                LEFT JOIN catalogo_decision AS C4 ON T1.dec_clave_ci = C4.dec_clave                
                WHERE informe_status = 1
				<cfif #Session.InformesFiltro.vInformeAnio# NEQ 0>
					 AND informe_anio = '#Session.InformesFiltro.vInformeAnio#'
				</cfif>
                <cfif #Session.InformesFiltro.vDep# NEQ ''>
	                AND T1.dep_clave = '#Session.InformesFiltro.vDep#'
				</cfif>
				<cfif #Session.InformesFiltro.vDecClave# NEQ '0'>
                    AND T1.dec_clave_ci = #Session.InformesFiltro.vDecClave#
                </cfif>
                <!--- Ordenamiento --->
				<!--- Ordenamiento --->
                <cfif #Session.InformesFiltro.vOrden# IS NOT ''>
                    ORDER BY 
					<cfif #Session.InformesFiltro.vDep# EQ ''>
                    	C1.dep_siglas, 
                    </cfif>
					<cfif #Session.InformesFiltro.vOrden# EQ 'nombre'>
                        acd_apepat #Session.InformesFiltro.vOrdenDir#, 
                        acd_apemat #Session.InformesFiltro.vOrdenDir#, 
                        acd_nombres #Session.InformesFiltro.vOrdenDir#
                    <cfelse>
                        #Session.InformesFiltro.vOrden#
                        <cfif #Session.InformesFiltro.vOrdenDir# IS NOT ''> 
                            #Session.InformesFiltro.vOrdenDir#
                        </cfif>
                    </cfif>
                </cfif>
            </cfquery>

			<!-- Encabezado (include general) -->
			<cfdocumentitem type="header">
	            <cfset #vModuloImp# = 'INFORME'>
    	        <cfset vTipoReporte = 'MODINFREC'>

                <cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_encabeza.cfm">

					<!-- Encabezados de las columnas -->
                <table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
                    <!-- Línea -->
                    <tr><td colspan="8" height="3px;"><hr class="LineaHr"></td></tr>
                    <!-- Encabezados -->
                    <tr valign="middle">
                        <!---<td style="width:5%;" class="TablaEncabeza">A&ntilde;o</td>--->
                        <td style="width:6%;" class="TablaEncabeza">Entidad</td>
                        <td style="width:34%;" class="TablaEncabeza">Nombre</td>
                        <td style="width:20%;" class="TablaEncabeza">Clase, categor&iacute;a y nivel</td>
                        <td style="width:12%;" class="TablaEncabeza">Decisión CI</td>
                        <td style="width:6%;" class="TablaEncabeza">Acta</td>
                        <td style="width:10%;" class="TablaEncabeza">N&uacute;mero de oficio</td>
                        <td style="width:12%;" class="TablaEncabeza">Decisión CTIC</td>
                    </tr>
                    <!-- Línea -->
                    <tr><td colspan="8" height="3px;"><hr class="LineaHr"></td></tr>
                </table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbInformesAnual"> 			
					<tr>
                        <!--- <td style="width:5%;" class="TablaContenido">#informe_anio#</td> --->
                        <td style="width:6%;" class="TablaContenido">#dep_siglas#</td>
                        <td style="width:34%;" class="TablaContenido">#nombre_comp#</td>
                        <td style="width:20%;" class="TablaContenido">#cn_siglas#</td>
                        <td style="width:12%;" class="TablaContenido" align="center">#dec_descrip_ci#</td>
                        <td style="width:6%;" class="TablaContenido">#ssn_id#</td>
                        <td style="width:10%;" class="TablaContenido">#SoloNumeroOficio(informe_oficio)#</td>
                        <td style="width:12%;" class="TablaContenido" align="center">#dec_descrip#</td>
					</tr>
				</cfoutput>
			</table>
			<!-- Pie de página (include general) -->
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>