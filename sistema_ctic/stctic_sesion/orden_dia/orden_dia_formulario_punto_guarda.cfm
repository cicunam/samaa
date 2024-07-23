<!--- Ejecutar comandos: NUEVO, EDITA, ELIMINA, SUBE, BAJA --->
<cfif isDefined('vAccion')>
	<!--- Verifica en que carpeta se va a colocar el archivo UNO --->		
    <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
        <cfset vArchivoPdf = #vCarpetaSesionHistoria#>
    <cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
        <cfset vArchivoPdf = #vCarpetaAcademicos#>
    <cfelseif #RTrim(punto_clave)# EQ 'OTRO' OR #RTrim(punto_clave)# EQ 'ICRI'>
        <cfset vArchivoPdf = #vCarpetaSesionOtros#>
    </cfif>
    
    <!--- Verifica en que carpeta se va a colocar el archivo DOS--->		
    <cfif #MID(punto_clave,1,4)# EQ 'ACTA' OR #MID(punto_clave,1,9)# EQ 'RECOMCAAA'>
        <cfset vArchivoPdf2 = #vCarpetaSesionHistoria#>
    <cfelseif #RTrim(punto_clave)# EQ 'PNCA' OR #RTrim(punto_clave)# EQ 'PNIE'>
        <cfset vArchivoPdf2 = #vCarpetaAcademicos#>
    <cfelseif #RTrim(punto_clave)# EQ 'OTRO' OR #RTrim(punto_clave)# EQ 'ICRI'>
        <cfset vArchivoPdf2 = #vCarpetaSesionOtros#>
    </cfif>


	<!--- ACTUALIZAR ORDEN DEL DÍA --->
	<cfif #vAccion# EQ "N">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO sesiones_orden (ssn_id, punto_num, punto_clave, punto_texto, acd_id)
			VALUES (
			<cfif IsDefined("vIdSsn") AND #vIdSsn# NEQ "">
				#vIdSsn#
			<cfelse>
				NULL
			</cfif>
			,
			<cfif IsDefined("punto_num") AND #punto_num# NEQ "">
				#punto_num#
			<cfelse>
				NULL
			</cfif>
			,
			<cfif IsDefined("punto_clave") AND #punto_clave# NEQ "">
				'#punto_clave#'
			<cfelse>
				NULL
			</cfif>
			,
			<cfif IsDefined("punto_texto") AND #punto_texto# NEQ "">
				'#punto_texto#'
			<cfelse>
				NULL
			</cfif>
			,
			<cfif IsDefined("vSelAcad") AND #vSelAcad# NEQ "">
				#vSelAcad#
			<cfelse>
				NULL
			</cfif>
			)	
		</cfquery>
	<cfelseif #vAccion# EQ "E">
		<cfquery datasource="#vOrigenDatosSAMAA#">
			UPDATE sesiones_orden SET
            punto_clave = 
			<cfif IsDefined("punto_clave") AND #punto_clave# NEQ "">
				'#punto_clave#'
			<cfelse>
				NULL
			</cfif>
            ,
			punto_texto=
			<cfif IsDefined("punto_texto") AND #punto_texto# NEQ "">
				'#punto_texto#'
			<cfelse>
				NULL
			</cfif>
			WHERE ssn_id = #vIdSsn# 
            AND punto_num = #vPunto#
		</cfquery>
	<cfelseif #vAccion# EQ "D">
		<!--- Eliminar archivo relacionado, si existe --->
		<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM sesiones_orden 
			WHERE ssn_id = #vIdSsn# 
            AND punto_num = #vPunto#
		</cfquery>

		<!--- Elimina el archivo relacionado UNO si existe ---->
		<cfif #tbSesionOrden.punto_pdf# NEQ ''>
	        <cfset vArchivoElimina = #vArchivoPdf# & #tbSesionOrden.punto_pdf#>
			<cfif FileExists(#vArchivoElimina#)>
				<cffile action="delete" file="#vArchivoElimina#">	
			</cfif>	
		</cfif>

		<!--- Elimina el archivo relacionado DOS si existe ---->
		<cfif #tbSesionOrden.punto_pdf_2# NEQ ''>
	        <cfset vArchivoElimina = #vArchivoPdf2# & #tbSesionOrden.punto_pdf_2#>
			<cfif FileExists(#vArchivoElimina#)>
				<cffile action="delete" file="#vArchivoElimina#">	
			</cfif>	
		</cfif>

		<!--- Eliminar el punto --->
		<cfquery datasource="#vOrigenDatosSAMAA#">
			DELETE FROM sesiones_orden
			WHERE ssn_id = #vIdSsn# 
            AND punto_num = #vPunto#
		</cfquery>
		<!--- Reindexar --->
		<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM sesiones_orden 
			WHERE ssn_id = #vIdSsn# 
            ORDER BY punto_num
		</cfquery>
		<cfset C = 1>
		<cfoutput query="tbSesionOrden">
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = #C#
				WHERE ssn_id = #vIdSsn# AND punto_num = #tbSesionOrden.punto_num#
			</cfquery>	
			<cfset C = C + 1>
		</cfoutput>
	</cfif>
	<cfif #vAccion# EQ "S">
		<!--- Hacer un SWAP entre el punto específicado y el anterior --->
		<cfif #vPunto# GT 1>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = 99
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto#
			</cfquery>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = #vPunto#
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto# - 1
			</cfquery>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = #vPunto# - 1
				WHERE ssn_id = #vIdSsn# AND punto_num = 99
			</cfquery>
		</cfif>	
	</cfif>
	<cfif #vAccion# EQ "B">
		<!--- Hacer un SWAP entre el punto específicado y el siguiente --->
		<cfquery name="tbSesionOrden" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM sesiones_orden 
			WHERE ssn_id = #vIdSsn# ORDER BY punto_num
		</cfquery>
		<cfif #vPunto# LT #tbSesionOrden.RecordCount#>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = 99
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto#
			</cfquery>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = #vPunto#
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto# + 1
			</cfquery>
			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden 
				SET punto_num = #vPunto# + 1
				WHERE ssn_id = #vIdSsn# AND punto_num = 99
			</cfquery>
		</cfif>
	</cfif>

	<!--- Administración de archivos asociados --->
	<cfif (#vAccion# EQ "N" OR #vAccion# EQ "E")>
		<!--- Carga el PRIMER archivo en el servidor --->
		<cfif IsDefined("punto_pdf") AND #punto_pdf# IS NOT ''>

			<!--- Carga el archivo UNO en el servidor --->
			<cffile action="upload" filefield="punto_pdf" destination="#vArchivoPdf#" nameConflict="overwrite">

			<!--- Generar el nombre del archivo correspondiente --->
			<cfif #punto_clave# IS 'ACTA'>
				<cfset vNombreArchivo = 'ACTA_' & #vIdSsn#-1 & '.pdf'> 
			<cfelseif  #punto_clave# IS 'ACTAS'>
				<cfset vNombreArchivo = 'ACTA_' & #vIdSsn#-2 & '.pdf'> 
			<cfelseif  #punto_clave# IS 'RECOMCAAA'>
				<cfset vNombreArchivo = 'RECOMCAAA_' & #vIdSsn# & '.pdf'>
			<cfelseif  #punto_clave# IS 'RECOMCAAAS'>
				<cfset vNombreArchivo = 'RECOMCAAA_' & #vIdSsn#-1 & '.pdf'>
			<cfelseif  #Rtrim(punto_clave)# IS 'PNCA' OR #Rtrim(punto_clave)# IS 'PNIE'>
				<cfset vNombreArchivo = #vSelAcad# & "_" & #punto_clave# & "_" & #vIdSsn# & '.pdf'>
			<cfelse>
				<cfset vNombreArchivo = #cffile.attemptedServerFile#>
			</cfif>
            
			<!--- Renombrar el archivo --->
			<cffile action="rename" source="#vArchivoPdf##cffile.attemptedServerFile#" destination="#vNombreArchivo#">	
			<!--- Guardar el nombre del archivo relacionado en la tabla de orden del día --->

			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden
				SET punto_pdf = '#vNombreArchivo#'
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto#
			</cfquery>
		</cfif>

        <!--- OPCIÓN PARA AGREGAR UN SEGUNDO ARCHIVO SEGÚN LA OPCIÓN SELECCIONADA --->
		<cfif IsDefined("punto_pdf_2") AND #punto_pdf_2# IS NOT ''>
			<!--- Carga el SEGUNDO archivo en el servidor --->
			<cffile action="upload" filefield="punto_pdf_2" destination="#vArchivoPdf2#" nameConflict="overwrite">

			<!--- Generar el nombre del archivo correspondiente --->
			<cfif #punto_clave# IS 'ACTAS'>
				<cfset vNombreArchivo2 = 'ACTA_' & #vIdSsn#-1 & '.pdf'> 
			<cfelseif #punto_clave# IS 'ACTAE'>
				<cfquery name="tbSesionExtra" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM sesiones WHERE ssn_clave = 2 ORDER BY ssn_id DESC
				</cfquery>
                <cfset vSesionExtra = #tbSesionExtra.ssn_id#>
				<cfset vNombreArchivo2 = 'ACTA_EXTRAORDINARIA_' & #tbSesionExtra.ssn_id# & '.pdf'>
			<cfelseif #punto_clave# IS 'RECOMCAAAS'>
				<cfset vNombreArchivo2 = 'RECOMCAAA_' & #vIdSsn# & '.pdf'>
			<cfelse>	
				<cfset vNombreArchivo2 = #cffile.attemptedServerFile#>
			</cfif>
			<!--- Renombrar el archivo --->
			<cffile action="rename" source="#vArchivoPdf2##cffile.attemptedServerFile#" destination="#vNombreArchivo2#">
			<!--- Guardar el nombre del archivo relacionado en la tabla de orden del día --->

			<cfquery datasource="#vOrigenDatosSAMAA#">
				UPDATE sesiones_orden
				SET punto_pdf_2 = '#vNombreArchivo2#'
				WHERE ssn_id = #vIdSsn# AND punto_num = #vPunto#
			</cfquery>
		</cfif>
	</cfif>
	<cflocation url="orden_dia.cfm?vIdSsn=#vIdSsn#" addtoken="no">
</cfif>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<title>Documento sin t&iacute;tulo</title>
<!---        
		<script language="JavaScript" type="text/JavaScript">
			function fActualizaPagina(vAccion)
			{
				if (vAccion == 'NUEVO' || vAccion == 'EDITA')
				{
					//parent.window.location.reload();
					window.location.href = 'orden_dia.cfm?vIdSsn=' + <cfoutput>#vIdSsn#</cfoutput>
				}
			}
		</script>
--->
	</head>
	<body onLoad="fActualizaPagina('<cfoutput>#vAccion#</cfoutput>');">
    </body>
</html>
