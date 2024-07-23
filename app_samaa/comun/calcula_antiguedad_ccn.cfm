<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/02/2016 --->
<!--- FECHA ULTIMA MOD.: 02/06/2017 --->
<!--- CÓDIGO QUE CALCULA LA ANTIGÜEDAD EN CATEGORÍA Y NIVEL, SE OCUPA EN VARIOS LUGARES --->

<cfparam name="vIdAcad" default="0">
<cfparam name="vTipoSolicitudAntigCnn" default="N">
<cfparam name="vSolId" default="0">
<cfparam name="vCampoPos4" default="0">

<cftry>
	<cfset vDiasAntig = 0>
    <cfset vFF = #Now()#>
    <cfset vFDef = #Now()#>	
    <cfset vFBaja = 0>
    <cfset vFCoa = 0>
    <cfset vMovId = 0>

	<!--- <cfoutput>#vCampoPos4# #vSolId# #vTipoSolicitudAntigCnn#</cfoutput><br /> --->

	<cfif #vTipoSolicitudAntigCnn# EQ 'N' OR #vTipoSolicitudAntigCnn# EQ 'A'>
		<!--- ABRE LOS DATOS DEL ACADÉMICO --->
        <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM academicos
            WHERE acd_id = #vIdAcad#
        </cfquery>

        <cfset vIdCnActual = #tbAcademico.cn_clave#>

        <cfif #vTipoSolicitudAntigCnn# EQ 'A'>
            <cfquery name="tbSolicitud" datasource="#vOrigenDatosSAMAA#">
                SELECT sol_pos4, cap_fecha_crea
				FROM movimientos_solicitud
                WHERE sol_id = #vSolId#
            </cfquery>
            <cfset vFF = #tbSolicitud.cap_fecha_crea#>        
		</cfif>

        <cfquery name="tbCalculaAntig" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM ((movimientos
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave)
            LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave <!--- ESTE SE DEBE ELIMINAR --->
            WHERE acd_id = #vIdAcad#
            <cfif #vIdCnActual# EQ 'I2196'>
                AND movimientos.cn_clave = '#vIdCnActual#'
            <cfelse>
                AND (movimientos.mov_cn_clave = '#vIdCnActual#' OR movimientos.cn_clave = '#vIdCnActual#')
            </cfif>
            AND asu_reunion = 'CTIC'
            AND dec_super = 'AP' <!--- Asuntos aprobados --->
            AND catalogo_movimiento.mov_antig_filtro = 1
            ORDER BY ssn_id , mov_fecha_inicio
        </cfquery>
        
        <!--- MUESTRA LOS DATOS PARA CALCULAR LA ANTIGÜEDAD --->
        <cfoutput query="tbCalculaAntig">
            <cfset vMovId = #tbCalculaAntig.mov_id#>
            <cfif #mov_fecha_inicio# EQ ""><cfset vFechaInicio = 0>
            <cfelse><cfset vFechaInicio = #LsDateFormat(mov_fecha_inicio, 'dd/mm/yyyy')#>
            </cfif>
    
            <cfif #mov_fecha_final# EQ ""><cfset vFechaFinal = 0>
            <cfelse><cfset vFechaFinal = #LsDateFormat(mov_fecha_final, 'dd/mm/yyyy')#>
            </cfif>
            <cfif #mov_clave# IS 6 OR #mov_clave# IS 5 OR #mov_clave# IS 25 OR #mov_clave# IS 71  <!--- OR #mov_clave# IS 9 OR #mov_clave# IS 10---> >
                <cfquery name="tbBaja" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM (movimientos
                    LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                    WHERE acd_id = #vIdAcad#
                    AND mov_clave = 14
                    AND asu_reunion = 'CTIC'
                    AND dec_super = 'AP'
                    AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                </cfquery>
    
                <cfquery name="tbCoa" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM (movimientos
                    LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                    WHERE acd_id = #vIdAcad#
                    AND asu_reunion = 'CTIC'
                    AND dec_super = 'AP'
                    AND mov_clave = 5
                    AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                    <cfif #vFCoa# NEQ 0>
                        AND mov_fecha_inicio <> '#vFCoa#'
                    </cfif>
                    AND mov_id <> #vMovId#
                </cfquery>
    
                <cfquery name="tbDef" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM (movimientos
                    LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                    LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                    WHERE acd_id = #vIdAcad#
                    AND asu_reunion = 'CTIC'
                    AND dec_super = 'AP'
                    AND (mov_clave = 7 OR mov_clave = 8 OR mov_clave = 18 OR mov_clave = 28 OR mov_clave = 67)
                    AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                    AND mov_id <> #vMovId#
                </cfquery>
                
                <!--- SI EXISTE BAJA --->
                <cfif #tbBaja.recordcount# EQ 1>
                    <cfset vFBaja = #tbBaja.mov_fecha_inicio#>	
                <cfelse>
                    <cfset vFBaja = 0>										
                </cfif>
                <!--- SI EXISTE COA --->
                <cfif #tbCoa.recordcount# EQ 1>
                    <cfset vFCoa = #LsDateFormat(tbCoa.mov_fecha_inicio-1, 'dd/mm/yyyy')#>	
                    <cfset vFCoaNum = #tbCoa.mov_fecha_inicio# - 1>	
                <cfelse>
                    <cfset vFCoa = 0>
                </cfif>
                <!--- SI EXISTE DEFINITIVIDAD--->
                <cfif #tbDef.recordcount# EQ 1>
                    <cfset vFDef = #LsDateFormat(tbDef.mov_fecha_inicio-1, 'dd/mm/yyyy')#>	
                    <cfset vFDefNum = #tbDef.mov_fecha_inicio# - 1>	
                <cfelse>
                    <cfset vFDef = 0>
                </cfif>
                <cfif #mov_fecha_final# GT #vFF#>
                    <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio, vFF)#>
                <cfelseif #vFCoa# NEQ 0>
                    <cfif #mov_clave# EQ 5>
                        <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio, mov_fecha_final)# + 1>
                    <cfelse>
                        <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio, vFCoaNum)#>
                    </cfif>		
                <cfelseif #vFDef# NEQ 0>
                    <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio, vFDefNum)#>
                <cfelse>
                    <cfif #mov_fecha_final# NEQ ''>
                        <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio, mov_fecha_final)# + 1>
                    <cfelse>
                        <cfset vDiasAntig = vDiasAntig + 0>
                    </cfif>
                </cfif>
            <cfelseif #mov_clave# IS 7 OR #mov_clave# IS 8 OR #mov_clave# IS 18 OR #mov_clave# IS 20 OR #mov_clave# IS 28 OR #mov_clave# IS 67>
                <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
            <cfelseif #mov_clave# IS 9 OR #mov_clave# IS 10 OR #mov_clave# IS 19 OR #mov_clave# IS 61>
                <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
            <cfelseif #mov_clave# IS 76 AND #LsDateFormat(mov_fecha_inicio, 'yyyy')# GTE 1972 AND #LsDateFormat(mov_fecha_inicio, 'yyyy')# LTE 1974>
                <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
            </cfif>
        </cfoutput>
	<cfelse>
		<cfset #vDiasAntig# = #vCampoPos4#>
		<cfset vFF = #tbSolicitudes.cap_fecha_crea#>
	</cfif>
    
	<!--- Obtener la cadena de texto de la antiguedad académica --->	
	<cfif #vDiasAntig# NEQ 0>
		<!--- Calcular años, meses y días --->
		<cfset vF1 = #vFF# - #vDiasAntig#>	<!---#Now()#--->
		<cfset vAntigAcadAnios = #DateDiff('yyyy',vF1, vFF)#>
		<cfset vF2 = #dateadd('yyyy',vAntigAcadAnios,vF1)#>
		<cfset vAntigAcadMeses = #DateDiff('m',vF2, vFF)#>
		<cfset vF3 = #dateadd('m',vAntigAcadMeses,vF2)#>			
		<cfset vAntigAcadDias = #DateDiff('d',vF3, vFF)#>
		<!--- Construir la cadena de texto que se mostrará --->
		<cfset vAntiguedad = "">
		<cfif #vAntigAcadAnios# GT 0>
			<cfif #vAntigAcadAnios# GT 1><cfset vAntiguedad = #vAntigAcadAnios# & " años ">
			<cfelse><cfset vAntiguedad = #vAntigAcadAnios# & " año ">
			</cfif>
		</cfif>
		<cfif #vAntigAcadMeses# GT 0>
			<cfif #vAntigAcadMeses# GT 1><cfset vAntiguedad = #vAntiguedad# & #vAntigAcadMeses# & " meses "> 
			<cfelse><cfset vAntiguedad = #vAntiguedad# & #vAntigAcadMeses# & " mes ">
			</cfif>
		</cfif>
		<cfif #vAntigAcadDias# GT 0>
			<cfif #vAntigAcadDias# GT 1><cfset vAntiguedad = #vAntiguedad#  & #vAntigAcadDias# & " días"> 
			<cfelse><cfset vAntiguedad = #vAntiguedad#  & #vAntigAcadDias# & " día">
			</cfif>
		</cfif>
		<cfoutput>
			<cfif #vSolId# EQ 0>
            	<span class="Sans10NeNe">Antig&uuml;edad en nombramiento: </span><span class="Sans10Gr"><em>#vAntiguedad#</em>
			<cfelseif #vSolId# GT 0>
				<cfif #vTipoSolicitudAntigCnn# EQ 'N' OR #vTipoSolicitudAntigCnn# EQ 'C'>
					<cfset vCampoPos4_txt = #vAntiguedad#>
                	<cfset vCampoPos4 = #vDiasAntig#>
					<!---                
	            	<input name="vCampoPos4_txt" type="text" disabled id="vCampoPos4txt" value="#vAntiguedad#" size="30">
    	            <input name="vCampoPos4" id="vCampoPos4" type="hidden" value="#vDiasAntig#">
					--->
				<cfelseif #vTipoSolicitudAntigCnn# EQ 'A'>
					<cfquery datasource="#vOrigenDatosSAMAA#">
                    	UPDATE movimientos_solicitud SET
                        sol_pos4 = #vDiasAntig#
                        WHERE sol_id = #vSolId#
                    </cfquery>
				</cfif>
			</cfif>
		</cfoutput>
	<cfelse>
		<span class="Sans10ViNe">NO CUENTA CON ANTIGÜEDAD EN NOMBRAMIENTO</span>
	</cfif>
	<cfcatch type="any">
		<span class="Sans10ViNe">ERROR AL CALCULAR LA ANTIGÜEDAD EN NOMBRAMIENTO</span>
	</cfcatch>
</cftry>