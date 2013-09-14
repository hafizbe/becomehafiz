class FormPlayerOption
  attr_accessor  :verset_minimu
  
  def initialize(id_surah, lst_from_versets, lst_to_versets)
    @verset_minimum = choose_verset_minimum lst_from_versets
  end

  private
    def choose_verset_minimum(lst_from_versets)
      verset_minimum = 1
      unless lst_from_versets.nil?
        verset_minimum = lst_from_versets
      end
      verset_minimum
    end
end