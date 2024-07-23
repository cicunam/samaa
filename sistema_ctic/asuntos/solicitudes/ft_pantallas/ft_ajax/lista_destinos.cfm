<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 05/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 24/06/2016 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR DESTINOS EN COMISIONES--->

	<!--- Parámetros --->
	<cfparam name="vIdRegDestino" default="">
	<cfparam name="vComandoDestino" default="">

	<cfif #vComandoDestino# EQ 'INSERTA'>

        <cfquery datasource="#vOrigenDatosSAMAA#">
            INSERT INTO movimientos_destino (sol_id, acd_id, des_institucion, pais_clave, edo_clave, des_ciudad)
            VALUES (
              <cfif #vIdSol# NEQ "">
                #vIdSol#<cfelse>NULL</cfif>
                ,
              <cfif #vIdAcad# NEQ "">
                #vIdAcad#<cfelse>NULL</cfif>
                ,
              <cfif #des_institucion# NEQ "">
                '#SinAcentos(Ucase(des_institucion),0)#'<cfelse>NULL</cfif>
                ,
              <cfif #pais_clave# NEQ "">
                '#Ucase(pais_clave)#'<cfelse>NULL</cfif>
                ,
              <cfif #edo_clave# NEQ "">
                '#SinAcentos(Ucase(edo_clave),0)#'<cfelse>NULL</cfif>
                ,
              <cfif #des_ciudad# NEQ "">
                '#SinAcentos(Ucase(des_ciudad),0)#'<cfelse>NULL</cfif>
            )
        </cfquery>
	<cfelse>
        <cfif #vComandoDestino# EQ 'ELIMINA'>
            <cfquery datasource="#vOrigenDatosSAMAA#">
                DELETE FROM movimientos_destino 
                WHERE id = #vIdRegDestino#
				<!--- dbo.TRIM(sol_id) + dbo.TRIM(des_institucion) + dbo.TRIM(pais_clave) + dbo.TRIM(des_ciudad) = '#vIdRegDestino#' --->
            </cfquery>
        </cfif>
        
        <!--- Base de datos para seleccionar destinos de una comisión --->
        <cfquery name="tbDestinos" datasource="#vOrigenDatosSAMAA#">
			SELECT * FROM movimientos_destino AS T1 
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_paises')# AS C1 ON T1.pais_clave = C1.pais_clave
			LEFT JOIN #MYSQL('CATALOGOS', 'catalogo_paises_edo')# AS C2 ON T1.edo_clave = C2.edo_clave AND  T1.pais_clave = C2.pais_clave
			WHERE sol_id = #vIdSol#
        </cfquery>
        
        <table width="100%" border="0" cellpadding="0" align="center">
            <tr id="lista_destinos_enc">
                <td width="53%"><span class="Sans9GrNe">Instituci&oacute;n</span></td>
                <td width="15%"><span class="Sans9GrNe">Pa&iacute;s</span></td>
                <td width="15%"><span class="Sans9GrNe">Estado / Provincia</span></td>
                <td width="15%"><span class="Sans9GrNe">Ciudad</span></td>
                <cfif #vActivaCampos# NEQ "disabled">
                    <td width="2%">&nbsp;</td>
                </cfif>
            </tr>
            <cfoutput query="tbDestinos">
				<tr>
					<td><span class="Sans9Gr">#tbDestinos.des_institucion#</span></td>
					<td><span class="Sans9Gr">#tbDestinos.pais_nombre#</span></td>
					<cfif #tbDestinos.pais_clave# EQ 'MEX' OR #tbDestinos.pais_clave# EQ 'USA'>
						<td><span class="Sans9Gr">#tbDestinos.edo_nombre#</span></td>
					<cfelse>
						<td><span class="Sans9Gr">#tbDestinos.edo_clave#</span></td>
					</cfif>
					<td><span class="Sans9Gr">#tbDestinos.des_ciudad#</span></td>
					<cfif #vActivaCampos# NEQ "disabled">
                        <td class="NoImprimir" align="right">
                            <img src="#vCarpetaICONO#/elimina_15.jpg" style="border:none; cursor:pointer;" title="Eliminar destino #id#" onclick="fEliminaDestino('#id#')">
                        </td>
<!--- PENDIENTE POR USAR
                    <td class="NoImprimir" align="right">
                        <img src="#vCarpetaICONO#/detalle_15.jpg" style="border:none; cursor:pointer;" title="Editar destino" onclick="">
                    </td>
--->
					</cfif>                
				</tr>
			</cfoutput>
		</table>
        <span class="NoImprimir"><div class="linea_gris"></div></span>
        <input type="hidden" name="HiddenNumDestinos" id="HiddenNumDestinos" value="<cfoutput>#tbDestinos.RecordCount#</cfoutput>">
    </cfif>