<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA: 30/10/2013 --->
<!--- IMPRIME LAS SESIONES ORDINARIAS VIGENTES--->

<cfset vMes = val(LsDateFormat(now(),"mm"))>
<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
<cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>

<cfquery name="tbCatalogoSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT ssn_id FROM sesiones WHERE (ssn_clave <> 2 AND ssn_clave <> 6) AND (
	<cfif #Session.CalendarioSesFiltro.Semestre1# EQ 'checked'>
		MONTH(ssn_fecha) < 7 AND YEAR(ssn_fecha) = #vAnio#
	<cfelseif #Session.CalendarioSesFiltro.Semestre2# EQ 'checked'>
		MONTH(ssn_fecha) > 7 AND YEAR(ssn_fecha) = #vAnio# OR MONTH(ssn_fecha) = 1 AND YEAR(ssn_fecha) = #vAnioPost#
	</cfif>
	 ) GROUP BY ssn_id ORDER BY ssn_id ASC
</cfquery>

<cfdocument format="PDF" fontembed="yes" marginbottom="1.5" marginleft="1.5" marginright="1.5" margintop="2" unit = "cm" orientation="portrait" pagetype="letter" backgroundvisible="yes">
	<html>
        <head>
            <title>STCTIC -CALENDARIO DE SESIONES</title>
            <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<cfoutput>
            	<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
            	<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
        	    <link href="#vCarpetaCSS#/fuentes_calendario.css" rel="stylesheet" type="text/css">
			</cfoutput>
        </head>
	
		<body>
			<table width="95%" cellspacing="0">
				<tr>
					<td width="135"><img src="<cfoutput>#vCarpetaIMG#</cfoutput>/ctic_nuevo.png" width="90" height="123"></td>
					<td width="537" valign="top" class="ArialNarrow20"><strong>Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica</strong></td>
				</tr>
			</table>
            <div align="center" style="width:100%; background-color:#EBEBEB;">
                <span class="ArialNarrow12">CALENDARIO DE SESIONES DEL CTIC</span>
                <br>
                <cfoutput>
                    <cfif #Session.CalendarioSesFiltro.Semestre1# EQ 'checked'>
                        <span class="ArialNarrow12">Enero a Julio de #vAnio#</span>
                    <cfelseif #Session.CalendarioSesFiltro.Semestre2# EQ 'checked'>
                        <span class="ArialNarrow12">Junio de #vAnio# a Enero de #vAnioPost#</span>
                    </cfif>
                </cfoutput>
                <br>
            </div>
            <br/>
            <table width="95%" border="0" align="center" cellpadding="3" cellspacing="0">
                <tr bgcolor="#EBEBEB">
                    <td width="135" align="center">
                        <span class="ArialNarrow10N">
                            RECEPCI&Oacute;N DE DOCUMENTOS
                        </span>
                        <br>
                        <span class="ArialNarrow8">
                            Fecha l&iacute;mite<sup>1</sup>
                        </span>
                    </td>
                    <td width="135" align="center"><span class="ArialNarrow10N">REUNI&Oacute;N CAAA</span></td>
                    <td width="135" align="center"><span class="ArialNarrow10N">ENTREGA DE CORRESPONDENCIA </span></td>
                    <td width="135" align="center"><span class="ArialNarrow10N">SESI&Oacute;N CTIC </span></td>
                    <td align="center"><span class="ArialNarrow10N">ACTA</span></td>
                </tr>
                <tr>
                    <td colspan="5" align="center">
                        <hr>
                    </td>
                </tr>
                <cfoutput query="tbCatalogoSesiones">
                    <cfset vssnId = #tbCatalogoSesiones.ssn_ID#>
                    <cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM sesiones 
                        WHERE ssn_id = #vssnId# 
                        ORDER BY ssn_clave DESC
                    </cfquery>
                    <tr>
                        <cfloop query="tbSesiones" startrow="1" endrow="1">
                            <td height="30" align="center">
                                <span class="ArialNarrow10">
                                    #LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# 
                                </span>
                            </td>
                        </cfloop>
                        <cfloop query="tbSesiones" startrow="2" endrow="2">
                            <td height="30" align="center">
                                <span class="ArialNarrow10">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</span>
                                <cfif #DAYOFWEEK(tbSesiones.ssn_fecha)# EQ 3><span class="Sans12GrNe">*</span></cfif>
                            </td>
                        </cfloop>
                        <cfloop query="tbSesiones" startrow="3" endrow="3">
                            <td height="30" align="center"><span class="ArialNarrow10">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')# </span></td>
                        </cfloop>
                        <cfloop query="tbSesiones" startrow="4" endrow="4">
                            <td height="30" align="center">
                                <span class="ArialNarrow10">
                                    <cfif IsDate(#tbSesiones.ssn_fecha_m#)>
                                        #LSDateFormat(tbSesiones.ssn_fecha_m,'MMMM dd, yyyy')#
                                    <cfelse>
                                        #LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#
                                    </cfif>
                                </span>
                            </td>
                        </cfloop>
                        <td height="30" colspan="2" align="center">
                            <span class="ArialNarrow10">#LSNUMBERFORMAT(tbSesiones.ssn_id,'9999')#</span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="6" align="center">
                            <hr>
                        </td>
                    </tr>
                </cfoutput>
            </table>
            <p class="ArialNarrow8">
                    * Martes<br />
                    ** Miércoles<br />
                    *** Viernes
			</p>
            <p class="ArialNarrow8">&nbsp;</p>
            <p class="ArialNarrow8"><sup>1</sup> Los documentos se reciben en la Secretar&iacute;a del Consejo T&eacute;cnico hasta las 14:30 hrs. del d&iacute;a se&ntilde;alado como fecha l&iacute;mite.</p>
            <p>&nbsp;</p>
        </body>
    </html>
</cfdocument>
