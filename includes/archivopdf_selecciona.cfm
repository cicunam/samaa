<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 12/01/2023 --->
<!--- MÓDULO GENERAL PARA LA SELECCIÓN DE ARCHIVOS PARA ENVIAR AL SAMAA --->

<cfparam name="vpModuloConsulta" default="">
<cfparam name="vpAcdId" default="">
<cfparam name="vpNumRegistro" default="">
<cfparam name="vpSsnIdArchivo" default="">
<cfparam name="vpDepClave" default="">
<cfparam name="vpSolStatus" default="">
<cfparam name="vpUsuarioId" default="0">
    <script language="JavaScript" type="text/JavaScript">
        $(function() {
           $('#cmdEnvia_pdf').click(function(){
                if (document.getElementById('selecciona_pdf').value == '')
                {alert('No se ha seleccionado el archivo');}
                else
                {
                    $.ajax({
                        url: "<cfoutput>#vCarpetaINCLUDE#</cfoutput>/archivopdf_carga.cfm",
                        type:'POST',
                        async: false,
                        data: new FormData($('#formEnviaArchivo')[0]),
                        processData: false,
                        contentType: false,
                        success: function(data) {
                            alert(data);
                            //alert('EL ARCHIVO SE CARGO CORRECTAMENTE');
                            location.reload();
                        },
                        error: function(data) {
                            alert('ERROR AL CARGAR EL ARCHIVO');
                            location.reload();
                        },
                    });
                }
            });
        });
    </script>

    <cfform name="formEnviaArchivo" id="formEnviaArchivo">
        <table width="100%" border="0" class="cuadros">
            <tr>
                <td>
                    <span class="Sans10NeNe">Seleccione el archivo a enviar</span>
                </td>
            </tr>
            <tr>
                <td><cfinput type="file" name="selecciona_pdf" id="selecciona_pdf" class="datos" size="75"></td>
            </tr>
            <tr>
                <td align="center">
                    <div style="width:50%">
                        <cfif #CGI.SERVER_PORT# EQ '31221'>
                            <cfset vTipoInput = 'text'>
                        <cfelseif #CGI.SERVER_PORT# EQ '31220'>
                            <cfset vTipoInput = 'hidden'>
                        </cfif>
                        <cfinput type="button" name="cmdEnvia_pdf" id="cmdEnvia_pdf" value="Enviar archivo" class="botones">
                        <cfinput type="#vTipoInput#" id="vModuloConsulta" name="vModuloConsulta" value="#vpModuloConsulta#">
                        <cfinput type="#vTipoInput#" id="vAcdId" name="vAcdId" value="#vpAcdId#">
                        <cfinput type="#vTipoInput#" id="vNumRegistro" name="vNumRegistro" value="#vpNumRegistro#">
                        <cfinput type="#vTipoInput#" id="vSsnIdArchivo" name="vSsnIdArchivo" value="#vpSsnIdArchivo#">
                        <cfinput type="#vTipoInput#" id="vDepClave" name="vDepClave" value="#vpDepClave#">
                        <cfinput type="#vTipoInput#" id="vSolStatus" name="vSolStatus" value="#vpSolStatus#">
                        <cfinput type="#vTipoInput#" id="vUsuarioId" name="vUsuarioId" value="#Session.sUsuarioId#"><!--- vpUsuarioId --->
                        <cfinput type="#vTipoInput#" id="vCarpetaINCLUDE" name="vCarpetaINCLUDE" value="#vCarpetaINCLUDE#">
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <hr />
                    <p><span class="Sans10NeNe">Recuerde que los archivos deben ser enviados con las siguientes caracter&iacute;zticas:</span><br />
                    <br>
                    <span class="Sans10NeNe">Formato: </span><span class="Sans10Ne">Adobe Acrobat (PDF)</span><br />
                    <span class="Sans10NeNe">Tipo de salida: </span><span class="Sans10Ne">Blanco y negro</span><br />
                    <span class="Sans10NeNe">Resoluci&oacute;n: </span><span class="Sans10Ne">300 dpi</span></p>
                </td>
            </tr>
        </table>
    </cfform>
