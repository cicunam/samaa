			<!--- CREADO: ARAM PICHARDO--->
            <!--- EDITO: ARAM PICHARDO--->
            <!--- FECHA CREA: 29/06/2017 --->
            <!--- FECHA ULTIMA MOD.: 29/06/2017 --->
            
            <!--- CONTROLES PARA PODER REALIZAR FILTROS POR TIPO DE MOVIMIENTO CATÁLOGO COMPLETO --->
            <!--- NOTA: remplaza al archivo movimientos_catalogoa_select.cfm --->

            <cfset vSesionAlta = "#attributes.SsnId#">
            <cfset vSsnClave = "#attributes.SsnClave#">
            <cfset vSsnDescrip = "#attributes.SsnDescrip#">
            <cfset vOrigenDatosSAMAA = "#attributes.OrigenDatos#">            

			<cfquery name="tbSysClaves" datasource="#vOrigenDatosSAMAA#">
                SELECT top 1
                newid() AS clave_alfanum,
                RAND() AS 'Random',
                abs(CHECKSUM(newid())) AS clave_acceso
                FROM sys.tables
			</cfquery>

			<cfset vClaveAleatorio = #tbSysClaves.clave_acceso#>
			<cfset vClaveAlfaNum = #tbSysClaves.clave_alfanum#>
        
			<cfquery datasource="#vOrigenDatosSAMAA#">
				INSERT INTO samaa_accesos_comisiones
                (ssn_id, clave_acceso, clave_alfanum, ssn_clave, asu_reunion) 
               	VALUES 
				(#vSesionAlta#, #vClaveAleatorio#, '#vClaveAlfaNum#',#vSsnClave# , '#vSsnDescrip#')
			</cfquery>