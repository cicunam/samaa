<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA: 11/03/2010--->
<!--- AJAX PARA ACTUALIZAR LA INFORMACIÓN DE LA FIRMA DE LA FT --->

<!---Actualizar el campo indicado --->
<cfswitch expression="#vParte#">
	<!--- Fecha de firma --->
	<cfcase value="FechaFirma">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_fecha_firma = '#vFechaFirma#'
			WHERE sol_id = #vIdSol#
		</cfquery>
	</cfcase>
	<!--- Académico que firma --->
	<cfcase value="AcademicoFirma">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET acd_id_firma = #vAcdIdFirma#
			WHERE sol_id = #vIdSol#
		</cfquery>
	</cfcase>
</cfswitch>


