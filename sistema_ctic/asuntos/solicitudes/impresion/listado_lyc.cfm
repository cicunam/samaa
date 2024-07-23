<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 02/11/2009 --->
<!--- FECHA ÚLTIMA MOD.: 20/03/2024 --->
<!--- IMPRESION DE RELACIÓN DE LICENCIAS Y COMISIONES ENVIADS POR LAS ENTIDADES --->
<!---
<!--- Obtener información del periodo de sesión --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones WHERE ssn_id = #vActa# AND ssn_clave = 1
</cfquery>
--->

<!--- Obtener el nombre del secretario académico para firma --->
<cfset vTipoFirma = 'LYC'>
<cfinclude template="#vCarpetaCOMUN#/include_firma_docs.cfm">

<!---
<!--- Obtener el nombre del director --->
<cfquery name="tbFirma" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos AS T1
	LEFT JOIN academicos_cargos AS T2 ON T1.acd_id = T2.acd_id
	WHERE 1 = 1
	<cfif #Session.sIdDep# EQ '030101' OR #Session.sIdDep# EQ '034201' OR #Session.sIdDep# EQ '034301' OR #Session.sIdDep# EQ '034401' OR #Session.sIdDep# EQ '034501' OR #Session.sIdDep# EQ '034601'>
        AND T2.dep_clave = '030101'
        AND T2.adm_clave = 100 <!--- SE CAMBIÓ LA FIRMA DEL COORDINADOR POR EL SECRETARIO DE INVESTIGACIÓN Y DESARROLLO 03/04/2018 --->
    <cfelse>
        AND T2.dep_clave = '#Session.sIdDep#' 
        AND T2.adm_clave = 32 adasdasasd
        AND T2.caa_fecha_inicio <= GETDATE()
	</cfif>
	AND T2.caa_status = 'A'
</cfquery>
--->
<!--- SE REQUIRIÓ ESTANDARIOZAR ESTO PARA AGREGAR EL LETRERO DE "USO INTERNO" SOLICITADO POR LA ST-CTIC...
<cfdocument format="PDF" fontembed="yes" marginbottom="1.5" marginleft="1.5" marginright="1.5" margintop="1.5" unit="cm" orientation="portrait" pagetype="letter">		
--->
<cfdocument format="PDF" fontembed="yes" orientation="portrait" pagetype="letter" margintop="3.1" unit="cm" backgroundvisible="yes">	
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<cfoutput>
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
		</cfoutput>
		<!---
		<style type="text/css">
			body {
				background-image:url(<cfoutput>#vCarpetaIMG#/iUsoInterno.gif</cfoutput>);
				background-position: center; 
			}
		</style>
		--->
	</head>
	<body>
		<!--- Titulo del reporte --->
		<cfdocumentitem type="header">
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
			<center>
				<span style="font-size:9pt;">
					<br>
					<b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
					<br>RELACI&Oacute;N DE LICENCIAS CON GOCE DE SUELDO Y COMISIONES MENORES A 22 D&Iacute;AS</span>
					<cfif #Session.sTipoSistema# IS 'sic'>
						<br>
						<br><i><cfoutput>#Session.sDep#</cfoutput></i>
					</cfif>
					<br>
				</span>
			</center>
		</cfdocumentitem>
		<!--- Obtener la lista de licencias y comisiones enviadas por las entidades adscritas al SIC --->
		<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
			SELECT *, LEFT(catalogo_cn.cn_siglas, 3) AS clase_academico 
			FROM ((movimientos_solicitud 
			LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
			LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
			LEFT JOIN catalogo_cn ON academicos.cn_clave = catalogo_cn.cn_clave
			WHERE (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41) <!--- Sólo licencias y comisiones (!) --->
			AND sol_status <= 3 <!--- Solicitudes enviadas --->
			<cfif #Session.sUsuarioNivel# EQ 26>
				AND sol_pos1 = '030101' 
				<cfif #Session.sIdDep# EQ '034201'>
					AND sol_pos1_u = '02'
				<cfelseif #Session.sIdDep# EQ '034301'>
					AND sol_pos1_u = '03'
				<cfelseif #Session.sIdDep# EQ '034401'>
					AND sol_pos1_u = '04'
				<cfelseif #Session.sIdDep# EQ '030116'>
					AND sol_pos1_u = '06'
				<cfelseif #Session.sIdDep# EQ '034501'>
					AND sol_pos1_u = '07'
				<cfelseif #Session.sIdDep# EQ '034601'>
					AND sol_pos1_u = '08'                
				</cfif>
			<cfelse>
				AND sol_pos1 = '#Session.sIdDep#'
			</cfif>    
<!---			
			<cfif #Session.sTipoSistema# IS 'sic'>
				
				AND movimientos_solicitud.sol_pos1 = '#Session.sIdDep#'
			</cfif> <!---Solo los asuntos de la dependencia --->
--->			
			ORDER BY 
			academicos.acd_apepat,
			academicos.acd_apemat,
			academicos.acd_nombres,
			movimientos_solicitud.sol_pos14
		</cfquery>
		<!-- Lista de licencias y comisiones -->
		<table border="0" cellspacing="0" cellpadding="0">
			<!--- Lista de licencias y comisiones --->
			<!--- Encabezados --->
			<tr>
				<td><b>NOMBRE</b></td>
				<td><b>CATEGOR&Iacute;A</b></td>
				<td><b>ASUNTO</b></td>
				<td><b>INICIO</b></td>
			</tr>
			<!-- Línea -->
			<tr><td colspan="7"><hr></td></tr>
			<!--- Incluir en la relación solamente las solicitudes marcadas --->
			<cfoutput query="tbSolicitudes">
				<cfif ArrayContainsValue(Session.AsuntosSolicitudFiltro.vMarcadas, #sol_id#) IS TRUE>
					<tr>
						<!-- Nombre del académico -->
						<td>#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#</td>
						<!-- Categoría y nivel -->
						<td>#tbSolicitudes.cn_siglas#</td>
						<!-- Asunto -->
						<td>
							<cfif #tbSolicitudes.mov_clave# IS 40>
								COMISI&Oacute;N
							<cfelse>
								#Ucase(tbSolicitudes.mov_titulo_corto)#
							</cfif>	
						</td>
						<!-- Fecha de incio -->
						<td>#LsDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</td>
					</tr>
					<!--- Registrar la fecha de impresión --->
                    <cfquery datasource="#vOrigenDatosSAMAA#">
                        UPDATE movimientos_solicitud 
                        SET sol_fecha_firma = GETDATE()
                        WHERE movimientos_solicitud.sol_id = #Session.AsuntosSolicitudFiltro.vMarcadas[E]#
                    </cfquery>                   
				</cfif>
			</cfoutput>
		</table>
		<!--- Espacio para el nombre y la firma del responsable --->
		<div style="bottom:1cm; width:100%;">
			<br><br><br><br><br>
			<table border="0" style="width:100%; font-size:7pt;">
				<tr>
					<td style="width:100%; text-align:center;">
						<hr width="50%">
					</td>
				</tr>
				<tr>
					<td style="width:100%; text-align:center;">
						<cfoutput>#tbFirma.acd_prefijo# #tbFirma.acd_nombres# #tbFirma.acd_apepat# #tbFirma.acd_apemat#</cfoutput>
					</td>
				</tr>
			</table>
		</div>
		<!--- Pie de página --->
		<cfdocumentitem type="footer">
			<div style="position:absolute; bottom:10px; width:100%;">
				<table width="100%">
					<tr>
						<td align="left" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>#FechaCompleta(Now())#</cfoutput></td>	
						<td align="right" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
					</tr>
				</table>		
			</div>	
		</cfdocumentitem> 
	</body>
</html>
</cfdocument>

