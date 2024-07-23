<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 28/10/2010 --->
<!--- FECHA ÚLTIMA MOD.: 09/02/2024 --->

<cfif IsDefined("MM_GuardaReg") AND MM_GuardaReg IS "NUEVO">
	<!--- Construir RFC --->
	<cfset vRfcConcatena = Ucase('#rfcc#' & '#rfcn#' & '#rfch#')>

	<!--- Buscar un académico con el mismo nombre o RFC --->
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
		SELECT
		acd_id, acd_apepat, acd_apemat, acd_nombres, acd_rfc, acd_curp, acd_fecha_nac
		FROM academicos WHERE 
        (
		<cfif Trim(#apepat#) NEQ ''>
	        (acd_apepat LIKE '%#SinAcentos(Ucase(Trim(apepat)),0)#%' OR acd_apemat LIKE '%#SinAcentos(Ucase(Trim(apepat)),0)#%' OR acd_nombres LIKE '%#SinAcentos(Ucase(Trim(apepat)),0)#%')
		</cfif>
		<cfif Trim(#apemat#) NEQ ''>
			<cfif Trim(#apepat#) NEQ ''>
				AND
			</cfif>
	        (acd_apepat LIKE '%#SinAcentos(Ucase(Trim(apemat)),0)#%' OR acd_apemat LIKE '%#SinAcentos(Ucase(Trim(apemat)),0)#%' OR acd_nombres LIKE '%#SinAcentos(Ucase(Trim(apemat)),0)#%')
		</cfif>
		<cfif Trim(#nombres#) NEQ ''>
			<cfif Trim(#apepat#) NEQ '' OR Trim(#apemat#) NEQ ''>
				AND
			</cfif>
	        (acd_apepat LIKE '%#SinAcentos(Ucase(Trim(nombres)),0)#%' OR acd_apemat LIKE '%#SinAcentos(Ucase(Trim(nombres)),0)#%' OR acd_nombres LIKE '%#SinAcentos(Ucase(Trim(nombres)),0)#%')
		</cfif>
        )
		OR acd_rfc = '#vRfcConcatena#'
	</cfquery>

	<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
	</cfquery>

	<!--- Si no se encuentra al académico darlo de alta --->
	<cfif #tbAcademico.RecordCount# EQ 0>
		<!--- NOTA: Llama al codigo que permite guardar los registro nuevos --->
		<cfinclude template="nuevo_academico_guarda.cfm">
	<cfelse>
		<!--- NOTA: Buscar otra manera de avisar al usuario y redireccionar al módulo anterior --->
        <html>
            <head>
                <title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
                <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
                <cfoutput>
	                <link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
    	            <link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
        	        <link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
				</cfoutput>
				<script language="JavaScript" type="text/JavaScript">
                    function fSeleccionaAcademico(vAcadId)
                    {
						document.getElementById('vAcadId').value = vAcadId;
						document.getElementById('cmdSiguente').disabled = '';
						document.getElementById('hidTipoReg').value = vAcadId;
                    }
					function fSubmitFormunario()
					{
						if (document.getElementById('hidTipoReg').value == 'NUEVO')
						{
							document.forms['frmAcdNuevo'].action = 'nuevo_academico_guarda.cfm';
							document.forms['frmAcdNuevo'].submit();
						}
						else
						{
							document.forms['frmAcdSel'].action = document.getElementById('vRutaSubmit').value;
							document.forms['frmAcdSel'].submit();
						}
					}
				</script>
            </head>
            <body>
				<br><br>
				<table width="98%">
					<tr>
						<td width="20%" valign="top">
							<table width="99%" border="0">
                                <tr>
                                    <td><div class="linea_menu"></div></td>
                                </tr>
                                <!-- Men&uacute; -->
                                <tr>
                                    <td valign="top">
                                        <div align="left" class="Sans10NeNe">Men&uacute;:</div>
                                        <input type="hidden" name="hidTipoReg" id="hidTipoReg">
                                    </td>
                                </tr>
                                <!-- Envia datos de academico ya existente -->
                                <tr>
                                    <td>
                                        <cfform name="frmAcdSel" id="frmAcdSel" method="get" action="">
                                            <cfinput name="vFt" id="vFt" type="hidden" value="#vFt#">
											<!--- <cfinput name="vIdSol" id="vIdSol" type="hidden" value="#vIdSol#"> --->
                                            <cfinput name="vAcadId" id="vAcadId" type="hidden" value="">
                                            <cfinput name="vRutaSubmit" id="vRutaSubmit" type="hidden" value="#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#">
                                            <cfinput name="vTipoComando" id="vTipoComando" type="hidden" value="NUEVO">
                                            <cfif #vFt# EQ 5>
                                                <cfinput name="vIdCoa" id="vIdCoa" type="hidden" value="#vIdCoa#">
                                            </cfif>
                                        </cfform>
                                    </td>
                                </tr>
                                <!-- Envia datos académico nuevo -->
                                <tr>
                                    <td>
                                        <cfform name="frmAcdNuevo" id="frmAcdNuevo" method="post" action="">
                                            <cfinput name="vFt" id="vFt" type="hidden" value="#vFt#">
                                            <cfinput name="curp" type="hidden" value="#curp#">
                                            <cfinput name="vRfcConcatena" type="hidden" value="#vRfcConcatena#">
                                            <cfinput name="grado_clave" type="hidden" value="#grado_clave#">
                                            <cfinput name="acd_prefijo" type="hidden" value="#acd_prefijo#">                                    
                                            <cfinput name="apepat" type="hidden" value="#apepat#">
                                            <cfinput name="apemat" type="hidden" value="#apemat#">
                                            <cfinput name="nombres" type="hidden" value="#nombres#">
                                            <cfinput name="fecha_nac" type="hidden" value="#fecha_nac#">
                                            <cfinput name="Sexo" type="hidden" value="#Sexo#">
                                            <cfinput name="pais_clave" type="hidden" value="#pais_clave#">
                                            <cfif #pais_clave# EQ 'MEX'>
	                                            <cfinput name="edo_clave" type="hidden" value="#edo_clave#">
                                            </cfif>
                                            <cfinput name="pais_clave_nacimiento" type="hidden" value="#pais_clave_nacimiento#">
                                            <cfif isdefined('calidad')>
                                                <cfinput name="calidad" type="hidden" value="#calidad#">
                                            <cfelse>
                                                <cfinput name="calidad" type="hidden" value="">
                                            </cfif>							
                                            <cfinput name="dep_clave" type="hidden" value="#dep_clave#">
                                            <cfinput name="dep_ubicacion" type="hidden" value="#dep_ubicacion#">
                                            <cfinput name="email" type="hidden" value="#email#">
                                            <cfif #vFt# EQ 5>
                                                <cfinput name="vIdCoa" type="hidden" value="#vIdCoa#">
                                            </cfif>
                                        </cfform>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="button" name="cmdSiguente" id="cmdSiguente" value="SIGUIENTE" disabled class="botones" onClick="fSubmitFormunario();">
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td><input type="button" name="cmdCancelar" id="button" value="CANCELAR" class="botones" onClick="window.history.go(-1)"></td>
                                </tr>
                            </table>
						</td>
						<td width="80%">
				    	  <span class="Sans12GrNe">
                        		SE HAN DETECTADO COINCIDENCIAS CON EL ACAD&Eacute;MICO QUE VA A DAR DE ALTA:<br>
                        		1. En caso de que sea el mismo nombre de persona, seleccione el  REGISTRO NO MARCADO EN AMARILLO.<br>
								2. En caso contrario seleccione el que captur&oacute; en la pantalla anterior (MARCADO EN AMARILLO Y LETRAS COLOR VINO).</span><br><br><br>
								<table width="95%" cellspacing="0">
                                    <tr bgcolor="#CCCCCC">
										<td height="24"></td>
										<td width="20%"><span class="Sans9GrNe">APELLIDO PATERNO</span></td>
										<td width="20%"><span class="Sans9GrNe">APELLIDO MATERNO</span></td>
										<td width="17%"><span class="Sans9GrNe">NOMBRE(S)</span></td>
										<td width="12%"><span class="Sans9GrNe">RFC</span></td>
										<td width="16%"><span class="Sans9GrNe">CURP</span></td>
										<td width="8%" align="center"><span class="Sans9GrNe">FECHA NACIMIENTO</span></td>
										<td width="7%" align="center"><span class="Sans9GrNe">ID ACADÉMICO</span></td>                            
                                    </tr>
									<cfoutput>
                                        <tr bgcolor="##FFFF99">
                                            <td ><input name="radIdAcademico" type="radio" value="NUEVO" onClick="fSeleccionaAcademico('NUEVO');"></td>
                                            <td><span class="Sans9ViNe">#Ucase(apepat)#</span></td>
                                            <td><span class="Sans9ViNe">#Ucase(apemat)#</span></td>
                                            <td><span class="Sans9ViNe">#Ucase(nombres)#</span></td>
                                            <td><span class="Sans9ViNe">#Ucase(vRfcConcatena)#</span></td>
                                            <td><span class="Sans9ViNe">#Ucase(curp)#</span></td>
                                            <td align="center"><span class="Sans9ViNe">#fecha_nac#</span></td>                                                                                
                                            <td align="center"><span class="Sans9ViNe">NUEVO</span></td>
                                        </tr>
									</cfoutput>
									<cfoutput query="tbAcademico">
										<tr>
											<td><input name="radIdAcademico" type="radio" value="#tbAcademico.acd_id#" onClick="fSeleccionaAcademico(#tbAcademico.acd_id#);"></td>
											<td>#Trim(tbAcademico.acd_apepat)#</td>
											<td>#Trim(tbAcademico.acd_apemat)#</td>
											<td>#Trim(tbAcademico.acd_nombres)#</td>
											<td>#acd_rfc#</td>
											<td>#acd_curp#</td>
											<td align="center">#LsDateFormat(acd_fecha_nac,'dd/mm/yyyy')#</td>
											<td align="center">#Trim(tbAcademico.acd_id)#</td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
					</table>
			</body>
		</html>
	</cfif>
</cfif>
