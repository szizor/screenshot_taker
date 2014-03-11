class ScreenshotTakerJob < Struct.new(:url, :sitemap_id, :screen_id)
  require 'open-uri'
  APP_KEY = "twjomw5hf03osal"
  APP_SECRET = "woa2ftmu5launqe"
  TOKEN = "hbsmaxpmwu892rmw"
  SECRET = "yue7rkiglqkfeix"
  ACCESS_TYPE = :dropbox

  def perform
    @client = Dropbox::API::Client.new :token => TOKEN, :secret => SECRET
        begin
         url2png_v6(url, sitemap_id, screen_id)
        rescue => e
            puts e.message
        end
  end

  def url2png_v6(url, id, screen_id)
    # ScreenshotTaker.new("http://www.google.com/", 1) DEMO
    url_path = url.gsub(/\/$/, '')

    url2png_apikey = 'P50DDE5FE3B0A9'
    url2png_secret = 'S073748ED06E32'
    query = {
      :url => url_path,
      :force => false, # [false,always,timestamp] Default: false
      :fullpage => true, # [true,false] Default: false
      :max_width => 'no-scaling', # scaled img width px; Default no-scaling
      :viewport => '1280x1024', # Max 5000x5000; Default 1280x1024
    }

    query_string = query.
      sort_by {|s| s[0].to_s }. # sort query by keys for uniformity
      select {|s| s[1] }. # skip empty options
      map {|s| s.map {|v| CGI::escape(v.to_s) }.join('=') }. # escape keys & vals
      join('&')

    token = Digest::MD5.hexdigest(query_string + url2png_secret)

    file = "http://beta.url2png.com/v6/#{url2png_apikey}/#{token}/png/?#{query_string}"
    if remote_file_exists? file
      uri = URI(file)
      http = Net::HTTP.new(uri.host, 80)
      request = Net::HTTP::Get.new(uri.request_uri)
      resp = http.request(request)
      name = URI.parse(url).host
      domain = name.split( "." )[-2,2].join(".")
      image_path = "ScreenshotTaker/#{domain}/#{name}.png"
      debugger
      image_uploaded = @client.upload image_path, resp.body
      image_url = image_uploaded.share_url.url
      screen = Screen.find(screen_id)
      screen.update_attributes(:image_path => image_url, :processed => true, :name => name )
    else
      "error"
      screen = Screen.find(screen_id)
      screen.update_attributes(:image_path => "Not Found" )
    end
  end

  def remote_file_exists?(url)
    url = URI.parse(url)
    Net::HTTP.start(url.host, url.port) do |http|
      return http.head(url.request_uri).code == "200"
    end
  end

end
