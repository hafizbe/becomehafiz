module Amazon
  # Permet de transformer les "1" en "001" car toutes les sourates sont présentées sous la forme "001.mp3"
  def id_surah_to_string(number)
    if number.to_s.size == 1
      number = "00#{number}"
    else
      if number.to_s.size == 2
        number = "0#{number}"
      end
    end
    number
  end
end