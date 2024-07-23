<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/08/2019 --->
<!--- FECHA ÚLTIMA MOD.: 28/04/2024 --->
<!--- IMPRESION DE RELACIÓN DE SOLICITUDES DE BECA POSDOCTORAL PARA REVISIÓN DE LA CAAA --->

<cfheader name="Content-Disposition" value="inline; filename=relacion_solicitudes_becasposdoc_caaa_#vSsnId#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">

<cfquery name="tbMovCAAAPosdoc" datasource="#vOrigenDatosSAMAA#">
	SELECT
	C1.dep_siglas,
	C2.area_siglas,
	T3.acd_rfc,	
	T3.acd_prefijo,
	(
		ISNULL(dbo.SINACENTOS(T3.acd_nombres),'') +
		CASE WHEN T3.acd_nombres IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(T3.acd_apepat),'') + 
		CASE WHEN T3.acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(T3.acd_apemat),'')
	) AS nombre
	,
	T3.acd_fecha_nac,
	T1.sol_pos21,
	T1.sol_pos11,
	C3.pais_nacionalidad,
	T4.acd_prefijo AS acd_prefijo_asesor,
	(
		ISNULL(dbo.SINACENTOS(T4.acd_nombres),'') +
		CASE WHEN T4.acd_nombres IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(T4.acd_apepat),'') + 
		CASE WHEN T4.acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(T4.acd_apemat),'')
	) AS asesor
	,
	C4.cn_siglas_nom,
	T1.sol_pos14,
    T1.sol_pos1,
	T1.sol_pos1_u
	FROM movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.sol_pos1 = C1.dep_clave
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_areas_sic')# AS C2 ON C1.dep_area = C2.area_clave
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_paises')# AS C3 ON T3.pais_clave_nacimiento = C3.pais_clave
	LEFT JOIN academicos AS T4 ON T1.sol_pos12 = T4.acd_id
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON T1.sol_pos8 = C4.cn_clave
	WHERE mov_clave = 38
	AND sol_status = 2
	AND T2.ssn_id = #vSsnId#
	ORDER BY C2.area_orden, C1.dep_orden, T3.acd_apepat, T3.acd_apemat
</cfquery>    

<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:excel"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">
    <head>
        <title>SAMAA</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <cfoutput>
            <link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
			<style>
				.Titulos {
					font-size: 12pt; 
					font-family:'Times New Roman';
					font-weight:bold;
				}
				.SubTitulos {
					font-size: 11pt; 
					font-family:'Times New Roman';
				}
				.TablaEncabeza {
					font-size: 11pt; 
					font-family:'Times New Roman';
					font-weight:bold;
				}
				.TablaContenido {
					font-size: 10pt; 
					font-family:'Times New Roman';
				}
			</style>		
        </cfoutput>
    </head>
	<body>
		<!--- Encabezado del listado del documento --->
        <table id="encabezado" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
                <td colspan="12" align="center">
					<span class="Titulos">
						CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA
						<br />
						CONVOCATORIA
					</span>
                </td>
            </tr>
            <tr>
                <td colspan="12">
					<span class="SubTitulos">Reunión de evaluación celebrada el XXXXXXX y Sesión del CTIC del XXXX</span>
                </td>
            </tr>
            <tr>
                <td colspan="12">
					<cfoutput><span class="SubTitulos">ACTA #vSsnId#</span></cfoutput>
                </td>
            </tr>
            <tr>
                <td colspan="12">
					<cfoutput><span class="SubTitulos">Fecha de reporte: #LsDateFormat(now(),'dd/mm/yyyy')#</span></cfoutput>
                </td>
			</tr>
        </table>
		<br/>
		<table id="listado" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="TablaEncabeza">Pos.</td>
				<td class="TablaEncabeza">Área</td>
				<td class="TablaEncabeza">Entidad</td>
				<cfif #Session.sUsuarioNivel# EQ 0><td class="TablaEncabeza">RFC</td></cfif>
				<td class="TablaEncabeza">Nombre y Apellido</td>
				<td class="TablaEncabeza">Fecha de nacimiento</td>
				<td class="TablaEncabeza">Edad al <cfoutput>#LsDateFormat(tbMovCAAAPosdoc.sol_pos14,'dd')# de #LsDateFormat(tbMovCAAAPosdoc.sol_pos14,'mmmm')# de #LsDateFormat(tbMovCAAAPosdoc.sol_pos14,'yyyy')#</cfoutput></td>
				<td class="TablaEncabeza">Fecha obtención grado</td>
				<td class="TablaEncabeza">Institución donde obtuvo el grado de doctor</td>
				<td class="TablaEncabeza">Nacionalidad</td>
				<td class="TablaEncabeza">Nombre del asesor</td>
				<td class="TablaEncabeza">Categoría del asesor</td>
				<td class="TablaEncabeza">Formación de recursos humanos de posgrado</td>
			</tr>
			<cfoutput query="tbMovCAAAPosdoc">
                <tr>
					<td class="TablaContenido"></td>
					<td class="TablaContenido">#area_siglas#</td>
					<td class="TablaContenido">#dep_siglas#</td>
					<cfif #Session.sUsuarioNivel# EQ 0><td class="TablaContenido">#acd_rfc#</td></cfif>
					<td class="TablaContenido">#acd_prefijo# #nombre#</td>
					<td class="TablaContenido">#LsDateFormat(acd_fecha_nac,'dd/mm/yyyy')#</td>
					<td class="TablaContenido"><cfif #acd_fecha_nac# NEQ ''>#datediff('yyyy',acd_fecha_nac,sol_pos14)#</cfif></td>
					<td class="TablaContenido">#LsDateFormat(sol_pos21,'dd/mm/yyyy')#</td>
					<td class="TablaContenido">#sol_pos11#</td>
					<td class="TablaContenido">#pais_nacionalidad#</td>
					<td class="TablaContenido">#acd_prefijo_asesor# #asesor#</td>
					<td class="TablaContenido">#cn_siglas_nom#</td>
					<td class="TablaContenido"></td>
				</tr>
			</cfoutput>
		</table>
	</body>
</html>
