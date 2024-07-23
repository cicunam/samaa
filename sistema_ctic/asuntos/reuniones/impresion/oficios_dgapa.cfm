<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 04/08/2017 --->
<!--- FECHA ÚLTIMA MOD.: 09/11/2022 --->
<!--- IMPRESION DE OFICIOS DE RESPUESTA AL DIRECTOR DE LA DGAPA APRA LOS SABÁTICOPS CON BECA --->

<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#_oficios_#vSsnId#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">
    
<!--- Obtener la información del COORDINADOR actual --->
<cfquery name="tbAcademicosCargosCoord" datasource="#vOrigenDatosSAMAA#">
	SELECT caa_firma, caa_siglas 
    FROM academicos_cargos
    WHERE adm_clave = 84
    AND caa_status = 'A'
</cfquery>
    
<!--- Obtener la información del DIRECTOR DE LA DEGAPA actual (se agregó el 09/11/2022)--->
<cfquery name="ctUnamFun" datasource="#vOrigenDatosCATALOGOS#">
	SELECT fun_apepat, fun_apemat, fun_nombres, grado_siglas, fun_sexo
    FROM catalogo_unam_funcionarios
    WHERE dep_clave = '050201'
    AND '#vFechaHoyUsa#' BETWEEN fecha_inicio AND fecha_termino
</cfquery>

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vSsnId# 
    AND ssn_clave = 1
</cfquery>

<!--- Fecha la sesión de pleno --->
<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>

<!--- Obtener los datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT *, 
		ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
		CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
		CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
		ISNULL(dbo.SINACENTOS(acd_apemat),'') AS vNombre     
	FROM movimientos_solicitud AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CTIC'
	LEFT JOIN academicos AS T3 ON T1.sol_pos2 = T3.acd_id
	LEFT JOIN catalogo_movimiento_oficios AS C1 ON C1.mov_clave = 90 AND C1.oficio_status = 1
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.sol_pos1 = C2.dep_clave
<!---
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON T1.sol_pos3 = C3.cn_clave
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias_ubica')# AS C4 ON T1.sol_pos1 = C4.dep_clave AND T1.sol_pos1_u = C4.ubica_clave
--->
	WHERE T2.ssn_id = #vSsnId#
	AND T2.asu_reunion = 'CTIC'
	AND T1.mov_clave = 30 <!--- Excluir los asuntos de los que no se genera oficio de respuesta --->
	ORDER BY 
	T2.asu_numero
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
		<cfoutput query="tbSolicitudes">
			<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #tbSolicitudes.sol_id#) IS TRUE>       

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

				<cfif #tbAcademicosCargos.acd_sexo# IS 'F'>
                	<cfset vDirectorTitulo = 'DIRECTORA'>
				<cfelse>
                	<cfset vDirectorTitulo = 'DIRECTOR'>
                </cfif>

				<cfif #acd_sexo# EQ 'F'>
					<cfset vPronombre = 'de la'>
                <cfelseif #acd_sexo# EQ 'M'>
					<cfset vPronombre = 'del'>
				</cfif>

				<cfif #sol_pos13# EQ 'A'>
                    <cfset vPeridoSabatico = 'Año'>
                <cfelseif #sol_pos13# EQ 'S'>
                    <cfset vPeridoSabatico = 'Semestre'>
                </cfif>
				<!--- ************************************************************************************** ---->
				<!--- GENERA OFICIOS --->                
				<div class="WordSection1" style="font-size: 12pt; font-family:'Times New Roman';">
					<cfset vTabuladores = 4><!--- TABULADORES PARA LOS ASUNTO SECUNDARIOS Y ALINEAR CON EL NO. DE OFICIO Y ASUNTO PRINCIPA --->
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="6">
	                    <p class="pOficioEspacio">&nbsp;</p>
					</cfloop>
					<!--- ENCABEZADO DE OFICIO --->
                    <!--- Número de oficio y asunto --->
                    <p class="pOficioAsunto">
						<span style='mso-tab-count:1;' lang=ES-TRAD>Oficio:</span>
						<span style='mso-tab-count:1;' lang=ES-TRAD>#asu_oficio_dgapa#</span>                        
                    </p>
                    <p class="pOficioAsunto">
						<span style='mso-tab-count:1;' lang=ES-TRAD>Asunto:</span>
						<span style='mso-tab-count:1;' lang=ES-TRAD>#Replace(oficio_asunto_1,'(PERIODO_SABATICO)',vPeridoSabatico,"ALL")#</span>
					</p>
					<cfif #oficio_asunto_2# NEQ ''>
                        <p class="pOficioAsunto">
							<span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>#oficio_asunto_2#</span>
                        </p>
					</cfif>
                    <!--- Espacio --->
					<cfset vEspaciosEncabezado = 4>
					<cfloop index="Espacio" from="1" to="#vEspaciosEncabezado#">
	                    <p class="pOficioEspacio">&nbsp;</p>
					</cfloop>
					<!--- Dirigido a --->                    
					<!--- DIRECTOR/RA DE LA DGAPA --->
                    <p class="pOficioDirigido">
                        #ctUnamFun.grado_siglas# #ctUnamFun.fun_nombres# #ctUnamFun.fun_apepat# #ctUnamFun.fun_apemat#
                    </p>
                    <p class="pOficioDirigido">
                        DIRECTOR<cfif #ctUnamFun.fun_sexo# IS 'M'>A</cfif> GENERAL DE ASUNTOS DEL<br>PERSONAL ACAD&Eacute;MICO
                    </p>
					<p style="width:100%; text-align: left; margin:0pt; padding:0pt;">
						P r e s e n t e
					</p>
                    <!--- Espacio --->
					<cfloop index="Espacio" from="1" to="2">
	                    <p class="pOficioEspacio">&nbsp;</p>
					</cfloop>

					<!--- CUERPO DE OFICIO --->
					<cfset vEspaciosCuerpo = 9>
                    
                    <!--- ********* PÁRRAFO 1 ********* --->
						<cfset vParrafo1 = #oficio_parrafo_1#>

						<cfif #FIND('(FECHA_SESION)',oficio_parrafo_1)# GT 0>
          					<cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_SESION)',FechaCompleta(tbSesiones.ssn_fecha),"ALL")#>
      					</cfif>                        

						<cfif #FIND('(DECISION)',oficio_parrafo_1)# GT 0>
							<cfset vParrafo1 = #Replace(vParrafo1,'(DECISION)',Ucase(tbAsuntosCTIC.dec_descrip),"ALL")#>
						</cfif>

						<cfif #FIND('(PERIODO_SABATICO)',oficio_parrafo_1)# GT 0>
							<cfset vParrafo1 = #Replace(vParrafo1,'(PERIODO_SABATICO)',Ucase(vPeridoSabatico),"ALL")#>                        
						</cfif>
                        
						<cfif #FIND('(NOMBRE_ACAD)',oficio_parrafo_1)# GT 0>
							<cfset vTextoRepNombre = '#vPronombre# #acd_prefijo# #vNombre#'>
							<cfset vParrafo1 = #Replace(vParrafo1,'(NOMBRE_ACAD)',vTextoRepNombre,"ALL")#>
						</cfif>
                        
						<cfif #FIND('(ENTIDAD_ADSCRIP)',oficio_parrafo_1)# GT 0>
                            <cfset vParrafo1 = #Replace(vParrafo1,'(ENTIDAD_ADSCRIP)',Ucase(dep_nombre),"ALL")#>
                        </cfif>

						<cfif #FIND('(FECHA_INICIO)',oficio_parrafo_1)# GT 0>
          					<cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_INICIO)',Ucase(FechaCompleta(sol_pos14)),"ALL")#>
						</cfif>

  						<!--- Párrafo texto 1 IMPRIME --->
						<p class="pOficioParrafo">
                            #vParrafo1#
						</p>

					<!--- Espacio --->
                    	<p class="pOficioEspacio">&nbsp;</p>

                    <!--- ********** PÁRRAFO 2 ********* --->
						<cfset vParrafo2 = #oficio_parrafo_2#>                        
                        
                    <!--- Párrafo texto 2 IMPRIME --->
                        <p class="pOficioParrafo">
                            #vParrafo2#
                        </p>

                   	<cfset vEspaciosParrafo = 7>
                    
                    <!--- Espacio --->
                      <cfloop index="Espacio" from="1" to="#vEspaciosParrafo#">
                            <p class="pOficioEspacio">&nbsp;</p>
                      </cfloop>

                    <!--- PIE DE PAGINA --->
                    <!--- Firma (INCLUDE PARA TODOS LOS OFICIOS --->
						<cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_firma.cfm">
                    <!--- Espacio --->
                        <p class="pOficioEspacio">&nbsp;</p>
                        <p class="pOficioEspacio">&nbsp;</p>
                        <cfset vTabuladores = 2><!--- TABULADORES PARA ALINEAR CON C.C.P. --->
                    <!--- Pie --->
                    <p class="pOficioPiePag">
                        C.C.P.<span style='mso-tab-count:1;'>#Replace(oficio_ccp_1,'(DIRECTOR_TITULO)',vDirectorTitulo,"ALL")#</span>
					</p>
                    <p class="pOficioPiePag">
						<span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_2#</span>
					</p>

                    <!--- Espacio --->
					<cfset vEspaciosPiepag = 3>
					<cfloop index="Espacio" from="1" to="#vEspaciosPiepag#">
						<p class="pOficioEspacio">&nbsp;</p>
					</cfloop>
                    <!--- Siglas de generación de oficio y número de sesión (INCLUDE PARA TODOS LOS OFICIOS) --->
                        <cfset vpSiglasOficio = 'STC'>                        
						<cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_pie_pagina.cfm">
				</div>
				<!--- Salto de página --->				
                <span lang=ES-TRAD style='font-size:12.0pt;mso-bidi-font-size:10.0pt;
                line-height:90%;font-family:"Times New Roman",serif;mso-fareast-font-family:
                "Times New Roman";mso-ansi-language:ES-TRAD;mso-fareast-language:ES-MX;
                mso-bidi-language:AR-SA'><br clear=all style='page-break-before:always'>
                </span>
			</cfif>                
		</cfoutput>
	</body>
</html>                
