<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 26/01/2010--->
<!--- AJAX PARA DESGLOSAR LA DURACIÓN DE UN MOVIMIENTO EN AÑOS, MESE Y DÍAS --->
<cfset vFF1 = #dateadd('d',1,LSParseDateTime(mov_fecha_final))#>
<cfset vF1 = #LSParseDateTime(mov_fecha_inicio)#>
<cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF1#)#>
<cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
<cfset vMeses = #DateDiff('m',#vF2#, #vFF1#)#>
<cfset vF3 = #dateadd('m',vMeses,vF2)#>			
<cfset vDias = #DateDiff('d',#vF3#, #vFF1#)#>
<!--- Construir la cadena de texto que se mostrará --->
<cfoutput>
	<input type="text" class="datos" size="1" maxlength="1" value="#vAnios#" #vActivaCampos#>
	<span class="Sans9Gr">año(s)</span>
	<input type="text" class="datos" size="2" maxlength="2" value="#vMeses#" #vActivaCampos#>
	<span class="Sans9Gr">mes(es)</span>
	<input type="text" class="datos" size="2" maxlength="2" value="#vDias#" #vActivaCampos#>
	<span class="Sans9Gr">d&iacute;a(s), del</span>
</cfoutput>