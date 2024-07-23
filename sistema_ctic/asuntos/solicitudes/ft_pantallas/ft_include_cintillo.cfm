<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2016 --->
<!--- FECHA ULTIMA MOD.: 23/02/2016--->
<!--- Cintillo con nombre y número de forma telegrámica --->

		<cfoutput>
            <table width="100%" class="Cintillo">
                <tr>
                    <td width="80%"><span class="Sans10GrNe">SOLICITUDES &gt;&gt; </span><span class="Sans10Gr">#vTipoComando#</span></td>
                    <td width="20%" align="right"><!---<span class="Sans10GrNe">FT-CTIC-#vFt#</span>---></td>
                </tr>
            </table>
		</cfoutput>
		<cfif #vTipoComando# IS 'CONSULTA'>
			<!--- Include para abrir archivo PDF enviando parámetros por POST --->                    
			<cfinclude template="#vCarpetaRaizLogicaSistema#/comun/consulta_pdf_comun.cfm">
		</cfif>