# frozen_string_literal: true

module Goodreads
  URI = 'https://www.goodreads.com'
  API_KEY = ENV.fetch 'GOODREADS_API_KEY'
  SECRET  = ENV.fetch 'GOODREADS_SECRET'

  module_function

  def get_books path
    HTTP.persistent URI do |http|
      doc = Nokogiri::XML http.get(path).body

      number_of_pages = doc.xpath('//books').first['numpages'].to_i

      1.upto(number_of_pages).flat_map do |page|
        "Fetching page #{page}..."
        doc = Nokogiri::XML http.get("#{path}&page=#{page}").body
        isbns = doc.xpath('//isbn').children.map &:text
        image_urls = doc.xpath('//book/image_url').children.map(&:text).grep_v /\A\n\z/
        titles = doc.xpath('//title').children.map &:text
        isbns.zip(image_urls, titles)
      end
    end
  end
end
