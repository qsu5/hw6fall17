
describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      it 'should convert the result into hashes' do
        expect(Movie.find_in_tmdb('Inception').class).to equal(Array)
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  
  describe 'create movies into database' do
    context 'valid id' do
      it 'should create a movie' do
        fake_movie = {:title=>nil, :release_date=>nil, :description=>nil}
        expect(Movie).to receive(:create!).with(fake_movie)
        Movie.create_from_tmdb('12345')
      end
      
      it 'should find US rating if the rating is not NR' do 
        allow(Movie).to receive(:create!)
        expect(Movie.create_from_tmdb('181808')[:rating]).to eq("NR")
      end
    end
  end
        
end
