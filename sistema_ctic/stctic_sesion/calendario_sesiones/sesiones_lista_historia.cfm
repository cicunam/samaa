

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfparam name="PageNum_sesiones" default="1">
<cfparam name="vFechaInico" default="0">
<cfparam name="vFechaTermino" default="0">
<cfparam name="vNoSesion" default="0">

<cfset vMes = val(LsDateFormat(now(),"mm"))>
<cfset vAnio = val(LsDateFormat(now(),"yyyy"))>
<cfset vAnioPost = val(LsDateFormat(now(),"yyyy")) + 1>

<cfquery name="sesiones" datasource="#vOrigenDatosSAMAA#">
	<cfif #vFechaInico# EQ "0" AND #vFechaTermino# EQ "0" AND #vNoSesion# EQ "0">
		SELECT * FROM sesiones WHERE FECHAPLENO < GETDATE() ORDER BY nosesion DESC
	<cfelse>
		<cfif #vFechaInico# NEQ "0" AND #vFechaTermino# NEQ "0">
			SELECT * FROM sesiones WHERE FECHAPLENO > '#vFechaInico#' AND FECHAPLENO < '#vFechaTermino#' ORDER BY nosesion DESC
		<cfelseif #vFechaInico# NEQ "0">
			SELECT * FROM sesiones WHERE FECHAPLENO > '#vFechaInico#' AND FECHAPLENO < GETDATE() ORDER BY nosesion DESC
		<cfelseif #vFechaTermino# NEQ "0">
			SELECT * FROM sesiones WHERE FECHAPLENO < '#vFechaTermino#' ORDER BY nosesion DESC		
		<cfelseif #vNoSesion# NEQ "0">
			SELECT * FROM sesiones WHERE nosesion = #vNoSesion# ORDER BY nosesion DESC
		</cfif>
	</cfif>
</cfquery>

<cfset vMsgFecha = 'La fecha debe de ser Dia/Mes/Año; ejemplo ' & #LsdateFormat(NOW(),'dd/mm/yyyy')#>
<cfset vMsgNumero = 'Se requiere números enteros'>

<cfset MaxRows_sesiones=20>
<cfset StartRow_sesiones=Min((PageNum_sesiones-1)*MaxRows_sesiones+1,Max(sesiones.RecordCount,1))>
<cfset EndRow_sesiones=Min(StartRow_sesiones+MaxRows_sesiones-1,sesiones.RecordCount)>
<cfset TotalPages_sesiones=Ceiling(sesiones.RecordCount/MaxRows_sesiones)>
<cfset QueryString_sesiones=Iif(CGI.QUERY_STRING NEQ "",DE("&"&XMLFormat(CGI.QUERY_STRING)),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_sesiones,"PageNum_sesiones=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_sesiones=ListDeleteAt(QueryString_sesiones,tempPos,"&")>
</cfif>

<html>
<head>
<title>STCTIC - Asuntos Acad&eacute;mico-Administrativos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/general.css" rel="stylesheet" type="text/css">
<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/herramientas.css" rel="stylesheet" type="text/css">
<link href="<cfoutput>#vCarpetaCSS#</cfoutput>/fuentes.css" rel="stylesheet" type="text/css">
</head>

<body>
<table width="1024" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td width="621" height="14"><em class="Sans10NeNe">SESIONES ANTERIORES</em></td>
    <td width="178"><div align="right"><span class="Sans10ViNe">Sesi&oacute;n: <cfoutput>#LsNumberFormat(session.sSesion,'9999')#</cfoutput></span></div></td>
  </tr>
</table>
<table width="800" border="0">
  <tr>
    <td width="180" valign="top"><cfoutput>
      <table width="155" border="0">
        <tr>
          <td width="258" valign="top"><div align="left" class="Sans9ViNe">________________________</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans10NeNe">MEN&Uacute;:</div></td>
        </tr>
        <tr>
          <td valign="top"><input disabled onclick="window.open('../reportes/ventana_reportes.cfm?vReporte=calendario_sesiones.cfr','Reportes','toolbar=no,scrollbars=yes,location=no,width=705,height=500')" name="Submit" type="submit" class="botones" value="Imprimir calendario"></td>
        </tr>
        <tr>
          <td valign="top"></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans9ViNe">________________________</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left">&nbsp;</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans9ViNe">________________________</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans10NeNe">B&Uacute;SQUEDA:</div></td>
        </tr>
		<cfif #vFechaInico# NEQ "0" OR #vFechaTermino# NEQ "0" OR #vNoSesion# NEQ "0">
        <tr>
          <td bgcolor="##CCCCCC"><span class="Sans10ViNe">- <a href="sesiones_lista_historia.cfm">Limpiar b&uacute;squeda</a></span></td>
        </tr>
		</cfif>
        <tr>
          <td valign="top" bgcolor="##CCCCCC"><span class="Sans10ViNe">- Peri&oacute;do</span></td>
        </tr>
        <tr>
          <td valign="top" class="Sans10ViNe"><cfform name="form1" method="get" action="sesiones_lista_historia.cfm">
            <table width="153" border="0">
              <tr>
                <td width="48" class="Sans9GrNe">Inicio:</td>
                <td width="84"><cfinput value="dd/mm/yyyy" name="vFechaInico" type="text" class="textos" id="textInicio" size="12" maxlength="10" validate="eurodate" message="Campo: Inicio: #vMsgFecha#"></td>
              </tr>
              <tr>
                <td class="Sans9GrNe">T&eacute;rmino:</td>
                <td><cfinput value="dd/mm/yyyy" name="vFechaTermino" type="text" class="textos" id="textTermino" size="12" maxlength="10" validate="eurodate" message="Campo: Término: #vMsgFecha#"></td>
              </tr>
              <tr>
                <td colspan="2" class="Sans9GrNe">
                  <div align="center">
                    <cfinput name="subSesion2" type="submit" class="botones" id="subSesion22" value="Buscar">
                  </div></td>
                </tr>
            </table>
          </cfform></td>
        </tr>
        <tr>
          <td valign="top" bgcolor="##CCCCCC"><span class="Sans10ViNe">- No. de sesi&oacute;n</span></td>
        </tr>
        <tr>
          <td valign="top">
			<cfform name="form1" method="post" action="sesiones_lista_historia.cfm">
            <table width="153" border="0">
              <tr>
                <td width="48" class="Sans9GrNe">Sesi&oacute;n:</td>
                <td width="84"><cfinput name="vNoSesion" type="text" class="textos" size="6" maxlength="4" validate="integer" message="Campo: Sesión; #vMsgNumero#" required="yes">                  <cfinput name="subSesion" type="submit" class="botones" id="subSesion" value="Ir"></td>
              </tr>
            </table>
          	</cfform>		  
		  </td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans9ViNe">________________________</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left">&nbsp;</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans9ViNe">________________________</div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left" class="Sans10NeNe">SESIONES:</div></td>
        </tr>
        <tr><cfoutput><td valign="top"><div align="left"><span class="Sans10NeNe">Registros</span> <span class="Sans10Ne">#StartRow_sesiones#</span> <span class="Sans10NeNe"> a </span><span class="Sans10Ne">#EndRow_sesiones#</span></div></td>
        </cfoutput>
        </tr>
        <tr>
          <td valign="top"><div align="left"><span class="Sans10NeNe">Total: </span><span class="Sans10Ne"><cfoutput>#sesiones.RecordCount#</cfoutput></span></div></td>
        </tr>
        <tr>
          <td valign="top"><div align="left">
            <div align="left" class="Sans9ViNe">________________________</div>
            <font size="1" face="Verdana"><font color="##333333"> </font></font></div></td>
        </tr>
      </table>
    </cfoutput> </td>
    <td width="844" valign="top"><table width="600" border="0" align="center" class="CuadrosMarron">
      <tr>
        <td><div align="center" class="Sans10NeNe">CALENDARIO DE SESIONES DEL CTIC<br><br>
        </div>
			</td>
      </tr>
    </table>
      <table width="600" border="0" align="center" cellpadding="3" cellspacing="0">
        <tr bgcolor="#CCCCCC">
          <td width="135" align="center" class="Sans10ViNe">Recepci&oacute;n de documentos</td>
          <td width="135" align="center" class="Sans10ViNe">Reuni&oacute;n CAAA</td>
          <td width="135" align="center" class="Sans10ViNe">Sesi&oacute;n CTIC </td>
          <td width="115" align="center" class="Sans10ViNe">Acta</td>
          <td width="50" class="Sans10ViNe">&nbsp;</td>
        </tr>
        <cfoutput query="sesiones" startrow="#StartRow_sesiones#" maxrows="#MaxRows_sesiones#">
          <tr <CFIF #sesiones.nosesion# EQ session.sSesion> bgcolor="##FFCC00"</CFIF> >
            <td align="center"><span class="Sans10Ne">#LSDateFormat(sesiones.fecharecdoc,'MMMM')# </span><span class="Sans10Ne">#LSDateFormat(sesiones.fecharecdoc,'DD')#, </span><span class="Sans10NeNe">#LSDateFormat(sesiones.fecharecdoc,'YYYY')#</span></td>
            <td align="center"><span class="Sans10Ne">#LSDateFormat(sesiones.fechacaaa,'MMMM')# </span><span class="Sans10Ne">#LSDateFormat(sesiones.fechacaaa,'DD')#, </span><span class="Sans10NeNe">#LSDateFormat(sesiones.fechacaaa,'YYYY')#</span></td>
			<cfif IsDate(#sesiones.fechapleno_m#)>
            <td align="center"><span class="ArialAltas10rojaN">#LSDateFormat(sesiones.fechapleno_m,'MMMM')# </span><span class="ArialAltas10rojaN">#LSDateFormat(sesiones.fechapleno_m,'DD')#, </span><span class="ArialAltas10rojaN">#LSDateFormat(sesiones.fechapleno_m,'YYYY')#</span></td>
			<cfelse>
            <td align="center"><span class="Sans10Ne">#LSDateFormat(sesiones.fechapleno,'MMMM')# </span><span class="Sans10Ne">#LSDateFormat(sesiones.fechapleno,'DD')#, </span><span class="Sans10NeNe">#LSDateFormat(sesiones.fechapleno,'YYYY')#</span></td>
			</cfif>
            <td align="center"><span class="Sans10NeNe">#LSNUMBERFORMAT(sesiones.nosesion,'9999')#</span></td>
            <td bgcolor="##CCCCCC" class="CuadrosMarron"><div align="center"><span class="Sans10NeNe"><a href="sesion_detalle.cfm?vNoListaSesion=#sesiones.nosesion#">Detalle</a></span></div></td>
          </tr>
          <tr>
            <td colspan="5" align="center"><hr></td>
          </tr>
        </cfoutput>
      </table>
      <table width="50%" border="0" align="center" class="CuadrosMarron">
        <cfoutput>
          <tr>
            <td width="23%" align="center">
              <cfif PageNum_sesiones GT 1>
                <a href="#CurrentPage#?PageNum_sesiones=1#QueryString_sesiones#" class="Sans10ViNe">Primero</a>
              </cfif>
            </td>
            <td width="31%" align="center">
              <cfif PageNum_sesiones GT 1>
                <a href="#CurrentPage#?PageNum_sesiones=#Max(DecrementValue(PageNum_sesiones),1)##QueryString_sesiones#" class="Sans10ViNe">Anterior</a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_sesiones LT TotalPages_sesiones>
                <a href="#CurrentPage#?PageNum_sesiones=#Min(IncrementValue(PageNum_sesiones),TotalPages_sesiones)##QueryString_sesiones#" class="Sans10ViNe">Siguiente</a>
              </cfif>
            </td>
            <td width="23%" align="center">
              <cfif PageNum_sesiones LT TotalPages_sesiones>
                <a href="#CurrentPage#?PageNum_sesiones=#TotalPages_sesiones##QueryString_sesiones#" class="Sans10ViNe">Último</a>
              </cfif>
            </td>
          </tr>
        </cfoutput>
      </table>
	  </td>
  </tr>
</table>
<br>
<table width="1024" cellspacing="0" class="CuadroGris">
  <tr>
    <td height="8" bgcolor="#7BA7D2"></td>
  </tr>
  <tr>
    <td height="14" bgcolor="#336699"></td>
  </tr>
</table>
<p>&nbsp;</p>
</body>
</html>
