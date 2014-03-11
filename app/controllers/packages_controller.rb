class PackagesController < ApplicationController
  before_filter :authorize
  layout "productshots"

  def index
    @packages = Package.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @packages }
    end
  end

  def show
    @package = Package.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @package }
    end
  end

  def new
    @package = Package.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @package }
    end
  end

  def edit
    @package = Package.find(params[:id])
  end

  def create
    @package = Package.new(params[:package])

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, :notice => 'Package was successfully created.' }
        format.json { render :json => @package, :status => :created, :location => @package }
      else
        format.html { render :action => "new" }
        format.json { render :json => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @package = Package.find(params[:id])

    respond_to do |format|
      if @package.update_attributes(params[:package])
        format.html { redirect_to @package, :notice => 'Package was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @package.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @package = Package.find(params[:id])
    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url }
      format.json { head :no_content }
    end
  end
end
