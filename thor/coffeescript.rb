# module: coffeescript
class Coffeescript < Thor
  include Thor::Actions

  desc 'compile', 'Compile CoffeeScripts to build/javascripts/'
  method_option :source_maps, type: :boolean, desc: "Generate source maps along with JS files"
  def compile
    `which coffee`

    if $?.exitstatus != 0
      say 'CoffeeScript executable not found. Run `npm install -g coffee-script`', :red
      exit
    end

    cs_dir = $root_dir.join 'coffeescripts'
    js_dir = $root_dir.join 'build', 'javascripts'

    say 'Compiling CoffeeScripts...', :blue
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

end
