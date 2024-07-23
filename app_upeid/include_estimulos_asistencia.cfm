<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 13/02/2018 --->
<!--- FECHA ÚLTIMA MOD.: 13/02/2018 --->
<!--- LISTA LOS DOCUMENTOS QUE INCLUYEN LAS LISTAS AL ESTÍMULO POR ASISTENCA --->

    <table id="tbListaDatos" class="table table-striped table-hover">
        <thead>
            <tr class="header">
                <th style="width:95%;">Proyecto</th>
                <th style="width:5%;" align="center">PDF</th>                                
            </tr>
        </thead>
        <tbody>
            <!-- Datos -->
            <cfoutput query="ctDependencia">
                <!--- Crea variable de archivo de solicitud --->
                <cfset vArchivoPdf = '#dep_clave#_#Session.sSesion#.pdf'>
                <cfset vArchivoAsuntoPdf = '#vCarpetaCEUPEID#/estimulos_asistencia/#vArchivoPdf#'>
                <cfset vArchivoAsuntoPdfWeb = '#vWebCEUPEID#/estimulos_asistencia/#vArchivoPdf#'>
                <cfif FileExists(#vArchivoAsuntoPdf#)>
                    <tr>
                        <td><cfif CGI.SERVER_PORT IS "31221">#dep_clave# </cfif>#dep_nombre#</td>
                        <!-- PDF -->
                        <td align="center">
                            <a href="#vArchivoAsuntoPdfWeb#" target="winPdf"><span class="fa fa-file-pdf-o" style="cursor:pointer;" title="Abrir archivo"></span></a>
                        </td>
                    </tr>
                </cfif>
            </cfoutput>
        </tbody>
    </table>
