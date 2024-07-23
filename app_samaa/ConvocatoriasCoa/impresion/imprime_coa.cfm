<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/09/2021 --->
<!--- FECHA ÚLTIMA MOD.: 22/11/2021 --->
<!--- IMPRIME LAS CONVOCATORIAS COA Y SOLICITANTES --->

<cfif #Session.sTipoSistema# IS 'sic'>
    <cfset vOrden = 'coa_no_plaza'>
<cfelseif #Session.sTipoSistema# IS 'stctic'>
    <cfset vOrden = 'dep_siglas'>
</cfif>
<cfset vOrdenDir = 'ASC'>
    
<!--- LLAMADO A LA CONSULTA DE CONVOCATORIAS --->
<cfquery name="tbCoas" datasource="#vOrigenDatosSAMAA#">
    SELECT coa_id, dep_clave, dep_siglas, coa_no_plaza, cn_descrip, coa_area, ubica_lugar, ssn_id, coa_gaceta_num, coa_gaceta_fecha, coa_gaceta_fecha_limite, coa_status
    FROM consulta_convocatorias_coa
    WHERE YEAR(coa_gaceta_fecha) >= 2021
    <cfif #vAppConCoaMenu# EQ 1>
        AND coa_status < 5 AND '#vFechaHoy#' BETWEEN coa_gaceta_fecha AND coa_gaceta_fecha_limite
    <cfelseif #vAppConCoaMenu# EQ 2>
        AND coa_status < 5 AND '#vFechaHoy#' > coa_gaceta_fecha_limite
    <cfelseif #vAppConCoaMenu# EQ 3>
        AND coa_status = 5
    </cfif>
	<!--- Filtro por entidad --->
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
    ORDER BY #vOrden#
</cfquery>

<cfdocument format="PDF"  pagetype="letter" orientation="LANDSCAPE" fontembed="yes" marginleft="1.5" marginright="1.5" margintop="3" marginbottom="2" unit="cm" scale="64" backgroundvisible="yes" saveAsName="#vNomArchivoFecha#_#Session.sDepSiglas#.pdf" overwrite="yes">
	<!--- Encabezado de la listado --->
	<cfdocumentitem type="header">
        <br/><br/>
        <span style="font-family:sans-serif; font-size=20px; font-color=black;">
            <div align="center">
                <strong>
                    <cfif #vAppConCoaMenu# EQ 1>
                        CONVOCATORIAS PUBLICACI&Oacute;N VIGENTE
                    <cfelseif #vAppConCoaMenu# EQ 2>
                        CONVOCATORIAS PUBLICACI&Oacute;N FINALIZADA Y EN PROCESO SELECCI&Oacute;N
                    <cfelseif #vAppConCoaMenu# EQ 3>
                        CONVOCATORIAS HIST&Oacute;RICO
                    </cfif>
                </strong>
            </div>
            <div align="center">
                <strong>
                <cfif #Session.sTipoSistema# EQ 'stctic'>
                    SUBSISTEMA DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA
                <cfelse>
                    <cfoutput>#ucase(Session.sDepAcento)#</cfoutput>
                </cfif>
                </strong>
            </div>
        </span>
        <div  style="border-bottom: 1px solid #000000;"></div>
        <br/>
        <table width="100%" cellpadding="0" cellspacing="0" id="tbListaDatos">
            <thead>
                <tr style="font-family:sans-serif; font-size=14px; font-color=black;">
                    <th style="width: 3%;"></th>
                    <cfif #Session.sTipoSistema# EQ 'stctic'>
                        <th style="width: 10%;">Entidad</th>
                    </cfif>
                    <th style="width: 30%;">Plaza</th>
                    <th style="width: 10%;" align="center">Acta CTIC</th>
                    <th style="width: 15%;" align="center">Publicada</th>
                    <th style="width: 32%;" align="center">
                        Solicitudes para ser considerado como candidato
                    </th>
                </tr>
            </thead>
        </table>
	</cfdocumentitem>
    <table id="tbListaDatos" width="100%">
        <thead>
            <tr>
                <th style="width: 3%;"></th>
                <cfif #Session.sTipoSistema# EQ 'stctic'>
                    <th style="width: 10%;"></th>
                </cfif>
                <th style="width: 30%;"></th>
                <th style="width: 10%;"></th>
                <th style="width: 15%;"></th>
                <th style="width: 32%;"></th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="tbCoas">
                <cfset vCoaId = #coa_id#>
                <tr>
                    <td class="small">#CurrentRow#</td>
                    <cfif #Session.sTipoSistema# EQ 'stctic'>
                        <td class="small">#dep_siglas#</td>
                    </cfif>
                    <td class="small">
                        <strong>N&uacute;mero de plaza:</strong> #coa_no_plaza#
                        <br/>
                        <strong title="Clase, categoria nivel">Ccn:</strong> #cn_descrip#
                        <br/>
                        <strong>&Aacute;rea:</strong> #coa_area#
                        <br/>
                        <strong>Ubicaci&oacute;n de la plaza:</strong> #ubica_lugar#
                    </td>
                    <td class="small hidden-sm hidden-xs">#ssn_id#</td>                
                    <td class="small hidden-sm hidden-xs">
                        <cfif #coa_gaceta_num# EQ '' AND #coa_gaceta_fecha# EQ ''>
                            <strong class="text-danger">En proceso de publicaci&oacute;n en Gaceta UNAM</strong>
                        <cfelse>
                            <strong>Gaceta no.:</strong> #coa_gaceta_num#
                            <br/>
                            <strong>Fecha pub.:</strong> #LsDateFormat(coa_gaceta_fecha,'dd/mm/yyyy')#
                            <br/>
                            <strong>Fecha l&iacute;mite:</strong> #LsDateFormat(coa_gaceta_fecha_limite,'dd/mm/yyyy')#                        
                        </cfif>
                    </td>
                    <td class="small" align="center">
                        <cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">
                            SELECT solicitud_id, sol_apepat, sol_apemat, sol_nombres, solicitud_status
                            FROM solicitudes
                            WHERE coa_id = '#vCoaId#'
                        </cfquery>
                        <table width="100%">
                            <tbody>
                                <cfloop query="tbSolCoa">
                                    <tr>
                                        <td width="65%">#tbSolCoa.sol_apepat# #tbSolCoa.sol_apemat# #tbSolCoa.sol_nombres#</td>
                                        <td width="35%" align="left">
                                            <cfif #tbSolCoa.solicitud_status# EQ '' OR #tbSolCoa.solicitud_status# EQ '0'>
                                                Validando email
                                            <cfelseif #tbSolCoa.solicitud_status# GTE '1' AND #tbSolCoa.solicitud_status# LTE '4'>
                                                En captura
                                            <cfelseif #tbSolCoa.solicitud_status# EQ '5'>
                                                Enviada a la entidad
                                            <cfelseif #tbSolCoa.solicitud_status# EQ '6'>
                                                En revisi&oacute;n en la entidad
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="7" style="border-bottom: 1px solid ##CCCCCC;"></td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    
	<cfdocumentitem type="footer">
        <span style="font-family:sans-serif; font-size=10px; font-color=black;">
            <cfoutput>
            <div style="float: left; width: 50%;">
                #LsDateFormat(now(), "dd/mm/yyyy")#, #LsTimeFormat(now(), "HH:mm:ss")#
            </div>
            <div style="float: left; width: 50%;" align="right">
                #cfdocument.currentpagenumber# / #cfdocument.totalpagecount#
            </div>
            </cfoutput>
        </span>
    </cfdocumentitem>
</cfdocument>