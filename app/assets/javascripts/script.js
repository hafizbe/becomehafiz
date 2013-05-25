soundManager.onload = function() {
    $("#lecteur_play").click(function(){
        url_amazon = $(this).attr("href");
        sound_object = soundManager.createSound({
            id:     'verset',
            url:    url_amazon,
            whileplaying : function() {
                console.log(this.position);
            }
        });
        tab_versets_time = get_time_ayah("https://s3.amazonaws.com/hafizbe/Nasser_al_qatami/1.xml");
        alert(tab_versets_time)

        //sound_object.play();
        return false;
    });
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

$(document).ready(function(){
    // Submit lorsqu'on change l'élement de la liste
    $('#lstSurahs').change(function() {
        $("#lstSurahsFrm").submit();
    });
});