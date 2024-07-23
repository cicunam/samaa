<!--- 
CREADO: ARAM PICHARDO
EDITO: JOS� ANTONIO ESTEVA
FECHA: 31/01/2011
---
IDENTIFICACI�N DEl USUARIO
--->
<!--- Incluir archivo de errores --->
<cfinclude template="/comun_cic/acceso_error.cfm">
<!--- Par�metros --->
<cfparam name="vpReturnValor" default="">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>CIC - Concentraci�n de Informaci�n del SIC</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/login.css" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="<cfoutput>#vCarpetaLIB#</cfoutput>/jquery-1.6.2.min.js"></script>
		<script language="JavaScript" type="text/JavaScript">
			// Validaci�n de campos:
			function fValidaCampos()
			{
			    var vErroresLogin = '';
			    if ($("#vpUno").val() == '') vErroresLogin = "La clave es requerida\n";
			    if ($("#vpDos").val() == '') vErroresLogin += "La contrase�a es requerida\n";
			    if (vErroresLogin.length > 0) 
			    {
			        alert(vErroresLogin);
			        return;
			    }
			    else if (vErroresLogin.length == 0) 
			    {
					$("#form1").attr("action","/comun_cic/acceso_sistema.cfm");
					$("#form1").attr("method","post");
					$("#form1").trigger("submit");
				}
			}
			function DetectarEnter(e) 
			{
				if (!e) var e = window.event;
				if (e.keyCode) codigo = e.keyCode;
				else if (e.which) codigo = e.which;
				if (codigo==13) fValidaCampos()
			}
		</script> 
	</head>
	<body marginheight="1" marginwidth="">
<!---    
		<cfoutput>
        http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT & ReReplace(getDirectoryFromPath(CGI.SCRIPT_NAME),"/$","","ONE")#
        <br>
        #Application.vCarpetaRaiz#
        <br>
        #Application.vCarpetaRaizLogica#
        </cfoutput>
--->		
		<!-- Contenido -->
		<table style="width:1024px;">
			<tr>
				<td>
					<br><br>
					<!-- Acceso a las dependencias -->
					<table class="Recuadro">
						<tr>
							<td class="RecuadroTitulo">Acceso al sistema</td>
						</tr>
						<tr>
							<td style="vertical-align:middle;">
								<!-- Formulario para env�o de nombre de usuario y contrase�a -->
								<cfform name="form1" id="form1" target="_parent">
									<table class="Login">
										<!-- Usuario --->
										<tr>
											<td class="Etiqueta">Usuario</td>
											<td class="Entrada">
												<cfinput name="vpUno" id="vpUno" type="text" onkeypress="DetectarEnter(event)" style="width:75px;" />
												<cfinput name="vpHttp" type="hidden" id="vpSistema" value="#vCarpetaRaizLogica#" />
												<cfinput name="vpHttp" type="hidden" id="vpHttp" value="#vCarpetaRaizLogica#" />                                                
											</td>
										</tr>
										<!-- Contrase�a -->
										<tr>
											<td class="Etiqueta">Contrase&ntilde;a</td>
											<td class="Entrada">
												<cfinput name="vpDos" id="vpDos" type="password" onkeypress="DetectarEnter(event)" style="width:75px;" />
												<cfinput name="vpSistema" type="hidden" id="vpSistema" value="SAMAA" />
											</td>	
										</tr>
										<!-- Botones -->
										<tr>
											<td class="Botones" colspan="2">
												<input type="button" value="Entrar"  class="Boton" onClick="fValidaCampos();">
												<input type="button" value="Limpiar" class="Boton" onClick="window.parent.location='index.cfm';">
											</td>
										</tr>
									</table>
								</cfform>
							</td>
						</tr>
						<cfif #vpReturnValor# NEQ ''>
							<tr>
								<td class="Alerta">
									<cfoutput>#vTextoError#</cfoutput>
								</td>
							</tr>
						</cfif>
					</table>
					<br>
					<!-- Requrimientos del sistema -->
                    <cfinclude template="/comun_cic/include_sistemas_requerimientos.cfm">
					<br>
                    <!-- Contacto -->
                    <cfinclude template="/comun_cic/include_sistemas_contacto.cfm">
<!---
					<!-- Requrimientos del sistema -->
					<table class="Recuadro">
						<tr>
							<td class="RecuadroTitulo">Requerimientos de sistema</td>
						</tr>
						<tr>
							<td style="margin-left:auto; margin-right:auto;">
								<!-- Navegadores -->
								<ul>
									<li>Windows: Internet Explorer 6.0+</li>
									<li>Mac: Safari 1.2+</li>
									<li>Linux: Mozilla FireFox 3.0+</li>
									<li>Resoluci&oacute;n de v&iacute;deo 1024x768</li>
								</ul>
							</td>
						</tr>
					</table>
					<br>
					<!-- Cr�ditos -->
					<table class="Recuadro">
						<tr>
							<td class="RecuadroTitulo">Contacto</td>
						</tr>
						<tr>
							<td class="CuadroGris" style="vertical-align:top;">
								<div class="Sans10Ne" style="display:block; width:80%; padding:5px; margin:auto; text-align:center;">
									<span class="Arial10Negra">
										<br>
										Coordinaci&oacute;n de la Investigaci&oacute;n Cient&iacute;fica<br>
										Secretar&iacute;a T&eacute;cnica de Seguimiento<br>
										Tel&eacute;fonos: 5622-4168 &oacute; 70<br><br>
									</span>
								</div>
							</td>
						</tr>
					</table>
--->					
				</td>
			</tr>
		</table>
	</body>
</html>
