<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 13/06/2016 --->
<!--- FECHA ÚLTIMA MOD.: 12/01/2023 --->
<!--- MÓDULO GENERAL PARA ENVIAR ARCHIVOS AL SERVIDOR --->

				<cfif #CGI.SERVER_PORT# EQ '31221'>
                    <cfset vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa/aram'>
                    <cfset vCarpetaRaizLogica = '/samaa/aram'>
                <cfelse>
                    <cfset vCarpetaRaiz = 'http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/samaa'>
                    <cfset vCarpetaRaizLogica = '/samaa'>
                </cfif>
				

				<!--- CARPETA VIRTUAL PARE PODER ACCESAR A LOS ARCHIVOS --->
                <cfset vWebCAAA = '#vCarpetaRaiz#/archivos_ctic/archivos_pleno/asuntos/'>
                <cfset vWebEntidad = '#vCarpetaRaiz#/archivos_ctic/archivos_entidades/'>
                <cfset vWebAcademicos = '#vCarpetaRaiz#/archivos_ctic/archivos_academicos/'>
                <cfset vWebSesionHistoria = '#vCarpetaRaiz#/archivos_ctic/archivos_sesion/'>
                <cfset vWebSesionOtros = '#vCarpetaRaiz#/archivos_ctic/archivos_sesion_otros/'>
                <cfset vWebCargosAA = '#vCarpetaRaiz#/archivos_ctic/archivos_cargos_acad_admin/'>
                <cfset vWebInforme = '#vCarpetaRaiz#/archivos_ctic/archivos_academicos_inf_anual/'>
                <cfset vWebOficios = '#vCarpetaRaiz#/archivos_ctic/archivos_oficios/'> <!--- ALTA 15/12/2021 --->
                <cfset vWebGradoAcad = '#vCarpetaRaiz#/archivos_samaa/archivos_academicos_gradoacad/'> <!--- ALTA 11/01/2023 --->                    
                <!--- RUTA DE LOS PDF QUE MANEJA EL SISTEMA --->
				<cfif #CGI.SERVER_PORT# EQ '31221'>    
                    <cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
                <cfelse>
                    <cfset vCarpetaRaizArchivos = 'E:\archivos_samaa'>
                </cfif>
                <cfset vCarpetaCAAA = '#vCarpetaRaizArchivos#\archivos_pleno\asuntos\'>
                <cfset vCarpetaEntidad = '#vCarpetaRaizArchivos#\archivos_entidades\'>
                <cfset vCarpetaAcademicos = '#vCarpetaRaizArchivos#\archivos_academicos\'>
                <cfset vCarpetaSesionHistoria = '#vCarpetaRaizArchivos#\archivos_sesion\'>
                <cfset vCarpetaSesionOtros = '#vCarpetaRaizArchivos#\archivos_sesion_otros\'>
                <cfset vCarpetaCargosAA = '#vCarpetaRaizArchivos#\archivos_cargos_acad_admin\'>
                <cfset vCarpetaInforme = '#vCarpetaRaizArchivos#\archivos_academicos_inf_anual\'>
                <cfset vCarpetaOficios = '#vCarpetaRaizArchivos#\archivos_oficios\'> <!--- ALTA 15/12/2021 --->
                <cfset vCarpetaGradoAcad = '#vCarpetaRaizArchivos#\archivos_academicos_gradoacad\'> <!--- ALTA 11/01/2023 --->                        