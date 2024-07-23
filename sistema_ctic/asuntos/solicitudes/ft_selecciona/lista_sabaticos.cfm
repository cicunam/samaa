<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA: 06/05/2009--->
<!--- LISTAR LOS PERIODOS SABÁTICOS DE UN ACADÉMICO (PARA MODIFICACIONES E INFORMES) --->
<!--- NOTA: Quiza sea mejor utilizar encabezados en las columnas como en los demás casos --->
<!--- Obtener el año o semestre sabático que se va a modificar --->
<cfparam name="vIdAcad" default="0">
<cfparam name="vFt" default="0">

<cfquery name="tbMovimientosSabaticos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id) 
	LEFT JOIN catalogo_movimiento AS C1 ON T1.mov_clave = C1.mov_clave)
	LEFT JOIN catalogo_decision AS C2 ON T2.dec_clave = C2.dec_clave
	WHERE acd_id = #vIdAcad#
	AND (T1.mov_clave = 21 OR T1.mov_clave = 30 <cfif #vFt# EQ 23> OR T1.mov_clave = 32)<cfelse> ) </cfif>
	AND T2.asu_reunion = 'CTIC'
	AND C2.dec_super = 'AP' <!--- Asuntos aprobados --->
	ORDER BY T1.mov_fecha_inicio DESC
</cfquery>
<cfscript>
  function PadString(txt, num) 
  {
  	return txt & RepeatString("&nbsp;", num-Len(txt));
  }
</cfscript>
<cfif #tbMovimientosSabaticos.RecordCount# GT 0>
	<br />
	<hr />
    <!-- TÍTULO -->
	<div>
		<span class="Sans10GrNe">
			<cfif #vFt# EQ 23>
				Periodo sabático que va a informar:
			<cfelseif  #vFt# EQ 32>
				Periodo sabático que va a modificar:
			</cfif>
		</span>
	</div>
    <!-- ENCABEZADO DE DATOS A DESPLEGAR -->
	<div style="padding:6px 0px 0px 4px; font-family: monospace; font-size: 8pt; font-weight: bold;">
		<cfif #vFt# EQ 23>
			<cfoutput>#PadString("Tipo",20)# #PadString("Periodo sabático",30)# #PadString("DGAPA",6)#</cfoutput>
		<cfelse>
			<cfoutput>#PadString("Periodo sabático",30)# #PadString("DGAPA",6)#</cfoutput>
		</cfif>
	</div>
	<select id="selSaba" name="selSaba" 
		<cfif #tbMovimientosSabaticos.RecordCount# EQ 1>
			size="2"
		<cfelseif #tbMovimientosSabaticos.RecordCount# GT 10>
			size="10"
		<cfelse>
			size="<cfoutput>#tbMovimientosSabaticos.RecordCount#</cfoutput>"
		</cfif>
		class="datos" onChange="fSeleccionCompleta();" style="font-family: monospace; font-size: 8pt; font-weight: normal;">
		<cfoutput query="tbMovimientosSabaticos">
			<cfif #vFt# EQ 23>
				<option value="#mov_id#">
					<cfif #mov_clave# EQ 32>#PadString("Modificación",20)#<cfelse>#PadString("Sabático",20)#</cfif>#PadString("#LsDateFormat(tbMovimientosSabaticos.mov_fecha_inicio,'dd/mm/yyyy')# al #LsDateFormat(tbMovimientosSabaticos.mov_fecha_final,'dd/mm/yyyy')#",30)# <cfif #mov_clave# EQ 32>#PadString("#Iif(tbMovimientosSabaticos.mov_texto EQ 'BECA',DE("Si"),DE("No"))#",6)#<cfelse>#PadString("#Iif(tbMovimientosSabaticos.mov_clave EQ 30,DE("Si"),DE("No"))#",6)#</cfif>
				</option>
			<cfelse>
				<!---  <option value="#LsDateFormat(tbMovimientosSabaticos.mov_fecha_inicio,'dd/mm/yyyy')#"> Creo que es mejor pasar el ID del movimiento --->
				<option value="#mov_id#"> <!--- SE REALIZÓ EL CAMBIO POR EL ID DEL MOVIMIENTO --->
					#PadString("#LsDateFormat(tbMovimientosSabaticos.mov_fecha_inicio,'dd/mm/yyyy')# al #LsDateFormat(tbMovimientosSabaticos.mov_fecha_final,'dd/mm/yyyy')#",30)# #PadString("#Iif(tbMovimientosSabaticos.mov_clave EQ 30,DE("Si"),DE("No"))#",6)#
				</option>
			</cfif>
		</cfoutput>
	</select>
<cfelse>
	<span class="Sans9Vi"><br>EL ACAD&Eacute;MICO NO TIENE PERIODOS SAB&Aacute;TICOS QUE PUEDAN MODIFICARSE.</span>
</cfif>
