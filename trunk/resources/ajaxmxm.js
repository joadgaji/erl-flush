// ajaxmxm
var hilo;
function nuevoAjax(){
  var xmlhttp=false;
  try {
    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
  } catch (e) {
    try {
      xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    } catch (E) {
      xmlhttp = false;
    }
  }
 
  if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
    xmlhttp = new XMLHttpRequest();
  }
  return xmlhttp;
}
function llamar_MXM(htmlId,url){
	dostatstxt="<script language='JavaScript' type='text/javascript'>doStats('esmas');</script>";
  contenedor = document.getElementById(htmlId);
  ajax=nuevoAjax();
  ajax.open("GET",url,true);
  ajax.onreadystatechange=function() {
 	if (ajax.readyState==1){
         contenedor.innerHTML="Cargando...";
         }
         else if (ajax.readyState==4){
                   if(ajax.status==200)
                   {
                        contenedor.innerHTML=ajax.responseText+dostatstxt;
                   }
                   else if(ajax.status==404){
                            contenedor.innerHTML = "La direccion no existe";
                          }else{
                            contenedor.innerHTML = "Error: ".ajax.status;
                          }
	 }

  }
//  ajax.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  ajax.send(null);
}

function llamarMxM(htmlId,url,segundos){
	eval("llamar_MXM('"+htmlId+"','"+url+"')");
	hilo=setInterval("llamar_MXM('"+htmlId+"','"+url+"')",segundos*1000);
}

function show_previo(){
	clearInterval(hilo);
	document.getElementById('tab_min').style.display='none';
	document.getElementById('alineacion').style.display='none';
	document.getElementById('minxmin').style.display='none';
	document.getElementById('previo').style.display='block';	
	document.getElementById('tab_previo').className = 'active';
	document.getElementById('tab_alineacion').className = '';
	document.getElementById('tab_minxmin').className = 'onAirTab';
}
function show_alineacion(idPartido){
	clearInterval(hilo);	
	document.getElementById('tab_min').style.display='none';
	document.getElementById('previo').style.display='none';
	document.getElementById('minxmin').style.display='none';
	document.getElementById('alineacion').style.display='block';	
	document.getElementById('tab_previo').className = '';
	document.getElementById('tab_alineacion').className = 'active';
	document.getElementById('tab_minxmin').className = 'onAirTab';
llamarMxM('alineacion','http://www2.esmas.com/ajxredir.php?url=http://mxm.esmas.com/futbol/feeds/minxmin.php&id_juego='+idPartido,60);
	
	
}
function show_minxmin(idPartido){
	clearInterval(hilo);	
	document.getElementById('tab_min').style.display='block';
	document.getElementById('alineacion').style.display='none';
	document.getElementById('previo').style.display='none';
	document.getElementById('minxmin').style.display='block';	
	document.getElementById('tab_previo').className = '';
	document.getElementById('tab_alineacion').className = '';
	document.getElementById('tab_minxmin').className = 'onAirTab active';
llamarMxM('minxmin','http://www2.esmas.com/ajxredir.php?url=http://mxm.esmas.com/futbol/feeds/comentarios.php&id_juego='+idPartido,60);

}
function show_fotogal(){
	document.getElementById('fotogal').style.display='block';
	document.getElementById('fotogalmasvis').style.display='none';
	document.getElementById('fotogalmascomen').style.display='none';	
	document.getElementById('tab_fotogal').className = 'First galleryTitle';
	document.getElementById('tab_fotogalmasvis').className = '';
	document.getElementById('tab_fotogalmascomen').className = '';	
}
function show_fotogalmasvis(){
	document.getElementById('fotogal').style.display='none';
	document.getElementById('fotogalmasvis').style.display='block';
	document.getElementById('fotogalmascomen').style.display='none';	
	document.getElementById('tab_fotogal').className = '';
	document.getElementById('tab_fotogalmasvis').className = 'First galleryTitle';
	document.getElementById('tab_fotogalmascomen').className = '';		
}
function show_fotogalmascomen(){
	document.getElementById('fotogal').style.display='none';
	document.getElementById('fotogalmasvis').style.display='none';
	document.getElementById('fotogalmascomen').style.display='block';	
	document.getElementById('tab_fotogal').className = '';
	document.getElementById('tab_fotogalmasvis').className = '';
	document.getElementById('tab_fotogalmascomen').className = 'First galleryTitle';	
}