class ProductshotsController < ApplicationController
  require 'aws/s3'
  layout "application"
  require 'open-uri'
  require 'net/http'
  respond_to :js, :only => :change_bg

  def index
    if current_user
      @stages = Stage.all(:order => :position)
      @stage = Stage.find(:first, :conditions => {:published => true}, :order => :position)
    else
      @stages = Stage.find(:all, :conditions => {:published => true}, :order => :position)
      @stage = Stage.find(:first, :conditions => {:published => true}, :order => :position)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @productshots }
    end
  end

  def show
    if current_user
      @stages = Stage.all(:order => :position)
      @stage = Stage.find(params[:id])
    else
      @purchse = Purchase.new
      @stages = Stage.find(:all, :conditions => {:published => true}, :order => :position)
      @stage = Stage.find(params[:id])
    end
  end

  def change_bg
    @stage = Stage.find(params[:stage])
    if params[:bg] == "0"
      @path = @stage.bg_less ? @stage.bg_less.url : @stage.stage_image.url
    else
      @path = @stage.stage_image.url
    end
    respond_to do |format|
      format.html {}
      format.js {respond_with(@path)}
    end
  end

  def upload
   @stages = Stage.find(:all, :conditions => {:published => true})
   @stage = Stage.find(params[:id])
   uploader = TempUploader.new
   uploader.store!(params[:file])
    if @stage.content
      shot = Productshot.create(:name => "productshot")
      composite = @stage.composite || ""
      tmp_file = "#{Rails.public_path}#{@stage.glare_image_url}" if @stage.glare_image
      if params[:bg] == "0"
        image = @stage.bg_less.present? ? @stage.bg_less.path : @stage.stage_image.path
      else
        image = @stage.stage_image.path
      end
      Delayed::Job.enqueue ProcessImageJob.new( uploader.path, image, @stage.id, shot.id, composite, tmp_file)
      render :text => shot.id
    else
      render :text => "error", :status => 403
    end
  end

  def benchmark
   @stages = Stage.find(:all, :conditions => {:published => true})
   @stage = Stage.find(206)
   image_path = "http://placeit.net/images/Test-Red.png"
   # uploader = TempUploader.new
   # uploader.store!(image)
    if @stage.content
      shot = Productshot.create(:name => "productshot")
      composite = @stage.composite || ""
      tmp_file = "#{Rails.public_path}#{@stage.glare_image_url}" if @stage.glare_image
      if params[:bg] == "0"
        image = @stage.bg_less.present? ? @stage.bg_less.path : @stage.stage_image.path
      else
        image = @stage.stage_image.path
      end
      #Rails.logger.info (">>>>>>>" + uploader.path)
      Delayed::Job.enqueue ProcessImageJob.new( image_path, image, @stage.id, shot.id, composite, tmp_file)
      render :text => shot.id
    else
      render :text => "error", :status => 403
    end
  end

  def shared_image
    hsh = params[:id]
    stage = SharedImage.find_by_slug(hsh)
    unless stage
      redirect_to :action => "index"
    else
      @path = "http://s3.amazonaws.com/place-it/" + stage.url
      render :action => "shared_image", :layout => "shared"
    end
  end

  def store_in_s3
    path = params[:id]
    connection = AWS::S3::Base.establish_connection!(
      :access_key_id     => APP_CONFIG[:s3_access_key],
      :secret_access_key => APP_CONFIG[:s3_access_secret])
    file = "public"+ path
    if FileTest.exists?("#{file}")
      image = AWS::S3::S3Object.store(file, open(file), 'place-it', :access => :public_read)
      share_image =  SharedImage.create(:url => file)
      hsh =  Digest::MD5.hexdigest(share_image.id.to_s)[0..6]
      share_image.update_attribute(:slug, hsh)
      render :text => share_image.slug
    else
      render :text => "error", :status => 403
    end
  end

  def url2png_v6#(url, options={})
    url_path = params[:url]

    @stage = Stage.find(params[:shot_id])
    url2png_apikey = 'P50DDE5FE3B0A9'
    url2png_secret = 'S073748ED06E32'
    query = {
      :url       => url_path,
      :force     => false,     # [false,always,timestamp] Default: false
      :fullpage  => false,  # [true,false] Default: false
      :max_width => 'no-scaling', # scaled img width px; Default no-scaling
      :viewport  => @stage.viewport,  # Max 5000x5000; Default 1280x1024
    }

    query_string = query.
      sort_by {|s| s[0].to_s }. # sort query by keys for uniformity
      select {|s| s[1] }.       # skip empty options
      map {|s| s.map {|v| CGI::escape(v.to_s) }.join('=') }. # escape keys & vals
      join('&')

    token = Digest::MD5.hexdigest(query_string + url2png_secret)

    file = "http://beta.url2png.com/v6/#{url2png_apikey}/#{token}/png/?#{query_string}"

    if remote_file_exists? file
      uploader = UrlUploader.new
      io = open(file)
      uploader.store! io
      io.unlink
      if @stage.content
        shot = Productshot.create(:name => "productshot")
        composite = @stage.composite || ""
        tmp_file = "#{Rails.public_path}#{@stage.glare_image_url}" if @stage.glare_image
        if params[:bg] == "0" || params[:bg] == "false"
          image = @stage.bg_less.present? ? @stage.bg_less.path : @stage.stage_image.path
        else
          image = @stage.stage_image.path
        end
        Delayed::Job.enqueue ProcessImageJob.new( uploader.path, image, @stage.id, shot.id, composite, tmp_file)
        render :text => shot.id
      else
        render :text => "error", :status => 403
      end
    else
      render :text => "error"
    end
  end

  def remote_file_exists?(url)
    url = URI.parse(url)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri).code == "200"
    end
  end

  def queue
    @shot = Productshot.find(params[:shot_id])
    if @shot.image
      render :text => @shot.image
    else
      render :text => "queue"
    end
  end

end
