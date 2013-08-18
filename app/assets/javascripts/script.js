function convertSourate(num){
    num = num.toString();
    if(num.length == 1)
        num = "00"+num
    else if (num.length == 2)
    {
        num = "0"+num
    }
    return num;
}

function convertFichier(num){
    num = num.toString();
    if(num.length == 1)
        num = "0"+num
    return num;
}

function playSourate(numSourate, recitateur)
{
    nb_fichier = get_nb_fichiers(numSourate);

    for(i = 1 ; i <= nb_fichier ; i ++)
    {
        url_fichier = get_url_fichier(convertSourate(numSourate), recitateur,convertFichier(i));

        play_fichier(url_fichier[0],convertSourate(i));
    }

    return false

}

function get_nb_fichiers(numSourate)
{
    url_detail  = "https://s3.amazonaws.com/hafizbe/RukuDetail.xml"
    docXml = loadXMLDoc(url_detail);
    doc = docXml.getElementsByTagName("marker");
    for(i = 0; i < doc.length ; i ++){
        if(doc[i].getAttribute("name") == numSourate){
            vlist = doc[i].getAttribute("vlist")
            break;
        }
    }
    nb_fichier = vlist.split(",");
    return nb_fichier.length
}

function get_url_fichier(numSourate, recitateur, numero_fichier){
    var surah = new Array(2);


    $.ajax({
        type: "GET",
        url: "/api/v1/get_url_amazon?recitator="+recitateur+"&surah="+numSourate+"&num_fichier="+numero_fichier ,
        dataType: "JSON",
        async: false,
        success: function(data) {
            surah[0] = data[0].scheme +"://"+data[0].host+data[0].path+"?"+data[0].query
            surah[1] = data[1].scheme +"://"+data[1].host+data[1].path+"?"+data[1].query
        },
        error: function() {
            alert('Error occured');
        }
    });

    return surah;
}

/*function play_fichier(url_fichier, a)
{
    var s = soundManager.getSoundById(a.toString());
    if (!s) {
        soundManager.createSound({
            id: a,
            url: url_fichier,
            whileplaying : function() {
                console.log(this.position);
            },
            onfinish: function() {

            }
        });
    }
    soundManager.play(a)


}    */

function seekAndPlay(soundID, soundPosition) {

    var s = soundManager.getSoundById(soundID.toString());

    if (!s) {
        return false;
    }

    if (s.readyState === 0) { // hasn't started loading yet...

        // load the whole sound, and play when it's done
        s.load({
            onload: function() {
                this.play({
                    position: soundPosition
                }),
                    active_surah(1);
            }

        });

    } else if (s.readyState === 3) {
        s.play({
            position: soundPosition
        });
    }
}

function loadXMLDoc(XMLname)
{
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp=new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
        xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.open("GET",XMLname,false);
    xmlhttp.send();
    xmlDoc=xmlhttp.responseXML;

    return xmlDoc;
}



// Récupère un fichier XML et retourne les temps dans un tableau.
function get_time_ayah(fichierXML)
{
    tableau = new Array();
    xmlDoc 	= 	loadXMLDoc(fichierXML);
    versets	=	xmlDoc.getElementsByTagName("marker");
    for (i=0;	i<versets.length	;i++){
        tableau[i] = versets[i].attributes.getNamedItem("time").nodeValue;
    }
    return tableau;
}

function play(tab_versets_time){
    begin_number 	= "";
    end_number 		= "";

    // On récupère le temps du debut
    time_begin 	= tab_versets_time[0] ;

    // On récupère le temps de la fin
    time_end 	= convert_to_millisecond(tab_versets_time[3]) ;
    alert(time_end);

}

// Converti le temps en millisecond //
function convert_to_millisecond(time)
{
    tab 		= time.split(':');
    heures 		= parseFloat(tab[0]) * 3600000;
    minutes 	= parseFloat(tab[1]) * 60000;
    secondes 	= parseFloat(tab[2]) * 1000;

    return( heures + minutes + secondes );
}

$(document).ready(function(){
    // Submit lorsqu'on change l'élement de la liste
    $('#lstSurahs').change(function() {
        $("#lstSurahsFrm").submit();
    });

    $('#lstFromVersets').change(function() {
        $("#lstSurahsFrm").submit();
    });
    $('#lstTraduction').change(function() {
        $("#lstSurahsFrm").submit();
    });
    $('#lstToVersets').change(function() {
        $("#lstToVersetsCheck").val(1)
        $("#lstSurahsFrm").submit();
    });

    $('#lstSize').change(function(){
       alert($(".verset_content").attr("class").length)
       var current_class = $(".verset_content").attr("class").split(" ")[$(".verset_content").attr("class").split(" ").length - 1]
       var value_selected = $(this).val()
        $(".verset_content").removeClass(current_class)
        $(".verset_content").addClass("arab_"+value_selected)
    })







    /*$("#lecteur_play").click(function(){
        surah_id = $("#lstSurahs").val();
        recitator_name = $("#lstRecitators").val();
        playSourate(surah_id, recitator_name);
        return false;
    }); */


});