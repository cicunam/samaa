<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 30/09/2009 --->
<!--- Obtener el siguiente identificador de movimiento disponible --->
<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'MOV';
</cfquery>
<!--- Registrar número de solicitud --->
<cfset vIdMov = #tbContadores.c_movimientos#>
<!--- Obtener el siguiente identificador de solicitud disponible --->
<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'SOL';
</cfquery>
<!--- Registrar número de solicitud --->
<cfset vIdSol = #tbContadores.c_solicitudes#>
<!--- Abrir el formulario de movimientos enviando los parámetros necesarios --->	
<cflocation url="../detalle/movimiento.cfm?vIdAcad=#vIdAcad#&vIdMov=#vIdMov#&vIdSol=#vIdSol#&mov_clave=#vFt#&vTipoComando=NUEVO" addtoken="no">
<!--- NOTA: Si decidimos enviar parámetros particulares segun el tipo de movimientos, entonces utilizar esto:
<cfif #vFt# EQ 5 OR #vFt# EQ 17 OR #vFt# EQ 28>
	<cflocation url="../detalle/movimiento.cfm?vIdAcad=#vIdAcad#&vIdMov=#vIdMov#&mov_clave=#vFt#&vIdCoa=#vIdCoa#&vTipoComando=NUEVO" addtoken="no">
<cfelseif #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 42>
	<cflocation url="../detalle/movimiento.cfm?vIdMov=#vIdMov#&mov_clave=#vFt#&vIdCoa=#vIdCoa#&vTipoComando=NUEVO" addtoken="no">
<cfelseif #vFt# EQ 23 OR #vFt# EQ 32>
	<cflocation url="../detalle/movimiento.cfm#?vIdAcad=#vIdAcad#&vIdMov=#vIdMov#&mov_clave=#vFt#&vFecSaba=#selSaba#&vTipoComando=NUEVO" addtoken="no">	
<cfelseif #vFt# EQ 31 OR #vFt# EQ 35 OR #vFt# EQ 37 >
	<cflocation url="../detalle/movimiento.cfm?vIdAcad=#vIdAcad#&vIdMov=#vIdMov#&mov_clave=#vFt#&vIdMovRel=#selAsunto#&vTipoComando=NUEVO" addtoken="no">	
<cfelse>
	<cflocation url="../detalle/movimiento.cfm?vIdAcad=#vIdAcad#&vIdMov=#vIdMov#&mov_clave=#vFt#&vTipoComando=NUEVO" addtoken="no">
</cfif>
--->
