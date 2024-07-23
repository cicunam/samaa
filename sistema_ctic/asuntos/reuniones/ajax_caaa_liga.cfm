<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 07/12/2017 --->
<!--- FECHA ÚLTIMA MOD: 20/01/2023 --->

<cfquery name="tbComisionCaaa" datasource="#vOrigenDatosSAMAA#">
    SELECT T1.*
    FROM samaa_accesos_comisiones AS T1
    LEFT JOIN sesiones AS T2 ON T1.ssn_id = T2.ssn_id AND T2.ssn_clave = 4
    WHERE T1.ssn_id = #Session.AsuntosCAAAFiltro.vActa#
    AND T1.ssn_clave = 4
	AND T2.ssn_fecha >= '#vFechaHoy#'
</cfquery>

<cfquery name="tbComisionCbp" datasource="#vOrigenDatosSAMAA#">
    SELECT T1.*
    FROM samaa_accesos_comisiones AS T1
    LEFT JOIN sesiones AS T2 ON T1.ssn_id = T2.ssn_id AND T2.ssn_clave = 7
    WHERE T1.ssn_id = #Session.AsuntosCAAAFiltro.vActa#
    AND T1.ssn_clave = 7
	AND T2.ssn_fecha >= '#vFechaHoy#'
</cfquery>

<cfif #tbComisionCaaa.RecordCount# EQ 1 OR #tbComisionCbp.RecordCount# EQ 1>
	<br/>
    <div class="linea_menu"></div>
</cfif>
<!--- SE AGREGÓ VARIABLE PARA GENERAR LA LIGA DE ACCESO A SISTEMA DESARROLLO/ HTTPS PRODUCCION 20/01/2023 --->
<cfif #CGI.SERVER_PORT# EQ '31221'>
    <cfset vLigaAppCaaa = '#vCarpetaRaiz#'>
<cfelse>
    <cfset vLigaAppCaaa = 'https://sesiones-ctic.cic.unam.mx'>                                
</cfif>

<!--- En caso de tener registro muestra el link para la Comisión de Asuntos Académico-Administrativos --->
<cfif #tbComisionCaaa.RecordCount# EQ 1>
	<cfset vLigaSesionCaaa = '#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#tbComisionCaaa.clave_acceso#&vDanFautsQb=#tbComisionCaaa.clave_alfanum#&vMiembro=31101&vReunionTipo=CAAA&vSesionActual=#Session.AsuntosCAAAFiltro.vActa#'>
	<br/>
	<a href="<cfoutput>#vLigaSesionCaaa#</cfoutput>" target="winCaaa">
        <div class="divLigaAsuntosCaaa" align="center">                                
            Consultar Asuntos<br/>
            que ver&aacute; la CAAA
        </div>
	</a>
</cfif>

<!--- En caso de tener registro muestra el link para la Comisión de Becas Posdoctorales --->
<cfif #tbComisionCbp.RecordCount# EQ 1>
	<cfset vLigaSesionCaaa = '#vLigaAppCaaa#/inicia_sesion.cfm?vChargesLt=#tbComisionCbp.clave_acceso#&vDanFautsQb=#tbComisionCbp.clave_alfanum#&vMiembro=31101&vReunionTipo=CBP&vSesionActual=#tbComisionCbp.ssn_id#'>
	<br/>
	<a href="<cfoutput>#vLigaSesionCaaa#</cfoutput>" target="winCaaa">
        <div class="divLigaAsuntosCaaa" align="center">                                
            Consultar Asuntos<br/>
            que ver&aacute; la CBP
        </div>
	</a>
</cfif>	




