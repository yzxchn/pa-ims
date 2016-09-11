require "minitest/autorun"
require "minitest/spec"

require "./music_info"
require "pstore"

class MusicStorage
	def initialize(storage_name)
    @storage = PStore.new(storage_name)
    @storage.transaction do
      if @storage[:tracks].nil?
        @storage[:tracks] = Hash.new
      elsif @storage[:artists].nil?
        @storage[:artists] = Hash.new
      elsif @storage[:last_played].nil?
        @storage[:last_played] = Array.new
      end

      @tracks = @storage[:tracks]
      @artists = @storage[:artists]
      @last_played = @storage[:last_played]
    end
  end

  def save
    @storage.transaction do
      @storage[:tracks] = @tracks
      @storage[:artists] = @artists
      @storage[:last_played] = @last_played
    end
  end

  def add_artist(name, artist_id)
    artist = Artist.new(name, artist_id)
    @artists[artist_id] = artist
  end

  def add_track(track_name, track_number, artist_id)
    track = Track.new(track_name, track_number, artist_id)
    @tracks[track_number] = track
    @artists[artist_id].tracks.push(track)
  end

  def play_track(track_number)
    @last_played.unshift(get_track(track_number))
    if @last_played.size > 3
      @last_played.pop
    end
  end

  def has_track(track_number)
    return @tracks.key?(track_number)
  end

  def has_artist(artist_id)
    return @artists.key?(artist_id)
  end

  def confirm_track_exists(track_number)
    if !@tracks.key?(track_number)
      raise "Unknown track number #{track_number}"
    end
  end

  def confirm_artist_exists(artist_id)
    if !@artists.key?(artist_id)
      raise "Unknown artist id #{artist_id}"
    end
  end

  def get_track(track_number)
    confirm_track_exists(track_number)
    return @tracks[track_number]
  end

  def get_artist(artist_id)
    confirm_artist_exists(artist_id)
    return @artists[artist_id]
  end

  def get_tracks_by(artist_id)
    confirm_artist_exists(artist_id)
    return @artists[artist_id].tracks
  end 

  def get_last_played
    return @last_played
  end

  def get_total_track_count
    return @tracks.size
  end

  def get_total_artist_count
    return @artists.size
  end
end

describe "MusicStorage" do
  it "interface for interacting with the data storage" do
    s = MusicStorage.new("test1.pstore")
    s.add_artist("Test Artist", "ta")
    s.add_track("Test Track", "3", "ta")
    s.play_track("3")

    s.get_track("3").name.must_equal "Test Track"
    s.get_artist("ta").name.must_equal "Test Artist"
    s.get_tracks_by("ta").size.must_equal 1
    s.get_last_played[0].name.must_equal "Test Track"
    s.has_artist("tz").must_equal false
    s.has_track("3").must_equal true
    s.get_total_track_count.must_equal 1
    s.get_total_artist_count.must_equal 1
  end
end