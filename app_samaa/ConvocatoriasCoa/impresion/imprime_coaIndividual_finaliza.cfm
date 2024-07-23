<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 17/05/2022 --->
<!--- FECHA ÚLTIMA MOD.: 17/05/2022 --->
<!--- IMPRIME LA CONVOCATORIA Y LAS SOLICITUDES REGISTRADAS --->

<!--- LLAMADO A LA CONSULTA DE CONVOCATORIAS --->
<cfquery name="tbCoas" datasource="#vOrigenDatosSAMAA#">
    SELECT coa_id, dep_clave, dep_nombre_may_min, coa_no_plaza, cn_descrip, coa_area, ubica_lugar, ssn_id, coa_gaceta_num, coa_gaceta_fecha, coa_gaceta_fecha_limite, coa_status
    FROM consulta_convocatorias_coa
    WHERE coa_id = '#vpCoaId#'
</cfquery>
<!--- LLAMADO A LA ABSE DE DATTOS DE SOLICITUDES COA --->
<cfquery name="tbSolCoa" datasource="#vOrigenDatosSOLCOA#">
    SELECT solicitud_id, sol_apepat, sol_apemat, sol_nombres, solicitud_status, sol_dep_status
    FROM solicitudes
    WHERE coa_id = '#vpCoaId#'
    ORDER BY sol_apepat, sol_apemat, sol_nombres
</cfquery>    

<cfdocument format="PDF"  pagetype="letter" orientation="LANDSCAPE" fontembed="yes" marginleft="1.5" marginright="1.5" margintop="3" marginbottom="2" unit="cm" scale="64" backgroundvisible="yes" saveAsName="#vNomArchivoFecha#_#Session.sDepSiglas#_#vpCoaId#.pdf" overwrite="yes">
	<!--- Encabezado de la listado --->
	<cfdocumentitem type="header">
        <br/><br/>
        <span style="font-family:sans-serif; font-size=20px; font-color=black;">
            <div align="center">
                
                
            </div>
            </span><div align="center">
                <span style="font-family:sans-serif; font-size=20px; font-color=black;"><strong>
                    <cfif #Session.sTipoSistema# EQ 'stctic'>
                        COORDINACI&Oacute;N DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA
                        <cfelse>
                        <cfoutput>#ucase(Session.sDepAcento)#</cfoutput>
                    </cfif>
                    <br/>
                    CONVOCATORIA DE CONCURSO DE OPOSICI&Oacute;N ABIERTO
                </strong>
            </span></div>
        
        <div  style="border-bottom: 1px solid #000000;"></div>
        <br/>
	</cfdocumentitem>
    <strong>INFORMACI&Oacute;N DE LA CONVOCATORIA</strong>
    <table id="tbListaDatos" width="100%">
        <tbody>
            <cfoutput query="tbCoas">
                <cfset vCoaId = #coa_id#>
                <tr>
                    <td class="small" width="20%"><strong>Entidad acad&eacute;mica:</strong></td>
                    <td class="small" width="80%">#UCASE(dep_nombre_may_min)#</td>
                </tr>
                <tr>
                    <td class="small"><strong>Plaza n&uacute;mero:</strong></td>
                    <td class="small">#coa_no_plaza#</td>
                </tr>
                <tr>
                    <td class="small"><strong>Clase, categor&iacute;a y nivel:</strong></td>
                    <td class="small">#cn_descrip#</td>
                </tr>
                <tr>
                    <td class="small"><strong>&Aacute;rea:</strong></td>
                    <td class="small">#UCASE(coa_area)#</td>
                </tr>
                <tr>
                    <td class="small"><strong>Ubicaci&oacute;n de la plaza:</strong></td>
                    <td class="small">#ubica_lugar#</td>
                </tr>
                <tr>
                  <td class="small">&nbsp;</td>
                  <td class="small">&nbsp;</td>
                </tr>
                <tr>
                    <td class="small"><strong>Aprobada en Sesi&oacute;n Pleno CTIC:</strong></td>
                    <td class="small">#ssn_id#</td>
                </tr>
                <tr>
                    <td class="small" colspan="2"><strong><div  style="border-bottom: 1px solid ##CCCCCC;"></div></strong></td>
                </tr>                    
                <tr>
                    <td class="small" colspan="2"><strong>Publicaci&oacute;n de la convocatoria</strong></td>
                </tr>
                <tr>
                    <td class="small"><strong>Gaceta n&uacute;mero:</strong></td>
                    <td class="small">#coa_gaceta_num#</td>
                </tr>
                <tr>
                    <td class="small"><strong>Fecha publicaci&oacute;n:</strong></td>
                    <td class="small">#LsDateFormat(coa_gaceta_fecha,'dd/mm/yyyy')#</td>
                </tr>
                <tr>
                    <td class="small"><strong>Fecha l&iacute;mite de recepci&oacute;n de solicitudes:</strong></td>
                    <td class="small">#LsDateFormat(coa_gaceta_fecha_limite,'dd/mm/yyyy')#</td>
                </tr>
            </cfoutput>
        </tbody>
    </table>
    <br/><br/>
    <strong>SOLICITUDES REGISTRADAS</strong>
    <table id="tbListaDatos" width="100%">
        <thead>
            <tr>
                <th style="width: 5%;"></th>                
                <th style="width: 20%;">Primer apellido</th>
                <th style="width: 20%;">Segundo apellido</th>
                <th style="width: 20%;">Nombre(s)</th>
                <th style="width: 20%;">Situaci&oacute;n de la solicitud</th>
                <th style="width: 15%;">La solicitutud fue</th>
            </tr>
        </thead>
        <tbody>
            <cfoutput query="tbSolCoa">
                <tr>
                    <td>#currentrow#</td>                    
                    <td>#sol_apepat#</td>
                    <td>#sol_apemat#</td>
                    <td>#sol_nombres#</td>                    
                    <td>
                        <cfif #solicitud_status# EQ ''  OR (#solicitud_status# GTE '1' AND #tbSolCoa.solicitud_status# LTE '4')>
                            No se concluy&oacute; el registro
                        <cfelseif #tbSolCoa.solicitud_status# EQ '5'>
                            Enviada a la entidad
                        <cfelseif #tbSolCoa.solicitud_status# EQ '6'>
                            Recibida en la entidad
                        </cfif>
                    </td>                    
                    <td width="35%" align="left">
                        <cfif #sol_dep_status# EQ '1'>
                            Aceptada
                        <cfelseif #sol_dep_status# EQ '2'>
                            Rechazada
                        <cfelseif #sol_dep_status# EQ '3'>
                            Cancelada
                        <cfelseif #sol_dep_status# EQ '4'>
                            Declin&oacute; participaci&oacute;n
                        </cfif>                        
                    </td>
                </tr>
            </cfoutput>                
        </tbody>
    </table>
	<cfdocumentitem type="footer">
        <span style="font-family:sans-serif; font-size=10px; font-color=black;">
            <cfoutput>
            <div style="float: left; width: 50%;">
                SAMAA #LsDateFormat(now(), "dd/mm/yyyy")#, #LsTimeFormat(now(), "HH:mm:ss")#
            </div>
            <div style="float: left; width: 50%;" align="right">
                #cfdocument.currentpagenumber# / #cfdocument.totalpagecount#
            </div>
            </cfoutput>
        </span>
    </cfdocumentitem>
</cfdocument>