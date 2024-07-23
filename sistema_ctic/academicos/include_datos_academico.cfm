<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 28/01/2016--->
<!--- FECHA ULTIMA MOD.: 20/06/2022 --->

		<!--- Llama la tabla de ACADEMICO --->
        <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
            SELECT T1.*,
				ISNULL(dbo.TRIM(dbo.SINACENTOS(T1.acd_apepat)), N'') + CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + ISNULL(dbo.TRIM(dbo.SINACENTOS(T1.acd_apemat)), N'') 
                + CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + ISNULL(dbo.TRIM(dbo.SINACENTOS(T1.acd_nombres)), N'') AS nombre_completo_pmn
                ,
                T2.identificador AS cvu
			FROM academicos AS T1 
            LEFT JOIN academicos_identificadores AS T2 ON T1.acd_id = T2.acd_id AND T2.fuente = 'SNI' AND campo_clave = 'CVU'
            WHERE T1.acd_id = #vAcadId#
        </cfquery>
		<cfoutput>
            <input name="con_clave_datos" id="con_clave_datos" type="hidden" value="#tbAcademico.con_clave#" />
            <input name="cn_clave_datos" id="cn_clave_datos" type="hidden" value="#tbAcademico.cn_clave#" />
            <input name="sni_exp_datos" id="sni_exp_datos" type="hidden" value="#tbAcademico.sni_exp#" />
		</cfoutput>