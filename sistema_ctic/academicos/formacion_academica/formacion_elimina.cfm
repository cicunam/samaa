<!--- CREADO: JOSE ANTONIO ESTEVA --->
<!--- EDITO: JOSE ANTONIO ESTEVA --->
<!--- FECHA: 15/04/2010 --->
<!--- CREAR UN NUEVO REGISTRO EN LA TABLA DE FORMACI�N ACAD�MICA --->

<!--- Ejecutar la instrucci�n SQL --->
<cfquery datasource="#vOrigenDatosCURRICULUM#">
	DELETE FROM formacion_academica 
	WHERE acd_id =#vAcadId# AND cap_fecha_crea = '#vFechaCreacion#'
</cfquery>

<!--- Redireccionar al formlario de captura de formaci�n acad�mica --->
<cflocation url="consulta_formacion.cfm?vAcadId=#vAcadId#" addtoken="no">



