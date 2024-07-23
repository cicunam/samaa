<!--- CREADO: ARAM PICHARDO DURÁN --->
<!--- EDITO: ARAM PICHARDO DURÁN --->
<!--- FECHA CREA: 11/10/2017 --->
<!--- FECHA ÚLTIMA MOD.: 11/10/2017 --->
<!--- CÓDIGO PARA EL ENVÍO DE CORREO ELECTRÓNICO DE COMENTARIOS Y SUGERENCIAS --->

<cfif isDefined('vComentarioTexto') AND Len(#vComentarioTexto#) GT 0>

    <cfmail type="html" to="samaa@cic.unam.mx" cc="aramp@unam.mx" from="samaa@cic.unam.mx" subject="Comentarios/sugerencias SAMAA" server="correo.cic.unam.mx" username="samaa" password="QQQwww123" spoolenable="yes">
        Estimado(a) administrador(a) del SAMAA:<br>
        <br>
        Por este medio le notifico que se recibido un comentario o sugenrencia:
        <br><br>
        Nombre: #vComentarioNombre#
        <br>
        Correo electr&oacute;nico: #vComentarioCorreo#
        <br>
        Comentario / sugerencia: <br>
        #vComentarioTexto#
        <br><br>
        Sin m&aacute;s por el momento, reciban un cordial saludo.
    </cfmail>

</cfif>
