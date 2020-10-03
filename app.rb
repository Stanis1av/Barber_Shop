require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  db = SQLite3::Database.new 'BarberShop.db'
  db.results_as_hash = true
  db
end

def is_barber_exists? db, name
  db.execute('select *from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
  barbers.each do |barber|
    if !is_barber_exists? db, barber
      db.execute 'insert into Barbers (name) values (?)', [barber]
    end
  end
end

before do
  db = get_db
  @barbers = db.execute 'select * from Barbers'
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

  db.execute 'CREATE TABLE IF NOT EXISTS
  "Barbers"
  ( "id" INTEGER,
   "name" TEXT,
        PRIMARY KEY("id" AUTOINCREMENT)
        )'

  seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehramantraut']

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

  @results = db.execute 'SELECT * FROM Users ORDER BY Id desc'

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

  erb "<h2>Спасибо! Вы записались.</h2>"
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



