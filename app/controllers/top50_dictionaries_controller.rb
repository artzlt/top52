class Top50DictionariesController < ApplicationController

  def index
    @top50_dictionaries = Top50Dictionary.all
  end

  def show
    @top50_dictionary = Top50Dictionary.find(params[:id])
  end
 
  def new
    @top50_dictionary = Top50Dictionary.new
  end

  def create
    @top50_dictionary = Top50Dictionary.new(top50_dictionary_params)
    if @top50_dictionary.save
      redirect_to @top50_dictionary
    else
      render :new
    end
  end

  def edit
    @top50_dictionary = Top50Dictionary.find(params[:id])
  end

  def update
    @top50_dictionary = Top50Dictionary.find(params[:id])
    @top50_dictionary.update_attributes(top50_dictionary_params)
    redirect_to :top50_dictionaries
  end

  def destroy
    @top50_dictionary = Top50Dictionary.find(params[:id])
    @top50_dictionary.destroy
    redirect_to :top50_dictionaries
  end



  def default
    Top50Dictionary.default!
  end

  private

  def top50_dictionary_params
    params.require(:top50_dictionary).permit(:name, :name_eng)
    #params.require(:top50_dictionary).permit(:top50_dictionary => [:dict_id], :top50_attribute => [:name, :name_eng, :attr_type])
  end
end
