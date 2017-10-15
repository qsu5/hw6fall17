require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:newMovie)).to eq(fake_results)
    end 
    
    it 'should check for invalid search terms' do
      allow(Movie).to receive(:find_in_tmdb).with('invalid').and_raise("invalid search term error")
      expect{post :search_tmdb, {:search_terms => 'invalid'}}.to raise_error
      
    end
    
    it 'should redirct user' do 
      allow(Movie).to receive(:find_in_tmdb).with('invalid').and_return([])
      expect(post :search_tmdb,{:search_terms => 'invalid'}).to render_template movies_path
    end
    
    it 'should check the user input' do
      expect(post :search_tmdb,{:search_terms => nil}).to render_template movies_path
    end
    
  end
  
  describe 'add tmdb movies' do
    it 'should call the movie model to performs add' do
      fake_results = [double('id')]
      expect(Movie).to receive(:create_from_tmdb).with('12345').
        and_return(fake_results)
      post :add_tmdb, {:tmdb_movies =>{'12345'=>'1'}}
    end
    
    it 'should iterate all movies for rendering' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:create_from_tmdb).and_return(fake_results)
      post :add_tmdb, {:tmdb_movies =>{'12345'=>'1'}}
      expect(response).to render_template("movies_path")
    end  
    
    it 'should redirect to index if did not choose anything' do
      expect(post :add_tmdb, {:tmdb_movies => nil}).to render_template("movies/index")
    end
  end
  
end
