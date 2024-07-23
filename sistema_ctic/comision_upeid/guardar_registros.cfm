<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 07/11/2017 --->
<!--- FECHA ÚLTIMA MOD.: 15/03/2018 --->
<!--- GUARDA LOS REGISTROS NUEVOS O EDITADOS DE TOTO EL MÓDULO --->

<!--- ********** SESIONES GUARDA/ELIMINA ********** --->
<cfif #Session.CeUpeidFiltro.MenuUpeid# EQ 'Sesiones'>
	<cfif #vTipoComando# EQ 'NV'>
    	<cfset vSsnIdCeUpeid = #LsDateFormat(ssn_fecha, 'yyyymmdd')#>

        <cfquery name="tbSesionEncuentra" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM sesiones
            WHERE ssn_clave = 20
			AND ssn_fecha = '#ssn_fecha#'
        </cfquery>
		<cfif #tbSesionEncuentra.RecordCount# EQ 0>
            <cfquery datasource="#vOrigenDatosSAMAA#">
                INSERT INTO sesiones
                (ssn_id, ssn_clave, ssn_fecha, ssn_nota)
                VALUES
                (
                    #vSsnIdCeUpeid#
                    ,
                    #ssn_clave#
                    ,
                    '#ssn_fecha#'
                    ,
                    <cfif #ssn_nota# NEQ ''>
                        '#ssn_nota#'
                    <cfelse>NULL</cfif>
                )
            </cfquery>

			<!--- MÓDULO COMÚN PARA LA GENERACIÓN DE LA LLAVES DINÁMICAS DE LAS LIGAS PARA LAS DIFERENTES COMISIONES --->
			<cfmodule template="#vCarpetaCOMUN#/modulo_genera_claves_acceso.cfm" SsnId="#vSsnIdCeUpeid#" SsnClave="20" SsnDescrip="CEUPEID" OrigenDatos="#vOrigenDatosSAMAA#">
			<cfset Session.CeUpeidFiltro.SsnIdCeUpeid = #vSsnIdCeUpeid#>
		<cfelse>
	        LA SESI&Oacute;N YA EXISTE
		</cfif>
	<cfelseif #vTipoComando# EQ 'ED'>
		<cfquery datasource="#vOrigenDatosSAMAA#">
        	UPDATE sesiones SET
			ssn_fecha = '#ssn_fecha#'
            ,
            ssn_nota =
			<cfif #ssn_nota# NEQ ''>
                '#ssn_nota#'
            <cfelse>NULL</cfif>
            WHERE ssn_clave = #ssn_clave#
			AND ssn_id = #ssn_id#
		</cfquery>
	</cfif>
</cfif>
<!---
<cfoutput>#Session.CeUpeidFiltro.MenuUpeid#</cfoutput>
--->

<!--- ********** MIEMBREOS GUARDA/ELIMINA ********** --->
<cfif #Session.CeUpeidFiltro.MenuUpeid# EQ 'Miembros'>
	<cfif #vTipoComando# EQ 'NV'>
		<cfquery datasource="#vOrigenDatosSAMAA#">
			INSERT INTO academicos_comisiones
				SELECT 
					(SELECT TOP 1 (comision_acd_id + 1) FROM academicos_comisiones ORDER BY comision_acd_id DESC)
                    , #comision_clave#
                    , acd_id
					, NULL
                    , dep_clave
                    , cn_clave
                    , #Session.CeUpeidFiltro.SsnIdCeUpeid#
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
					, NULL
				FROM academicos
				WHERE acd_id = #vAcadId#
		</cfquery>
	<cfelseif #vTipoComando# EQ 'ED'>
	<cfelseif #vTipoComando# EQ 'EL'>
        <cfquery datasource="#vOrigenDatosSAMAA#">
			DELETE FROM academicos_comisiones
			WHERE comision_acd_id = #vComisionAcdId#
		</cfquery>    
	</cfif>
</cfif>

<!--- ********** ASUNTOS GUARDA/ELIMINA ********** --->
<cfif #Session.CeUpeidFiltro.MenuUpeid# EQ 'Asuntos'>
	<cfif #vTipoComando# EQ 'NV'>
        <cfquery datasource="#vOrigenDatosSAMAA#">
            INSERT INTO evaluaciones_comision_upeid
            (acd_id, acd_otro, dep_clave, mov_clave, cn_clave, ssn_id, evalua_status)
            VALUES
            (
                #vAcadId#
                ,
                NULL
                ,
                (SELECT dep_clave FROM academicos WHERE acd_id = #vAcadId#)
                ,
                #mov_clave#
                ,
                (SELECT cn_clave FROM academicos WHERE acd_id = #vAcadId#)
                ,
                #ssn_id#
                ,
                3
            )
        </cfquery>
		<!--- INCLUDE GENERAL PARA EL ENVÍO DE ARCHIVOS --->
        <cfset vModuloConsulta = 'CEUPEID'>
        <cfinclude template="#vCarpetaINCLUDE#/archivopdf_carga.cfm">
	<cfelseif #vTipoComando# EQ 'EL'>
        <cfquery datasource="#vOrigenDatosSAMAA#">
        	DELETE FROM evaluaciones_comision_upeid
            WHERE asunto_id = #vAsuntoId#
		</cfquery>
        <cffile action="delete" file="#vCarpetaCEUPEID#/#vAcadId#_#vSsnId#.pdf">
	</cfif>
</cfif>