<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 21/10/2019 --->
<!--- CÓDIGO QUE ORDENA LOS INFOMES DE ACUERDO A LAS ESPECIFICACIONES DE LA ST DEL CTIC --->


<cfif (IsDefined('vpInformeAnio') AND #vpInformeAnio# GT 0) AND #Session.sTipoSistema# EQ 'stctic'>
	<!--- ORDENA LOS ASUNTOS PARA EL LISTOADO DEL PLENO DEL CTIC --->
	<cfif #vpInformeStatus# EQ 3>
        <cfquery  name="tbCatalogoEntidad" datasource="#vOrigenDatosCATALOGOS#">
            SELECT dep_clave, dep_nombre 
            FROM catalogo_dependencias
            WHERE dep_clave LIKE '03%'
            AND dep_status = 1
            AND dep_tipo <> 'PRO'
            ORDER BY dep_orden ASC
        </cfquery>
    
        <cfoutput query="tbCatalogoEntidad">
    
            <cfset vCuentaReg = 0>
            <cfquery  name="tbMovInformeAnual" datasource="#vOrigenDatosSAMAA#">
                SELECT 
                T1.informe_anual_id, T2.dec_clave, T1.dec_clave_ci
                FROM movimientos_informes_anuales AS T1
                LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CTIC'
                LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id
                WHERE T1.informe_anio = '#vpInformeAnio#'
                AND T1.dep_clave = '#dep_clave#'
                AND T2.ssn_id = #vpSsnId#
				AND T2.informe_reunion = 'CTIC'                
                ORDER BY T3.acd_apepat, T3.acd_apemat
            </cfquery>
    
            <!--- APROBADOS --->
            <cfquery name="tbInformesAp" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 1 <!--- SE CAMBIÓ EL CAMPO DE T2.dec_clave a T1.dec_clave_ci 20/05/2019 --->
            </cfquery>
    
            <cfif #tbInformesAp.RecordCount# GT 0> 
                <cfloop query="tbInformesAp">
                    <cfset vCuentaReg = #vCuentaReg# + 1>
					<cfset vInformeId = #tbInformesAp.informe_anual_id#>

                    <cfquery datasource="#vOrigenDatosSAMAA#">
                        UPDATE movimientos_informes_asunto SET
                        asu_numero = #vCuentaReg#
                        WHERE informe_anual_id = #vInformeId#
						AND informe_reunion = 'CTIC'                        
                    </cfquery>
                </cfloop>
            </cfif>
    
            <!--- APROBADOS CON COMENTARIOS --->
            <cfquery name="tbInformesApCom" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 49 <!--- SE CAMBIÓ EL CAMPO DE T2.dec_clave a T1.dec_clave_ci 20/05/2019 --->
            </cfquery>
    
            <cfif #tbInformesApCom.RecordCount# GT 0>
                <cfloop query="tbInformesApCom">
                    <cfset vCuentaReg = #vCuentaReg# + 1>
					<cfset vInformeId = #tbInformesApCom.informe_anual_id#>
                    
                    <cfquery datasource="#vOrigenDatosSAMAA#">
                        UPDATE movimientos_informes_asunto SET
                        asu_numero = #vCuentaReg#
                        WHERE informe_anual_id = #vInformeId#
						AND informe_reunion = 'CTIC'                        
                    </cfquery>
                </cfloop>
            </cfif>
    
            <!--- NO APROBADOS --->
            <cfquery name="tbInformesNoAp" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci = 4 <!--- SE CAMBIÓ EL CAMPO DE T2.dec_clave a T1.dec_clave_ci 20/05/2019 --->
            </cfquery>

            <cfif #tbInformesNoAp.RecordCount# GT 0>
                <cfloop query="tbInformesNoAp">
                    <cfset vCuentaReg = #vCuentaReg# + 1>
					<cfset vInformeId = #tbInformesNoAp.informe_anual_id#>

                    <cfquery datasource="#vOrigenDatosSAMAA#">
                        UPDATE movimientos_informes_asunto SET
                        asu_numero = #vCuentaReg#
                        WHERE informe_anual_id = #vInformeId#
						AND informe_reunion = 'CTIC'                        
                    </cfquery>
                </cfloop>
            </cfif>
    
            <!--- NO EVALUADOS --->
            <cfquery name="tbInformesNoEval" dbtype="query">
                SELECT * FROM tbMovInformeAnual
                WHERE dec_clave_ci BETWEEN 50 AND 60 <!--- SE CAMBIÓ EL CAMPO DE T2.dec_clave a T1.dec_clave_ci 20/05/2019 --->
            </cfquery>
    
            <cfif #tbInformesNoEval.RecordCount# GT 0>
                <cfloop query="tbInformesNoEval">
                    <cfset vCuentaReg = #vCuentaReg# + 1>
					<cfset vInformeId = #tbInformesNoEval.informe_anual_id#>
                    
                    <cfquery datasource="#vOrigenDatosSAMAA#">
                        UPDATE movimientos_informes_asunto SET
                        asu_numero = #vCuentaReg#
                        WHERE informe_anual_id = #vInformeId#
						AND informe_reunion = 'CTIC'
                    </cfquery>
                </cfloop>
            </cfif>
    
        </cfoutput>
	<cfelseif #vpInformeStatus# EQ 2>
		<!--- ORDENA LOS ASUNTOS PARA EL LISTADO DE LA CAAA --->
		<!--- SE RE-ORDENARON LOS ASUNTOS; PRIMERO LOS AP/COMENTARIO Y DESPUÉS LOS NO APROBADOS (02/05/2018) --->

        <cfquery  name="tbInformesCaaa" datasource="#vOrigenDatosSAMAA#">
            SELECT 
            T1.informe_anual_id, T2.dec_clave, T1.dec_clave_ci
            FROM movimientos_informes_anuales AS T1
			LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CAAA'
            LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id
            LEFT JOIN catalogo_dependencia AS C1 ON T1.dep_clave = C1.dep_clave
            WHERE T1.informe_anio = '#vpInformeAnio#'
			AND T2.informe_reunion = 'CAAA'            
            ORDER BY C1.dep_orden, T1.dec_clave_ci DESC, T3.acd_apepat, T3.acd_apemat
		</cfquery>   

        <cfquery  name="tbInformesCaaaApC" dbtype="query">
			SELECT * FROM tbInformesCaaa
            WHERE dec_clave = 49
		</cfquery>
        <!--- APROBADOS CON COMNETARIO --->
		<cfset vCuentaReg = 0>        
		<cfif #tbInformesCaaaApC.RecordCount# GT 0>
            <cfloop query="tbInformesCaaaApC">
                <cfset vCuentaReg = #vCuentaReg# + 1>
                <cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
					asu_numero = #vCuentaReg#
					WHERE informe_anual_id = #tbInformesCaaaApC.informe_anual_id#
					AND informe_reunion = 'CAAA'
                </cfquery>
            </cfloop>
        </cfif>

        <!--- NO APROBADOS --->
        <cfquery  name="tbInformesCaaaNA" dbtype="query">
			SELECT * FROM tbInformesCaaa
            WHERE dec_clave = 4
		</cfquery>

		<cfset vCuentaReg = 0>
		<cfif #tbInformesCaaaNA.RecordCount# GT 0>
            <cfloop query="tbInformesCaaaNA">
                <cfset vCuentaReg = #vCuentaReg# + 1>
                <cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
					asu_numero = #vCuentaReg#
					WHERE informe_anual_id = #tbInformesCaaaNA.informe_anual_id#
					AND informe_reunion = 'CAAA'
                </cfquery>
            </cfloop>
        </cfif>        
	</cfif>        
</cfif>	