do_nothing = () =>
  return true


convertSourate = (num) =>
  num = num.toString()
  if num .length == 1
    num = "00#{num}"
  else if num.length == 2
    num = "0#{num}"

convertFichier = (num) =>
  num = num.toString();
  if num.length == 1
    num = "0"+num
  num

play_fichier = (url_fichier, a, fichier_temp, nb_fichier, num_sourate, recitateur) =>
  flag = 1
  s = soundManager.getSoundById a
  if !s
    soundManager.createSound({
     id: a,
     url: url_fichier
    })
  s = soundManager.getSoundById a
  s.play({
   multiShotEvents: true
   whileplaying : =>
     laPosition = s.position
     console.log laPosition
     return
   onfinish : =>
     if (fichier_temp + 1) <= nb_fichier
       url_fichier = get_url_fichier convertSourate(num_sourate) , recitateur, convertFichier fichier_temp + 1
       play_fichier url_fichier[0],convertSourate(fichier_temp + 1),fichier_temp + 1, nb_fichier, num_sourate, recitateur
     return
  })

  return


play_sourate = (numSourate, recitateur) =>
  nb_fichier = get_nb_fichiers numSourate
  url_fichier = get_url_fichier convertSourate(numSourate) , recitateur, convertFichier 1
  play_fichier url_fichier[0],convertSourate(1),1, nb_fichier, numSourate, recitateur
  return false

get_nb_fichiers = (num_sourate) =>
  url_detail  = "https://s3.amazonaws.com/hafizbe/RukuDetail.xml"
  docXml = loadXMLDOC url_detail
  doc = docXml.getElementsByTagName "marker"
  for i in [0...doc.length]
    if doc[i].getAttribute("name") == num_sourate
      vlist = doc[i].getAttribute("vlist")
      break;
  nb_fichiers = vlist.split ","
  nb_fichiers.length


loadXMLDOC = (xml_url) =>
  if window.XMLHttpRequest
    xmlhttp=new XMLHttpRequest();
  else
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  xmlhttp.open("GET",xml_url,false);
  xmlhttp.send();
  xmlDoc=xmlhttp.responseXML;

get_time_ayah = (xml_url) =>
  tableau = []
  xmlDoc 	= 	loadXMLDOC xml_url
  versets	=	xmlDoc.getElementsByTagName("marker");

  for i in [0...tableau.length]
    tableau[i] = versets[i].attributes.getNamedItem("time").nodeValue

  tableau.length;

convert_to_milliseconde = (time) =>
  tab 		  = time.split(':')
  heures 		= parseFloat(tab[0]) * 3600000
  minutes 	= parseFloat(tab[1]) * 60000
  secondes 	= parseFloat(tab[2]) * 1000
  heures + minutes + secondes

get_url_fichier = (numSourate, recitateur, numero_fichier) =>
  surah = new Array(2)

  $.ajax({
     type: "GET",
     url: "/api/v1/get_url_amazon?recitator="+recitateur+"&surah="+numSourate+"&num_fichier="+numero_fichier ,
     dataType: "JSON",
     async: false,
     success:  (data) =>
       surah[0] = data[0].scheme+"://"+data[0].host+data[0].path+"?"+data[0].query
       surah[1] = data[1].scheme+"://"+data[1].host+data[1].path+"?"+data[1].query
       return
     error: =>
       alert('Error occured');
  })
  return surah

$(document).ready =>
    $("#lecteur_play").click =>
      surah_id = $("#lstSurahs").val();
      recitator_name = $("#lstRecitators").val();
      play_sourate(surah_id, recitator_name);

      return false
    return
