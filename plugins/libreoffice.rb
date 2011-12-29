
class LibreOfficePlugin
  BadFiles.register_extensions /\.odt/i do |file|
    `cd /tmp ; libreoffice --headless -print-to-file #{file}`
    tmp = File.join('/tmp', File.basename(file)[/(.*)\.odt/, 1] + ".ps")
    unless File.exists? tmp
      raise "Expected #{tmp} file to be created by libreoffice"
    end
    if tmp == file
      raise "Attempt to delete original file!"
    end
    File.delete(tmp)
  end
end

