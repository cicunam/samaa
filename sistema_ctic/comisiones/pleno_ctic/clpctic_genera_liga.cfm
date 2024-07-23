<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 19/03/2020 --->
<!--- FECHA ÚLTIMA MOD.: 19/03/2020 --->

<cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM samaa_accesos_comisiones
	WHERE ssn_id = #vSesionActualPleno#
	AND asu_reunion = 'PCTIC'
	AND ssn_clave BETWEEN 1 AND 2
</cfquery>

<!-- LE ASIGNA EL NÚMERO ALEATORIO PARA VISITAR LA PAGINA DE LA CAAA -->
<cfif #tbAccesoComisiones.RecordCount# EQ 1>
	<cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
	<cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>
<cfelseif #tbAccesoComisiones.RecordCount# EQ 0>

	<!--- MÓDULO COMÚN PARA LA GENERACIÓN DE LA LLAVES DINÁMICAS DE LAS LIGAS PARA LAS DIFERENTES COMISIONES --->
	<cfmodule template="#vCarpetaCOMUN#/modulo_genera_claves_acceso.cfm" SsnId="#vSesionActualPleno#" SsnClave="1" SsnDescrip="PCTIC" OrigenDatos="#vOrigenDatosSAMAA#">

	<cfquery name="tbAccesoComisiones" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM samaa_accesos_comisiones
		WHERE ssn_id = #vSesionActualPleno#
		AND asu_reunion = 'PCTIC'
		AND ssn_clave BETWEEN 1 AND 2
	</cfquery>

	<cfset vClaveAleatorio = #tbAccesoComisiones.clave_acceso#>
	<cfset vClaveAlfaNum = #tbAccesoComisiones.clave_alfanum#>            			
</cfif>

<cfif IsDefined('vMuestraLiga') AND #vMuestraLiga# EQ 'T'>
	<cfif #CGI.SERVER_PORT# EQ '31221'>
		<cfset vCorreoTo = 'aramp@unam.mx'>
		<cfset vCorreoCc = 'aramp@cic.unam.mx'>
	<cfelse>
		<cfset vCorreoTo = 'bcruz@unam.mx'>
		<cfset vCorreoCc = 'emmanuel@cic.unam.mx'>
	</cfif>

	<cfmail type="html" to="#vCorreoTo#" cc="#vCorreoCc#" bcc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="Liga para Sesión del Pleno (#vSesionActualPleno#)" username="samaa@cic.unam.mx" password="HeEaSamaa%8282" server="smtp.gmail.com" port="465" useSSL="yes">
		Dar click: <a href="#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#" target="WINPCTIC">VER LA SESI&Oacute;N #vSesionActualPleno#</a>
		<br /><br />
		o copiar y pegar la liga: 
		<br /><br />
		#Application.vCarpetaRaiz#/inicia_sesion.cfm?vChargesLt=#vClaveAleatorio#&vDanFautsQb=#vClaveAlfaNum#&vMiembro=PCTIC_#vSesionActualPleno#&vReunionTipo=PCTIC&vSesionActual=#vSesionActualPleno#
	</cfmail>

	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
			<title>SAMAA - Liga para Pleno CTIC</title>
		</head>

		<body>
			<strong>SE HA ENVIADO UN CORREO ELECTRÓNICO CON LA LIGA PARA CONSULTAR LOS ASUNTOS DE LA SESIÓN DEL PLENO DEL CTIC A LAS SIGUIENTES DIRECCIONES:</strong>
			<cfoutput>
				<br /><br />
				#vCorreoTo#
				<br /><br />
				#vCorreoCc#
			</cfoutput>
		</body>
	</html>
</cfif>