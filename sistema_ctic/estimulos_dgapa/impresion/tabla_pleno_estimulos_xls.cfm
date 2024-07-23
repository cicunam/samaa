<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 28/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 08/02/2023 --->
<!--- TABLA CON LA RELACIÓN DE ESTÍMULOS PARA LA SESIÓN VIGENTE --->


<cfheader name="Content-Disposition" value="inline; filename=ESTIMULOS_DGAPA_#vpSsnId#.xls">
<cfcontent type="application/msexcel; charset=iso-8859-1">

<cfset vFormatoExporta = 'XLS'>

<!--- INCLUDE PARA LLAMADO DE TABLA PRINCIPAL --->
<cfinclude template="include_llamado_db.cfm">
    
<cfset vCuentaRegEstAcd = 1>

<!--- ESTA OPCIÓN PERMITE CAMBIAR EL MARGEN INFERIOR SI SE REQUIERE FIRMA O NO --->
<cfif #vFirmaCoord# EQ 'true'>
	<cfset vMargenInferior = 3>
<cfelse>
	<cfset vMargenInferior = 1.5>
</cfif>

<html xmlns:v="urn:schemas-microsoft-com:vml"
xmlns:o="urn:schemas-microsoft-com:office:office"
xmlns:w="urn:schemas-microsoft-com:office:excel"
xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
xmlns="http://www.w3.org/TR/REC-html40">
    <head>
        <title>SAMAA</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <cfoutput>
            <link href="#vCarpetaCSS#/listados_lyc.css" rel="stylesheet" type="text/css">
            <link href="#vCarpetaCSS#/fuentes_listado_impresion.css" rel="stylesheet" type="text/css">
        </cfoutput>
        <style>
            .tbBorde{
                border-style:double;
                border-width: 1px;
                padding:1px;
            }
            .tbLineaEncabeza{
                border-top: solid;
                border-top-width: thin;
                border-bottom: solid;
                border-bottom-width: thin;
                border-right: solid;
                border-right-width: thin;
                /*padding: 1px;
                padding-top: 2px;*/
            }
            .tbLineaEncabezaDer{
                border-top: solid;
                border-top-width: thin;
                border-bottom: solid;
                border-bottom-width: thin;
                border-left: solid;
                border-left-width: thin;
                border-right: solid;
                border-right-width: thin;
               /* padding: 1px;*/
            }				
            .tbLineaInicio{
                border-bottom: solid;
                border-bottom-width: thin;
                height: 2px;
                
            }
            .tbLineaDerecha{
                border-bottom: solid;
                border-bottom-width: thin;
                border-left: solid;
                border-left-width: thin;
                /*padding:1px;*/
            }
            .tbLineaAmbos{
                border-bottom: solid;
                border-bottom-width: thin;
                border-right: solid;
                border-right-width: thin;
                border-left: solid;
                border-left-width: thin;
                /*padding: 1px;*/
            }
			tr.tr1 {
				width:600px;
			}
        </style>			
    </head>
    <body>
        <cfif #vpSsnId# GTE 1576>
            <cfquery name="tbRegistros" dbtype="query">
                SELECT * FROM tbEstimulosDgapa
                WHERE orden_samaa = 1
                AND recurso_revision IS NULL
            </cfquery>

            <cfif #tbRegistros.RecordCount# GT 0>
                <div align="center" style="column-width:5000px">
                    <span class="XlsTablaEncabeza">PRIDE</span>
                    <br/>
                    <span class="XlsTablaEncabeza">Renovaciones - Ingresos</span>
                </div>
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_xls.cfm">
            </cfif>
        <cfelse>
            <cfquery name="tbRegistros" dbtype="query">
                SELECT * FROM tbEstimulosDgapa
                WHERE ingreso = 1
                AND orden_samaa = 1
            </cfquery>

            <cfif #tbRegistros.RecordCount# GT 0>
                <div align="center">
                    <span class="XlsTablaEncabeza" style="width:8000px;">PRIDE</span>
                    <br/>
                    <span class="XlsTablaEncabeza">Ingresos</span>
                </div>
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_xls.cfm">
            </cfif>

            <cfquery name="tbRegistros" dbtype="query">
                SELECT * FROM tbEstimulosDgapa
                WHERE ingreso IS NULL
                AND orden_samaa = 1
            </cfquery>

            <cfif #tbRegistros.RecordCount# GT 0>
                <div align="center">
                    <span class="XlsTablaEncabeza">PRIDE</span>
                    <br/>
                    <span class="XlsTablaEncabeza">Renovación</span>
                </div>
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_xls.cfm">
            </cfif>
        </cfif>
                
        <!--- ********** RECURSOS DE REVISIÓN ********** 08/02/2023---->
        <cfquery name="tbRegistros" dbtype="query">
            SELECT * FROM tbEstimulosDgapa
            WHERE recurso_revision = 1
            AND orden_samaa = 1
        </cfquery>

        <cfif #tbRegistros.RecordCount# GT 0>
            <div align="center">
                <span class="XlsTablaEncabeza">Recursos de Revisión</span>
            </div>              
            <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
            <cfinclude template="include_contenido_tabla_rr_xls.cfm">
        </cfif>
            
        <!--- ********** EQUIVALANCIA ********** ---->
        <cfquery name="tbRegistros" dbtype="query">
            SELECT * FROM tbEstimulosDgapa
            WHERE ingreso IS NULL
            AND orden_samaa = 2
        </cfquery>

        <cfif #tbRegistros.RecordCount# GT 0>
            <div align="center">
                <span class="XlsTablaEncabeza">Programa de Estímulos Académicos por Equivalencia</span>
            </div>              
            <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
            <cfinclude template="include_contenido_tabla_xls.cfm">
        
        </cfif>

        <cfquery name="tbRegistros" dbtype="query">
            SELECT * FROM tbEstimulosDgapa
            WHERE ingreso IS NULL
            AND orden_samaa = 3
        </cfquery>

        <cfif #tbRegistros.RecordCount# GT 0>
            <div align="center">
                <span class="XlsTablaEncabeza">Programa de Estímulos de Iniciación de la Carrera Académica para Personal de Tiempo Completo (PEI)</span>
            </div>
            <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
            <cfinclude template="include_contenido_tabla_xls.cfm">
            
        </cfif>
    </body>
</html>
