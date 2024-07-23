<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 15/04/2010 --->
<!--- CREAR UN NUEVO REGISTRO EN LA TABLA DE FORMACIÓN ACADÉMICA --->

<!--- Ejecutar la instrucción SQL --->
<cfquery datasource="#vOrigenDatosCURRICULUM#">
	DELETE FROM formacion_academica 
	WHERE acd_id =#vAcadId# AND cap_fecha_crea = '#vFechaCreacion#'
</cfquery>

<!--- Redireccionar al formlario de captura de formación académica --->
<cflocation url="consulta_formacion.cfm?vAcadId=#vAcadId#" addtoken="no">



