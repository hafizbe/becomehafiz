$(document).ready =>
  # Lorsque l'on clic sur un élément de la liste du verset (Very good, good, bad ...)
  $("#surah_wrapper_ar").on('click','.dropdown-menu a', (e) =>
    verset_content = $(e.currentTarget).parent().parent().prev()
    connected = parseInt $(e.currentTarget).attr("data-connected")
    known_value = parseInt $(e.currentTarget).attr("data-action")
    current_aya= $(e.currentTarget).parent().parent().prev()
    current_aya_id = parseInt current_aya.attr("data-ayah-id")
    user_id = $("#user_id").text()
    unless connected == 0 #Utilisateur non connecté. Il sera redirigié vers l'url de la balise <a>
      if known_value > 0
        type_request = null
        if current_aya.hasClass("bad") or current_aya.hasClass("good") or current_aya.hasClass("very_good")
          type_request = "PUT"
        else
          type_request = "POST"
        nom_de_classe = verse_known(known_value)
        class_to_delete = switch_classes 'color',  verset_content.attr('class').split(" ")
        verset_content.removeClass(class_to_delete)
        verset_content.addClass(nom_de_classe)
        verset_content.parent().removeClass("open")
        $.ajax({
         dataType: "json",
         type: type_request,
         url: "/users/#{user_id}/ayahs",
         data: {
         'known_value': known_value,
         'current_aya_id' : current_aya_id
         }
         success: (data) =>
           unless data is false
            resize_surah_known data
         error: =>
           alert('Error occured');
        })
      else
        #Dans ce cas, afficher la fenetre modal
        verset_content.parent().removeClass("open")
        $("#modal-verset").html(verset_content.text())
        $("#myModal").modal('show')
      return false
  )

verse_known = (action) =>
  nom_de_class = null
  switch action
    when 1 then nom_de_class = 'bad'
    when 2 then nom_de_class = 'good'
    when 3 then nom_de_class = 'very_good'
  nom_de_class

switch_classes = (type_switch, classes_aray) =>
  retour = null
  if type_switch == 'size'
    if 'arab_small' in classes_aray
      retour = 'arab_small'
      return retour
    else if 'arab_medium' in classes_aray
      retour = 'arab_medium'
      return retour
    else if 'arab_large' in classes_aray
      retour = 'arab_large'
      return retour
    return
  else if type_switch == 'color'
    if 'good' in classes_aray
      retour = 'good'
      return  retour
    else if 'very_good' in classes_aray
      retour = 'very_good'
      return retour
    else if 'bad' in classes_aray
      retour = 'bad'
      return retour
    else if 'none_color' in classes_aray
      retour = 'none_color'
      return retour
  retour


resize_surah_known=(percentage_surah) =>
  $("#progress_current_surah .bar").css('width', percentage_surah+'%')