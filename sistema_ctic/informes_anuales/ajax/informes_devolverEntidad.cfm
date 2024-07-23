<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 23/02/2023 --->
<!--- FECHA ÚLTIMA MOD.: 23/02/2023 --->
<!--- AJAX PARA DEVOLVER LOS INFORMES A LA ENTIDAD, SOLO PARA SUBMÓDULO "INFORMES RECIBIDOS" --->

<cfif (IsDefined('vpDepClave') AND #vpDepClave# NEQ '') AND (IsDefined('vpInformeAnio') AND #vpInformeAnio# NEQ '')>
    <!--- Se genera un catálogo para filtrar por año de informe (CATÁLOGOS LOCAL SAMAA) --->
    <cfquery name="ctInformeAnio" datasource="#vOrigenDatosSAMAA#">
        UPDATE  movimientos_informes_anuales
        SET informe_status = 0
        WHERE dep_clave = '#vpDepClave#'
        AND informe_anio = '#vpInformeAnio#'
    </cfquery>
</cfif>