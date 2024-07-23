<!--- CREA: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 19/03/2009 --->
<!--- FECHA ÚLTIMA MOD: 02/05/2022 --->
<!--- ARCHIVO PARA GUARDAR INFORMACION DE CORRECIÓN DE FORMAS TELEGRAMICAS --->

<cfif IsDefined("vTipoComando") AND vTipoComando EQ "NUEVO">
       
       <cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
           SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
       </cfquery>
		<cfif #vFt# EQ 6 AND #pos12# EQ 4 AND #Session.sTipoSistema# EQ 'stctic'>
	        <cfquery name="ctNombramientosAA" datasource="#vOrigenDatosSAMAA#">
    	       SELECT * FROM academicos_cargos
               WHERE adm_clave = 84
               AND caa_status = 'A'
			</cfquery>       	
        </cfif>
       
       <cfquery datasource="#vOrigenDatosSAMAA#">
         INSERT INTO movimientos_solicitud (sol_id, mov_clave, sol_pos1, sol_pos1_u, sol_pos2, sol_pos3, sol_pos4, sol_pos4_f, sol_pos5, sol_pos6, sol_pos7, sol_pos8, sol_pos9, sol_pos10, sol_pos11, sol_pos11_p, sol_pos11_e, sol_pos11_c, sol_pos11_u, sol_pos12, sol_pos12_o, sol_pos13, sol_pos13_a, sol_pos13_m, sol_pos13_d, sol_pos14, sol_pos15, sol_pos16, sol_pos17, sol_pos18, sol_pos19, sol_pos20, sol_pos21, sol_pos22, sol_pos23, sol_pos24, sol_pos25, sol_memo1, sol_memo2, sol_pos26, sol_pos27, sol_pos28, sol_pos29, sol_pos30, sol_pos31, sol_pos32, sol_pos33, sol_pos34, sol_pos35, sol_pos36, sol_pos37, sol_pos38, sol_pos39, sol_pos40, sol_status, sol_devuelta, sol_devuelve_edita, sol_devuelve_archivo, cap_fecha_crea, cap_fecha_mod, acd_id_firma) 
         VALUES (
         #vIdSol#
         ,
		#vFt#
         ,	 
         <cfif IsDefined("pos1") AND #pos1# NEQ "">
           '#pos1#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos1_u") AND #pos1_u# NEQ "">
           '#pos1_u#'<cfelse>NULL</cfif>
         , 
	  	<cfif IsDefined("pos2") AND #pos2# NEQ "">
           #pos2#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos3") AND #pos3# NEQ "">
           '#pos3#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos4") AND #pos4# NEQ "">
           #pos4#<cfelse>NULL</cfif>
         , 
	  <cfif IsDefined("pos4_f") AND #pos4_f# NEQ "">
           '#LsDateFormat(pos4_f,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos5") AND #pos5# NEQ "">
           #pos5#<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos6") AND #pos6# NEQ "">
           #pos6#<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos7") AND #pos7# NEQ "">
           '#LsDateFormat(pos7,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos8") AND #pos8# NEQ "">
           '#SinAcentos(Ucase(pos8),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos9") AND #pos9# NEQ "">
           '#pos9#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos10") AND #pos10# NEQ "">
           #pos10#<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos11") AND #pos11# NEQ "">
           '#SinAcentos(Ucase(pos11),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos11_p") AND #pos11_p# NEQ "">
           '#SinAcentos(Ucase(pos11_p),0)#'<cfelse>NULL</cfif>
         ,
         <cfif IsDefined("pos11_e") AND #pos11_e# NEQ "">
           '#SinAcentos(Ucase(pos11_e),0)#'<cfelse>NULL</cfif>
         ,  
         <cfif IsDefined("pos11_c") AND #pos11_c# NEQ "">
           '#SinAcentos(Ucase(pos11_c),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos11_u") AND #pos11_u# NEQ "">
           '#SinAcentos(Ucase(pos11_u),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos12") AND #pos12# NEQ "">
           '#SinAcentos(Ucase(pos12),0)#'<cfelse>NULL</cfif>
         ,
         <cfif IsDefined("pos12_o") AND #pos12_o# NEQ "">
           '#SinAcentos(Ucase(pos12_o),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos13") AND #pos13# NEQ "">
           '#SinAcentos(Ucase(pos13),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos13_a") AND #pos13_a# NEQ "">
           #pos13_a#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos13_m") AND #pos13_m# NEQ "">
           #pos13_m#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos13_d") AND #pos13_d# NEQ "">
           #pos13_d#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos14") AND #pos14# NEQ "">
           '#LsDateFormat(pos14,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos15") AND #pos15# NEQ "">
           '#LsDateFormat(pos15,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos16") AND #pos16# NEQ "">
           #pos16#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos17") AND #pos17# NEQ "">
           #pos17#<cfelse>0</cfif>
         , 
         <cfif IsDefined("pos18") AND #pos18# NEQ "">
           '#SinAcentos(Ucase(pos18),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos19") AND #pos19# NEQ "">
           #pos19#<cfelse>NULL</cfif>
         , 
	  <cfif IsDefined("pos20") AND #pos20# NEQ "">
           <cfif #pos20# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 	
         <cfif IsDefined("pos21") AND #pos21# NEQ "">
           '#LsDateFormat(pos21,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos22") AND #pos22# NEQ "">
           '#LsDateFormat(pos22,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos23") AND #pos23# NEQ "">
           '#SinAcentos(Ucase(pos23),0)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos24") AND #pos24# NEQ "">
           '#LsDateFormat(pos24,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos25") AND #pos25# NEQ "">
           '#LsDateFormat(pos25,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("memo1") AND #memo1# NEQ "">
           '#SinAcentos(memo1,1)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("memo2") AND #memo2# NEQ "">
           '#SinAcentos(memo2,1)#'<cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos26") AND #pos26# NEQ "">
		<cfif #pos26# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos27") AND #pos27# NEQ "">
		<cfif #pos27# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos28") AND #pos28# NEQ "">
           <cfif #pos28# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         ,
         <cfif IsDefined("pos29") AND #pos29# NEQ "">
           <cfif #pos29# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos30") AND #pos30# NEQ "">
           <cfif #pos30# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos31") AND #pos31# NEQ "">
           <cfif #pos31# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos32") AND #pos32# NEQ "">
           <cfif #pos32# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos33") AND #pos33# NEQ "">
           <cfif #pos33# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos34") AND #pos34# NEQ "">
           <cfif #pos34# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos35") AND #pos35# NEQ "">
           <cfif #pos35# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos36") AND #pos36# NEQ "">
           <cfif #pos36# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos37") AND #pos37# NEQ "">
           <cfif #pos37# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos38") AND #pos38# NEQ "">
           <cfif #pos38# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos39") AND #pos39# NEQ "">
           <cfif #pos39# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif IsDefined("pos40") AND #pos40# NEQ "">
           <cfif #pos40# EQ "Si">1<cfelse>0</cfif>
	  <cfelse>NULL</cfif>
         , 
         <cfif #Session.sTipoSistema# IS 'sic'>4<cfelse>3</cfif>
         ,
		0	
		,
		0	
		,
		0	
		,	
		GETDATE()
		,
		GETDATE()
        ,
		<cfif #vFt# EQ 6 AND #pos12# EQ 4 AND #Session.sTipoSistema# EQ 'stctic'>
        	#ctNombramientosAA.acd_id#
		<cfelse>
        	NULL
        </cfif>
         ) 
         </cfquery>
		<!--- Actualiza la situación de la convocatoria a status 5 en caso de coa ganado 15 concurso desierto y 16 plaza desierta 17/08/2018 --->
		<cfif #vFt# EQ 5 OR #vFt# EQ 15 OR #vFt# EQ 16>
           <cfquery datasource="#vOrigenDatosSAMAA#">
               	UPDATE convocatorias_coa 
                SET 
                	coa_status = #vFt#
                    ,
                    sol_id_relaciona = #vIdSol# 
				WHERE coa_id = '#pos23#'
			</cfquery>
            
            <!--- SE AGREGÓ EL MARCAR AL GANADÓR EN LA TABLA DE convocatorias_coa_concursa 02/05/2022 --->
		    <cfif #vFt# EQ 5>
                <cfquery name="tbSolicitudCoaGana" datasource="#vOrigenDatosSOLCOA#">
                    SELECT solicitud_id
                    FROM solicitudes
                    WHERE acd_id = #pos2#
                </cfquery>
                <cfquery datasource="#vOrigenDatosSAMAA#">
                    IF NOT EXISTS(
                        SELECT * FROM convocatorias_coa_concursa
	    			    WHERE sol_id = #vIdSol#
                        AND coa_id = '#pos23#'
                        AND acd_id = #pos2#
                        AND coa_ganador = 1
                    ) 
                       INSERT INTO convocatorias_coa_concursa
                        (sol_id, coa_id, acd_id, solicitud_id_coa, coa_ganador)
                        VALUES
                        (
                            #vIdSol#, '#pos23#' ,#pos2#, 
                            <cfif #tbSolicitudCoaGana.solicitud_id# NEQ ''>
                                #tbSolicitudCoaGana.solicitud_id#
                            <cfelse>NULL</cfif>
                            ,
                            1
                        )
                </cfquery>
            </cfif>
		</cfif>
		<!--- Registrar en la bitácora UN NUEVO REGISTRO del registro --->
        <cfquery datasource="#vOrigenDatosSAMAA#">
            INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
            VALUES 
            (
                '#Session.sUsuario#',
                '#CGI.REMOTE_ADDR#',
                'movimientos_solicitud',
                #vIdSol#,
                'N',
                GETDATE()
            )
        </cfquery>

	  <!--- Redireccionar al formlario de captura de la forma telegrámica --->
         <cflocation url="../#ctMovimiento.mov_ruta#?vIdAcad=#vIdAcad#&vIdSol=#vIdSol#&vFt=#vFt#&vTipoComando=CONSULTA" addtoken="no">
</cfif>
