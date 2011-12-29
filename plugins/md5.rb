require 'digest/md5'

class MD5Plugin
  BadFiles.register_extensions /\.md5/i do |file|
    expected = read_checksum(file)
    if expected
      actual_file = file[/(.*)\.md5/, 1]
      actual = Digest::MD5.file(actual_file).hexdigest
      raise "Invalid MD5 checksum: expected #{expected}, got #{actual} (#{actual_file})" if expected != actual
    end
  end

  def self.read_checksum file
    IO.readlines(file)[0].split[0]
  end
end
