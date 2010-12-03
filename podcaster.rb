require 'rubygems'
require 'sinatra'
require 'erb'
require 'ruby-debug'
require 'mp3info'
require 'yaml'

helpers do
  def link_to(title, url_fragment, mode=:path_only)
    case mode
    when :path_only
      base = request.script_name
    when :full_url
      port = ":#{request.port}"
      base = "http://#{request.host}#{port}#{request.script_name}"
    when :itpc
      base = "itpc://localhost:4567"
    else
      raise "Unknown script_url mode #{mode}"
    end
    "<a href=\"#{base}/#{url_fragment}\">#{title}</a>"
  end
  def humanize(foo)
    foo.gsub(/_/, " ").capitalize
  end
  def yml_of(path)
    YAML::load(File.open(path))
  end
  def available_podcasts
    configs = []
    Dir.glob("public/podcasts/**/podcast.yml").each do |file_path| # use glob because it ignores hidden files
      yml = yml_of(file_path)
      p = file_path.split("/")
      p.pop
      p.shift
      yml[:path] = p.join("/")
      configs << yml
    end
    configs
  end
  def get_items(path)
    ret = []
    Dir.glob("#{path}/*.mp3").each do |p|
      ret << p.sub("public\/", '')
    end
    ret
  end
end

get '/' do
  @title = "Local Podcasts"
  erb :index
end

get '/podcasts/*' do
  @podcast = yml_of("public/podcasts/#{params[:splat]}/podcast.yml")
  @podcast[:items] = get_items("public/podcasts/#{params[:splat]}")
  builder :podcast
end
