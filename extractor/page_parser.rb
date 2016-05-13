require 'ox'

module Extractor
  class PageParser
    def initialize path
      #@file = File.open path, 'w'
    end

    def parse xml
      page_xml = Ox.parse xml
      title = Page.title page_xml
    end

    def extract_text text
      text.scan(/(?<=\[\[).*?(?=\]\])/).map do |link|
        parse_link link
      end.compact
    end

    def parse_link link
      if /^Category/ =~ link
        # drop category from the link
        link[9..-1]
      end
    end
  end
end
