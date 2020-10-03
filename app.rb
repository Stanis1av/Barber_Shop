require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'BarberShop.db'
  db.results_as_hash = true
  db
end

configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS
  "Users"
  ( "id" INTEGER,
   "username" TEXT,
    "phone" TEXT,
     "datestamp" TEXT,
      "hairdresser" TEXT,
       "color" TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
        )'

end

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

get '/showusers' do
  db = get_db
  @results = db.execute 'SELECT * FROM Users'
     # puts "Имя: #{row["username"]}, время записи: #{row["datestamp"]}"
  erb :showusers
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
  @datestamp = params[:datestamp]
  @hairdresser = params[:hairdresser]
  @color = params[:color]

  hh = { username: 'Введите имя', phone: 'Введите телефон',
         datestamp: 'Введите дату и время', }

  @error = hh.select {|key,_| params[key] == ''}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  db = get_db
  db.execute 'INSERT INTO
  Users (
    username,
    phone,
    datestamp,
    hairdresser,
    color
    )
    VALUES
    (?, ?, ?, ?, ?)', [@username, @phone, @datestamp, @hairdresser, @color]

  # erb "OK. Name: #{@username}, phone: #{@phone}, time: #{@datestamp}, Hairdresser: #{@hairdresser}, Color: #{@color}"
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

post '/showusers' do

  erb :showusers
end



