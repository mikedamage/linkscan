# module: coffeescript
class Coffeescript < Thor
  include Thor::Actions

  desc 'compile', 'Compile CoffeeScripts to build/javascripts/'
  method_option :source_maps, type: :boolean, desc: "Generate source maps along with JS files"
  method_option :clean, type: :boolean, desc: 'Delete files in build/javascripts first'
  def compile
    require 'coffee-script'

    thor 'coffeescript:clean' if options.clean

    cs_dir = $root_dir.join 'coffeescripts'
    js_dir = $root_dir.join 'build', 'javascripts'

    cs_dir.children.each do |child|
      if child.fnmatch('*.coffee')
        timestamp          = Time.now.strftime("%Y-%m-%d %H:%M:%S")
        js_filename        = child.basename.sub 'coffee', 'js'
        compilation_header = "// Compiled with CoffeeScript #{CoffeeScript.version} on #{timestamp}"

        say_status 'compile', child.basename.to_s, :blue

        js_content  = CoffeeScript.compile child.read
        
        say_status 'save', js_filename.to_s, :green
        js_dir.join(js_filename).open('w') do |file|
          file.puts  compilation_header
          file.write js_content
        end
      end
    end
  end

  desc 'clean', 'Delete compiled JS files in build/javascripts'
  def clean
    js_dir = $root_dir.join 'build', 'javascripts'
    js_files = Pathname.glob js_dir.join('*.js')

    js_files.each do |file|
      say_status 'delete', file.basename.to_s, :red
      file.unlink
    end
  end
end
