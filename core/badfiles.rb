class BadFiles
  def self.register_extensions pattern, &block
    @@patterns ||= []
    @@patterns.push [pattern, block]
  end

  def scan path
    @bad_files ||= []
    @good_files ||= []
    begin
      entries = Dir.entries(path)
      entries.reject! {|p| ['..', '.'].include? p }
      entries.reject! {|p| p[0] == '.' }
      entries.map! {|p|File.join(path, p)}
      entries.each do |entry|
        if File.directory? entry
          scan entry
        else
          check(entry) ? @bad_files.push(entry) : @good_files.push(entry)
        end
      end
    rescue
      $stderr.puts "Error accessing #{path}: #{$!}"
    end
  end

  def check filename
    begin
      checked = false
      @@patterns.each do |plugin|
        pattern, handler = plugin
        if File.extname(filename) =~ pattern
          handler.call filename
          checked = true
        end
      end
      # TODO don't print here - delegate to block
      #puts "[ \e[32mOK\e[0m ] #{filename}" if checked
      nil
    rescue
      puts "[ \e[31mBAD\e[0m ] #{filename}: #{$!}"
      #$stderr.puts $!.backtrace
      filename
    end
  end

  def print_summary
    puts "\nSummary:"
    puts "  Tested files: #{@good_files.size + @bad_files.size}"
    puts "  Bad files: #{@bad_files.size}"
    @bad_files.each do |file|
      puts "#{file}"
    end
  end
end

