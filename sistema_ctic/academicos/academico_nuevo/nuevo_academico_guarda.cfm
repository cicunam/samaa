<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 03/11/2010 --->
<!--- FECHA �LTIMA MOD.: 17/10/2018 --->


<cfif #vFt# EQ 0>
	<cfparam name="vIdSol" default="0">
<cfelse>
	<!--- INCLUDE Obtener el siguiente n�mero de solicitud SOL_ID disponible --->
    <cfinclude template="#vCarpetaRaizLogica#/sistema_ctic/comun/include_sol_id_incrementa.cfm">
</cfif>

<!--- INCLUDE Obtener el siguiente n�mero de acad�mico ACD_ID disponible --->
<cfinclude template="#vCarpetaRaizLogica#/sistema_ctic/comun/include_acd_id_incrementa.cfm">

<!---
<!--- Obtener el siguiente n�mero de acad�mico disponible --->
<cfquery name="tbContadoresAcad" datasource="#vOrigenDatosSAMAA#">
	SELECT c_academicos FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'ACD';
</cfquery>

<!--- Registrar n�mero de acad�mico --->
<cfset vAcadId = #tbContadoresAcad.c_academicos#>
--->

<!--- Buscar un acad�mico con el mismo nombre o RFC --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
    WHERE mov_clave = #vFt#
</cfquery>

<!--- Crear un registro en la tabla de acad�micos --->
<cfquery datasource="#vOrigenDatosSAMAA#">
	INSERT INTO academicos 
	(
		acd_id, acd_curp, acd_rfc, grado_clave, acd_prefijo, acd_apepat, acd_apemat, acd_nombres, acd_fecha_nac, acd_sexo, 
		pais_clave_nacimiento, inegi_edo_nac_clave, pais_clave, migracion_clave, dep_clave, dep_ubicacion, acd_email, con_clave, activo, cap_fecha_crea) 
	VALUES (
	<!--- Identificador --->
	<cfif IsDefined("vAcadId") AND #vAcadId# NEQ "">
		#vAcadId#
	<cfelse>
		0
	</cfif>
	,
	<!--- CURP --->
	<cfif IsDefined("curp") AND #curp# NEQ "">
		UPPER(LTRIM(RTRIM('#curp#')))
	<cfelse>
		NULL
	</cfif>
	,
	<!--- RFC --->
	<cfif IsDefined("vRfcConcatena") AND #vRfcConcatena# NEQ "">
		UPPER('#vRfcConcatena#')
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Grado acad�mico --->
	<cfif IsDefined("grado_clave") AND #grado_clave# NEQ "">
		#grado_clave#
	<cfelse>
		0
	</cfif>
	,
	<!--- Prefijo de nombre --->
	<cfif IsDefined("acd_prefijo") AND #acd_prefijo# NEQ "">
		UPPER('#acd_prefijo#')
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Apellido paterno --->
	<cfif IsDefined("apepat") AND #apepat# NEQ "">
		UPPER(LTRIM(RTRIM('#apepat#')))
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Apellido materno --->
	<cfif IsDefined("apemat") AND #apemat# NEQ "">
		UPPER(LTRIM(RTRIM('#apemat#')))
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Nombres --->
	<cfif IsDefined("nombres") AND #nombres# NEQ "">
		UPPER(LTRIM(RTRIM('#nombres#')))
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Fecha de nacimiento --->
	<cfif IsDefined("fecha_nac") AND #fecha_nac# NEQ "">
		'#LsDateFormat(fecha_nac,"dd/mm/yyyy")#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Sexo --->
	<cfif IsDefined("Sexo") AND #Sexo# NEQ "">
		'#Sexo#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Pa�s de Nacionalidad --->
	<cfif IsDefined("pais_clave") AND #pais_clave# NEQ "">
		'#pais_clave#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- En caso de seleccionar M�xico, se pregunta en que estado naci� --->
	<cfif IsDefined("edo_clave") AND #edo_clave# NEQ "">
		'#edo_clave#'
	<cfelse>
		NULL
	</cfif>
    ,
	<!--- Nacionalidad --->
	<cfif IsDefined("pais_clave_nacimiento") AND #pais_clave_nacimiento# NEQ "">
		'#pais_clave_nacimiento#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Calidad migratoria --->
	<cfif IsDefined("calidad") AND #calidad# NEQ "">
		'#calidad#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Dependencia de adscripci�n --->
	<cfif IsDefined("dep_clave") AND #dep_clave# NEQ "">
		'#dep_clave#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Ubicaci�n --->
	<cfif IsDefined("dep_ubicacion") AND #dep_ubicacion# NEQ "">
		'#dep_ubicacion#'
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Correo electr�nico --->
	<cfif IsDefined("email") AND #email# NEQ "">
		LTRIM(RTRIM('#email#'))
	<cfelse>
		NULL
	</cfif>
	,
	<!--- Tipo de contrato (valor predeterminado) --->
		0
	,
	<!--- Activo (valor predeterminado) --->
		0
	,
	<!--- Fecha de creaci�n --->
	GETDATE()
	)
</cfquery>

<!--- CREA EL DIRECTORIO F�SICO DONDE SE GUARDAR�N LOS ARCHIVOS PDF --->
<cfset vDirectorioExiste  = #vCarpetaAcademicos# & #vAcadId#>
<cfif NOT DirectoryExists(vDirectorioExiste)> 
	<cfdirectory action = "create" directory = "#vDirectorioExiste#">
</cfif>

<!--- Redirigir 
a la FT correspondiente, en su caso --->
<cfif #vFt# EQ 0>
	<cflocation url="#vCarpetaRaizLogica#/sistema_ctic/academicos/personal/academico_personal.cfm?vAcadId=#vAcadId#&vTipoComando=CONSULTA" addtoken="no">    
	<!---	<cflocation url="../consulta_academicos.cfm" addtoken="no"> --->
<cfelse>
	<cfif IsDefined("vIdSol")>
		<cfset vUrlConcatena = "#vCarpetaRaizLogica#/sistema_ctic/asuntos/solicitudes/" & #ctMovimiento.mov_ruta# & "?vIdSol=" & #vIdSol# & "&vIdAcad=" & #vAcadId# & "&vFt=" & #vFt# & "&vTipoComando=NUEVO">
		<cfif #vFt# EQ 5>
            <cfset vUrlConcatena = #vUrlConcatena# & "&vIdCoa=" & #vIdCoa#>
        </cfif>
    	<cflocation url="#vUrlConcatena#" addtoken="no">
	<cfelse>
    	<cflocation url="#vCarpetaRaizLogica#/sistema_ctic/asuntos/solicitudes/#ctMovimiento.mov_ruta#?vIdAcad=#vAcadId#&vFt=#vFt#&vTipoComando=NUEVO" addtoken="no">
		<!--- <cfset vUrlConcatena = '#vCarpetaRaizLogica#/sistema_ctic/asuntos/solicitudes/' & #ctMovimiento.mov_ruta# & '?vIdAcad=' & #vAcadId# & '&vFt=' & #vFt# & '&vTipoComando=NUEVO'>--->
	</cfif>
	<!--- <cflocation url="#vUrlConcatena#" addtoken="no"> --->
</cfif>
