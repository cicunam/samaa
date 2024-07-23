<!--- CREADO: ARAM PICHARDO --->
<!--- EDITO: ARAM PICHARDO --->
<!--- FECHA CREA: 27/02/2022 --->
<!--- FECHA ÚLTIMA MOD.: 26/04/2022 --->
<!--- JAVASCRIPT PARA LAS FT's 5, 15 Y 42, referentea los COA'S --->

		<script type="text/javascript">
            // Función para iniciar AJAX
            function fOnloadPantalla()
            {
                //fDatosPlaza();
                fListaOponentes();
                fListaSolicitudesCoa();
            }            
            // Función que ejecuta ajax para desplegar a los oponentes
            function fListaOponentes()
            {
                //alert('LISTA OPONENTES: ' + $('#vIdSol').val() + ' ' + $('#pos23').val() + ' ' + $('#vFt').val());
                $.ajax({
                    async: false,
                    url: "ft_ajax/coa_lista_oponentes.cfm",
                    type:'POST',
                    data: {vpSolId: $('#vIdSol').val(), vpCoaId: $('#pos23').val(), vFt: $('#vFt').val(), vActivaCampos: $('#vActivaCampos').val()}, 
                    dataType: 'html',
                    success: function(data, textStatus) {
                        $('#oponentes_dynamic').html(data);
                    },
                    error: function(data) {
                        //alert(data);
                        alert('ERROR AL CARGAR LA RELACIÓN DE OPONENTES');
                    },
                });                
            }
            // Función que ejecuta ajax para desplegar las solicitudes registradas en una convocatoria COA
            function fListaSolicitudesCoa()
            {
                $.ajax({
                    async: false,
                    url: "ft_ajax/coa_lista_solicitudes.cfm",
                    type:'POST',
                    data: {vpCoaId: $('#pos23').val(), vFt: $('#vFt').val(), vpAcdId: $('#vIdAcad').val()},
                    dataType: 'html',
                    success: function(data, textStatus) {
                        //alert(data);
                        $('#solicitudescoa_dynamic').html(data);
                    },
                    error: function(data) {
                        alert('ERROR AL CARGAR LA RELACIÓN DE SOLICITUDES REGISTRADAS');
                        //location.reload();
                    },
                });                
            }
            // Función que ejecuta ajax para agregar solicitantes a oponentes o eliminar oponentes
            function fOponentesAdm(vTipoAdmOpon,vSolicitudId)
            {
                $.ajax({
                    async: false,
                    url: "ft_ajax/coa_adm_oponentes.cfm",
                    type:'POST',
                    data: {vpSolId: $('#vIdSol').val(), vpCoaId: $('#pos23').val(), vpTipoAdmOpon: vTipoAdmOpon, vpSolicitudId: vSolicitudId},
                    dataType: 'html',
                    success: function(data, textStatus) {
                        alert(data);
                        fOnloadPantalla();
                    },
                    error: function(data) {
                        alert('ERROR AL CARGAR LA RELACIÓN DE SOLICITUDES REGISTRADAS');
                        //location.reload();
                    },
                });
            }
		</script>            