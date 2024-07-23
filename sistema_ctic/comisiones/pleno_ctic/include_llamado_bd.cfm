<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/04/2020 --->
<!--- FECHA ÚLTIMA MOD.: 27/04/2020 --->

<!-- LLMADO A LA COSULTA DE CARGOS ACADEMICO-ADMINISTRATIVOS Y CONTIENE A LOS MIEMBROS DEL CTIC -->
<cfquery name="csMiembrosPleno" datasource="#vOrigenDatosSAMAA#">
	SELECT  * FROM consulta_cargos_acadadm
	WHERE (adm_clave = '01' OR adm_clave = '32')
	AND caa_status = 'A'
	ORDER BY dep_orden, adm_descrip DESC
</cfquery>