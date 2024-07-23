<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 23/08/2017 --->
<!--- FECHA ÚLTIMA MOD.: 09/01/2023 --->


		<cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM samaa_accesos_comisiones
            WHERE ssn_id = #vSesionActualCbp#
            AND asu_reunion = 'CBP'
            AND ssn_clave = 7
		</cfquery>

		<!-- LE ASIGNA EL NÚMERO ALEATORIO PARA VISITAR LA PAGINA DE LA CAAA -->
		<cfif #tbAccesoComisiones.RecordCount# EQ 1>
			<cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
			<cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>

		<cfelseif #tbAccesoComisiones.RecordCount# EQ 0>

			<!--- MÓDULO COMÚN PARA LA GENERACIÓN DE LA LLAVES DINÁMICAS DE LAS LIGAS PARA LAS DIFERENTES COMISIONES --->
			<cfmodule template="#vCarpetaCOMUN#/modulo_genera_claves_acceso.cfm" SsnId="#vSesionActualCbp#" SsnClave="7" SsnDescrip="CBP" OrigenDatos="#vOrigenDatosSAMAA#">

            <cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
                SELECT * FROM samaa_accesos_comisiones
                WHERE ssn_id = #vSesionActualCbp#
                AND asu_reunion = 'CBP'
                AND ssn_clave = 7
            </cfquery>

			<cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
			<cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>            			
		</cfif>

        
		<cfif #CGI.SERVER_PORT# EQ '31221'>
            <cfset vCorreoTo = 'aramp@unam.mx'>
            <cfset vCorreoCc = 'aramp@cic.unam.mx'>
			<cfset vSubjet = ' SD/CBP (#vSesionActualCbp#)'>
            <cfset vLigaAppCBP = '#vCarpetaRaiz#'>
        <cfelse>
            <cfset vCorreoTo = 'sectec_ctic@cic.unam.mx'>
            <cfset vCorreoCc = 'emmanuel@cic.unam.mx'>
			<cfset vSubjet = 'Comisión de Becas Posdoctorales (#vSesionActualCbp#)'>
            <cfset vLigaAppCBP = 'https://sesiones-ctic.cic.unam.mx'>                
        </cfif>
        
		<cfmail type="html" to="#vCorreoTo#" cc="#vCorreoCc#" bcc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="#vSubjet#" username="samaa@cic.unam.mx" password="HeEaSamaa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
			Dar click: <a href="#vLigaAppCBP#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=CBP_#vSesionActualCbp#&vReunionTipo=CBP&vSesionActual=#vSesionActualCbp#" target="WINCAAA">VER ASUNTOS DE LA SESI&Oacute;N #vSesionActualCbp#</a>
            <br /><br />
			o copiar y pegar la liga: #vLigaAppCBP#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=CBP_#vSesionActualCbp#&vReunionTipo=CBP&vSesionActual=#vSesionActualCbp#
		</cfmail>        

        <!-- SELECCIONA LOS ASUINTOS QUE SE DISTRIBUIRAN ENTRE EL MIEMBRO -->
        <cfquery name="tbSolicitudCbp"  datasource="#vOrigenDatosSAMAA#">
            SELECT 
            T1.sol_id  
            ,
			(SELECT COUNT(*) from movimientos_solicitud_comision WHERE sol_id = T1.sol_id AND ssn_id = #vSesionActualCbp#) AS vCuenta
            FROM (movimientos_solicitud AS T1
            LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CAAA')
            WHERE T2.ssn_id = #vSesionActualCbp#
            AND T2.asu_reunion = 'CAAA'
            AND T2.asu_parte = 3.1 
            ORDER BY T1.sol_id
        </cfquery>

        <!-- MARCA EN LA BASE DE DATOS LOS ASUNTOS QUE LE CORRESPONDEN AL MIEMBRO DE LA CAAA -->
        <cfoutput query="tbSolicitudCbp">

            <cfset vSolIdTemp = #sol_id#>
            <cfif #CGI.SERVER_PORT# EQ '31221'>#vClaveAleatorio# - #vSolIdTemp# - #vSesionActualCbp#<br></cfif>

            <cfif #vCuenta# EQ 0>
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    INSERT INTO movimientos_solicitud_comision 
                    (comision_acd_id, sol_id, ssn_id) 
                    VALUES 
                    (#vClaveAleatorio#, #vSolIdTemp#, #vSesionActualCbp#)
                </cfquery>
            </cfif>
		</cfoutput>

<!---        
        <cfquery name="tbCorreosCaaa" datasource="#vOrigenDatosSAMAA#">
            SELECT* FROM caaa_email 
            WHERE ssn_id = #tbSesion.ssn_id# 
            AND comision_acd_id = #vIdAcadCaaa#
        </cfquery>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            <cfif #tbCorreosCaaa.RecordCount# EQ 0>
                INSERT INTO caaa_email 
                (ssn_id, comision_acd_id, acd_id, acd_email, sol_inicio, sol_final, fecha_email) 
                VALUES
                (#vSesionActualCaaa#, #vIdAcadCaaa#, #vAcdId#, '#ctMiembroCAAA.acd_email#', #Evaluate(vAsignaInicio)#, #Evaluate(vAsignaFinal)#, #now()#)
            <cfelseif #tbCorreosCaaa.RecordCount# EQ 1>
                UPDATE caaa_email SET
                sol_inicio = #Evaluate(vAsignaInicio)#
                , 
                sol_final = #Evaluate(vAsignaFinal)#
                ,
                acd_email = '#ctMiembroCAAA.acd_email#'
                ,
                fecha_email = #now()#
                WHERE ssn_id = #tbSesion.ssn_id# 
                AND comision_acd_id = #vIdAcadCaaa#
            </cfif>
        </cfquery>
--->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <title>SAMAA - Liga para Comisión de Becas Posdoctorales</title>
    </head>

    <body>
    	<strong>SE HA ENVIADO UN CORREO ELECTRÓNICO CON LA LIGA DE LOS ASUNTOS A REVISAR POR LA COMISIÓN DE BECAS POSDOCTORALES A LAS SIGUIENTES DIRECCIONES:</strong>
		<cfoutput>
        <br /><br />
        #vCorreoTo#
        <br />
        #vCorreoCc#
        </cfoutput>
    </body>
</html>