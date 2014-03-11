# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def image_size
    res = params[:res]
    case res
    when "normal"
      size = @stage.stage_image.normal.url
    when "high"
      size = @stage.stage_image.high.url
    when "super"
      size = @stage.stage_image.url
    else
      size = @stage.stage_image.free.url
    end
  end
end
