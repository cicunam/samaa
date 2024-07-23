<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 09/03/2010 --->
<!--- FECHA ÚLTIMA MOD.: 20/11/2020 --->
<!--- AJAX PARA ACTUALIZAR LA INFORMACIÓN DE CONTROL DE LAS FT --->

<!---Actualizar el campo indicado --->
<cfswitch expression="#vParte#">
	<!--- Acta --->
	<cfcase value="Acta">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET ssn_id = #vActa#
			WHERE sol_id = #vIdSol# 
			AND ssn_id = <cfif #vActa# EQ #Session.sSesion#>#Session.sSesion# + 1<cfelse>#Session.sSesion#</cfif>
			<cfif #vStatus# IS 1>AND asu_reunion = 'CTIC'<cfelseif #vStatus# IS 2>AND asu_reunion = 'CAAA'</cfif> 
		</cfquery>
	</cfcase>
	<!--- Sección CAAA y CTIC --->
	<cfcase value="SeccionCAAA;SeccionCTIC" delimiters=";">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto
            SET asu_parte = #vSeccion#
			WHERE sol_id = #vIdSol# 
            AND ssn_id = #vActa#
			<cfif #vParte# EQ 'SeccionCTIC'>
                AND asu_reunion = 'CTIC'
            <cfelseif #vParte# EQ 'SeccionCAAA'>
                AND asu_reunion = 'CAAA'
            </cfif>
		</cfquery>
	</cfcase>
	<!--- Número de asunto CAAA y CTIC --->
	<cfcase value="AsuntoCAAA;AsuntoCTIC" delimiters=";">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET asu_numero = #vAsunto#
			WHERE sol_id = #vIdSol# AND ssn_id = #vActa#
			<cfif #vParte# IS 'AsuntoCTIC'>AND asu_reunion = 'CTIC'<cfelseif #vParte# IS 'AsuntoCAAA'>AND asu_reunion = 'CAAA'</cfif>
		</cfquery>
	</cfcase>
	<!--- Hay comentario solo para CAAA  --->
	<cfcase value="ComentarioCAAA" delimiters=";">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET asu_comentario = <cfif #vComentario# IS 'Si'>1<cfelse>0</cfif>
			WHERE sol_id = #vIdSol# AND ssn_id = #vActa#
            AND asu_reunion = 'CAAA'
		</cfquery>
	</cfcase>
	<!--- Notas solo CAAA --->
	<cfcase value="NotasCAAA" delimiters=";">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET asu_notas = '#vNotas#'
			WHERE sol_id = #vIdSol# AND ssn_id = #vActa#
            AND asu_reunion = 'CAAA'
		</cfquery>
	</cfcase>
	<!--- Comentario para oficio --->
	<cfcase value="AsuComentaCtic" delimiters=";">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto
            SET asu_oficio_comenta = '#vAsuComentarioCTIC#'
			WHERE sol_id = #vIdSol#
			AND ssn_id = #vActa#
            AND asu_reunion = 'CTIC'
		</cfquery>
	</cfcase>
	<!--- Fecha del oficio --->
	<cfcase value="FechaOficio">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET asu_fecha_oficio = '#vFechaOficio#'
			WHERE sol_id = #vIdSol# AND ssn_id = #vActa#
            AND asu_reunion = 'CTIC'
		</cfquery>
	</cfcase>
	<!--- Sintesis --->
	<cfcase value="Sintesis">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_sintesis = '#vSintesis#'
			WHERE sol_id = #vIdSol#
		</cfquery>
	</cfcase>
	<!--- Observaciones --->
	<cfcase value="Observa">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_solicitud SET sol_observaciones = '#vObserva#'
			WHERE sol_id = #vIdSol#
		</cfquery>
	</cfcase>
	<!--- Recomandación de la CAAA --->
	<cfcase value="RecCAAA">
		<cflocation url="../../../reuniones/recomendacion_decision.cfm?vIdSol=#vIdSol#&vActa=#vActa#&vReunion=CAAA&vDecision=#vRecCAAA#" addtoken="false">
	</cfcase>
	<!--- Decisión del CTIC --->
	<cfcase value="DecCTIC">
		<cflocation url="../../../reuniones/recomendacion_decision.cfm?vIdSol=#vIdSol#&vActa=#vActa#&vReunion=CTIC&vDecision=#vDecCTIC#" addtoken="false">
	</cfcase>
</cfswitch>


