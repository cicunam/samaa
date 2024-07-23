
<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 24/05/2016 --->
<!--- FECHA ULTIMA MOD.: 23/05/2018 --->
<!--- IMPRESION DE OFICIOS DE RESPUESTA INFORMES ANUALES --->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#_oficios_informes_#vpInformeAnio#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<cfset vProgActividades = #vpInformeAnio# + 1>
<cfset vTextoComun = 'informe de actividades #vpInformeAnio# y su programa de trabajo #vProgActividades#'>

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
    WHERE ssn_id = #vpSsnId# 
	AND ssn_clave = 1
</cfquery>

<cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
    SELECT TOP 10 * FROM consulta_informes_oficios
    WHERE informe_anio = '#vpInformeAnio#'	
	AND ssn_id = #vpSsnId#	
<!---	
    SELECT 
    T1.informe_anio, 
	T3.*,
    T2.acd_prefijo, T2.acd_nombres, T2.acd_apepat, T2.acd_apemat, 
    C1.cn_descrip,
    C4.*
    FROM movimientos_informes_anuales AS T1
    LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
    LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id <!--- AND T3.informe_reunion = 'CTIC' AND T3.ssn_id = #vpSsnId# --->
    LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C1 ON T1.cn_clave = C1.cn_clave <!---CATALOGOS GENERALES MYSQL --->
    LEFT JOIN catalogo_decision AS C3 ON T3.dec_clave = C3.dec_clave
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C4 ON T1.dep_clave = C4.dep_clave <!---CATALOGOS GENERALES MYSQL --->
    WHERE T1.informe_anio = '#vpInformeAnio#'
	AND T3.informe_reunion = 'CTIC'
	AND T3.ssn_id = #vpSsnId#
    AND (T3.dec_clave = 1 OR T3.dec_clave = 4 OR T3.dec_clave = 49) <!--- T1.dec_clave = 4 --->
    ORDER BY C4.dep_orden, C3.dec_orden, T2.acd_apepat, T2.acd_apemat
--->
</cfquery>

<!--- Fecha la sesión de pleno --->
<cfset DiaCTIC = FechaCompleta(tbSesiones.ssn_fecha)>

    <html xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:w="urn:schemas-microsoft-com:office:word"
    xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
    xmlns="http://www.w3.org/TR/REC-html40">
        <head>
            <title>SAMAA</title>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!---
			<cfoutput>
				<link href="#vCarpetaCSS#/oficios_v20.css" rel="stylesheet" type="text/css">
			</cfoutput>
---->	
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
                .pOficioRubrica
                    {
						position: absolute; 
						float: left; 
						margin-left: -50px; 
						margin-top: 9px; 
						width: inherit;
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
			<cfoutput query="tbInformesAnuales">    
                <cfset vpDepClave = #dep_clave#>
                <cfset vpDepNombre = #dep_nombre#>
				<cfset vEspaciosCuerpo = 9>
    
                <!--- Obtener la información del COORDINADOR actual --->
                <cfquery name="tbAcademicosCargosDir" datasource="#vOrigenDatosSAMAA#">
                    SELECT T2.acd_sexo, T2.acd_prefijo, T2.acd_nombres, T2.acd_apepat, T2.acd_apemat
                    FROM academicos_cargos AS T1
                    LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
                    WHERE adm_clave = 32
                    AND caa_status = 'A'
                    AND T1.dep_clave = '#vpDepClave#'
                </cfquery>
                
                <!--- ************************************************************************************** ---->
                <!--- GENERA OFICIOS --->
                <div class="WordSection1">
					<cfset vTabuladores = 4><!--- TABULADORES PARA LOS ASUNTO SECUNDARIOS Y ALINEAR CON EL NO. DE OFICIO Y ASUNTO PRINCIPA --->                
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="6">
						<p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- ******************* ASUNTO DEL OFICIO ******************* --->
                    <!--- Número de oficio y asunto --->
                    <p class="pOficioAsunto">
                        <span style='mso-tab-count:1;' lang=ES-TRAD>Oficio:</span>
                        <span style='mso-tab-count:1;' lang=ES-TRAD>CJIC/CTIC/#informe_oficio#</span>
					</p>
                    <p class="pOficioAsunto">
                        <span style='mso-tab-count:1;' lang=ES-TRAD>Asunto:</span>
                        <span style='mso-tab-count:1;' lang=ES-TRAD>Evaluación de informe #informe_anio# y</span>
                        <span style='mso-tab-count:2;' lang=ES-TRAD>programa de trabajo #vProgActividades#</span>                        
                    </p>
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="2">
						<p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- Dirigido a --->
                    <p class="pOficioDirigido">
                        <strong>
                            #acd_prefijo#
                            <cfif #acd_nombres# NEQ ''> #acd_nombres#</cfif>
                            <cfif #acd_apepat# NEQ ''> #acd_apepat#</cfif>
                            <cfif #acd_apemat# NEQ ''> #acd_apemat#</cfif>
                        </strong>
                    </p>
                    <p class="pOficioDirigido">
                        #cn_descrip#
                    </p>
                    <p class="pOficioDirigido">
                        #vpDepNombre#
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
                        Comunico a usted que el Consejo Técnico de la Investigación Científica, en su sesión  
                        ordinaria del #DiaCTIC#, con fundamento en los artículos 51-B fracción III y 54-E 
                        fracciones III y IV del Estatuto General de la UNAM; 27 inciso e), 56 inciso b) y 60 del Estatuto 
                        del Personal Académico,
                        <cfif #dec_clave# IS 1>
                             evaluó y acordó <strong>aprobar</strong> su <strong>#vTextoComun#</strong>.
                            </p>
                            <cfset vEspaciosCuerpo = 9>
                        <cfelseif #dec_clave# IS 49>
                            evaluó y acordó <strong>aprobar</strong> su <strong>#vTextoComun#</strong>, con el siguiente comentario:
                            </p>
                            <p class="pOficioParrafo">
                                #comentario_texto#
                            </p>
                            <cfset vEspaciosCuerpo = 7 - (LEN(#comentario_texto#) / 90) >
                        <cfelseif #dec_clave# IS 4>
                            evaluó y ratificó el dictamen emitido por el Consejo Interno de su Entidad Académica en el sentido de
                               </p>    <cfif #comentario_clave# EQ '99'>
                                    otorgarle una evaluación negativa por no haber presentado en tiempo y forma su <strong>#vTextoComun#</strong>.
                          
                                 <p class="pOficioDirigido">
                                    Por lo anterior, se le exhorta a dar cumplimiento al Artículo 60 del Estatuto del Personal Académico de la UNAM.
                                </p>
                                <cfset vEspaciosCuerpo = 7>
                            <cfelse>
                                    <strong>no aprobar</strong> su <strong>#vTextoComun#</strong>.
                                </p>
                                <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                                <p class="pOficioParrafo">
                                    Por lo anterior, #comentario_texto#
                                </p>
                                <cfset vEspaciosCuerpo = 4 - (LEN(#comentario_texto#) / 90) >                                
                            </cfif>
                        </cfif>
                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    <p class="pOficioParrafo">
                        Sin otro particular, reciba un cordial saludo.
                    </p>
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="#vEspaciosCuerpo#">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- PIE DE PAGINA --->
                    <!--- Firma (INCLUDE PARA TODOS LOS OFICIOS --->
                        <cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_firma.cfm">
                    <!--- Pie --->
                    <cfif #dec_clave# IS 1>
                        <cfset vEspaciosPiepag = 5>
                    </cfif>
                    <cfif #dec_clave# IS 49 OR #dec_clave# IS 4>
                        <!--- Espacio --->
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        <cfset vTabuladores = 2><!--- TABULADORES PARA ALINEAR CON C.C.P. --->                        
                        <p class="pOficioPiePag">
                            C.C.P.<span style='mso-tab-count:1;'>#tbAcademicosCargosDir.acd_prefijo#
                            <cfif #tbAcademicosCargosDir.acd_nombres# NEQ ''> #tbAcademicosCargosDir.acd_nombres#</cfif>
                            <cfif #tbAcademicosCargosDir.acd_apepat# NEQ ''> #tbAcademicosCargosDir.acd_apepat#</cfif>
                            <cfif #tbAcademicosCargosDir.acd_apemat# NEQ ''> #tbAcademicosCargosDir.acd_apemat#</cfif>
                             - Director<cfif tbAcademicosCargosDir.acd_sexo EQ 'F'>a</cfif> del #vpDepNombre#
                            </span>                             
                        </p>
                        <cfset vEspaciosPiepag = 4>                        
                    </cfif>
                    <cfif #dec_clave# IS 4>
                        <p class="pOficioPiePag">
                            <span style='mso-tab-count:#vTabuladores#'>DR. CARLOS ARÁMBURO DE LA HOZ - DIRECTOR DE LA DGAPA</span>
                        </p>
                        <cfset vEspaciosPiepag = 3>
                    </cfif>
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="#vEspaciosPiepag#">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; SE REPLAZÓ nbsp; POR br EL 23/05/2019 YA QUE INCORPORABA UN CARACTER RARO EN MSWORD ---></p>
                    </cfloop>
                    <!--- Siglas de generación de oficio y número de sesión (INCLUDE PARA TODOS LOS OFICIOS --->
                        <cfset vSsnId = #vpSsnId#>
                        <cfset vpSiglasOficio = 'STC'>
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