<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA CREA: 21/09/2009--->
<!--- FECHA ÚLTIMA MOD: 24/09/2021--->
<!--- LISTAR LAS PLAZAS DE UNA DEPENDENCIA --->
<!--- Obtener la lista de convocatorias vigantes --->

<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
	SELECT coa_id, coa_no_plaza, coa_gaceta_fecha, dep_siglas
    FROM consulta_convocatorias_coa 
	WHERE YEAR(coa_gaceta_fecha) BETWEEN (#LsDateFormat(now(), 'yyyy')# - 2) AND #LsDateFormat(now(), 'yyyy')#
	<cfif #vFt# EQ 17><!--- NUEVO DICTAMEN DE CONCURSO DESIERTO --->
        AND (coa_status = 5 OR coa_status = 15)
	<cfelseif #vFt# EQ 42><!--- NUEVO DICTAMEN DE CONCURSO DESIERTO --->
    	AND coa_status = 15        
	<cfelse>
    	AND coa_status = 4
	</cfif>
	<cfif #Session.sTipoSistema# IS 'sic'>
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
	<!--- Pendientes filtros para FT-CTIC-15 (solo vacantes), FT-CTIC-42 (solo devueltas), etc. --->
	ORDER BY coa_no_plaza
</cfquery>
<cfscript>
  function PadString(txt, num) 
  {
  	return txt & RepeatString("&nbsp;", num-Len(txt));
  }
</cfscript>
<cfif #tbConvocatorias.RecordCount# GT 0>
    <cfif #tbConvocatorias.RecordCount# EQ 1>
	    <cfset vSize = 2>
    <cfelseif #tbConvocatorias.RecordCount# GT 10>
	    <cfset vSize = 10>
	<cfelse>
        <cfset vSize = #tbConvocatorias.RecordCount#>
	</cfif>    
	<hr />
    <!-- TÍTULO -->
	<div><span class="Sans10GrNe">Seleccione el n&uacute;mero de plaza al que hace referencia la convocatoria:</span></div>
    <!-- ENCABEZADO DE DATOS A DESPLEGAR -->
	<div style="padding:6px 0px 0px 4px; font-family: monospace; font-size: 8pt; font-weight:bold;">
    	<cfoutput>#PadString("Plaza",10)# #PadString("Fecha pub.",12)# <!---#PadString("Entidad",10)# #PadString("Categoría y nivel",20)#---></cfoutput>
	</div>
	<select id="vIdCoa" name="vIdCoa" size="<cfoutput>#vSize#</cfoutput>" class="datos" onChange="fSeleccionCompleta();" style="font-family: monospace; font-size: 8pt; font-weight: normal;">
		<cfoutput query="tbConvocatorias">
			<option value="#tbConvocatorias.coa_id#">
			#PadString("#coa_no_plaza#",10)# #PadString(LsDateFormat(coa_gaceta_fecha,"dd/mm/yyyy"),12)#<cfif #Session.sTipoSistema# IS 'stctic'> #PadString(dep_siglas, 8)# </cfif><!---#PadString("#tbConvocatorias.coa_ccn#",20)#--->
			</option>
		</cfoutput>
	</select>
<cfelse>
	<span class="Sans9Vi"><br><strong>POR EL MOMENTO LA DEPENDENCIA NO TIENE PLAZAS PUESTAS A CONCURSO DE COA.</strong></span>
</cfif>
