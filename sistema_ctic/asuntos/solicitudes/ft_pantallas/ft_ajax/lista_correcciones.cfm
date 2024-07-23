<!--- CREADO: ARAM PICHARDO--->
<!--- EDITO: ARAM PICHARDO--->
<!--- FECHA CREA: 05/05/2009--->
<!--- FECHA ULTIMA MOD.: 05/05/2009--->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR DESTINOS EN COMISIONES--->
<!--- Parámetros --->
<cfparam name="vComando" default="">
<cfparam name="vIdReg" default="">
<cfparam name="vIdMov" default="">
<cfparam name="vFI" default="">
<cfparam name="vFF" default="">
<cfparam name="vApePat" default="">
<cfparam name="vApeMat" default="">
<cfparam name="vNombre" default="">
<cfparam name="vTexto" default="">

<!--- Obtener datos del movimiento relacionado --->
<cfquery name="tbMovimientoRel" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos 
    WHERE mov_id = #vIdMov#
</cfquery>

<!--- Insertar registro --->
<cfif #vComando# EQ 'INSERTA'>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		INSERT INTO movimientos_correccion (sol_id, mov_id, co_tipo, co_campo, co_apepat, co_apemat, co_nombres, co_fecha_inicio, co_fecha_final, co_texto)
		VALUES (
			<cfif #vIdSol# IS NOT ''>#vIdSol#<cfelse>NULL</cfif>,
			<cfif #vIdMov# IS NOT ''>#vIdMov#<cfelse>NULL</cfif>,
			<cfif #vTipo# IS NOT ''>'#vTipo#'<cfelse>NULL</cfif>,
			<cfif #vCampo# IS NOT ''>'#Ucase(vCampo)#'<cfelse>NULL</cfif>,
			<cfif #vApePat# IS NOT ''>'#Ucase(vApePat)#'<cfelse>NULL</cfif>,
			<cfif #vApeMat# IS NOT ''>'#Ucase(vApeMat)#'<cfelse>NULL</cfif>,
			<cfif #vNombre# IS NOT ''>'#Ucase(vNombre)#'<cfelse>NULL</cfif>,
			<cfif #vFI# IS NOT ''>'#vFI#'<cfelse>NULL</cfif>,
			<cfif #vFF# IS NOT ''>'#vFF#'<cfelse>NULL</cfif>,
			<cfif #vTexto# IS NOT ''>'#Ucase(vTexto)#'<cfelse>NULL</cfif>
		)
	</cfquery>
</cfif>

<!--- Eliminar registro (elimina el dice y el debe decir) --->
<cfif #vComando# EQ 'ELIMINA'>
	<cfquery datasource="#vOrigenDatosSAMAA#">
		DELETE FROM movimientos_correccion 
		WHERE dbo.TRIM(sol_id) + dbo.TRIM(mov_id) + dbo.TRIM(co_campo) = '#vIdReg#'
	</cfquery>
</cfif>
<!--- Base de datos para seleccionar destinos de una comisión --->
<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_correccion 
    WHERE sol_id = #vIdSol#
</cfquery>
<table width="100%" border="0" cellpadding="0" align="center">
	<cfoutput query="tbCorrecciones">
        <tr>
            <!-- Dice / Debe decir --->
            <td valign="top" width="16%"><span class="Sans9Gr">#tbCorrecciones.co_tipo#</span></td>
            <!-- Campo -->
            <td valign="top" width="16%"><span class="Sans9Gr">#tbCorrecciones.co_campo#</span></td>
            <!-- Descripción del cambio -->
            <td valign="top" width="68%">
				<span class="Sans9Gr">
					<cfif #tbCorrecciones.co_campo# IS 'NOMBRE'>
                        #tbCorrecciones.co_nombres# #tbCorrecciones.co_apepat# #tbCorrecciones.co_apemat#
                    <cfelseif #tbCorrecciones.co_campo# IS 'DURACION'>	
                        <cfif #tbCorrecciones.co_fecha_final# EQ ''>
                            <cfif #tbMovimientoRel.mov_clave# EQ 22>
                                Diferir de la fecha #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
                            <cfelse>
                                A partir del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
                            </cfif>
                        <cfelse>
                            <cfif #tbMovimientoRel.mov_clave# NEQ 22>
                                <!--- Desglosar el periodo en años, meses y días --->
                                <cfset vFF = #dateadd('d',1,tbCorrecciones.co_fecha_final)#>
                                <cfset vF1 = #tbCorrecciones.co_fecha_inicio#>
                                <cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
                                <cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
                                <cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
                                <cfset vF3 = #dateadd('m',vMeses,vF2)#>			
                                <cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
                                <cfif #vAnios# GT 0>#vAnios# año </cfif>
                                <cfif #vMeses# GT 0>#vMeses# <cfif #vMeses# EQ 1>mes<cfelse>meses</cfif></cfif>
                                <cfif #vDias# GT 0>#vDias# <cfif #vDias# EQ 1>día<cfelse>días</cfif></cfif>
                            </cfif>
                            <cfif #tbMovimientoRel.mov_clave# EQ 22> 
                                Diferir del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')# 
                            <cfelse> 
                                del #LsDateFormat(tbCorrecciones.co_fecha_inicio,'dd/mm/yyyy')#
                            </cfif>
                            al #LsDateFormat(tbCorrecciones.co_fecha_final,'dd/mm/yyyy')#
                        </cfif>
                    <cfelse>
                        #tbCorrecciones.co_texto#
                    </cfif>
                </span>
			</td>
			<cfif #vComando# EQ 'EDITA'>
                <!-- Botón editar -->
                <td align="right" valign="top" width="1%">
                	<cfif #co_tipo# EQ 'DICE'>
                    	<img id="#id#" src="#vCarpetaICONO#/nuevo_15.jpg" style="border:none; cursor:pointer;" title="Editar" onclick="">
					</cfif>
                </td>
                <!-- Botón eliminar -->
                <td align="right" valign="top" width="1%">
                	<cfif #co_tipo# EQ 'DICE'>
						<img id="#id#" src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar" onclick="fAgregarCorreccion('ELIMINA', '', '#Trim(tbCorrecciones.sol_id) & Trim(tbCorrecciones.mov_id) & Trim(tbCorrecciones.co_campo)#');">
					</cfif>
                </td>
			</cfif>
		</tr>
	</cfoutput>
<!---                                 
	<cfif #vComando# EQ 'EDITA'>
        <tr>
            <td colspan="5"><span class="NoImprimir"><div class="linea_gris"></div></span></td>
        </tr>
        <tr>
            <td colspan="4">
				Agregar una de correcci&oacute;n de
                <select name="frmSeleccionCampo" id="frmSeleccionCampo" class="datos" onChange="fMostrarFormulario(this.value);" <cfif #vActivaCampos# IS 'disabled'>disabled</cfif>>
                    <option value="">SELECCIONE</option>
                    <!--- <option value="GRADO">Grado acad&eacute;mico / T&iacute;tulo</option> --->
                    <option value="DURACION">Duraci&oacute;n y/o fechas</option>
                    <option value="NOMBRE">Nombre del académico</option>
                    <!--- <option value="PLAZA">N&uacute;mero de plaza</option> --->
                    <!--- <option value="UBICA">Ubicaci&oacute;n</option>--->
                    <option value="OTRO">Otra correcci&oacute;n</option>
                </select>
            </td>
            <td colspan="1">
                <img id="0" src="<cfoutput>#vCarpetaICONO#</cfoutput>/agregar_15.jpg" style="border:none; cursor:pointer;" title="Agregar" onclick="">
            </td>
        </tr>
	</cfif>
--->                                
</table>

