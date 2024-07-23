<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/02/2016 --->
<!--- FECHA ULTIMA MOD.: 02/06/2017 --->
<!--- CÓDIGO QUE CALCULA LA ANTIGÜEDAD ACADÉMICA, SE OCUPA EN VARIOS LUGARES --->

<cfparam name="vIdAcad" default="2352">
<cfparam name="vTipoSolicitudAntig" default="N">
<cfparam name="vSolId" default="0">
<cfparam name="vCampoPos6" default="0">

<cftry>

	<cfset vDiasAntig = 0>
    <cfset vFF = #Now()#>
    <cfset vFDef = #Now()#>	
    <cfset vFBaja = 0>
    <cfset vFCoa = 0>
    <cfset vMovId = 0>
    <cfset vDefinitivo = 0>

	<!--- <cfoutput>#vCampoPos6# #vSolId# #vTipoSolicitudAntig#</cfoutput> --->
    
	<cfif #vTipoSolicitudAntig# EQ 'N' OR #vTipoSolicitudAntig# EQ 'A'>
        <cfquery name="tbAcademico" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM academicos
            WHERE acd_id = #vIdAcad#
        </cfquery>
    
		<cfif #vTipoSolicitudAntig# EQ 'A'>
			<cfquery name="tbSolicitud" datasource="#vOrigenDatosSAMAA#">
                SELECT sol_pos6, cap_fecha_crea
				FROM movimientos_solicitud
                WHERE sol_id = #vSolId#
            </cfquery>
            <cfset vFF = #tbSolicitud.cap_fecha_crea#>
		</cfif>
            
        <cfquery name="tbCalculaAntig" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM ((movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave)
            LEFT JOIN catalogo_movimiento ON movimientos.mov_clave = catalogo_movimiento.mov_clave  <!--- ESTE SE DEBE ELIMINAR --->
            WHERE acd_id = #vIdAcad#
            AND asu_reunion = 'CTIC'
            AND dec_super = 'AP' <!--- Asuntos aprobados --->
            AND catalogo_movimiento.mov_antig_filtro = 1
            ORDER BY mov_fecha_inicio ASC
        </cfquery>
    
        <!--- MUESTRA LOS DATOS PARA CALCULAR LA ANTIGÜEDAD --->
        <cfoutput query="tbCalculaAntig">
            <cfif #mov_fecha_inicio# EQ ""><cfset vFechaInicio = 0>
            <cfelse><cfset vFechaInicio = #LsDateFormat(mov_fecha_inicio, 'dd/mm/yyyy')#>
            </cfif>
    
            <cfif #mov_fecha_final# EQ ""><cfset vFechaFinal = 0>
            <cfelse><cfset vFechaFinal = #LsDateFormat(mov_fecha_final, 'dd/mm/yyyy')#>
            </cfif>
            <cfif vDefinitivo EQ 0>
                <cfif #mov_clave# IS 6 OR #mov_clave# IS 5 OR #mov_clave# IS 25 OR #mov_clave# IS 71 OR #mov_clave# IS 27 OR #mov_clave# IS 60 OR #mov_clave# IS 17 <!--- OR #mov_clave# IS 9 OR #mov_clave# IS 10---> >
                    <!--- VERIFICA SI HAY UNA BAJA PRÓXIMA --->
                    <cfquery name="tbBaja" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM (movimientos
                        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                        WHERE acd_id = #vIdAcad#
                        AND mov_clave = 14
                        AND asu_reunion = 'CTIC'
                        AND dec_super = 'AP'
                        <cfif #vFechaFinal# EQ 0 or #vFechaFinal# EQ ''>
                            AND mov_fecha_inicio >= '#vFechaInicio#'
                        <cfelse>
                            AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                        </cfif>
                    </cfquery>
                    
                    <!--- VERIFICA SI HAY UN COA PRÓXIMA --->
                    <cfquery name="tbCoa" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM (movimientos
                        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                        WHERE acd_id = #vIdAcad#
                        AND asu_reunion = 'CTIC'
                        AND dec_super = 'AP'
                        AND mov_clave = 5
                        <cfif #vFechaFinal# EQ 0 or #vFechaFinal# EQ ''>
                            AND mov_fecha_inicio >= '#vFechaInicio#'
                        <cfelse>
                            AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                        </cfif>
                        <cfif #vFCoa# NEQ 0>
                            AND mov_fecha_inicio <> '#vFCoa#'
                        </cfif>
                        AND mov_id <> #vMovId#
                    </cfquery>
        
                    <!--- VERIFICA SI HAY UNA DEFINITIVIDAD PRÓXIMA --->
                    <cfquery name="tbDef" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM (movimientos
                        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                        WHERE acd_id = #vIdAcad#
                        AND asu_reunion = 'CTIC'
                        AND dec_super = 'AP'
                        AND (mov_clave = 7 OR mov_clave = 8 OR mov_clave = 18 OR mov_clave = 28 OR mov_clave = 67)
                        <cfif #vFechaFinal# EQ 0 or #vFechaFinal# EQ ''>
                            AND mov_fecha_inicio >= '#vFechaInicio#'
                        <cfelse>
                            AND (mov_fecha_inicio >= '#vFechaInicio#' AND mov_fecha_inicio <= '#vFechaFinal#')
                        </cfif>
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
                    <!---		XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX --->
        
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
                <cfelseif #mov_clave# IS 7 OR #mov_clave# IS 8 OR #mov_clave# IS 18 OR #mov_clave# IS 28 OR #mov_clave# IS 67><!--- DEFINITIVIDAD --->
                    <!--- REVISA QUE NO HAYA CONTRATO ALGUNO --->
                    <cfquery name="tbCodCoa" datasource="#vOrigenDatosSAMAA#">
                        SELECT * FROM (movimientos
                        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
                        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave			
                        WHERE acd_id = #vIdAcad#
                        AND asu_reunion = 'CTIC'
                        AND dec_super = 'AP'
                        AND (mov_clave = 5 OR mov_clave = 6)
                        AND mov_fecha_inicio >= '#vFechaInicio#'
                        ORDER BY mov_fecha_inicio ASC
                    </cfquery>
                    <!--- SI EXISTE UN COD O COA --->
                    <cfif #tbCodCoa.RecordCount# GT 0>
                        <cfset vFechaCorte = #LsDateFormat(tbCodCoa.mov_fecha_inicio, 'dd/mm/yyyy')#>
                        <cfif #vFechaCorte# EQ LsDateFormat(#mov_fecha_inicio#, 'dd/mm/yyyy')>
                            <cfset vDiasAntig = vDiasAntig - #DateDiff('d',tbCodCoa.mov_fecha_inicio, tbCodCoa.mov_fecha_final)#>
                            <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
                        <cfelse>
                            <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
                        </cfif>			
                    <cfelse>	
                        <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
                    </cfif>
                    <cfset vDefinitivo = 1>
                <cfelseif #mov_clave# IS 76 AND #LsDateFormat(mov_fecha_inicio, 'yyyy')# GTE 1972 AND #LsDateFormat(mov_fecha_inicio, 'yyyy')# LTE 1974>
                    <cfset vDiasAntig = vDiasAntig + #DateDiff('d',mov_fecha_inicio,vFF)#>
                    <cfset vDefinitivo = 1>
                </cfif>
            </cfif>
        </cfoutput>
	<cfelse>
		<cfset #vDiasAntig# = #vCampoPos6#>
		<cfset vFF = #tbSolicitudes.cap_fecha_crea#>
	</cfif>

	<!--- Obtener la cadena de texto de la antiguedad académica --->	
	<cfif #vDiasAntig# NEQ 0>
		<!--- Calcular años, meses y días --->
		<cfset vF1 = #vFF# - #vDiasAntig#>	
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
				<span class="Sans10NeNe">Antig&uuml;edad acad&eacute;mica: </span><span class="Sans10Gr"><em>#vAntiguedad#</em>
			<cfelseif #vSolId# GT 0>
				<cfif #vTipoSolicitudAntig# EQ 'N' OR #vTipoSolicitudAntig# EQ 'C'>
					<cfset vCampoPos6_txt = #vAntiguedad#>
                	<cfset vCampoPos6 = #vDiasAntig#>
					<!---
                    <input name="vCampoPos6_txt" type="text" disabled id="vCampoPos6_txt" value="#vAntiguedad#" size="30">
                    <input name="vCampoPos6" id="vCampoPos6" type="hidden" value="#vDiasAntig#">
					--->
				<cfelseif #vTipoSolicitudAntig# EQ 'A'>
					<cfquery datasource="#vOrigenDatosSAMAA#">
                    	UPDATE movimientos_solicitud SET
                        sol_pos6 = #vDiasAntig#
                        WHERE sol_id = #vSolId#
                    </cfquery>
				</cfif>
			</cfif>
		</cfoutput>
	<cfelse>
		<span class="Sans10ViNe">NO CUENTA CON ANTIGÜEDAD</span>
	</cfif>	
	<cfcatch type="any">
		<span class="Sans10ViNe">ERROR AL CALCULAR LA ANTIGÜEDAD ACADÉMICA</span>
	</cfcatch>
</cftry>