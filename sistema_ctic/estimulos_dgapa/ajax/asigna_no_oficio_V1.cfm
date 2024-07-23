<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 09/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 29/06/2023 --->
<!--- AJAX PARA ASIGNAR EL NÚMERO DE OFICIO A LOS DICTÁMENES DE LOS ESTÍMULOS DE LA DGAPA --->

<cfquery name="tbEstimulosDgapa" datasource="#vOrigenDatosSAMAA#">
	SELECT T1.estimulo_id
    FROM estimulos_dgapa AS T1
	LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_dependencias') AS C1 ON T1.dep_clave = C1.dep_clave
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_cn') AS C2 ON T1.cn_clave = C2.cn_clave    
	LEFT JOIN OPENQUERY(MYSQL, 'SELECT * FROM catalogos.catalogo_pride') AS C3 ON T1.pride_clave = C3.pride_clave    
   	WHERE ssn_id = #vpSsnId#
	ORDER BY 
	<cfif #vpSsnId# GTE 1576 AND #vpSsnId# LTE 1661>
    	C3.orden_samaa, T1.renovacion, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	<cfelseif #vpSsnId# GTE 1662> <!--- SE AGREGÓ ESTE ORDEN A PETICIÓN DE ADRINA 29/06/2023 --->
    	C1.dep_orden, C3.orden_samaa, T1.ingreso DESC, T1.estimulo_oficio
	<cfelse>
    	C3.orden_samaa, T1.ingreso DESC, C1.dep_orden, C2.cn_clase, T2.acd_apepat, T2.acd_apemat
	</cfif>
</cfquery>


<cfoutput query="tbEstimulosDgapa">

	<cfif LEN(#vpAsignaNoOficio#) EQ 1>
    	<cfset vNumeroOficioAcdEst = '000#vpAsignaNoOficio#'>
	<cfelseif LEN(#vpAsignaNoOficio#) EQ 2>
		<cfset vNumeroOficioAcdEst = '00#vpAsignaNoOficio#'>
	<cfelseif LEN(#vpAsignaNoOficio#) EQ 3>
		<cfset vNumeroOficioAcdEst = '0#vpAsignaNoOficio#'>    
	</cfif>
    
	<cfset vOficioNo = 'P.#vNumeroOficioAcdEst#/' & #LsDateFormat(now(),'YYYY')#>

	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE estimulos_dgapa SET
        estimulo_oficio = '#vOficioNo#'
		WHERE estimulo_id = #estimulo_id#
	</cfquery>

	<cfset #vpAsignaNoOficio# = #vpAsignaNoOficio# + 1>

</cfoutput>

