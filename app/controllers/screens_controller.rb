class ScreensController < ApplicationController

  def destroy
    #@client = Dropbox::API::Client.new :token => APP_CONFIG[:dropbox_token], :secret => APP_CONFIG[:dropbox_secret]
    @screen = Screen.find(params[:id])
    #path = @screen.image_path.split('/')[-3] +"/"+ @screen.image_path.split('/')[-2] +"/"+ @screen.image_path.split('/')[-1]
    @screen.destroy

    flash[:notice] = "Successfully destroyed stage."
    redirect_to stages_url
  end
end
