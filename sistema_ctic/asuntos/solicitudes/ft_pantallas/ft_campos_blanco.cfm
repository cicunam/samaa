<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA ULTIMA MOD.: 08/09/2009 --->
<!--- ARCHIVO PARA CREAR VARIABLES LOCALES --->

<!--- Parámetros utilizados por las FT --->
<cfparam name="vIdAcad" default="0">
<cfparam name="vFt" default="0">
<cfparam name="vIdSol" default="0">
<cfparam name="vTipoComando" default="0">
<cfparam name="vHistoria" default="0">

<!--- Obtener datos de la tabla de academicos --->
<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos WHERE acd_id = #vIdAcad# 
</cfquery>

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
</cfquery>

	<cfset vCampoPos1 = ''>
	<cfset vCampoPos1_u = ''>
	<cfset vCampoPos1_txt = ''>
	<cfset vCampoPos1_i_txt = ''>
	<cfset vCampoPos1_u_txt = ''>
	<cfset vCampoPos1_Siglas = ''>
	<cfset vCampoPos2 = ''>		
	<cfset vCampoPos2_txt = ''>
	<cfset vCampoPos3 = ''>
	<cfset vCampoPos3_txt = ''>
	<cfset vCampoPos4 = ''>
	<cfset vCampoPos4_f = ''>
	<cfset vCampoPos4_txt = "">
	<cfset vCampoPos5 = ''>
	<cfset vCampoPos6 = ''>
	<cfset vCampoPos6_txt = "">
	<cfset vCampoPos7 = ''>
	<cfset vCampoPos8 = ''>
	<cfset vCampoPos8_txt = ''>
	<cfset vCampoPos9 = ''>
	<cfset vCampoPos10 = ''>	
	<cfset vCampoPos11 = ''>
	<cfset vCampoPos11_p = ''>
	<cfset vCampoPos11_e = ''>
	<cfset vCampoPos11_c = ''>
	<cfset vCampoPos11_u = ''>
	<cfset vCampoPos11_e_txt = ''>
	<cfset vCampoPos11_p_txt = ''>
	<cfset vCampoPos12 = ''>
	<cfset vCampoPos12_o = ''>
	<cfset vCampoPos13 = ''>
	<cfset vCampoPos13_a = ''>
	<cfset vCampoPos13_m = ''>
	<cfset vCampoPos13_d = ''>
	<cfset vCampoPos14 = ''>
	<cfset vCampoPos12_txt = ''>
	<cfset vCampoPos15 = ''>
	<cfset vCampoPos16 = ''>
	<cfset vCampoPos17 = ''>
	<cfset vCampoPos18 = ''>
	<cfset vCampoPos19 = ''>	
	<cfset vCampoPos20 = ''>	
	<cfset vCampoPos21 = ''>
	<cfset vCampoPos22 = ''>
	<cfset vCampoPos23 = ''>
	<cfset vCampoPos24 = ''>
	<cfset vCampoPos25 = ''>
	<cfset vCampoMemo1 = ''>
	<cfset vCampoMemo2 = ''>
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
	<cfset vDocumentosRecibidos = 'No'>
	<cfset vSolSintesis = ''>
	<cfset vSolObserva = ''>
	<cfset vDevuelta = 'No'>
	<cfset vActivaCampos = "">
	<cfset VRUTAPAGSIG = "">
	<cfset vActa = 0>
	<cfset vSolStatus = 1>
	<cfset vIdCoa = 1>
	<cfset vIdCcnOrden = 80>
	<cfset vFecSaba = '01/01/2000'>
	<cfset vIdMovRel = 0>	