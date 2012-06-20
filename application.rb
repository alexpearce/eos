class Eos < Sinatra::Base
  
  set :haml, :format => :html5, :attr_wrapper => '"'

  get "/" do
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
    def postgres_up
      return false if ENV["RACK_ENV"] == "development" # No PostgreSQL on my OS X
      
      `service postgresql status`.strip == "Running clusters: 9.1/main"
    end
    
    def used_memory
      return "#" if ENV["RACK_ENV"] == "development" # OS X doesn't have a free
    
      `free -m`.split(" ")[-6]
    end
  
    def load_average
      (`uptime`.strip.split(" ").last.to_f * 100).to_i
    end
  
    def uptime
      `uptime`.strip.split(" ")[2]
    end
  end
  
end