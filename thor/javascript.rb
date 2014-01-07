# module: javascript

class Javascript < Thor
  include Thor::Actions

  @@app_js     = $root_dir.join 'build', 'javascripts', 'app.js'
  @@bundle_dir = $root_dir.join 'build', 'javascripts', 'compiled'

  desc 'bundle', 'Concatenate and minify JavaScripts'
  def bundle
    thor 'javascript:concat'
    thor 'javascript:minify'
  end

  desc 'concat [INPUT] [OUTPUT]', 'Combine JS files using comments in specified JS file'
  def concat(input = @@app_js.to_s, output = @@bundle_dir.join('bundle.js').to_s)
    js_file          = Pathname.new input
    js_dir           = js_file.dirname
    compiled_script  = Pathname.new output
    js_script        = js_file.read
    included_scripts = []
    total_size       = 0

    concatted = js_script.gsub(/^\=\s*require \"(?<path>[^\n]+)\"$/m) do |match|
      referred_script = js_dir.join $1

      if referred_script.file?
        total_size += referred_script.size
        included_scripts << referred_script
      else
        say_status 'missing', "#{$1} cannot be found", :red
      end

      String.new
    end

    total_size += concatted.bytesize
    total_kb    = ( total_size / 1024.0 ).round 2

    unless compiled_dir.directory?
      say_status 'mkdir', compiled_dir.to_s, :yellow
      compiled_dir.mkdir
    end

    # Stream included_scripts into compiled_script using a 4K buffer
    compiled_script.open('w') do |file|
      included_scripts.each do |scpt|
        say_status 'add', scpt.to_s, :yellow
        input = scpt.open 'r'

        file.write "\n// #{scpt.basename.to_s}\n"

        while chunk = input.read(4096)
          file.write(chunk)
        end

        file.write "\n;\n"
        input.close
      end

      say_status 'save', compiled_script.to_s, :green
      say "Total size: #{total_kb.to_s} kilobytes"
      file.write concatted
    end
  end

  desc 'minify [INPUT] [OUTPUT]', 'Minify bundled JS file'
  def minify(input = @@bundle_dir.join('bundle.js').to_s, output = @@bundle_dir.join('bundle.min.js').to_s)
    require 'uglifier'

    infile           = Pathname.new input
    outfile          = Pathname.new output
    original_size    = infile.size
    minified         = Uglifier.compile infile.read
    minified_size    = minified.bytesize
    original_size_kb = ( original_size / 1024.0 ).round 2
    minified_size_kb = ( minified_size / 1024.0 ).round 2
    shrinkage        = (100 - (( minified_size.to_f / original_size.to_f ) * 100)).round(2)

    say "Original size: #{original_size_kb.to_s} kilobytes"
    say "Minified size: #{minified_size_kb.to_s} kilobytes"
    say "Shrinkage: #{shrinkage.to_s}%"

    outfile.open('w') {|f| f.write(minified) }
    say "Saved #{outfile.to_s}", :green
  end
end
