<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 30/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 30/05/2019 --->
<!--- ELIMINA EL REGISTRO SELECCIONADO DEL MÓDULO DE ESTÍMULOS DGAPA   --->

<cfif isValid("integer", #vpEstimuloId#) AND #vpEstimuloId# GT 0>
	<cfquery datasource="#vOrigenDatosSAMAA#">
    	DELETE estimulos_dgapa
		WHERE estimulo_id = #vpEstimuloId#
	</cfquery>
</cfif>