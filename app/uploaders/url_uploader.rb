class UrlUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/tmp"
  end

  def filename
    "#{DateTime.now.to_s}-#{original_filename}"
  end
  def fog_directory
    "place-it"
  end

  # def extension_white_list
  #  %w(jpg jpeg png image/png)
  # end

end
