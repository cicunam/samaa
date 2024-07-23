<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 06/05/2009 --->
<!--- FECHA ÚLTIMA MOD.: 27/04/2023 --->
<!--- COMPLEMENTO DE FORMA TELEGRAMICA CON AJAX PARA LISTAR, AGREGAR O ELIMINAR OPONENTES EN CONCURSOS ABIERTO--->
<!---
<cfset vTexto = URLDecode(vTexto, 'iso-8859-1')>
--->

<!--- Obtener datos del catálogo de movimientos --->
<cfquery name="ctMovimiento" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM catalogo_movimiento 
	WHERE mov_clave = #vFt# <!--- AND mov_status = 1 ORDER BY mov_orden--->
</cfquery>

<cfset vActivaOr = "NA">
<!--- Obtener datos de los académicos encontrados --->
<cfquery name="tbAcademicoLista" datasource="#vOrigenDatosSAMAA#">
	SELECT * FROM consulta_academicos_busqueda
    WHERE
	dbo.SINACENTOS(nombre_completo_busqueda) LIKE '%#NombreSinAcentos(vTexto)#%'
    <!--- Filtro por clase (Investigador/Profesor o Técnico academico, según el parámetro que se envía (20/09/2022) --->
	<cfif #ctMovimiento.mov_clase_filtro# EQ "INV">
		AND (cn_clase = 'INV' OR cn_clase = 'PRO')
	<cfelseif #ctMovimiento.mov_clase_filtro# EQ "TEC">
		AND cn_clase = 'TEC'
	<cfelseif #ctMovimiento.mov_clase_filtro# EQ "AMBOS">
		AND (cn_clase = 'INV' OR cn_clase = 'PRO' OR cn_clase = 'TEC')
	</cfif>
        
	<!--- Filtrar por el tipo de contrato especificado en el catálogo de movimeintos --->
	<cfif #ctMovimiento.mov_contrato_filtro# NEQ "0">
		AND (
		<cfif FIND("0",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 0
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("1",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 1
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("2",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 2
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("3",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 3
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("5",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 5
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("6",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 6
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("7",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 7
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("8",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 8
			<cfset vActivaOr = "OR">
		</cfif>
		<cfif FIND("9",#ctMovimiento.mov_contrato_filtro#) GT 0>
			<cfif vActivaOr EQ "OR"> OR </cfif>
			con_clave = 9
		</cfif>
		)
	</cfif>
	<cfif #vFt# EQ 9 OR #vFt# EQ 10 OR #vFt# EQ 19>
		AND (cn_clave <> 'I6696' AND cn_clave <> 'I9689')
	</cfif>
	<!--- En caso de seleccionar baja elimina los academicos con baja --->
	<cfif #vFt# EQ 14>
		AND (activo <> 0)
	</cfif>
  	<!--- El reconocimiento de antigüedad (FT-CTIC-34) es solo para INVESTIGADORES Y TÉCNICOS TITULARES NIVEL "C" --->
	<cfif #vFt# EQ 34>
		AND cn_siglas LIKE '%TIT C%'
	</cfif>
	<!---
	NOTA: ESTA PENDIENTE DETERMINAR EN QUE CASOS SE FILTRARÁN LOS ACADÉMICOS DE LA DEPENDENCIA QUE ESTÁ CAPTURANDO. 
	<cfif #Session.sTipoSistema# IS 'sic' AND (#vFt# NEQ 5 AND #vFt# NEQ 6 AND #vFt# NEQ 38 AND #vFt# NEQ 39)>
		AND dep_clave = '#Session.sIdDep#'
	</cfif>
	--->
	ORDER BY nombre_completo_pmn
</cfquery>

<!--- 
NOTA: Pendiente hacer que pasen las Ñ bien. Este campo es para ver el valor que recibe ColdFusion.
<input type="text" value="<cfoutput>#vTexto#</cfoutput>">
--->
<select name="lstAcad" id="lstAcad" size="5" class="datos" style="width: 550px;"><!--- <cfif #vFt# EQ 40 OR #vFt# EQ 41>onchange="fSeleccionAcademico();"<cfelse>onchange="fListarAsuntosDuplicados();"</cfif>--->
	<cfif #vFt#	EQ 5 OR #vFt# EQ 6 OR #vFt#	EQ 13 OR #vFt#	EQ 26 OR #vFt# EQ 38 OR #vFt# EQ 44><option value="0" onclick="fSeleccionAcademico();">NUEVO ACADEMICO</option></cfif>
	<cfoutput query="tbAcademicoLista">
        <option value="#acd_id#" onclick="fSeleccionAcademico();">
            #nombre_completo_pmn#
            <cfif #Session.sTipoSistema# EQ 'stctic' AND #dep_siglas# NEQ ''>
                &nbsp;-&nbsp;(#dep_siglas#)
            </cfif>
        </option>
	</cfoutput>
</select>
