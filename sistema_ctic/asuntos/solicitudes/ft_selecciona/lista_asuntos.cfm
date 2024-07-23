<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 17/10/2023 --->
<!--- LISTAR LOS ASUNTOS ACADÉMICO-ADMINISTRATIVOS DE UN ACADÉMICO (PARA RECUORSOS DE REVISIÓN, RECURSOS DE RECONSIDERACIÓN Y CORRECCIONES A OFICIOS) --->

<!--- Obtener el tipo del año o semestre sabático que se va a modificar --->
<cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
	<!---SELECT DISCTINT acd_clave, mov_consecutivo, mov_no_acta, mov_no_oficio, mov_fec_inicio, mov_fec_final FROM movimientos --->
	SELECT * 
    FROM movimientos AS T1
	LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND asu_reunion = 'CTIC'
	LEFT JOIN catalogo_movimiento ON T1.mov_clave = catalogo_movimiento.mov_clave
	LEFT JOIN catalogo_decision ON T2.dec_clave = catalogo_decision.dec_clave
    <cfif #vTipo# EQ "35">
		LEFT JOIN convocatorias_coa_concursa AS T3 ON T1.coa_id = T3.coa_id AND T3.acd_id = #vIdAcad#
    </cfif>
	WHERE T1.acd_id = #vIdAcad#
	<cfif #vTipo# EQ "31">
		AND NOT (T1.mov_clave = 14 OR T1.mov_clave = 15 OR T1.mov_clave = 16)
		AND (dec_super = 'AP' OR dec_super = 'CO') <!--- Asuntos aprobados y correcciones a oficio --->
		AND NOT asu_oficio = ''
	<cfelseif #vTipo# EQ "35"><!--- SÓLO PARA CONCURSOS --->
		AND 
		(
            (
                T1.mov_clave = 5 
                OR T1.mov_clave = 7 
                OR T1.mov_clave = 8 
                OR T1.mov_clave = 9 
                OR T1.mov_clave = 10 
                OR T1.mov_clave = 15 
                OR T1.mov_clave = 17 
                OR T1.mov_clave = 18 
                OR T1.mov_clave = 19 
                OR T1.mov_clave = 28 
                OR T1.mov_clave = 42
            )
            AND dec_super = 'NA' <!--- Asuntos no aprobados --->
        )
        OR   
        (	<!--- Concursos desiertos --->
        	T1.mov_clave = 15 AND dec_super = 'AP' AND T3.acd_id = #vIdAcad#
		)
        OR   
        (	<!--- Concursos desiertos --->
        	T1.mov_clave = 5 AND dec_super = 'AP' AND T3.acd_id = #vIdAcad#
		)
	<cfelseif #vTipo# EQ "37">
		AND NOT 
        (
        	T1.mov_clave = 5 
			OR T1.mov_clave = 7 
			OR T1.mov_clave = 8 
			OR T1.mov_clave = 9 
			OR T1.mov_clave = 10 
			OR T1.mov_clave = 14 
			OR T1.mov_clave = 15 
			OR T1.mov_clave = 16 
			OR T1.mov_clave = 17 
			OR T1.mov_clave = 18 
			OR T1.mov_clave = 19 
			OR T1.mov_clave = 28 
			OR T1.mov_clave = 35 
			OR T1.mov_clave = 37 
			OR T1.mov_clave = 42
		)
        AND (mov_fecha_inicio BETWEEN (GETDATE() - 180) AND GETDATE() + 60) <!--- Se agregó para lis --->
		<!--- AND dec_super = 'NA' Asuntos no aprobados, se eliminó el filtro, ya que hay un caso del IIB sobre una reconsideración de un asunto PAROBADO (11/09/203) --->
	</cfif>
	ORDER BY mov_fecha_inicio DESC, ssn_id DESC
</cfquery>

<!--- EN CASO DE SELECCIONAR RECURSO DE RECONSIDERACIÓN, SE DEBE INCLUIR LOS INFORMES ANUALES --->
<cfif #vTipo# EQ "37">
    <cfquery name="tbInformesAnual" datasource="#vOrigenDatosSAMAA#">
        SELECT TOP 1 'INFORME ANUAL' AS mov_titulo_corto, * 
        FROM movimientos_informes_anuales AS T1
        LEFT JOIN movimientos_informes_asunto AS T2 ON T1.informe_anual_id = T2.informe_anual_id AND T2.informe_reunion = 'CTIC'
        LEFT JOIN catalogo_decision AS C1 ON T2.dec_clave = C1.dec_clave
        WHERE T1.acd_id = #vIdAcad#
        AND T2.informe_reunion = 'CTIC'
		<!--- AND C1.dec_super = 'NA' ---> <!--- SE ELIMINO ESTA OPCIÓN PORQUE ESXISTEN INCONFORMIDADES EN INFORMES APROBADOS CON COMENTARIO --->
        ORDER BY T1.informe_anio DESC
    </cfquery>
<cfelse>
    <cfquery name="tbInformesAnual" datasource="#vOrigenDatosSAMAA#">
        SELECT 'INFORME ANUAL' AS mov_titulo_corto 
        FROM movimientos_informes_anuales
        WHERE ssn_id = 1
	</cfquery>
</cfif>

<cfscript>
  function PadString(txt, num) 
  {
  	return txt & RepeatString("&nbsp;", num-Len(txt));
  }
</cfscript>


<cfif #tbMovimientos.RecordCount# GT 0 OR (#vTipo# EQ "37" AND #tbInformesAnual.RecordCount# GT 0)>
	<hr />
    <!-- TÍTULO -->
	<div>
    	<span class="Sans10GrNe">
			<cfif #vTipo# EQ "31">
				Seleccione el asunto que desea corregir:
            <cfelseif #vTipo# EQ "35">
				Seleccione el asunto al que desea imponer un recurso de revisión:
            <cfelseif #vTipo# EQ "37">
				Seleccione el asunto al que desea imponer un recurso de reconsideración:            
            </cfif>
		</span>
	</div>
    <!-- ENCABEZADO DE DATOS A DESPLEGAR -->
	<div style="padding:6px 0px 0px 4px; font-family: monospace; font-size: 8pt; font-weight:bold;">
		<cfoutput>#PadString("Asunto",30)# #PadString("Inicio",12)# #PadString("Acta",6)# #PadString("Oficio",24)# </cfoutput>
	</div>
            
    <cfif #tbMovimientos.RecordCount# EQ 1 OR #tbInformesAnual.RecordCount# EQ 1>
        <cfset vSize = "2">
    <cfelse>
        <cfset vSize = "10">        
    </cfif>            
            
        <select id="selAsunto" name="selAsunto" size="10" class="datos" onChange="fSeleccionCompleta();" style="font-family: monospace; font-size: 8pt; font-weight: normal;">
		<cfoutput query="tbMovimientos">
			<!--- VERIFICA SI EXISTEN CORRECIONES A OFICIO (SE AGRAGÓ EL 14/02/2018)  --->
			<cfquery name="tbCorrecionOficio" datasource="#vOrigenDatosSAMAA#">
				SELECT TOP 1 * FROM movimientos_correccion AS T1
                LEFT JOIN movimientos_asunto AS T2 ON T1.sol_id = T2.sol_id AND T2.asu_reunion = 'CTIC'
                WHERE T1.mov_id = #mov_id#
                ORDER BY T2.ssn_id DESC
			</cfquery>        
        
            <option value="#tbMovimientos.mov_id#">
                #PadString(tbMovimientos.mov_titulo_corto,30)# #PadString(LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy'),12)# <cfif #tbCorrecionOficio.RecordCount# EQ 0>#PadString(ToString(tbMovimientos.ssn_id), 6)# #PadString(tbMovimientos.asu_oficio,24)#<cfelse>#PadString(ToString(tbCorrecionOficio.ssn_id), 6)# #PadString(tbCorrecionOficio.asu_oficio,24)#</cfif>
            </option>
		</cfoutput>
		<cfif #vTipo# EQ "37">
			<cfoutput query="tbInformesAnual">
                <option value="I#informe_anual_id#">
                    #PadString(mov_titulo_corto,30)# #PadString(informe_anio,12)# #PadString(ssn_id,6)# #PadString(informe_oficio,24)#
                </option>
            </cfoutput>
		</cfif>
	</select>
<cfelse>
	<span class="Sans11ViNe">
		<cfif #vTipo# EQ "35" OR #vTipo# EQ "37">
			<br>EL ACAD&Eacute;MICO NO CUENTA CON ASUNTOS ACAD&Eacute;MICO-ADMINISTRATIVOS RECHAZADOS.
		<cfelseif #vTipo# EQ "31">
			<br>EL ACAD&Eacute;MICO NO CUENTA CON ASUNTOS ACAD&Eacute;MICO-ADMINISTRATIVOS QUE SE PUEDAN CORREGIR.
		</cfif>
	</span>
</cfif>
