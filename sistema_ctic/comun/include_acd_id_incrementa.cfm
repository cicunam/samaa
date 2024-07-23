<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/02/2017 --->
<!--- FECHA ÚLTIMA MOD.: 01/02/2017 --->
<!--- SE MOVIÓ DEL ARCHIVO nuevo_academico_guarda.cfm y lista_oponentes.cfm PARA RE-UTILIZAR EN DIFERENTES SITIOS --->

<!--- Obtener el siguiente número de académico disponible --->
<cfquery name="tbContadoresAcad" datasource="#vOrigenDatosSAMAA#">
	SELECT c_academicos FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'ACD';
</cfquery>

<cfif IsDefined('vComandoDestino') AND #vComandoDestino# EQ 'INSERTA'>
	<!--- Registrar número de académico alta de oponente para COA --->
	<cfset selOponente = #tbContadores.c_academicos#>
<cfelse>
	<!--- Registrar número de académico alta de académicos nuevos --->
    <cfset vAcadId = #tbContadoresAcad.c_academicos#>
</cfif>    
	