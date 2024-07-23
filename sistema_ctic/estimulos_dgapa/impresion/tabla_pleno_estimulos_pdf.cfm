<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 28/05/2019 --->
<!--- FECHA ÚLTIMA MOD.: 20/08/2019 --->
<!--- TABLA CON LA RELACIÓN DE ESTÍMULOS PARA LA SESIÓN VIGENTE --->

<cfset vFormatoExporta = 'PDF'>

<!--- INCLUDE PARA LLAMADO DE TABLA PRINCIPAL --->    
<cfinclude template="include_llamado_db.cfm">    
    
<cfset vCuentaRegEstAcd = 1>

<!--- ESTA OPCIÓN PERMITE CAMBIAR EL MARGEN INFERIOR SI SE REQUIERE FIRMA O NO --->
<cfif #vFirmaCoord# EQ 'true'>
	<cfset vMargenInferior = 3>
<cfelse>
	<cfset vMargenInferior = 1.5>
</cfif>


<cfcontent type="application/pdf">

<cfheader name="Content-Disposition" value="attachment;filename=ESTIMULOS_DGAPA_#vpSsnId#.pdf">

<cfdocument format="PDF" fontembed="yes" orientation="landscape" pagetype="letter" margintop="1.5" marginleft="1" marginright="1" marginbottom="#vMargenInferior#" unit="cm"  saveasname="ESTIMULOS_DGAPA_#vpSsnId#.pdf" overwrite="yes"><!--- --->
	<html>
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
					border-top-width: 1px;
					border-bottom: solid;
					border-bottom-width: 1px;
					border-right: solid;
					border-right-width: 1px;
					/*padding: 1px;*/
					padding-top: 2px;
				}
				.tbLineaEncabezaDer{
					border-top: solid;
					border-top-width: 1px;
					border-bottom: solid;
					border-bottom-width: 1px;
					border-left: solid;
					border-left-width: 1px;
					border-right: solid;
					border-right-width: 1px;
					padding: 1px;
				}				
				.tbLineaInicio{
					border-bottom: solid;
					border-bottom-width: 1px;
					height: 2px;
					
				}
				.tbLineaDerecha{
					border-bottom: solid;
					border-bottom-width: 1px;
					border-left: solid;
					border-left-width: 1px;
					padding:1px;					
				}
				.tbLineaAmbos{
					border-bottom: solid;
					border-bottom-width: 1px;
					border-right: solid;
					border-right-width: 1px;
					border-left: solid;
					border-left-width: 1px;
					padding: 1px;
				}
			</style>			
		</head>
		<body>
			<!--- Encabezado --->
			<cfdocumentitem type="header">
			</cfdocumentitem>
			<cfif #vpSsnId# GTE 1576>
                <cfquery name="tbRegistros" dbtype="query">
                    SELECT * FROM tbEstimulosDgapa
                    WHERE orden_samaa = 1
                    AND recurso_revision IS NULL
                </cfquery>
    
                <cfif #tbRegistros.RecordCount# GT 0>
                    <div align="center">
                        <span class="TablaEncabeza">PRIDE</span>
                        <br/>
                        <span class="TablaEncabeza">Renovaciones - Ingresos</span>
                        <br/><br/>
                    </div>
                    <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                    <cfinclude template="include_contenido_tabla_pdf.cfm">
                </cfif>            
        	<cfelse>
                <cfquery name="tbRegistros" dbtype="query">
                    SELECT * FROM tbEstimulosDgapa
                    WHERE ingreso = 1
                    AND orden_samaa = 1
                </cfquery>
    
                <cfif #tbRegistros.RecordCount# GT 0>
                    <div align="center">
                        <span class="TablaEncabeza">PRIDE</span>
                        <br/>
                        <span class="TablaEncabeza">Ingresos</span>
                        <br/><br/>
                    </div>
                    <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                    <cfinclude template="include_contenido_tabla_pdf.cfm">
                </cfif>
    
                <cfquery name="tbRegistros" dbtype="query">
                    SELECT * FROM tbEstimulosDgapa
                    WHERE ingreso IS NULL
                    AND orden_samaa = 1
                </cfquery>
    
                <cfif #tbRegistros.RecordCount# GT 0>
                    <div align="center">
                        <span class="TablaEncabeza">PRIDE</span>
                        <br/>
                        <span class="TablaEncabeza">Renovación</span>
                        <br/><br/>
                    </div>
                    <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                    <cfinclude template="include_contenido_tabla_pdf.cfm">
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
                    <span class="TablaEncabeza">Recursos de Revisión</span>
                </div>              
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_rr_pdf.cfm">
            </cfif>                    
                    
                    
			<cfquery name="tbRegistros" dbtype="query">
				SELECT * FROM tbEstimulosDgapa
			    WHERE ingreso IS NULL
				AND orden_samaa = 2
			</cfquery>

			<cfif #tbRegistros.RecordCount# GT 0>
				<div align="center">
					<span class="TablaEncabeza">Programa de Estímulos Académicos por Equivalencia</span>
					<br/><br/>                    
				</div>              
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_pdf.cfm">
			
			</cfif>
	
			<cfquery name="tbRegistros" dbtype="query">
				SELECT * FROM tbEstimulosDgapa
				WHERE ingreso IS NULL
				AND orden_samaa = 3
			</cfquery>

			<cfif #tbRegistros.RecordCount# GT 0>
				<div align="center">
					<span class="TablaEncabeza">Programa de Estímulos de Iniciación de la Carrera Académica para Personal de Tiempo Completo (PEI)</span>
					<br/><br/>                    
				</div>
                <!--- INCLUDO CON EL CONTENIDO DE LA TABLA A IMPRIMIR --->
                <cfinclude template="include_contenido_tabla_pdf.cfm">
				
			</cfif>
        </body>
    </html>
</cfdocument>        