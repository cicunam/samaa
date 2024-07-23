<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/08/2019 --->
<!--- FECHA ÚLTIMA MOD.: 31/08/2022 --->
<!--- IMPRESION DE TABLA CON LAS PLAZAS DE LOS COD DE LA SESIÓN SELECCIONADA --->

<cfheader name="Content-Disposition" value="inline; filename=relacion_verifica_plazas_caaa_#vSsnId#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">

<cfquery name="tbMovCAAAPlazas" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.*,
    	(
        ISNULL(dbo.SINACENTOS(acd_prefijo),'') +
        CASE WHEN acd_prefijo IS NULL THEN '' ELSE ' ' END +	
        ISNULL(dbo.SINACENTOS(acd_nombres),'') +
        CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END +
		ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
        ISNULL(dbo.SINACENTOS(acd_apemat),'')
        ) AS nombre
		,
		T2.adscripcion_dgpo  
	FROM consulta_solicitudes_caaa AS T1
	LEFT JOIN [PLAZAS-SIC].dbo.plazas_nuevas AS T2 ON T1.sol_pos9  = T2.plaza_numero <!--- SE AGREGÓ LA ADSCRIPCIÓN DE LA PLAZA SEGÚN LA DGPo 11/03/2020 --->
	WHERE T1.ssn_id = #vSsnId#
	AND T1.mov_clave = 6
    <!--- AND (T1.sol_pos12 = 3 OR (T1.sol_pos17 = 0 AND T1.sol_pos12 IS NULL)) --->
    ORDER BY T1.asu_parte, T1.asu_numero
</cfquery>
<!--- PLAZAS NUEVAS Y PLAZAS SIJAC --->
<cfquery name="tbMovCAAAPlazasTemp" dbtype="query">
    SELECT * FROM tbMovCAAAPlazas
    WHERE sol_pos12 = '3' OR (sol_pos17 = 0 AND sol_pos12 IS NULL)
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
                <td colspan="16" align="center">
					<span class="Titulos">
						CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA
						<br />
						RELACIÓN SOLICITUDES DE CONTRATO PARA OBRA DETERMINADA
					</span>
                </td>
            </tr>
            <tr>
                <td colspan="16">
					<cfoutput><span class="Titulos">ACTA #vSsnId#</span></cfoutput>
                </td>
            </tr>
            <tr>
                <td colspan="16">
					<cfoutput><span class="SubTitulos">Fecha de reporte: #LsDateFormat(now(),'dd/mm/yyyy')#</span></cfoutput>
                </td>
			</tr>
        </table>
		<br/>
		<!--- GENERA LISTA DE LAS SOLICITUDES DE OBRA DETERMINADA PARA VERIFICAR LA PLAZA --->
		<table id="listado" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="TablaEncabeza">No.</td>
				<td class="TablaEncabeza">Nombre del académico</td>
				<td class="TablaEncabeza">Entidad</td>
				<td class="TablaEncabeza">Categoría inicial de la plaza</td>
				<td class="TablaEncabeza">Categoría que solicita la dependencia</td>
				<td class="TablaEncabeza">No. de plaza</td>
				<td class="TablaEncabeza">SIJAC</td>
				<td class="TablaEncabeza">La Plaza pertenece a la entidad</td>
				<td class="TablaEncabeza">Cod. Prog. entidad</td>
				<td class="TablaEncabeza">Propuesta de fecha decontratación a partir del</td>
				<td class="TablaEncabeza">Vigencia</td>
				<td class="TablaEncabeza">Categoría actual de la plaza al</td>
				<td class="TablaEncabeza">Status</td>
				<td class="TablaEncabeza">Fecha de término de vigencia</td>
				<td class="TablaEncabeza">Código programático</td>
				<td class="TablaEncabeza">Área adscripción DGPo</td>
				<td class="TablaEncabeza">Observaciones</td>
			</tr>
			<cfoutput query="tbMovCAAAPlazasTemp">
                <tr>
                    <td class="TablaContenido"><strong>#CurrentRow#</strong></td>
                    <td class="TablaContenido">#nombre#</td>
                    <td class="TablaContenido">#dep_nombre#</td>
                    <td class="TablaContenido"></td>
                    <td class="TablaContenido">#cn_siglas#</td>
                    <td class="TablaContenido">#sol_pos9#</td>
                    <td class="TablaContenido"><cfif #sol_pos12# eq 3>X</cfif></td>
                    <td class="TablaContenido"></td>
                    <td class="TablaContenido"></td>
                    <td class="TablaContenido">#LsDateFormat(sol_pos14,'dd/mm/yyyy')#</td>
                    <td class="TablaContenido">
						<cfif #sol_pos13_a# GT 0>1 año</cfif>
						<cfif #sol_pos13_m# GT 0>#sol_pos13_m# mes(es)</cfif>
						<cfif #sol_pos13_d# GT 0>#sol_pos13_a# día(s)</cfif>
					</td>
					<td class="TablaContenido"></td>
					<td class="TablaContenido"></td>
					<td class="TablaContenido"></td>
					<td class="TablaContenido"></td>
					<td class="TablaContenido"></td>					
					<td class="TablaContenido"></td>
                </tr>
			</cfoutput>
		</table>
		<br/><br/>
        <!--- OTRAS PLAZAS --->
        <cfquery name="tbMovCAAAPlazasTemp" dbtype="query">
            SELECT * FROM tbMovCAAAPlazas
            WHERE sol_pos12 IS NULL AND sol_pos17 > 0
        </cfquery>
        <table id="encabezado" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
                <td colspan="16" align="center">
					<span class="Titulos"> OTRAS OBRAS DETERMINADAS
					</span>
                </td>
            </tr>
        </table>
		<br/>        
		<!--- GENERA LISTA DE LAS SOLICITUDES DE OBRA DETERMINADA PARA VERIFICAR LA PLAZA --->
		<table id="listado" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="TablaEncabeza">No.</td>
				<td class="TablaEncabeza">Nombre del académico</td>
				<td class="TablaEncabeza">Entidad</td>
				<td class="TablaEncabeza">Categoría inicial de la plaza</td>
				<td class="TablaEncabeza">Categoría que solicita la dependencia</td>
				<td class="TablaEncabeza">No. de plaza</td>
				<td class="TablaEncabeza">Propuesta de fecha decontratación a partir del</td>
				<td class="TablaEncabeza">Vigencia</td>
				<td class="TablaEncabeza">Observaciones</td>
			</tr>
			<cfoutput query="tbMovCAAAPlazasTemp">
                <cfquery name="tbConvocaCoa" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM convocatorias_coa
                    WHERE coa_no_plaza = '#sol_pos9#'
                    AND YEAR(cap_fecha_crea) BETWEEN YEAR(GETDATE()) -1 AND YEAR(GETDATE())    
                    <!--- AND coa_status BETWEEN 1 AND 4 --->
                </cfquery>
                <tr>
                    <td class="TablaContenido"><strong>#CurrentRow#</strong></td>
                    <td class="TablaContenido">#nombre#</td>
                    <td class="TablaContenido">#dep_nombre#</td>
                    <td class="TablaContenido"></td>
                    <td class="TablaContenido">#cn_siglas#</td>
                    <td class="TablaContenido">#sol_pos9#</td>
                    <td class="TablaContenido">#LsDateFormat(sol_pos14,'dd/mm/yyyy')#</td>
                    <td class="TablaContenido">
						<cfif #sol_pos13_a# GT 0>1 año</cfif>
						<cfif #sol_pos13_m# GT 0>#sol_pos13_m# mes(es)</cfif>
						<cfif #sol_pos13_d# GT 0>#sol_pos13_a# día(s)</cfif>
					</td>
					<td class="TablaContenido">
                        <cfif #tbConvocaCoa.Recordcount# GT 0>
                            PLAZA CON CONVOCATORIA DE COA EN PROCESO
                            Acta aprobación CTIC: #tbConvocaCoa.ssn_id#
                            Publicada en Gaceta UNAM no.: #tbConvocaCoa.coa_gaceta_num#
                            Situación del la convocatoria:
                                <cfswitch expression="#tbConvocaCoa.coa_status#">
                                    <cfcase value="3">APROBADA EN EL PLENO DEL CTIC</cfcase>
                                    <cfcase value="4">PUBLICADA EN GACETA</cfcase>
                                    <cfcase value="5">
                                        <cfif #tbConvocaCoa.sol_id_relaciona# EQ ''>
                                            EN PROCESO EN LA ENTIDAD
                                        <cfelse>
                                            COA ASINGNADO A UNA SOLICITUD FT-CTIC-5 (#tbConvocaCoa.sol_id_relaciona#)
                                        </cfif>
                                    </cfcase>
                                </cfswitch>
                        </cfif>
                    </td>
                </tr>
			</cfoutput>
		</table>        
		Versión: 2.4 <br/>
		Última actualización: 05/03/2020
	</body>
</html>
