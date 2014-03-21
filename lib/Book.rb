class Book

  attr_reader :id
  attr_accessor :title

  def initialize(attributes)
    @title = attributes['title']
    @id = attributes['id']
  end

  def ==(another_book)
    self.title == another_book.title
  end

  def save
    result = DB.exec("INSERT INTO book (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first['id']
  end

  def self.all
    results = DB.exec('SELECT * FROM book;')
    books = []
    results.each do |result|
      books << Book.new(result)
    end
    books
  end

  def add_author(author)
    result = DB.exec("INSERT INTO book_author (book_id, author_id) VALUES (#{@id}, #{author.id});")
  end

  def delete
    DB.exec("DELETE FROM book WHERE id = #{@id};")
  end

  def delete_author(inputted_author)
    DB.exec("DELETE FROM book_author WHERE author_id = #{inputted_author} AND book_id = #{@id}")
  end

  def view
    puts "Title: #{@title}"
    results = DB.exec("SELECT name FROM author JOIN book_author ON (author.id = book_author.author_id) WHERE book_id = #{@id};")
    results.each do |author|
      puts "Author: #{author['name']}"
    end
    copies = DB.exec("SELECT * FROM copies WHERE book_id = #{@id}")
    puts "Number of Copies Available: #{copies.count.to_i}"
    puts "\n"
  end

  def edit_title(user_input)
  @title = user_input
  DB.exec("UPDATE book SET title = '#{@title}' WHERE id = #{@id};")
  end

  def remove_author(author_name)
    author = DB.exec("SELECT author_id FROM book_author JOIN author ON (author.id = book_author.author_id) WHERE book_id = #{@id} AND author.name = '#{author_name}';")
    DB.exec("DELETE FROM book_author WHERE author_id = #{author.first['author_id']} AND book_id = #{@id};")
  end

  def self.search(user_input)
    results = DB.exec("SELECT * FROM book WHERE title LIKE '%#{user_input}%';")
    results.each do |result|
      puts "#{result['title']}"
      puts "\n"
    end
  end
end
