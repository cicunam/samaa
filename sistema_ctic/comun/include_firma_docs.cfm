<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/04/2018 --->
<!--- FECHA ÚLTIMA MOD.: 20/03/2024 --->
<!--- INCLUDE ÚNICO PARA OBTENER EL NOMBRE DE LA PERSONA QUE FIRMA LOS DOCUMENTOS A IMPRIMIR EL EL SISTEMA --->


<!--- Obtener el nombre del director, secretario académico para firma de documentos --->
<cfquery name="tbFirma" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.acd_id, T1.acd_prefijo, T1.acd_nombres, T1.acd_apepat, T1.acd_apemat  
    FROM academicos AS T1
	LEFT JOIN academicos_cargos AS T2 ON T1.acd_id = T2.acd_id
	WHERE T2.caa_status = 'A'
	<cfif #Session.sIdDep# EQ '030101' OR #Session.sIdDep# EQ '034201' OR #Session.sIdDep# EQ '034301' OR #Session.sIdDep# EQ '034401' OR #Session.sIdDep# EQ '034501' OR #Session.sIdDep# EQ '034601'>
        AND T2.dep_clave = '030101'
        AND (T2.adm_clave = 100 OR T2.adm_clave = 84) <!--- SE CAMBIÓ LA FIRMA DEL COORDINADOR POR EL SECRETARIO DE INVESTIGACIÓN Y DESARROLLO 03/04/2018 --->
    <cfelse>
        AND T2.dep_clave = '#Session.sIdDep#'
		<cfif IsDefined('vCampoPos1')>
            <cfif #tbSolicitudes.mov_clave# EQ 5>
                AND adm_clave = '32'            
            <cfelse>
			    AND (T2.adm_clave = '11' OR T2.adm_clave = '32' OR T2.adm_clave = '82' OR T2.adm_clave = '84') <!--- SE AGREGÓ AL ENCARGADO(A) DE LA DIRECCION (11) 10/10/2023--->
            </cfif>
		<cfelse>
            <cfif IsDefined('vTipoFirma') AND #vTipoFirma# EQ 'LYC'>
                AND (T2.adm_clave = 32 OR T2.adm_clave = '11') <!--- SE AGREGÓ AL ENCARGADO(A) DE LA DIRECCION (11) 10/10/2023 --->
            <cfelse>
                AND T2.adm_clave = 82
            </cfif>
            AND T2.caa_fecha_inicio <= GETDATE()
		</cfif>
	</cfif>
</cfquery>