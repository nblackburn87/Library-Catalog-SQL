require 'spec_helper'

describe 'Copy' do
  describe '#initialize' do
    it 'is initialized with a book_id and id' do
      test_copy = Copy.new({'book_id' => '1'})
      test_copy.should be_an_instance_of Copy
    end
  end

  describe '==' do
    it 'is the same copy if it has the same book_id' do
      test_copy_1 = Copy.new({'book_id' => '1'})
      test_copy_2 = Copy.new({'book_id' => '1'})
      test_copy_1.should eq test_copy_2
    end
  end

  describe '#save' do
    it 'is saved to the database' do
      test_copy = Copy.new({'book_id' => '1'})
      test_copy.save
      Copy.all.should eq [test_copy]
    end
  end

  describe '.all' do
    it('should return an array of all copys') do
      test_copy = Copy.new({'book_id' => '1'})
      test_copy.save
      Copy.all.should eq [test_copy]
    end
  end
end
