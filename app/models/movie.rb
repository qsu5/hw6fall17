require 'themoviedb'
Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")

class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R NR)
  end
  
class Movie::InvalidKeyError < StandardError ; end

  
  def self.find_in_tmdb(string)
    begin
      moviesFound = Tmdb::Movie.find(string)
      movieHash = Array.new(0)
      if moviesFound!= nil
        for item in moviesFound
          movie = Hash.new
          movie[:tmdb_id] = item.id
          movie[:title] = item.title
          movie[:release_date] = item.release_date
          if movie[:release_date] == nil
            movie[:release_date] = 'N/A'
          end
          movie[:description] = item.overview
  
          data = Tmdb::Movie.releases(item.id)
          if data["countries"] != nil
            if not data["countries"].empty?
              if !(data["countries"].keep_if{|c| c['iso_3166_1'] == 'US'}.empty?)
                movie[:rating] = data["countries"].keep_if{|c| c['iso_3166_1'] == 'US'}[0]['certification']
                if movie[:rating] == ""
                  movie[:rating] = 'NR'
                end
              else
                movie[:rating] = 'NR'
              end
              
            else
              movie[:rating] ='NR'
            end
            movieHash.push(movie)
          end
        end
      end
      
      return movieHash
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.create_from_tmdb(id)
    movieparams = Hash.new()
    data = Tmdb::Movie.detail(id)
    movieparams[:title] = data["title"]
    movieparams[:release_date] = data["release_date"]
    movieparams[:description] = data["overview"]
    
    data2 = Tmdb::Movie.releases(id)
    if data2["countries"] != nil
      if !(data2["countries"].keep_if{|c| c['iso_3166_1'] == 'US'}.empty?)
        movieparams[:rating] = data2["countries"].keep_if{|c| c['iso_3166_1'] == 'US'}[0]['certification']
        if movieparams[:rating] == ""
          movieparams[:rating] = 'NR'
        end
      else
        movieparams[:rating] ='NR'
      end
    end
    self.create!(movieparams) 
  end

end
