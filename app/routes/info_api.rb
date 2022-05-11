class MoocApi < Sinatra::Application

  get '/' do
    @units = University.cached_all
    i18n_erb(:index, layout: :main)
  end

  post '/add' do
    case (params.delete(:type))
      when 'program' then Program.append!(params)
      when 'bailee'  then Bailee.append!(params)
    else
      Demand.append!(params)
    end

    i18n_erb(:greetings, layout: request.xhr? ? nil : :main)
  end

  get '/rector' do
    @units = University.cached_all
    erb(:rector, layout: :rector_layout)
  end

  get '/ping' do
    [200, (University.last_updated || 'never').to_s]
  end

  get '/reset' do
    University.reset_cache
    redirect '/'
  end


  if MoocApi.settings.cache_ttl.to_i > 0
  Thread.new do
    while true do
      University.cached_all(true)
      sleep MoocApi.settings.cache_ttl.to_i*3/4
    end
  end
  else
    puts 'Cache disabled. Set cache_ttl (in seconds) to enable.'
  end

end