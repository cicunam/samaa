<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/06/2017 --->
<!--- FECHA ÚLTIMA MOD.: 25/05/2022 --->

<!--- IMPRESION DE OFICIOS DE LICENCIAS Y COMISIONES --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#oficios_lyc_#vSsnId#.doc">
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
    
<!---    
	SELECT * FROM ((((movimientos_solicitud 
	LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON academicos.cn_clave = C3.cn_clave
	WHERE movimientos_asunto.ssn_id = #vSsnId#
	AND movimientos_asunto.asu_reunion = 'CTIC'
	AND (movimientos_solicitud.mov_clave = 40 OR movimientos_solicitud.mov_clave = 41) <!--- licencias y comisiones --->
	ORDER BY 
	C2.dep_orden,
	movimientos_solicitud.mov_clave DESC,
	academicos.acd_apepat,
	academicos.acd_apemat,
	academicos.acd_nombres,
	movimientos_solicitud.sol_pos14
--->    
</cfquery>

<!--- Obtener solicitudes de licencias y comisiones --->
<cfquery name="ctOficios" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento_oficios
	WHERE mov_clave = 40
	AND oficio_status = 1
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
            .pOficioAsunto
                {
                    margin-left:247pt;
                    margin-right:4pt;
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
            @page WordSection1
                {
                    mso-page-orientation: portrait;		
                    size: 21.59cm 27.94cm;
                    margin:1.27cm  2.5cm 0.85cm 3cm;
                    mso-header-margin:36.0pt;
                    mso-footer-margin:36.0pt;
                    mso-paper-source:0;
                    font-size: 12pt;
                    font-family:'Times New Roman';					
                    tab-interval:17pt;
                }
                div.WordSection1
                    {page:WordSection1;}
        </style>
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
				<!--- ************************************************************************************** ---->
				<!--- GENERA OFICIOS --->
				<div class="WordSection1">
					<cfset vTabuladores = 4><!--- TABULADORES PARA LOS ASUNTO SECUNDARIOS Y ALINEAR CON EL NO. DE OFICIO Y ASUNTO PRINCIPA --->
					<!--- Espacio --->
					<cfloop index="Espacio" from="1" to="6">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; SE REPLAZÓ nbsp; POR br EL 23/05/2019 YA QUE INCORPORABA UN CARACTER RARO EN MSWORD ---></p>
					</cfloop>
					<!--- ******************* ASUNTO DEL OFICIO ******************* --->
                    <!--- Número de oficio y asunto --->
                    <p class="pOficioAsunto">
                        <span style='mso-tab-count:1;' lang=ES-TRAD>Oficio:</span>
						<span style='mso-tab-count:1;' lang=ES-TRAD>#tbSolicitudes.asu_oficio#</span>
                    </p>
                    <p class="pOficioAsunto">
						<span style='mso-tab-count:1;' lang=ES-TRAD>Asunto:</span>
						<span style='mso-tab-count:1;' lang=ES-TRAD>#ctOficios.oficio_asunto_1#</span>
					</p>
					<p class="pOficioAsunto">
						<span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>#ctOficios.oficio_asunto_2#</span>
					</p>                    
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="3">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
                    <!--- Dirigido a --->
                    <p class="pOficioDirigido">
						#Trim(tbAcademicosCargos.acd_prefijo)# #Trim(tbAcademicosCargos.acd_nombres)# #Trim(tbAcademicosCargos.acd_apepat)# #Trim(tbAcademicosCargos.acd_apemat)#
					</p>
                    <p class="pOficioDirigido">
						DIRECTOR<cfif #tbAcademicosCargos.acd_sexo# IS 'F'>A</cfif>
					</p>
                    <p class="pOficioDirigido">
						#Ucase(tbSolicitudes.dep_nombre)#
					</p>                    
					<p class="pOficioDirigido">
                        P r e s e n t e
					</p>
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="3">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
                    <!--- CUERPO DE OFICIO --->
					<p class="pOficioParrafo">
                    	#Replace(ctOficios.oficio_parrafo_1,'(FECHA_SESION)',FechaCompleta(tbSesiones.ssn_fecha))#
					</p>
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="6">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
                    <!--- PIE DE PAGINA --->
    
                    <!--- Firma (INCLUDE PARA TODOS LOS OFICIOS --->
						<cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_firma.cfm">

                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="3">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
                    <!--- Pie --->
					<p class="pOficioPiePag">
						Se anexa lista.
					</p>
					<p class="pOficioPiePag">
						<cfif #vCL# GT 0>#vCL# licencias</cfif><cfif #vCL# GT 0 AND #vCC# GT 0>,</cfif><cfif #vCC# GT 0>#vCC# comisiones</cfif>
					</p>
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="3">
	                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
					</cfloop>
                    <p class="pOficioPiePag">
                        C.C.P.<span style='mso-tab-count:1;' lang=ES-TRAD>#ctOficios.oficio_ccp_3#</span>
					</p>
                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    <!--- Siglas de generación de oficio y número de sesión (INCLUDE PARA TODOS LOS OFICIOS) --->
                        <cfset vpSiglasOficio = 'STC'>
						<cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_pie_pagina.cfm">
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
