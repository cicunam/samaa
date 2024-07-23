<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2022 --->
<!--- FECHA ÚLTIMA MOD.: 16/03/2022 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR OPONENTES EN EL COA --->

    <!--- <cfoutput>#vpSolId# - #vpCoaId# - #vActivaCampos#</cfoutput> --->

    <!--- OBTENER LA LISTA DE CONCURSANTES DEL COA --->
    <cfquery name="tbCoaOponentes" datasource="#vOrigenDatosSAMAA#">
	    SELECT * FROM consulta_convocacoa_concursa
	    WHERE coa_id = '#vpCoaId#'
        AND sol_id = #vpSolId#
	    <cfif #vFt# NEQ 15 AND #vFt# NEQ 42>
	    	AND coa_ganador = 0
	    </cfif>
	    ORDER BY acd_apepat, acd_apemat, acd_nombres
    </cfquery>

	<!--- CREAR LA LISTA DE OPONENTES --->
    <cfif #tbCoaOponentes.RecordCount# EQ 0>
        <div class="NoImprimir">
            <strong>SIN OPONENTES REGISTRADOS</strong>
        </div>
    <cfelse>
        <cfif #tbCoaOponentes.RecordCount# LTE 13>
            <cfset vRegInicio = 1>
            <cfset vRegFinal = #tbCoaOponentes.RecordCount#>
            <cfinclude template="coa_lista_oponentes_tabla.cfm">
        <cfelseif #tbCoaOponentes.RecordCount# GT 13>
            <div style="float:left; width: 50%;">
                <cfset vRegInicio = 1>
                <cfset vRegFinal = #tbCoaOponentes.RecordCount# / 2>
                <cfinclude template="coa_lista_oponentes_tabla.cfm">
            </div>
            <div style="float:left; width: 50%;">
                <cfset vRegInicio = #tbCoaOponentes.RecordCount# / 2 + 1>
                <cfset vRegFinal = #tbCoaOponentes.RecordCount#>
                <cfinclude template="coa_lista_oponentes_tabla.cfm">
            </div>
        </cfif>
<!---            
        <table width="50%" align="center">
            <tr>
                <td></td>
                <td><span class="Sans9Gr"><strong>Nombre</strong></span></td>
                <td align="center">
                    <div class="NoImprimir">
                        <cfif #vActivaCampos# NEQ "disabled">Eliminar oponente</cfif>
                    </div>
                </td>
            </tr>        
            <cfoutput query="tbCoaOponentes">
                <tr>
                    <td width="5%"><span class="Sans9Gr"><strong>#CurrentRow#.-</strong></span></td>
                    <td width="65%"><span class="Sans9Gr">#acd_apepat# #acd_apemat# #acd_nombres#</span></td>
                    <td width="30%" align="center">
                        <div class="NoImprimir">
                            <cfif #vActivaCampos# NEQ "disabled">
                                <img src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar oponente" onclick="fOponentesAdm('E', #id#)">
                            </cfif>
                        </div>
                    </td>
                </tr>
            </cfoutput>
        </table>
--->
    </cfif>
    <!--- CONTEO DE PARTICIPANTES EN EL CONCURSO --->        
    <cfif #vFt# EQ 5>
        <cfset vNumConcursa = #tbCoaOponentes.RecordCount# + 1>            
    <cfelseif #vFt# EQ 15 OR #vFt# EQ 42>
        <cfset vNumConcursa = #tbCoaOponentes.RecordCount#>
    <cfelse>
        <cfset vNumConcursa = ''>
    </cfif>
    <!--- REGRESAR EL NÚMERO DE CONCURSANTES EN UN INPUT-HIDDEN --->
    <cfoutput>
        <input type="#vTipoInput#" name="NumConcursa" id="NumConcursa" value="#vNumConcursa#">
    </cfoutput>        