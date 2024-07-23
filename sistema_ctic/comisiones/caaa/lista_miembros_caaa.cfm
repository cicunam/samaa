<!--- CREADO: JOSÉ ANTONIO ESTEVA --->
<!--- EDITO: JOSÉ ANTONIO ESTEVA --->
<!--- FECHA: 21/10/2009 --->
<!--- LISTA DE MIEMBROS DE AL CAAA --->
<!--- Parámetros --->
        <cfparam name="vTipoCargoAdmin" default="">
        <cfparam name="vComisionClave" default=0>
        <cfparam name="vSesionActualCaaa" default=1512>
        <cfparam name="vPagina" default="1">

        <cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

        <cfquery name="tbComision" datasource="#vOrigenDatosSAMAA#">
            SELECT * FROM ((academicos_comisiones AS T1
            LEFT JOIN academicos AS T2 ON T1.acd_id = T2.acd_id)
            LEFT JOIN catalogo_comisiones AS C1 ON T1.comision_clave = C1.comision_clave)
            WHERE (T1.status) = 1 OR (T1.ssn_id = #vSesionActualCaaa#)
            <cfif #vComisionClave# GT 1>
                AND T1.comision_clave = #vComisionClave#
            </cfif>
            ORDER BY T1.comision_clave ASC, T2.acd_apepat, T2.acd_apemat DESC
        </cfquery>

        <table style="width: 800px;  margin: 10px 0px 10px 15px; border: none" cellspacing="0" cellpadding="1">
            <tr valign="middle" bgcolor="#CCCCCC">
                <td width="72%"><span class="Sans9GrNe">NOMBRE</span></td>
                <td width="10%">&nbsp;</td>
                <td width="15%"><span class="Sans9GrNe">FECHA INICIO</span></td>
                <td width="3%" bgcolor="#0066FF"></td>
            </tr>
            <cfoutput query="tbComision">
            <tr onMouseOver="this.style.backgroundColor='##E8E8E8'" onMouseOut="this.style.backgroundColor='##FFFFFF'">
                <td valign="top"><span class="Sans9Gr">#tbComision.acd_prefijo# #tbComision.acd_apepat# #tbComision.acd_apemat#, #tbComision.acd_nombres#</span></td>
                <td valign="top">
                    <span class="Sans9Gr">
                    <cfif #presidente# EQ 1>Presidente</cfif>
                    <cfif #sustitucion# EQ 1>Sustituto</cfif>
                    </span>
                </td>
                <td valign="top"><span class="Sans9Gr">#LsDateFormat(tbComision.fecha_inicio,'dd/mm/yyyy')#</span></td>
                <!-- Botón VER -->
                <td align="center"><a href="miembro_caaa.cfm?vComisionId=#tbComision.comision_acd_id#&vTipoComando=CONSULTA"><img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none;"></a></td>
            </tr>
            </cfoutput>
        </table>
