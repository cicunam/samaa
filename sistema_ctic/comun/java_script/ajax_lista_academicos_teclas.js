/*  CREADO: ARAM PICHARDO */
/* EDITO: ARAM PICHARDO DURAN */
/* FECHA CREA: 11/11/2019 */
/* FECHA ULTIMA MOD.: 07/12/2021 */
/* JAVA SCRIPT PARA DETECTAR CUANDO DEJA DE TECLAR EL USUARIO Y LISTAR LAS COINCIDENCIAS DE LOS ACADÉMICOS */
/* FUNCIONES GLOBALES PARA DESPELGAR Y SELECCIONAR UN ACADÉMICO POR MEDIO DE AJAX / JQUERY */

var ctrl_v = false;
vAcadNom.addEventListener("keyup", function()
{   
    var intervalo;
    if (!e) var e = window.event;
    if (e.keyCode) codigo = e.keyCode;
    else if (e.which) codigo = e.which;
    if (ctrl_v == true) 
    {
        $('#vCuentaIntervalo').val($('#vAcadNom').val().length - 1);
        ctrl_v = false;
    }
    if ((codigo > 47 && codigo < 91) || codigo == 192 || codigo == 32 || codigo == 8)
    {
        if (codigo == 8)
        {
            if ($("#vSelAcad").val().length == 0)
                $('#lstAcad_dynamic').show();
                //document.getElementById('lstAcad_dynamic').style.display = '';
            if ($("#vSelAcad").val().length > 0)
                //alert('CON VALOR');
                $("#agrega_acdest_dynamic").html('');
                $("#vSelAcad").val('');
            if ($('#vAcadNom').val().length == 0)
            {
                $('#vCuentaIntervalo').val(0);
                $("#lstAcad_dynamic").html('');
            }
            else
            {$('#vCuentaIntervalo').val(parseInt($('#vCuentaIntervalo').val()) - 1);}
        }
        else
        {
            intervalo = setInterval(function(){ //Y vuelve a iniciar
                $('#vCuentaIntervalo').val(parseInt($('#vCuentaIntervalo').val()) + 1);
                if ($('#vAcadNom').val().length == $('#vCuentaIntervalo').val())
                    {
                        if ($('#vTipoBusquedaAcd').val() == 'SelAcdCons')
                            fBuscaAcademico();
                        if ($('#vTipoBusquedaAcd').val() == 'SelAcdSol')
                            fBuscaAcademico();
                        if ($('#vTipoBusquedaAcd').val() == 'SelAcdMov')
                            fBuscaAcademico();
                            //fListaSeleccionAcademico();
                        if ($('#vTipoBusquedaAcd').val() == 'SelAcdDgapa')
                            fBuscaAcademicoNombre();
                    }
                clearInterval(intervalo); //Limpio el intervalo
            }, 1000);
        }
    }
}, false);

$("#vAcadNom").bind('paste', function() {
    ctrl_v = true; 
});

function fBorrarParametros()
{
    if (document.getElementById('vAcadId'))
        document.getElementById('vAcadId').value = '';
    if (document.getElementById('vAcadNom'))
        document.getElementById('vAcadNom').value = '';
    if (document.getElementById('vSelAcad'))
        document.getElementById('vSelAcad').value = '';
    document.getElementById('vCuentaIntervalo').value = '0';
	   document.getElementById('lstAcad_dynamic').style.display = '';
    document.getElementById('lstAcad_dynamic').innerHTML = ''; 
}

// Obtener la lista de académicos:
function fBuscaAcademico()
{
	// Ocultar la lista si no hay datos:
	if (document.getElementById('vAcadNom').value.length == 0) 
		document.getElementById('lstAcad_dynamic').innerHTML = ''; 
	// Solo obtener la lista de académicos si hay más de 3 letras tecleadas:
	if (document.getElementById('vAcadNom').value.length <= 3) return; // && vTipoBusq == 'NAME'  (SE ELIMINO EL CÓDIGO, NO SE UTILIZA 07/12/2021)
	// Crear un objeto XmlHttpRequest:
	var xmlHttp = XmlHttpRequest();
	// Función de atención a las petición HTTP:
	xmlHttp.onreadystatechange = function(){
		if (xmlHttp.readyState == 4) {
			//alert(document.getElementById('vAcadNom').value);
			document.getElementById('lstAcad_dynamic').innerHTML = xmlHttp.responseText;
		}
	}
	// Generar una petición HTTP: (Cambié el charset de iso-8859-1 a utf-8 para que pasen las letras Ñ-ñ))
	xmlHttp.open("POST", document.getElementById('vLigaAjax').value, true);
	xmlHttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=utf-8');
	// Crear la lista de parámetros:
	parametros = "vTexto=" + encodeURIComponent(document.getElementById('vAcadNom').value);
	parametros += "&vTipoBusq=NAME";
    if (document.getElementById('vFt'))    
        parametros += "&vFt=" + encodeURIComponent(document.getElementById('vFt').value);    
	// Enviar la petición HTTP:
	xmlHttp.send(parametros);
}

 // ************ USANDO JQUERY ***************
function fBuscaAcademicoNombre()
{
	//alert($('#vAcadNom').val().length);
	if ($('#vAcadNom').val().length = 0)
	{
		$("#lstAcad_dynamic").html('');
		if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
			$("#agrega_acdest_dynamic").html('');
	}
		if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
		{vAcdActivo = 1;}
		else
		{vAcdActivo = 0;}
	//if ($('#vAcadNom').val().length <= 5) return;
	//if (event.keyCode  == '13' || event.which == '13')
		$.ajax({
			async: false,
			method: "POST",
			data: {vTexto: $('#vAcadNom').val(),vTipoBusq:"NAME",vCss:"OTRO",vpAcdActivo:vAcdActivo},
			url: $('#vUrlSelAcad').val(),
			success: function(data) {
				$("#lstAcad_dynamic").html(data);
			},
			error: function(data) {
				alert('ERROR AL DESPELGAR LA INFORMACIÓN');
				//location.reload();
			}
		});
}

//Al seleccionar al académico de los resultados que despliega el "SELECT" envía estos datos a los elementos del formulario
function fSeleccionAcademico()
{
    //alert($('#vTipoBusquedaAcd').val());
    if ($('#vTipoBusquedaAcd').val() == 'SelAcdCons' || $('#vTipoBusquedaAcd').val() == 'SelAcdMov' || $('#vTipoBusquedaAcd').val() == 'SelAcdDgapa')    
    {
        // Registrar la clave y el nombre del académico seleccionado:
        if (document.getElementById('vSelAcad'))
           { document.getElementById('vSelAcad').value = document.getElementById('lstAcad').value;}
        if(document.getElementById('vAcadId'))
            { document.getElementById('vAcadId').value = document.getElementById('lstAcad').value;}
        if(document.getElementById('vAcadNom'))
            document.getElementById('vAcadNom').value = document.getElementById('lstAcad').options[document.getElementById('lstAcad').selectedIndex].text;

	   document.getElementById('lstAcad_dynamic').innerHTML = '';
	   document.getElementById('lstAcad_dynamic').style.display = 'none';

	   //ESTA OPCIÓN PERMITE EJECUTAR UNA FUNCIÓN SÓLO EN EL MÓDULO DE /estimulos_dgapa/
	   if (window.location.pathname.indexOf("/estimulos_dgapa/") > 0)
	   {
		  $('#vCuentaIntervalo').val($('#vAcadNom').val().length)
		  fAgregaAcdEst();
	   }
    }

    if ($('#vTipoBusquedaAcd').val() == 'SelAcdSol')
    {
        var vFt = document.getElementById('vFt').value;
		/* Pasar el RFC y el nombre del academico a los controles correspondientes: */
		document.getElementById('vSelAcad').value = document.getElementById('lstAcad').value;
		document.getElementById('vAcadNom').value = document.getElementById('lstAcad').options[document.getElementById('lstAcad').selectedIndex].text;
		document.getElementById('lstAcad_dynamic').innerHTML = '';
		document.getElementById('lstAcad_dynamic').style.display = 'none';
        // Determinar si se debe mostrar la lista de plazas o el boton "Siguiente":
	   if (vFt==5 || vFt==15 || vFt==16 || vFt==17 || vFt==28 || vFt==42)
		{
			fListarPlazas();
			document.getElementById("lstPlazas_dynamic").style.display = '';
		}
		else if (vFt==23 || vFt==32)
		{
			fListarSabaticos();
			document.getElementById("lstSaba_dynamic").style.display = '';
		}
		else if (vFt==31 || vFt==35 || vFt==37)
		{
		 	document.getElementById("lstAsuntos_dynamic").style.display = '';
			fListarAsuntos(vFt);
		}
		else if (vFt==38 || vFt==39)
		{
			if (document.getElementById("vSelAcad").value == '0')
			{
				document.getElementById("cmdSiguente").style.display = '';
			}
			else
			{
				document.getElementById("lstPosdocVerifica_dynamic").style.display = '';
				fVerificaPosdoc();
			}
		}
		else
		{
			document.getElementById("cmdSiguente").style.display = '';
		}
		//fListarAsuntosDuplicados(); (SE ELIMINO EL CÓDIGO, NO SE UTILIZA 07/12/2021)
    }

}

