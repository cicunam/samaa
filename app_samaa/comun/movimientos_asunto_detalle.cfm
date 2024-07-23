<!--- CREADO: ARAM PICHARDO --->
<!--- CREADO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 18/05/2017 --->
<!--- VENTANA EMERGENTE PARA DESPLEGAR POR JQUERY EL ASUNTO DEL MOVIMIENTO / INFORME ANUAL (ASUNTO SON LOS DATOS DE LA SESIÓN, LA PARTE, EL NÚMERO DE ASUNTO--->

<!--- Obtener los datos de un MOVIMIENTO --->
<cfquery name="tbAsuntos" datasource="#vOrigenDatosSAMAA#">
	<cfif #vpTipoAsunto# EQ 'MOV' OR #vpTipoAsunto# EQ 'SOL'>
		SELECT *, asu_reunion AS reunion, asu_oficio AS oficio, asu_comentario AS comentario
		FROM movimientos_asunto
		WHERE id = #vpAsuntoId#
	<cfelseif  #vpTipoAsunto# EQ 'INF'>
        SELECT *, informe_reunion AS reunion, informe_oficio AS oficio, comentario_texto AS comentario
		FROM movimientos_informes_asunto
        WHERE id = #vpAsuntoId#
	</cfif>
</cfquery>

<!--- --->
<cfquery name="ctListadoParte" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_listado
    WHERE parte_status = 1
    ORDER BY parte_numero
</cfquery>

<!--- Obtener datos del catálogo RECOMNEDACIONES / DECICIONES de movimientos --->
<cfquery name="ctDecision" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_decision
	<cfif #vpTipoAsunto# EQ 'SOL'>
        <cfswitch expression="#vFt#">
            <!--- Asuntos que reciben recomendación de RATIFICAR --->
            <cfcase value="5,7,8,9,10,15,17,18,19,28">
                WHERE dec_descrip NOT LIKE '%APROBAR%'
            </cfcase>
            <!--- Asuntos que reciben recomendación de APROBAR --->
            <cfdefaultcase>
                WHERE dec_descrip NOT LIKE '%RATIFICAR%'
            </cfdefaultcase>
        </cfswitch>
	<cfelseif #vpTipoAsunto# EQ 'INF'>
		<cfif #vpInformeStatus# LTE 2>
	    	WHERE dec_marca_ci = 1
		</cfif>
	</cfif>
	ORDER BY dec_orden
</cfquery>

	<!--- JQUERY --->
    <script language="JavaScript" type="text/JavaScript">
        $(function() {
           $('#cmdAsuntoGuarda').click(function(){
                $.ajax({
                    url: "../comun/movimientos_asunto_guarda.cfm",
                    type:'POST',
                    //async: false,
                    data: new FormData($('#frmAsunto')[0]),
                    processData: false,
                    contentType: false,
                    success: function(data) {
						//alert(data);
						location.reload();
                    },					
                    error: function(data) {
                        alert('ERROR AL AGREGAR ASUNTO');
    //					location.reload();
                    },
                });
            });
        });
    </script>
	<cfform name="frmAsunto">
        <table width="100%" border="0"><!--  class="cuadros" bgcolor="#EEEEEE" -->
            <!-- Encabezado -->
            <tr bgcolor="#CCCCCC">
                <td colspan="3">
                    <div align="center"><span class="Sans12GrNe">SESI&Oacute;N <cfif #tbAsuntos.reunion# EQ 'CTIC'>ORDINARIA DEL PLENO<cfelse>DE LA CAAA</cfif></span></div>
					<cfinput type="text" name="vRegistroId" id="vpRegistroId" value="#vpRegistroId#">
					<cfinput type="text" name="vAsuntoId" id="vpAsuntoId" value="#vpAsuntoId#">
					<cfinput type="text" name="vTipoAsunto" id="vpTipoAsunto" value="#vpTipoAsunto#">
                </td>
            </tr>
            <tbody>
                <tr>
                    <td colspan="4" height="5"></td>
                </tr>
                <tr>
                    <td width="20%"><span class="FormularioTexto">Reunión</span></td>
                    <td width="80%" colspan="2">
                        <select name="reunion" id="reunion" class="datosJQ" <cfif (#vFt# IS 31 OR #vFt# IS 40 OR  #vFt# IS 41) OR #vpAsuntoId# GT 0>disabled</cfif>>
							<option value="CAAA" <cfif #tbAsuntos.reunion# EQ 'CAAA'>selected</cfif>>COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS</option>
							<option value="CTIC" <cfif #tbAsuntos.reunion# EQ 'CTIC'>selected</cfif>>PLENO DEL CONSEJO TÉCNICO</option>
                        </select>
                    </td>
                </tr>                
				<!-- Número de sesión -->
                <tr>
                    <td width="20%"><span class="FormularioTexto">Número de sesión</span></td>
                    <td width="80%" colspan="2">
                        <cfinput name="ssn_id" id="ssn_id" type="text" size="4" maxlenght="4" value="#tbAsuntos.ssn_id#" class="datosJQ" onkeypress="return MascaraEntrada(event, '9999');">
                    </td>
                </tr>
                <!-- Secci&oacute;n en el listado -->
                <tr>
                    <td width="20%"><span class="FormularioTexto">Secci&oacute;n en el listado</span></td>
                    <td width="80%" colspan="2">
                        <select name="asu_parte" id="asu_parte" class="datosJQ" <cfif #vFt# IS 31 OR #vFt# IS 40 OR #vFt# IS 41>disabled</cfif>>
                            <cfoutput query="ctListadoParte">
                                <option value="#parte_numero#" <cfif #Val(tbAsuntos.asu_parte)# EQ '#parte_numero#'>selected</cfif>>#parte_romano#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
                <!-- N&uacute;mero de asunto -->
                <tr>
                    <td><span class="FormularioTexto">N&uacute;mero de asunto</span></td>
                    <td>
                        <cfoutput>
                            <input name="asu_numero" id="asu_numero" type="text" size="3" maxlenght="3" value="#tbAsuntos.asu_numero#" class="datosJQ" onchange="fActualizaControl('AsuntoCTIC');">
                        </cfoutput>
                    </td>
                </tr>
                <!-- Decisi&oacute;n del CTIC -->
                <tr>
                    <td><span class="FormularioTexto">Decisi&oacute;n del CTIC</span></td>
                    <td>
                        <select name="dec_clave" id="dec_clave" class="datosJQ" <cfif #vFt# IS 31 OR #vFt# IS 40 OR #vFt# IS 41>disabled</cfif>>
                            <cfoutput query="ctDecision">
                                <option value="#dec_clave#" <cfif #Val(tbAsuntos.dec_clave)# EQ '#dec_clave#'>selected</cfif>>#dec_descrip#</option>
                            </cfoutput>
                        </select>
    <!---
                        <cfselect name="vDecCTIC" id="vDecCTIC" class="datos100" query="ctDecision" value="dec_clave" display="dec_descrip" selected="#tbAsuntosCTIC.dec_clave#" queryPosition="below" onchange="fActualizaControl('DecCTIC');" disabled>
                            <option value="" selected="selected">NINGUNA</option>
                        </cfselect>
    --->					
                    </td>
                </tr>
                <cfif #tbAsuntos.reunion# EQ 'CTIC'>
                    <!-- N&uacute;mero de oficio -->
                    <tr>
                        <td><span class="FormularioTexto">N&uacute;mero de oficio</span></td>
                        <td>
                            <cfoutput>
                                <input type="text" name="oficio" id="oficio" value="#tbAsuntos.oficio#" class="datosJQ">
                            </cfoutput>
                        </td>
                        <!-- Fecha del oficio -->
                    </tr>
                    <cfif (#vpTipoAsunto# EQ 'MOV' OR #vpTipoAsunto# EQ 'SOL') AND #vFt# IS 31>
                        <tr>
                            <td><span class="FormularioTexto">Fecha del oficio &nbsp;&nbsp;&nbsp;</span></td>
                            <td>
                                <cfoutput>
                                    <input type="text" name="vFechaOficio" id="vFechaOficio" size="10" value="#LsDateFormat(tbAsuntos.fecha_oficio,'dd/mm/yyyy')#" class="datosJQ" onkeypress="return MascaraEntrada(event, '99/99/9999');">
                                </cfoutput>
                            </td>
                        </tr>
                    </cfif>
                <cfelse>
                    <!-- N&uacute;mero de oficio -->
                    <tr>
                        <td><span class="FormularioTexto">Comentario</span></td>
                        <td>
                            <cfoutput>
                                <textarea id="vComentario" name="vComentario" cols="100" rows="3"  r="r" class="datosJQ">#tbAsuntos.comentario#</textarea>
                            </cfoutput>
                        </td>
                        <!-- Fecha del oficio -->
                    </tr>				            
                </cfif>
            </tbody>
        </table>
        <div align="center">
			<div style="width:25%"><cfinput type="button" id="cmdAsuntoGuarda" name="cmdAsuntoGuarda" value="Guardar" class="botones" onClick=""></div>
		</div>
	</cfform>