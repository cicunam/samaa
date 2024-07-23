<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 29/08/2016 --->
<!--- FECHA ÚLTIMA MOD.: 22/02/2022 --->

<!--- IMPRESION DE LA LISTA DE ASUNTOS QUE VERÁ LA CAAA PARA SOLICITAR EXPEDIENTES AL ARCHIVO --->
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="3.5" marginleft="1" marginright="1" marginbottom="2.5" unit="cm">

	<!--- SELECCIONA LOS REGISTROS DE LOS ASUNTOS QUE SE VERÁN EN LA CAAA (APARTIR DEL 22/02/2022 SE HACE SOBRE CONSULTA ) --->
    <cfquery name="tbAsuntosCaaa" datasource="#vOrigenDatosSAMAA#">
        SELECT
        dep_siglas,
        acd_apepat,
        acd_apemat,
        acd_nombres,
        no_expediente,
        num_emp,
        mov_clave
        FROM consulta_movimientosArchivo
        WHERE ssn_id = #vSsnId#
        ORDER BY 
        dep_orden, acd_apepat, acd_apemat        
    </cfquery>


	
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
			<!--- Encabezado --->
			<cfdocumentitem type="header">
	            <cfset #vModuloImp# = 'ASUNTOS'>
                <cfset #vTipoReporte# = 'LEXPEDIENTE'>
				<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_encabeza.cfm">
				<!-- Encabezados de las columnas -->
				<table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
					<!-- Línea -->
					<tr><td colspan="6"><hr class="LineaHr"></td></tr>
					<!-- Encabezados -->
					<tr valign="middle">
						<td class="TablaEncabeza" width="3%">#</td>
						<td class="TablaEncabeza" width="8%">Entidad</td>
						<td class="TablaEncabeza" width="43%">Nombre del académico</td>
						<td class="TablaEncabeza" width="18%" align="center">Número de expediente</td>
						<td class="TablaEncabeza" width="14%" align="center">Entrega</td>
						<td class="TablaEncabeza" width="14%" align="center">Devolución</td>
					</tr>
					<!-- Línea -->
					<tr><td colspan="6"><hr class="LineaHr"></td></tr>
				</table>
			</cfdocumentitem>
            <!--- Contenido del listado --->
            <cfset vbgcolor = '##DADADA'>
			<cfset vPageBreak = 1>
			<table border="0" cellspacing="0" cellpadding="0" style="width:100%;">
				<cfloop index='i' from="1" to="2">

					<cfquery name="tbAsuntosCaaaTemp" dbtype="query">
						SELECT * FROM tbAsuntosCaaa
						WHERE
						<cfif #i# EQ 1>
							mov_clave NOT BETWEEN 38 AND 39
						<cfelseif #i# EQ 2>							
							mov_clave BETWEEN 38 AND 39
						</cfif>
					</cfquery>
					<cfoutput query="tbAsuntosCaaaTemp">
						<cfif vbgcolor EQ ''>
							<cfset vbgcolor = '##DADADA'>
						<cfelse>
							<cfset vbgcolor = ''>
						</cfif>
						<tr valign="middle"> <!--- bgcolor="#vbgcolor#" class="BordeHor"--->
							<td width="3%" height="18px" style="border-bottom:solid ##000 1;"><span class="TablaContenido">#CurrentRow#</span></td>
							<td width="8%" style="border-bottom:solid ##000 1;"><span class="TablaContenido">#dep_siglas#</span></td>
							<td width="43%" style="border-bottom:solid ##000 1; border-right::solid ##000 1;">
								<span class="TablaContenido">
									<cfif #acd_apepat# NEQ ''>#acd_apepat#</cfif><cfif #acd_apepat# NEQ ''> #acd_apemat#</cfif><cfif #acd_nombres# NEQ ''>, #acd_nombres#</cfif>
								</span>
							</td>
							<td width="18%" style="border-bottom:solid ##000 1; border-right::solid ##000 1;">
	<!---
								<span class="TablaContenido">                        
								<cfif #con_clave# GTE 1 AND #con_clave# LTE 3>
									<cfif #no_expediente# NEQ ''>
										#no_expediente#
									<cfelseif #num_emp# NEQ ''>
										No. EMPLEADO: #num_emp#
									<cfelse>
										REVISAR INF. ACADÉMICO
									</cfif>
								<cfelseif #con_clave# EQ 6 OR #mov_clave# EQ '38' OR #mov_clave# EQ '39' OR #mov_clave# EQ '43'>
									BECARIO POSDOC.
								<cfelseif #con_clave# EQ 7 OR #mov_clave# EQ '26'>
									ACADÉMICO VISITANTE
								<cfelse>
									REVISAR INF. ACADÉMICO
								</cfif>
								</span>
	--->
							</td>
							<td width="14%" style="border-bottom:solid ##000 1; border-right::solid ##000 1;"></td>
							<td width="14%" style="border-bottom:solid ##000 1; border-right::solid ##000 1;"></td>
						</tr>
					</cfoutput>
				</cfloop>
			</table>

			<!--- Pie de página --->
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
		</body>
	</html>
</cfdocument>