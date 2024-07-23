<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 21/06/2017 --->
<!--- FECHA ÚLTIMA MOD.: 14/05/2024 --->
<!--- IMPRESION DE OFICIOS DE RESPUESTA v2.0 --->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
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

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vSsnId# 
    AND ssn_clave = 1
</cfquery>

<!--- Fecha la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)> 
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>

<!--- Fecha del día despues de la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>

<!--- Obtener los datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT *
	FROM consulta_solicitudes_oficios
	WHERE ssn_id = #vSsnId#
	AND asu_reunion = 'CTIC'
	AND asu_parte < 5 <!--- Excluir los asuntos de los que no se genera oficio de respuesta --->
	AND oficio_id < 55 <!--- Solo movimiento de formas telegrámicas (14/05/2024) --->
	ORDER BY 
	asu_parte,
	asu_numero
</cfquery>

<!--- Obtiene tabla de CATÁLOGO DE PLANTILLAS REGISTRADASA EN LA BASE DE DATOS --->
<cfquery name="tbCatalogoPlantillas" datasource="#vOrigenDatosPlantilla#">
	SELECT TOP 1 plantilla_archivo AS vPlantilla
    FROM catalogo_tablas_plantillas
	WHERE plantilla_status = 1
	ORDER BY catalogo_plantilla_id DESC
</cfquery>

<!--- 

NOTA IMPORTANTE: 
Incluir aquí variables <cfset> para los elementos del oficio que se utilizan comúnmente (fecha de inicio, duración, decisión, etc.),
para, de esta manera, incluir solamente el nombre de la variable.
--->


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
                <cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #sol_id#) IS TRUE>
                    <!--- Obtener la recomandación del PLENO DEL CTIC --->
                    <cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM movimientos_asunto AS T1
                        LEFT JOIN catalogo_decision AS C1 ON T1.dec_clave = C1.dec_clave
                        WHERE sol_id = #sol_id#
                        AND ssn_id = #vSsnId#
                        AND asu_reunion = 'CTIC'
                    </cfquery>
                    <!--- Obtener la categoría y nivel del movimiento --->
                    <cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM catalogo_cn
                        WHERE cn_clave = '#sol_pos8#'
                    </cfquery>
                    <!--- Obtener datos de la convocatoria para plaza y concurso desierto --->
                    <cfif #mov_clave# IS 15 OR #mov_clave# IS 16>
                        <cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
                            SELECT * FROM convocatorias_coa	
                            WHERE coa_id = '#sol_pos23#'
                        </cfquery>
                    </cfif>
                    <!--- Obtener el nombre del director --->
                    <cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM (academicos_cargos
                        LEFT JOIN academicos ON academicos_cargos.acd_id = academicos.acd_id)
                        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON academicos_cargos.dep_clave = C2.dep_clave
                        WHERE academicos_cargos.dep_clave = '#sol_pos1#' 
                        AND academicos_cargos.adm_clave = '32'
                        AND academicos_cargos.caa_fecha_inicio <= GETDATE()
                        AND academicos_cargos.caa_fecha_final >= GETDATE()
                    </cfquery>
    
                    <cfif #tbAcademicosCargos.acd_sexo# IS 'F'>
                        <cfset vDirectorTitulo = 'DIRECTORA'>
                    <cfelse>
                        <cfset vDirectorTitulo = 'DIRECTOR'>
                    </cfif>
                    <cfif #acd_sexo# EQ 'F' OR #tbAcademicosCargos.acd_sexo# IS 'F'>
						<cfif #mov_clave# EQ 22 OR #mov_clave# EQ 43 OR #mov_clave# EQ 44>
	                        <cfset vPronombre = 'de la'>
						<cfelse>
	                        <cfset vPronombre = 'a la'>
						</cfif>
                    <cfelseif #acd_sexo# EQ 'M' OR #tbAcademicosCargos.acd_sexo# IS 'F'>
						<cfif #mov_clave# EQ 22 OR #mov_clave# EQ 43 OR #mov_clave# EQ 44>
	                        <cfset vPronombre = 'del'>
						<cfelse>
	                        <cfset vPronombre = 'al'>
						</cfif>
                    </cfif>

                    <cfif #mov_clave# EQ 21 OR #mov_clave# EQ 23 OR #mov_clave# EQ 30>
                        <cfif #sol_pos13# EQ 'A'>
                            <cfset vPeridoSabatico = 'AÑO'>
                        <cfelseif #sol_pos13# EQ 'S'>
                            <cfset vPeridoSabatico = 'SEMESTRE'>
                        </cfif>
                    <cfelseif #mov_clave# EQ 22>
						<cfif #sol_pos10# EQ 3>
							<cfset vPeridoSabatico = 'AÑO'>
						<cfelse>
							<cfif DATEDIFF('d',#sol_pos14#, #sol_pos15#) GT 360>
								<cfset vPeridoSabatico = 'AÑO'>
							<cfelseif DATEDIFF('d',#sol_pos14#, #sol_pos15#) LT 360>
								<cfset vPeridoSabatico = 'SEMESTRE'>
							</cfif>
						</cfif>                        
                    </cfif>

                    <cfif #mov_clave# EQ 4>
						<cfif #sol_pos12# EQ 'PRORROGA'>
							<cfset vTipoComision = #oficio_asunto_2#>
                        <cfelse>
                            <cfset vTipoComision = #oficio_asunto_1#>
                        </cfif>
					</cfif>
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
                            <span style='mso-tab-count:1;' lang=ES-TRAD>
								    Oficio:
                            </span>
                            <span style='mso-tab-count:1;' lang=ES-TRAD>
								#asu_oficio#
							</span>
                        </p>
                        <p class="pOficioAsunto">
                            <span style='mso-tab-count:1;' lang=ES-TRAD>
                            	<cfif #mov_clave# NEQ 44>
									Asunto:
								</cfif>
                            </span>
                            <span style='mso-tab-count:1;' lang=ES-TRAD>
								<cfif #oficio_asunto_1# NEQ ''>
                                    <cfif #mov_clave# EQ 21 OR #mov_clave# EQ 23 OR #mov_clave# EQ 30>
										#UCASE(Replace(oficio_asunto_1,'(PERIODO_SABATICO)',vPeridoSabatico,"ALL"))#
                                    <cfelseif #mov_clave# EQ 4><!--- FT-04 --->
										#vTipoComision#
                                    <cfelse>
										#oficio_asunto_1#
                                    </cfif>
                                <cfelse>
									FT-CTIC-#mov_clave#
                                </cfif>
							</span>
                        </p>
                        <cfif #oficio_asunto_2# NEQ '' AND #mov_clave# NEQ 4>
                            <p class="pOficioAsunto">
								<span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>                            
									<cfif #mov_clave# EQ 21 OR #mov_clave# EQ 23 OR #mov_clave# EQ 30>
                                        #UCase(oficio_asunto_2)#
                                    <cfelse>
                                        #oficio_asunto_2#
									</cfif>
								</span>
                            </p>
                        </cfif>
                        <cfset vEspaciosEncabezado = 4>
                        <cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3>
                            <p class="pOficioAsunto">
								<!--- <span style='mso-tab-count:1' lang=ES-TRAD>Subprograma de Incorporaci&oacute;n de J&oacute;venes Acad&eacute;micos de Carrera a la UNAM</span> --->
                                <span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>Subprograma de Incorporaci&oacute;n</span>
                            </p>
                            <p class="pOficioAsunto">
                                <span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>de J&oacute;venes Acad&eacute;micos de</span>
                            </p>
                            <p class="pOficioAsunto">
                                <span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>Carrera a la UNAM</span>                                
                            </p>
                            <cfset vEspaciosEncabezado = #vEspaciosEncabezado# - 2>
						</cfif>
                        <cfif #mov_clave# EQ 5 OR #mov_clave# EQ 6><!--- (#mov_clave# EQ 6 AND #sol_pos12# EQ 3 AND #sol_pos17# GT 0)--->
                            <p class="pOficioAsunto">
                                <span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>Plaza número #sol_pos9#</span> 
                            </p>
                            <cfset vEspaciosEncabezado = #vEspaciosEncabezado# - 1>
                            <cfif #mov_clave# EQ 6 AND #sol_pos12# EQ 3 AND #sol_pos17# GT 0>
								<cfquery name="tbPlantillas" datasource="#vOrigenDatosPlantilla#">
									SELECT cp FROM #tbCatalogoPlantillas.vPlantilla#
                                    WHERE plaza + '-' + plaza_cv = '#sol_pos9#'
								</cfquery>
                                <p class="pOficioAsunto">
                                    <span style='mso-tab-count:#vTabuladores#;' lang=ES-TRAD>#tbPlantillas.cp#</span> 
                                </p>
                                <cfset vEspaciosEncabezado = #vEspaciosEncabezado# - 1>
                            </cfif>
                        <cfelse>
                            <cfset vEspaciosEncabezado = 3>
                        </cfif>
                        <!--- Espacio --->
                        <cfloop index="Espacio" from="1" to="#vEspaciosEncabezado#">
                            <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        </cfloop>
                        <!--- Dirigido a --->
                        <cfif (#mov_clave# EQ 15 OR #mov_clave# EQ 16 OR #mov_clave# EQ 38 OR #mov_clave# EQ 39 OR #mov_clave# EQ 43 OR #mov_clave# EQ 44)>
                            <!--- DIRECTOR DE LA ENTIDAD --->
                            <p class="pOficioDirigido">
                               #Trim(tbAcademicosCargos.acd_prefijo)# #Trim(tbAcademicosCargos.acd_nombres)# #Trim(tbAcademicosCargos.acd_apepat)# #Trim(tbAcademicosCargos.acd_apemat)#
                            </p>
                            <p class="pOficioDirigido">
                                #vDirectorTitulo# DEL #Ucase(dep_nombre)#
                            </p>
                        <cfelse>
                            <!--- ACADÉMICO --->
                            <p class="pOficioDirigido">
                                #Trim(acd_prefijo)# #vNombre# 
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
							<cfelse>
								<p class="pOficioDirigido">
									#Ucase(dep_nombre)#
								</p>
							</cfif>
                        </cfif>
                        <p style="width:100%; text-align: left; margin:0pt; padding:0pt;">
                            P r e s e n t e
                        </p>
                        <!--- Espacio --->
                        <cfloop index="Espacio" from="1" to="2">
                            <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                        </cfloop>
    
                        <!--- CUERPO DE OFICIO --->
                        <cfset vEspaciosCuerpo = 9>
    
                        <!--- ******************* PÁRRAFO 1 ******************* --->
                            <cfset vParrafo1 = #oficio_parrafo_1#>
        
                            <cfif #FIND('(FECHA_SESION)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_SESION)',UCASE(FechaCompleta(tbSesiones.ssn_fecha)),"ALL")#>
                            </cfif>
                            <cfif #FIND('(DIRECTOR_TITULO)',oficio_parrafo_1)# GT 0>
								<cfset vParrafoDir = '#vPronombre# #vDirectorTitulo#'>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(DIRECTOR_TITULO)', vParrafoDir,"ALL")#>
                            </cfif>
                            <cfif #FIND('(DECISION)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(DECISION)',Ucase(tbAsuntosCTIC.dec_descrip),"ALL")#>
                            </cfif>
                            <cfif #FIND('(DECISION_MIN)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(DECISION_MIN)',Ucase(tbAsuntosCTIC.dec_descrip),"ALL")#>
                            </cfif>
                            <cfif #FIND('(PERIODO_SABATICO)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(PERIODO_SABATICO)',Ucase(vPeridoSabatico),"ALL")#>                        
                            </cfif>
                            <cfif #FIND('(FECHA_INICIO)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_INICIO)',Ucase(FechaCompleta(sol_pos14)),"ALL")#>
                            </cfif>
                            <cfif #FIND('(FECHA_TERMINO)',oficio_parrafo_1)# GT 0>
                               	<cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_TERMINO)',Ucase(FechaCompleta(sol_pos15)),"ALL")#>
                            </cfif>
                            <cfif #FIND('(NO_PLAZA)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(NO_PLAZA)',Ucase(sol_pos9),"ALL")#>
                            </cfif>
                            <cfif #FIND('(NOMBRE_ACAD)',oficio_parrafo_1)# GT 0>
                                <cfset vTextoRepNombre = '#vPronombre# #acd_prefijo# #vNombre#'>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(NOMBRE_ACAD)',vTextoRepNombre,"ALL")#>
                            </cfif>
                            <cfif #FIND('(CCN_POS3)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(CCN_POS3)',Ucase(cn_descrip),"ALL")#>
                            </cfif>
                            <cfif #FIND('(CCN_POS8)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(CCN_POS8)',Ucase(ctCategoria.cn_descrip),"ALL")#>
                            </cfif>
                            <cfif #FIND('(OBJETO)',oficio_parrafo_1)# GT 0>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(OBJETO)',Ucase(sol_sintesis),"ALL")#>
                            </cfif>
                            
                            <cfif #mov_clave# EQ 22 AND #sol_pos10# EQ 3>
								<cfset vFechaCargoNomb = 'EL TERMINO DE SU NOMBRAMIENTO COMO #sol_pos12#'>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_TERMINO_CARGO_NOMBRA)',Ucase(vFechaCargoNomb),"ALL")#>
							<cfelse>
                                <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_TERMINO_CARGO_NOMBRA)',Ucase(FechaCompleta(sol_pos15)),"ALL")#>
                            </cfif>
                            
                            <cfif #FIND('(TIPO_BECA)',oficio_parrafo_1)# GT 0>
                                <cfif #mov_clave# EQ 38>
                                    <cfif #tbAsuntosCTIC.dec_super# EQ 'AP' OR #tbAsuntosCTIC.dec_super# EQ 'CO'>
                                        <cfset vParrafo1 = #Replace(vParrafo1,'(TIPO_BECA)','otorgar',"ALL")#>
                                    <cfelseif #tbAsuntosCTIC.dec_super# EQ 'NA'>
                                        <cfset vParrafo1 = #Replace(vParrafo1,'(TIPO_BECA)','NO APROBAR',"ALL")#>
                                    </cfif>
                                <cfelseif #mov_clave# EQ 39>
                                    <cfif #tbAsuntosCTIC.dec_super# EQ 'AP'>                            
                                        <cfset vParrafo1 = #Replace(vParrafo1,'(TIPO_BECA)','renovar',"ALL")#>
                                    <cfelseif #tbAsuntosCTIC.dec_super# EQ 'NA'>
                                        <cfset vParrafo1 = #Replace(vParrafo1,'(TIPO_BECA)','NO RENOVAR',"ALL")#>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif #FIND('(PRONOMBRE)',oficio_parrafo_1)# GT 0>
								<cfset vParrafo1 = #Replace(vParrafo1,'(PRONOMBRE)',vPronombre,"ALL")#>
                            </cfif>

                            <cfif #FIND('(FECHA_GACETA)',oficio_parrafo_1)# GT 0>
								<cfif #mov_clave# EQ 38>                            
									<!--- Obtene la fecha de publicación de la última convocatotria de becas posdoctorales UNAM (SE COMENTÓ A EMMANUEL LA FECHA DE LA CONVOCATORIA DEBE SER REFERENCIA A EL AÑO QUE ENTRÓ EL BECARIO) --->
                                    <cfquery name="tbConvocatorias" datasource="#vOrigenDatosPOSDOC#">
                                        SELECT convoca_bp_publica_gaceta 
                                        FROM convocatorias AS T1 
                                        LEFT JOIN convocatorias_periodos AS T2 ON T1.convoca_bp_anio = T2.convoca_bp_anio
                                        WHERE '#sol_pos14#' BETWEEN T2.fecha_inicio_periodo AND T2.fecha_final_periodo
                                        ORDER BY T1.convoca_bp_anio DESC
                                    </cfquery>
                                    
                                    <cfset vFechaConvocatoriaPosdoc = LCase(FechaCompleta(tbConvocatorias.convoca_bp_publica_gaceta))>
                                
                                    <cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_GACETA)',vFechaConvocatoriaPosdoc,"ALL")#>
								<cfelseif #mov_clave# EQ 15 OR #mov_clave# EQ 16  OR #mov_clave# EQ 99>
                                	<!---  FECHA DE GACETA PARA PLAZA DESIETA, CONCURSO DESIERTO --->
									<cfset vFechaGaceta = LCase(#FechaCompleta(sol_pos21)#)>                                
									<cfset vParrafo1 = #Replace(vParrafo1,'(FECHA_GACETA)',vFechaGaceta,"ALL")#>                                
								</cfif>
    						</cfif>

                            <cfif #FIND('(COA_AREA)',oficio_parrafo_1)# GT 0>
                                	<!---  ÁREA PARA PLAZA DESIETA, CONCURSO DESIERTO --->
								<cfset vParrafo1 = #Replace(vParrafo1,'(COA_AREA)',sol_memo1,"ALL")#>
                            </cfif>

                            <cfif #FIND('(ARTICULOS_EPA)',oficio_parrafo_1)# GT 0>
								<cfif #mov_clave# EQ 7 OR #mov_clave# EQ 9>
									<cfset vArtEpa = 'el ARTICULO 19'>
								<cfelseif #mov_clave# EQ 8 OR #mov_clave# EQ 10>
									<cfset vArtEpa = 'los ARTICULOS 66, 78 Y 79'>
								</cfif>
								<cfset vParrafo1 = #Replace(vParrafo1,'(ARTICULOS_EPA)',vArtEpa,"ALL")#>
                            </cfif>
                            
							<!--- SOLO PARA FT-CTIC-11 LICENCIA SIN GOCE DE SUELDO --->
                            <cfif #FIND('(INCISO)',oficio_parrafo_1)# GT 0>
								<cfif #sol_pos20# EQ 1>
                                	<cfset vInciso = 'G)'>
								<cfelse>
                                	<cfset vInciso = 'E)'>
								</cfif>                                
                                <cfset vParrafo1 = #Replace(vParrafo1,'(INCISO)',vInciso,"ALL")#>                        
                            </cfif>                            

                            <!--- Párrafo texto 1 IMPRIME --->
                            <p class="pOficioParrafo">
                                #vParrafo1#
                            </p>
    <!---                        
                            <cfif #CGI.SERVER_PORT# IS '31221'>
                                TAMAÑO PARRAFO: #LEN(vParrafo1)# - LINEAS: #LEN(vParrafo1) / 75#
                            </cfif>
    --->						
                        <!--- NOMBRE DEL BECARIO POSDOCTORAL --->
                            <cfif #mov_clave# EQ 38 OR #mov_clave# EQ 39>
                                <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                                <p class="pOficioParrafo">
                                    #Trim(acd_prefijo)# #vNombre#
                                </p>
                            </cfif>
                        <!--- Espacio --->
                            <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
    
                        <!--- ******************* PÁRRAFO 2 ******************* --->
                            <cfset vParrafo2 = #oficio_parrafo_2#>
    
                            <cfif #FIND('(DECISION)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(DECISION)',Ucase(tbAsuntosCTIC.dec_descrip),"ALL")#>
                            </cfif>
    
                            <cfif #FIND('(TIEMPO)',oficio_parrafo_2)# GT 0>
                                <cfset vTiempo = ''>
                                <cfif #sol_pos13_a# EQ 1><cfset vTiempo = '1 AÑO'></cfif>
                                <cfif #sol_pos13_m# EQ 1>
									<cfset vTiempo = '#vTiempo# 1 MES'>
								<cfelseif #sol_pos13_m# GT 1>
									<cfset vTiempo = '#vTiempo# #sol_pos13_m# MESES'>
								</cfif>
								<cfif #sol_pos13_m# GT 0 AND #sol_pos13_d# GT 0><cfset vTiempo = '#vTiempo#,'></cfif>
                                <cfif #sol_pos13_d# EQ 1>
									<cfset vTiempo = '#vTiempo# 1 DIA'>
								<cfelseif #sol_pos13_d# GT 1>
									<cfset vTiempo = '#vTiempo# #sol_pos13_d# DIAS'>
								</cfif>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(TIEMPO)',Ucase(vTiempo),"ALL")#>
                            </cfif>

                            <cfif #FIND('(PERIODO_SABATICO)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(PERIODO_SABATICO)',UCase(vPeridoSabatico),"ALL")#>
                            </cfif>

                            <cfif #FIND('(TIPO_COMISION)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(TIPO_COMISION)',LCase(vTipoComision),"ALL")#>
                                <!--- COMISIÓN/PRORROGA PORCENTAJE GOCE DE SUELDO --->
                                <cfif #mov_clave# EQ 4 AND #sol_pos17# GT 0>
									<cfset vParrafo2 = #Replace(vParrafo2,'(PORCENTAJE)', 'con #sol_pos17#% de sueldo',"ALL")#>
								<cfelse>
									<cfset vParrafo2 = #Replace(vParrafo2,'(PORCENTAJE)',' ',"ALL")#>                                
								</cfif>
                            </cfif>

                            <cfif #FIND('(FECHA_INICIO)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(FECHA_INICIO)',Ucase(FechaCompleta(sol_pos14)),"ALL")#>
                            </cfif>
							<!--- PRORROGA DE COMISIÓN FT-CTIC-3 Y PROGRAMA PASPA DGAPA --->
							<cfif #mov_clave# EQ 3>
								<cfif #sol_pos20# EQ '1'>
									<cfset vPaspaTexto = ' Y RECOMENDAR SE LE OTORGUE EL APOYO DEL PROGRAMA PASPA DE LA DGAPA'>
								<cfelse>
									<cfset vPaspaTexto = ''>
								</cfif>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(PASPA)',vPaspaTexto,"ALL")#>                                
							</cfif>

                            <cfif #FIND('(CCN_POS3)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(CCN_POS3)',Ucase(cn_descrip),"ALL")#>
								<cfif #mov_clave# EQ 7 OR #mov_clave# EQ 8>
									<cfset vParrafo2 = #Replace(vParrafo2,'ASOCIADO ','',"ALL")#>
									<cfset vParrafo2 = #Replace(vParrafo2,'TITULAR ','',"ALL")#>
									<cfset vParrafo2 = #Replace(vParrafo2,"'A' ",'',"ALL")#>
									<cfset vParrafo2 = #Replace(vParrafo2,"'B' ",'',"ALL")#>
									<cfset vParrafo2 = #Replace(vParrafo2,"'C' ",'',"ALL")#>
								</cfif>                                
                            </cfif>

                            <cfif #FIND('(CCN_POS8)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(CCN_POS8)',Ucase(ctCategoria.cn_descrip),"ALL")#>
                            </cfif>

                            <cfif #FIND('(NOMBRE_ACAD)',oficio_parrafo_2)# GT 0>
                                <cfif #mov_clave# EQ 44>
                                    <cfif #acd_sexo# EQ 'F'>
                                        <cfset vPronombre = 'a la '>
                                    <cfelseif #acd_sexo# EQ 'M'>
                                        <cfset vPronombre = 'al '>
                                    </cfif>
                                <cfelseif #mov_clave# EQ 38 OR #mov_clave# EQ 39>
                                    <cfif #acd_sexo# EQ 'F'>
                                        <cfset vPronombre = 'de la '>
                                    <cfelseif #acd_sexo# EQ 'M'>
                                        <cfset vPronombre = 'del '>
                                    </cfif>
                                <cfelse>
                                    <cfset vPronombre = ''>
                                </cfif>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(NOMBRE_ACAD)','#vPronombre##acd_prefijo# #vNombre#',"ALL")#>
                            </cfif>

                            <cfif #FIND('(OBJETO)',oficio_parrafo_2)# GT 0 OR #FIND('(PROYECTO)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(OBJETO)',Ucase(sol_sintesis),"ALL")#>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(PROYECTO)',Ucase(sol_sintesis),"ALL")#>                            
                            </cfif>

                            <cfif #FIND('(FECHA_POSTERIOR_SESION)',oficio_parrafo_2)# GT 0>
                                <cfset vParrafo2 = #Replace(vParrafo2,'(FECHA_POSTERIOR_SESION)',LCase(FechaCompleta(tbSesiones.ssn_fecha + 1)),"ALL")#>
                            </cfif>

							<!--- SOLO PARA FT-CTIC-43 INFORME ANUAL DE BECA POSDOCTORAL --->
                            <cfif #FIND('(PERIODO_BECA)',oficio_parrafo_2)# GT 0>
								<cfif #LsDateFormat(sol_pos14,'yyyy')# EQ #LsDateFormat(sol_pos15,'yyyy')#>
									<cfset vPeriodoBeca = #lsDateFormat(sol_pos14,'mmmm')# & ' - ' & #lsDateFormat(sol_pos15,'mmmm yyyy')#>
								<cfelse>
									<cfset vPeriodoBeca = #lsDateFormat(sol_pos14,'mmmm yyyy')# & ' - ' & #lsDateFormat(sol_pos15,'mmmm yyyy')#>
								</cfif>
                                
                                <cfset vParrafo2 = #Replace(vParrafo2,'(PERIODO_BECA)',Ucase(vPeriodoBeca),"ALL")#>
                            </cfif>
							<!--- SOLO PARA FT-CTIC-1 CÁTEDRAS, TRABAJOS Y ASESORÍAS --->
							<cfif mov_clave EQ 1>

                            	<cfif #sol_pos12# EQ '32'><cfset vTipoActividad = 'CATEDRA'>
                                <cfelseif #sol_pos12# EQ '29'><cfset vTipoActividad = 'TRABAJO'>
                                <cfelseif #sol_pos12# EQ '1'><cfset vTipoActividad = 'ASESORIA'>
								</cfif>

								<cfset vParrafo2 = #Replace(vParrafo2,'(NO_HORAS)',LsNumberFormat(sol_pos16,'99'),"ALL")#>
								<cfset vParrafo2 = #Replace(vParrafo2,'(TIPO_ACTIVIDAD)',vTipoActividad,"ALL")#>
							</cfif>
    
   							<!--- SOLO PARA FT-CTIC-13 y 29 CAMBIOS DE ADSCRIPCIÓN O UBICACIÓN --->
                            <cfif #mov_clave# EQ 13 OR #mov_clave# EQ 29>
                                <!--- Obtener la dependencia del movimiento --->
                                <cfquery name="ctEntidadDestino" datasource="#vOrigenDatosCATALOGOS#">
                                    SELECT dep_nombre FROM catalogo_dependencias
                                    WHERE dep_clave = '#sol_pos11#'
                                </cfquery>

                                <!--- Obtener la ubicación de la dependencia del movimiento --->
                                <cfquery name="ctEntidadUbicaDestino" datasource="#vOrigenDatosCATALOGOS#">
                                    SELECT IF(ubica_siglas = 'CU', ubica_lugar, ubica_nombre) AS ubica_nombre 
                                    FROM catalogo_dependencias_ubica
									WHERE dep_clave = <cfif #mov_clave# EQ 13>'#sol_pos11#'<cfelseif #mov_clave# EQ 29>'#sol_pos1#'</cfif>
									AND ubica_clave = '#sol_pos11_u#'
                                </cfquery>

                                <cfif #FIND('(TIPO_CAMBIO)',oficio_parrafo_2)# GT 0>
                                    <cfif #sol_pos10# EQ 1>
                                        <cfset vParrafo2 = #Replace(vParrafo2,'(TIPO_CAMBIO)','DEFINITIVO',"ALL")#>
                                    <cfelseif #sol_pos10# EQ 2>
                                        <cfset vParrafo2 = #Replace(vParrafo2,'(TIPO_CAMBIO)','TEMPORAL',"ALL")#>
                                    </cfif>
                                </cfif>

                                <cfif #FIND('(ENTIDAD_ADSCRIP)',oficio_parrafo_2)# GT 0>
                                    <cfset vParrafo2 = #Replace(vParrafo2,'(ENTIDAD_ADSCRIP)',Ucase(dep_nombre),"ALL")#>
                                </cfif>

                                <cfif #FIND('(UBICA_ADSCRIP)',oficio_parrafo_2)# GT 0>
                                    <cfset vParrafo2 = #Replace(vParrafo2,'(UBICA_ADSCRIP)',Ucase(ubica_nombre),"ALL")#>
                                </cfif>

                                <cfif #FIND('(ENTIDAD_DESTINO)',oficio_parrafo_2)# GT 0>
                                    <cfset vParrafo2 = #Replace(vParrafo2,'(ENTIDAD_DESTINO)', ctEntidadDestino.dep_nombre,"ALL")#>
                                </cfif>

                                <cfif #FIND('(UBICA_DESTINO)',oficio_parrafo_2)# GT 0>
                                    <cfset vParrafo2 = #Replace(vParrafo2,'(UBICA_DESTINO)',ctEntidadUbicaDestino.ubica_nombre,"ALL")#>
                                </cfif>
                            </cfif>
                            
   							<!--- SOLO PARA FT-CTIC-44 CÁTEDRAS CONACyT --->
                            <cfif #mov_clave# EQ 38 OR #mov_clave# EQ 39 OR #mov_clave# EQ 44>
                                <!--- Obtener el nombre del director --->
                                <cfquery name="tbAcademicosResp" datasource="#vOrigenDatosSAMAA#">
                                    SELECT *, 
                                        ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                                        CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END + 
                                        ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                                        CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
                                        ISNULL(dbo.SINACENTOS(acd_apemat),'') AS vNombre                                
                                    FROM academicos
                                    WHERE acd_id = '#sol_pos12#' 
                                </cfquery>
                                <cfif #tbAcademicosResp.acd_sexo# EQ 'F'>
                                    <cfset vAcadResp = 'la #tbAcademicosResp.acd_prefijo# #tbAcademicosResp.vNombre#'>
                                <cfelseif #tbAcademicosResp.acd_sexo# EQ 'M'>
                                    <cfset vAcadResp = 'el #tbAcademicosResp.acd_prefijo# #tbAcademicosResp.vNombre#'>
                                </cfif>
                                <!--- <cfset vTextoRepNombre = '#vPronombre# #tbAcademicosResp.acd_prefijo# #tbAcademicosResp.vNombre#'> --->
                                <cfset vParrafo2 = #Replace(vParrafo2,'(NOMBRE_RESP)', vAcadResp,"ALL")#>
                            </cfif>
                            
                        <!--- Párrafo texto 2 IMPRIME --->
                            <cfif #mov_clave# NEQ 38 OR (#mov_clave# EQ 38 AND (#tbAsuntosCTIC.dec_super# EQ 'AP' OR #tbAsuntosCTIC.dec_super# EQ 'CO'))>
                                <p class="pOficioParrafo">
                                    #vParrafo2#
                                </p>
                            <cfelse>
                                <cfloop index="Espacio" from="1" to="3">
                                    <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
                                </cfloop>
                            </cfif>
    <!---                    
                        <cfif #CGI.SERVER_PORT# IS '31221'>
                            TAMAÑO PARRAFO: #LEN(vParrafo2)# - LINEAS: #LEN(vParrafo2) / 75#
                        </cfif>
    --->

                        <!--- ******************* PÁRRAFO 3 ******************* --->
							<cfset vParrafo3 = ''>

							<cfif #LEN(oficio_parrafo_3)# GT 0>
	                            <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>                            
								<cfset vParrafo3 = '#oficio_parrafo_3#'>
                                <cfif (#mov_clave# EQ 38 AND #tbAsuntosCTIC.dec_super# EQ 'AP') OR #mov_clave# EQ 44>
									<cfset vParrafo3 = #oficio_parrafo_3#>
								<cfelseif (#mov_clave# EQ 9 OR #mov_clave# EQ 10) AND #con_clave# EQ 2>
                                	<!--- VERIFICA QUE HAYA SOLICITUD DE DEFINITIVIDAD, EN CASO DE HABER NO IMRIME EL PARRAFO_3 --->
									<cfquery name="tbSolicitudDef" datasource="#vOrigenDatosSAMAA#">
										SELECT COUNT(*) as vCuenta
										FROM movimientos_solicitud AS T1
										LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CTIC'
										WHERE T2.ssn_id = #vSsnId#
										AND T2.asu_reunion = 'CTIC'
										AND T1.sol_pos2 = #acd_id#
										AND (T1.mov_clave = 7 OR T1.mov_clave = 8)
									</cfquery>
									<cfif #tbSolicitudDef.vCuenta# EQ 0>
										<cfif #FIND('(TIEMPO)',oficio_parrafo_3)# GT 0>
											<cfset vTiempo = ''>
											<cfif #sol_pos13_a# EQ 1><cfset vTiempo = '1 AÑO'></cfif>
											<cfif #sol_pos13_m# EQ 1>
												<cfset vTiempo = '#vTiempo# 1 MES'>
											<cfelseif #sol_pos13_m# GT 1>
												<cfset vTiempo = '#vTiempo# #sol_pos13_m# MESES'>
											</cfif>
											<cfif #sol_pos13_m# GT 0 AND #sol_pos13_d# GT 0><cfset vTiempo = '#vTiempo#,'></cfif>
											<cfif #sol_pos13_d# EQ 1>
												<cfset vTiempo = '#vTiempo# 1 DIA'>
											<cfelseif #sol_pos13_d# GT 1>
												<cfset vTiempo = '#vTiempo# #sol_pos13_d# DIAS'>
											</cfif>
											<cfset vParrafo3 = #Replace(vParrafo3,'(TIEMPO)',vTiempo,"ALL")#>
										</cfif>
										<cfif #FIND('(FECHA_INICIO)',oficio_parrafo_3)# GT 0>
											<cfset vParrafo3 = #Replace(vParrafo3,'(FECHA_INICIO)',Ucase(FechaCompleta(sol_pos14)),"ALL")#>
										</cfif>
									<cfelse>
										<cfset vParrafo3 = ''>
									</cfif>
								<cfelseif #mov_clave# EQ 6 AND #sol_pos17# EQ 0>
                                	<!--- AGREGA EN EL OFICIO EL AREA DE ADSCRIPCIÓN DE LA PLAZA EN EL PARRAFO_3 (SE TOMA LA INFORMACION DEL SISTEMA DE PLAZAS DE NUEVA CREACIÓN 16/06/2022)--->
									<cfquery name="tbPlazaNuevas" datasource="#vOrigenDatosPLAZASN#">
										SELECT TOP 1 adscripcion_dgpo
										FROM plazas_nuevas
                                        WHERE plaza_numero = '##'
                                        ORDER BY fecha_crea DESC
									</cfquery>
                                    <cfif #tbPlazaNuevas.adscripcion_dgpo# NEQ ''>
									    <cfset vParrafo3 = #Replace(vParrafo3,'(PLAZA_AREA)',tbPlazaNuevas.adscripcion_dgpo,"ALL")#>
                                    <cfelse>
									    <cfset vParrafo3 = ''>                                        
                                    </cfif>
								<cfelseif (#mov_clave# EQ 9 OR #mov_clave# EQ 10) AND #con_clave# EQ 1>
									<cfset vParrafo3 = ''>
								</cfif>

		                        <!--- Párrafo texto 3 IMPRIME --->
								<cfif #LEN(vParrafo3)# GT 0>
                                    <p class="pOficioParrafo">
                                        #vParrafo3#
                                    </p>
								</cfif>
                            </cfif>
    
                        <cfset vCuentaEspaciosParrafos =  (#LEN(vParrafo1)# + #LEN(vParrafo2)# + #LEN(#vParrafo3#)# + 2) / 70> 
						<!--- LINEAS:  #vCuentaEspaciosParrafos# - #INT(vCuentaEspaciosParrafos)# --->

                        <cfif #vCuentaEspaciosParrafos# LTE 1>
                            <cfset vEspaciosParrafo = 8>
                        <cfelseif #vCuentaEspaciosParrafos# GT 1 AND #vCuentaEspaciosParrafos# LTE 3>
                            <cfset vEspaciosParrafo = 7>
                        <cfelseif #vCuentaEspaciosParrafos# GT 3 AND #vCuentaEspaciosParrafos# LTE 5>
                            <cfset vEspaciosParrafo = 6>
                        <cfelseif #vCuentaEspaciosParrafos# GT 5 AND #vCuentaEspaciosParrafos# LTE 7>
                            <cfset vEspaciosParrafo = 5>
                        <cfelseif #vCuentaEspaciosParrafos# GT 7 AND #vCuentaEspaciosParrafos# LTE 9>
                            <cfset vEspaciosParrafo = 4>
                        <cfelseif #vCuentaEspaciosParrafos# GT 9 AND #vCuentaEspaciosParrafos# LTE 11>
                            <cfset vEspaciosParrafo = 3>
                        <cfelseif #vCuentaEspaciosParrafos# GT 11 AND #vCuentaEspaciosParrafos# LTE 13>
                            <cfset vEspaciosParrafo = 2>
                        <cfelseif #vCuentaEspaciosParrafos# GTE 13>
                            <cfset vEspaciosParrafo = 1>
						<cfelse>
                            <cfset vEspaciosParrafo = 1>                        
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
                            <cfset vEspaciosPiepag = 6>
	                        <cfset vTabuladores = 2><!--- TABULADORES PARA ALINEAR CON C.C.P. --->
							<cfif #mov_clave# NEQ 44>
								<p class="pOficioPiePag">
                                    C.C.P. 
                                    <span style='mso-tab-count:1;'>
                                        <!--- A SOLICITUD DE NICOL SE HIZO ESTA ACTUALIZACIÓN 27/01/2021 --->
                                        <cfif #dep_siglas# EQ 'CIC'>
                                            SECRETARIO DE INVESTIGACION Y DESARROLLO DE LA COORDINACION DE LA INVESTIGACION CIENTIFICA
                                        <cfelse>
                                            #Replace(oficio_ccp_1,'(DIRECTOR_TITULO)',vDirectorTitulo,"ALL")#
                                        </cfif>
                                    </span>                                        
                                </p>
								<cfif #LEN(oficio_ccp_2)# GT 0>
                                    <cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                                    <p class="pOficioPiePag"><span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_2#</span></p>
								</cfif>
								<cfif #LEN(oficio_ccp_3)# GT 0>
                                    <cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                                    <p class="pOficioPiePag"><span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_3#</span></p>
								</cfif>
								<cfif #LEN(oficio_ccp_4)# GT 0>
									<cfif #mov_clave# NEQ 6 OR (#mov_clave# EQ 6 AND #sol_pos12# EQ '')><!---  OR (#mov_clave# EQ 6 AND #sol_pos12# EQ 3 AND #sol_pos17# GT 0) --->
										<cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                                        <p class="pOficioPiePag"><span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_4#</span></p>
									</cfif>
								</cfif>
								<cfif #LEN(oficio_ccp_5)# GT 0>
									<cfif #mov_clave# NEQ 6 OR (#mov_clave# EQ 6 AND #sol_pos12# EQ 3)>
										<cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                                        <p class="pOficioPiePag"><span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_5#</span></p>
									</cfif>
								</cfif>
								<cfif #LEN(oficio_ccp_6)# GT 0>
                                    <cfset vEspaciosPiepag = #vEspaciosPiepag# - 1>
                                    <p class="pOficioPiePag"><span style='mso-tab-count:#vTabuladores#'>#oficio_ccp_6#</span><br /></p>
								</cfif>
							</cfif>
                        <!--- Espacio --->
                            <cfloop index="Espacio" from="1" to="#vEspaciosPiepag#">
                                <p class="pOficioEspacio"><br /><!--- &nbsp; ---></p>
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
