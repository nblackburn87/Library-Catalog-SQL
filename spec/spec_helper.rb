require 'rspec'
require 'Author'
require 'Book'
require 'Book_author'
require 'Checkouts'
require 'Copies'
require 'Patrons'
require 'pg'

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("TRUNCATE TABLE book RESTART IDENTITY;")
    DB.exec("TRUNCATE TABLE author RESTART IDENTITY;")
    DB.exec("TRUNCATE TABLE book_author RESTART IDENTITY;")
    DB.exec("TRUNCATE TABLE checkouts RESTART IDENTITY;")
    DB.exec("TRUNCATE TABLE copies RESTART IDENTITY;")
    DB.exec("TRUNCATE TABLE patrons RESTART IDENTITY;")
  end
end
