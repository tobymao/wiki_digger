module Extractor
  module Page
    def self.title_map page_xml
      title = humanize_title page_xml.title.text
      text = page_xml.locate('revision/text')[0].text
      main_title = redirect_title text
      main_title ||= title
      main_title != title ? main_title : title
      [page_xml.id.text.to_i, title, main_title]
    end

    private
    def self.humanize_title title
      # remove camel case
      title.gsub! /([A-Z\s])+/, ' \1'
      title.downcase!
      title.strip!
      title
    end

    def self.redirect_title text
      # check if the text is just a redirect
      # then extract it
      match = text.match /^#REDIRECT \[\[(.*?)\]\]/
      match[1].strip.downcase if match
    end
  end
end
