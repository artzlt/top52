class Top50BenchmarksController < ApplicationController

  def index
    @top50_benchmarks = Top50Benchmark.all
  end

  def show
    @top50_benchmark = Top50Benchmark.find(params[:id])
  end
 
  def new
    @top50_benchmark = Top50Benchmark.new
  end

  def create
    @linked_obj = Top50Object.new
    @linked_obj[:type_id] = 9
    @linked_obj[:is_valid] = 0
    @linked_obj[:comment] = "NewBenchmark"
    @linked_obj.save!
    @top50_benchmark = Top50Benchmark.new(top50benchmark_params)
    @top50_benchmark.id = @linked_obj.id
    if @top50_benchmark.save
      redirect_to :top50_benchmarks
    else
      render :new
    end
  end

  def edit
    @top50_benchmark = Top50Benchmark.find(params[:id])
  end

  def update
    @top50_benchmark = Top50Benchmark.find(params[:id])
    @top50_benchmark.update_attributes(top50benchmark_params)
    redirect_to :top50_benchmarks
  end

  def destroy
    @top50_benchmark = Top50Benchmark.find(params[:id])
    @top50_benchmark.top50_object.destroy
    @top50_benchmark.destroy
    redirect_to :top50_benchmarks
  end



  def default
    Top50Benchmark.default!
  end

  private

  def top50benchmark_params
    params.require(:top50_benchmark).permit(:name, :name_eng, :measure_id)
  end
end
