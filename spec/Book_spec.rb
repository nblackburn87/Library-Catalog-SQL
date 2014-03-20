require 'spec_helper'

describe 'Book' do
  describe '#initialize' do
    it 'is initialized with a title and id' do
      test_book = Book.new({'title' => 'Moby Dick'})
      test_book.should be_an_instance_of Book
    end
  end

  describe '==' do
    it 'is the same book if it has the same title' do
      test_book_1 = Book.new({'title' => 'Moby Dick'})
      test_book_2 = Book.new({'title' => 'Moby Dick'})
      test_book_1.should eq test_book_2
    end
  end

  describe '#save' do
    it 'is saved to the database' do
      test_book = Book.new({'title' => 'Moby Dick'})
      test_book.save
      Book.all.should eq [test_book]
    end
  end

  describe '.all' do
    it('should return an array of all books') do
      test_book = Book.new({'title' => 'Moby Dick'})
      test_book.save
      Book.all.should eq [test_book]
    end
  end

  describe 'add_author' do
    it 'associates a book with its author' do
      test_book = Book.new({'title' => 'Moby Dick'})
      test_book.save
      test_author = Author.new({'name' => 'Herman Melville'})
      test_author.save
      test_book.add_author(test_author)
      test_result = DB.exec("SELECT * FROM book_author WHERE book_id = #{test_book.id} AND author_id = #{test_author.id};")
      test_result.first['book_id'].should eq "1"
      test_result.first['author_id'].should eq "1"
    end
  end

  describe 'delete' do
    it 'deletes a book' do
      test_book = Book.new({'title' => 'Moby Dick'})
      test_book.save
      test_book.delete
      Book.all.should eq []
    end
  end
end
