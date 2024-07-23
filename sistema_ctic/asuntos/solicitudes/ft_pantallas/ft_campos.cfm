<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 08/09/2009 --->
<!--- FECHA ÚLTIMA MOD.: 09/04/2024 --->
<!--- ARCHIVO PARA CREAR VARIABLES LOCALES --->

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

<!--- Si se pasó el comando "EDITA" o "CONSULTA" obtener los datos del registro seleccionado --->
<cfif #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'IMPRIME'>
	<!--- Obtener los datos de la solicitud --->
	<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM <cfif #vHistoria# GTE 1>movimientos_solicitud_historia<cfelse>movimientos_solicitud</cfif> 
		WHERE sol_id = #vIdSol#
	</cfquery>
	<cfset pos12 = #tbSolicitudes.sol_pos12#>
</cfif>

<cfif #vTipoComando# EQ 'NUEVO'>

	<!--- LLENA LOS CONTROLES CON UN VALOR NULO O PREDETERMINADO (NUEVA SOLICITUD) --->
	<cfset vRutaPagSig = "ft_ctic_nuevo.cfm">
	<cfset vActivaCampos = "">

	<!--- Abre la tabla de CONVOCATORIAS DE COA --->
	<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 17 OR #vFt# EQ 28 OR #vFt# EQ 42>
        <cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM convocatorias_coa 
            WHERE coa_id = '#vIdCoa#'
        </cfquery>
    </cfif>

	<!--- Valores predeterminados obtenidos de la base de datos --->
	<cfif #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 42>
		<cfset vCampoPos1 = '#tbConvocatorias.dep_clave#'>
		<cfset vCampoPos1_u = '#tbConvocatorias.dep_ubicacion#'>
	<cfelse>
		<cfif #Session.sTipoSistema# IS 'sic'>
			<!--- SE AGREGÓ PARA GUARDAR LAS LICENCIAS CON GOCE DE SUELDO A LA CIC 19/02/2024 --->
			<cfif '#Session.sIdDep#' EQ '034201' OR '#Session.sIdDep#' EQ '034301' OR '#Session.sIdDep#' EQ '034401' OR '#Session.sIdDep#' EQ '034502' OR '#Session.sIdDep#' EQ '034601'>
            	<cfset vCampoPos1 = '030101'>
			<cfelse>
            	<cfset vCampoPos1 = '#Session.sIdDep#'>
			</cfif>
            <cfif #vFt# EQ 29 OR #vFt# EQ 40 OR #vFt# EQ 41>
                <cfset vCampoPos1_u = '#tbAcademico.dep_ubicacion#'><!--- Ubicación del académico --->
            <cfelse>
                <cfset vCampoPos1_u = ''><!--- PENDIENTE --->
            </cfif>
        <cfelse>
            <!--- Dependencia y ubicación del académico --->
            <cfset vCampoPos1 = '#tbAcademico.dep_clave#'>
            <cfset vCampoPos1_u = '#tbAcademico.dep_ubicacion#'><!--- Ubicación del académico --->
        </cfif>
	</cfif>	
    
	<!--- Académico --->
	<cfif #vFt# EQ 15 AND #vFt# EQ 16 AND #vFt# EQ 42>
		<cfset vCampoPos2 = ''><!--- PENDIENTE --->
	<cfelse>
		<cfset vCampoPos2 = '#tbAcademico.acd_id#'>		
	</cfif>
	
	<cfset vCampoPos3 = '#tbAcademico.cn_clave#'><!--- Clase, categoría y nivel --->
	
	<!--- Antigúedad en esa CCN --->
	<cfset vCampoPos4 = 0>
<!---
	<cfif #tbAcademico.fecha_cn# NEQ "">
		<cfset vCampoPos4 = DateDiff("d","#tbAcademico.fecha_cn#", "#Now()#")>
	<cfelse>
		<cfset vCampoPos4 = 0>
	</cfif>
--->	

	<cfset vCampoPos4_f = '#LsDateFormat(tbAcademico.fecha_cn,'dd/mm/yyyy')#'><!--- Desde (CCN) --->
	<cfset vCampoPos5 = '#tbAcademico.con_clave#'><!--- Tipo de contrato --->
	
	<!--- Antigüedad académica --->
	<cfset vCampoPos6 = 0>
<!---
	<cfif #tbAcademico.fecha_pc# NEQ "">
		<cfset vCampoPos6 = DateDiff("d","#tbAcademico.fecha_pc#", "#Now()#")>
	<cfelse>
		<cfset vCampoPos6 = 0>
	</cfif>	
--->
	
	<cfset vCampoPos7 = '#LsDateFormat(tbAcademico.fecha_pc,'dd/mm/yyyy')#'><!--- Fecha de primer contrato --->	

	<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 17 OR #vFt# EQ 28 OR #vFt# EQ 42>
		<cfset vCampoPos8 = '#tbConvocatorias.cn_clave#'> 
	<cfelse>
		<cfif #tbAcademico.cn_clave# NEQ "">
            <cfset vCampoPos8 = '#tbAcademico.cn_clave#'>
        <cfelse>
            <cfset vCampoPos8 = ''>
        </cfif>	
	</cfif>
	
	<!--- Valores que deben capturar las dependencias --->
	<cfif #vFt# EQ 12>
		<cfset vCampoPos9 = #tbAcademico.no_plaza#>
	<cfelse>
		<cfset vCampoPos9 = ''>
	</cfif>
	<cfset vCampoPos10 = ''>	
	<cfset vCampoPos11 = ''>
	<cfset vCampoPos11_p = ''>
	<cfset vCampoPos11_e = ''>
	<cfset vCampoPos11_c = ''>
	<cfset vCampoPos11_u = ''>
	<cfset vCampoPos12 = ''>
	<cfset vCampoPos12_o = ''>
	<cfset vCampoPos13 = ''>
	<cfif #vFt# EQ "9" OR #vFt# EQ "10" OR #vFt# EQ "25" OR #vFt# EQ "44" >
		<cfset vCampoPos13_a = '1'>
	<cfelse>
		<cfset vCampoPos13_a = ''>
    </cfif>
	<cfset vCampoPos13_m = ''>
	<cfset vCampoPos13_d = ''>
<!--- CÓDIGO PARA DETERMINAR ÚLTIMA FECHA DE PLAZA 26/04/2022
	<cfif #vFt# EQ 5>        
        <!--- Obtener el último movimiento de la palza solo para COAS --->
        <cfquery name="tbMovimienos" datasource="#vOrigenDatosSAMAA#">
	        SELECT TOP 1 mov_fecha_final
            FROM movimientos
            WHERE mov_plaza = '#tbConvocatorias.coa_no_plaza#'
            AND mov_clave = 6
            ORDER BY mov_fecha_inicio DESC
        </cfquery>
        <cfif #tbMovimienos.recordcount# EQ 1>
	        <cfset vCampoPos14 = #LsDateFormat(tbMovimienos.mov_fecha_final + 1,'dd/mm/yyyy' )# ><!--- dd/mm/yyyy' --->
            <cfset vCampoPos14Texto = ''>
        <cfelse>
            <cfset vCampoPos14 = ''><!--- dd/mm/yyyy' --->
            <cfset vCampoPos14Texto = ''>
        </cfif>
    <cfelse>
	    <cfset vCampoPos14 = ''><!--- dd/mm/yyyy' --->
    </cfif>
--->        
    <cfset vCampoPos14 = ''><!--- dd/mm/yyyy' --->
	<cfset vCampoPos15 = ''><!--- dd/mm/yyyy' --->
	<cfif #vFt# EQ "6" OR  #vFt# EQ "44">
		<cfset vCampoPos16 = '40'>
	<cfelse>
		<cfset vCampoPos16 = ''>
	</cfif>
	<cfset vCampoPos17 = ''>
	<cfset vCampoPos18 = ''>
	<cfset vCampoPos19 = ''>	
	<cfset vCampoPos20 = ''>	
	<cfset vCampoPos21 = ''><!--- dd/mm/yyyy' --->
	<cfset vCampoPos22 = ''><!--- dd/mm/yyyy' --->
	<!--- En caso de usar una FT a la que se lige una CONVOCATORIA COA --->
	<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 17 OR #vFt# EQ 28 OR #vFt# EQ 42>
		<cfset vCampoPos23 = '#vIdCoa#'> <!--- Asignar valor al campo pos23 con el parámetro de la convocatira (Concocatoria COA) --->
	<cfelse>
		<cfset vCampoPos23 = ''>
	</cfif>
	<cfset vCampoPos24 = ''><!--- dd/mm/yyyy' --->
	<cfset vCampoPos25 = ''><!--- dd/mm/yyyy' --->	
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
	<cfset vCampoPos41 = ''>
	<cfset vDocumentosRecibidos = 'No'>
	<cfset vSolSintesis = ''>
	<cfset vSolObserva = ''>
	<cfif #Session.sTipoSistema# IS 'sic'><cfset vSolStatus = '4'><cfelse><cfset vSolStatus = '3'></cfif>
	<cfset vDevuelta = 'No'>

	<cfif #vFt# EQ 46><!--- SE AGREGÓ POR LA CREACIÓN DE LA FT-CTIC-46 Y HACE PRECARGA DE LA INFORMACIÓN DEL LA OBRA DETERMINADA DEVIELTO A LA ENTIDAD --->
		<!--- REVISA EL ÚLTIMO MOVIMIENTO DE COD DEVUELTO A LA ENTIDAD  --->
		<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
			SELECT TOP 1 sol_id FROM consulta_movimientos
			WHERE mov_clave = 6 
			AND acd_id = #vIdAcad#
			AND dec_super = 'DE'
			ORDER BY ssn_id
		</cfquery>

		<!--- LLAMA EL REGISTRO DE LA SOLICITUD LIGADA AL MOVIMIENTO  --->
		<cfquery name="tbSolicitudesHistoria" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_solicitud_historia
			WHERE sol_id = #tbMovimientos.sol_id#
		</cfquery>

		<cfoutput query="tbSolicitudesHistoria">
			<cfset vCampoPos1 = "#sol_pos1#">
			<cfset vCampoPos1_u = "#sol_pos1_u#">
			<cfset vCampoPos2 = #sol_pos2#>
			<cfset vCampoPos8 = #sol_pos8#>	
			<cfset vCampoPos9 = #sol_pos9#>
			<cfset vCampoPos12_o = #sol_pos12_o#>
			<cfset vCampoPos13_a = #sol_pos13_a#>
			<cfset vCampoPos14 = "#LsDateFormat(sol_pos14,'dd/mm/yyyy')#"><!--- dd/mm/yyyy' --->
			<cfset vCampoPos15 = "#LsDateFormat(sol_pos15,'dd/mm/yyyy')#"><!--- dd/mm/yyyy' --->
			<cfset vCampoPos16 = #sol_pos16#>
			<cfset vCampoPos17 = #sol_pos17#>
			<cfset vCampoPos20 = #sol_pos20#>	
			<cfset vCampoMemo1 = #sol_memo1#>
			<cfset vCampoMemo2 = #sol_memo2#>
		</cfoutput>
	</cfif>
		
<cfelseif #vTipoComando# EQ 'CONSULTA' OR #vTipoComando# EQ 'EDITA' OR #vTipoComando# EQ 'IMPRIME'>

	<!--- LLENA LOS CONTROLES CON INFORMACION DE LA BASE DE DATOS (EDITA Y CONAULTA SOLICITUD) --->
	<cfif #vTipoComando# EQ 'CONSULTA'>
		<cfset vActivaCampos = "disabled">
		<cfset vRutaPagSig = "../#ctMovimiento.mov_ruta#">
	<cfelseif #vTipoComando# EQ 'EDITA'>
		<cfset vActivaCampos = "">
		<cfset vRutaPagSig = "ft_ctic_edita.cfm">
	<cfelseif #vTipoComando# EQ 'IMPRIME'>	
		<cfset vActivaCampos = "">
		<cfset vRutaPagSig = "../#ctMovimiento.mov_ruta#">
	</cfif>

	<cfset vCampoPos1 = #Iif(tbSolicitudes.sol_pos1 EQ "",DE(""),DE("#tbSolicitudes.sol_pos1#"))#>
	<cfset vCampoPos1_u = #Iif(tbSolicitudes.sol_pos1_u EQ "",DE(""),DE("#tbSolicitudes.sol_pos1_u#"))#>
	<cfset vCampoPos2 = #Iif(tbSolicitudes.sol_pos2 EQ "",DE(""),DE("#tbSolicitudes.sol_pos2#"))#>
	<cfset vCampoPos3 = #Iif(tbSolicitudes.sol_pos3 EQ "",DE(""),DE("#tbSolicitudes.sol_pos3#"))#>
	<cfset vCampoPos4 = #Iif(tbSolicitudes.sol_pos4 EQ "",DE("0"),DE("#tbSolicitudes.sol_pos4#"))#>
	<cfset vCampoPos4_f = #Iif(tbSolicitudes.sol_pos14 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos4_f,'dd/mm/yyyy')#"))#>
	<cfset vCampoPos5 = #Iif(tbSolicitudes.sol_pos5 EQ "",DE(""),DE("#tbSolicitudes.sol_pos5#"))#>
	<cfset vCampoPos6 = #Iif(tbSolicitudes.sol_pos6 EQ "",DE("0"),DE("#tbSolicitudes.sol_pos6#"))#>
	<cfset vCampoPos7 = #Iif(tbSolicitudes.sol_pos7 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos7,'dd/mm/yyyy')#"))#>	

	<!--- En caso de usar una FT a la que se lige una CONVOCATORIA COA --->
	<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16 OR #vFt# EQ 17 OR #vFt# EQ 28 OR #vFt# EQ 42>
		<!--- Obtener datos de la convocatoria --->
        <cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM convocatorias_coa 
            WHERE coa_id = '#tbSolicitudes.sol_pos23#'
        </cfquery>
		<cfset vCampoPos8 = '#tbConvocatorias.cn_clave#'>        
	<cfelse>
		<cfset vCampoPos8 = #Iif(tbSolicitudes.sol_pos8 EQ "",DE(""),DE("#tbSolicitudes.sol_pos8#"))#>
	</cfif>
	<cfset vCampoPos9 = #Iif(tbSolicitudes.sol_pos9 EQ "",DE(""),DE("#tbSolicitudes.sol_pos9#"))#>
	<cfset vCampoPos10 = #Iif(tbSolicitudes.sol_pos10 EQ "",DE(""),DE("#tbSolicitudes.sol_pos10#"))#>
	<cfset vCampoPos11 = #Iif(tbSolicitudes.sol_pos11 EQ "",DE(""),DE("#tbSolicitudes.sol_pos11#"))#>
	<cfset vCampoPos11_p = #Iif(tbSolicitudes.sol_pos11_p EQ "",DE(""),DE("#tbSolicitudes.sol_pos11_p#"))#>
	<cfset vCampoPos11_e = #Iif(tbSolicitudes.sol_pos11_e EQ "",DE(""),DE("#tbSolicitudes.sol_pos11_e#"))#>
	<cfset vCampoPos11_c = #Iif(tbSolicitudes.sol_pos11_c EQ "",DE(""),DE("#tbSolicitudes.sol_pos11_c#"))#>
	<cfset vCampoPos11_u = #Iif(tbSolicitudes.sol_pos11_u EQ "",DE(""),DE("#tbSolicitudes.sol_pos11_u#"))#>
<!---
	<cfset vCampoPos11_i = #Iif(tbSolicitudes.sol_pos11_i EQ "",DE(""),DE("#tbSolicitudes.sol_pos11_i#"))#>
--->
	<cfset vCampoPos12 = #Iif(tbSolicitudes.sol_pos12 EQ "",DE(""),DE("#tbSolicitudes.sol_pos12#"))#>
	<cfset vCampoPos12_o = #Iif(tbSolicitudes.sol_pos12_o EQ "",DE(""),DE("#tbSolicitudes.sol_pos12_o#"))#>
    <cfif #vFt# EQ '32'>
	    <cfset vMovSabId = #Iif(tbSolicitudes.sol_pos12_o EQ "",DE(""),DE("#tbSolicitudes.sol_pos12_o#"))#>
    </cfif>
	<cfset vCampoPos13 = #Iif(tbSolicitudes.sol_pos13 EQ "",DE(""),DE("#tbSolicitudes.sol_pos13#"))#>
	<cfset vCampoPos13_a = #Iif(tbSolicitudes.sol_pos13_a EQ "",DE(""),DE("#tbSolicitudes.sol_pos13_a#"))#>
	<cfset vCampoPos13_m = #Iif(tbSolicitudes.sol_pos13_m EQ "",DE(""),DE("#tbSolicitudes.sol_pos13_m#"))#>
	<cfset vCampoPos13_d = #Iif(tbSolicitudes.sol_pos13_d EQ "",DE(""),DE("#tbSolicitudes.sol_pos13_d#"))#>
	<cfset vCampoPos14 = #Iif(tbSolicitudes.sol_pos14 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#"))#>	
	<cfset vCampoPos15 = #Iif(tbSolicitudes.sol_pos15 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos15,'dd/mm/yyyy')#"))#>
	<cfset vCampoPos16 = #Iif(tbSolicitudes.sol_pos16 EQ "0",DE(""),DE("#tbSolicitudes.sol_pos16#"))#>
	<cfset vCampoPos17 = #Iif(tbSolicitudes.sol_pos17 EQ "0",DE(""),DE("#tbSolicitudes.sol_pos17#"))#>
	<cfset vCampoPos18 = #Iif(tbSolicitudes.sol_pos18 EQ "",DE(""),DE("#tbSolicitudes.sol_pos18#"))#>
	<cfset vCampoPos19 = #Iif(tbSolicitudes.sol_pos19 EQ "",DE(""),DE("#LsNumberFormat(tbSolicitudes.sol_pos19,'9999999')#"))#>
	<cfset vCampoPos20 = #Iif(tbSolicitudes.sol_pos20 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos21 = #Iif(tbSolicitudes.sol_pos21 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos21,'dd/mm/yyyy')#"))#>
	<cfset vCampoPos22 = #Iif(tbSolicitudes.sol_pos22 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos22,'dd/mm/yyyy')#"))#>		
	<cfset vCampoPos23 = #Iif(tbSolicitudes.sol_pos23 EQ "",DE(""),DE("#tbSolicitudes.sol_pos23#"))#>
	<cfset vCampoPos24 = #Iif(tbSolicitudes.sol_pos24 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos24,'dd/mm/yyyy')#"))#>
	<cfset vCampoPos25 = #Iif(tbSolicitudes.sol_pos25 EQ "",DE(""),DE("#LsDateFormat(tbSolicitudes.sol_pos25,'dd/mm/yyyy')#"))#>
	<cfset vCampoMemo1 = #Iif(tbSolicitudes.sol_memo1 EQ "",DE(""),DE("#tbSolicitudes.sol_memo1#"))#>
	<cfset vCampoMemo2 = #Iif(tbSolicitudes.sol_memo2 EQ "",DE(""),DE("#tbSolicitudes.sol_memo2#"))#>
	<cfset vCampoPos26 = #Iif(tbSolicitudes.sol_pos26 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos27 = #Iif(tbSolicitudes.sol_pos27 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos28 = #Iif(tbSolicitudes.sol_pos28 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos29 = #Iif(tbSolicitudes.sol_pos29 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos30 = #Iif(tbSolicitudes.sol_pos30 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos31 = #Iif(tbSolicitudes.sol_pos31 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos32 = #Iif(tbSolicitudes.sol_pos32 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos33 = #Iif(tbSolicitudes.sol_pos33 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos34 = #Iif(tbSolicitudes.sol_pos34 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos35 = #Iif(tbSolicitudes.sol_pos35 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos36 = #Iif(tbSolicitudes.sol_pos36 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos37 = #Iif(tbSolicitudes.sol_pos37 IS 1,DE("Si"),DE("No"))#>	
	<cfset vCampoPos38 = #Iif(tbSolicitudes.sol_pos38 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos39 = #Iif(tbSolicitudes.sol_pos39 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos40 = #Iif(tbSolicitudes.sol_pos40 IS 1,DE("Si"),DE("No"))#>
	<cfset vCampoPos41 = #Iif(tbSolicitudes.sol_pos40 IS 1,DE("Si"),DE("No"))#>		
	<cfset vSolSintesis = #Iif(tbSolicitudes.sol_sintesis EQ "",DE(""),DE("#tbSolicitudes.sol_sintesis#"))#>
	<cfset vSolObserva = #tbSolicitudes.sol_observaciones#>
	<cfset vSolStatus = #Iif(tbSolicitudes.sol_status EQ "",DE(""),DE("#tbSolicitudes.sol_status#"))#>
	<cfset vDevuelta = #Iif(tbSolicitudes.sol_devuelta IS 1,DE("Si"),DE("No"))#>
</cfif>

<!--- OBTENER EL NOMBRE DE LA DEPENDENCIA EN MODO TEXTO, se hizo el cambio a la BD de catálogos el 09/04/2024--->
<cfquery name="ctDependencia" datasource="#vOrigenDatosCATALOGOS#">
   	SELECT * FROM catalogo_dependencias
    WHERE dep_clave = '#vCampoPos1#' 
</cfquery>

<cfset vCampoPos1_txt = '#Ucase(ctDependencia.dep_nombre)#'>
<cfset vCampoPos1_Siglas = '#Ucase(ctDependencia.dep_siglas)#'>

<!--- GENERAR EL NOMBRE DEL ACADÉMICO EN MODO TEXTO--->
<cfif #vCampoPos2# NEQ ''>
	<cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
	   	SELECT * FROM academicos 
        WHERE acd_id = #vCampoPos2#
	</cfquery>
	<cfif #tbAcademico.RecordCount# EQ 1> 
		<cfset vCampoPos2_txt = '#Trim(tbAcademico.acd_prefijo)# #Trim(tbAcademico.acd_nombres)# #Trim(tbAcademico.acd_apepat)# #Trim(tbAcademico.acd_apemat)#'>
	<cfelse>
		<cfset vCampoPos2_txt = ''>
	</cfif>	
</cfif>

<!--- OBTENER LA CATEGORÍA DEL ACADÉMICO EN MODO TEXTO --->

<!--- Obtener datos del catálogo de categorías y niveles cuando el campo SOL_POS3 se utiliza (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctCategoriaPos3" datasource="#vOrigenDatosCATALOGOS#">
   	SELECT cn_siglas FROM catalogo_cn 
    WHERE cn_clave = '#vCampoPos3#' 
</cfquery>

<cfset vCampoPos3_txt = '#ctCategoriaPos3.cn_siglas#'>

<!--- Obtener datos del catálogo de categorías y niveles del responsable técnico (CATÁLOGOS GENERALES MYSQL) --->
<cfif #vCampoPos8# NEQ ''>
    <cfquery name="ctCategoriaPos8" datasource="#vOrigenDatosCATALOGOS#">
        SELECT cn_siglas FROM catalogo_cn 
		WHERE 1 = 1
        AND cn_clave = '#vCampoPos8#'
        ORDER BY cn_siglas
    </cfquery>

	<cfset vCampoPos8_txt='#ctCategoriaPos8.cn_siglas#'>

<cfelse>
	<cfset vCampoPos8_txt=''>
</cfif>


<cfset vSolId = #vIdSol#>

<!--- OBTENER LA CADENA DE TEXTO DE LA ANTIGÜEDAD ANTIGÜEDAD EN LA CATEGORÍA Y NIVEL --->
<cfset vCampoPos4_txt = "">
<cfif #vCampoPos4# GT 0>
	<cfset vTipoSolicitudAntigCnn = 'C'>
	<cfinclude template="../../../comun/calcula_antiguedad_ccn.cfm">
<cfelseif #vCampoPos4# EQ 0 OR #vCampoPos4# EQ ''>
	<cfset vTipoSolicitudAntigCnn = 'N'>
	<cfinclude template="../../../comun/calcula_antiguedad_ccn.cfm">
</cfif>

<!--- OBTENER LA CADENA DE TEXTO DE LA ANTIGÜEDAD ACADÉMICA --->	
<cfset vCampoPos6_txt = "">
<cfif #vCampoPos6# GT 0>
	<cfset vTipoSolicitudAntig = 'C'>
	<cfinclude template="../../../comun/calcula_antiguedad.cfm">
<cfelseif #vCampoPos6# EQ 0 OR #vCampoPos6# EQ ''>
	<cfset vTipoSolicitudAntig = 'N'>
	<cfinclude template="../../../comun/calcula_antiguedad.cfm">	
</cfif>

<!---
<!--- OBTENER LA CADENA DE TEXTO DE LA ANTIGÜEDAD ANTIGÜEDAD EN LA CATEGORÍA Y NIVEL --->
<cfif #tbAcademico.fecha_cn# NEQ "">
	<cfset vF1 = #tbAcademico.fecha_cn#>
	<cfset vFF = #dateadd('d',vCampoPos4,vF1)#>
	<!--- Calcular años, meses y días --->
	<cfset vAntigCcnAnios = #DateDiff('yyyy',#vF1#, vFF)#>
	<cfset vF2 = #dateadd('yyyy',vAntigCcnAnios,vF1)#>
	<cfset vAntigCcnMeses = #DateDiff('m',#vF2#, vFF)#>
	<cfset vF3 = #dateadd('m',vAntigCcnMeses,vF2)#>			
	<cfset vAntigCcnDias = #DateDiff('d',#vF3#, vFF)#>
	<!--- Construir la cadena de texto que se mostrará --->
	<cfset vCampoPos4_txt = "">
	<cfif #vAntigCcnAnios# GT 0><cfset vCampoPos4_txt = #vAntigCcnAnios# & " año(s) "></cfif>
	<cfif #vAntigCcnMeses# GT 0><cfset vCampoPos4_txt = #vCampoPos4_txt# & #vAntigCcnMeses# & " mes(es) "></cfif>
	<cfif #vAntigCcnDias# GT 0><cfset vCampoPos4_txt = #vCampoPos4_txt#  & #vAntigCcnDias# & " día(s)"></cfif>
        
	<cfif #vAntigCcnDias# EQ "1 día(s)">
    	<cfset vCampoPos4_txt = "">
    </cfif>        
<cfelse>
	<cfset vCampoPos4_txt = "">
</cfif>

<!--- OBTENER LA CADENA DE TEXTO DE LA ANTIGÜEDAD ACADÉMICA --->	
<cfif #tbAcademico.fecha_pc# NEQ "">
	<!--- Calcular años, meses y días --->
	<cfset vF1 = #tbAcademico.fecha_pc#>
	<cfset vFF = #dateadd('d',vCampoPos6,vF1)#>
	<cfset vAntigAcadAnios = #DateDiff('yyyy',#vF1#, vFF)#>
	<cfset vF2 = #dateadd('yyyy',vAntigAcadAnios,vF1)#>
	<cfset vAntigAcadMeses = #DateDiff('m',#vF2#, vFF)#>
	<cfset vF3 = #dateadd('m',vAntigAcadMeses,vF2)#>			
	<cfset vAntigAcadDias = #DateDiff('d',#vF3#, vFF)#>
	<!--- Construir la cadena de texto que se mostrará en la FT --->
	<cfset vCampoPos6_txt = "">
	<cfif #vAntigAcadAnios# GT 0><cfset vCampoPos6_txt = #vAntigAcadAnios# & " año(s) "></cfif>
	<cfif #vAntigAcadMeses# GT 0><cfset vCampoPos6_txt = #vCampoPos6_txt# & #vAntigAcadMeses# & " mes(es) "></cfif>
	<cfif #vAntigAcadDias# GT 0><cfset vCampoPos6_txt = #vCampoPos6_txt#  & #vAntigAcadDias# & " día(s)"></cfif>
	<cfif #vAntigAcadDias# GT 0><cfset vCampoPos6_txt = #vCampoPos6_txt#  & #vAntigAcadDias# & " día(s)"></cfif>
	<cfif #vAntigAcadDias# EQ "1 día(s)">
    	<cfset vCampoPos6_txt = "">
    </cfif>
<cfelse>
	<cfset vCampoPos6_txt = "">
</cfif>
--->