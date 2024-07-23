<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/05/2022 --->
<!--- FECHA ÚLTIMA MOD.: 24/05/2022 --->
<!--- IMPRESION DE OFICIOS OPONENTES COA --->

<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=#vNomArchivoFecha#_oficios_CoaOponentes_#vSsnId#.doc">
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
    
<!--- Obtener los datos de la solicitud --->  
<cfquery name="tbCoaOponentes" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM consulta_solicitudes_oficiosCoaOp
	WHERE ssn_id = #vSsnId#
    ORDER BY
    asu_parte, asu_numero, acd_apepat, acd_apemat, acd_nombres    
<!---    
	ORDER BY 
	asu_parte,
	asu_numero
--->
</cfquery>

<!--- Obtener los datos de la solicitud --->
<cfquery name="ctOficios" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM catalogo_movimiento_oficios
	WHERE mov_clave = 55
    AND oficio_status = 1
</cfquery>    

<!--- Fecha la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)> 
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>
    
    
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
                        font-family:'Times New Roman';					
						tab-interval:17pt;
                    }
                    div.WordSection1
                        {page:WordSection1;}
            </style>
        </head>
        <body>
            <!--- GENERA OFICIOS --->
            <cfoutput query="tbCoaOponentes">
                <div class="WordSection1">
                    <cfset vTabuladores = 4><!--- TABULADORES PARA LOS ASUNTO SECUNDARIOS Y ALINEAR CON EL NO. DE OFICIO Y ASUNTO PRINCIPA --->
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="4">
                        <p class="pOficioEspacio"><br />
                    </cfloop>
                    <!--- ******************* ASUNTO DEL OFICIO ******************* --->

                    <!--- Número de oficio y asunto --->
                    <p class="pOficioAsunto">
                        <span style='mso-tab-count:1;' lang=ES-TRAD>
                                Oficio:
                        </span>
                        <span style='mso-tab-count:1;' lang=ES-TRAD>
                            #asu_oficio_ctic#
                        </span>
                    </p>
                    <p class="pOficioAsunto">
                        <span style='mso-tab-count:1;' lang=ES-TRAD>
                            Asunto:
                        </span>
                        <span style='mso-tab-count:1;' lang=ES-TRAD>
                            #ctOficios.oficio_asunto_1#
                        </span>
                    </p>
                    <!--- Espacio --->                    
                    <cfloop index="Espacio" from="1" to="2">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- NOMBRE DEL OPONENTE --->
                    <p class="pOficioDirigido">
                        #Trim(acd_prefijo)# #vNombre# 
                    </p>
                    <p style="width:100%; text-align: left; margin:0pt; padding:0pt;">
                        P r e s e n t e
                    </p>

                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="1">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>

                    <cfset vParrafo1 = #ctOficios.oficio_parrafo_1#>

                    <cfif #FIND('(FECHA_SESION)',ctOficios.oficio_parrafo_1)# GT 0>
                        <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_SESION)',UCASE(FechaCompleta(tbSesiones.ssn_fecha)),"ALL")#>
                    </cfif>
                    <cfif #FIND('(NO_PLAZA)',ctOficios.oficio_parrafo_1)# GT 0>
                        <cfset vParrafo1 = #Replace(vParrafo1,'(NO_PLAZA)',Ucase(sol_pos9),"ALL")#>
                    </cfif>
                    <cfif #FIND('(ENTIDAD_ADSCRIP)',ctOficios.oficio_parrafo_1)# GT 0>
                        <cfset vParrafo1 = #Replace(vParrafo1,'(ENTIDAD_ADSCRIP)',Ucase(dep_nombre),"ALL")#>
                    </cfif>

                    <cfif #FIND('(CCN_POS8)',ctOficios.oficio_parrafo_1)# GT 0>
                        <cfset vParrafo1 = #Replace(vParrafo1,'(CCN_POS8)',Ucase(cn_descrip),"ALL")#>
                    </cfif>
                    <cfif #FIND('(COA_AREA)',ctOficios.oficio_parrafo_1)# GT 0>
                        <cfset vParrafo1 = #Replace(vParrafo1,'(COA_AREA)',sol_memo1,"ALL")#>
                    </cfif>
                    <cfif #FIND('(FECHA_GACETA)',ctOficios.oficio_parrafo_1)# GT 0>
                    <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_GACETA)', FechaCompleta(sol_pos21),"ALL")#>
                    </cfif>
                    <!--- Párrafo texto 1 IMPRIME --->
                    <p class="pOficioParrafo">
                        #vParrafo1#
                    </p>
                    <!--- Espacio --->
                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        
                    <!--- ******************* PÁRRAFO 2 ******************* --->
                    <cfset vParrafo2 = #ctOficios.oficio_parrafo_2#>
                        
                    <!--- Párrafo texto 2 IMPRIME --->
                    <p class="pOficioParrafo">
                        #vParrafo2#
                    </p>
                        
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="12">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- PIE DE PAGINA --->
                    <!--- Firma (INCLUDE PARA TODOS LOS OFICIOS --->
                        <cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_firma.cfm">
                    <!--- Espacio --->
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>

                    <cfset vEspaciosPiepag = 2>
                    <!--- Pie --->
                    <p class="pOficioPiePag">
                        C.C.P. <span style='mso-tab-count:1;'>#ctOficios.oficio_ccp_1#</span>
                    </p>
                    <cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                    <p class="pOficioPiePag">
                        <span style='mso-tab-count:#vTabuladores#'>#ctOficios.oficio_ccp_2#</span>
                    </p>
                    <!--- Espacio --->
                    <cfloop index="Espacio" from="1" to="1">
                        <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                    </cfloop>
                    <!--- Siglas de generación de oficio y número de sesión (INCLUDE PARA TODOS LOS OFICIOS) --->
                    <cfset vpSiglasOficio = 'COAOP'>
                    <cfinclude template="#vCarpetaCOMUN#/impresiones/include_oficios_pie_pagina.cfm">

                    <!--- Salto de página --->				
                    <span lang=ES-TRAD style='font-size:12.0pt;mso-bidi-font-size:10.0pt;
                    line-height:90%;font-family:"Times New Roman",serif;mso-fareast-font-family:
                    "Times New Roman";mso-ansi-language:ES-TRAD;mso-fareast-language:ES-MX;
                    mso-bidi-language:AR-SA'><br clear=all style='page-break-before:always'>
                    </span>
                </div>
            </cfoutput>
        </body>
    </html>