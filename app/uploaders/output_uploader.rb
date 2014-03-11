# encoding: utf-8

class OutputUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def fog_directory
    "place-it"
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # %w[red green blue purple black].each do |color|
  #   version(color) { process stamp: color }
  # end

  # def stamp(color)
  #   manipulate! format: "png" do |source|
  #     overlay_path = Rails.root.join("app/assets/images/stamp_overlay.png")
  #     overlay = Magick::Image.read(overlay_path).first
  #     source = source.resize_to_fill(70, 70).quantize(256, Magick::GRAYColorspace).contrast(true)
  #     source.composite!(overlay, 0, 0, Magick::OverCompositeOp)
  #     colored = Magick::Image.new(70, 70) { self.background_color = color }
  #     colored.composite(source.negate, 0, 0, Magick::CopyOpacityCompositeOp)
  #   end
  # end
end

