<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 12/05/2022 --->
<!--- FECHA ÚLTIMA MOD.: 12/05/2022 --->
<!---  FRAME LATERAL QUE INCLUYE LA PANTALLA DE LA INFORMACIÓN DE LA SOLICITUD --->
<!--------------------------------------------------->

<!--- Obtener datos del Académico --->
<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos
	WHERE acd_id= #vAcdId#
</cfquery>

<cfquery name="tbProduccion" datasource="#vOrigenDatosCISIC#">
	SELECT * FROM academicos_numeros
	WHERE acd_clave= #vAcdId#
    ORDER BY captura DESC
</cfquery>
<!---
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta charset="charset=iso-8859-1">
        <meta http-equiv="Content-Type" content="text/html" />
        <title>Documento sin título</title>
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    </head>

    <body>
    
        <div class="modal-dialog">
            <div class="modal-content">
--->            
                <!-- Modal content-->
                <cfoutput query="tbAcademico">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title"><strong>#Trim(acd_apepat)# #Trim(acd_apemat)# #Trim(acd_nombres)#</strong></h4>
                    </div>
                </cfoutput>                    
                <div class="modal-body">
                    <h5><strong>PRODUCCI&Oacute;N CIENT&Iacute;FICA PRIMARIA</strong></h5>
                    <cfif #tbProduccion.RecordCount# GT 0>
                        <hr />
                        <table width="100%" class="table table-striped">
                            <thead>
                                <tr class="header">
                                    <td class="small" width="15%"><strong>A&Ntilde;O</strong></td>
                                    <td class="small" width="10%" title="Sin producci&oacute;n durante el a&ntilde;o"><strong>S.P.</strong></td>
                                    <td class="small" width="10%" title="Art&iacute;culos indizados internacionales"><strong >A.I.I</strong></td>
                                    <td class="small" width="10%" title="Art&iacute;culos indizados nacionales"><strong>A.I.N</strong></td>
                                    <td class="small" width="10%" title="Cap&iacute;tulos en libros"><strong>C.L.</strong></td>
                                    <td class="small" width="10%" title="Libros publicados"><strong>L.P.</strong></td>
                                    <td class="small" width="10%" title="Graduados de licenciatura"><strong>G.L.</strong></td>
                                    <td class="small" width="10%" title="Graduados de maestr&iacute;a"><strong>G.M.</strong></td>
                                    <td class="small" width="10%" title="Graduados de doctorado"><strong>G.D.</strong></td>
                                </tr>
                            </thead>
                            <cfoutput query="tbProduccion">
                                <tr>
                                    <td class="small" valign="top"><cfif #captura# EQ '0610'>2006 al 2010<cfelse>#captura#</cfif></td>
                                    <td class="small" valign="top"><cfif #sin_produccion# EQ 1><span class="glyphicon glyphicon-asterisk"></span></cfif></td>
                                    <td class="small" valign="top"><cfif #art_ind_int# GT 0>#art_ind_int#</cfif></td>
                                    <td class="small" valign="top"><cfif #art_ind_nac# GT 0>#art_ind_nac#</cfif></td>
                                    <td class="small" valign="top"><cfif #cap_libros# GT 0>#cap_libros#</cfif></td>
                                    <td class="small" valign="top"><cfif #libros# GT 0>#libros#</cfif></td>
                                    <td class="small" valign="top"><cfif #graduado_l# GT 0>#graduado_l#</cfif></td>
                                    <td class="small" valign="top"><cfif #graduado_m# GT 0>#graduado_m#</cfif></td>
                                    <td class="small" valign="top"><cfif #graduado_d# GT 0>#graduado_d#</cfif></td>
                                </tr>
                            </cfoutput>
                        </table>
                    </cfif>
                </div>
                <div class="modal-footer">
						<cfif CGI.SERVER_PORT IS "31220">
							<cfset vLigaInformacionAcad = 'http://www.cic-ctic.unam.mx:31220/consultas/academicos/valida_academico.cfm'>
						<cfelse>
							<cfset vLigaInformacionAcad = 'http://www.cic-ctic.unam.mx:31221/consultas/aram/academicos/valida_academico.cfm'>
						</cfif>
						<cfform id="frmInfAcad" method="post" action="#vLigaInformacionAcad#" target="winConsultas">
							<div class="divInformacionAcad">
								<cfinput type="hidden" id="acdid" name="acdid" value="#vAcdId#">
								<cfinput type="hidden" id="vpSistemaAcceso" name="vpSistemaAcceso" value="#ToBase64('SAMAA.CAAA.INFANUAL')#">
								<cfinput type="hidden" id="vpSistemaPass" name="vpSistemaPass" value="#ToBase64('?31101$Cic8282StsSamaaInf!')#">
							</div>
						</cfform>					
                    <button type="button" class="btn btn-primary"  onclick="fInformacionAcad();">Consultar detalle de productividad</button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </body>
</html>
<script language="JavaScript" type="text/JavaScript">
	function fInformacionAcad()
	{
		document.forms['frmInfAcad'].submit();
	}
</script>