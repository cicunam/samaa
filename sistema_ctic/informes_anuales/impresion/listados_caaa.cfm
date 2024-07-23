<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 30/05/2016 --->
<!--- FECHA ÚLTIMA MOD.: 08/05/2019 --->
<!--- GENERA EL LISTADO PARA LAS RECOMENDACIONES Y DECISIONES --->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="0">
<cfparam name="vpSsnId" default="1533">

<cfquery  name="tbMovInformeAnual" datasource="#vOrigenDatosSAMAA#">
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
    , C2.comentario_descrip
    , C3.dep_siglas
    FROM movimientos_informes_anuales AS T1
    LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
    LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.ssn_id = #vpSsnId# AND T3.informe_reunion = 'CAAA'
    LEFT JOIN catalogo_cn AS C1 ON T1.cn_clave = C1.cn_clave
    LEFT JOIN catalogo_decs_informes_comenta AS C2 ON T1.comentario_clave_ci = C2.comentario_clave
	LEFT JOIN catalogo_dependencia AS C3 ON T1.dep_clave = C3.dep_clave    
    WHERE T1.informe_anio = '#vpInformeAnio#'
    AND informe_status = 2
    ORDER BY C3.dep_orden, acd_apepat, acd_apemat
</cfquery>


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
		<cfset vCuentaReg = 0>

        <!---#tbMovInformeAnual.Recordcount# --->
        <cfif #tbMovInformeAnual.RecordCount# GT 0>
            <!--- APROBADOS CON COMENTARIOS --->
            <cfquery name="tbInformesApRec" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave = 49
            </cfquery>
            <cfif #tbInformesApRec.RecordCount# GT 0>
                <br />
                <br />
                <table>
                    <tr>
                        <td colspan="4">
                            <strong>RECOMENDACION: APROBAR (COMENTARIO)</strong>
                        </td>
                    </tr>
                    <cfoutput query="tbInformesApRec">
                        <tr>
                            <td width="5%" valign="top">#asu_numero#</td>
                            <td width="5%" valign="top">#dep_siglas#</td>
                            <td width="35%" valign="top">
								#acd_prefijo# #NombreCompleto#<br />
                                #cn_siglas#
                            </td>
                            <td width="60%" valign="top">
                                <cfif LEN(#comentario_texto#) GT 0>
                                    #comentario_texto#
                                <cfelse>
                                    #comentario_descrip#
                                </cfif>
                                <br /><br />
                          </td>
                        </tr>
                    </cfoutput>
                </table>
            </cfif>
            <!--- NO APROBADOS --->
            <cfquery name="tbInformesNoAp" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave = 4
            </cfquery>
            <cfif #tbInformesNoAp.RecordCount# GT 0>
                <br />
                <br />
                <table>
                    <tr>
                        <td colspan="5">
                            <strong>RECOMENDACION:: NO APROBAR</strong>
                        </td>
                    </tr>
                    <cfoutput query="tbInformesNoAp">
                        <tr>
                            <td width="5%" valign="top">#asu_numero#</td>
                            <td width="5%" valign="top">#dep_siglas#</td>
                            <td width="35%" valign="top">
                                #acd_prefijo# #NombreCompleto#<br />
                                #cn_siglas#
                            </td>
                            <td width="55%" valign="top">
                                <cfif LEN(#comentario_texto#) GT 0>
                                    #comentario_texto#
                                <cfelse>
                                    #comentario_descrip#
                                </cfif>
                                <br /><br />
                            </td>
                        </tr>
                    </cfoutput>
                </table>
            </cfif>
            <br /><br />
        </cfif>
    </body>
</html>