class SitemapsController < ApplicationController
  before_filter :authenticate
  # skip_before_filter :authenticate_user!
  layout "sitemap"

  def index
    @sitemaps = Sitemap.all

  end

  def show
    @sitemap = Sitemap.find(params[:id])

  end

  def new
    @sitemap = Sitemap.new

  end

  def edit
    @sitemap = Sitemap.find(params[:id])
  end

  def create
    @sitemap = Sitemap.new(params[:sitemap])
    if @sitemap.save
      enqueue_sitemap(@sitemap.id)
      flash[:notice] = 'Sitemap was successfully created.'
      redirect_to sitemap_url(@sitemap)
    else
      render :action => "new"
    end
  end

  def update
    @sitemap = Sitemap.find(params[:id])
    if @sitemap.update_attributes(params[:sitemap])
      enqueue_sitemap(@sitemap.id)
      flash[:notice] = 'Sitemap was successfully updated.'
      redirect_to sitemap_url(@sitemap)
    else
      render :action => "edit"
    end
  end

  def destroy
    @sitemap = Sitemap.find(params[:id])
    @sitemap.destroy
    redirect_to sitemaps_url
  end

  def enqueue_sitemap(sitemap_id)
    sitemap = Sitemap.find(sitemap_id)
    links=[]
    url = sitemap.url
    doc = Nokogiri::HTML(open(url))
    doc.xpath('//urlset/url/loc').each { |node| links << node.inner_text }
    links.each do |link|
      screen = Screen.find_or_create_by_url(link)
      screen.sitemap_id = sitemap_id
      screen.save
      Delayed::Job.enqueue ScreenshotTakerJob.new(link, sitemap_id, screen.id), :queue => 'screens', :priority => 5
      #Resque.enqueue(Screenshot, link, sitemap_id, screen.id)
    end
  end

  def authenticate
    authenticate_or_request_with_http_basic('Administration') do |username, password|
      username == 'admin' && password == 'fr3sh0ut'
    end
  end
end
