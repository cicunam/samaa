<!--- CREADO: ARAM PICHARDO DURAN --->
<!--- EDITO: ARAM PICHARDO DURAN --->
<!--- FECHA CREA: 02/12/2015 --->
<!--- FECHA ÚLTIMA MOD.: 02/12/2015 --->

<cfparam name="vAcdNoEmpleado" default="0">

<!--- ABRE EL CATÁLOGO DE LAS TABLAS REGISTRADAS DEL SNI
<cfquery name="ctTbSni" datasource="sni_miembros">
	SELECT TOP 1 * FROM catalogo_tablas_sni
	WHERE tabla_status = 1
    ORDER BY anio DESC
</cfquery>
 --->


		<cfoutput>
			<hr />
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
				<tr><td><span class="Sans10ViNe">ESTÍMULO DGAPA</span></td></tr>
				<tr><td><span class="Sans10NeNe">Nivel: </span><span class="Sans10Gr">#tbSni.nivel#</span></td></tr>
			</table>
		</cfoutput>
