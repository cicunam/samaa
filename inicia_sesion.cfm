<!--- CREADO: ARAM PICHARDO DURÁN--->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 26/04/2017 --->
<!--- FECHA ÚLTIMA MOD.: 19/05/2022 --->
<!--- INICIA EL ACCEOS AL SISTEMAS DE LA CAAA, CBP, PLENO e INFORMES ANUALES --->

<cfset vAhora = LsDateFormat(#Now()#,'dd/mm/yyyy')>
    
<cfset vAntes = LsDateFormat(#Now()# - 5,'dd/mm/yyyy')>

<cfif NOT IsDefined('vChargesLt') AND NOT IsDefined('vMiembro') AND NOT IsDefined('vReunionTipo')> <!--- CONEXIÓN EXLUSIVO EN LA COORDINACIÓN VALIDANDO POR DIRECCIÓN IP --->

    <cfset vReunionTipo = 'PCTICL'>
	<!--- Valida que la IP de la CIC pueda accesar a la información --->
    <cfquery name="tbDireccionIp" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM samaa_sistema_ip 
        WHERE direccion_ip = '#REMOTE_ADDR#'
		AND status_caaa = 1
		AND status = 1
    </cfquery>

	<cfif #tbDireccionIp.RecordCount# EQ 1>
    	<!--- Llamado a un solo código de acceso (INCLUDE) --->    
		<cfset vMiembro = 0>
		<cfinclude template="includes/include_inicia_sesion.cfm">
    <cfelse>
		<!--- Denegar el acceso --->
        <cfinclude template="includes/include_cierra_sesion_nv.cfm">
		<!--- <cflocation url="http://www.cic.unam.mx" addtoken="no"> --->
	</cfif>

<cfelseif IsDefined('vChargesLt') AND #vChargesLt# NEQ '' AND 
    IsDefined('vMiembro') AND #vMiembro# NEQ 0 AND 
	IsDefined('vReunionTipo') AND 
    (#vReunionTipo# EQ 'CAAA' OR #vReunionTipo# EQ 'CBP' OR #vReunionTipo# EQ 'PCTIC' OR #vReunionTipo# EQ 'INFANUAL')><!--- Si se conecta a través del correo electrónico --->

	<!--- Verificar que se cuente con un número aleatorio para abrir la página --->
	<cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
		SELECT *
		FROM samaa_accesos_comisiones
		WHERE ssn_id = #vSesionActual#
		AND clave_acceso = #vChargesLt#
		AND clave_alfanum = '#vDanFautsQb#'
		AND asu_reunion = '#vReunionTipo#'
	</cfquery>
	
	<cfif #vReunionTipo# EQ 'CAAA'> <!--- ********** ACCESO A LA COMISIÓN DE ASUNTOS ACADÉMICO-ADMINISTRATIVOS (CAAA) ********** --->
		<!--- Verificar el miembro de la comisión al que se asigno para la sesión --->
        <cfquery name="tbCaaaEmail" datasource="#vOrigenDatosSAMAA#">
            SELECT *
            FROM caaa_email
            WHERE ssn_id = #vSesionActual#
			AND comision_acd_id = #vMiembro#
        </cfquery>

        <cfif (#tbAccesoComisiones.RecordCount# EQ 1 AND #tbCaaaEmail.RecordCount# EQ 1) OR (#tbAccesoComisiones.RecordCount# EQ 1 AND #vMiembro# EQ 31101)> <!--- Conceder el acceso --->
			<!--- Llamado a un solo código de acceso (INCLUDE) --->
			<cfinclude template="includes/include_inicia_sesion.cfm">
        <cfelse> <!--- Denegar el acceso --->
			<cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
        </cfif>
    <cfelseif #vReunionTipo# EQ 'PCTIC'> <!--- ********** SI HAY REUNIÓN DEL PLENO ********** --->
        <cfif #tbAccesoComisiones.RecordCount# EQ 1> <!--- Conceder el acceso --->
			<!--- Llamado a un solo código de acceso (INCLUDE) --->
			<cfinclude template="includes/include_inicia_sesion.cfm">
        <cfelseif #tbAccesoComisiones.RecordCount# EQ 0> <!--- Denegar el acceso --->
			<cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
		</cfif>			
    <cfelseif #vReunionTipo# EQ 'CBP'> <!--- ********** SI HAY COMISIÓN DE DE BECAS POSDOCTORALES (CBP) ********** --->
		<cfif #tbAccesoComisiones.RecordCount# EQ 1> <!--- Conceder el acceso --->
			<!--- Llamado a un solo código de acceso (INCLUDE) --->
			<cfinclude template="includes/include_inicia_sesion.cfm">
        <cfelseif #tbAccesoComisiones.RecordCount# EQ 0> <!--- Denegar el acceso --->
			<cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
		</cfif>
    <cfelseif #vReunionTipo# EQ 'INFANUAL'> <!--- ********** SI HAY COMISIÓN DE INFORMES ANYALES (INFA) 12/05/2022 ********** --->
		<cfif #tbAccesoComisiones.RecordCount# EQ 1> <!--- Conceder el acceso --->
			<!--- Llamado a un solo código de acceso (INCLUDE) --->
			<cfinclude template="includes/include_inicia_sesion.cfm">
        <cfelseif #tbAccesoComisiones.RecordCount# EQ 0> <!--- Denegar el acceso --->
			<cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
		</cfif>            
	</cfif>
<cfelseif IsDefined('vChargesLt') AND #vChargesLt# NEQ '' AND 
		  IsDefined('vMiembro') AND  #vMiembro# NEQ 0 AND 
		  IsDefined('vReunionTipo') AND #vReunionTipo# EQ 'CEUPEID'>
	<!--- Verificar que se cuente con un número aleatorio para abrir la página (ACCESO PARA LA COMISIÓN DE EVALUACIÓN DE LA RAI --->
    <cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM samaa_accesos_comisiones
		WHERE ssn_id = #vSesionActual#
        AND clave_acceso = #vChargesLt#
        AND clave_alfanum = '#vDanFautsQb#'
        AND asu_reunion = 'CEUPEID'
    </cfquery>
	<cfif #tbAccesoComisiones.RecordCount# EQ 1> <!--- Conceder el acceso --->
        <!--- Llamado a un solo código de acceso (INCLUDE) --->		
        <cfinclude template="includes/include_inicia_sesion.cfm">
    <cfelseif #tbAccesoComisiones.RecordCount# EQ 0> <!--- Denegar el acceso --->
        <cflocation url="#Application.vCarpetaRaizLogica#" addtoken="no">
    </cfif>
<cfelse>
    <cfinclude template="includes/include_cierra_sesion_nv.cfm">
	<!--- <cflocation url="http://www.cic-ctic.unam.mx" addtoken="no"> --->
</cfif>