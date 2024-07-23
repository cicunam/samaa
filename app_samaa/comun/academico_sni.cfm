<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 15/09/2014 --->
<!--- FECHA ÚLTIMA MOD.: 02/12/2015 --->

<cfparam name="vExpSni" default="0">

<!--- ABRE EL CATÁLOGO DE LAS TABLAS REGISTRADAS DEL SNI --->
<cfquery name="ctTbSni" datasource="#vOrigenDatosSNI#">
	SELECT TOP 1 * FROM catalogo_tablas_sni
	WHERE tabla_status = 1
    ORDER BY anio DESC
</cfquery>

<cfquery name="tbSni" datasource="sni_miembros">
	SELECT * FROM #ctTbSni.tabla_sni_nombre#
	WHERE exp = #vExpSni#
</cfquery>

		<cfoutput>
			<hr />
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
				<tr><td><span class="Sans10ViNe">SISTEMA NACIONAL DE INVESTIGADORES (SNI) #ctTbSni.anio#</span></td></tr>
				<tr><td><span class="Sans10NeNe">Nivel: </span><span class="Sans10Gr">#tbSni.nivel#</span></td></tr>
				<tr><td><span class="Sans10NeNe">&Aacute;rea: </span><span class="Sans10Gr">#tbSni.area#</span></td></tr>
				<tr><td><span class="Sans10NeNe">Campo: </span><span class="Sans10Gr">#tbSni.campo#</span></td></tr>
                <!---
				<tr><td><span class="Sans10NeNe">Disciplina: </span><span class="Sans10Gr">#tbSni.disciplina#</span></td></tr>
				<tr><td><span class="Sans10GrNe">Fuente: Base de datos proporcionada por el Sistema Nacional de Investigadores #ctTbSni.anio#</span></td></tr>
				--->
			</table>
		</cfoutput>
