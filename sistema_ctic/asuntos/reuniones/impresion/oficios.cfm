<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 14/01/2010 --->
<!--- FECHA ÚLTIMA MOD.: 10/12/2015 --->

<!--- IMPRESION DE OFICIOS DE RESPUESTA --->
<!--- Enviar el contenido a un archivo MS Word --->
<cfheader name="Content-Disposition" value="inline; filename=oficios.doc">
<cfcontent type="application/msword; charset=iso-8859-1">

<!--- Obtener la información del COORDINADOR actual --->
<cfquery name="tbAcademicosCargosCoord" datasource="#vOrigenDatosSAMAA#">
	SELECT caa_firma, caa_siglas 
    FROM academicos_cargos
    WHERE adm_clave = 84
    AND caa_status = 'A'
</cfquery>

<!--- Obtener información de la sesión del CTIC --->
<cfquery name="tbSesiones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM sesiones 
    WHERE ssn_id = #vActa# 
    AND ssn_clave = 1
</cfquery>

<!--- Fecha la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)> 
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset DiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>
<!--- Fecha del día despues de la sesión de pleno --->
<cfif IsDate(#tbSesiones.ssn_fecha_m#)>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha_m))>
<cfelse>
	<cfset SiguienteDiaCTIC = Ucase(FechaCompleta(tbSesiones.ssn_fecha))>
</cfif>
<!--- Obtener los datos de la solicitud --->
<cfquery name="tbSolicitudes" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM ((((movimientos_solicitud 
	LEFT JOIN movimientos_asunto ON movimientos_solicitud.sol_id = movimientos_asunto.sol_id)
	LEFT JOIN academicos ON movimientos_solicitud.sol_pos2 = academicos.acd_id)
	LEFT JOIN catalogo_movimiento ON movimientos_solicitud.mov_clave = catalogo_movimiento.mov_clave) 
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON movimientos_solicitud.sol_pos1 = C2.dep_clave)
	LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_cn')# AS C3 ON movimientos_solicitud.sol_pos3 = C3.cn_clave
	WHERE movimientos_asunto.ssn_id = #vActa#
	AND movimientos_asunto.asu_reunion = 'CTIC'
	AND movimientos_asunto.asu_parte < 7 <!--- Excluir los asuntos de los que no se genera oficio de respuesta --->
	ORDER BY 
	movimientos_asunto.asu_parte,
	movimientos_asunto.asu_numero	
</cfquery>
<!--- 
NOTA IMPORTANTE: 
Incluir aquí variables <cfset> para los elementos del oficio que se utilizan comúnmente (fecha de inicio, duración, decisión, etc.),
para, de esta manera, incluir solamente el nombre de la variable.
--->
<html>
	<head>
		<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/oficios.css" rel="stylesheet" type="text/css">
		<style type="text/css">
			@page { 
			size: 21.59cm 27.94cm;
			margin: 2cm;
			}
		</style>
	</head>
	<body style="color:black; font-family:sans-serif; font-weight:normal;">
		<cfoutput query="tbSolicitudes">
			<cfif ArrayContainsValue(Session.AsuntosCTICFiltro.vMarcadas, #tbSolicitudes.sol_id#) IS TRUE>
				<!--- Obtener la recomandación de la CAAA --->
				<cfquery name="tbAsuntosCTIC" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_asunto
					INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CTIC'
				</cfquery>
				<!--- Obtener la decisión del CTIC --->
				<cfquery name="tbAsuntosCAAA" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM movimientos_asunto
					INNER JOIN catalogo_decision ON movimientos_asunto.dec_clave = catalogo_decision.dec_clave
					WHERE sol_id = #tbSolicitudes.sol_id# AND ssn_id = #vActa# AND asu_reunion = 'CAAA'
				</cfquery>
				<!--- Obtener la categoría y nivel del movimiento --->
				<cfquery name="ctCategoria" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_cn
					WHERE cn_clave = '#tbSolicitudes.sol_pos8#'
				</cfquery>
				<!--- Obtener la dependencia del movimiento --->
				<cfquery name="ctDependencia" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM catalogo_dependencia WHERE dep_clave = '#tbSolicitudes.sol_pos11#'
				</cfquery>
				<!--- Obtener datos de la convocatoria para plaza y concurso desierto --->
				<cfif #tbSolicitudes.mov_clave# IS 15 OR #tbSolicitudes.mov_clave# IS 16>
					<cfquery name="tbConvocatorias" datasource="#vOrigenDatosSAMAA#">
						SELECT * FROM convocatorias_coa	WHERE coa_id = '#tbSolicitudes.sol_pos23#'
					</cfquery>
				</cfif>
				<!--- Obtener el nombre del director --->
				<cfquery name="tbAcademicosCargos" datasource="#vOrigenDatosSAMAA#">
					SELECT * FROM (academicos_cargos
					LEFT JOIN academicos ON academicos_cargos.acd_id = academicos.acd_id)
					LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_dependencias')# AS C2 ON academicos_cargos.dep_clave = C2.dep_clave
					WHERE academicos_cargos.dep_clave = '#tbSolicitudes.sol_pos1#' 
					AND academicos_cargos.adm_clave = '32'
					AND academicos_cargos.caa_fecha_inicio <= GETDATE()
					AND academicos_cargos.caa_fecha_final >= GETDATE()
				</cfquery>
				<!-- Tabla para situar la firma siempre en el mismo lugar -->
				<table width="100%" border="0" cellpadding="4" cellspacing="0">
					<tr>
						<td width="100%" height="490" valign="top">
							<!--- Número de oficio y asunto --->
							<p class="OficioAsunto">
								Oficio #tbSolicitudes.asu_oficio#<br>
								Asunto: #tbSolicitudes.mov_titulo_listado#<br>
								<cfif #tbAsuntosCTIC.dec_super# IS 'AP' AND (#tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 6)>Plaza No. #tbSolicitudes.sol_pos9#<br><cfelse><br></cfif>
								<br><br><br><br>
							</p>
							<!--- Dirigido a --->
							<p class="Academico" style="width:100%; font-size: 10pt; text-align: left;">
								<cfif #tbSolicitudes.mov_clave# IS 15 OR #tbSolicitudes.mov_clave# IS 16 OR #tbSolicitudes.mov_clave# IS 38>
									#Trim(tbAcademicosCargos.acd_prefijo)# #Trim(tbAcademicosCargos.acd_nombres)# #Trim(tbAcademicosCargos.acd_apepat)# #Trim(tbAcademicosCargos.acd_apemat)#<br>
									DIRECTOR<cfif #tbAcademicosCargos.acd_sexo# IS 'F'>A</cfif> DEL #Ucase(tbSolicitudes.dep_nombre)#<br>
								<cfelseif #tbSolicitudes.mov_clave# IS 30>
									DR. RAFAEL PEREZ PASCUAL<br> <!--- TEMPORAL: Este dato debe obtenerse de una tabla de funcionarios --->
									DIRECTOR GENERAL DE ASUNTOS DEL<br>PERSONAL ACAD&Eacute;MICO<br>
								<cfelse>
									#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#<br>
									#Ucase(tbSolicitudes.dep_nombre)#<br>
								</cfif>
								Presente
							</p>
							<!--- Texto del oficio ---->				
							<cfswitch expression="#tbSolicitudes.mov_clave#">
								<cfcase value="1">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 57 inciso B 
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su #Ucase(tbSolicitudes.mov_titulo_listado)#, 
										por #tbSolicitudes.sol_pos16# HORAS A LA SEMANA
										durante <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
									</p>
								</cfcase>
								<cfcase value="2,3">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en los art&iacute;culos 95 inciso B y 96
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> 
										su <cfif #tbSolicitudes.mov_clave# IS 3>prorroga de </cfif>comisi&oacute;n
										por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #FechaCompleta(tbSolicitudes.sol_pos14)#,
										con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
									</p>
								</cfcase>
								<cfcase value="5,17,28">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en los art&iacute;culos correspondientes
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> el dict&aacute;men de la Comisi&oacute;n Dictaminadora
										<cfif #tbSolicitudes.mov_clave# IS 5 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# IS NOT 1)>
											para otrorgarle un contrato como #Ucase(ctCategoria.cn_descrip)#,
											por un año a partir del #SiguienteDiaCTIC#.
										<cfelseif #tbSolicitudes.mov_clave# IS 28 OR (#tbSolicitudes.mov_clave# IS 17 AND #tbSolicitudes.sol_pos5# IS 1)>
											para otrorgarle su nombramiento definitivo como #Ucase(ctCategoria.cn_descrip)#,	
											a partir del #SiguienteDiaCTIC#.
										</cfif>	
									</p>
								</cfcase>
								<cfcase value="6">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 51
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su contrato por obra determinada
										por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										por #NumberFormat(tbSolicitudes.sol_pos16,'99')# horas a la semana,
										con sueldo mensual EQUIVALENTE A #Ucase(ctCategoria.cn_descrip)#,
										con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
									</p>
								</cfcase>
								<cfcase value="7,8,18">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en <cfif #tbSolicitudes.mov_clave# IS 7>el art&iacute;culo 19<cfelse>los art&iacute;culos 66, 78 y 79</cfif>
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> el dictamen de la Comisi&oacute;n Dictaminadora para otorgarle su definitividad 
										como #Ucase(tbSolicitudes.cn_descrip)#,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="9,10,19">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en <cfif #tbSolicitudes.mov_clave# IS 9 OR (#tbSolicitudes.mov_clave# IS 19 AND #Left(Ucase(ctCategoria.cn_descrip),3)# IS 'TEC')>el art&iacute;culo 19<cfelseif #tbSolicitudes.mov_clave# IS 10 OR (#tbSolicitudes.mov_clave# IS 19 AND #Left(Ucase(ctCategoria.cn_descrip),3)# IS 'INV')>los art&iacute;culos 66, 78 y 79</cfif>
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> el dictamen de la Comisi&oacute;n Dictaminadora para otorgarle su promoci&oacute;n
										de #Ucase(tbSolicitudes.cn_descrip)#
										a #Ucase(ctCategoria.cn_descrip)#,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="11">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 92 inciso G)
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su LICENCIA SIN GOCE DE SUELDO
										por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="12">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 94
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> 
										su CAMBIO DE <cfif #Right(Ucase(Trim(ctCategoria.cn_descrip)),2)# IS 'TC'>MEDIO TIEMPO A TIEMPO COMPLETO<cfelse>TIEMPO COMPLETO A MEDIO TIEMPO</cfif>
										como #CnSinTiempo(Ucase(ctCategoria.cn_descrip))#,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="13">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 92
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> 
										su CAMBIO DE ADSCRIPCI&Oacute;N <cfif #tbSolicitudes.sol_pos10# IS 1>DEFINITIVO,<cfelse>TEMPORAL</cfif>
										<cfif #tbSolicitudes.sol_pos10# IS 2>
											por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										</cfif>
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										<cfif #Left(tbSolicitudes.dep_nombre,2)# IS 'CE' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'CC' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'IN' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'PR'>DEL<cfelse>DE LA</cfif> #Ucase(tbSolicitudes.dep_nombre)#
										<cfif #Left(ctDependencia.dep_nombre,2)# IS 'CE' OR #Left(ctDependencia.dep_nombre,2)# IS 'CC' OR #Left(ctDependencia.dep_nombre,2)# IS 'IN' OR #Left(ctDependencia.dep_nombre,2)# IS 'PR'>AL<cfelse>A LA</cfif> #Ucase(ctDependencia.dep_nombre)#.
									</p>
								</cfcase>
								<cfcase value="15,16,42">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										decidi&oacute; DECLARAR DESIERTO EL CONCURSO DE OPOCISI&Oacute;N PARA INGRESO
										para ocupar la PLAZA DE #Ucase(ctCategoria.cn_descrip)#,
										para trabajar en el &aacute;rea de #Ucase(tbConvocatorias.coa_area)#,
										publicada en la gaceta de la UNAM del #FechaCompleta(tbSolicitudes.sol_pos21)#,
										debido a que <cfif #tbSolicitudes.mov_clave# IS 15>NINGUNO DE LOS CONCURSANTES QUE SE PRESENTARON REUNI&Oacute; LOS REQUISITOS PARA OCUPAR DICHA PLAZA.<cfelse>NO SE PRESENTARON CONCURSANTES PARA OCUPAR DICHA PLAZA.</cfif>
									</p>
								</cfcase>
								<cfcase value="20,36">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Me permito comunicar a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#, 
										conoci&oacute; su solicitud de <cfif #tbSolicitudes.mov_clave# IS 20>REINCORPORACI&Oacute;N<cfelse>REINGRESO</cfif> <cfif #Left(tbSolicitudes.dep_nombre,2)# IS 'CE' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'CC' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'IN' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'PR'>al<cfelse>a la</cfif> #Ucase(tbSolicitudes.dep_nombre)#,
										que fuera enviada por el director de la dependencia.
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Por lo anterior y con base en el art&iacute;culo <cfif #tbSolicitudes.mov_clave# IS 20>101<cfelse>103</cfif> 
										del Estatuto del Personal Acad&eacute;mico de la UNAM,
										y debido a que existe suficiencia presupuestal para ello,
										este Consejo T&eacute;cnico decidi&oacute; 
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su <cfif #tbSolicitudes.mov_clave# IS 20>REINCORPORACI&Oacute;N<cfelse>REINGRESO</cfif> a dicha dependencia,
										<cfif #tbSolicitudes.mov_clave# IS 36>
											por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										</cfif>	
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										como #Ucase(ctCategoria.cn_descrip)#.
										<cfif #ctCategoria.cn_clave# EQ #tbSolicitudes.cn_clave#>
											Es decir, con la categor&iacute;a y nivel que usted ten&iacute;a en la UNAM antes de su separaci&oacute;n.
										</cfif>	
									</p>
								</cfcase>
								<cfcase value="21">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 58
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su <cfif #tbSolicitudes.sol_pos13# IS 'A'>A&Ntilde;O<cfelse>SEMESTRE</cfif> SAB&Aacute;TICO,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
									</p>
								</cfcase>
								<cfcase value="22">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										con base en el art&iacute;culo 58 inciso D) del Estatuto del Personal Acad&eacute;mico de la UNAM, 
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#, conoci&oacute; y aprob&oacute; la solicitud 
										del #Trim(tbAcademicosCargos.acd_prefijo)# #Trim(tbAcademicosCargos.acd_nombres)# #Trim(tbAcademicosCargos.acd_apepat)# #Trim(tbAcademicosCargos.acd_apemat)#,
										para DIFERIR EL DISFRUTE DE SU PERIODO sab&aacute;tico
										del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))# 
										<cfif #tbSolicitudes.sol_pos10# IS 3>
											hasta el término de su #tbSolicitudes.sol_pos12#.
										<cfelse>
											hasta el #Ucase(FechaCompleta(tbSolicitudes.sol_pos15))#.
										</cfif>	
									</p>
								</cfcase>
								<cfcase value="23">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su INFORME 
										del <cfif #tbSolicitudes.sol_pos13# IS 'A'>A&Ntilde;O<cfelse>SEMESTRE</cfif> SAB&Aacute;TICO
										que le fuera concedido a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="25">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en los art&iacute;culos correspondientes
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> otro contrato bajo condiciones similares al anterior
										como #Ucase(tbSolicitudes.cn_descrip)#,
										por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
								</cfcase>
								<cfcase value="26">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en los art&iacute;culos 52 y 63
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> su designaci&oacute;n como personal acad&eacute;mico visitante,
										durante <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
									</p>
								</cfcase>
								<cfcase value="29">
									<!--- Ubicación actual --->
									<cfquery name="ctUbicacionActual" datasource="#vOrigenDatosSAMAA#">
										SELECT * FROM catalogo_dependencia_ubica 
										WHERE dep_clave = '#tbSolicitudes.sol_pos1#' AND ubica_clave = '#tbSolicitudes.sol_pos1_u#'
									</cfquery>
									<!--- Ubicación a la que aspira --->
									<cfquery name="ctUbicacionAspira" datasource="#vOrigenDatosSAMAA#">
										SELECT * FROM catalogo_dependencia_ubica 
										WHERE dep_clave = '#tbSolicitudes.sol_pos1#' AND ubica_clave = '#tbSolicitudes.sol_pos11_u#'
									</cfquery>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#,
										con fundamento en el art&iacute;culo 92
										del Estatuto del Personal Acad&eacute;mico de la UNAM, acord&oacute;:
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> 
										su CAMBIO DE UBICACI&Oacute;N <cfif #tbSolicitudes.sol_pos10# IS 1>DEFINITIVO<cfelse>TEMPORAL</cfif>
										<cfif #tbSolicitudes.sol_pos10# IS 2>
											por <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;O</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										</cfif>
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
										<cfif #ctUbicacionActual.ubica_tipo# IS 'UNIDAD' OR #ctUbicacionActual.ubica_tipo# IS 'ESTACION' OR #ctUbicacionActual.ubica_tipo# IS 'DEPENDENCIA'  OR #ctUbicacionActual.ubica_tipo# IS 'PLATAFORMA'>de la<cfelse>del</cfif> #ctUbicacionActual.ubica_nombre# #ctUbicacionActual.ubica_lugar#
										<cfif #ctUbicacionAspira.ubica_tipo# IS 'UNIDAD' OR #ctUbicacionAspira.ubica_tipo# IS 'ESTACION' OR #ctUbicacionAspira.ubica_tipo# IS 'DEPENDENCIA'  OR #ctUbicacionAspira.ubica_tipo# IS 'PLATAFORMA'>a la<cfelse>al</cfif> #ctUbicacionAspira.ubica_nombre# #ctUbicacionAspira.ubica_lugar#.
									</p>
								</cfcase>
								<cfcase value="30">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#, decidi&oacute; 
										<cfif #tbAsuntosCTIC.dec_descrip# IS NOT ''>#Ucase(tbAsuntosCTIC.dec_descrip)#<cfelse>#Ucase(tbAsuntosCAAA.dec_descrip)#</cfif> el <cfif #tbSolicitudes.sol_pos13# IS 'A'>A&Ntilde;O<cfelse>SEMESTRE</cfif> SAB&Aacute;TICO,
										del #Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#,
										a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#.
									</p>
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										En virtud de que re&uacute;ne los criterios acad&eacute;micos de rigor, este Consejo consider&oacute;
										que es merecedor de la beca sab&aacute;tica que ofrece la dependencia a su digno cargo.
									</p>
								</cfcase>
								<cfcase value="34">
									<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
										Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
										en su sesi&oacute;n ORDINARIA del #DiaCTIC#, acord&oacute;
										reconocerle <cfif #tbSolicitudes.sol_pos13_a# GT 0>#tbSolicitudes.sol_pos13_a# A&Ntilde;OS</cfif><cfif #tbSolicitudes.sol_pos13_m# GT 0> #tbSolicitudes.sol_pos13_m# MESES</cfif><cfif #tbSolicitudes.sol_pos13_d# GT 0> #tbSolicitudes.sol_pos13_d# D&Iacute;AS</cfif>,
										de antig&uuml;edad acad&eacute;mica, 
										<!--- en el --->
										con el prop&oacute;sito de que se compute como antig&uuml;edad en la UNAM para los efectos legales que procedan,
										en el nombramiento que como #Ucase(tbSolicitudes.cn_descrip)#
										tiene en <cfif #Left(tbSolicitudes.dep_nombre,2)# IS 'CE' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'CC' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'IN' OR #Left(tbSolicitudes.dep_nombre,2)# IS 'PR'>el<cfelse>la</cfif> #Ucase(tbSolicitudes.dep_nombre)#
										desde el #Ucase(FechaCompleta(tbSolicitudes.sol_pos21))#.
									</p>
								</cfcase>
								<cfcase value="38,39">
									<cfquery name="tbAcademicosAsesor" datasource="#vOrigenDatosSAMAA#">
										SELECT * FROM academicos
										WHERE acd_id = #tbSolicitudes.sol_pos12#
									</cfquery>
									<cfif #tbAsuntosCTIC.dec_super# IS 'AP' OR #tbAsuntosCTIC.dec_super# IS 'RT'>
										<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
											Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
											en su sesi&oacute;n ORDINARIA del #DiaCTIC#, 
											con fundamento en la Base VII, numeral 2.1, inciso e) de las Reglas de Operaci&oacute;n del Programa de Becas Posdoctorales de la UNAM,
											resolvi&oacute; otrogar la <cfif #tbSolicitudes.mov_clave# IS 39>renovaci&oacute;n de</cfif> beca posdoctoral <cfif #tbSolicitudes.acd_sexo# IS 'F'>a la<cfelse>al</cfif>:
											<br><br>
											#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#,
										</p>
										<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">	
											Por UN A&Ntilde;O, 
											a partir del #Ucase(FechaCompleta(tbSolicitudes.sol_pos14))#,
											con objeto de #tbSolicitudes.sol_memo1#<cfif #Right(tbSolicitudes.sol_memo1,1)# IS NOT ".">.</cfif>
											Bajo la asesor&iacute;a de <cfif #tbAcademicosAsesor.acd_sexo# IS 'F'>la<cfelse>el</cfif> #Trim(tbAcademicosAsesor.acd_prefijo)# #Trim(tbAcademicosAsesor.acd_nombres)# #Trim(tbAcademicosAsesor.acd_apepat)# #Trim(tbAcademicosAsesor.acd_apemat)#.
										</p>
										<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
											Asimismo, le comunico que el Becario est&aacute; obligado a informar de inmediato a este Consejo T&eacute;cnico 
											sobre cualquier tipo de remuneraci&oacute;n o pago econ&oacute;mico adicional a la beca; 
											adem&aacute;s, se le deber&aacute; informar que las actividades docentes que realice no podr&aacute;n exceder de 8 horas a la semana.
										</p>
									<cfelse>
										<p class="Parrafo" style="width:100%; font-size:10pt; text-align:justify;">
											Comunico a usted que el Consejo T&eacute;cnico de la Investigaci&oacute;n Cient&iacute;fica,
											en su sesi&oacute;n ORDINARIA del #DiaCTIC#, 
											con fundamento en la Base VII, numeral 2.1, inciso e) de las Reglas de Operaci&oacute;n del Programa de Becas Posdoctorales de la UNAM,
											resolvi&oacute; NO OTORGAR la beca posdoctoral <cfif #tbSolicitudes.acd_sexo# IS 'F'>a la<cfelse>al</cfif>:
											<br><br>
											#Trim(tbSolicitudes.acd_prefijo)# #Trim(tbSolicitudes.acd_nombres)# #Trim(tbSolicitudes.acd_apepat)# #Trim(tbSolicitudes.acd_apemat)#
										</p>
									</cfif>	
								</cfcase>
							</cfswitch>
						</td>
					</tr>
					<tr>
						<td width="100%" height="390" valign="top">			
							<!--- Firma --->
							<p class="Firma" style="width:100%; font-size:10pt; text-align:left;">
								<br>
								Atentamente<br><br>
								"Por mi raza hablar&aacute; el esp&iacute;ritu"<br>
								Ciudad Universitaria, Cd. Mx. a #FechaCompleta(Now())#
                                <br><br><br><br><br><br>
			                    #UCASE(tbAcademicosCargosCoord.caa_firma)#<br>
								PRESIDENTE DEL CONSEJO T&Eacute;CNICO DE LA INVESTIGACI&Oacute;N CIENT&Iacute;FICA<br><br><br>
							</p>
							<!--- Pie --->
							<p class="Pie" style="width:100%; font-size: 8pt; text-align:left;">
								<cfset vExtra = 0>
								<cfif #tbSolicitudes.mov_clave# IS 13>
									C.C.P. DIRECTORES DE LAS DEPENDENCIAS RESPECTIVAS<br>
								<cfelseif #tbSolicitudes.mov_clave# IS 15 OR #tbSolicitudes.mov_clave# IS 16><!--- Todas las demas con algunas excepciones --->
									C.C.P. COMISI&Oacute;N DICTAMINADORA DE LA ENTIDAD ACADÉMICA<br>
								<cfelse>
									C.C.P. DIRECTOR DE LA ENTIDAD ACADÉMICA<br>								
								</cfif>	
								<cfif #tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 6 OR #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 12 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 20 OR #tbSolicitudes.mov_clave# IS 28 OR #tbSolicitudes.mov_clave# IS 29>
									<span style="padding-left:34px;">COMISI&Oacute;N DICTAMINADORA DE LA DEPENDENCIA</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 11 OR #tbSolicitudes.mov_clave# IS 12 OR #tbSolicitudes.mov_clave# IS 13 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 19 OR #tbSolicitudes.mov_clave# IS 20 OR #tbSolicitudes.mov_clave# IS 21 OR #tbSolicitudes.mov_clave# IS 22 OR #tbSolicitudes.mov_clave# IS 23 OR #tbSolicitudes.mov_clave# IS 25 OR #tbSolicitudes.mov_clave# IS 26 OR #tbSolicitudes.mov_clave# IS 29 OR #tbSolicitudes.mov_clave# IS 34 OR #tbSolicitudes.mov_clave# IS 38>
									<span style="padding-left:34px;">CONSEJO INTERNO DE LA ENTIDAD ACADÉMICA <cfif #tbSolicitudes.mov_clave# IS 13>RECEPTORA</cfif></span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 34>							
									<span style="padding-left:34px;">SECRETARIO ADMINISTRATIVO DE LA UNAM</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 5 OR #tbSolicitudes.mov_clave# IS 6 OR #tbSolicitudes.mov_clave# IS 7 OR #tbSolicitudes.mov_clave# IS 8 OR #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 12 OR #tbSolicitudes.mov_clave# IS 13 OR #tbSolicitudes.mov_clave# IS 15 OR #tbSolicitudes.mov_clave# IS 16 OR #tbSolicitudes.mov_clave# IS 17 OR #tbSolicitudes.mov_clave# IS 18 OR #tbSolicitudes.mov_clave# IS 20 OR #tbSolicitudes.mov_clave# IS 28 OR #tbSolicitudes.mov_clave# IS 29 OR #tbSolicitudes.mov_clave# IS 34 OR #tbSolicitudes.mov_clave# IS 38>							
									<span style="padding-left:34px;">DIRECTOR GENERAL DE PRESUPUESTO</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 38>							
									<span style="padding-left:34px;">DIRECTOR GENERAL DE FINANZAS</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 9 OR #tbSolicitudes.mov_clave# IS 10 OR #tbSolicitudes.mov_clave# IS 19>							
									<span style="padding-left:34px;">DIRECTOR GENERAL DE ASUNTOS DEL PERSONAL ACADEMICO</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 12 OR #tbSolicitudes.mov_clave# IS 29 OR #tbSolicitudes.mov_clave# IS 34>							
									<span style="padding-left:34px;">DIRECTOR GENERAL PERSONAL</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<cfif #tbSolicitudes.mov_clave# IS 30 OR #tbSolicitudes.mov_clave# IS 38>							
									<span style="padding-left:34px;">INTERESADO</span><br>
								<cfelse>
									<cfset vExtra = #vExtra# + 1>
								</cfif>
								<!-- Poner los espacios que no se ocuparon --->
								<cfloop index="cc" from="1" to="#vExtra#"><br></cfloop>	
								Acta #vActa#<br><br>
								#tbAcademicosCargosCoord.caa_siglas#/BCM/stc
							</p>	
						</td>
					</tr>
				</table>
				<!--- Salto de página --->
				<br class="SaltoPagina">
			</cfif>
		</cfoutput>
	</body>
</html>

