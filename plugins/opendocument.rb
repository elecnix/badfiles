require 'zip/zip'
require 'rexml/document'

class OpenDocumentPlugin
  BadFiles.register_extensions /\.odt/i do |file|
    zip = Zip::ZipFile.open(file)
    zip.find_entry('Pictures')
    ['content.xml', 'styles.xml', 'settings.xml', 'meta.xml', 'manifest.rdf'].each do|f|
      parse_xml(zip, f)
    end
    zip.close
  end

  def self.parse_xml(zip, filename)
    xml_doc = REXML::Document.new(zip.read(filename))
  end
end
