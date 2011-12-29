class BadFiles
  def self.register_extensions pattern, &block
    @@patterns ||= {}
    @@patterns[pattern] = block
  end

  def scan path
    @bad_files = []
    @good_files = []
    begin
      entries = Dir.entries(path)
      entries.reject! {|p| ['..', '.'].include? p }
      entries.map! {|p|File.join(path, p)}
      entries.each do |entry|
        if File.directory? entry
          scan entry
        else
          check(entry) ? @bad_files.push(entry) : @good_files.push(entry)
        end
      end
    rescue IOError
      $stderr.puts "Error accessing #{path}: #{$!}"
    end
  end

  def check filename
    begin
      @@patterns.each do |pattern, handler|
        if File.extname(filename) =~ pattern
          handler.call filename
        end
      end
      puts "[ \e[32mOK\e[0m ] #{filename}"
      nil
    rescue
      puts "[ \e[31mBAD\e[0m ] #{filename}: #{$!}"
      #$stderr.puts $!.backtrace
      filename
    end
  end

  def print_summary
    puts "\nSummary:"
    puts "  Good files: #{@good_files.size}"
    puts "  Bad files: #{@bad_files.size}"
    @bad_files.each do |file|
      puts "#{file}"
    end
  end
end

