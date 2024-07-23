<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 01/02/2017 --->
<!--- FECHA �LTIMA MOD.: 01/02/2017 --->
<!--- SE MOVI� DEL ARCHIVO nuevo_academico_guarda.cfm y lista_oponentes.cfm PARA RE-UTILIZAR EN DIFERENTES SITIOS --->

<!--- Obtener el siguiente n�mero de acad�mico disponible --->
<cfquery name="tbContadoresAcad" datasource="#vOrigenDatosSAMAA#">
	SELECT c_academicos FROM contadores;
	EXEC INCREMENTAR_CONTADOR 'ACD';
</cfquery>

<cfif IsDefined('vComandoDestino') AND #vComandoDestino# EQ 'INSERTA'>
	<!--- Registrar n�mero de acad�mico alta de oponente para COA --->
	<cfset selOponente = #tbContadores.c_academicos#>
<cfelse>
	<!--- Registrar n�mero de acad�mico alta de acad�micos nuevos --->
    <cfset vAcadId = #tbContadoresAcad.c_academicos#>
</cfif>    
	