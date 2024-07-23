<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 15/04/2010 --->
<!--- CREAR UN NUEVO REGISTRO EN LA TABLA DE FORMACIÓN ACADÉMICA --->

<!--- Registrar la fecha de creación del registro --->
<cfset vFechaCreacion = '#LSDateFormat(Now(),'dd/mm/yyyy')# #LSTimeFormat(Now(),'HH:mm:ss')#'>

<!--- Ejecutar la instrucción SQL --->
<cfquery datasource="#vOrigenDatosCURRICULUM#">
	INSERT INTO formacion_academica 
	(
		acd_id,
		grado_clave,
		pais_clave,
		<!--- uni_clave,--->
        institucion_clave,
		dep_clave,
		car_clave,
		carrera_programa,
		grado_obtenido,
		porcentaje_creditos,
		porcentaje_tesis,
		fecha_grado,
		tesis_director,
		tesis_titulo,
		mencion_honorifica,
		cap_fecha_crea,
		cap_fecha_mod
	) 
	values 
	(
		<cfif IsDefined("vAcadId") AND #vAcadId# IS NOT ''>#vAcadId#<cfelse>NULL</cfif>,
		<cfif IsDefined("grado_clave") AND #grado_clave# IS NOT ''>#grado_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("pais_clave") AND #pais_clave# IS NOT ''>'#pais_clave#'<cfelse>NULL</cfif>,
<!---		<cfif IsDefined("uni_clave") AND #uni_clave# IS NOT ''>#uni_clave#<cfelse>NULL</cfif>,--->
		<cfif IsDefined("institucion_clave") AND #institucion_clave# IS NOT ''>#institucion_clave#<cfelse>NULL</cfif>,
		<cfif IsDefined("dep_clave") AND #dep_clave# IS NOT ''>'#dep_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("car_clave") AND #car_clave# IS NOT ''>'#car_clave#'<cfelse>NULL</cfif>,
		<cfif IsDefined("carrera_programa") AND #carrera_programa# IS NOT ''>'#SinAcentos(Ucase(carrera_programa),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("grado_obtenido") AND #grado_obtenido# IS NOT ''><cfif #grado_obtenido# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		<cfif IsDefined("porcentaje_creditos") AND #porcentaje_creditos# IS NOT ''>#porcentaje_creditos#<cfelse>NULL</cfif>,
		<cfif IsDefined("porcentaje_tesis") AND #porcentaje_tesis# IS NOT ''>#porcentaje_tesis#<cfelse>NULL</cfif>,
		<cfif IsDefined("fecha_grado") AND #fecha_grado# IS NOT ''>'#LsDateFormat(fecha_grado,'dd/mm/yyyy')#'<cfelse>NULL</cfif>,
		<cfif IsDefined("tesis_director") AND #tesis_director# IS NOT ''>'#SinAcentos(Ucase(tesis_director),0)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("tesis_titulo") AND #tesis_titulo# IS NOT ''>'#SinAcentos(Ucase(tesis_titulo),1)#'<cfelse>NULL</cfif>,
		<cfif IsDefined("mencion_honorifica") AND #mencion_honorifica# IS NOT ''><cfif #mencion_honorifica# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		'#vFechaCreacion#',
		'#vFechaCreacion#'
	)
</cfquery>

<!--- Redireccionar al formlario de captura de formación académica --->
<cflocation url="formacion.cfm?vAcadId=#vAcadId#&vFechaCreacion=#vFechaCreacion#&vTipoComando=CONSULTA" addtoken="no">
