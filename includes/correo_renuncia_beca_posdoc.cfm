<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 28/01/2020 --->
<!--- FECHA ÚLTIMA MOD.: 28/01/2020 --->
<!--- CÓDIGO PARA EL ENVÍO DE CORREO ELECTRÓNICO DE NOTIFICACIÓN DE RANUANCIA DE BECA POSDOC --->
<!--- CÓDIGO TEMPORAL PARA ENVÍO DE CORREO DESDE SAMAA V1  --->

		<!--- CREA ARREGLO CON INFORMACIÓN DEL PERSONAL A NOTIFICAR --->

		<cfset vOrigenDatosSAMAA = 'samaa'>
		<cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
        <cfset vCarpetaCAAA = '#vCarpetaRaizArchivos#\archivos_pleno\asuntos'>
        <cfset vCarpetaEntidad = '#vCarpetaRaizArchivos#\archivos_entidades'>

		<cfset vCorreosEnvio = ArrayNew(2)>
		<cfif #CGI.SERVER_PORT# EQ '31221'>
            <cfset vCorreosEnvio[1][1] = "aramp@unam.mx">
            <cfset vCorreosEnvio[1][2] = "SAMAA PRUEBA">
            <cfset vCorreosEnvio[1][3] = "999999">
            <cfset vHttp = 'http://www.cic-ctic.unam.mx:31221/samaa/aram'>
		<cfelseif #CGI.SERVER_PORT# EQ '31220'>
            <cfset vCorreosEnvio[1][1] = "elino@cic.unam.mx">
            <cfset vCorreosEnvio[1][2] = "C.P. Ernesto Lino">
            <cfset vCorreosEnvio[1][3] = "130641">
            <cfset vCorreosEnvio[2][1] = "vicsktel@cic.unam.mx">
            <cfset vCorreosEnvio[2][2] = "Victor Escatel">
            <cfset vCorreosEnvio[2][3] = "823148">
			<cfset vCorreosEnvio[3][1] = "alexmoran1@live.com.mx">
            <cfset vCorreosEnvio[3][2] = "Alejandro Moran">
            <cfset vCorreosEnvio[3][3] = "835713">
            <cfset vCorreosEnvio[4][1] = "paty@cic.unam.mx">
            <cfset vCorreosEnvio[4][2] = "Patricia Cortes">
            <cfset vCorreosEnvio[4][3] = "809250">
				
            <cfset vHttp = 'http://www.cic-ctic.unam.mx:31220/samaa'>
<!---
			<cfset vCorreosEnvio[3][1] = "bsapina@hotmail.com">
            <cfset vCorreosEnvio[3][2] = "Lic. Beatriz Sapiña">
            <cfset vCorreosEnvio[3][3] = "123749">
--->
		</cfif>

		<!--- Obtener los datos de la solicitud --->
        <cfquery name="tbSolicitudes" datasource="samaa">
            SELECT 
            (
            ISNULL(dbo.SINACENTOS(acd_apepat),'') + 
            CASE WHEN acd_apepat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_apemat),'') + 
            CASE WHEN acd_apemat IS NULL THEN '' ELSE ' ' END + 
            ISNULL(dbo.SINACENTOS(acd_nombres),'')
            ) AS nombre 
            ,
            T2.acd_id,
            T1.sol_id,            
            C1.dep_nombre,
            C1.dep_clave,
            T1.sol_pos14,
            C2.baja_descrip,
			T1.sol_memo1,
            T1.sol_status
            FROM movimientos_solicitud AS T1
            LEFT JOIN academicos AS T2 ON T1.sol_pos2 = T2.acd_id
            LEFT JOIN catalogo_dependencia AS C1 ON T1.sol_pos1 = C1.dep_clave
            LEFT JOIN catalogo_baja AS C2 ON T1.sol_pos12 = C2.baja_clave
            WHERE T1.sol_id = #vSolId#
        </cfquery>

		<cfquery name="tbSysClaves" datasource="samaa">
			SELECT top 1
			newid() AS clave_alfanum,
			RAND() AS 'Random',
			abs(CHECKSUM(newid())) AS clave_acceso
			FROM sys.tables
        </cfquery>

		<!--- Obtener del envío de correo electrónico para notificar baja
		<cfquery name="tbNotificaCorreo" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM samaa_notifica_correos
			WHERE sol_id = #vIdSol#
		</cfquery>
		 --->

		<cfoutput query="tbSolicitudes">
        	<cfset trimDepClave = mid(#dep_clave#,1,4)>
			<cfif #tbSolicitudes.sol_status# EQ 3>
                <cfset vAdjunta = '#vCarpetaENTIDAD#\#trimDepClave#\#acd_id#_#sol_id#.pdf'>
            <cfelseif #tbSolicitudes.sol_status# LTE 2>
                <cfset vAdjunta = '#vCarpetaCAAA#\#acd_id#_#sol_id#.pdf'>
			</cfif>
		</cfoutput>
        <!--- <cfdump var="#vCorreosEnvio#"> --->
        
		<hr />
		<span class="Sans12ViNe">Se envi&oacute; la notificaci&oacute;n a:</span><br />
        <cfloop index="i" from="1" to="#ArrayLen(vCorreosEnvio)#">
			<cfoutput><span class="Sans10ViNe">#vCorreosEnvio[i][2]# - #vCorreosEnvio[i][1]#</span></cfoutput><br />

            <cfmail type="html" to="#vCorreosEnvio[i][1]#" cc="samaa@cic.unam.mx" from="samaa@cic.unam.mx" subject="Notificacion de RENUNCIA a beca posdoctoral UNAM" username="samaa@cic.unam.mx" password="HeEaSamaa%8282" server="smtp.gmail.com" port="465" useSSL="yes" charset="iso-8859-1">
                <p>Estimado #vCorreosEnvio[i][2]#,</p>
                <p></p>
                <p>
                    Se informa que se ha registrado una renuncia en el SAMAA del siguiente becario posdoctoral (se adjunta documentos digitalizados):
                </p>
                <p></p>
                <p>
                    <ul>
                        <li>NOMBRE: #tbSolicitudes.nombre#</li>
                        <li>ENTIDAD: #tbSolicitudes.dep_nombre#</li>
                        <li>BAJA A PARTIR DEL: #LsDateFormat(tbSolicitudes.sol_pos14,'dd/mm/yyyy')#</li>
                        <li>TIPO: #tbSolicitudes.baja_descrip#</li>
                        <li>MOTIVO: #tbSolicitudes.sol_memo1#</li>
                    </ul>
                </p>
                <p>
					Favor de notificar la recepci&oacute;n de este correo electr&oacute;nico.<br />
					<a href="#vHttp#/includes/notifica_correo_solicitud.cfm?vSolId=#vSolId#&vEmpId=#vCorreosEnvio[i][3]#&vCodVerifica=#tbSysClaves.clave_alfanum#" target="WinSAMAANotifica">
						<span class="">DAR CLICK PARA NOTIFICAR</span>
					</a>
					
<!---
                    <form action="#vCarpetaRaiz#/includes/notifica_correo_solicitud.cfm?vSolId=#vSolId#&vEmpId=#vCorreosEnvio[i][3]#&vCodVerifica=#tbSysClaves.clave_alfanum#" method="get" target="WinSAMAANotifica">
						<input type="text" name="vSolId" id="vSolId" value="#vSolId#" />
						<input type="text" name="vEmpId" id="vEmpId" value="#vCorreosEnvio[i][3]#" />
						<input type="text" name="vCodVerifica" id="vCodVerifica" value="#tbSysClaves.clave_alfanum#" />
						<input type="text" name="vEmail" id="vEmail" value="#vCorreosEnvio[i][1]#" />
						<input type="submit" value="NOTIFICAR ACUSE DE CORREO" />
                    </form>
--->						

					<!---
					<iframe src="#vCarpetaRaiz#/includes/notifica_correo_solicitud.cfm?vSolId=#vSolId#&vEmpId=#vCorreosEnvio[i][3]#&vCodVerifica=#tbSysClaves.clave_alfanum#" frameborder="0"></iframe>
					--->					
                </p>
    
                <p>Sin m&aacute;s por el momento, reciban un cordial saludo.</p>
				<cfif FileExists(#vAdjunta#)>			
                	<cfmailparam file="#vAdjunta#" type="application/pdf">
				</cfif>
            </cfmail>

			<!--- Inserta  --->
            <cfquery name="tbNotificaCorreo" datasource="samaa">
				INSERT INTO samaa_notifica_correos
                (sol_id, notifica_no_empleado, notifica_email, notifica_fecha_email, notifica_clave_alfanum)
                VALUES
                (#vSolId#, #vCorreosEnvio[i][3]#, '#vCorreosEnvio[i][1]#', GETDATE(), '#tbSysClaves.clave_alfanum#')
            </cfquery>

		</cfloop>