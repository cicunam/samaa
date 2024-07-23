<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/08//2019 --->
<!--- FECHA ÚLTIMA MOD.: 24/05/2024 --->
<!--- GENERA LOS OFICIOS SOBRE LOS ESTÍMULOS DGAPA --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vSsnId# 
    AND ssn_clave = 1
</cfquery>

<cfif #vTipoOficio# EQ '104' OR #vTipoOficio# EQ '105'>
    <cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM consulta_estimulos_dgapaOficios
        WHERE ssn_id = #vSsnId#
        AND oficio_id = #vTipoOficio#
        AND estimulo_oficio IS NOT NULL
        ORDER BY dep_orden, acd_apepat, acd_apemat
    </cfquery>
<cfelseif #vTipoOficio# EQ '102'>
    <cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
        SELECT T1.estimulo_id, T1.acd_id, T1.dep_clave, T1.ubica_clave, T1.cn_clave, T1.con_clave, T1.pride_clave, T1.pride_clave_ant, T1.ingreso, T1.propuesto_pride_d, T1.ratifica_caa_pride_d, T1.recurso_revision, T1.renovacion, 
        T1.reingreso, T1.ssn_id, T1.estimulo_oficio, T1.estimulo_nota, T2.acd_prefijo, ISNULL(dbo.SINACENTOS(T2.acd_nombres), N'') + CASE WHEN acd_nombres IS NULL 
        THEN '' ELSE ' ' END + ISNULL(dbo.SINACENTOS(T2.acd_apepat), N'') + CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + ISNULL(dbo.SINACENTOS(T2.acd_apemat), N'') AS nombre_completo_npm, T2.acd_rfc, 
        T2.acd_apepat, T2.acd_apemat, T2.dep_clave AS Expr2, T2.dep_ubicacion, T2.acd_prefijo AS Expr3, T2.acd_sexo, C1.dep_siglas, C1.dep_nombre, C1.dep_orden, C2.cn_siglas, C2.cn_descrip, C3.pride_nivel, C3.orden_samaa, 
        C4.ubica_nombre, C5.oficio_id, C5.mov_clave, C5.mov_clave_2, C5.oficio_descrip, C5.oficio_asunto_1, C5.oficio_asunto_2, C5.oficio_parrafo_1, C5.oficio_parrafo_2, C5.oficio_parrafo_3, C5.oficio_parrafo_4, C5.oficio_ccp_1, 
        C5.oficio_ccp_2, C5.oficio_ccp_3, C5.oficio_ccp_4, C5.oficio_ccp_5, C5.oficio_ccp_6, C5.oficio_status, C5.oficio_modificaciones
        FROM dbo.estimulos_dgapa AS T1 
        LEFT OUTER JOIN dbo.academicos AS T2 ON T1.acd_id = T2.acd_id
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias_ubica') AS C4 ON C4.ubica_clave = T1.ubica_clave AND C4.dep_clave = T1.dep_clave 
        LEFT OUTER JOIN dbo.catalogo_movimiento_oficios AS C5 ON C5.mov_clave = 102
        WHERE T1.ssn_id = #vSsnId#
        AND T1.pride_clave BETWEEN 4 AND 5
        AND propuesto_pride_d = 1
        ORDER BY C1.dep_orden, T2.acd_apepat, T2.acd_apemat
    </cfquery>    
<cfelseif #vTipoOficio# EQ '101I' OR #vTipoOficio# EQ '101R'>
    <cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
        SELECT T1.estimulo_id, T1.acd_id, T1.dep_clave, T1.ubica_clave, T1.cn_clave, T1.con_clave, T1.pride_clave, T1.pride_clave_ant, T1.ingreso, T1.propuesto_pride_d, T1.ratifica_caa_pride_d, T1.recurso_revision, T1.renovacion, 
        T1.reingreso, T1.ssn_id, T1.estimulo_oficio, T1.estimulo_nota, T2.acd_prefijo, ISNULL(dbo.SINACENTOS(T2.acd_nombres), N'') + CASE WHEN acd_nombres IS NULL 
        THEN '' ELSE ' ' END + ISNULL(dbo.SINACENTOS(T2.acd_apepat), N'') + CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + ISNULL(dbo.SINACENTOS(T2.acd_apemat), N'') AS nombre_completo_npm, T2.acd_rfc, 
        T2.acd_apepat, T2.acd_apemat, T2.dep_clave AS Expr2, T2.dep_ubicacion, T2.acd_prefijo AS Expr3, T2.acd_sexo, C1.dep_siglas, C1.dep_nombre, C1.dep_orden, C2.cn_siglas, C2.cn_descrip, C3.pride_nivel, C3.orden_samaa, 
        C4.ubica_nombre, C5.oficio_id, C5.mov_clave, C5.mov_clave_2, C5.oficio_descrip, C5.oficio_asunto_1, C5.oficio_asunto_2, C5.oficio_parrafo_1, C5.oficio_parrafo_2, C5.oficio_parrafo_3, C5.oficio_parrafo_4, C5.oficio_ccp_1, 
        C5.oficio_ccp_2, C5.oficio_ccp_3, C5.oficio_ccp_4, C5.oficio_ccp_5, C5.oficio_ccp_6, C5.oficio_status, C5.oficio_modificaciones
        FROM dbo.estimulos_dgapa AS T1 
        LEFT OUTER JOIN dbo.academicos AS T2 ON T1.acd_id = T2.acd_id
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave
        LEFT OUTER JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias_ubica') AS C4 ON C4.ubica_clave = T1.ubica_clave AND C4.dep_clave = T1.dep_clave 
        LEFT OUTER JOIN dbo.catalogo_movimiento_oficios AS C5 ON C5.mov_clave = 101
        WHERE T1.ssn_id = #vSsnId#
        AND T1.pride_clave BETWEEN 2 AND 4
        <cfif #vTipoOficio# EQ '101I'>
            AND ingreso = 1
        <cfelseif #vTipoOficio# EQ '101R'>
            AND renovacion = 1
        </cfif>
        ORDER BY C1.dep_orden, T2.acd_apepat, T2.acd_apemat            
    </cfquery>
<cfelseif #vTipoOficio# EQ '106'>
</cfif>


<!--- IMPRESION DE OFICIOS DE LICENCIAS Y COMISIONES --->
<!--- Enviar el contenido a un archivo MS Word  --->
<cfheader name="Content-Disposition" value="inline; filename=oficios_estimulos_dgapa_#vSsnId#_#vTipoOficio#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:word"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">

    <head>
        <title>SAMAA</title>
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
                    margin-left:235pt;
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
                    font-family:'Arial Narrow';/* Times New Roman (02/06/2022) */
                    tab-interval:17pt;
                }
                div.WordSection1
                    {page:WordSection1;}
        </style>
    </head>
    <body>
		<cfoutput query="tbEstimulosDgapa">

			<!--- ************************************************************************************** ---->
			<!--- GENERA OFICIOS --->
            <div class="WordSection1">
				<cfset vTabuladores = 4><!--- TABULADORES PARA LOS ASUNTO SECUNDARIOS Y ALINEAR CON EL NO. DE OFICIO Y ASUNTO PRINCIPA --->
				<!--- Espacio --->
				<cfloop index="Espacio" from="1" to="5">
					<p class="pOficioEspacio"><br /><!--- &nbsp; SE REPLAZÓ nbsp; POR br EL 23/05/2019 YA QUE INCORPORABA UN CARACTER RARO EN MSWORD ---></p>
				</cfloop>
				<!--- ******************* ASUNTO DEL OFICIO ******************* --->
				<!--- Número de oficio y asunto --->
				<p class="pOficioAsunto">
					<span style='mso-tab-count:1;' lang=ES-TRAD>
						Oficio:
					</span>
					<span style='mso-tab-count:1;' lang=ES-TRAD>
						#estimulo_oficio#
					</span>
				</p>

				<p class="pOficioAsunto">
					<span style='mso-tab-count:1;' lang=ES-TRAD>
						Asunto:
					</span>
					<span style='mso-tab-count:1;' lang=ES-TRAD>
                        <cfif #vTipoOficio# EQ '101I'>
                            <cfset vOficioAsunto1 = #Replace(oficio_asunto_1,'(TIPO_PRIDE)','ingreso')#>
                        <cfelseif #vTipoOficio# EQ '101R'>
                            <cfset vOficioAsunto1 = #Replace(oficio_asunto_1,'(TIPO_PRIDE)','renovación')#>
                        <cfelse>
                            <cfset vOficioAsunto1 = #oficio_asunto_1#>
                        </cfif>
                        #vOficioAsunto1#
    
					</span>
				</p>
				<cfset vEspaciosEncabezado = 4>
				<cfif #oficio_asunto_2# NEQ '' AND #mov_clave# NEQ 4>
					<p class="pOficioAsunto">
						<span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>                            
							#oficio_asunto_2#<br/>
						</span>
					</p>
					<cfset vEspaciosEncabezado = #vEspaciosEncabezado# - 1>
				</cfif>
				<!--- Espacio --->
				<cfloop index="Espacio" from="1" to="#vEspaciosEncabezado#">
					<p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
				</cfloop>

				<!--- ACADÉMICO --->
				<p class="pOficioDirigido">
					#Trim(acd_prefijo)# #nombre_completo_npm#<br/>
                    #cn_descrip#
				</p>
				<cfif #dep_siglas# EQ 'CIC'>
					<p class="pOficioDirigido">
						COORDINACION DE LA INVESTIGACION CIENTIFICA
					</p>
					<p class="pOficioDirigido">
						UNIDAD DE PROYECTOS ESPECIALES EN APOYO A LA INVESTIGACION Y LA DOCENCIA (UPEID)
					</p>
					<p class="pOficioDirigido">
						#Ucase(ubica_nombre)#
					</p>
					<cfset vEspaciosEncabezado = 2>
				<cfelse>
					<p class="pOficioDirigido">
						#Ucase(dep_nombre)#
					</p>
					<cfset vEspaciosEncabezado = 4>
				</cfif>
				<p style="width:100%; text-align: left; margin:0pt; padding:0pt;">
					P r e s e n t e
				</p>
				<!--- Espacio --->
				<cfloop index="Espacio" from="1" to="#vEspaciosEncabezado#">
					<p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
				</cfloop>

				<!--- ******************* PÁRRAFO 1 ******************* --->
                <cfif #vTipoOficio# EQ '101I' OR #vTipoOficio# EQ '101R'>
                    <cfset vParrafo1 = #Replace(oficio_parrafo_1,'(ENTIDAD_ADSCRIP)',Ucase(dep_nombre))#>
                    <cfset vParrafo1 = #Replace(vParrafo1,'(NIVEL_PRIDE)',pride_nivel)#>
                <cfelse>
				    <cfset vParrafo1 = #oficio_parrafo_1#>
                </cfif>

				<!--- Párrafo texto 1 IMPRIME --->
                <p class="pOficioParrafo">
                    #vParrafo1#
                </p>
                <cfif #oficio_parrafo_2# EQ ''>
				    <cfset vEspaciosParrafo = 5>
                <cfelse>
				<!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="1">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <p class="pOficioParrafo">
                        #oficio_parrafo_2#
                    </p>

				    <cfset vEspaciosParrafo = 3>
                </cfif>
				<!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="#vEspaciosParrafo#">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>

				<!--- PIE DE PAGINA --->
				<!--- Firma (INCLUDE PARA TODOS LOS OFICIOS --->
                <cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_firma.cfm">
                <!--- Espacio --->
                <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                <!--- Pie --->
                    
                <cfif #vTipoOficio# EQ '104' OR #vTipoOficio# EQ '105'>
                    <cfset vEspaciosPiepag = 6>
                <cfelse>
                    <cfset vEspaciosPiepag = 3>
                </cfif>
                        
                <!--- Espacio --->
                <cfloop index="Espacio" from="1" to="#vEspaciosPiepag#">
                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                </cfloop>
                    
                <!--- INSERTA EL CCP --->                    
                <cfif #vTipoOficio# NEQ '104' AND #vTipoOficio# NEQ '105'>
                    <!--- Obtener el nombre del director --->
                    <cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
                        SELECT acd_prefijo, nombre_completo_npm, acd_sexo
                        FROM consulta_cargos_acadadm
                        WHERE dep_clave = '#dep_clave#' 
                        AND adm_clave = '32'
                        AND GETDATE() BETWEEN caa_fecha_inicio AND caa_fecha_final                        
                    </cfquery>
                    
                    <cfif #tbAcademicosCargos.acd_sexo# IS 'F'>
                        <cfset vDirectorTitulo = 'DIRECTORA'>
                    <cfelse>
                        <cfset vDirectorTitulo = 'DIRECTOR'>
                    </cfif>                    
                    
                    <p class="pOficioPiePag" style="font-size: 9pt;">
                        C.C.P.
                        <span style='mso-tab-count:1;'>
                            <!--- A SOLICITUD DE NICOL SE HIZO ESTA ACTUALIZACIÓN 27/01/2021 --->
                            <cfif #dep_siglas# EQ 'CIC'>
                                SECRETARIO DE INVESTIGACION Y DESARROLLO DE LA COORDINACION DE LA INVESTIGACION CIENTIFICA
                            <cfelse>
                                <cfset vDirectorNombre = '#tbAcademicosCargos.acd_prefijo# #tbAcademicosCargos.nombre_completo_npm#'>
                                <cfset vDirector = #Replace(oficio_ccp_1,'(DIRECTOR_NOMBRE)',vDirectorNombre,"ALL")#>
                                <cfset vDirector = #Replace(vDirector,'(DIRECTOR_TITULO)',vDirectorTitulo,"ALL")#>
                                #vDirector#
                            </cfif>
                        </span>
                        <br/>
                        <span style='mso-tab-count:2;' lang=ES-TRAD>
                            <span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_5#</span>
                        </span>
                            
                        <!--- Espacio --->
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </p>
                </cfif>
                    
                <!--- Siglas de generación de oficio y número de sesión (INCLUDE PARA TODOS LOS OFICIOS --->
                    <cfset vpSiglasOficio = 'AU'>
				    <cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_pie_pagina.cfm">
			</div>
			<!--- Salto de página --->				
			<span lang=ES-TRAD style='font-size:12.0pt;mso-bidi-font-size:10.0pt;
			line-height:90%;font-family:"Times New Roman",serif;mso-fareast-font-family:
			"Times New Roman";mso-ansi-language:ES-TRAD;mso-fareast-language:ES-MX;
			mso-bidi-language:AR-SA'><br clear=all style='page-break-before:always'>
			</span>
        </cfoutput>
    </body>
</html>
