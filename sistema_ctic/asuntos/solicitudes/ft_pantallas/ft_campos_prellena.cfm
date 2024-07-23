<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 12/02/2024 --->
<!--- FECHA ÚLTIMA MOD.: 12/02/2024 --->
<!--- INCLUDE QUE PERMITE PRELLENAR LOS CAMPOS REQUERIDOS PARA LA FORMA TELEGÁMICA --->

<!--- Parámetros utilizados por las FT --->
<cfparam name="vIdAcad" default="0">
<cfparam name="vFt" default="0">
<cfparam name="vIdSol" default="0">
<cfparam name="vTipoComando" default="0">
<cfparam name="vHistoria" default="0">

<!--- Obtener datos de la tabla de academicos --->
<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
    WHERE acd_id = #vIdAcad# 
</cfquery>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>
	
<!--- LLENA LOS CONTROLES CON UN VALOR NULO O PREDETERMINADO (NUEVA SOLICITUD) --->
<cfset vRutaPagSig = "ft_ctic_nuevo.cfm">
<cfset vActivaCampos = "">
	
<cfif #vFt# EQ 46>
	<!---  --->
	<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
		SELECT TOP 1 sol_id FROM consulta_movimientos
		WHERE mov_clave = 6 
		AND acd_id = #vIdAcad#
		AND dec_super = 'DE'
		ORDER BY ssn_id
	</cfquery>

	<!---  --->
	<cfquery name="tbSolicitudesHistoria" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM movimientos_solicitud_historia
		WHERE sol_id = #tbMovimientos.sol_id#
	</cfquery>

	<cfoutput query="tbSolicitudesHistoria">
		<cfset vCampoPos1 = #sol_pos1#>
		<cfset vCampoPos1_u = #sol_pos1_u#>
		<cfset vCampoPos2 = #sol_pos2#>
		<cfset vCampoPos3 = ''>
		<cfset vCampoPos4 = ''>
		<cfset vCampoPos4_f = ''>
		<cfset vCampoPos5 = ''>
		<cfset vCampoPos6 = ''>
		<cfset vCampoPos7 = ''>
		<cfset vCampoPos6 = ''>	
		<cfset vCampoPos7 = ''>
		<cfset vCampoPos8 = #sol_pos8#>	
		<cfset vCampoPos9 = #sol_pos9#>
		<cfset vCampoPos10 = ''>
		<cfset vCampoPos11 = ''>
		<cfset vCampoPos11_p = ''>
		<cfset vCampoPos11_e = ''>
		<cfset vCampoPos11_c = ''>
		<cfset vCampoPos11_u = ''>
		<cfset vCampoPos12 = ''>
		<cfset vCampoPos12_o = #sol_pos12_o#>
		<cfset vCampoPos13 = ''>
		<cfset vCampoPos13_a = #sol_pos13_a#>
		<cfset vCampoPos13_m = ''>
		<cfset vCampoPos13_d = ''>
		<cfset vCampoPos14 = #sol_pos14#><!--- dd/mm/yyyy' --->
		<cfset vCampoPos15 = #sol_pos15#><!--- dd/mm/yyyy' --->
		<cfset vCampoPos16 = #sol_pos16#>
		<cfset vCampoPos17 = #sol_pos17#>
		<cfset vCampoPos18 = ''>
		<cfset vCampoPos19 = ''>	
		<cfset vCampoPos20 = #sol_pos20#>	
		<cfset vCampoPos21 = ''><!--- dd/mm/yyyy' --->
		<cfset vCampoPos22 = ''><!--- dd/mm/yyyy' --->
		<cfset vCampoPos23 = ''>
		<cfset vCampoPos24 = ''><!--- dd/mm/yyyy' --->
		<cfset vCampoPos25 = ''><!--- dd/mm/yyyy' --->	
		<cfset vCampoMemo1 = #sol_memo1#>
		<cfset vCampoMemo2 = #sol_memo2#>
		<cfset vCampoPos26 = ''>
		<cfset vCampoPos27 = ''>
		<cfset vCampoPos28 = ''>
		<cfset vCampoPos29 = ''>
		<cfset vCampoPos30 = ''>
		<cfset vCampoPos31 = ''>
		<cfset vCampoPos32 = ''>
		<cfset vCampoPos33 = ''>
		<cfset vCampoPos34 = ''>	
		<cfset vCampoPos35 = ''>
		<cfset vCampoPos36 = ''>
		<cfset vCampoPos37 = ''>
		<cfset vCampoPos38 = ''>
		<cfset vCampoPos39 = ''>
		<cfset vCampoPos40 = ''>
		<cfset vSolSintesis = ''>
		<cfset vSolObserva = ''>
		<cfif #Session.sTipoSistema# IS 'sic'><cfset vSolStatus = '4'><cfelse><cfset vSolStatus = '3'></cfif>
		<cfset vDevuelta = 'No'>	
	</cfoutput>
</cfif>
