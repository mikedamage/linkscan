# module: javascript

class Javascript < Thor
  include Thor::Actions

  desc 'concat', 'Combine JS files using comments in specified JS file'
  def concat(js_file = $root_dir.join('build', 'javascripts', 'app.js').to_s)
    js_file         = Pathname.new js_file
    js_dir          = js_file.dirname
    compiled_dir    = $root_dir.join('build', 'javascripts', 'compiled')
    compiled_script = compiled_dir.join('bundle.js')
    js_script       = js_file.read

    concatted = js_script.gsub(/^\=\s*require \"(?<path>[^\n]+)\"$/m) do |match|
      referred_script = js_dir.join $1

      if referred_script.file?
        say_status 'add', $1, :yellow
        replacement  = "// #{$1}\n"
        replacement += referred_script.read
        replacement += ";\n"
      else
        say_status 'missing', "#{$1} cannot be found", :red
        replacement = "\n"
      end

      replacement
    end

    unless compiled_dir.directory?
      say_status 'mkdir', compiled_dir.to_s, :yellow
      compiled_dir.mkdir
    end

    say_status 'save', compiled_script.to_s, :green
    compiled_script.open('w') {|f| f.write concatted }
  end
end
