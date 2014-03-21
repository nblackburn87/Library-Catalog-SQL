class Author

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes['name']
    @id = attributes['id']
  end

  def ==(another_author)
    self.name == another_author.name
  end

  def save
    result = DB.exec("INSERT INTO author (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first['id']
  end

  def self.all
    results = DB.exec('SELECT * FROM author;')
    authors = []
    results.each do |result|
      authors << Author.new(result)
    end
    authors
  end

  def self.check(author_input)
    Author.all.each do |author|
      if author_input == author.name
        return author
      end
    end
    new_author = Author.new({'name' => author_input})
    new_author.save
    new_author
  end

  def self.search(user_input)
    results = DB.exec("SELECT book.title FROM author JOIN book_author ON (author.id = book_author.author_id) JOIN book ON (book_author.book_id = book.id) WHERE author.name LIKE '%#{user_input}%';")
    results.each do |result|
      puts "#{result['title']}"
      puts "\n"
    end
  end
end
