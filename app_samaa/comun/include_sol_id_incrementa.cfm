<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/01/2017 --->
<!--- FECHA �LTIMA MOD.: 27/01/2017 --->
<!--- SE MOVI� DEL ARCHIVO select_ft_n.cfm PARA RE-UTILIZAR EN DIFERENTES SITIOS --->

<!--- Obtener el siguiente n�mero de solicitud disponible --->
<cfquery name="tbContadoresSol" datasource="#vOrigenDatosSAMAA#">
	SELECT c_solicitudes FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'SOL';
</cfquery>

<cfif #tbContadoresSol.c_solicitudes# EQ 0 OR  #tbContadoresSol.c_solicitudes# EQ ''>
	<cfloop index="vIntentos" from="1" to="50"> 
		<!--- Obtener el siguiente n�mero de solicitud disponible --->
		<cfquery name="tbContadoresSol" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM contadores;
			EXEC INCREMENTAR_CONTADOR 'SOL';
		</cfquery>
		<cfif #tbContadoresSol.c_solicitudes# GT 0>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>


<!--- Registrar n�mero de solicitud --->
<cfset vIdSol = #tbContadoresSol.c_solicitudes#>