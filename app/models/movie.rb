class Movie < ActiveRecord::Base
    def self.ratings
        ##we need to define ratings so that we can use it
        ##select the didderent ratings that are distinct and put them into our arrays
        Movie.select(:rating).distinct.inject([]) {|a, m| a.push m.rating}
    end
    
end
