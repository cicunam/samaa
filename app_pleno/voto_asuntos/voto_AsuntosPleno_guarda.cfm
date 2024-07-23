<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/11/2023 --->
<!--- FECHA ULTIMA MOD.: 23/11/2023 --->
<!--- INCLUDE QUE ACTIVAR LA VOTACIÓN, VOTAR Y VER RESULTADOS PARA LOS MIEMBROS DEL CTIC  --->


<cfquery datasource="#vOrigenDatosSAMAA#">
    INSERT INTO movimientos_sesion_voto
    (sol_id, ssn_id, acd_id, voto_id, fecha_voto)
    VALUES
    (#sol_id#, #ssn_id#, 123, #voto_id#, GETDATE())
</cfquery>