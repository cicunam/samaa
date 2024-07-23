<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 17/04/2009 --->
<!--- ARCHIVO PARA GUARDAR INFORMACION DE CORRECIÓN DE FORMAS TELEGRAMICAS--->

<!--- Valores predeterminados de parámetros --->
<cfparam name="vActa" default="#Session.sSesion#">

<!--- Verifica que se esté editando el registro --->
<cfif IsDefined("vTipoComando") AND vTipoComando EQ "EDITA">
	
	<!--- Obtiene datos del catálogo de movimeitnos --->
	<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
		SELECT * FROM catalogo_movimiento WHERE mov_clave = #vFt#
	</cfquery>

	<!--- Generación y ejecución de la instrucción SQL UPDATE --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		UPDATE movimientos_solicitud SET 
		sol_pos1=
		<cfif IsDefined("pos1") AND #pos1# NEQ "">
		  '#pos1#'<cfelse>NULL</cfif>
		, sol_pos1_u=
		<cfif IsDefined("pos1_u") AND #pos1_u# NEQ "">
		  '#pos1_u#'<cfelse>NULL</cfif>  
		, sol_pos2=
		<cfif IsDefined("pos2") AND #pos2# NEQ "">
		  #pos2#<cfelse>0</cfif>
		, sol_pos3=
		<cfif IsDefined("pos3") AND #pos3# NEQ "">
		  '#pos3#'<cfelse>NULL</cfif>
		, sol_pos4=
		<cfif IsDefined("pos4") AND #pos4# NEQ "">
		  #pos4#<cfelse>NULL</cfif>
		, sol_pos4_f=
		<cfif IsDefined("pos5_d") AND #pos5_d# NEQ "">
		  '#LsDateFormat(pos4_f,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
		, sol_pos5=
		<cfif IsDefined("pos5") AND #pos5# NEQ "">
		  #pos5#<cfelse>NULL</cfif>
		, sol_pos6=
		<cfif IsDefined("pos6") AND #pos6# NEQ "">
		  #pos6#<cfelse>NULL</cfif>
		, sol_pos7=
		<cfif IsDefined("pos7") AND #pos7# NEQ "">
		  '#LsDateFormat(pos7,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
		, sol_pos8=
		<cfif IsDefined("pos8") AND #pos8# NEQ "">
		  '#SinAcentos(Ucase(pos8),0)#'<cfelse>NULL</cfif>
		, sol_pos9=
		<cfif IsDefined("pos9") AND #pos9# NEQ "">
		  '#pos9#'<cfelse>NULL</cfif>
		, sol_pos10=
		<cfif IsDefined("pos10") AND #pos10# NEQ "">
		  #pos10#<cfelse>NULL</cfif>
		, sol_pos11=
		<cfif IsDefined("pos11") AND #pos11# NEQ "">
		  '#SinAcentos(Ucase(pos11),0)#'<cfelse>NULL</cfif>
		, sol_pos11_p=
		<cfif IsDefined("pos11_p") AND #pos11_p# NEQ "">
		  '#SinAcentos(Ucase(pos11_p),0)#'<cfelse>NULL</cfif>
		, sol_pos11_e=
		<cfif IsDefined("pos11_e") AND #pos11_e# NEQ "">
		  '#SinAcentos(Ucase(pos11_e),0)#'<cfelse>NULL</cfif>	
		, sol_pos11_c=
		<cfif IsDefined("pos11_c") AND #pos11_c# NEQ "">
		  '#SinAcentos(Ucase(pos11_c),0)#'<cfelse>NULL</cfif>
		, sol_pos11_u=
		<cfif IsDefined("pos11_u") AND #pos11_u# NEQ "">
		  '#SinAcentos(Ucase(pos11_u),0)#'<cfelse>NULL</cfif>
		, sol_pos12=
		<cfif IsDefined("pos12") AND #pos12# NEQ "">
		  '#SinAcentos(Ucase(pos12),0)#'<cfelse>NULL</cfif>
		, sol_pos12_o=
		<cfif IsDefined("pos12_o") AND #pos12_o# NEQ "">
		  '#SinAcentos(Ucase(pos12_o),0)#'<cfelse>NULL</cfif>  
		, sol_pos13=
		<cfif IsDefined("pos13") AND #pos13# NEQ "">
		  '#SinAcentos(Ucase(pos13),0)#'<cfelse>NULL</cfif>
		, sol_pos13_a=
		<cfif IsDefined("pos13_a") AND #pos13_a# NEQ "">
		  #pos13_a#<cfelse>0</cfif>
		, sol_pos13_m=
		<cfif IsDefined("pos13_m") AND #pos13_m# NEQ "">
		  #pos13_m#<cfelse>0</cfif>
		, sol_pos13_d=
		<cfif IsDefined("pos13_d") AND #pos13_d# NEQ "">
		  #pos13_d#<cfelse>0</cfif>
		, sol_pos14=
		<cfif IsDefined("pos14") AND #pos14# NEQ "">
		  '#LsDateFormat(pos14,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
		, sol_pos15=
		<cfif IsDefined("pos15") AND #pos15# NEQ "">
		  '#LsDateFormat(pos15,"dd/mm/yyyy")#'<cfelse>NULL</cfif>
		, sol_pos16=
		<cfif IsDefined("pos16") AND #pos16# NEQ "">
		  #pos16#<cfelse>0</cfif>
		, sol_pos17=
		<cfif IsDefined("pos17") AND #pos17# NEQ "">
		  #pos17#<cfelse>0</cfif>
		, sol_pos18=
		<cfif IsDefined("pos18") AND #pos18# NEQ "">
		  '#SinAcentos(Ucase(pos18),0)#'<cfelse>NULL</cfif>
		, sol_pos19=
		<cfif IsDefined("pos19") AND #pos19# NEQ "">
		  #pos19#<cfelse>NULL</cfif>
		, sol_pos20=
		<cfif IsDefined("pos20") AND #pos20# NEQ "">
		  <cfif #pos20# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos21=
		<cfif IsDefined("pos21") AND #pos21# NEQ "">
		  '#LsDateFormat(pos21,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
		, sol_pos22=
		<cfif IsDefined("pos22") AND #pos22# NEQ "">
		  '#LsDateFormat(pos22,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
		, sol_pos23=
		<cfif IsDefined("pos23") AND #pos23# NEQ "">
		  '#SinAcentos(Ucase(pos23),0)#'<cfelse>NULL</cfif>
		, sol_pos24=
		<cfif IsDefined("pos24") AND #pos24# NEQ "">
		  '#LsDateFormat(pos24,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
		, sol_pos25=
		<cfif IsDefined("pos25") AND #pos25# NEQ "">
		 '#LsDateFormat(pos25,'dd/mm/yyyy')#'<cfelse>NULL</cfif>
		, sol_memo1=
		<cfif IsDefined("memo1") AND #memo1# NEQ "">
		  '#SinAcentos(memo1,1)#'<cfelse>NULL</cfif>
		, sol_memo2=
		<cfif IsDefined("memo2") AND #memo2# NEQ "">
		  '#SinAcentos(memo2,1)#'<cfelse>NULL</cfif>
		, sol_pos26=
		<cfif IsDefined("pos26") AND #pos26# NEQ "">
		  <cfif #pos26# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos27=
		<cfif IsDefined("pos27") AND #pos27# NEQ "">
		  <cfif #pos27# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos28=
		<cfif IsDefined("pos28") AND #pos28# NEQ "">
		  <cfif #pos28# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos29=
		<cfif IsDefined("pos29") AND #pos29# NEQ "">
		  <cfif #pos29# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos30=
		<cfif IsDefined("pos30") AND #pos30# NEQ "">
		  <cfif #pos30# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos31=
		<cfif IsDefined("pos31") AND #pos31# NEQ "">
		  <cfif #pos31# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos32=
		<cfif IsDefined("pos32") AND #pos32# NEQ "">
		  <cfif #pos32# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos33=
		<cfif IsDefined("pos33") AND #pos33# NEQ "">
		  <cfif #pos33# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos34=
		<cfif IsDefined("pos34") AND #pos34# NEQ "">
		  <cfif #pos34# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos35=
		<cfif IsDefined("pos35") AND #pos35# NEQ "">
		  <cfif #pos35# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos36=
		<cfif IsDefined("pos36") AND #pos36# NEQ "">
		  <cfif #pos36# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos37=
		<cfif IsDefined("pos37") AND #pos37# NEQ "">
		  <cfif #pos37# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos38=
		<cfif IsDefined("pos38") AND #pos38# NEQ "">
		  <cfif #pos38# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos39=
		<cfif IsDefined("pos39") AND #pos39# NEQ "">
		  <cfif #pos39# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_pos40=
		<cfif IsDefined("pos40") AND #pos40# NEQ "">
		  <cfif #pos40# EQ "Si">1<cfelse>0</cfif>
		<cfelse>NULL</cfif>
		, sol_devuelta = 0
		, cap_fecha_mod = GETDATE() 
		WHERE sol_id = #vIdSol#
	</cfquery>
	
	<!--- Registrar en la bitácora la eliminación del registro --->
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO bitacora_registros (usuario,ip,tabla,registro,accion,fecha) 
		VALUES 
		(
			'#Session.sUsuario#',
			'#CGI.REMOTE_ADDR#',
			'movimientos_solicitud',
			#vIdSol#,
			'M',
			GETDATE()
		)
	</cfquery>
	
	<!--- Redireccionar al formlario de captura de la forma telegrámica	--->
	<cflocation url="../#ctMovimiento.mov_ruta#?vActa=#vActa#&vIdAcad=#vIdAcad#&vIdSol=#vIdSol#&vTipoComando=CONSULTA&vFt=#vFt#" addtoken="no">	
</cfif>
