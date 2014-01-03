
$root_dir = Pathname.new File.dirname(__FILE__)

$root_dir.join('thor').children.each do |script|
  require script if script.fnmatch('*.rb') || script.fnmatch('*.thor')
end
