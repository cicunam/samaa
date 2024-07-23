<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/09/2009 --->
<!--- FECHA ÚLTIMA MOD.: 12/11/2019 --->

<!--- Se inicia la varible en cero por detectar error en sol_id de solicitudes con cero --->
<cfset vIdSol = 0>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>


<!--- INCLUDE Obtener el siguiente número de solicitud disponible --->
<cfinclude template="#vCarpetaRaizLogica#/sistema_ctic/comun/include_sol_id_incrementa.cfm">

<!--- ANTERIOR 27/01/2017
<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'SOL';
</cfquery>

<cfif #tbContadores.c_solicitudes# EQ 0 OR  #tbContadores.c_solicitudes# EQ ''>
	<cfloop index="vIntentos" from="1" to="50"> 
		<!--- Obtener el siguiente número de solicitud disponible --->
		<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM contadores;
			EXEC INCREMENTAR_CONTADOR 'SOL';
		</cfquery>
		<cfif #tbContadores.c_solicitudes# GT 0>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>


<!--- Registrar número de solicitud --->
<cfset vIdSol = #tbContadores.c_solicitudes#>
--->

<cfif #vIdSol# GT 0>
	<!--- Si el usuario desea ingresar un nuevo académico --->
	<cfif IsDefined("vSelAcad") AND #vSelAcad# IS 0>
		<cfif #vFt# EQ 5 OR #vFt# EQ 17>
			<cflocation url="#vCarpetaRaizLogicaSistema#/academicos/academico_nuevo/nuevo_academico.cfm?vIdSol=#vIdSol#&vFt=#vFt#&vIdCoa=#vIdCoa#" addtoken="no">
		<cfelse>
			<cflocation url="#vCarpetaRaizLogicaSistema#/academicos/academico_nuevo/nuevo_academico.cfm?vIdSol=#vIdSol#&vFt=#vFt#" addtoken="no">
		</cfif>
		<!--- Abrir la FT correspondiente enviando los parámetros necesarios --->	
	<cfelse>
		<cfif #vFt# EQ 5 OR #vFt# EQ 17 OR #vFt# EQ 28>
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vIdAcad=#vSelAcad#&vFt=#vFt#&vIdCoa=#vIdCoa#&vTipoComando=NUEVO" addtoken="no">
		<cfelseif #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 42>
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vFt=#vFt#&vIdCoa=#vIdCoa#&vTipoComando=NUEVO" addtoken="no">
		<cfelseif #vFt# EQ 23>
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vIdAcad=#vSelAcad#&vFt=#vFt#&vFecSaba=#selSaba#&vTipoComando=NUEVO" addtoken="no">
		<cfelseif #vFt# EQ 32>
            <!--- <cfoutput>#selSaba#</cfoutput> --->
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vIdAcad=#vSelAcad#&vFt=#vFt#&vMovSabId=#selSaba#&vTipoComando=NUEVO" addtoken="no">
		<cfelseif #vFt# EQ 31 OR #vFt# EQ 35 OR #vFt# EQ 37 >
			<cfif FIND('I',#selAsunto#) GT 0>
                <cfset vIdMovRel = #MID(selAsunto,2,LEN(selAsunto))#>
                <cfset vTipoMovRel = 'INF'>
            <cfelseif FIND('I',#selAsunto#) EQ 0>
                <cfset vIdMovRel = #selAsunto#>
                <cfset vTipoMovRel = 'MOV'>
            </cfif>
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vIdAcad=#vSelAcad#&vFt=#vFt#&vIdMovRel=#vIdMovRel#&vTipoMovRel=#vTipoMovRel#&vTipoComando=NUEVO" addtoken="no">	
		<cfelse>
			<cflocation url="../#ctMovimiento.mov_ruta#?vIdSol=#vIdSol#&vIdAcad=#vSelAcad#&vFt=#vFt#&vTipoComando=NUEVO" addtoken="no">
		</cfif>
	</cfif>
<cfelseif #vIdSol# EQ 0>
	<cflocation url="select_ft_acad.cfm" addtoken="no">
</cfif>

