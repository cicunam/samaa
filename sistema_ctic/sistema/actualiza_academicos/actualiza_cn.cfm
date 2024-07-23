<!--- CREADO: ARAM_PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA: 01/10/2010 --->
<!--- ACTUALIZA LA CLASE, CATEGORÍA Y NIVEL DE LOS ACADÉMICOS DEL SAMAA --->

<!--- Parámetros --->
<cfparam name="vIdInicioAct" default="1">
<cfparam name="vidFinalAct" default="2">

<!---
<cfset vIdInicioAct = 1>
<cfset vidFinalAct = 100>
--->

INICIO DEL PROCESO: <cfoutput>#LsTimeFormat(now(),'HH:mm:ss')#</cfoutput><br><br>

<!--- Obtener la lista de los académicos --->
<cfquery name="tbAcademicos" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM academicos 
	WHERE
    acd_id BETWEEN #vIdInicioAct# AND #vidFinalAct#
	<!--- acd_id = 1333  --->
    ORDER BY acd_id
</cfquery>

<cfloop query="tbAcademicos">

	<!-- VARIABLE PARA GURDAR EL IDENTIFICADOR DEL ACADÉMICO -->
	<cfset vAcdId = #tbAcademicos.acd_id#>
	<cfset vAcdCn = #tbAcademicos.cn_clave#>    
	<!-- ABRE LA BASE DE DATOS DE MOVIMIENTOS PARA VER CUAL ES LA ULTIMA CATEGORÍA Y NIVEL -->
    <cfquery name="tbMovimientos" datasource="#vOrigenDatosSAMAA#">
        SELECT * FROM (movimientos 
        LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
        LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
        WHERE movimientos.acd_id = #vAcdId# 
        AND movimientos_asunto.asu_reunion = 'CTIC' 
        AND catalogo_decision.dec_super = 'AP'
        AND (mov_clave = 61 OR mov_clave = 28 OR mov_clave = 9 OR  mov_clave = 10 OR mov_clave = 19 OR mov_clave = 5 OR mov_clave = 25 OR mov_clave = 6 OR mov_clave = 17)
        ORDER BY mov_fecha_inicio DESC
    </cfquery>

<!---
    <cfif #tbMovimientos.RecordCount# GT 0 AND #vAcdCn# NEQ #tbMovimientos.mov_cn_clave#>
	<cfoutput>
		<cfoutput>#tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#</cfoutput><br>    
		#vAcdCn# -- #tbMovimientos.mov_cn_clave# - #tbMovimientos.mov_clave# - #LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#  - #LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#<br>
	</cfoutput>
    </cfif>

	<cfoutput>
        <cfloop query="tbMovimientos">
            #tbMovimientos.mov_cn_clave# - #tbMovimientos.mov_clave# - #LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#  - #LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#<br>
        </cfloop>
	</cfoutput>
--->
	<cfif #tbMovimientos.RecordCount# GT 0 AND #vAcdCn# NEQ #tbMovimientos.mov_cn_clave#>
		<cfset vCcnAct = #tbMovimientos.mov_cn_clave#>
        <cfset vTipoMov = #tbMovimientos.mov_clave#>
    
		<cfoutput>
			#tbAcademicos.acd_apepat# #tbAcademicos.acd_apemat# #tbAcademicos.acd_nombres#<br>    
			#vAcdCn# -- #tbMovimientos.mov_cn_clave# - #tbMovimientos.mov_clave# - #LsDateFormat(tbMovimientos.mov_fecha_inicio,'dd/mm/yyyy')#  - #LsDateFormat(tbMovimientos.mov_fecha_final,'dd/mm/yyyy')#<br>
		</cfoutput>

        <!-- ABRE LA BASE DE DATOS DE MOVIMIENTOS PARA VER CUAL ES LA ULTIMA CATEGORÍA Y NIVEL -->
        <cfquery name="tbMovAct" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM (movimientos 
            LEFT JOIN movimientos_asunto ON movimientos.sol_id = movimientos_asunto.sol_id)
            LEFT JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
            WHERE movimientos.acd_id = #vAcdId# 
            AND movimientos_asunto.asu_reunion = 'CTIC' 
            AND catalogo_decision.dec_super = 'AP'
            AND (mov_clave = 61 OR mov_clave = 28 OR mov_clave = 9 OR  mov_clave = 10 OR mov_clave = 19 OR mov_clave = 5 OR mov_clave = 25 OR mov_clave = 6 OR mov_clave = 17)
            AND mov_cn_clave = '#vCcnAct#'
            ORDER BY mov_fecha_inicio ASC
        </cfquery>
		MOVIMIENTOS CON LA CATEGORÍA Y NIVEL<br />
		<cfoutput>
            <cfloop query="tbMovAct">
                #tbMovAct.mov_cn_clave# - #tbMovAct.mov_clave# - #LsDateFormat(tbMovAct.mov_fecha_inicio,'dd/mm/yyyy')#  - #LsDateFormat(tbMovAct.mov_fecha_final,'dd/mm/yyyy')#<br>
            </cfloop>
        </cfoutput>
        
    <!---
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE academicos SET 
            ccn_calve = #vCcnAct#, fecha_cn = '##'
            
            WHERE sol_id = #vSolId#
        </cfquery>
    --->
    <hr />
	</cfif>

</cfloop>


<cfoutput>
	FINALIZÓ LA ACTUALIZACIÓN DE LA CATEGORÍA Y NIVEL ACTUAL<br>
	FIN DEL PROCESO: #LsTimeFormat(now(),'HH:mm:ss')#<br>
	DEL REGISTRO #vIdInicioAct# AL #vidFinalAct#
</cfoutput>
