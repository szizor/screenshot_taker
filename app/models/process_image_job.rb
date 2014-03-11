class ProcessImageJob < Struct.new(:uploader, :stage_path, :stage_id, :shot_id, :composite, :stage_glare)

  def perform
    #system("echo #{stage_id} >> test.log")
    stage = Stage.find(stage_id)
    shot = Productshot.find(shot_id)
    example = uploader
    content = stage.content
    if stage.image_type_id == 4
        glare_file = "#{Rails.public_path}/#{stage.glare_image.url}"
        size = stage.stage_image.path
    else
        glare_file = "#{Rails.public_path}/#{stage.glare_image.free.url}"
        size = stage.stage_image.free.path
    end
    tmp_file = "#{Rails.public_path}/uploads/#{shot.class.to_s.underscore}/#{shot.id}/"
    FileUtils.mkdir_p tmp_file
    command = content.gsub(":origin", example).gsub(":output", tmp_file+"output.png")
    system(command)
    compose = "composite #{composite} #{tmp_file}output.png #{size} #{tmp_file}temp_shot.png"
    system(compose)
    glare = "composite #{glare_file} #{tmp_file}temp_shot.png #{tmp_file}breezi_placeit.png"
    system(glare)
    output = "/uploads/#{shot.class.to_s.underscore}/#{shot.id}/breezi_placeit.png"
    shot.update_attribute('image', output)
  end


end
