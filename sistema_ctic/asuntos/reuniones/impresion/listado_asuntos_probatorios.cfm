<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 24/05/2019 --->
<!--- IMPRESION DE LA LISTA ASUNTOS CON PROBATORIOS --->

<cfquery name="ctListado" datasource="#vOrigenDatosSAMAA#">
    SELECT * FROM catalogo_listado
    WHERE parte_numero < 4
	<!--- AND YEAR(#now()#) BETWEEN anio_activo_inicio AND anio_activo_termino --->
    ORDER BY parte_numero
</cfquery>
    
<!--- Enviar el contenido a un archivo PDF --->
<cfdocument format="PDF" fontembed="yes" orientation="portrait" pagetype="letter" margintop="2.7" marginleft="1" marginright="1" marginbottom="2.5" unit="cm">
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

		<!--- Encabezado --->
		<cfdocumentitem type="header">
            <cfset #vModuloImp# = 'ASUNTOS'>
			<cfset #vTipoReporte# = 'LPROBATORIOS'>
			<cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_encabeza.cfm">
		</cfdocumentitem>        
		<table id="listado" border="0" cellspacing="0" cellpadding="0" style="width:100%;">
			<cfloop query="ctListado">
				<cfset vParteNumero = #ctListado.parte_numero#>
				<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
					SELECT *
                    ,
					ISNULL(dbo.TRIM(dbo.SINACENTOS(acd_nombres)), '') + 
                    CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                    ISNULL(dbo.TRIM(dbo.SINACENTOS(acd_apepat)), '') + 
                    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                    ISNULL(dbo.TRIM(dbo.SINACENTOS(acd_apemat)), '') AS nombre_completo_npm                    
					FROM consulta_solicitudes_listados
					WHERE sol_status = 2 <!--- Asuntos que se encuentran el CAAA --->
					AND asu_reunion = 'CAAA' <!--- Registro de asunto CAAA --->
					AND ssn_id = #vSsnId# <!--- Del acta seleccionada --->
					AND asu_parte = #vParteNumero# <!--- Solo incluir los asuntos de la sección I --->
					ORDER BY dep_orden, nombre_comp
				</cfquery>
				<cfset vDepSiglas = ''>
				<cfif #tbSolicitudes.RecordCount# GT 0>
					<cfif #vParteNumero# NEQ 1>
						<tr><td colspan="6" height="15px"></td></tr>
					</cfif>                        
					<tr><td colspan="6"><span class="TablaPdfContenidoEncabeza"><strong><cfoutput>#parte_titulo#</cfoutput></strong></span></td></tr>
					<cfoutput query="tbSolicitudes">
						<cfif #dep_siglas# NEQ #vDepSiglas#>
							<tr><td colspan="5" height="15px"></td></tr>
							<tr><td colspan="5"><span class="TablaPdfContenido">#dep_nombre#</span></td></tr>
						</cfif>                            
						<tr>
							<td width="4%" height="16px"><cfif #dep_siglas# NEQ #vDepSiglas#><span class="TablaPdfContenido">#dep_siglas#</span></cfif></td>
							<td width="30%"><span class="TablaPdfContenido">#acd_prefijo# #nombre_completo_npm#</span></td>
							<td width="25%"><span class="TablaPdfContenido">#UCASE(mov_titulo_corto)#</span></td>
							<td width="2%"><span class="TablaPdfContenido"></span></td>
							<td width="28%"><span class="TablaPdfContenido">___________________________________________________</span></td><!---#LsDateFormat(sol_pos14,'dd/mm/yyyy')#--->
							<!--- <td width="13%"><span class="TablaPdfContenido">No. Reg ______</span></td> --->
						</tr>
						<cfset vDepSiglas = #dep_siglas#>
					</cfoutput>
				</cfif>
			</cfloop>
		</table>
		<!--- Pie de página --->
        <cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
	</body>
</html>
</cfdocument>