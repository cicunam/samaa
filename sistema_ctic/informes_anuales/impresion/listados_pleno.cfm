<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/05/2018 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2019 --->
<!--- GENERA EL LISTADO PARA EL PLENO DEL CTIC--->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="0">
<cfparam name="vpSsnId" default="1533">

<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vpSsnId# 
    AND ssn_clave = 1
</cfquery>

<cfquery  name="tbCatalogoEntidad" datasource="#vOrigenDatosCATALOGOS#">
    SELECT dep_clave, dep_nombre 
    FROM catalogo_dependencias
    WHERE dep_clave LIKE '03%'
    AND dep_status = 1
    AND dep_tipo <> 'PRO'
    ORDER BY dep_orden ASC
</cfquery>

<cfset vTextoEncabezaCol = "RECOMENDACIÓN">

<cfheader name="Content-Disposition" value="inline; filename=listado_ctic_informes_#vpInformeAnio#.doc">
<cfcontent type="application/msword; charset=iso-8859-1">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>Listado Informes Anuales Recomendaciones</title>
		<link href="http://www.cic-ctic.unam.mx:31102/ctic/css/listados.css" rel="stylesheet" type="text/css">
    </head>

    <body>
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
        	<cfoutput>
                <tr>
                    <td colspan="2">
                        III ASUNTOS ACADÉMICO-ADMINISTRATIVOS SUJETOS A DECISIÓN DEL CTIC<br />
                        III.III EVALUACIÓN DE INFORMES ANUALES DEL PERSONAL ACADÉMICO. #vpInformeAnio#
                        <!---#ctListado.parte_titulo# --->
                    </td>
                </tr>
                <tr>
                    <td>RELACION DEL #LsDateFormat(tbSesiones.ssn_fecha, 'dd/mm/yyyy')#</td>
                    <td align="right">ACTA #vpSsnId#</td>
                </tr>
			</cfoutput>
			<!--- Línea --->
            <tr><td colspan="3"><hr class="doble"></td></tr>
        </table>
    	<br /><br />
    	<cfoutput query="tbCatalogoEntidad">
			<cfset vCuentaReg = 0>
            <cfquery  name="tbMovInformeAnualPleno" datasource="#vOrigenDatosSAMAA#">
                SELECT 
                T3.asu_numero,
                T1.acd_id, T1.dep_clave, C1.cn_siglas, T2.acd_prefijo,
                (
                    ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                    CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END +
                    ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END +
                    ISNULL(dbo.SINACENTOS(acd_apemat),'')
                ) AS NombreCompleto,
                T3.*
                FROM movimientos_informes_anuales AS T1
                LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
				LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.ssn_id = #vpSsnId# AND T3.informe_reunion = 'CTIC'
                LEFT JOIN catalogo_cn AS C1 ON T1.cn_clave = C1.cn_clave
                WHERE T1.informe_anio = '#vpInformeAnio#'
                AND T1.dep_clave = '#dep_clave#'
				AND T3.informe_reunion = 'CTIC'
				AND (T3.dec_clave = 1 OR T3.dec_clave BETWEEN 70 AND 80)
                AND informe_status = 3
                ORDER BY T2.acd_apepat, T2.acd_apemat    
            </cfquery>
			<!--- SE SEPARÓ PARA PODER IMPRIMIR LAS RECOMNEDACIONES DE LA CAAA DE LOS ASUNTOS APROBADOS CON COMNETARIO Y LOS NO APROBADOS (14/05/2019) --->
            <cfquery  name="tbMovInformeAnualCaaa" datasource="#vOrigenDatosSAMAA#">
                SELECT 
                T3.asu_numero,
                T1.acd_id, T1.dep_clave, C1.cn_siglas, T2.acd_prefijo,
                (
                    ISNULL(dbo.SINACENTOS(acd_nombres),'') + 
                    CASE WHEN acd_nombres IS NULL THEN '' ELSE ' ' END +
                    ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
                    CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END +
                    ISNULL(dbo.SINACENTOS(acd_apemat),'')
                ) AS NombreCompleto,
                T3.*
                FROM movimientos_informes_anuales AS T1
                LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
				LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.ssn_id = #vpSsnId# AND T3.informe_reunion = 'CAAA'
                LEFT JOIN catalogo_cn AS C1 ON T1.cn_clave = C1.cn_clave
                WHERE T1.informe_anio = '#vpInformeAnio#'
                AND T1.dep_clave = '#dep_clave#'
				AND T3.informe_reunion = 'CAAA'
				AND (T3.dec_clave = 4 OR T3.dec_clave = 19 OR T3.dec_clave = 49 OR T3.dec_clave = 61)
                AND informe_status = 3
                ORDER BY T2.acd_apepat, T2.acd_apemat    
            </cfquery>            
            
            <!---#tbMovInformeAnual.Recordcount# --->
            <cfif #tbMovInformeAnualPleno.RecordCount# GT 0 OR #tbMovInformeAnualCaaa.RecordCount# GT 0>
	        	<strong>#dep_nombre#</strong><br />
	            <br />
    
                <!--- APROBADOS --->
                <cfquery name="tbInformesAp" dbtype="query">
                    SELECT * FROM tbMovInformeAnualPleno
                    WHERE dec_clave = 1
                </cfquery>
                <cfif #tbInformesAp.RecordCount# GT 0> 
                    <cfset vMedioFin = #tbInformesAp.RecordCount# / 2>
    
                    <cfset vLen = #LEN(tbInformesAp.RecordCount)#>
    <!---
                    <cfoutput>#vLen# - #MID(tbInformesAp.RecordCount,vLen,1)#</cfoutput>
    --->
                    <cfif #MID(tbInformesAp.RecordCount,vLen,1)# EQ 1 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 3 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 5 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 7 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 9>
                        <cfset vMedioFin = #vMedioFin# + 1>
                    </cfif>
                    <cfset vMedioInicio = #vMedioFin# + 1>
                    <cfset vFinal = #tbInformesAp.RecordCount#>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td colspan="2">
								<strong>#vTextoEncabezaCol#: APROBAR</strong>
							</td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <table>
                                   <cfloop query="tbInformesAp" startrow="1" endrow="#vMedioFin#">
                                        <cfset vCuentaReg = #vCuentaReg# + 1>
                                        <tr>
                                            <td width="5%">#vCuentaReg#<!--- #tbInformesAp.asu_numero#---></td>
                                            <td width="45%">#tbInformesAp.NombreCompleto#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                            <td valign="top">
                                <table>
                                   <cfloop query="tbInformesAp" startrow="#vMedioInicio#" endrow="#vFinal#">
                                        <cfset vCuentaReg = #vCuentaReg# + 1>
                                        <tr>
                                            <td width="5%">#vCuentaReg#</td>
                                            <td width="45%">#tbInformesAp.NombreCompleto#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                        </tr>
                    </table>
                </cfif>
                <!--- APROBADOS CON COMENTARIOS --->
                <cfquery name="tbInformesApRec" dbtype="query">
                    SELECT * FROM tbMovInformeAnualCaaa
                    WHERE (dec_clave = 49 OR dec_clave = 61)
                </cfquery>
                <cfif #tbInformesApRec.RecordCount# GT 0>
                    <br />
                    <br />
                    <table>
                        <tr>
                            <td colspan="4">
								<strong>#vTextoEncabezaCol#: APROBAR (COMENTARIO)</strong>
							</td>
                        </tr>
                        <cfloop query="tbInformesApRec">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#vCuentaReg#<!--- #tbInformesApRec.asu_numero#---></td>
                                <td width="35%" valign="top">
                                    #tbInformesApRec.NombreCompleto#<br />
                                    #tbInformesApRec.cn_siglas#
								</td>
                                <td width="60%" valign="top">
									#tbInformesApRec.comentario_texto#
									<br /><br />
							  </td>
                            </tr>
                        </cfloop>
                    </table>
                </cfif>
                <!--- NO APROBADOS --->
                <cfquery name="tbInformesNoAp" dbtype="query">
                    SELECT * FROM tbMovInformeAnualCaaa
                    WHERE (dec_clave = 4 OR dec_clave = 19)
                </cfquery>
                <cfif #tbInformesNoAp.RecordCount# GT 0>
                    <br />
                    <br />
                    <table>
                        <tr>
                            <td colspan="4">
								<strong>#vTextoEncabezaCol#: NO APROBAR</strong>
                            </td>
                        </tr>
                        <cfloop query="tbInformesNoAp">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#vCuentaReg#<!--- #tbInformesNoAp.asu_numero#---></td>
                                <td width="35%" valign="top">
                                    #tbInformesNoAp.NombreCompleto#<br />
                                    #tbInformesNoAp.cn_siglas#
                                </td>
                                <td width="60%" valign="top">
									#tbInformesNoAp.comentario_texto#
									<br /><br />
								</td>
                            </tr>
                        </cfloop>
                    </table>
                </cfif>
                <!--- NO EVALUADOS --->
                <cfquery name="tbInformesNoEval" dbtype="query">
                    SELECT * FROM tbMovInformeAnualPleno
                    WHERE dec_clave > 49
                </cfquery>
                <cfif #tbInformesNoEval.RecordCount# GT 0>
                    <br />
                    <br />
                    <table>
                        <tr>
                            <td colspan="3"><strong>#vTextoEncabezaCol#: NO EVALUADOS</strong></td>
                        </tr>
                        <cfloop query="tbInformesNoEval">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#vCuentaReg#<!--- #tbInformesNoEval.asu_numero# ---></td>
                                <td width="40%" valign="top">#tbInformesNoEval.NombreCompleto#</td>
                                <td width="55%" valign="top">#tbInformesNoEval.comentario_texto#</td>
                            </tr>
                        </cfloop>
                    </table>
                </cfif>
                <br /><br />
			</cfif>
		</cfoutput>
    </body>
</html>