<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 14/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 02/03/2023 --->
<!--- GENERA EL LISTADO PARA ACUSE DE RECIBO POR APRTE DE LA ENTIDAD ACADÉMICA --->
<!--- Enviar el contenido a un archivo MS Word --->

<cfparam name="vpInformeAnio" default="0">

<cfquery  name="tbCatalogoEntidad" datasource="#vOrigenDatosCATALOGOS#">
    SELECT dep_clave, dep_nombre_may_min 
    FROM catalogo_dependencias
    WHERE dep_clave = '#Session.sIdDep#'
</cfquery>
    
<cfquery  name="tbMovInformeAnual" datasource="#vOrigenDatosSAMAA#">
    SELECT 
    acd_id, dep_clave, cn_siglas, acd_prefijo,
    (
        ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
        CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END +
        ISNULL(dbo.SINACENTOS(acd_apemat),'') +
        CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END +
        ISNULL(dbo.SINACENTOS(acd_nombres),'')
    ) AS NombreCompleto
    , dec_clave_ci, comentario_texto_ci
    FROM consulta_informes_anualesEnt
    WHERE informe_anio = '#vpInformeAnio#'
    AND dep_clave = '#Session.sIdDep#'
    ORDER BY acd_apepat, acd_apemat
    
</cfquery>

<cfdocument format="PDF" fontembed="yes" orientation="PORTRAIT" pagetype="letter" margintop="2.5" marginleft="2" marginright="2" marginbottom="2.5" unit="cm">		
    <html xmlns="http://www.w3.org/1999/xhtml">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
            <title>Listado Informes Anuales Recomendaciones</title>
			<cfoutput>
                <link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
                <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
			</cfoutput>
        </head>

        <body>
            <cfdocumentitem type="header">        
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <cfoutput>
                        <tr>
                            <td style="font: Arial; font-size: 14px;">
                                <strong>
                                <br/>
                                SISTEMA PARA LA ADMINISTRACIÓN DE MOVIMIENTOS ACADÉMICO ADMINISTRATIVOS<br />
                                #UCASE(tbCatalogoEntidad.dep_nombre_may_min)#<br />
                                EVALUACIÓN DE INFORMES ANUALES DEL PERSONAL ACADÉMICO #vpInformeAnio#
                                </strong>
                            </td>
                        </tr>
                    </cfoutput>
                    <!--- Línea --->
                    <tr><td><hr></td></tr>
                </table>
            </cfdocumentitem>
            <!--- APROBADOS --->
            <cfquery name="tbInformesAp" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 1
            </cfquery>

            <cfif #tbInformesAp.RecordCount# GT 0> 
                <cfset vMedioFin = #tbInformesAp.RecordCount# / 2>
                <cfset vCuentaReg = 0>

                <cfset vLen = #LEN(tbInformesAp.RecordCount)#>
                <cfif #MID(tbInformesAp.RecordCount,vLen,1)# EQ 1 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 3 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 5 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 7 OR #MID(tbInformesAp.RecordCount,vLen,1)# EQ 9>
                    <cfset vMedioFin = #vMedioFin# + 1>
                </cfif>
                <cfset vMedioInicio = #vMedioFin# + 1>
                <cfset vFinal = #tbInformesAp.RecordCount#>
                <cfoutput>                
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="2" style="font: Arial; font-size: 12px;">
                            <strong>APROBADOS</strong>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table>
                                <cfloop query="tbInformesAp" startrow="1" endrow="#vMedioFin#">
                                    <cfset vCuentaReg = #vCuentaReg# + 1>
                                    <tr>
                                        <td width="5%">#vCuentaReg#<!---#vCuentaReg#---></td>
                                        <td width="45%">
                                            #tbInformesAp.NombreCompleto#<br />
                                            #tbInformesAp.cn_siglas#
                                        </td>
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
                                        <td width="45%">
                                            #tbInformesAp.NombreCompleto#<br />
                                            #tbInformesAp.cn_siglas#
                                        </td>
                                    </tr>
                                </cfloop>
                            </table>
                        </td>
                    </tr>
                </table>
                </cfoutput>
            </cfif>

            <!--- APROBADOS CON COMENTARIOS --->
            <cfquery name="tbInformesApRec" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 49
            </cfquery>
            <cfif #tbInformesApRec.RecordCount# GT 0>
                <cfset vCuentaReg = 0>
                <br />
                <br />
                <cfoutput>
                    <table>
                        <tr>
                            <td colspan="4" style="font: Arial; font-size: 12px;">
                                <strong>APROBADOS (COMENTARIO)</strong>
                            </td>
                        </tr>
                        <cfloop query="tbInformesApRec">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#tbInformesApRec.CurrentRow#<!---#vCuentaReg#---></td>
                                <td width="35%" valign="top">
                                    #tbInformesApRec.NombreCompleto#<br />
                                    #tbInformesApRec.cn_siglas#
                                </td>
                                <td width="60%" valign="top">
                                    #tbInformesApRec.comentario_texto_ci#
                                    <br /><br />
                              </td>
                            </tr>
                        </cfloop>
                    </table>
                </cfoutput>                
            </cfif>

            <!--- NO APROBADOS --->
            <cfquery name="tbInformesNoAp" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 4
            </cfquery>
            <cfif #tbInformesNoAp.RecordCount# GT 0>
                <cfset vCuentaReg = 0>            
                <br />
                <br />
                <cfoutput>
                    <table>
                        <tr>
                            <td colspan="4" style="font: Arial; font-size: 12px;">
                                <strong>NO APROBADOS</strong>
                            </td>
                        </tr>
                        <cfloop query="tbInformesNoAp">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#tbInformesNoAp.CurrentRow#<!---#vCuentaReg#---></td>
                                <td width="35%" valign="top">
                                    #tbInformesNoAp.NombreCompleto#<br />
                                    #tbInformesNoAp.cn_siglas#
                                </td>
                                <td width="60%" valign="top">
                                    #tbInformesNoAp.comentario_texto_ci#
                                    <br /><br />
                                </td>
                            </tr>
                        </cfloop>
                    </table>
                </cfoutput>
            </cfif>

            <!--- NO EVALUADOS --->
            <cfquery name="tbInformesNoEval" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci > 49
            </cfquery>
            <cfif #tbInformesNoEval.RecordCount# GT 0>
                <cfset vCuentaReg = 0>
                <br />
                <br />
                <cfoutput>
                    <table>
                        <tr>
                            <td colspan="3" style="font: Arial; font-size: 12px;"><strong>NO EVALUADOS</strong></td>
                        </tr>
                        <cfloop query="tbInformesNoEval">
                            <cfset vCuentaReg = #vCuentaReg# + 1>
                            <tr>
                                <td width="5%" valign="top">#tbInformesNoEval.CurrentRow#<!---#vCuentaReg#---></td>
                                <td width="40%" valign="top">
                                    #tbInformesNoEval.NombreCompleto#<br />
                                    #tbInformesNoEval.cn_siglas#
                                </td>
                                <td width="55%" valign="top">#tbInformesNoEval.comentario_texto_ci#</td>
                            </tr>
                        </cfloop>
                    </table>
                </cfoutput>
            </cfif>
            <!-- Pie de página (include general) -->
            <cfset vModuloImp = 'SICLISTAACUSE'>
            <cfinclude template="#vCarpetaRaizLogica#/includes/include_imprime_listado_pie.cfm">
        </body>
    </html>
</cfdocument>            