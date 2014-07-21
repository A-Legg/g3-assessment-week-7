require 'sinatra/base'
require 'gschool_database_connection'

require './lib/country_list'

class Application < Sinatra::Application

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV['RACK_ENV'])
  end

  get '/' do
    erb :index
  end

  post '/' do
    @database_connection.sql("INSERT INTO home (name, message) VALUES ('#{params[:name]}', '#{params[:message]}')")
    redirect "/"

  end



  get '/continents' do
    all_continents = CountryList.new.continents
    erb :continents, locals: { continents: all_continents }
  end

  get '/continents/:continent_name' do
    list_of_countries = CountryList.new.countries_for_continent(params[:continent_name])
    erb :countries, locals: { countries: list_of_countries, continent: params[:continent_name] }
  end

  def names
     @database_connection.sql("select name from home")



    end


  def messages
    @database_connection.sql("select message from home")

  end

end