require 'RMagick'
include Magick

class RMagickPlugin
  BadFiles.register_extensions /\.jpg|\.png|\.gif|\.tiff|\.pdf/i do |file|
    img = Image.read(file).first
    img.destroy!
  end
end
