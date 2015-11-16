class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G', 'PG', 'PG-13', 'R']
    end
    
    def self.all_ratings_hash
        hash = Hash.new
        all_ratings.each do |rating|
            hash[rating] = "1"
        end
        hash
    end
end
