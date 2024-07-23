<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/06/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/05/20221 --->

<!--- IMPRESION DE OFICIOS DE LICENCIAS Y COMISIONES --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#_anexos_lyc_#vSsnId#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<!--- Obtener la información del COORDINADOR actual --->
<cfquery name="tbAcademicosCargosCoord" datasource="#vOrigenDatosSAMAA#">
	SELECT caa_firma, caa_siglas 
    FROM academicos_cargos
    WHERE adm_clave = 84
    AND caa_status = 'A'
</cfquery>

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vSsnId#
    AND ssn_clave = 1    
</cfquery>

<!--- Obtener solicitudes de licencias y comisiones --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_solicitudes_oficiosLyC 
	WHERE ssn_id = #vSsnId#
	ORDER BY 
	dep_orden,
	mov_clave DESC,
	acd_apepat,
	acd_apemat,
	acd_nombres,
	sol_pos14
</cfquery>

<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<style type="text/css">
			.pOficioEspacio
				{
					width:100%;
					text-align:left;
					margin:0pt;
					padding:0pt;
				}
			.pOficioEncabezado
				{
					margin-left:255pt; 
					margin-right:10pt;
					margin-bottom:0pt;
					margin-top:0pt;
					padding-bottom:0pt;
					padding-top:0pt;
				}
			.pOficioDirigido
				{
					width:100%;
					text-align:left;
					margin:0pt;
					padding:0pt;
				}
			.pOficioParrafo
				{
					width:100%;
					text-align:justify;
					margin:0pt;
					padding:0pt;					
				}
			.pOficioPiePag
				{
					width:100%;
					text-align:left;
					margin:0pt;
					padding:0pt;
				}
			.pListaLyC
				{
					width:100%;
					text-align:center;
					margin:0pt;
					padding:0pt;
				}
			@page WordSection2
				{
					mso-page-orientation: landscape;		
					size: 27.94cm 21.59cm;
					margin: 1.27cm  1.5cm 0.85cm 2cm;
					mso-header-margin:36.0pt;
					mso-footer-margin:36.0pt;
					mso-paper-source:0;
					font-size: 12pt;
					font-family:'Times New Roman';					
				}
				div.WordSection2
					{page:WordSection2;}
		</style>		        
		<!--- <link href="http://www.cic-ctic.unam.mx:31221<cfoutput>#vCarpetaCSS#</cfoutput>/oficios.css" rel="stylesheet" type="text/css">--->
	</head>
	<body>
		<!--- Generar oficios de respuesta --->
		<cfoutput query="tbSolicitudes" group="dep_clave">
			<!--- Obtener el nombre del director --->
			<cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM (academicos_cargos
				LEFT JOIN academicos ON academicos_cargos.acd_id = academicos.acd_id)
				LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON academicos_cargos.dep_clave = C2.dep_clave
				WHERE academicos_cargos.dep_clave = '#tbSolicitudes.sol_pos1#'
				AND academicos_cargos.adm_clave = '32'
				AND academicos_cargos.caa_fecha_inicio <= GETDATE()
				AND academicos_cargos.caa_fecha_final >= GETDATE()
			</cfquery>

			<!--- Contador de comisiones --->
			<cfquery name="tbCountCom" dbtype="query">
				SELECT COUNT(*) AS vCuenta
                FROM tbSolicitudes
				WHERE sol_pos1 = '#tbSolicitudes.sol_pos1#'
               	AND mov_clave = 40
			</cfquery>
			<cfset vCC = #tbCountCom.vCuenta#>

			<!--- Contador de licencias --->
			<cfquery name="tbCountLic" dbtype="query">
				SELECT COUNT(*) AS vCuenta
                FROM tbSolicitudes
				WHERE sol_pos1 = '#tbSolicitudes.sol_pos1#'
               	AND mov_clave = 41
			</cfquery>
			<cfset vCL = #tbCountLic.vCuenta#>

			<!--- Si hay asuntos generar el oficio y lista anexa --->
			<cfif #vCC# GT 0 OR #vCL# GT 0>	
				<!--- GENERA LISTA ANEXA --->
                <div class="WordSection2"> <!--- style="font-size: 10pt; font-family:'Times New Roman';"--->
					<p class="pListaLyC"><strong>#dep_nombre#</strong></p>
					<cfoutput group="mov_titulo">
						<cfset HD = 0>
						<!--- Lista de licencias y comisiones --->
                        <table id="lyc" width="100%" border="0" cellspacing="0" cellpadding="0" style="font-size: 10pt; font-family:'Times New Roman';">
                            <!--- Datos --->	
                            <cfoutput>
                                <!--- Solo inclir las solicitudes seleccionadas --->
                                <cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #tbSolicitudes.sol_id#) IS TRUE>
                                    <!--- Si no se ha puesto el encabezado entonces ponerlo --->
                                    <cfif #HD# IS 0>
                                        <!--- Titulo de la lista --->
                                        <tr>
                                            <td colspan="3" align="left">#Ucase(tbSolicitudes.mov_titulo)#</td>
                                            <td colspan="3" align="right">#tbSolicitudes.asu_oficio#</td>
                                        </tr>
                                        <!--- Línea --->
                                        <tr><td colspan="6"><hr></td></tr>
                                        <!--- Encabezados --->
                                        <tr>
                                            <td><strong>NOMBRE</strong></td>
                                            <td><strong>CATEGOR&Iacute;A</strong></td>
                                            <td><strong>DURACI&Oacute;N</strong></td>
                                            <td><strong>FECHA INICIO</strong></td>
                                            <td><strong>ACTIVIDAD</strong></td>
                                            <td><strong>DECISI&Oacute;N</strong></td>
                                        </tr>
                                        <!--- Línea --->
                                        <tr><td colspan="6"><hr></td></tr>
                                        <!--- Levantar bandera que indica que ya se imprimió el encabezado --->
                                        <cfset HD = 1>
                                    </cfif>
                                    <tr>
                                        <!--- Nombre del académico --->
                                        <td>#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#</td>
                                        <!--- Categoría y nivel --->
                                        <td>#tbSolicitudes.cn_siglas#</td>
                                        <!--- Duración (en días) --->
                                        <td>#LsNumberFormat(tbSolicitudes.sol_pos13_d,99)# DIAS</td>
                                        <!--- Fecha de incio --->
                                        <td>#LsDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</td>
                                        <!--- Actividad --->
                                        <cfquery name="ctActividad" datasource="#vOrigenDatosSAMAA#">
                                            SELECT * FROM catalogo_actividad
                                            WHERE activ_clave = #tbSolicitudes.sol_pos12#
                                        </cfquery>
                                        <td>#ctActividad.activ_descrip#</td>
                                        <!--- Decisión --->
                                        <cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
                                            SELECT * FROM movimientos_asunto
                                            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
                                            WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vSsnId# AND asu_reunion = 'CTIC'
                                        </cfquery>
                                        <!--- Como la ST-CTIC genera los oficios antes de que el CTIC emita su decisión, es necesario tomar en su lugar la recomendación de la CAAA --->
                                        <td>#tbAsuntosCTIC.dec_descrip#</td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                        </table>
						<!--- Espacio --->
                        <cfloop index="Espacio" from="1" to="3">
                            <p class="pOficioEspacio">&nbsp;</p>
                        </cfloop>
                    </cfoutput>
                    <!--- Salto de página --->				
                    <span lang=ES-TRAD style='font-size:12.0pt;mso-bidi-font-size:10.0pt;
                    line-height:90%;font-family:"Times New Roman",serif;mso-fareast-font-family:
                    "Times New Roman";mso-ansi-language:ES-TRAD;mso-fareast-language:ES-MX;
                    mso-bidi-language:AR-SA'><br clear=all style='page-break-before:always'>
                    </span>
				</div>
			</cfif>	            
		</cfoutput>
	</body>
</html>
