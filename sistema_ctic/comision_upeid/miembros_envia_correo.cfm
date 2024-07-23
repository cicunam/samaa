<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 16/03/2018 --->
<!--- FECHA ULTIMA MOD.: 16/03/2018 --->
<!--- ENVIA EL CORREO ELECTRÓNICO AL PEROSNAL DE LA SID PARA LA COMISIÓN ESPECIAL DE LA UPEID ASIGNANDO --->

<cfparam name="vpSesionIdCeUpeid" default="0">
<cfif #vpSesionIdCeUpeid# GT 0>
    <cfquery name="tbSesion" datasource="#vOrigenDatosSAMAA#">
        SELECT TOP 1 * FROM sesiones 
        WHERE ssn_clave = 20 
        AND ssn_id  = #vpSesionIdCeUpeid#
        ORDER BY ssn_id
    </cfquery>
    
    <cfif #tbSesion.RecordCount# EQ 1>
    
        <cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM samaa_accesos_comisiones
            WHERE ssn_id = #vpSesionIdCeUpeid#
            AND asu_reunion = 'CEUPEID'
            AND ssn_clave = 20
        </cfquery>
        
        <cfif #tbAccesoComisiones.RecordCount# EQ 1>
            <cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
            <cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>
        <cfelseif #tbAccesoComisiones.RecordCount# EQ 0>
        
            <cfset vClaveAleatorio = 0>
            <cfset vClaveAlfaNum = 0>
        </cfif>
    
    
        <cfif #CGI.SERVER_PORT# EQ '31221'>
            <cfset vCorreoTo = 'aramp@unam.mx'>
            <cfset vCorreoCc = 'aramp@cic.unam.mx, aramp@msn.com'>
        <cfelse>
            <cfset vCorreoTo = 'saniger@cic.unam.mx'>
            <cfset vCorreoCc = 'fernanda@cic.unam.mx, edgar@cic.unam.mx'>
        </cfif>
		<cfset vFechaLargaComision = "#LsDateFormat(tbSesion.ssn_fecha,'dd')# de #LsDateFormat(tbSesion.ssn_fecha,'mmmm')# de #LsDateFormat(tbSesion.ssn_fecha,'yyyy')#">
        
        <cfmail type="html" to="#vCorreoTo#" cc="#vCorreoCc#" bcc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="Liga asuntos Comision Especial de la UPEID #vFechaLargaComision#" server="correo.cic.unam.mx" username="samaa" password="QQQwww123" spoolenable="yes">
            Estimado(a) usuario(a):<br>
            <br>
            Anexo encontrar&aacute; las ligas para el acceso a los asuntos a revisar por los miembros de la Comisi&oacute;n Especial de la UPEID del #vFechaLargaComision#:
            <br><br>
            <a href="#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=&vReunionTipo=CEUPEID&vSesionActual=#vpSesionIdCeUpeid#" target="WINCAAA">DAR CLICK A ESTE ENLACE</a>
            <br><br>o copie y pegue la siguiente liga en el navegador:
            <br><br>#Application.vCarpetaRaiz#/inicia_sesion.cfm.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=&vReunionTipo=CEUPEID&vSesionActual=#vpSesionIdCeUpeid#
            <br><br>
            Sin m&aacute;s por el momento, reciban un cordial saludo.
        </cfmail>
        EL CORREO HA SIDO ENVIADO
    </cfif>
</cfif>    