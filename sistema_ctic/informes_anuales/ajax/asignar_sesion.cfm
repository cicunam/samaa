<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/03/2017 --->
<!--- FECHA ÚLTIMA MOD.: 22/04/2022 --->
<!--- ASIGNA LA SESIÓN DONDE SE VERÁ EN EL PLENO LOS INFORMES ANUALES --->

<cfparam name="vpActa" default="">
<cfparam name="vpInformeAnio" default="">
<cfparam name="vpInformeAnualId" default="">
<cfparam name="vpDepClave" default="">

<cfoutput>
#vpActa#<br />
#vpInformeAnio#<br />
#vpInformeAnualId#<br />
#vpDepClave#<br/>
</cfoutput>

<cfif (IsDefined('vpActa') AND #vpActa# GT 0) AND (IsDefined('vpInformeAnio') AND #vpInformeAnio# GT 0) AND #Session.sTipoSistema# EQ 'stctic'>
	<!--- QUERY PARA DESPLEGAR INFORMACIÓN --->
    <cfquery name="tbInformesAnualesSesion" datasource="#vOrigenDatosSAMAA#">
        SELECT T1.informe_anual_id, T1.dec_clave_ci, T1.comentario_clave_ci, T1.comentario_texto_ci, 
		(SELECT ssn_id FROM movimientos_informes_asunto WHERE informe_anual_id = T1.informe_anual_id AND informe_reunion = 'CAAA') AS ssn_id_caaa
		,
		(SELECT ssn_id FROM movimientos_informes_asunto WHERE informe_anual_id = T1.informe_anual_id AND informe_reunion = 'CTIC') AS ssn_id
        FROM movimientos_informes_anuales AS T1
        WHERE T1.informe_anio = #vpInformeAnio#
		AND T1.informe_status = 1
        <cfif LEN(#vpDepClave#) EQ 6>
			AND T1.dep_clave = '#vpDepClave#'
		</cfif>
        <cfif #vpDecClave# NEQ 0>
            AND dec_clave_ci = #vpDecClave#
        </cfif>
		<cfif #vpInformeAnualId# GT 0>
			AND T1.informe_anual_id = #vpInformeAnualId#
		</cfif>
	</cfquery>

	<cfoutput>#tbInformesAnualesSesion.RecordCount#</cfoutput><br />
	
	<cfoutput query="tbInformesAnualesSesion">
		<cfset vInformeId = #informe_anual_id#>
		<cfset vDecClaveCi = #dec_clave_ci#>            
        SIN SESION
        <cfif (#vDecClaveCi# EQ 4 OR #vDecClaveCi# EQ 49) AND #ssn_id_caaa# EQ ''> 
            <!--- SE ASIGNA LOS INFORMES NO APROBADO Y APROBADOS CON COMENTARIO A UNA REUNIÓN DE LA CAAA --->
            <cfquery datasource="#vOrigenDatosSAMAA#">
                INSERT INTO movimientos_informes_asunto
                (informe_anual_id, informe_reunion, ssn_id, asu_parte, dec_clave, comentario_clave, comentario_texto)
                VALUES
                (
                    #informe_anual_id#
                    ,
                    'CAAA'
                    ,
                    #vpActa#
                    ,
                    '3.3'
                    ,
                    #vDecClaveCi#
                    ,
                    <cfif #comentario_clave_ci# NEQ ''>
                        '#comentario_clave_ci#'
                    <cfelse>
                        NULL
                    </cfif>
                    ,
                    <cfif #comentario_texto_ci# NEQ ''>
                        '#comentario_texto_ci#'
                    <cfelse>
                        NULL
                    </cfif>
                )
                ;
                UPDATE movimientos_informes_anuales SET
                informe_status = 2
                WHERE informe_anual_id = #vInformeId#
            </cfquery>
        <cfelse>
            <!--- SE ASIGNA EL INFORME A UNA REUNIÓN DEL CTIC --->				
            <cfquery datasource="#vOrigenDatosSAMAA#">
                INSERT INTO movimientos_informes_asunto
                (informe_anual_id, informe_reunion, ssn_id, asu_parte, dec_clave, comentario_clave, comentario_texto)
                VALUES
                (
                    #informe_anual_id#
                    ,
                    'CTIC'
                    ,
                    #vpActa#
                    ,
                    '3.3'
                    ,
                    #vDecClaveCi#
                    ,
                    <cfif #comentario_clave_ci# NEQ ''>
                        '#comentario_clave_ci#'
                    <cfelse>
                        NULL
                    </cfif>
                    ,
                    <cfif #comentario_texto_ci# NEQ ''>
                        '#comentario_texto_ci#'
                    <cfelse>
                        NULL
                    </cfif>
                )
                ;
                UPDATE movimientos_informes_anuales SET
                informe_status = 3
                WHERE informe_anual_id = #vInformeId#
            </cfquery>
        </cfif>
	</cfoutput>	
</cfif>