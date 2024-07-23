<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 24/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 06/06/2022 --->
<!--- FORMULARIO PARA AGREGAR ESTÍMULO A ACADÉMICO  --->

<cfif #vTipoComando# EQ 'NV' AND isValid("integer", #acd_id#) AND #acd_id# GT 0>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO estimulos_dgapa
		(acd_id, dep_clave, ubica_clave, cn_clave, con_clave, pride_clave, pride_clave_ant, ingreso, propuesto_pride_d, ratifica_caa_pride_d, recurso_revision, renovacion, reingreso, ssn_id, estimulo_nota)
		VALUES
		(
			#acd_id#
			,
			'#dep_clave#'
			,
			'#dep_ubicacion#'
			,
			'#cn_clave#'
			,
			#con_clave#
			,
			'#pride_clave#'
			,
			<cfif IsDefined('pride_clave_ant')>
				'#pride_clave_ant#'
			<cfelse>NULL</cfif>
			,
			<cfif IsDefined('ingreso')>
				<cfif #ingreso# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>
			,
			<cfif IsDefined('propuesto_pride_d')>
				<cfif #propuesto_pride_d# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>
			,
			<cfif IsDefined('ratifica_caa_pride_d')>
				<cfif #ratifica_caa_pride_d# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>
			,
			<cfif IsDefined('recurso_revision')>
				<cfif #recurso_revision# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>            
			,
			<cfif IsDefined('renovacion')>
				<cfif #renovacion# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>
			,
			<cfif IsDefined('reingreso')>
				<cfif #reingreso# EQ "Si">1<cfelse>NULL</cfif>
			<cfelse>NULL</cfif>                    
			,
			#ssn_id#
			,
			'#estimulo_nota#'
		)
	</cfquery>    
	
<cfelse>

</cfif>