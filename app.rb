require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'


get '/' do
  erb :home
end

get '/about' do
  @error = "Somthing wrong!!!"
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

get '/admin' do
  erb :admin
end

post '/home' do
  @login = params[:login]
  @password = params[:password]

  if @login == 'admin' && @password == 'secret'
    erb :admin
  elsif @login == 'admin' && @password == 'admin'
    @denied = 'Ха-ха-ха, хорошая попытка. Доступ запрещён!'
    erb :home
  else
    @denied = 'Доступ запрещён!'
    erb :home
  end

end

post '/visit' do
  @username = params[:username]
  @phone = params[:phone]
  @datetime = params[:datetime]
  @hairdresser = params[:hairdresser]
  @color = params[:color]

  hh = { username: 'Введите имя', phone: 'Ввелите телефон',
         datetime: 'Введите дату и время', }

  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  client = File.open './public/client.txt', 'a'
  client.write "Name: #{@username}, phone: #{@phone}, time: #{@datetime}\nHairdresser: #{@hairdresser}\nColor: #{@color}\n"
  client.close

  erb :visit
end

post '/contacts' do
  @mail = params[:mail]
  @textbox = params[:textbox]

  cont = File.open './public/contacts.txt', 'a'
  cont.write "Mailing address #{@mail}. \nMessage:\n#{@textbox}\n"
  cont.close

  erb :contacts
end



