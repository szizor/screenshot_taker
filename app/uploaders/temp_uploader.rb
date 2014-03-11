class TempUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/tmp"
  end

  def extension_white_list
   %w(jpg jpeg png image/png)
  end
  def fog_directory
    "place-it"
  end

end
