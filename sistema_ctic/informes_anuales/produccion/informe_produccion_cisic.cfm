<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 01/04/2022 --->
<!--- FECHA ÚLTIMA MOD.: 01/04/2022 --->

<cfparam name="vAnioInicio" default="2010">
<cfparam name="vAnioFinal" default="#Session.InformesFiltro.vInformeAnio#">
<cfparam name="vpDepClave" default="0">
<cfparam name="vpDecClaveCi" default="0">

<cfif #vAnioInicio# EQ '2010'>
	<cfif #vAnioFinal# EQ '2010'>
		<cfset vAniosDivide = (2010 - 2006) + 1>
	<cfelse>
		<cfset vAniosDivide = (#vAnioFinal# - 2006) + 1>
	</cfif>	
<cfelse>
	<cfset vAniosDivide =  (#vAnioFinal# - #vAnioInicio#) + 1>
</cfif>

<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
    SELECT
    T1.informe_anual_id, T1.informe_anio, T1.comentario_texto_ci,
    T2.acd_id, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres, T2.acd_fecha_nac,
    C2.cn_siglas_nom,
    C1.dep_siglas
    FROM movimientos_informes_anuales AS T1
    LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
    LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C1 ON T1.dep_clave = C1.dep_clave
    LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C2 ON T1.cn_clave = C2.cn_clave
    WHERE T1.informe_anio = #Session.InformesFiltro.vInformeAnio#
    AND T1.dec_clave_ci = #vpDecClaveCi#
    AND C2.cn_clase = 'INV'
    AND T1.informe_status = 1
    ORDER BY C1.dep_siglas, T2.acd_apepat, T2.acd_apemat, T2.acd_nombres
</cfquery>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Investigadores Números</title>
</head>
    
    <body>
        <blockquote>&nbsp;</blockquote>
        <table width="100%">
            <tr>
            	<cfoutput>
					<td colspan="23">RELACI&Oacute;N DE INVESTIGADORES <cfif #vAnioInicio# EQ #vAnioFinal#>DEL #vAnioFinal#<cfelse>DE <cfif #vAnioInicio# EQ 2010>2006-2010<cfelse>#vAnioInicio#</cfif> AL #vAnioFinal#</cfif></td>
				</cfoutput>
            </tr>
            <tr>
                <td colspan="12"><cfif #vpDecClaveCi# EQ 4>NO APROBADOS<cfelseif #vpDecClaveCi# EQ 49>APROBADOS (COMENTARIOS)</cfif></td>
                <td colspan="13">Total durante el periodo</td>
				<cfloop index="vAnio" from="#vAnioInicio#" to="#vAnioFinal#">
	                <td colspan="11">
						<cfif #vAnio# GT 2010>
                            <cfoutput>#vAnio#</cfoutput>
                        <cfelse>
                            2006-2010
                        </cfif>
					</td>
				</cfloop>
            </tr>
            <tr>
                <td>NO</td>
                <td>ÁREA</td>
                <td>ENTIDAD</td>
                <td>ACD_ID</td>
                <td>NOMBRE</td>
                <td>FECHA DE NAC.</td>
                <td>EDAD</td>
                <td>ANTIG</td>
                <td>CCN</td>
                <td>SNI</td>
                <td>EST. DGAPA</td>
                <td>COMENTARIO</td>
                <td colspan="2">ART INDIZADOS</td>
                <td>CAP&Iacute;TULOS</td>
                <td>&nbsp;</td>
                <td>TOTAL</td>
                <td colspan="2">PROMEDIO</td>
                <td colspan="3">GRADUADOS</td>
                <td>TOTAL </td>
                <td>PROMEDIO</td>
                <td>&nbsp;</td>
				<cfloop index="vAnio" from="#vAnioInicio#" to="#vAnioFinal#">
                    <td colspan="2">ART INDIZADOS</td>
                    <td>CAP&Iacute;TULOS</td>
                    <td>&nbsp;</td>
                    <td>TOTAL</td>
                    <td >&nbsp;</td>
                    <td colspan="3">GRADUADOS</td>
                    <td>TOTAL </td>
                    <td>&nbsp;</td>
				</cfloop>
			</tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>INTERNACIONALES</td>
                <td>NACIONALES</td>
                <td>EN LIBROS</td>
                <td>LIBROS</td>
                <td>PUBLICACIONES</td>
                <td>ART./INV/A&Ntilde;O</td>
                <td>PUB./INV/A&Ntilde;O</td>
                <td>LICENCIATURA</td>
                <td>MAESTR&Iacute;A</td>
                <td>DOCTORADO</td>
                <td>GRADUADOS</td>
                <td>GRAD/INV/AÑO</td>
                <td>A&Ntilde;OS CONTRATO</td>
				<cfloop index="vAnio" from="#vAnioInicio#" to="#vAnioFinal#">
                    <td>INTERNACIONALES</td>
                    <td>NACIONALES</td>
                    <td>EN LIBROS</td>
                    <td>LIBROS</td>
                    <td>PUBLICACIONES</td>
                    <td>&nbsp;</td>
                    <td>LICENCIATURA</td>
                    <td>MAESTR&Iacute;A</td>
                    <td>DOCTORADO</td>
                    <td>GRADUADOS</td>
                    <td>&nbsp;</td>
				</cfloop>
            </tr>
			<cfoutput query="tbAcademicos">
				<cfset vAcdClave = #acd_id#>
                <!--- QUERY QUE SACA DE LA BASE DE DATOS LOS DATOS MÁS RECIENTES --->
                <cfquery name="tbAcademicosReciente" datasource="#vOrigenDatosCISIC#">
                    SELECT T1.acd_clave, C6.area_siglas, C2.dep_siglas, T1.dep_clave, C3.cn_siglas_nom, T1.fecha_nacimiento, C4.pride_nombre, C5.sni_nombre, T1.antiguedad, T1.fecha_nacimiento, T1.captura
                    FROM (((((academicos AS T1
                    LEFT JOIN catalogos.catalogo_academicos AS C1 ON T1.acd_clave = C1.acd_clave)
                    LEFT JOIN catalogos.catalogo_dependencias AS C2 ON T1.dep_clave = C2.dep_clave)
                    LEFT JOIN catalogos.catalogo_cn AS C3 ON T1.cn_clave= C3.cn_clave)
                    LEFT JOIN catalogos.catalogo_pride AS C4 ON T1.pride_clave = C4.pride_clave)
                    LEFT JOIN catalogos.catalogo_sni AS C5 ON T1.sni_clave = C5.sni_clave)
                    LEFT JOIN catalogos.catalogo_areas_sic AS C6 ON C2.dep_area = C6.area_clave
                    WHERE T1.acd_clave = #vAcdClave#
                    AND T1.captura BETWEEN '#vAnioInicio#' AND '#vAnioFinal#'
                    ORDER BY T1.captura DESC
                    <!--- LIMIT 5--->
                </cfquery>

                <cfset vEdad = 0>
                <cfif #tbAcademicosReciente.fecha_nacimiento# NEQ ''>
                    <cfset vEdad = #vAnioFinal# - #LsDateFormat(tbAcademicosReciente.fecha_nacimiento,'yyyy')#>
                <cfelse>
                    <cfset vEdad = 'ERROR'>
                </cfif>
                <cfset vAntiguedad = #tbAcademicosReciente.antiguedad#>

                <cfquery name="tbAcademicosNum" datasource="#vOrigenDatosCISIC#">
                    SELECT SUM(art_ind_int) AS art_ind_int, SUM(art_ind_nac) AS art_ind_nac, SUM(cap_libros) AS cap_libros, SUM(libros) AS libros, SUM(graduado_l) AS graduado_l, SUM(graduado_m) AS graduado_m, SUM(graduado_d) AS graduado_d
                    FROM academicos_numeros
                    WHERE acd_clave = #vAcdClave#
                    <cfif #vAnioInicio# EQ #vAnioFinal#>
                        AND captura = '#vAnioFinal#'
                    <cfelse>
                        <cfif #vAnioInicio# EQ '2010'>
                            AND captura BETWEEN '0610' AND '#vAnioFinal#'
                        <cfelse>
                            AND captura BETWEEN '#vAnioInicio#' AND '#vAnioFinal#'
                        </cfif>                                
                    </cfif>
                </cfquery>
                <cfset vTotalArt = #IIf(LEN(tbAcademicosNum.art_ind_int) EQ 0, DE(0), DE(tbAcademicosNum.art_ind_int))# + #IIf(tbAcademicosNum.art_ind_nac EQ '', DE(0), DE(tbAcademicosNum.art_ind_nac))#>

                <cfif #vAntiguedad# GT #vAniosDivide# OR #vAntiguedad# EQ ''>
                    <cfset vPromArt = #vTotalArt#/#vAniosDivide#>
                <cfelse>
                    <cfif #vAntiguedad# EQ 0>
                        <cfset vPromArt = #vTotalArt#>
                    <cfelse>
                        <cfset vPromArt = #vTotalArt#/#vAntiguedad#>
                    </cfif>
                </cfif>

                <cfset vTotalPublica = #IIf(tbAcademicosNum.art_ind_int EQ '', DE(0), DE(tbAcademicosNum.art_ind_int))# + #IIf(tbAcademicosNum.art_ind_nac EQ '', DE(0), DE(tbAcademicosNum.art_ind_nac))# + #IIf(tbAcademicosNum.cap_libros EQ '', DE(0), DE(tbAcademicosNum.cap_libros))# + #IIf(tbAcademicosNum.libros EQ '', DE(0), DE(tbAcademicosNum.libros))#>

                <cfif #vAntiguedad# GT #vAniosDivide# OR #vAntiguedad# EQ ''>
                    <cfset vPromPub = #vTotalPublica#/#vAniosDivide#>
                <cfelse>
                    <cfif #vAntiguedad# EQ 0>
                        <cfset vPromPub = #vTotalPublica#>
                    <cfelse>
                        <cfset vPromPub = #vTotalPublica#/#vAntiguedad#>
                    </cfif>
                </cfif>

                <cfset vTotalGradua = #IIf(tbAcademicosNum.graduado_l EQ '', DE(0), DE(tbAcademicosNum.graduado_l))# + #IIf(tbAcademicosNum.graduado_m EQ '', DE(0), DE(tbAcademicosNum.graduado_m))# + #IIf(tbAcademicosNum.graduado_d EQ '', DE(0), DE(tbAcademicosNum.graduado_d))#>
                <cfif #vAntiguedad# GT #vAniosDivide# OR #vAntiguedad# EQ ''>
                    <cfset vPromGradua = #vTotalGradua#/#vAniosDivide#>
                <cfelse>
                    <cfif #vAntiguedad# EQ 0>
                        <cfset vPromGradua = #vTotalGradua#>
                    <cfelse>
                        <cfset vPromGradua = #vTotalGradua#/#vAntiguedad#>
                    </cfif>
                </cfif>

                <tr bgcolor="">
                    <td>#CurrentRow#</td>
                    <td>#tbAcademicosReciente.area_siglas#</td>
                    <td>#dep_siglas#</td>
                    <td>#vAcdClave#</td>
                    <td>#UCASE(acd_apepat)# #UCASE(acd_apemat)# #UCASE(acd_nombres)#</td>
                    <td>#LsDateFormat(acd_fecha_nac,'dd/mm/yyyy')#</td>
                    <td>#vEdad#</td>
                    <td>#tbAcademicosReciente.antiguedad#</td>
                    <td>#cn_siglas_nom#</td>
                    <td>#tbAcademicosReciente.sni_nombre#</td>
                    <td>#tbAcademicosReciente.pride_nombre#</td>
                    <td>#comentario_texto_ci#</td>

                    <td>#tbAcademicosNum.art_ind_int#</td>
                    <td>#tbAcademicosNum.art_ind_nac#</td>
                    <td>#tbAcademicosNum.cap_libros#</td>
                    <td>#tbAcademicosNum.libros#</td>
                    <td>#vTotalPublica#</td>
                    <td>#LsNumberFormat(vPromArt, '99.99')#</td>
                    <td>#LsNumberFormat(vPromPub, '99.99')#</td>
                    <td>#tbAcademicosNum.graduado_l#</td>
                    <td>#tbAcademicosNum.graduado_m#</td>
                    <td>#tbAcademicosNum.graduado_d#</td>
                    <td>#vTotalGradua#</td>
                    <td>#LsNumberFormat(vPromGradua, '99.99')#</td>
                    <td><cfif #vAntiguedad# GT #vAniosDivide#>#vAniosDivide#<cfelse>#vAntiguedad#</cfif></td>
                    <cfloop index="vAnio" from="#vAnioInicio#" to="#vAnioFinal#">
                        <cfquery name="tbAcademicosNumAnio" datasource="#vOrigenDatosCISIC#">
                            SELECT
                            SUM(art_ind_int) AS art_ind_int, SUM(art_ind_nac) AS art_ind_nac, SUM(cap_libros) AS cap_libros, SUM(libros) AS libros, SUM(graduado_l) AS graduado_l, SUM(graduado_m) AS graduado_m, SUM(graduado_d) AS graduado_d
                            FROM academicos_numeros
                            WHERE acd_clave = #vAcdClave#
                            <cfif #vAnio# EQ '2010'>
                                AND captura = '0610'
                            <cfelse>
                                AND captura = #vAnio#
                            </cfif>                                
                        </cfquery>
                        <cfset vTotalPublicaAnio = #IIf(tbAcademicosNumAnio.art_ind_int EQ '', DE(0), DE(tbAcademicosNumAnio.art_ind_int))# + #IIf(tbAcademicosNumAnio.art_ind_nac EQ '', DE(0), DE(tbAcademicosNumAnio.art_ind_nac))# + #IIf(tbAcademicosNumAnio.cap_libros EQ '', DE(0), DE(tbAcademicosNumAnio.cap_libros))# + #IIf(tbAcademicosNumAnio.libros EQ '', DE(0), DE(tbAcademicosNumAnio.libros))#>
                        <cfset vTotalGraduaAnio = #IIf(tbAcademicosNumAnio.graduado_l EQ '', DE(0), DE(tbAcademicosNumAnio.graduado_l))# + #IIf(tbAcademicosNumAnio.graduado_m EQ '', DE(0), DE(tbAcademicosNumAnio.graduado_m))# + #IIf(tbAcademicosNumAnio.graduado_d EQ '', DE(0), DE(tbAcademicosNumAnio.graduado_d))#>

                        <td>#tbAcademicosNumAnio.art_ind_int#</td>
                        <td>#tbAcademicosNumAnio.art_ind_nac#</td>
                        <td>#tbAcademicosNumAnio.cap_libros#</td>
                        <td>#tbAcademicosNumAnio.libros#</td>
                        <td>#vTotalPublicaAnio#</td>
                        <td>&nbsp;</td>
                        <td>#tbAcademicosNumAnio.graduado_l#</td>
                        <td>#tbAcademicosNumAnio.graduado_m#</td>
                        <td>#tbAcademicosNumAnio.graduado_d#</td>
                        <td>#vTotalGraduaAnio#</td>
                        <td>&nbsp;</td>
                    </cfloop>
                </tr>
            </cfoutput>
    	</table>
    </body>
</html>
