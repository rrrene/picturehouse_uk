require_relative '../../test_helper'

describe PicturehouseUk::Screening do

  before { WebMock.disable_net_connect! }

  describe '#new film_name, cinema_name, date, time, variant' do
    it 'stores film_name, cinema_name & when (in UTC)' do
      screening = PicturehouseUk::Screening.new 'Iron Man 3', "Duke's At Komedia", Time.parse('2013-09-12 11:00')
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal "Duke's At Komedia"
      screening.when.must_equal Time.utc(2013, 9, 12, 10, 0)
      screening.variant.must_equal nil
    end

    it 'stores variant if passed' do
      screening = PicturehouseUk::Screening.new 'Iron Man 3', "Duke's At Komedia", Time.utc(2013, 9, 12, 11, 0), 'baby'
      screening.film_name.must_equal 'Iron Man 3'
      screening.cinema_name.must_equal "Duke's At Komedia"
      screening.when.must_equal Time.utc(2013, 9, 12, 11, 0)
      screening.variant.must_equal 'baby'
    end
  end

  describe '#date' do
    subject { PicturehouseUk::Screening.new('Iron Man 3', "Duke's At Komedia", Time.utc(2013, 9, 12, 11, 0), '3d').date }
    it 'should return date of showing' do
      subject.must_be_instance_of(Date)
      subject.must_equal Date.new(2013, 9, 12)
    end
  end

  describe '#varient (DEPRECATED)' do
    subject { screening.varient }
    let(:screening) { PicturehouseUk::Screening.new('Iron Man 3', "Duke's At Komedia", Time.utc(2013, 9, 12, 11, 0), '3d') }

    it 'should return variant' do
      subject.must_equal '3d'
    end
  end
end
