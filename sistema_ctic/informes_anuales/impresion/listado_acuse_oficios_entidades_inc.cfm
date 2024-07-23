            <cfquery name="tbInformesAnuales" datasource="#vOrigenDatosSAMAA#">
                SELECT 
					T2.acd_prefijo, T2.acd_nombres, T2.acd_apepat, T2.acd_apemat,
                    T3.informe_oficio
                FROM movimientos_informes_anuales AS T1
                LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
				LEFT JOIN movimientos_informes_asunto AS T3 ON T1.informe_anual_id = T3.informe_anual_id AND T3.informe_reunion = 'CTIC'                
                WHERE T1.dep_clave = '#vpDepClave#'
                AND T1.informe_anio = '#vpInformeAnio#'
                AND T3.informe_oficio IS NOT NULL
                AND T3.dec_clave = #vDecClave#
                ORDER BY T3.informe_oficio ASC
            </cfquery>
            
            <cfif #tbInformesAnuales.RecordCount# GT 0>
                <table width="100%">
                    <tr>
                        <td width="20%" align="center"><img src="http://www.cic-ctic.unam.mx:31220/images/iconos/acuse_80.png"   /></td>
                        <td width="50%" align="center" style="font-size:14px" valign="top"><strong>CONSEJO TÉCNICO DE LA INVESTIGACIÓN CIENTÍFICA</strong></td>
                        <td width="30%" align="right" style="font-size:12px" valign="top">
                            <cfoutput>
								<br />
                                <strong>#tbCatalogoEntidad.dep_nombre#</strong>
                                <br />
                                Evaluación de informes #vpInformeAnio#
							  <br />
                                <cfif #vDecClave# EQ 1>
                                	<em><strong>Aprobados</strong></em>
								<cfelseif  #vDecClave# EQ 49>
                                	<em><strong>Aprobados con comentario</strong></em>
								<cfelseif #vDecClave# EQ 4>
									<em><strong>No aprobados</strong></em>
							  </cfif>
								<br />
                            </cfoutput>
                        </td>                	
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <table width="100%">
                                <tr>
                                    <td width="5%" style="border-bottom: 1px solid #000; border-top: 1px solid #000;"></td>
                                    <td width="70%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>NOMBRE</strong></td>
                                    <td width="25%" style="font-size:10px; border-bottom: 1px solid #000; border-top: 1px solid #000;"><strong>OFICIO</strong></td>
                                </tr>
                                <cfoutput query="tbInformesAnuales">
                                    <tr>
                                        <td style="font-size:10px" valign="top">#CurrentRow#</td>
                                        <td style="font-size:10px">#acd_apepat# #acd_apemat# #acd_nombres#</td>
                                        <td style="font-size:10px" valign="top">CJIC/CTIC/#informe_oficio#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                        <td></td>                    
                    </tr>
                </table>
				<!--- Salto de página --->
                <br class="SaltoPagina">                
			</cfif>