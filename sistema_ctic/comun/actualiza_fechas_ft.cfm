<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 14/03/2018 --->
<!--- FECHA ULTIMA MOD.: 14/03/2018 --->
<!--- ACTUALIZA LAS FECHAS PRIMER CONTRATO O DE CATAGORÍA Y NIVEL  --->

<cfparam name="vSolId" default="0">
<cfparam name="vAcadId" default="0">
<cfparam name="vTipoFecha" default="">

<cfif #vSolId# GT 0 AND #vAcadId# GT 0 AND (#vTipoFecha# EQ '1C' OR #vTipoFecha# EQ 'CN')>
	<cfoutput>#vTipoFecha# - #vSolId# - #vAcadId#</cfoutput>

    <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
        SELECT fecha_pc, fecha_cn, fecha_def FROM academicos
        WHERE acd_id = #vAcadId#
    </cfquery>
	<cfset vFechaCn = #LsDateFormat(tbAcademico.fecha_cn,'dd/mm/yyyy')#>
    <cfset vFecha1C = #LsDateFormat(tbAcademico.fecha_pc,'dd/mm/yyyy')#>

    <cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_solicitud
        SET
		<cfif #vTipoFecha# EQ '1C' AND #tbAcademico.fecha_pc# NEQ ''>
			sol_pos7 = '#vFecha1C#'
		<cfelseif #vTipoFecha# EQ 'CN' AND #tbAcademico.fecha_cn# NEQ ''>
			sol_pos4_f = '#vFechaCn#'
		</cfif>
        WHERE sol_id = #vSolId#
        AND sol_pos2 = #vAcadId#
    </cfquery>
</cfif>