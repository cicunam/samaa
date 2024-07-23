<!---
CREADO: ARAM PICHARDO
EDITO: ARAM PICHARDO DURAN
FECHA CREA: 03/03/2020
FECHA ÚLTIMA MOD: 03/03/2020
---
OBTENER DE LA LISTA DE ACADÉMICOS
--->
<!-------------------------------------->
<!--- Obtener la lista de académicos --->
<!-------------------------------------->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosCATALOGOS#">
	SELECT
		acd_clave AS id,
		REPLACE(CONCAT_WS(' ', IFNULL(acd_apepat,''), IFNULL(acd_apemat,''), IFNULL(acd_nombres,'')), '  ', ' ') AS label
	FROM
		catalogo_academicos
	WHERE
		REPLACE(CONCAT_WS(' ', IFNULL(acd_apepat,''), IFNULL(acd_apemat,''), IFNULL(acd_nombres,'')), '  ', ' ') LIKE '%#term#%'
		<cfif #Session.sNivelAcceso# IS NOT 1 AND (IsDefined('vEntidad') AND #vEntidad# IS NOT '')>
			<cfswitch expression="#vEntidad#">
				<cfcase value = '034201' >
					AND dep_clave = '030101' AND dep_ubicacion = '02'
				</cfcase>					
				<cfcase value = '034301' >
					AND dep_clave = '030101' AND dep_ubicacion = '03'
				</cfcase>
				<cfcase value = '034401' >
					AND dep_clave = '030101' AND dep_ubicacion = '04'				
				</cfcase>
				<cfcase value = '034501' >
					AND dep_clave = '030101' AND dep_ubicacion = '05'
				</cfcase>
				<cfdefaultcase>
					AND dep_clave LIKE '#Left(vEntidad & '0000', 4)#%'
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	ORDER BY
		acd_apepat,
		acd_apemat,
		acd_nombres
</cfquery>
<!---------------------------------------------->
<!--- Regresar la lista de académicos (JSON) --->
<!---------------------------------------------->
<cfoutput>#SerializeJSON(queryToArray(tbAcademicos), true)#</cfoutput>
