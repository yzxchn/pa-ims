require "minitest/autorun"
require "minitest/spec"

# class for storing information for an artist
class Artist
	def initialize(name, id)
		@name = name
		@id = id
		@tracks = Array.new
	end

	attr_reader :name
	attr_reader :id
	attr_accessor :tracks
end

# class for storing information for a track
class Track
	def initialize(name, number, artist_id)
		@name = name
		@number = number
		@artist_id = artist_id
	end

	attr_reader :name
	attr_reader :number
	attr_reader :artist_id
end



# Unit test
describe "Artist" do
	it "stores artist information" do
		a = Artist.new("Joe Hisaishi","jh")
		a.name.must_equal "Joe Hisaishi"
		a.id.must_equal "jh"
		a.tracks.size.must_equal 0
	end
end

describe "Track" do
	it "stores track information" do
		a = Track.new("One Summer's Day","2", "jh")
		a.name.must_equal "One Summer's Day"
		a.number.must_equal "2"
		a.artist_id.must_equal "jh"
	end
end