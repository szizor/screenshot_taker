class StagesController < ApplicationController
  before_filter :authorize
  before_filter :set_cache_buster

  layout "productshots"
  def index
    @stages = Stage.all(:order => :position)
  end

  def show
    @stage = Stage.find(params[:id])
    if @stage.content
       Rails.logger.info(">>>>>>>>>>>>>>>>>>>>>>>>")
       @stage.create_example(params[:res], params[:image])
    end
  end

  def new
    @stage = Stage.new
  end

  def create
    @stage = Stage.new(params[:stage])
    if @stage.save
      flash[:notice] = "Successfully created stage."
      redirect_to @stage
    else
      render :action => 'new'
    end
  end

  def edit
    @stage = Stage.find(params[:id])
  end

  def update
    @stage = Stage.find(params[:id])
    new_update if params[:rules]
    if @stage.update_attributes(params[:stage])
      flash[:notice] = "Successfully updated stage."
      redirect_to @stage
    else
      render :action => 'edit'
    end
  end

  def new_update
    debugger
    rules = params[:rules]
    comp = params[:comp]
    string = "-geometry +{{0}}+{{1}}"
    comp.each_with_index do |y,i|
      string.gsub!("{{#{i}}}", y.to_s)
    end
    str = "convert :origin  \( -resize '{{0}}' -gravity northwest -crop '{{1}}x{{2}}+{{3}}+{{4}}' -background transparent -extent '{{5}}x{{6}}' \) \( -resize '{{7}}x{{8}}!' \) \( -matte -virtual-pixel transparent +distort Perspective '{{9}},{{10}} {{11}},{{12}} {{13}},{{14}} {{15}},{{16}} {{17}},{{18}} {{19}},{{20}} {{21}},{{22}} {{23}},{{24}} ' \)  :output"
    rules.each_with_index do |y,i|
      str.gsub!("{{#{i}}}", y)
    end
    str.gsub!("(", "\\(").gsub!(")", "\\)")
    params[:stage][:rules] = rules
    params[:stage][:content] = str
    params[:stage][:composite] = string
    params[:stage][:comp_array] = params[:comp]
  end

  def destroy
    @stage = Stage.find(params[:id])
    @stage.destroy
    flash[:notice] = "Successfully destroyed stage."
    redirect_to stages_url
  end

  def sort
    params[:stage].each_with_index do |id, index|
      Stage.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
