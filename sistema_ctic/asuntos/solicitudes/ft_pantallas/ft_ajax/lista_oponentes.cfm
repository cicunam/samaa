<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 26/01/2022 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
	
	<!--- Parámetros --->
	<cfparam name="vComandoDestino" default="">
	
	<!--- AGREGAR EL GANADOR A LA LISTA DE CONCURSANTES DEL COA --->
	<cfif #vComandoDestino# IS 'GANADOR'>
 		<!--- DESMARCAR AL GANADOR ACTUAL --->       
		<cfquery datasource="#vOrigenDatosSAMAA#">
	        UPDATE convocatorias_coa_concursa 
            SET coa_ganador = 0 
			WHERE sol_id = #vIdSol#
            AND coa_id = '#vConvocatoria#' 
        </cfquery>
		<!--- VERIFICAR SI EL GANADOR YA ESTA EN LA LISTA --->
		<cfquery name="tbConvocatoriasGanador" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM convocatorias_coa_concursa 
		    WHERE sol_id = #vIdSol#
            AND coa_id = '#vConvocatoria#' 
		    AND acd_id = #selOponente#
		</cfquery>
		<!--- SI NO ESTÁ EN LA LISTA ENTONCES AGREGARLO --->
		<cfif #tbConvocatoriasGanador.RecordCount# EQ 0>
			<cfquery datasource="#vOrigenDatosSAMAA#">
		        INSERT INTO convocatorias_coa_concursa (sol_id,coa_id, acd_id, coa_ganador) 
		        VALUES (
                #vIdSol#
                ,
		        <cfif IsDefined("vConvocatoria") AND #vConvocatoria# NEQ "">
		        '#vConvocatoria#'<cfelse>NULL</cfif>
		        ,
		        <cfif IsDefined("selOponente") AND #selOponente# NEQ 0>
		        #selOponente#<cfelse>0</cfif>
		        ,
		        1
		        )
	        </cfquery>
	    <!--- SI YA ESTÁ EN LA LISTA SOLAMENTE MARCARLO COMO GANADOR --->    
	    <cfelse>
	    	<cfquery datasource="#vOrigenDatosSAMAA#">
		        UPDATE convocatorias_coa_concursa 
		        SET coa_ganador = 1
		        WHERE sol_id = #vIdSol#
                AND coa_id = '#vConvocatoria#' 
		    	AND acd_id = #selOponente#
	        </cfquery>    	
		</cfif>
	</cfif>
	
	<!--- AGREGAR AL OPONENTE A LA LISTA DE CONCURSANTES DEL COA --->
	<cfif #vComandoDestino# IS 'INSERTA'>
		<!--- SI SE SELECCIONO LA OPCIÓN "NUEVO OPONENTE" --->
		<cfif #selOponente# EQ "NUEVO">
<!---
			<!--- INCLUDE Obtener el siguiente número de académico ACD_ID disponible --->
            <cfinclude template="#vCarpetaRaizLogica#/sistema_ctic/comun/include_acd_id_incrementa.cfm">
--->

			<!--- Obtener el siguiente número de académico disponible --->
			<cfquery name="tbContadores" datasource="#vOrigenDatosSAMAA#">
				SELECT * FROM contadores;
				EXEC INCREMENTAR_CONTADOR 'ACD';
			</cfquery>
			<!--- Registrar número de académico --->
			<cfset selOponente = #tbContadores.c_academicos#>

			<!--- Crear un RFC temporal --->
            <cfset vRfcAcad = "SINRFC" & #selOponente#>
            <cfset vActivaCampos = "">

			<!--- Crear el registro del nuevo académico en la base de datos --->
			<cfquery datasource="#vOrigenDatosSAMAA#">
                INSERT INTO academicos (acd_id, acd_rfc, grado_clave, acd_apepat, acd_apemat, acd_nombres, acd_sexo, pais_clave) 
				VALUES (
                    <cfif IsDefined("selOponente") AND #selOponente# NEQ "">
                        #selOponente#<cfelse>0</cfif>
                    ,
                    <cfif IsDefined("vRfcAcad") AND #vRfcAcad# NEQ "">
                        '#vRfcAcad#'<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmGrado") AND #frmGrado# NEQ "">
                        #frmGrado#<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmPaterno") AND #frmPaterno# NEQ "">
                        '#Ucase(frmPaterno)#'<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmMaterno") AND #frmMaterno# NEQ "">
                        '#Ucase(frmMaterno)#'<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmNombres") AND #frmNombres# NEQ "">
                        '#Ucase(frmNombres)#'<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmSexo") AND #frmSexo# NEQ "">
                        '#Ucase(frmSexo)#'<cfelse>NULL</cfif>
                    ,
                    <cfif IsDefined("frmNacionalidad") AND #frmNacionalidad# NEQ "">
                        '#Ucase(frmNacionalidad)#'<cfelse>NULL</cfif>
					)
            </cfquery>
        </cfif>
		<!--- AGREGAR AL ACADÉMICO A LA LISTA DE CONCURSANTES DEL COA --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
	        INSERT INTO convocatorias_coa_concursa (sol_id, coa_id, acd_id, coa_ganador) 
	        VALUES (
			#vIdSol#
			,
	        <cfif IsDefined("vConvocatoria") AND #vConvocatoria# NEQ "">
	        '#vConvocatoria#'<cfelse>NULL</cfif>
	        ,
	        <cfif IsDefined("selOponente") AND #selOponente# NEQ 0>
	        #selOponente#<cfelse>0</cfif>
	        ,
		    0
	        )
        </cfquery>
    </cfif>
    
	<!--- ELIMINAR AL OPONENTE DE LA LISTA DE CONCURSANTES DEL COA --->
    <cfif #vComandoDestino# IS 'ELIMINA'>
        <cfquery datasource="#vOrigenDatosSAMAA#">
            DELETE FROM convocatorias_coa_concursa 
            WHERE 1 = 1
	        AND (sol_id = #vIdSol# OR sol_id IS NULL)
            AND coa_id = '#vConvocatoria#' 
            AND acd_id = #selOponente#
            AND coa_ganador = 0
        </cfquery>
    </cfif>
	
	<!--- EN TODOS LOS CASOS --->

	<!--- OBTENER LA LISTA DE CONCURSANTES DEL COA --->
    <cfquery name="tbConvocatorias1" datasource="#vOrigenDatosSAMAA#">
	    SELECT * FROM convocatorias_coa_concursa AS T1
	    LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id 
	    WHERE 1 = 1
        AND (T1.sol_id = #vIdSol# OR T1.sol_id IS NULL)
        AND T1.coa_id = '#vConvocatoria#' 
	    <cfif #vFt# NEQ 15 AND #vFt# NEQ 42>
	    	AND T1.coa_ganador = 0
	    </cfif>
	    ORDER BY T2.acd_apepat, T2.acd_apemat, T2.acd_nombres
    </cfquery>
	
	<!--- CREAR LA LISTA DE OPONENTES --->
	<cfoutput>
		<table width="100%" align="center">
			<cfloop query="tbConvocatorias1">
				<tr>
					<td width="10%"><span class="Sans9GrN">#CurrentRow#.-</span></td>
					<td width="80%"><span class="Sans9Gr">#acd_apepat# #acd_apemat# #acd_nombres#</span></td>
                    <td width="10%">
                        <div align="right" class="NoImprimir">
							<cfif #vActivaCampos# NEQ "disabled">
                            	<img src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar oponente" onclick="fAgregarOponente('ELIMINA', #tbConvocatorias1.acd_id#)">
							</cfif>
<!--- ELIMINA XXXXXXXXXXXXXX
							<input type="button" name="cmdElimina" id="cmdElimina" value="X" class="botonesStandar" onclick="fAgregarOponente('ELIMINA', #tbConvocatorias1.acd_id#)" <cfif #vActivaCampos# EQ "disabled">disabled</cfif>>
--->					
						</div>
					</td>
				</tr>
			</cfloop>
		</table>
	</cfoutput>
    
	<!--- OBTENER EL NÚMERO DE CONCURSANTES DEL COA INCLUYENDO AL GANADOR --->
    <cfquery name="tbConvocatoriasCuenta" datasource="#vOrigenDatosSAMAA#">
	    SELECT * FROM convocatorias_coa_concursa 
        WHERE coa_id = '#vConvocatoria#'
        AND sol_id = #vIdSol#
    </cfquery>
	
	<!--- REGRESAR EL NÚMERO DE CONCURSANTES EN UN INPUT-HIDDEN --->
	<input type="hidden" name="NumOponentes" id="NumOponentes" value="<cfoutput>#tbConvocatoriasCuenta.RecordCount#</cfoutput>">	