<!--- CREADO: ARAM PICHARDO --->
<!--- CREADO: ARAM PICHARDO --->
<!--- FECHA CREA: 18/05/2017 --->
<!--- FECHA ÚLTIMA MOD.: 18/05/2017 --->
<!--- GUARDA LAS ALTAS O MODIFICACIONES A LOS ASUNTOS DE LAS SOLITITUDES,INFORMES O MOVIMIENTOS--->

<cfquery name="tbAsuntos" datasource="#vOrigenDatosSAMAA#">
	<cfif #vTipoAsunto# EQ 'MOV' OR #vTipoAsunto# EQ 'SOL'>
		<cfif #vAsuntoId# GT 0>
            UPDATE movimientos_asunto SET
            asu_parte = 
            ,
            asu_numero = 
            ,
            dec_clave = 
    		<cfif IsDefined('oficio')>, asu_oficio = ''</cfif>
			<cfif IsDefined('oficio')>, asu_comentario = ''</cfif>
            <cfif IsDefined('oficio')>, asu_notas = ''</cfif>
            <cfif IsDefined('oficio')>, comision_nota = ''</cfif>
			WHERE id = #vAsuntoId#
		<cfelseif #vAsuntoId# EQ 0>
		</cfif>
	<cfelseif  #vTipoAsunto# EQ 'INF'>
		<cfif #vAsuntoId# GT 0>
            UPDATE movimientos_informes_asunto SET
            ssn_id = #ssn_id#
            , asu_numero = #asu_numero#
            , dec_clave = #dec_clave#
            <cfif IsDefined('vComentario')>, comentario_texto = '#vComentario#'</cfif>
            <cfif IsDefined('oficio')>, informe_oficio = '#oficio#'</cfif>
            WHERE id = #vAsuntoId#
		<cfelse>
			INSERT INTO movimientos_informes_asunto
			(informe_anual_id, informe_reunion, ssn_id, asu_numero, dec_clave, comentario_texto, informe_oficio)
            VALUES
            (
				#vpRegistroId#
                ,'#reunion#'
				,#ssn_id#
				,#asu_numero#
				, #dec_clave#
				,<cfif IsDefined('vComentario')>'#vComentario#'<cfelse>NULL</cfif>
				,<cfif IsDefined('oficio')>'#oficio#'<cfelse>NULL</cfif>
            )
		</cfif>
	</cfif>
</cfquery>