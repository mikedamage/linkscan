# module: javascript

class Javascript < Thor
  include Thor::Actions

  desc 'concat', 'Combine JS files using comments in specified JS file'
  def concat(js_file = $root_dir.join('build', 'javascripts', 'app.js').to_s)
    js_file          = Pathname.new js_file
    js_dir           = js_file.dirname
    compiled_dir     = $root_dir.join('build', 'javascripts', 'compiled')
    compiled_script  = compiled_dir.join('bundle.js')
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
end
