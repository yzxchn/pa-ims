require "minitest/autorun"
require "minitest/spec"

require "./music_info.rb"
require "pstore"

class MusicStorage

	def initialize(artistStorage, trackStorage)
		@artists = PStore.new(artistStorage)
		@tracks = PStore.new(trackStorage)

		@tracks.transaction do
			# if a list of tracks does not exist in tracks
			@tracks.abort unless @tracks[:track_list].nil?

			@tracks[:track_list] = Array.new
			@tracks[:last_played] = Array.new
		end

		@artists.transaction do
			# if a list of artists does not exist in artists
			@artists.abort unless @artists[:artist_list].nil?
			@artists[:artist_list] = Array.new
		end

	end

	def addArtist(name, artistID)
		#create artist object
		artist = Artist.new(name, artistID)
		#associate artist ID with artist object
		@artists.transaction do
			@artists.abort unless @artists[artistID].nil?
			@artists[artistID] = artist
			#also add reference to artist object to a list
			@artists[:artist_list].push(artist)
		end
	end

	def addTrack(trackName, trackNumber, artistID)
		#create a Track object
		track = Track.new(trackName, trackNumber, artistID)
		#associate track with the artist
		@artists.transaction {@artists[artistID].tracks.push(track)}
		#put it in the storage of music tracks
		@tracks.transaction do
			@tracks[trackNumber] = track
			#add reference to a list
			@tracks[:track_list].push(track)
		end
	end

	def playTrack(trackNumber)
		# add the track being played to the play history list
		@tracks.transaction do
			playHistory = @tracks[:last_played]
			track = @tracks[trackNumber]
			# add it to the beginning of the list
			playHistory.unshift(track)
			# if the list size is too long, remove the oldest(last) track played
			if playHistory.size > 3
				playHistory.pop
			end
		end
	end

	def getTrack(trackNumber)
		# get track by track number
		if !hasTrack(trackNumber)
			raise "Unknown track number"
		else
		    return @tracks.transaction {@tracks[trackNumber]}
		end
	end

	def getArtist(artistID)
		# get artist object with id
		if !hasArtistID(artistID)
			raise "Unknow artist ID"
		else
			return @artists.transaction {@artists[artistID]}
		end
	end

	def getTracksBy(artistID)
		return @artists.transaction {@artists[artistID].tracks}
	end

	def getLastPlayed()
		return @tracks.transaction {@tracks[:last_played]}
	end

	def hasArtistID(artistID)
		return !@artists.transaction {@artists[artistID].nil?}
	end

	def hasTrack(trackNumber)
		return !@tracks.transaction {@tracks[trackNumber].nil?}
	end

	def getTotalTrackCount()
		return @tracks.transaction {@tracks[:track_list].size}
	end

	def getTotalArtistCount()
		return @artists.transaction {@artists[:artist_list].size}
	end
end



describe "MusicStorage" do
	it "interface for interacting with the data storage" do
		s = MusicStorage.new("test_artists.pstore", "test_tracks.pstore")
		s.addArtist("Test Artist", "ta")
		s.addTrack("Test Track", "3", "ta")
		s.playTrack("3")

		s.getTrack("3").name.must_equal "Test Track"
		s.getArtist("ta").name.must_equal "Test Artist"
		s.getTracksBy("ta").size.must_equal 1
		s.getLastPlayed[0].name.must_equal "Test Track"
		s.hasArtistID("tz").must_equal false
		s.hasTrack("3").must_equal true
		s.getTotalTrackCount.must_equal 1
		s.getTotalArtistCount.must_equal 1
	end
end