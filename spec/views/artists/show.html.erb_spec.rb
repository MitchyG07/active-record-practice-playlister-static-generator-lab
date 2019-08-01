require "spec_helper"

describe "artists/show.html.erb", type: :view do
  let(:abs_path) { "#{Dir.pwd}/app/views" }
  let(:html) { File.read("#{abs_path}/artists/show.html.erb") }

  before(:each) do
    @extra_artist = Artist.create(name: "Daft Punk")
    # adding extra instance to prevent .all.first solutions
    rand(5).times do
      Artist.create(name: "test_artist")
      Genre.create(name: "test_genre")
      Song.create(name: "test_song", artist: Artist.all.last, genre: Genre.all.last)
    end
    @extra_genre = Genre.create(name: "electronic")
    @artist = Artist.create(name: "Taylor Swift")
    @genres = [
      Genre.create(name: "country"),
      Genre.create(name: "pop")
    ]
    @songs = [
      Song.create(name: "Our Song", genre: @genres[0], artist: @artist),
      Song.create(name: "Blank Space", genre: @genres[1], artist: @artist)
    ]
    @extra_song = Song.create(name: "Aerodynamic", genre: @extra_genre, artist: @extra_artist)
  end

  after(:each) do
    @songs.each { |s| s.delete }
    @genres.each { |g| g.delete }
    @artist.delete
  end

  let(:rendered) { ERB.new(html).result(binding) }

  it "displays the artist's name" do
    expect(rendered).to match(/Taylor Swift/)
  end

  it "displays the artist's genres" do
    expect(rendered).to match(/country/)
    expect(rendered).to match(/pop/)
    expect(rendered).to match(/genres\/country\.html/)
    expect(rendered).to match(/genres\/pop\.html/)
  end

  it "displays the artist's songs" do
    expect(rendered).to match(/songs\/blank-space\.html/)
    expect(rendered).to match(/songs\/our-song\.html/)
    expect(rendered).to match(/Taylor Swift - Blank Space - pop/)
    expect(rendered).to match(/Taylor Swift - Our Song - country/)
  end
end
