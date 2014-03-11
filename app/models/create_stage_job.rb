class CreateStageJob < Struct.new(:stage_id, :type)

  def perform
    stage = Stage.find(stage_id)
    tmp_file = "#{Rails.public_path}/uploads/#{stage.class.to_s.underscore}/stage_image/#{stage.id}/"
    filename = stage.stage_image.to_s.split("/").last
    image = "#{Rails.public_path}#{stage.stage_image}"
    if type == 'normal'
        normal = "convert #{image} -resize '1280x960^' #{tmp_file}normal_#{filename}"
        system(normal)
    else
        high = "convert #{image} -resize '1920x1440^' #{tmp_file}high_#{filename}"
        system(high)
    end
  end

end
