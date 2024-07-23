<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 15/04/2010 --->
<!--- CREAR UN NUEVO REGISTRO EN LA TABLA DE FORMACIÓN ACADÉMICA --->

<!--- Ejecutar la instrucción SQL --->
<cfquery datasource="#vOrigenDatosCURRICULUM#">
	UPDATE formacion_academica 
	SET
		grado_clave = <cfif IsDefined("grado_clave") AND #grado_clave# IS NOT ''>#grado_clave#<cfelse>NULL</cfif>,
		pais_clave = <cfif IsDefined("pais_clave") AND #pais_clave# IS NOT ''>'#pais_clave#'<cfelse>NULL</cfif>,
<!---		uni_clave = <cfif IsDefined("uni_clave") AND #uni_clave# IS NOT ''>#uni_clave#<cfelse>NULL</cfif>,--->
		institucion_clave = <cfif IsDefined("institucion_clave") AND #institucion_clave# IS NOT ''>#institucion_clave#<cfelse>NULL</cfif>,
		dep_clave = <cfif IsDefined("dep_clave") AND #dep_clave# IS NOT ''>'#dep_clave#'<cfelse>NULL</cfif>,
		car_clave = <cfif IsDefined("car_clave") AND #car_clave# IS NOT ''>'#car_clave#'<cfelse>NULL</cfif>,
		carrera_programa = <cfif IsDefined("carrera_programa") AND #carrera_programa# IS NOT ''>'#SinAcentos(Ucase(carrera_programa),0)#'<cfelse>NULL</cfif>,
		grado_obtenido = <cfif IsDefined("grado_obtenido") AND #grado_obtenido# IS NOT ''><cfif #grado_obtenido# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		porcentaje_creditos = <cfif IsDefined("porcentaje_creditos") AND #porcentaje_creditos# IS NOT ''>#porcentaje_creditos#<cfelse>NULL</cfif>,
		porcentaje_tesis = <cfif IsDefined("porcentaje_tesis") AND #porcentaje_tesis# IS NOT ''>#porcentaje_tesis#<cfelse>NULL</cfif>,
		fecha_grado = <cfif IsDefined("fecha_grado") AND #fecha_grado# IS NOT ''>'#LsDateFormat(fecha_grado,'dd/mm/yyyy')#'<cfelse>NULL</cfif>,
		tesis_director = <cfif IsDefined("tesis_director") AND #tesis_director# IS NOT ''>'#SinAcentos(Ucase(tesis_director),0)#'<cfelse>NULL</cfif>,
		tesis_titulo = <cfif IsDefined("tesis_titulo") AND #tesis_titulo# IS NOT ''>'#SinAcentos(Ucase(tesis_titulo),1)#'<cfelse>NULL</cfif>,
		mencion_honorifica = <cfif IsDefined("mencion_honorifica") AND #mencion_honorifica# IS NOT ''><cfif #mencion_honorifica# EQ "Si">1<cfelse>0</cfif><cfelse>NULL</cfif>,
		cap_fecha_mod = GETDATE()
	WHERE 
	acd_id =#vAcadId# AND cap_fecha_crea = '#vFechaCreacion#'
</cfquery>

<!--- Redireccionar al formlario de captura de formación académica --->
<cflocation url="formacion.cfm?vAcadId=#vAcadId#&vFechaCreacion=#vFechaCreacion#&vTipoComando=CONSULTA" addtoken="no">



