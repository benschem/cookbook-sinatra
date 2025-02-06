require "nokogiri"
require "open-uri"

class Search
  def display_search_results(search_results)
    # search_results is an array of arrays
    # [[title, description, rating],[title, description, rating]]
    search_results.each_with_index do |result, index|
      # result is an array [title, description, rating]
      puts "#{index + 1}. #{result[0]}"
    end
  end

  def import_recipes(search_term)
    # Make an HTTP request to the recipe’s website with our keyword
    url = "https://www.allrecipes.com/search/results/?search=#{search_term}"
    html = URI.open(url)
    doc = Nokogiri::HTML(html)

    single_result = []
    search_results = []

    # Parse the HTML document to extract the first 5 recipes suggested and store them in an Array
    for counter in 0..4 do
      title = doc.search(".card__title")
      single_result << title[counter].text.strip
      # single_result ==> [title]

      description = doc.search(".card__summary")
      single_result << description[counter].text.strip
      # single_result ==> [title, description]

      rating = doc.search(".review-star-text") # (Going to return a string "Rating: 4 stars")
      rating_array = rating[counter].text.strip.split
      single_result << rating_array[1]
      # single_result ==> [title, description, rating]

      search_results << single_result
      # search_results ==> [[title, description, rating],[title, description, rating]]
      single_result = []
      # single_result ==> []
    end

    return search_results
  end
end
