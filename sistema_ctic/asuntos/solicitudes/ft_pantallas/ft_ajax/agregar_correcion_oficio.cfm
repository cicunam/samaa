<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 23/10/2017 --->
<!--- AGREGA LAS CORRECIONES QUE SE LE HARÁN A UN MOVIMIENTO --->


<cfparam name="vIdSol" default="">
<cfparam name="vCoTipo" default="">

<!--- Base de datos para seleccionar destinos de una comisión --->
<cfquery name="tbCorrecciones" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM movimientos_correccion 
    WHERE sol_id = #vIdSol#
    AND co_tipo = '#vCoTipo#'
</cfquery>

<!-- FORMULARIO PARA AGREGAR CORRECCIONES (INICIA) -->
<!-- Coorrección de duración -->
<table>
    <cfif #tbMovimientoRel.mov_fecha_final# EQ '' OR #tbMovimientoRel.mov_fecha_final# EQ #tbMovimientoRel.mov_fecha_inicio#>
        <!-- Dice -->
        <tr id="frmDuracionDice" style="display: none;">
            <td width="20%"><span class="Sans9GrNe">Dice</span></td>
            <td width="80%">
                <!-- Fechas -->
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        Diferir de la fecha
                    <cfelse>
                        A partir del
                    </cfif>
                </span>
                <input id="fecha_inicio_dice" type="text" class="datos" size="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#</cfoutput>" disabled>
                <span class="Sans9Gr" id="pos14_txt">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>al término de su cargo/nombramiento.</cfif>
                </span>
            </td>
        </tr>
        <!-- Debe decir -->
        <tr id="frmDuracionDebeDecir" style="display: none;">
            <td><span class="Sans9GrNe">Debe decir</span></td>
            <td>
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        Diferir de la fecha&nbsp;
                    <cfelse>
                        A partir del&nbsp;
                    </cfif>
                </span>
                <input id="fecha_inicio_debe_decir" class="datos" type="text" size="10" maxlength="10" onChange="CalcularSiguienteFecha();" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                <span class="Sans9Gr" id="pos14_txt">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>al término de su cargo/nombramiento.</cfif>
                </span>
            </td>
        </tr>
    <cfelse>
        <!-- Dice -->
        <tr id="frmDuracionDice" style="display: none;">
            <td width="20%"><span class="Sans9GrNe">Dice</span></td>
            <td width="80%">
                <cfif #tbMovimientoRel.mov_clave# NEQ 22>
                    <!--- Desglosar el periodo en años, meses y días --->
                    <cfset vFF = #dateadd('d',1,tbMovimientoRel.mov_fecha_final)#>
                    <cfset vF1 = #tbMovimientoRel.mov_fecha_inicio#>
                    <cfset vAnios = #DateDiff('yyyy',#vF1#, #vFF#)#>
                    <cfset vF2 = #dateadd('yyyy',vAnios,vF1)#>
                    <cfset vMeses = #DateDiff('m',#vF2#, #vFF#)#>
                    <cfset vF3 = #dateadd('m',vMeses,vF2)#>
                    <cfset vDias = #DateDiff('d',#vF3#, #vFF#)#>
                    <!--- Construir la cadena de texto que se mostrará --->
                    <input type="text" class="datos" size="1" maxlength="1" value="<cfoutput>#vAnios#</cfoutput>" disabled>
                    <span class="Sans9Gr">año(s)</span>
                    <input type="text" class="datos" size="2" maxlength="2" value="<cfoutput>#vMeses#</cfoutput>" disabled>
                    <span class="Sans9Gr">mes(es)</span>
                    <input type="text" class="datos" size="2" maxlength="2" value="<cfoutput>#vDias#</cfoutput>" disabled>
                    <span class="Sans9Gr">d&iacute;a(s)</span>
                </cfif>
                <!-- Fechas -->
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        Diferir de la fecha&nbsp;
                    <cfelse>
                        del&nbsp;
                    </cfif>
                </span>
                <input id="fecha_inicio_dice" type="text" class="datos" size="10" maxlength="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_inicio,'dd/mm/yyyy')#</cfoutput>" disabled>
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        a la fecha&nbsp;
                    <cfelse>
                        al&nbsp;
                    </cfif>
                </span>
                <input id="fecha_final_dice" type="text" class="datos" size="10" maxlength="10" value="<cfoutput>#LsDateFormat(tbMovimientoRel.mov_fecha_final,'dd/mm/yyyy')#</cfoutput>" disabled>
            </td>
        </tr>
        <!-- Debe decir -->
        <tr id="frmDuracionDebeDecir" style="display: none;">
            <td><span class="Sans9GrNe" id="pos13_a_txt">Debe decir</span></td>
            <td>
                <cfif #tbMovimientoRel.mov_clave# NEQ 22>
                    <input id="duracion_a" type="text" class="datos" size="1" maxlength="1" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '9');">
                    <span class="Sans9Gr">año(s)</span>
                    <input id="duracion_m" type="text" class="datos" size="2" maxlength="2" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99');">
                    <span class="Sans9Gr">mes(es)</span>
                    <input id="duracion_d" type="text" class="datos" size="2" maxlength="2" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99');">
                    <span class="Sans9Gr">día(s)</span>
                </cfif>
                <!-- Fechas -->
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        Diferir de la fecha&nbsp;
                    <cfelse>
                        del&nbsp;
                    </cfif>
                </span>
                <input id="fecha_inicio_debe_decir" type="text" class="datos" size="10" maxlength="10" onBlur="CalcularFechaFinal();" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                <span class="Sans9Gr">
                    <cfif #tbMovimientoRel.mov_clave# EQ 22>
                        a la fecha <input id="fecha_final_debe_decir" type="text" class="datos" size="10" maxlength="10" onKeyPress="return MascaraEntrada(event, '99/99/9999');">
                    <cfelse>
                        al <input id="fecha_final_debe_decir" type="text" class="datos" size="10" maxlength="10" disabled>
                    </cfif>
                </span>
            </td>
        </tr>
    </cfif>
    <!-- Corrección de nombre -->
	<cfif ## EQ 'NOMBRE'>
        <!-- Dice -->
        <tr id="frmAcademicoDice" style="display: none;">
            <td width="20%"><span class="Sans9GrNe">Dice</span></td>
            <td width="80%">
                <table class="Sans9Gr">
                    <tr>
                        <td>Nombre</td>
                        <td><input id="nombre_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_nombres#</cfoutput>" size="40" disabled></td>
                    </tr>
                    <tr>
                        <td>Apellido paterno</td>
                        <td><input id="apepat_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_apepat#</cfoutput>" size="40" disabled></td>
                    </tr>
                    <tr>
                        <td>Apellido materno</td>
                        <td><input id="apemat_dice" type="text" class="datos" value="<cfoutput>#tbAcademico.acd_apemat#</cfoutput>" size="40" disabled></td>
                    </tr>
                </table>
            </td>
        </tr>
        <!-- División -->
        <tr><td colspan="2"><hr></td></tr>
        <!-- Debe decir -->
        <tr id="frmAcademicoDebeDecir" style="display: none;">
            <td width="20%"><span class="Sans9GrNe">Debe decir</span></td>
            <td width="80%">
                <table class="Sans9Gr">
                    <tr>
                        <td>Nombre</td>
                        <td><input id="nombre_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                    </tr>
                    <tr>
                        <td>Apellido paterno</td>
                        <td><input id="apepat_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                    </tr>
                    <tr>
                        <td>Apellido materno</td>
                        <td><input id="apemat_debe_decir" type="text" class="datos" size="40" maxlength="50"></td>
                    </tr>
                </table>
            </td>
        </tr>
	</cfif>
    <!-- Otras correcciones -->
	<cfif ## EQ 'NOMBRE'>
        <!-- Cambio en -->
        <tr id="frmOtrosCampo" style="display: none;">
            <td width="20%"><span class="Sans9GrNe">Cambio en</span></td>
            <td width="80%">
                <input id="otro_cambio_en" type="text" class="datos" size="20" maxlength="20">
            </td>
        </tr>
        <!-- Dice -->
        <tr id="frmOtrosDice" style="display: none;">
            <td><span class="Sans9GrNe">Dice</span></td>
            <td>
                <textarea id="otro_cambio_dice" cols="70" rows="4" class="datos100"></textarea>
            </td>
        </tr>
        <!-- Debe decir -->
        <tr id="frmOtrosDebeDecir" style="display: none;">
            <td><span class="Sans9GrNe">Debe decir</span></td>
            <td>
                <textarea id="otro_cambio_debe_decir" cols="70" rows="4" class="datos100"></textarea>
            </td>
        </tr>
        <!-- Botones -->
        <tr id="frmBotones" style="display: none;">
            <td colspan="2" align="center">
                <cfinput name="cmdAgregaCorreccion_1" id="cmdAgregaCorreccion_1" type="button" class="botonesStandar" value="AGREGAR" onclick="if (fValidaCamposCorreccion()) fMostrarFormulario(false);">
                <cfinput name="cmdAgregaCorreccion_2" id="cmdAgregaCorreccion_2" type="button" class="botonesStandar" value="CANCELAR" onclick="fMostrarFormulario(false);">
            </td>
        </tr>
	</cfif>
    <!-- FORMULARIO PARA AGREGAR CORRECCIONES (TERMINA) -->
</table>