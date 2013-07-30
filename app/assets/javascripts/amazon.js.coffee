#Transforme 1 en 001
convertSourate = (num) =>
  num = num.toString()
  if num .length == 1
    num = "00#{num}"
  else if num.length == 2
    num = "0#{num}"

#Transforme 1 en 01
convertFichier = (num) =>
  num = num.toString();
  if num.length == 1
    num = "0"+num
  num

# Lit le fichier mp3 en s'aidant du fichier xml.
play_fichier = (url_fichier, id, fichier_temp, nb_fichier, num_sourate, recitateur, tab_duration, current_marker) =>
  selector.next()
  current_marker = parseInt current_marker
  fichier_mp3   = url_fichier[0]
  fichier_xml   = url_fichier[1]
  tab_duration  =  get_time_ayah fichier_xml
  if current_marker == 0
    state_auto_play = true
  else
    state_auto_play = false
  soundManager.createSound({
     id: id
     url: fichier_mp3,
     stream: true
     autoLoad: true
     autoPlay: state_auto_play
     whileloading : =>
       total = s.bytesTotal
       rapport = (s.bytesLoaded/total) *100
       etat = ""
       if rapport <= 33
        etat =  "info progress-striped"
       else if rapport <= 66
        etat = "success progress-striped"
       else if rapport <= 99
              etat = "warning progress-striped"
         else if rapport == 100
            etat = "danger"
       classe = $("#surah_option_wrapper .progress").attr("class").split(" ")[1]
       $("#surah_option_wrapper .progress").removeClass(classe)
       $("#surah_option_wrapper .progress").addClass("progress-"+etat)
       $("#surah_option_wrapper .progress .bar").css("width",rapport+"%")
       return
     onload : =>
       if s.playState == 0
         s.play({
          position:  convert_to_milliseconde tab_duration[current_marker]
          multiShotEvents: true
          onfinish : =>
           if (fichier_temp + 1) <= nb_fichier
             console.log "Terminé !"
             url_fichier = get_url_fichier convertSourate(num_sourate) , recitateur, convertFichier fichier_temp + 1
             fichier_xml   = url_fichier[1]
             play_fichier url_fichier, id+1 ,fichier_temp + 1, nb_fichier, num_sourate, recitateur, tab_duration, 0
             return

          })
         return
     whileplaying : =>
       console.log "#{s.position} <  #{convert_to_milliseconde tab_duration[current_marker + 1]} ?"
       if s.position > convert_to_milliseconde(tab_duration[current_marker + 1])
         old_marker = current_marker
         current_marker++

         if (old_marker != 0 || fichier_temp !=1) || num_sourate == "1"
           selector.next()
           console.log(s.position)
       return
     onfinish : =>
       if (fichier_temp + 1) <= nb_fichier
         console.log "Terminé !"
         url_fichier = get_url_fichier convertSourate(num_sourate) , recitateur, convertFichier fichier_temp + 1
         fichier_xml   = url_fichier[1]
         play_fichier url_fichier, id+1 ,fichier_temp + 1, nb_fichier, num_sourate, recitateur, tab_duration, 0
         return

  })
  s = soundManager.getSoundById id
  console.log s

  #s.play({
         #from:  convert_to_milliseconde tab_duration[current_marker]
         #multiShotEvents: true

         #})
  return

# Ouverture d'une récitation
play_recitation = (num_sourate, recitateur, from_verset, to_verset) =>

  ruku_detail = get_ruku_detail()

  #Récupération de la vlist pour la sourate
  vlist = get_vlist ruku_detail, num_sourate
  nb_fichier = vlist.length
  file_of_verset = get_file_for_verset vlist, from_verset
  marker = get_the_marker from_verset, file_of_verset, vlist
  console.log "Marker => #{marker}"
  url_fichier = get_url_fichier convertSourate(num_sourate) , recitateur, convertFichier file_of_verset
  fichier_xml = url_fichier[1]
  tab_duration  =  get_time_ayah fichier_xml
  play_fichier url_fichier,file_of_verset,file_of_verset, nb_fichier, num_sourate, recitateur, tab_duration, marker
  return false

#Récupère le nb de fichier pour une sourate
get_nb_fichiers = (docXml, num_sourate) =>
  doc = docXml.getElementsByTagName "marker"
  for i in [0...doc.length]
    if doc[i].getAttribute("name") == num_sourate
      vlist = doc[i].getAttribute("vlist")
      break;
  nb_fichiers = vlist.split ","
  nb_fichiers.length

#Récupère la vlist d'une sourate
get_vlist =  (docXml, num_sourate) =>
  doc = docXml.getElementsByTagName "marker"
  for i in [0...doc.length]
    if doc[i].getAttribute("name") == num_sourate
      vlist = doc[i].getAttribute("vlist")
      break;
  vlist.split ","

# Détermine dans quel fichier se trouve un verset
get_file_for_verset = (vlist, from_verset) =>
  i = 1
  from_verset = parseInt from_verset
  result = 1
  unless from_verset == 1
    for a in vlist
      a = parseInt a
      if from_verset == a
        result = i
        break
      else
        if from_verset < a
          result = i - 1
          break
        else
          if i == vlist.length
            result = i
            break
      i++
  result

#Récupère le marker associé au début du verset (Exemple : Le verset 24 correspond au marker 4 du fichier xml)
get_the_marker = (from_verset, file_of_verset, vlist) =>
   marker = 0
   unless parseInt(from_verset) == 1
     if file_of_verset == 1
       marker = from_verset
     else
       marker = from_verset - vlist[file_of_verset-1]

   marker

#Récupère le fichier xml global
get_ruku_detail =() =>
  url_detail  = 'http://s3.amazonaws.com/hafizbe/RukuDetail.xml'
  docXml = loadXMLDOC url_detail


#Charge un fichier Xml en ajax
loadXMLDOC = (xml_url) =>
  if window.XMLHttpRequest
    xmlhttp=new XMLHttpRequest();
  else
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  xmlhttp.open("GET",xml_url,false);
  xmlhttp.send();
  xmlDoc=xmlhttp.responseXML;

#Retourne dans un tableau tous les markers
get_time_ayah = (xml_url) =>
  tableau = []
  xmlDoc 	= 	loadXMLDOC xml_url
  versets	=	xmlDoc.getElementsByTagName("marker");
  for i in [0...versets.length]
    tableau[i] = versets[i].attributes.getNamedItem("time").nodeValue

  tableau
#Converti un temps en milliseconde
convert_to_milliseconde = (time) =>
  tab 		  = time.split(':')
  heures 		= parseFloat(tab[0]) * 3600000
  minutes 	= parseFloat(tab[1]) * 60000
  secondes 	= parseFloat(tab[2]) * 1000
  heures + minutes + secondes

#Return url xml et mp3 pour une sourate, en foncttion du récitateur et du nombre de fichier (01, 02 etc..)
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

selector =
  current_aya : $("#lstFromVersets").val()
  state : "stop"
  next : ->
    $(".verset").removeClass("ayah_playing")
    verset =  $(".break:contains('("+this.current_aya+")')").prev()
    verset.addClass("ayah_playing",{duration:500})
    verset_offset =verset.offset().top
    $('body,html').animate(
     {scrollTop: (verset_offset - 5)+"px"}, {easing: "swing", duration: 1600}
    )
    this.current_aya = parseInt(this.current_aya) + 1
    return

#Methode qui regénère la liste déroulante from_verset et to_verset
regenerate_list_from_to = (option_from_max, option_to_max) =>

  $("#lstFromVersets").find('option').remove()
  for i in [1..option_to_max.max]
    if i == parseInt option_from_max
      $("#lstFromVersets").append('<option selected="selected" value="'+i+'">'+i+'</option>')
    else
      $("#lstFromVersets").append('<option value="'+i+'">'+i+'</option>')

  $("#lstToVersets").find('option').remove()
  for i in [1..option_to_max.max]
    if i == parseInt option_to_max.max_selected
      $("#lstToVersets").append('<option selected="selected" value="'+i+'">'+i+'</option>')
    else
      $("#lstToVersets").append('<option value="'+i+'">'+i+'</option>')


$(document).ready =>
  #Clic sur play
  $("#lecteur_play").click =>
    selector.current_aya = $("#lstFromVersets").val()

    surah_id = $("#lstSurahs").val()
    recitator_name = $("#lstRecitators").val()
    from_verset =  $("#lstFromVersets").val()
    to_verset =  $("#lstToVersets").val()
    play_recitation surah_id, recitator_name, from_verset, to_verset
    return false

  #Validation du formulaire
  $("#lstSurahsFrm").submit =>
    lstSurahs = $("#lstSurahs").val()
    lstRecitators = $("#lstRecitators").val()
    lstFromVersets = $("#lstFromVersets").val()
    lstToVersets = $("#lstToVersets").val()
    lstToVersetsCheck = $("#lstToVersetsCheck").val()
    $("#surah_wrapper").hide()

    $("#surah_wrapper").empty()

    $.ajax({
     dataType: "json",
     type: "POST",
     url: "/surahs",
     data: {
      'lstSurahs': lstSurahs,
      'lstRecitators': lstRecitators,
      'lstFromVersets' : lstFromVersets,
      'lstToVersets' : lstToVersets,
      'lstToVersetsCheck' : lstToVersetsCheck
     }
     success:  (data) =>
       regenerate_list_from_to data.from_verset_minimum,data.from_verset_maximum
       for i in [0...data.versets.length]
        $("#surah_wrapper").append('<span class="verset">'+data.versets[i].ayahText+'</span>')
        $("#surah_wrapper").append('<span class="break">('+data.versets[i].ayah_id+')</span>')
       $("#surah_wrapper").fadeIn(1000)

     error: =>
       alert('Error occured');
    })

    return false
  return