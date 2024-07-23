<!--- CREADO: ARAM PICHARDO --->
<!--- CREADO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 22/08/2019 --->
<!--- GUARDA LAS ALTAS O MODIFICACIONES A LOS ASUNTOS DE LAS SOLITITUDES,INFORMES O MOVIMIENTOS--->

<cfif #vTipoAsunto# EQ 'MOV' OR #vTipoAsunto# EQ 'SOL'>
	<cfif #vAsuntoId# GT 0>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_asunto SET
			asu_parte = #asu_parte#,
			asu_numero = #asu_numero#,
			dec_clave = '#dec_clave#'
			<cfif IsDefined('oficio')>, asu_oficio = '#oficio#'</cfif>
			<cfif IsDefined('vComentario')>, asu_notas = '#vComentario#'</cfif>
			WHERE id = #vAsuntoId#
		</cfquery>
	<cfelseif #vAsuntoId# EQ 0>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO movimientos_asunto
			(sol_id, ssn_id, asu_reunion, asu_parte, asu_numero, dec_clave,
				<cfif #reunion# EQ 'CTIC'>
					asu_oficio,
				</cfif>
				asu_notas
			)
			VALUES
			(
				#vRegistroId#,
				#ssn_id#,
				'#reunion#',
				#asu_parte#,
				#asu_numero#,
				#dec_clave#,
				<cfif #reunion# EQ 'CTIC'>
					'#oficio#',
				</cfif>
				'#vComentario#'
			)
		</cfquery>
	</cfif>
<cfelseif  #vTipoAsunto# EQ 'INF'>
	<cfif #vAsuntoId# GT 0>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE movimientos_informes_asunto SET
			ssn_id = #ssn_id#
			, asu_numero = #asu_numero#
			, dec_clave = #dec_clave#
			<cfif IsDefined('oficio')>, informe_oficio = '#oficio#'</cfif>
			<cfif IsDefined('vComentario')>, comentario_texto = '#vComentario#'</cfif>
			WHERE id = #vAsuntoId#
		</cfquery>
	<cfelse>
		<cfquery datasource="#vOrigenDatosSAMAA#">        
			INSERT INTO movimientos_informes_asunto
			(informe_anual_id, informe_reunion, ssn_id, asu_numero, dec_clave, comentario_texto, informe_oficio)
			VALUES
			(
				#vpRegistroId#,
				'#reunion#',
				#ssn_id#,
				#asu_numero#,
				#dec_clave#,
				<cfif IsDefined('oficio')>'#oficio#'<cfelse>NULL</cfif>,
				<cfif IsDefined('vComentario')>'#vComentario#'<cfelse>NULL</cfif>
			)
		</cfquery>
	</cfif>
</cfif>
