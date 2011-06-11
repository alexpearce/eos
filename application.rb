get '/' do
  haml :index
end

# error pages
not_found do
  haml :'404'
end

error do
  haml :'500'
end

helpers do
  def used_memory
    return '#' if ENV['RACK_ENV'] == 'development' # OS X doesn't have a /proc/meminfo
    
    f = File.new('/proc/meminfo')

    info = {}

    while line = f.gets
      key, val = line.gsub(/ /,'').split(':')
      info[key.downcase.to_sym] = val.gsub(/kB/,'').strip.to_f
    end

    puts ((info[:memtotal] - info[:memfree]) / 1000)
  end
  
  def load_average
    (`uptime`.strip.split(' ').last.to_f * 100).to_i
  end
  
  def uptime
    `uptime`.strip.split(' ')[2]
  end
end