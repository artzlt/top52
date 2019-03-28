class Top50DictionaryElemsController < Top50BaseController

  respond_to :json

  def index
    attribute_dict = Top50AttributeDict.find(params[:attr_id])
    dict = attribute_dict.top50_dictionary
    @top50_dictionary_elems= dict.top50_dictionary_elems.finder(params[:q])
    json = { records: @top50_dictionary_elems.page(params[:page]).per(params[:per]), total: @top50_dictionary_elems.count}
    #@top50_dictionary_elems= dict.top50_dictionary_elems
    #json = { records: @top50_dictionary_elems, total: @top50_dictionary_elems.count}
    respond_with(json)
  end 

  def new
    @top50_dictionary = Top50Dictionary.find(params[:top50_dictionary_id])
    @top50_dictionary_elem = @top50_dictionary.top50_dictionary_elems.build
  end

  def create
    @top50_dictionary = Top50Dictionary.find(params[:top50_dictionary_id])
    @top50_dictionary_elem = @top50_dictionary.top50_dictionary_elems.build(top50_dictionary_elem_params)
    if @top50_dictionary_elem.save
      redirect_to @top50_dictionary
    else
      render :new
    end
  end

  def edit
    @top50_dictionary_elem = Top50DictionaryElem.find(params[:id])
  end

  def update
    @top50_dictionary_elem = Top50DictionaryElem.find(params[:id])
    @top50_dictionary = @top50_dictionary_elem.top50_dictionary
    @top50_dictionary_elem.update_attributes(top50_dictionary_elem_params)
    redirect_to @top50_dictionary
  end

  def destroy
    @top50_dictionary_elem = Top50DictionaryElem.find(params[:id])
    @top50_dictionary = @top50_dictionary_elem.top50_dictionary
    @top50_dictionary_elem.destroy
    redirect_to @top50_dictionary
  end



  def default
    Top50Dictionary.default!
  end

  private

  def top50_dictionary_elem_params
    params.require(:top50_dictionary_elem).permit(:name, :name_eng)
    #params.require(:top50_dictionary).permit(:top50_dictionary => [:dict_id], :top50_attribute => [:name, :name_eng, :attr_type])
  end
end
