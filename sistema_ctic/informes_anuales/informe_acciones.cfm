<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 31/05/2017 --->
<!--- FECHA ÚLTIMA MOD: 14/02/2022 --->
<!--- CÓDIGO QUE PERMITE ACTUALIZAR LA INFORMACIÓN DE LA TABLA --->

<!---
	<cfparam name="vTipoComando" default="0">
	<cfparam name="informe_anual_id" default="0">    
--->
    <cfif IsDefined('vTipoComando') AND IsDefined('informe_anual_id') AND #informe_anual_id# GT 0>
		<cfif #vTipoComando# EQ  'GUARDA'>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE movimientos_informes_anuales SET
                cn_clave = '#cn_clave#'
                ,
				dec_clave_ci = #dec_clave#
                <cfif #dec_clave# EQ 4 OR #dec_clave# EQ 49>
					<cfif #informe_anio# GTE '2016'>
                        ,
                        comentario_clave_ci = <cfif IsDefined('comentario_clave_ci') AND #comentario_clave_ci# NEQ ''>#comentario_clave_ci#<cfelse>NULL</cfif>
					</cfif>
					,comentario_texto_ci = <cfif IsDefined('comentario_texto_ci')>'#comentario_texto_ci#'<cfelse>NULL</cfif>
				<cfelse>
                	,
                    comentario_clave_ci = NULL
                </cfif>
                <cfif #informe_status# EQ 3 AND (#dec_clave# EQ 4 OR #dec_clave# EQ 49)><!--- SI CAMBIA DE DECISIÓN DEL CI Y YA ESTÁ ASIGNADA A UNA SESIÓN DEL CTIC: SI CAMBIA DE APROBAR A AP-Comentario / NO APROBAR GENERA UN ASUNTO EN LA CAAA --->
                    , informe_status = 2
                <cfelseif #informe_status# EQ 2 AND #dec_clave# EQ 1><!--- SI CAMBIA DE AP-COMENTARIO / NO APROBAR A APROBAR SE ELIMINA EL ASUNTO CAAA --->
                    , informe_status = 3                    
                </cfif>
                WHERE informe_anual_id = #informe_anual_id#
			</cfquery>

			<cfif #informe_status# EQ 3 AND (#dec_clave# EQ 4 OR #dec_clave# EQ 49)><!--- SI CAMBIA DE DECISIÓN DEL CI Y YA ESTÁ ASIGNADA A UNA SESIÓN DEL CTIC: SI CAMBIA DE APROBAR A AP-Comentario / NO APROBAR GENERA UN ASUNTO EN LA CAAA --->
                <cfquery name="tbAsuntoConsulta" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM movimientos_informes_asunto
                    WHERE informe_anual_id = #informe_anual_id#
                    AND informe_reunion = 'CAAA'
                </cfquery>
                <cfif #tbAsuntoConsulta.RecordCount# EQ 0>
	                <cfquery datasource="#vOrigenDatosSAMAA#">
    	            	INSERT INTO movimientos_informes_asunto
                        (informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave)
                        VALUES
                        (#informe_anual_id#, 'CAAA', #ssn_id#, 3.3, #asu_numero#, #dec_clave#)
                        ;
                        DELETE movimientos_informes_asunto
                        WHERE informe_anual_id = #informe_anual_id#
                        AND informe_reunion = 'CTIC'
                        ;
					</cfquery>
                </cfif>
    			
            <cfelseif #informe_status# EQ 2 AND #dec_clave# EQ 1><!--- SI CAMBIA DE AP-COMENTARIO / NO APROBAR A APROBAR SE ELIMINA EL ASUNTO CAAA --->
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    INSERT INTO movimientos_informes_asunto
                    (informe_anual_id, informe_reunion, ssn_id, asu_parte, asu_numero, dec_clave)
                    SELECT informe_anual_id, 'CTIC', ssn_id, asu_parte, asu_numero, 1
					FROM movimientos_informes_asunto
                    WHERE informe_anual_id = #informe_anual_id#
                    AND informe_reunion = 'CAAA'
                    ;
                    DELETE movimientos_informes_asunto
                    WHERE informe_anual_id = #informe_anual_id#
                    AND informe_reunion = 'CAAA'
                    ;
                </cfquery>
            </cfif>
           
            <cflocation url="informe.cfm?vInformeAnualId=#informe_anual_id#&vTipoComando=CONSULTA" addtoken="no">            
		<cfelseif #vTipoComando# EQ  'ELIMINA'>
			<!--- <cfoutput>#vTipoComando# - #vInformeAnualId#</cfoutput> --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
				DELETE FROM movimientos_informes_anuales
                WHERE informe_anual_id = #informe_anual_id#
			</cfquery>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				DELETE FROM movimientos_informes_asunto
                WHERE informe_anual_id = #informe_anual_id#
			</cfquery>
            <cflocation url="consulta_informes.cfm?vInformeStatus=#Session.InformesFiltro.vInformeStatus#" addtoken="no">
		</cfif>
	</cfif>