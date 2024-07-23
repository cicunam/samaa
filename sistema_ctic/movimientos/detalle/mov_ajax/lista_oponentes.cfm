<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ULTIMA MOD.: 02/08/2023 --->
<!--- AJAX: LISTA DE OPONENTES/CONCURSANTES --->

<!--- Obtener la lista de oponentes/concursantes --->
<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_convocacoa_concursa 
	WHERE coa_id = '#vConvocatoria#'
    AND sol_id = #vSolId# <!--- Se agrego el 02/08/2023 --->
	<cfif #vFt# NEQ 15 AND #vFt# NEQ 42>
		AND coa_ganador = 0
	</cfif>
	ORDER BY acd_apepat, acd_apemat, acd_nombres    
</cfquery>
<!--- Generar la lista de oponentes/concursantes --->
<table width="100%" align="center">
	<cfoutput query="tbConvocatorias">
		<tr>
			<td class="Sans9Gr" width="5%"><strong>#CurrentRow#.-</strong></td>            
			<td class="Sans9Gr">
				#acd_nombres#<cfif #acd_apepat# NEQ ''> #acd_apepat#</cfif><cfif #acd_apemat# NEQ ''> #acd_apemat#</cfif> 
			</td>
		</tr>
	</cfoutput>
</table>
