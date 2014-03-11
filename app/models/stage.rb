class Stage < ActiveRecord::Base
  serialize :rules
  serialize :comp_array
  belongs_to :image_type
  require 'fileutils'
  attr_accessible :stage_image, :name, :content, :output_image, :composite, :glare_image, :published, :viewport, :bg_less, :tag_list, :rules, :comp_array, :image_type_id
  mount_uploader :stage_image, StageUploader
  mount_uploader :glare_image, StageUploader
  mount_uploader :bg_less, StageUploader
  acts_as_list
  acts_as_taggable
  # after_save :create_stage_versions

  # def create_stage_versions
  #   Delayed::Job.enqueue CreateStageJob.new( self.id, 'normal' )
  #   Delayed::Job.enqueue CreateStageJob.new( self.id, 'high' )
  # end

  def create_example(res=nil, image=nil)
    case res
    when "normal"
      size = self.stage_image.normal.path
      rules = self.rules.map(&:to_f)
      glare_file = "#{Rails.public_path}/#{self.glare_image.normal.url}"
      array = []
      comp = []
      rules.each{|r| array << (r * 1.6)}
      str = "convert :origin  \( -resize '{{0}}' -gravity northwest -crop '{{1}}x{{2}}+{{3}}+{{4}}' -background transparent -extent '{{5}}x{{6}}' \) \( -resize '{{7}}x{{8}}!' \) \( -matte -virtual-pixel transparent +distort Perspective '{{9}},{{10}} {{11}},{{12}} {{13}},{{14}} {{15}},{{16}} {{17}},{{18}} {{19}},{{20}} {{21}},{{22}} {{23}},{{24}} ' \)  :output"
      array.each_with_index do |y,i|
        str.gsub!("{{#{i}}}", y.to_s)
      end
      str.gsub!("(", "\\(").gsub!(")", "\\)")
      new_comp = self.comp_array ? self.comp_array.each{|r| comp << (r.to_f * 1.6)} : self.composite
      string = "-geometry +{{0}}+{{1}}"
      comp.each_with_index do |y,i|
        string.gsub!("{{#{i}}}", y.to_s)
      end
    when "high"
      size = self.stage_image.high.path
      rules = self.rules.map(&:to_f)
      glare_file = "#{Rails.public_path}/#{self.glare_image.high.url}"
      array = []
      comp = []
      rules.each{|r| array << (r * 2.4)}

      str = "convert :origin  \( -resize '{{0}}' -gravity northwest -crop '{{1}}x{{2}}+{{3}}+{{4}}' -background transparent -extent '{{5}}x{{6}}' \) \( -resize '{{7}}x{{8}}!' \) \( -matte -virtual-pixel transparent +distort Perspective '{{9}},{{10}} {{11}},{{12}} {{13}},{{14}} {{15}},{{16}} {{17}},{{18}} {{19}},{{20}} {{21}},{{22}} {{23}},{{24}} ' \)  :output"
      array.each_with_index do |y,i|
        str.gsub!("{{#{i}}}", y.to_s)
      end

      str.gsub!("(", "\\(").gsub!(")", "\\)")
      new_comp = self.comp_array ? self.comp_array.each{|r| comp << (r.to_f * 2.4)} : self.composite
      string = "-geometry +{{0}}+{{1}}"
      comp.each_with_index do |y,i|
        string.gsub!("{{#{i}}}", y.to_s)
      end
    when "super"
      size = self.stage_image.path
      glare_file = "#{Rails.public_path}/#{self.glare_image.url}"
      rules = self.rules.map(&:to_f)
      array = []
      comp = []
      rules.each{|r| array << (r * 4.125)}
      str = "convert :origin  \( -resize '{{0}}' -gravity northwest -crop '{{1}}x{{2}}+{{3}}+{{4}}' -background transparent -extent '{{5}}x{{6}}' \) \( -resize '{{7}}x{{8}}!' \) \( -matte -virtual-pixel transparent +distort Perspective '{{9}},{{10}} {{11}},{{12}} {{13}},{{14}} {{15}},{{16}} {{17}},{{18}} {{19}},{{20}} {{21}},{{22}} {{23}},{{24}} ' \)  :output"
      array.each_with_index do |y,i|
        str.gsub!("{{#{i}}}", y.to_s)
      end
      str.gsub!("(", "\\(").gsub!(")", "\\)")
      new_comp = self.comp_array ? self.comp_array.each{|r| comp << (r.to_f * 4.125)} : self.composite
      string = "-geometry +{{0}}+{{1}}"
      # string.gsub!("{{#{0}}}", (comp[0]+3).to_s)
      # string.gsub!("{{#{1}}}", (comp[1]).to_s)
      comp.each_with_index do |y,i|
        string.gsub!("{{#{i}}}", y.to_s)
      end
    else
      glare_file = "#{Rails.public_path}/#{self.glare_image.free.url}"
      size = self.stage_image.free.path
    end
    if image
      example = "#{Rails.public_path}/images/1536x2048.jpg"
    else
      example = "#{Rails.public_path}/images/Test-Red.png"
    end
    composite = comp ? string : self.composite
    content = str ? str : self.content
    tmp_file = "#{Rails.public_path}/#{self.stage_image.store_path}"
    command = content.gsub(":origin", example).gsub(":output", tmp_file+"output.png")
    system(command)
    Rails.logger.info(command)
    compose = "composite #{composite} #{tmp_file}output.png #{size} #{tmp_file}shot.png"
    system(compose)
    Rails.logger.info(compose)
    glare = "composite #{glare_file} -quality 100% #{tmp_file}shot.png #{tmp_file}breezi_placeit.png"
    system(glare)
    Rails.logger.info(glare)
    output = "/#{self.stage_image.store_path}breezi_placeit.png"
    self.output_image = output
    self.save
  end

  def execute_code(uploader)
    shot = Productshot.create(:name => "productshot")
    example = uploader.path
    tmp_file = "#{Rails.public_path}/uploads/#{shot.class.to_s.underscore}/#{shot.id}/"
    FileUtils.mkdir_p tmp_file
    command = self.content.gsub(":origin", example).gsub(":output", tmp_file+"output.png")
    system(command)
    compose = "composite -gravity center #{tmp_file}output.png #{self.stage_image.path} #{tmp_file}product_shot.png"
    system(compose)
    output = "/uploads/#{shot.class.to_s.underscore}/#{shot.id}/product_shot.png"
    shot.update_attribute('image', output)
    output
  end

end
