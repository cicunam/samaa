<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 09/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 10/0225 --->
<!--- EXTRAE LOS REGISTROS DE ACADÉMICOS REPORTADOS EN EL CISIC PARA INCLUIR EN LOS INFORMES ANUALES --->


<cfif (IsDefined('vpDepClave') AND #vpDepClave# NEQ '') AND (IsDefined('vpInformeAnio') AND #vpInformeAnio# GT 0)>
	<cfquery  name="tbAcademicos" datasource="#vOrigenDatosCISIC#">
    	SELECT * FROM academicos
        WHERE dep_clave = '#vpDepClave#'
        AND captura = '#vpInformeAnio#'
		AND cn_clave IS NOT NULL
	</cfquery>

    <cfquery name="tbInformeAcd" datasource="#vOrigenDatosSAMAA#">
        SELECT TOP 1 informe_anual_id
        FROM movimientos_informes_anuales
        ORDER BY informe_anual_id DESC
    </cfquery> 

	<cfset vInformeAnualId = #tbInformeAcd.informe_anual_id# + 1>
	<cfif #Session.sTipoSistema# EQ 'stctic'>
        <cfset vInformeStatus = 1>
    <cfelse>
        <cfset vInformeStatus = 0>
    </cfif>

	<cfif #tbAcademicos.RecordCount# GT 0>

		<cfoutput query="tbAcademicos">
			<cfset vAcdClave = #acd_clave#>
			<cfset vDepClave = '#dep_clave#'>
			<cfset vCampusClave = '#campus_clave#'>
			<cfset vCnClave = '#cn_clave#'>
			
			<cfquery name="tbInformeAcd" datasource="#vOrigenDatosSAMAA#">
				SELECT acd_id
                FROM movimientos_informes_anuales
				WHERE acd_id = #vAcdClave#
				AND informe_anio = #vpInformeAnio#
			</cfquery>                

<!--- 			#CurrentRow# - #vAcdClave# - #tbInformeAcd.RecordCount#<br/> --->

			<cfif #tbInformeAcd.RecordCount# EQ 0>
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    INSERT INTO movimientos_informes_anuales 
                    (informe_anual_id, acd_id, dep_clave, ubica_clave, cn_clave, dec_clave_ci, informe_anio, informe_status)
                    VALUES
                    (#vInformeAnualId#, #vAcdClave#, '#vDepClave#', '#vCampusClave#', '#vCnClave#', 1, #vpInformeAnio#, #vInformeStatus#)
                </cfquery>
				<cfset vInformeAnualId = #vInformeAnualId# + 1>      
			</cfif>

		</cfoutput>
	</cfif>
    <cfoutput>TOTAL DE REGISTROS IMPORTADOS: #tbAcademicos.RecordCount#</cfoutput>
</cfif>