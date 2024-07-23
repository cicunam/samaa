					<!--- CREADO: ARAM PICHARDO --->
					<!--- EDITO: ARAM PICHARDO DURÁN --->
					<!--- FECHA CREA: 16/05/2017 --->
					<!--- FECHA ULTIMA MOD.: 20/09/2018 --->

					<!--- LISTA DE SESIONES DEL CTIC --->
					<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
					<cfparam name="PageNum_sesiones" default="1">
					<cfparam name="vpAnio" default="0">
					<cfparam name="vpSesionTipo" default="o">
					<cfparam name="vpSemestre" default="0">

					<cfset vMes = val(LsDateFormat(now(),"mm"))>
					<cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>
                    
					<cfset Session.sTipoSesionCel = #vpSesionTipo#>
					
					<cfquery name="tbCatalogoSesiones" datasource="#vOrigenDatosSAMAA#">
                        SELECT ssn_id FROM sesiones 
                        WHERE (ssn_clave = 1 OR ssn_clave BETWEEN 3 AND 5)
                        <cfif #vpSemestre# EQ 1>
                             AND (MONTH(ssn_fecha) < 9 AND YEAR(ssn_fecha) = #vpAnio#)
                        <cfelseif #vpSemestre# EQ 2>
                             AND (MONTH(ssn_fecha) > 7 AND YEAR(ssn_fecha) = #vpAnio#) OR (MONTH(ssn_fecha) = 1 AND YEAR(ssn_fecha) = #vAnioPost#)
                        <cfelse>
                            AND YEAR(ssn_fecha) = #vpAnio#
                        </cfif>
                        GROUP BY ssn_id
					</cfquery>

					<cfset MaxRows_sesiones=50>
					<cfset StartRow_sesiones=Min((PageNum_sesiones-1)*MaxRows_sesiones+1,Max(tbCatalogoSesiones.RecordCount,1))>
					<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,tbCatalogoSesiones.RecordCount)>
					<cfset TotalPages_sesiones=Ceiling(tbCatalogoSesiones.RecordCount/MaxRows_sesiones)>
					<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
					<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_sesiones=","&")>
					<cfif tempPos NEQ 0>
						<cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
					</cfif>

                    <div align="center">
                        <h3><strong>CALENDARIO DE SESIONES DEL CTIC</strong></h3>
                        <h4><strong>SESIONES ORDINARIAS</strong></h4>
                        <cfoutput>
                        <h4>
                            <cfif #vpSemestre# EQ 1>
                                Enero a Julio de #vpAnio#
                            <cfelseif #vpSemestre# EQ 2>
                                Junio de #vpAnio# a Enero de #vAnioPost#
                            <cfelse>
                                #vpAnio#
                            </cfif>
                        </h4>
                        </cfoutput>
                        <br>
                    </div>
					<br>
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr class="header">
                                <td width="20%" align="center"><strong>Recepci&oacute;n de documentos</strong></td>
                                <td width="20%" align="center"><strong>Reuni&oacute;n de la CAAA</strong></td>
                                <td width="20%" align="center"><strong>Entrega de correspondencia</strong></td>
                                <td width="20%" align="center"><strong>Sesi&oacute;n ordinaria de Pleno</strong></td>
                                <td width="17%" align="center"><strong>Sesi&oacute;n</strong></td>
                            </tr>
                        </thead>
						<tbody>
                            <!-- Datos -->
                            <cfoutput query="tbCatalogoSesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
                                <cfset vssnId = #tbCatalogoSesiones.ssn_ID#>
                                <cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
                                    SELECT * FROM sesiones 
                                    WHERE ssn_id = #vssnId# 
                                    ORDER BY ssn_clave DESC
                                </cfquery>
                                <tr <cfif #tbCatalogoSesiones.ssn_ID# EQ #Session.sSesion#>style="background-color:##FFFFCC; color:##FF3300;"</cfif>>
                                    <cfloop query="tbSesiones" startrow="1" endrow="1">
                                        <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                    </cfloop>
                                    <cfloop query="tbSesiones" startrow="2" endrow="2">
                                        <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                    </cfloop>
                                    <cfloop query="tbSesiones" startrow="3" endrow="3">
                                        <td align="center">#LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#</td>
                                    </cfloop>
                                    <cfloop query="tbSesiones" startrow="4" endrow="4">
                                        <td align="center" <cfif IsDate(#tbSesiones.ssn_fecha_m#)>bgcolor="##FF9900"</cfif>>
											<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
                                                #LSDateFormat(tbSesiones.ssn_fecha_m,'MMMM dd, yyyy')#
                                            <cfelse>
                                                #LSDateFormat(tbSesiones.ssn_fecha,'MMMM dd, yyyy')#
                                            </cfif>
                                        </td>
                                    </cfloop>
                                    <td align="center">#LSNUMBERFORMAT(tbSesiones.ssn_id,'9999')#</td>
                                </tr>
                            </cfoutput>
						</tbody>
                    </table>

