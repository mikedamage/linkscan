# module: coffeescript
class Coffeescript < Thor
  include Thor::Actions

  desc 'compile', 'Compile CoffeeScripts to build/javascripts/'
  method_option :source_maps, type: :boolean, desc: "Generate source maps along with JS files"
  method_option :clean, type: :boolean, desc: 'Delete files in build/javascripts first'
  def compile
    thor 'coffeescript:clean' if options.clean

    `which coffee`

    if $?.exitstatus != 0
      say 'CoffeeScript executable not found. Run `npm install -g coffee-script`', :red
      exit
    end

    cs_dir = $root_dir.join 'coffeescripts'
    js_dir = $root_dir.join 'build', 'javascripts'

    cs_dir.children.each do |child|
      if child.fnmatch('*.coffee')
        say_status 'compile', child.basename.to_s, :blue

        coffee_opts = {
          output: js_dir.expand_path.to_s,
          compile: true
        }
        coffee_opts[:map] = true if options.source_maps

        coffee_opts = coffee_opts.map do |pair|
          if pair.last === true then "--#{pair.first}" else "--#{pair.first} #{pair.last}" end
        end

        coffee_cmd = "coffee #{coffee_opts.join(' ')} #{child.expand_path.to_s}"

        run coffee_cmd, verbose: false
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
