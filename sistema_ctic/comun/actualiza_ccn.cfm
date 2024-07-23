<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 03/10/2019 --->
<!--- FECHA ULTIMA MOD.: 03/10/2019 --->
<!--- ACTUALIZA LA CATAGORÍA Y NIVEL EN LA SOLICITUD --->

<cfparam name="vSolId" type="integer" default=0>
<cfparam name="vAcadId" type="integer" default=0>

<cfoutput>#vSolId# - #vAcadId#</cfoutput>

<cfif (isValid("integer", #vSolId#) AND #vSolId# GT 0) AND (isValid("integer", #vAcadId#) AND #vAcadId# GT 0)>

	<cfoutput>#vSolId# - #vAcadId#</cfoutput>

    <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
        SELECT fecha_cn, cn_clave
        FROM academicos
        WHERE acd_id = #vAcadId#
    </cfquery>

	<cfset vCn = #tbAcademico.cn_clave#>
	<cfset vFechaCn = #LsDateFormat(tbAcademico.fecha_cn,'dd/mm/yyyy')#>

    <cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_solicitud
        SET
		sol_pos3 = '#vCn#'
        WHERE sol_id = #vSolId#
		AND sol_pos2 = #vAcadId#
    </cfquery>
</cfif>