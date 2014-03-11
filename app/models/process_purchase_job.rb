class ProcessPurchaseJob < Struct.new(:shot_id, :stage_id, :email)
  def perform
    shot = Productshot.find(shot_id)
    stage = Stage.find(stage_id)
    composite = stage.composite || ""
    stage_path = stage.stage_image.path
    stage_glare = "#{Rails.public_path}#{stage.glare_image_url}"
    tmp_file = "#{Rails.public_path}/uploads/productshot/#{shot_id}/"
    compose = "composite #{composite} #{tmp_file}output.png #{stage_path} #{tmp_file}temp_shot.png"
    system(compose)
    glare = "composite #{stage_glare} #{tmp_file}temp_shot.png #{tmp_file}breezi_placeit_high.png"
    system(glare)
    output = "/uploads/#{shot.class.to_s.underscore}/#{shot.id}/breezi_placeit_high.png"
    shot.update_attribute('image_high', output)
    ::Notifier.purchase_confirmation(email, output).deliver
  end
end
