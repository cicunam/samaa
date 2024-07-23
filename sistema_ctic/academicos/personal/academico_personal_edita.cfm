<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 03/02/2010 --->
<!--- GUARDAR LOS DATOS PERSONALES DE UN ACADÉMICO --->
<!--- Generar y ejecutar la instrucción SQL UPDATE --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	UPDATE academicos SET 
	sni_exp = <cfif IsDefined("sni_exp") AND #sni_exp# IS NOT ''>#sni_exp#<cfelse>NULL</cfif>,
	num_emp = <cfif IsDefined("num_emp") AND #num_emp# IS NOT ''>#num_emp#<cfelse>NULL</cfif>,
	acd_curp = <cfif IsDefined("acd_curp") AND #acd_curp# IS NOT ''>'#acd_curp#'<cfelse>NULL</cfif>,
	acd_rfc = <cfif IsDefined("acd_rfc") AND #acd_rfc# IS NOT ''>'#acd_rfc#'<cfelse>NULL</cfif>,
	acd_apepat = <cfif IsDefined("acd_apepat") AND #acd_apepat# IS NOT ''>RTRIM('#SinAcentos(Ucase(acd_apepat),0)#')<cfelse>NULL</cfif>,
	acd_apemat = <cfif IsDefined("acd_apemat") AND #acd_apemat# IS NOT ''>RTRIM('#SinAcentos(Ucase(acd_apemat),0)#')<cfelse>NULL</cfif>,
	acd_nombres = <cfif IsDefined("acd_nombres") AND #acd_nombres# IS NOT ''>RTRIM('#SinAcentos(Ucase(acd_nombres),0)#')<cfelse>NULL</cfif>,
	acd_prefijo = <cfif IsDefined("acd_prefijo") AND #acd_prefijo# IS NOT ''>'#acd_prefijo#'<cfelse>NULL</cfif>,
	acd_fecha_nac = <cfif IsDefined("acd_fecha_nac") AND #acd_fecha_nac# IS NOT ''>'#acd_fecha_nac#'<cfelse>NULL</cfif>,
	acd_sexo = <cfif IsDefined("acd_sexo") AND #acd_sexo# IS NOT ''>'#acd_sexo#'<cfelse>NULL</cfif>,
	acd_email = <cfif IsDefined("acd_email") AND #acd_email# IS NOT ''>RTRIM('#SinAcentos(Lcase(acd_email),0)#')<cfelse>NULL</cfif>,
	acd_memo = <cfif IsDefined("acd_memo") AND #acd_memo# IS NOT ''>'#SinAcentos(acd_memo,1)#'<cfelse>NULL</cfif>,
	dep_clave = <cfif IsDefined("dep_clave") AND #dep_clave# IS NOT ''>'#dep_clave#'<cfelse>NULL</cfif>,
	dep_ubicacion = <cfif IsDefined("dep_ubicacion") AND #dep_ubicacion# IS NOT ''>'#dep_ubicacion#'<cfelse>NULL</cfif>,
	no_plaza = <cfif IsDefined("no_plaza") AND #no_plaza# IS NOT ''>'#no_plaza#'<cfelse>NULL</cfif>,
	con_clave = <cfif IsDefined("con_clave") AND #con_clave# IS NOT ''>#con_clave#<cfelse>NULL</cfif>,
	cn_clave = <cfif IsDefined("cn_clave") AND #cn_clave# IS NOT ''>'#cn_clave#'<cfelse>NULL</cfif>,
	grado_clave = <cfif IsDefined("grado_clave") AND #grado_clave# IS NOT ''>#grado_clave#<cfelse>NULL</cfif>,
	fecha_pc = <cfif IsDefined("fecha_pc") AND #fecha_pc# IS NOT ''>'#fecha_pc#'<cfelse>NULL</cfif>,
	fecha_cn = <cfif IsDefined("fecha_cn") AND #fecha_cn# IS NOT ''>'#fecha_cn#'<cfelse>NULL</cfif>,
	fecha_def = <cfif IsDefined("fecha_def") AND #fecha_def# IS NOT ''>'#fecha_def#'<cfelse>NULL</cfif>,
	pais_clave = <cfif IsDefined("pais_clave") AND #pais_clave# IS NOT ''>'#pais_clave#'<cfelse>NULL</cfif>,
	<cfif IsDefined("edo_clave")>
		inegi_edo_nac_clave =  <cfif #edo_clave# IS NOT ''>'#edo_clave#'<cfelse>NULL</cfif>,
	</cfif>
	pais_clave_nacimiento = <cfif IsDefined("pais_clave_nacimiento") AND #pais_clave_nacimiento# IS NOT ''>'#pais_clave_nacimiento#'<cfelse>NULL</cfif>,
	migracion_clave = <cfif IsDefined("migracion_clave") AND #migracion_clave# IS NOT ''>'#migracion_clave#'<cfelse>NULL</cfif>,
	no_expediente = <cfif IsDefined("no_expediente") AND #no_expediente# IS NOT ''>'#no_expediente#'<cfelse>NULL</cfif>,
	activo = <cfif IsDefined("activo") AND #activo# IS NOT ''><cfif #activo# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
	baja_clave = <cfif IsDefined("baja_clave") AND #baja_clave# IS NOT ''>#baja_clave#<cfelse>NULL</cfif>,
	cap_fecha_mod = GETDATE()
	WHERE acd_id = #vAcadId#
</cfquery>
<!--- Redirigir al formulario de captura --->
<cflocation url="academico_personal.cfm?vAcadId=#vAcadId#" addtoken="no">

