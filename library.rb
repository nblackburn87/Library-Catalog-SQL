require 'pg'
require './lib/Author'
require './lib/Book'
require './lib/Gets_override'
require './lib/Copies'


DB = PG.connect({:dbname => 'library'})

def welcome
  puts "Welcome to the Library!"
  main_menu
end

def main_menu
  puts "L - Login as a librarian"
  puts "P - Login as a Patron"
  puts "X - Exit"

  case gets.chomp.upcase
  when "L"
    librarian
  when "P"
    patron
  when "X"
    puts "Goodbye"
  else
    puts 'Invalid input'
    main_menu
  end
end

def librarian
  puts "C - Create a book"
  puts "L - List books"
  puts "S - Search for a book"
  puts "X - Go back"

  case gets.chomp.upcase
  when "C"
    add_book
  when "L"
    list_books
    puts "Enter a book number to view it's info."
    selected_book = Book.all[(gets.chomp.to_i-1)]
    selected_book.view
    lib_book_options(selected_book)
  when "S"
    puts "T - Search by title"
    puts "A - Search by author"

    case gets.chomp.upcase
    when "T"
      puts "What is the title of the book you're looking for?"
      Book.search(gets.chomp)
    when "A"
      puts "What is the name of the author who wrote your book?"
      Author.search(gets.chomp)
    else
      puts 'Invalid input'
    end
    librarian
  when "X"
    main_menu
  else
    puts "Invalid Input"
    librarian
  end
end

def patron

end

def add_book
  puts "What is this book's title?"
  user_input = gets.chomp
  puts "What is this book's author?"
  author_input = gets.chomp
  author = Author.check(author_input)
  new_book = Book.new({'title' => user_input})
  new_book.save
  new_book.add_author(author)
  puts "Does this book have another author (y/n)?"
  while gets.chomp == "y"
    puts "What is the author's name?"
    author_input = gets.chomp
    author = Author.check(author_input)
    new_book.add_author(author)
    puts "Does this book have another author (y/n)?"
  end
  puts "How many copies of this book do you have?"
  number_input = gets.chomp.to_i
  while number_input > 0
    new_copy = Copy.new({'book_id' => new_book.id})
    new_copy.save
    number_input -= 1
  end
  librarian
end

def list_books
  Book.all.each_with_index do |book, index|
    puts "#{index + 1}: #{book.title}"
  end
end

def lib_book_options(selected_book)
  puts "D - Delete this book"
  puts "T - Edit this book's title"
  puts "R - Remove an author from this book"
  puts "A - Add an author to this book"
  puts "N - Add a number of copies of this book"
  puts "L - List all the copies of this book"
  puts "DC - Delete a copy"
  puts "X - Go back"

  case gets.chomp.upcase
  when 'D'
    selected_book.delete
    librarian
  when 'T'
    puts "What should the new title be?"
    selected_book.edit_title(gets.chomp)
    selected_book.view
    lib_book_options(selected_book)
  when "A"
    puts "Name the author you want to add"
    named_author = gets.chomp
    author = Author.check(named_author)
    selected_book.add_author(author)
    selected_book.view
    lib_book_options(selected_book)
  when 'R'
    puts "Remove which author from this book?"
    author_name = gets.chomp
    selected_book.remove_author(author_name)
    selected_book.view
    lib_book_options(selected_book)
  when 'N'
    puts 'How many copies do you want to add?'
    copy_number = gets.chomp.to_i
    while copy_number > 0
      new_copy = Copy.new({'book_id' => selected_book.id})
      new_copy.save
      copy_number -= 1
    end
    selected_book.view
    lib_book_options(selected_book)
  when 'L'
    Copy.all.each do |copy|
      if copy.book_id == selected_book.id
        puts copy.id
      end
    end
    selected_book.view
    lib_book_options(selected_book)
  when 'DC'
    puts "Which copy would you like to delete? (integer)"
    copy_to_delete = gets.chomp
    new_copy = Copy.new({'book_id' => selected_book.id, 'id' => copy_to_delete})
    new_copy.delete
  when 'X'
  else
    puts 'Invalid input'
    lib_book_options(selected_book)
  end
end


main_menu
