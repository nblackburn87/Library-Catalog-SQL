class Copy

  attr_reader :book_id, :id

  def initialize(attributes)
    @book_id = attributes['book_id']
    @id = attributes['id']
  end

  def ==(another_book)
    self.book_id == another_book.book_id
  end

  def save
    result = DB.exec("INSERT INTO copies (book_id) VALUES ('#{@book_id}') RETURNING id;")
    @id = result.first['id']
  end

  def self.all
    results = DB.exec('SELECT * FROM copies;')
    copies = []
    results.each do |result|
      copies << Copy.new(result)
    end
    copies
  end

  def delete
    DB.exec("DELETE FROM copies WHERE id = #{@id};")

  end
end
