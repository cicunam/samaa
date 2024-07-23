				<cfoutput>
					<table class="MenuEncabezado" cellspacing="0" cellpadding="0" style="margin-left:15px; border:none;">	
                        <tr>
                            <td><div id="mPa" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../personal/academico_personal.cfm?vAcadId=#vAcadId#');">Información General</div></td>
                            <td><div id="mPaFa" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../formacion_academica/consulta_formacion.cfm?vAcadId=#vAcadId#');">Formaci&oacute;n</div></td>
                            <td><div id="mPaMov" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../movimientos/consulta_movimientos.cfm?vAcadId=#vAcadId#');">Movimientos</div></td>
                            <!-- SÓLO PARA ACADEMICOS CON CONTRATO -->
                            <cfif #tbAcademico.con_clave# GTE 1 AND #tbAcademico.con_clave# LTE 4>
                                <td><div id="mPaIa" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../informe_anual/consulta_informes.cfm?vAcadId=#vAcadId#');">Informes anuales</div></td>
<!--- 
                                <td><div id="mPaC" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../cargos/consulta_cargos.cfm?vAcadId=#vAcadId#');">Cargos</div></td>
                                <td><div id="mPaE" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../estimulos/consulta_estimulos.cfm?vAcadId=#vAcadId#');">Est&iacute;mulos DGAPA</div></td>
--->
                            </cfif>
							<cfif #tbAcademico.sni_exp# GT 0>
								<td><div id="mPaSni" class="MenuEncabezadoBoton" onClick="parent.frames[2].location.replace('../sni/consulta_sni.cfm?vAcadId=#vAcadId#');">&nbsp;&nbsp;SNI&nbsp;&nbsp;</div></td>
							</cfif>
                        </tr>
					</table>
                    <!-- Titulo del submódulo -->
                    <table style="width:100%;  margin-left:15px; border:none;" cellspacing="0" cellpadding="1">	
                        <tr bgcolor="##FAFAFA">
                            <td height="20" colspan="5"><div align="center" class="Sans12ViNe">#vTituloModulo#</div></td>
                        </tr>
                    </table>                    
				</cfoutput>