<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 13/05/2010 --->
<!--- FECHA ULTIMA MOD.: 26/06/2018 --->

		<!--- PAGINA PARA ENVIAR CORREO ELECTRÓNICO A LOS MIEMBROS DE LA CAAA --->

        <cfquery name="tbSesionCaaa" datasource="#vOrigenDatosSAMAA#">
            SELECT TOP 1 ssn_id FROM sesiones 
            WHERE ssn_clave = 4 
            AND ssn_fecha >= GETDATE()
            ORDER BY ssn_id
        </cfquery>
        
        <cfset vSesionActualCaaa = #tbSesionCaaa.ssn_id# >
        
		<cfquery name="tbAsuntos" datasource="#vOrigenDatosSAMAA#">
			SELECT COUNT(*) AS vCuentaAsuntos 
			FROM movimientos_asunto
			WHERE asu_reunion = 'CAAA'
            AND ssn_id = #vSesionActualCaaa#
            AND asu_parte = 1
		</cfquery>

		<cfquery name="ctMiembroCAAA" datasource="#vOrigenDatosSAMAA#">
            SELECT ISNULL(T2.acd_prefijo,'') + ' ' + ISNULL(T2.acd_nombres,'')  + ' ' + ISNULL(T2.acd_apepat,'') AS vNombre, T1.comision_acd_id, T2.acd_email
            ,
            T3.sol_inicio, T3.sol_final
            FROM (academicos_comisiones AS T1
            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
			LEFT JOIN caaa_email AS T3 ON T1.comision_acd_id = T3.comision_acd_id AND T3.ssn_id = #vSesionActualCaaa#
            WHERE (T1.status = 1 AND T1.comision_clave = 1) OR (T1.ssn_id = #vSesionActualCaaa#)
            ORDER BY T2.acd_apepat, T2.acd_apemat DESC
        </cfquery>
            
		<cfform name="frmCorreo" method="post" action="">
            <table width="95%" border="0">
                <tr>
                    <td colspan="3">&nbsp;<cfinput type="#vTipoInput#" id="no_asuntos" name="no_asuntos" value="#tbAsuntos.vCuentaAsuntos#"></td>
                </tr>
                <tr>
                    <td height="18" colspan="3" bgcolor="#E5E5E5"><span class="Sans10GrNe">Para:</span></td>
                </tr>
                <cfoutput query="ctMiembroCAAA">
                    <tr>
                        <td width="80" align="right" valign="top">
                            <cfinput type="checkbox" name="chk#comision_acd_id#" id="chk#comision_acd_id#" value="#comision_acd_id#" onClick="fDelAl(this, '#acd_email#');">
                        </td>
                        <td width="345">
                            <span class="Sans9GrNe">#vNombre#</span><br>
                            <cfif #acd_email# NEQ "">
                                <span class="Sans9ViNe">#acd_email#</span>
                            <cfelse>
                                <span class="Sans9ViNe">NO CUENTA CON CORREO ELECTRÓNICO</span>
                            </cfif>
                        </td>
                        <td width="260" valign="top">
							<span class="Sans9GrNe">Revisar asuntos del </span>
							<cfinput type="text" name="txtIni#comision_acd_id#" class="textos" id="txtIni#comision_acd_id#" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" value="#sol_inicio#" disabled>
							<span class="Sans9GrNe"> al </span>
							<cfinput type="text" name="txtFin#comision_acd_id#" class="textos" id="txtFin#comision_acd_id#" size="3" maxlength="3" onkeypress="return MascaraEntrada(event, '999');" value="#sol_final#" disabled>
						</td>
                    </tr>
                </cfoutput>
            </table>
            <hr />
            <table width="95%" border="0">
                <tr>
                    <td><span class="Sans10GrNe">Asunto:</span></td>
                    <td colspan="2">
                        <cfinput type="text" name="txtAsunto" class="datosJQ" id="txtAsunto" value="Asuntos para reunión de la CAAA (#vSesionActualCaaa#)" size="100" maxlength="254">
                    </td>
                </tr>
                <tr>
                    <td valign="top"><span class="Sans10GrNe">Descripci&oacute;n:</span></td>
                    <td colspan="2" bgcolor="#E5E5E5">
                        <span class="Sans9GrNe">
                        Estimado(a) XXXXXX:
                        <br><br>
                        Por este medio le notifico que los asuntos para la sesión <cfoutput>#vSesionActualCaaa#</cfoutput> que se revisarán en la Comisión de Asuntos Académico-Administrativos se encuentran disponibles. Para acceder a ellos de un click en la siguiente liga:
                        <br><br>
                        LIGA AL SISTEMA DE LA CAAA
						<br><br>o copie y pegue la siguiente liga en el navegador:
                        <br><br>
<!---
                        Los asuntos delegados a CI y/o CD y que le corresponden revisar son del ## al ## y se encuentran marcados con color. Además, en otra pestaña de la página principal se encuentran los asuntos sujetos a decisión del CTIC y en otra los objetados. los que deberán ser analizados por el pleno de la comisión.
                        <br><br>
--->						
                        </span>
                        <cftextarea name="txtDescripcion" id="txtDescripcion" cols="120" rows="6" class="datos"></cftextarea>
                        <br><br>
                        <span class="Sans9GrNe">
                        Sin más por el momento, reciba un cordial saludo.
                        </span>
                    </td>
                </tr>
            </table>
            <div align="center">
				<cfinput type="button" name="Submit" value="Enviar" class="botonesstandar" onClick="vValidaCorreo();">
				<cfinput type="reset" name="Submit" value="Limpiar" class="botonesstandar">
			</div>
		</cfform>
