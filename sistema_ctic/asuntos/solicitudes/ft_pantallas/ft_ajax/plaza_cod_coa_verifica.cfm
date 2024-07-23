<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 29/08/2022 --->
<!--- FECHA ÚLTIMA MOD.: 29/08/2022 --->
<!--- CÓDIGO PARA VERIFICAR QUE LA PLAZA NO ESTÉ EN UN COA VIGENTE --->

<cfparam name="vCoaNoPlaza" default="00001-01" type="string">


<!--- Obtener la lista de ubicaciones de la dependencia  (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="tbConvocaCoa" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM convocatorias_coa
    WHERE coa_no_plaza = '#vCoaNoPlaza#'
    AND YEAR(cap_fecha_crea) BETWEEN YEAR(GETDATE()) -1 AND YEAR(GETDATE())    
    AND coa_status BETWEEN 1 AND 4
</cfquery>
    
<cfif #tbConvocaCoa.Recordcount# GT 0>
    LA PLAZA SE ENCUENTRA EN PROCESO DE CONVOCATORIA DE CONCURSO DE OPOSICION ABEIRTO
</cfif>
    
    
