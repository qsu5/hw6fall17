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
    
    it 'should redirct user' do 
      allow(Movie).to receive(:find_in_tmdb).with('invalid').and_return([])
      expect(post :search_tmdb,{:search_terms => 'invalid'}).to redirect_to movies_path
    end
    
    it 'should check the user input' do
      expect(post :search_tmdb,{:search_terms => ""}).to redirect_to movies_path
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
      expect(post :add_tmdb, {:tmdb_movies =>{'12345'=>'1'}}).to redirect_to movies_path
    end  
    
    it 'should to get an success message' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:create_from_tmdb).and_return(fake_results)
      post :add_tmdb, {:tmdb_movies =>{'12345'=>'1'}}
      expect(flash[:notice]).to eq("Movies successfully added to Rotten Potatoes")
    end  
    
    it 'should redirect to index if did not choose anything' do
      allow(Movie).to receive(:create_from_tmdb)
      expect(post :add_tmdb, {:tmdb_movies => nil}).to redirect_to movies_path
      expect(flash[:notice]).to eq("No movies selected")
    end
  end
  
  describe 'showing index' do
    it 'should list movies giving in index in the database'do
      fake_movie = double('Movies')
      expect(Movie).to receive(:where).with(rating: "PG").and_return(fake_movie)
      post :index, {:ratings => ["PG"]}
    end
  end
  
  describe 'show' do
    it 'should find the movie when show' do
      expect(Movie).to receive(:find).with('1')
      post :show, {:id => '1'}
    end
  end
  
  describe 'create' do
    it 'should create a movie' do
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      fake_movie = double({:title => "aa"})
      expect(Movie).to receive(:create!).and_return(fake_movie)
      post :create, {:movie => fake_movieparam}
    end
    it 'should generate flash' do
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      fake_movie = double({:title => "aa"})
      allow(Movie).to receive(:create!).and_return(fake_movie)
      post :create, {:movie => fake_movieparam}
      expect(flash[:notice]).to eq("aa was successfully created.")
    end
    it'should redirect to movie index'   do 
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      fake_movie = double({:title => "aa"})
      allow(Movie).to receive(:create!).and_return(fake_movie)
      expect(post :create, {:movie => fake_movieparam}).to redirect_to movies_path
    end
  end
  
  describe 'edit' do
    it 'should call find function' do
      expect(Movie).to receive(:find).with("1")
      post :edit, {:id => "1"}
    end
  end
  
  describe 'update' do
    it 'should call find function' do 
      fake_movie = double({:title => "aa"})
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      allow(fake_movie).to receive(:update_attributes!)
      expect(Movie).to receive(:find).with("1").and_return(fake_movie)
      post :update, {:id => "1",:movie =>fake_movieparam}
    end
    
    it 'should call update_attributes function' do
      fake_movie = double({:title => "aa"})
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      allow(Movie).to receive(:find).with("1").and_return(fake_movie)
      expect(fake_movie).to receive(:update_attributes!)
      post :update, {:id => "1",:movie =>fake_movieparam}
    end
    
    it 'should call flash note' do
      fake_movie = double({:title => "aa"})
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      allow(Movie).to receive(:find).with("1").and_return(fake_movie)
      allow(fake_movie).to receive(:update_attributes!)
      post :update, {:id => "1",:movie =>fake_movieparam}
      expect(flash[:notice]).to eq "aa was successfully updated."
    end
    
  end  
  
  describe 'destroy' do
    it 'should call find function' do 
      fake_movie = double({:title => "aa"})
      fake_movieparam = {:title => "aa", :release_date =>" ", :description =>" ", :rating => " "}
      allow(fake_movie).to receive(:destroy)
      expect(Movie).to receive(:find).with("1").and_return(fake_movie)
      post :destroy, {:id => "1",:movie =>fake_movieparam}
    end
  end
end
