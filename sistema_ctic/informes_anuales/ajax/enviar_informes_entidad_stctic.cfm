<!--- CREADO: ARAM PICHARDO DUR�N --->
<!--- EDITO: ARAM PICHARDO DUR�N --->
<!--- FECHA CREA: 24/01/2022 --->
<!--- FECHA �LTIMA MOD.: 24/01/2022 --->
<!--- ENVIAR INFORMES DE LA ENTIDAD ACAD�MICA A LA SECRETAR�A T�CNICA DEL CTIC --->

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
