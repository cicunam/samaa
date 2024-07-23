<!--- CREADO: ARAM PICHARDO DURÁN--->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 26/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 19/05/2022 --->
<!--- INCLUDE QUE COMPLEMENTA EL INICIO DE SESIÓN PARA ACCCESAR AL SISTEMAS DE LA CAAA, CBP Y PLENO --->

		<!--- Obtener información del periodo de sesión ordinaria/extraordinaria --->
        <cfquery name="tbSesionActiva" datasource="#vOrigenDatosSAMAA#">
            SELECT T1.ssn_clave, T1.ssn_id, C1.ssn_name_application, C1.ssn_ruta_app 
            FROM sesiones AS T1
            <cfif #vReunionTipo# EQ 'INFANUAL'>            
                LEFT JOIN catalogo_sesion AS C1 ON C1.ssn_clave = 33
            <cfelse>
                LEFT JOIN catalogo_sesion AS C1 ON T1.ssn_clave = C1.ssn_clave
            </cfif>
            <cfif NOT IsDefined('vReunionTipo')>
                WHERE 
				CONVERT(date, T1.ssn_fecha) = '#vAhora#' <!--- (CONVERT(date, T1.ssn_fecha) >= '#vAntes#' AND CONVERT(date, T1.ssn_fecha) <= '#vAhora#') --->
                AND (T1.ssn_clave = 1 OR T1.ssn_clave = 2 OR T1.ssn_clave = 4 OR T1.ssn_clave = 7)
                ORDER BY T1.ssn_fecha DESC
            <cfelse>
                <cfif #vReunionTipo# EQ 'CAAA' OR #vReunionTipo# EQ 'INFANUAL'>
                    WHERE T1.ssn_id = #vSesionActual#
                    AND T1.ssn_clave = 4
					AND CONVERT(date, T1.ssn_fecha) >= '#vAhora#'
				<cfelseif #vReunionTipo# EQ 'PCTIC'>
                    WHERE T1.ssn_id = #vSesionActual#
                    AND (T1.ssn_clave = 1 OR T1.ssn_clave = 2)
					AND CONVERT(date, T1.ssn_fecha) >= '#vAhora#'
				<cfelseif #vReunionTipo# EQ 'CBP'>
                    WHERE T1.ssn_id = #vSesionActual#
                    AND T1.ssn_clave = 7
					AND CONVERT(date, T1.ssn_fecha) >= '#vAhora#'
				<cfelseif #vReunionTipo# EQ 'CEUPEID'>
                    WHERE T1.ssn_id = #vSesionActual#
                    AND T1.ssn_clave = 20
                </cfif>
            </cfif>
        </cfquery>

		<cfoutput>#vReunionTipo# - #tbSesionActiva.RecordCount# - #vAntes# - #vAhora# - #tbSesionActiva.ssn_ruta_app#</cfoutput>

		<cfif #tbSesionActiva.RecordCount# GT 0>
            <cfapplication
            name="#tbSesionActiva.ssn_name_application#"
            applicationTimeout = "#createTimeSpan(1,0,0,0)#"
            sessionManagement = "yes"
            sessionTimeout = "#createTimeSpan(0,1,0,0)#"
            setclientcookies="yes"
            >
        
            <cfset Application.vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>
            <cfset Application.vCarpetaRaizLogica = '#ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#'>

			<cfset Session.sSesion = #tbSesionActiva.ssn_id#>
            
			<cfif #tbSesionActiva.ssn_clave# EQ 1 OR #tbSesionActiva.ssn_clave# EQ 2> <!--- ********** SI HAY SESIÓN ORDINARIA O EXTRAORDINARIA DEL PLENO DEL CTIC ********** --->
                <cfset Session.sLoginSistema = 'pleno'>
                <cfset Session.sTipoSistema = 'samaa_pleno'>
                <cfset Session.sDep = 'pleno'>
			<cfelseif #tbSesionActiva.ssn_clave# EQ 4> <!--- ********** SI HAY COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS (CAAA) ********** --->
				<cfset Session.sLoginSistema = 'caaa'>
                <cfset Session.sTipoSistema = 'samaa_caaa'>
                <cfset Session.sAcadIdCaaa = #vMiembro#>
                <cfset Session.sDep = 'caaa'>

			<cfelseif #tbSesionActiva.ssn_clave# EQ 7> <!--- ********** SI HAY COMISIÓN DE BECAS POSDOCTORALES (CBP) ********** --->
				<cfset Session.sLoginSistema = 'cbp'>
				<cfset Session.sTipoSistema = 'samaa_cbp'>
				<cfset Session.sAcadIdCbp = #vMiembro#>
                <cfset Session.sDep = 'cbp'>
			<cfelseif #tbSesionActiva.ssn_clave# EQ 20> <!--- ********** SI HAY COMISIÓN PARA EVALUACIÓN DE ACADÉMICOS DE AL RAI ********** --->
				<cfset Session.sLoginSistema = 'ceupeid'>
				<cfset Session.sTipoSistema = 'samaa_ceupeid'>
				<cfset Session.sAcadIdRai = #vMiembro#>
                <cfset Session.sDep = 'ceupeid'>
			<cfelseif #tbSesionActiva.ssn_clave# EQ 33> <!--- ********** SI HAY COMISIÓN PARA REVISIÓN DE INFORMES ANUALES (12/15/2022) ********** --->
				<cfset Session.sLoginSistema = 'infanual'>
                <cfset Session.sTipoSistema = 'samaa_infanual'>
                <cfset Session.sAcadIdCaaa = #vMiembro#>
                <cfset Session.sDep = 'infanual'>
			</cfif>
			<cflocation url="#tbSesionActiva.ssn_ruta_app#" addtoken="no">
		<cfelse>
			<cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
		</cfif>
