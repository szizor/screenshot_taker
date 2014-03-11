class TagsController < ApplicationController
  before_filter :authorize
  layout "productshots"
   def index
    @tags = Tag.all
    respond_to do |format|
      format.html
      format.json { render :json => @tags }
    end
  end

  def search
    @tags = Tag.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @tags }
    end
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(params[:tag])

    if @tag.save
      redirect_to tags_path, :notice => 'Tag was successfully created.'
    else
      render :action => "new"
    end
  end

  def edit
     @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])
    if @tag.update_attributes(params[:tag])
      redirect_to tags_path, :notice => 'tag was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to tags_url
  end

  def sort
    # params[:tag].each_with_index do |id, index|
    #   Tag.update_all({position: index+1}, {id: id})
    # end
    # render nothing: true
  end
end
