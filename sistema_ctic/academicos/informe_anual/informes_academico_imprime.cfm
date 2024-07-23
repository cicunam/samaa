<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 25/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 28/03/2022 --->
<!--- IMPRESION DE LA LISTA INFORMES ANUALES REGISTRADOS EN EL SISTEMA --->

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
			<!--- Obtener los datos del académico --->
            <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
                SELECT T1.acd_prefijo, T1.acd_apepat, T1.acd_apemat, T1.acd_nombres, C1.dep_nombre
				FROM academicos AS T1
                LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave <!---CATALOGOS GENERALES MYSQL --->                
                WHERE acd_id = #Session.InformeAnualFiltro.vIdAcad#
            </cfquery>
        
			<!--- Obtener la lista de movimientos del académico --->
            <cfquery name="tbInformesAnual" datasource="#vOrigenDatosSAMAA#">
                SELECT
                T1.informe_anio,
                T1.informe_anual_id,
                T1.acd_id,
                T2.ssn_id,
                T2.informe_oficio,
                C1.dep_siglas,
                C2.cn_siglas,
                C3.dec_super,
                C3.dec_descrip
                FROM
                movimientos_informes_anuales AS T1 
                LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND informe_reunion = 'CTIC'
                <!--- LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id--->
                LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave <!---CATALOGOS GENERALES MYSQL --->
                LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave <!---CATALOGOS GENERALES MYSQL --->
                LEFT JOIN catalogo_decision AS C3 ON T2.dec_clave = C3.dec_clave
                WHERE T1.acd_id = #Session.InformeAnualFiltro.vIdAcad#
                AND T1.informe_status IS NULL
                <!--- Ordenamiento --->
                <cfif #Session.InformeAnualFiltro.vOrden# IS NOT ''>ORDER BY #Session.InformeAnualFiltro.vOrden#</cfif>
				<cfif #Session.InformeAnualFiltro.vOrdenDir# IS NOT ''> #Session.InformeAnualFiltro.vOrdenDir#</cfif>
            </cfquery>

			<!-- Encabezado (include general) -->
			<cfdocumentitem type="header">            
	            <cfset #vModuloImp# = 'INFORME'>
    	        <cfset vTipoReporte = 'IND'>
				<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_encabeza.cfm">
                <!-- Encabezados de las columnas -->
                <table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
                    <!-- Línea -->
                    <tr><td colspan="6"><hr class="LineaHr"></td></tr>
                    <!-- Encabezados -->
                    <tr valign="middle">
                        <td style="width:10%;" class="TablaEncabeza">A&ntilde;o de informe</td>
                        <td style="width:25%;" class="TablaEncabeza">Clase, categor&iacute;a y nivel</td>
                        <td style="width:10%;" class="TablaEncabeza">Entidad</td>
                        <td style="width:10%;" class="TablaEncabeza">Acta</td>
                        <td style="width:15%;" class="TablaEncabeza">N&uacute;mero de oficio</td>
                        <td style="width:25%;" class="TablaEncabeza">Decisión CTIC</td>
                    </tr>
                    <!-- Línea -->
                    <tr><td colspan="6"><hr class="LineaHr"></td></tr>
				</table>
			</cfdocumentitem>
			<!-- Tabla de datos -->
			<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
				<cfoutput query="tbInformesAnual"> 			
					<tr>
                        <td style="width:10%;" class="TablaContenido">#informe_anio#</td>
                        <td style="width:25%;" class="TablaContenido">#cn_siglas#</td>
                        <td style="width:10%;" class="TablaContenido">#dep_siglas#</td>
                        <td style="width:10%;" class="TablaContenido">#ssn_id#</td>
                        <td style="width:15%;" class="TablaContenido">#SoloNumeroOficio(informe_oficio)#</td>
                        <td style="width:25%;" class="TablaContenido">#dec_descrip#</td>
					</tr>
				</cfoutput>
			</table>
			<!-- Pie de página (include general) -->
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>