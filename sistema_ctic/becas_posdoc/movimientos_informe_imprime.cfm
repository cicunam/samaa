<!--- CREADO: ARAM PICHARDO --->
<!--- EDITÓ: ARAM PICHARDO --->
<!--- FECHA: 19/03/2014 --->
<!--- Imprime lista de becarios posdoctorales que deben entregar informe ANUAL o SEMESTRAL  --->	

<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="3.1" unit="cm" backgroundvisible="yes">

	<!--- Parámetros de búsqueda --->
    <cfparam name="vAcadNom" default="#Session.BecasInformeFiltro.vAcadNom#">
    <cfparam name="vDep" default="#Session.BecasInformeFiltro.vDep#">
    <cfparam name="vOrden" default="#Session.BecasInformeFiltro.vOrden#">
    <cfparam name="vOrdenDir" default="#Session.BecasInformeFiltro.vOrdenDir#">
    
    <!--- Obtener la lista de movimientos entre cinco a seis meses anteriores para poder determinar el informe semestral --->
    <cfset vFechaAnterior5 = LsDateFormat(DateAdd("m", -5, Now()),"dd/mm/yyyy")>
    <cfset vFechaAnterior6 = LsDateFormat(DateAdd("m", -6, Now()),"dd/mm/yyyy")>
    <!--- Obtener la lista de movimientos que vencen en los tres meses siguientes para poder determinar el informa anual --->
    <cfset vFechaActual = LsDateFormat(Now(),"dd/mm/yyyy")>
    <cfset vFechaPosterior = LsDateFormat(DateAdd("m", 2, Now()),"dd/mm/yyyy")>
    
    <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
        SELECT DISTINCT * 
        FROM (((((movimientos AS T1
        LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id  AND T2.ssn_id = (SELECT MAX(ssn_id) FROM movimientos_asunto WHERE sol_id = T1.sol_id))<!--- IMPORTANTE: Obtener el registro más reciente de la tabla de asuntos --->
        LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave) 
        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON T1.dep_clave = C2.dep_clave)
        LEFT JOIN catalogo_decision AS C3 ON T2.dec_clave = C3.dec_clave)
        LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id)
        LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C4 ON CASE WHEN T1.mov_cn_clave IS NULL THEN T1.cn_clave ELSE T1.mov_cn_clave END = C4.cn_clave
        WHERE asu_reunion = 'CTIC'
        AND ((T1.mov_fecha_inicio BETWEEN '#vFechaAnterior6#' AND '#vFechaAnterior5#') OR (T1.mov_fecha_final BETWEEN '#vFechaActual#' AND '#vFechaPosterior#'))
        <!--- (T1.mov_fecha_final > '#vFechaActual#' AND T1.mov_fecha_final < '#vFechaPosterior#')--->
        AND C3.dec_super = 'AP'
        AND T1.mov_cancelado IS NULL
        AND (T1.mov_clave = 38 OR T1.mov_clave = 39)
        <cfif #vAcadNom# NEQ ''>AND acd_apepat + ' ' + acd_apepat + ' ' + acd_nombres LIKE '%#vAcadNom#%'</cfif>
        <cfif #Session.sTipoSistema# IS 'sic'>
            AND T1.dep_clave LIKE '#Left(Session.sIdDep,4)#%'
        <cfelseif #vDep# NEQ '0'>
            AND T1.dep_clave LIKE '#Left(vDep,4)#%'
        </cfif>
        <!--- Ordenamiento --->
        <cfif #vOrden# IS NOT ''> ORDER BY #vOrden# </cfif><cfif #vOrdenDir# IS NOT ''> #vOrdenDir#</cfif>
    </cfquery>
    <html>
        <head>
            <title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
			<style type="text/css">
				body {
					background-image:url(<cfoutput>#vCarpetaIMG#/iUsoInterno.gif</cfoutput>);
					background-position: center; 
				}
			</style>
        </head>
        <body>
            <cfdocumentitem type="header">
                <link href="<cfoutput>#vCarpetaCSS#</cfoutput>/listados_lyc.css" rel="stylesheet" type="text/css">
                <!-- Titulo da la página --->
        
                <center>
                    <span style="font-size:9pt;">
                        <br>
                        <b>CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA</b>
                        <br>
                        <b><cfoutput>#Session.sDep#</cfoutput></b>
                        <br><br>
                        <i>RELACIÓN DE BECARIOS POSDOCTORALES QUE DEBEN ENTREGAR INFORME</i>
                        <br>
                        <br>
                    </span>
                </center>
            </cfdocumentitem>
            <!--- VER LOS REGISTROS COMO TABLA --->
            <table border="0" cellspacing="1" cellpadding="1" style="width:100%;">
                <!-- Encabezados -->
                <cfoutput>
                    <tr valign="middle" bgcolor="##CCCCCC">
                        <td class="Sans9GrNe">Nombre</td>
                        <td class="Sans9GrNe">Movimiento</td>
                        <td class="Sans9GrNe">Informe</td>
                        <td class="Sans9GrNe">Antes del</td>
                        <cfif #Session.sTipoSistema# IS 'stctic'>
                            <td class="Sans9GrNe">Entidad</td>
                        </cfif>
                    </tr>
                </cfoutput>
                <!-- Datos -->
                <cfoutput query="tbMovimientos">
                    <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor=''">
                        <td class="Sans9Gr"><cfif #acd_nombres# IS NOT ''>#acd_apepat#, #PrimeraPalabra(acd_nombres)#</cfif></td>
                        <td class="Sans9Gr">#Ucase(mov_titulo_corto)# <span class="Sans9Vi"><cfif #mov_cancelado# IS 1>(CANCELADO)</cfif></span></td>
                        <!--- <td class="Sans9Gr">#LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#</td>--->
                        <td class="Sans9Gr">
                            <cfif #mov_fecha_inicio# LT #vFechaAnterior6#>
                            ANUAL
                            <cfelse>
                            SEMESTRAL
                            </cfif>
                        </td>
                        <td class="Sans9Gr">
                            <cfif #mov_fecha_inicio# LT #vFechaAnterior6#>
                                #LsDateFormat(mov_fecha_final,'dd/mm/yyyy')#
                            <cfelse>
                                #LsDateFormat(DateAdd("m", 6, mov_fecha_inicio),'dd/mm/yyyy')#
                          </cfif>
                        </td>
                        <cfif #Session.sTipoSistema# IS 'stctic'>
                            <td class="Sans9Gr">#dep_siglas#</td>
                        </cfif>
                    </tr>
                </cfoutput>
            </table>
            <br><br><br>
            <p style="font-family:sans-serif; font-size:9px; color:#990000; font-weight:bold; text-align:center;">
                Este listado es para uso exclusivo de la entidad. La Secretar&iacute;a T&eacute;cnica del CTIC no lo recibirá como acuse de recibo.
            </p>
            <!--- Pie de página --->
            <cfdocumentitem type="footer">
                <table width="100%">
                    <tr>
                        <td align="left" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>#FechaCompleta(Now())#</cfoutput></td>	
                        <td align="right" style="font-family:sans-serif; font-size:7pt; font-weight:normal;"><cfoutput>P&aacute;gina #cfdocument.currentpagenumber# de #cfdocument.totalpagecount#</cfoutput></td>
                    </tr>
                </table>		
            </cfdocumentitem>
        </body>
    </html>
</cfdocument>