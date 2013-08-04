module Amazon
  # Permet de transformer les "1" en "001" car toutes les sourates sont présentées sous la forme "001.mp3"
  def count_number(number)
    if number.to_s.size == 1
      number = "00#{number}"
    else
      if number.to_s.size == 2
        number = "0#{number}"
      end
    end
    number
  end

  # Retourne un tableau avec la traduction de chaque verset
  def get_traduction(lang, num_sourate)
    require 'open-uri'
    s3 = AWS::S3.new
    url = s3.buckets['hafizbe'].objects["traduction/#{lang}/Chapter#{num_sourate}.xml"].url_for(:read, :secure => false).to_s
    document = Nokogiri::XML(open(url))
    versets = document.xpath("//Verse/text()")
  end
end