# encoding: utf-8

class StageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def move_to_cache
    true
  end

  def move_to_store
    true
  end

  # Choose what kind of storage to use for this uploader:
  storage :file

  version :thumb do
    process :resize_to_fill => [150,112]
    process :quality => 80
  end

  version :free do
    process :resize_to_fill => [800,600]
  end

  version :normal do
    process :resize_to_fill => [1280,960]
  end

  version :high do
    process :resize_to_fill => [1920,1440]
  end

  def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
  end
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def fog_directory
    "place-it"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end


end
