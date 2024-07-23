<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 17/11/2009 --->
<!------------------------------------->
<!--- CONSULAT DE UNA SOLICITUD HISTÓRICA --->
<!------------------------------------------->

<!--- Obtener información de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_solicitud_historia 
	LEFT JOIN academicos ON movimientos_solicitud_historia.acd_id_firma = academicos.acd_id
    WHERE movimientos_solicitud_historia.sol_id = #vIdSol#
</cfquery>
<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento WHERE mov_clave = #tbSolicitudes.mov_clave#
</cfquery>
<!--- Obtener el HTML de la FT --->
<cfhttp url="#vCarpetaRaizLogicaSistema#/asuntos/solicitudes/#ctMovimiento.mov_ruta#?vTipoComando=CONSULTA&vIdAcad=#tbSolicitudes.sol_pos2#&vFt=#tbSolicitudes.mov_clave#&vSolStatus=0&vIdSol=#vIdSol#&vHistoria=1" method="get" resolveurl="true">
	<cfhttpparam type="COOKIE" name="CFID" value="#cookie.cfid#">
	<cfhttpparam type="COOKIE" name="CFTOKEN" value="#cookie.cftoken#">
</cfhttp>
<!--- Cuerpo de la FT --->
<cfoutput><div style="padding-top:32px">#cfhttp.fileContent#</div></cfoutput>
