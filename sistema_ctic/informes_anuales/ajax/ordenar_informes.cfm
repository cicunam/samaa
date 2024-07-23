<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 08/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 08/03/2017 --->
<!--- CÓDIGO QUE ORDENA LOS INFOMES DE ACUERDO A LAS ESPECIFICACIONES DE LA ST DEL CTIC --->


<cfif (IsDefined('vpInformeAnio') AND #vpInformeAnio# GT 0) AND #Session.sTipoSistema# EQ 'stctic'>
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
            T1.informe_anual_id, T2.dec_clave
            FROM movimientos_informes_anuales AS T1
			LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id
			LEFT JOIN academicos AS T3 ON T1.acd_id = T3.acd_id
            WHERE T1.informe_anio = '#vpInformeAnio#'
            AND T1.dep_clave = '#dep_clave#'
            ORDER BY T3.acd_apepat, T3.acd_apemat
        </cfquery>

        <!--- APROBADOS --->
        <cfquery name="tbInformesAp" dbtype="query">
            SELECT * FROM tbMovInformeAnual
            WHERE dec_clave = 1
        </cfquery>
        <cfif #tbInformesAp.RecordCount# GT 0> 
            <cfloop query="tbInformesAp">
                <cfset vCuentaReg = #vCuentaReg# + 1>
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
                    asu_numero = #vCuentaReg#
                    WHERE informe_anual_id = #tbInformesAp.informe_anual_id#
				</cfquery>
            </cfloop>
        </cfif>

        <!--- APROBADOS CON COMENTARIOS --->
        <cfquery name="tbInformesApRec" dbtype="query">
            SELECT * FROM tbMovInformeAnual
            WHERE dec_clave = 49
        </cfquery>
        <cfif #tbInformesApRec.RecordCount# GT 0>
            <cfloop query="tbInformesApRec">
                <cfset vCuentaReg = #vCuentaReg# + 1>
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
                    asu_numero = #vCuentaReg#
                    WHERE informe_anual_id = #tbInformesApRec.informe_anual_id#
				</cfquery>
            </cfloop>
        </cfif>

        <!--- NO APROBADOS --->
        <cfquery name="tbInformesNoAp" dbtype="query">
            SELECT * FROM tbMovInformeAnual
            WHERE dec_clave = 4
        </cfquery>
        <cfif #tbInformesNoAp.RecordCount# GT 0>
            <cfloop query="tbInformesNoAp">
                <cfset vCuentaReg = #vCuentaReg# + 1>
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
                    asu_numero = #vCuentaReg#
                    WHERE informe_anual_id = #tbInformesNoAp.informe_anual_id#
				</cfquery>
            </cfloop>
        </cfif>

        <!--- NO EVALUADOS --->
        <cfquery name="tbInformesNoEval" dbtype="query">
            SELECT * FROM tbMovInformeAnual
            WHERE dec_clave > 49
        </cfquery>
        <cfif #tbInformesNoEval.RecordCount# GT 0>
            <cfloop query="tbInformesNoEval">
                <cfset vCuentaReg = #vCuentaReg# + 1>
				<cfquery datasource="#vOrigenDatosSAMAA#">
					UPDATE movimientos_informes_asunto SET
                    asu_numero = #vCuentaReg#
                    WHERE informe_anual_id = #tbInformesNoEval.informe_anual_id#
				</cfquery>
            </cfloop>
        </cfif>
    </cfoutput>
</cfif>	