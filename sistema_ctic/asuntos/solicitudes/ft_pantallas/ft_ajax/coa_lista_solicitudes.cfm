<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 23/02/2022 --->
<!--- FECHA ÚLTIMA MOD.: 26/04/2022 --->
<!--- LISTA LOS SOLICITANTES REGISTRADOS EN EL SISTEMA DE SOLICITUDES PARA CONVOCATORIAS A COA'S--->
	
	<!--- Parámetros --->
	<cfparam name="vpCoaId" default="">
	<cfparam name="vpAcdId" default="">
	
    <cfquery name="tbSolicitudCoa" datasource="#vOrigenDatosSOLCOA#">
        SELECT *
        FROM solicitudes AS T1
        WHERE coa_id = '#vpCoaId#'
        AND solicitud_status = 6
        ORDER BY sol_apepat, sol_apemat
    </cfquery>
        
        
    <cfif #tbSolicitudCoa.RecordCount# GT 0>
        <table width="80%">
            <tr>
                <td></td>
                <td><strong>Nombre</strong></td>
                <td align="center"><strong>Agregar como <cfif #vFt# EQ 5>oponente<cfelseif #vFt# EQ 15>concursante</cfif></strong></td>
            </tr>
            <cfoutput query="tbSolicitudCoa">
                <cfquery name="tbCoaOponentes" datasource="#vOrigenDatosSAMAA#">
                    SELECT * FROM consulta_convocacoa_concursa
                    WHERE solicitud_id_coa = #solicitud_id#
                </cfquery>
                
                <cfquery name="tbAcadGana" datasource="#vOrigenDatosSAMAA#">
                    SELECT acd_curp FROM academicos
                    WHERE acd_id = #vpAcdId#
                </cfquery>                
                
                <cfif #tbCoaOponentes.Recordcount# EQ 0>
                    <tr>
                        <td width="5%"><span class="Sans9Gr"><strong>#CurrentRow#</strong></span></td>                
                        <td width="65%"><span class="Sans9Gr">#sol_apepat# <cfif #sol_apemat# NEQ ''>#sol_apemat# </cfif>#sol_nombres#</span></td>
                        <td width="30%" align="center">
                            <cfif #tbAcadGana.acd_curp# NEQ #sol_curp#>
                                <img src="#vCarpetaICONO#/agregar_15.jpg" style="border:none; cursor:pointer;" title="Agregar" onclick="fOponentesAdm('A',#solicitud_id#)">
                            <cfelse>
                                <strong class="Sans9ViNe">GANADOR COA</strong>
                            </cfif>
                            <!--- <input name="cmdSolCoaAgrega" type="button" class="botones" id="cmdSolCoaAgrega" value="  AGREGAR COMO OPONENTE  " onClick="">--->
                        </td>
                    </tr>
                </cfif>
            </cfoutput>
        </table>
    <cfelse>
        <strong>NO HAY SOLICITUDES REGISTRADAS EN EL COA</strong>
    </cfif>