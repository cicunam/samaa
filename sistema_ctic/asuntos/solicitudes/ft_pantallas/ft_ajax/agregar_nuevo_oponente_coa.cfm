<!--- Obtener datos del catálogo de grados (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctGrado" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_grados 
	ORDER BY grado_clave ASC
</cfquery>

<!--- Llena el catálogo de nacionalidad (CATÁLOGOS GENERALES MYSQL) --->
<cfquery name="ctPais" datasource="#vOrigenDatosCATALOGOS#">
	SELECT * FROM catalogo_paises
	ORDER BY pais_nombre
</cfquery>

<html>
	<head>
		<cfoutput>
			<title>SAMAA - FT-CTIC-<!---#vFt# ---></title>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<link href="#vCarpetaCSS#/formularios.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/general.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/fuentes.css" rel="stylesheet" type="text/css">
			<link href="#vCarpetaCSS#/jquery/jquery-ui-1.8.12.custom.css" rel="stylesheet" type="text/css">
		</cfoutput>
        <cfinclude template="../ft_scripts_valida.cfm">
		<script type="text/javascript">
			<!-- CREADO: ARAM PICHARDO -->
			<!-- EDITO: JOSÉ ANTONIO ESTEVA -->
			<!-- FECHA: 27/08/2009 -->
			<!-- FUNCION QUE VALIDA LOS CAMPOS DE UN NUEVO ACADÉMICO -->
		
			function fValidaCamposNuevoAcademico()
			{
				// Quitar color rojo de los controles:
				document.getElementById("frmPaterno").style.backgroundColor = '#FFFFFF';
				document.getElementById("frmMaterno").style.backgroundColor = '#FFFFFF';
				document.getElementById("frmNombres").style.backgroundColor = '#FFFFFF';
				document.getElementById("frmNacionalidad").style.backgroundColor = '#FFFFFF';
				// Validaciones:	
				var vSumaError = '';
				if (document.getElementById('frmPaterno').value == '' && document.getElementById('frmMaterno').value == '' && document.getElementById('frmNombres').value == '')
				{
					document.getElementById("frmPaterno").style.backgroundColor = '#FC8C8B';
					document.getElementById("frmMaterno").style.backgroundColor = '#FC8C8B';
					document.getElementById("frmNombres").style.backgroundColor = '#FC8C8B';
					vSumaError += 'Debe indicar el APELLIDO PATERNO, MATERNO o NOMBRES del académico.\n';
				}
				if (document.getElementById('frmNacionalidad').value == '')
				{
					document.getElementById("frmNacionalidad").style.backgroundColor = '#FC8C8B';
					vSumaError += 'Debe indicar la NACIONALIDAD del académico.\n';
				}
				if (!document.getElementById('frmSexoF').checked && !document.getElementById('frmSexoM').checked)
				{
					 vSumaError += 'Debe indicar el SEXO del académico.\n';
				}
				// Realizar la acción correspondeitne:			
				if (vSumaError.length > 0)
				{	
					alert(vSumaError);
					return false;
				}	
				else
				{
					document.getElementById('vConvocatoria').click();
//					fAgregarOponente('INSERTA', 0);
//					return true;
				}
			}
		</script>
		<script language="JavaScript" type="text/JavaScript">
            $(function() {
               $('#vConvocatoria').click(function(){
					$.ajax({
						url: "ft_ajax/lista_oponentes.cfm",
						type:'POST',
						async: false,
						data: new FormData($('#frmNuevoOponente')[0]),
						processData: false,
						contentType: false,
						success: function(data) {
							window.self.fAgregarOponente('CONSULTA', 0);
							alert('EL OPONENTE SE AGRAGÓ CORRECTAMENTE');
		                    $('#nuevooponente_jquery').dialog('close');
						},
						error: function(data) {
							alert('ERROR AL AGREGAR EL OPONENTE');//'ERROR AL AGREGAR EL OPONENTE'
		                    $('#nuevooponente_jquery').dialog('close');
//							location.reload();
						},
					});
				});
            });
        </script>        
	</head>
	<body>
        <cfform name="frmNuevoOponente">
            <div align="center">
                <table width="100%" border="0">
                    <tr>
                        <td width="30%"><span class="Sans9GrNe">Apellido paterno</span></td>
                        <td width="70%"><cfinput id="frmPaterno" name="frmPaterno" type="text" class="Datos" size="50" maxlength="60"></td>
                    </tr>
                    <tr>
                        <td><span class="Sans9GrNe">Apellido materno</span></td>
                        <td><cfinput id="frmMaterno" name="frmMaterno" type="text" class="Datos" size="50" maxlength="60"></td>
                    </tr>
                    <tr>
                        <td><span class="Sans9GrNe">Nombre(s)</span></td>
                        <td><cfinput id="frmNombres" name="frmNombres" type="text" class="Datos" size="50" maxlength="60"></td>
                    </tr>
                    <tr>
                        <td><span class="Sans9GrNe">Grado</span></td>
                        <td>
                            <cfselect name="frmGrado" id="frmGrado" class="datos" query="ctGrado" queryPosition="below" display="grado_descrip" value="grado_clave">
                                <option value="">SELECCIONE</option>
                            </cfselect>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="Sans9GrNe">Sexo</span></td>
                        <td>
                            <cfinput id="frmSexoF" name="frmSexo" type="radio" value="F">
                            <span class="Sans9ViNe">Femenino</span>
                            <cfinput id="frmSexoM" name="frmSexo" type="radio" value="M">
                            <span class="Sans9ViNe">Masculino</span>
                        </td>
                    </tr>
                    <tr>
                        <td><span class="Sans9GrNe">Nacionalidad</span></td>
                        <td>
                            <cfselect id="frmNacionalidad" name="frmNacionalidad" class="datos" query="ctPais" value="pais_clave" display="pais_nacionalidad" queryPosition="below">
                                <option value="">SELECCIONE</option>
                            </cfselect>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <div align="center" style="width:30%">
                                <input type="button" id="cmdAgregaOponente" value=" AGREGAR " class="botones" onClick="if (fValidaCamposNuevoAcademico());">

                                <cfinput type="hidden" name="vConvocatoria" id="vConvocatoria" value="#vConvocatoria#">
                                <cfinput type="hidden" name="vFt" id="vFt" value="#vFt#">
                                <cfinput type="hidden" name="vIdSol" id="vIdSol" value="#vIdSol#">
                                <cfinput type="hidden" name="vComandoDestino" id="vComandoDestino" value="INSERTA">
                                <cfinput type="hidden" name="selOponente" id="selOponente" value="NUEVO">                                
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </cfform>
    </body>
</html>
