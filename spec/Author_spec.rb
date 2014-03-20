require 'spec_helper'

describe 'author' do
  describe '#initialize' do
    it 'is initialized with a title and id' do
      test_author = Author.new({'name' => 'Herman Melville'})
      test_author.should be_an_instance_of Author
    end
  end

  describe '==' do
    it 'is the same author if it has the same title' do
      test_author_1 = Author.new({'name' => 'Herman Melville'})
      test_author_2 = Author.new({'name' => 'Herman Melville'})
      test_author_1.should eq test_author_2
    end
  end

  describe '#save' do
    it 'is saved to the database' do
      test_author = Author.new({'name' => 'Herman Melville'})
      test_author.save
      Author.all.should eq [test_author]
    end
  end

  describe '.all' do
    it('should return an array of all authors') do
      test_author = Author.new({'name' => 'Herman Melville'})
      test_author.save
      Author.all.should eq [test_author]
    end
  end

  describe '.check' do
    it('checks to see if an author exists and returns it') do
      test_author = Author.new({'name' => 'Herman Melville'})
      test_author.save
      Author.check('Herman Melville').should eq test_author
    end
    it('creates a new author if the inputted author does not exist') do
      new_author = Author.check('Herman Melville')
      new_author.name.should eq 'Herman Melville'
    end
  end

end
