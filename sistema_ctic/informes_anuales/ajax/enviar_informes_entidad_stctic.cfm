<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 24/01/2022 --->
<!--- FECHA ÚLTIMA MOD.: 24/01/2022 --->
<!--- ENVIAR INFORMES DE LA ENTIDAD ACADÉMICA A LA SECRETARÍA TÉCNICA DEL CTIC --->

<cfif IsDefined('Session.sIdDep') AND IsDefined('vpInformeAnio')>
    <cfif #Session.sIdDep# EQ #vpDepClave#>
        <cfquery datasource="#vOrigenDatosSAMAA#">
            UPDATE movimientos_informes_anuales
            SET informe_status = 1
            WHERE informe_status = 0
            AND dep_clave = '#Session.sIdDep#'
            AND informe_anio = '#vpInformeAnio#'
        </cfquery>
    </cfif>
</cfif>
