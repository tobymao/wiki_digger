require 'ox'

module Extractor
  class Page
    Map  = Struct.new :id, :title, :target
    Link = Struct.new :title, :link

    def initialize maps_io, links_io
      @maps_io = maps_io
      @links_io = links_io
    end

    def parse xml
      page_xml = Ox.parse xml
      return unless page_xml.ns.text.to_i == 0

      map = extract_title_map page_xml
      return if duplicate? map

      @maps_io << map

      maps = extract_links page_xml, map.title
      maps.each do |m|
        @maps_io << m if m.target
        link = Link.new map.title, m.title
        @links_io << link
      end
    end

    def extract_title_map page_xml
      id = page_xml.id.text.to_i
      title = page_xml.title.text.strip
      target = parse_target page_xml
      Map.new id, title, target
    end

    def extract_links page_xml, title
      text = page_xml.locate('revision/text')[0].text
      text.scan(/(?<=\[\[).*?(?=\]\])/).map do |link|
        parse_link link
      end.compact
    end

    private
    def duplicate? map
      map.target && normalized(map.target) == normalized(map.title)
    end

    def parse_target page_xml
      text = page_xml.locate('revision/text')[0].text
      # check if the text is just a redirect then extract it
      match = text.match /^#REDIRECT \[\[(.*?)\]\]/
      match[1].strip.gsub('_', ' ') if match
    end

    def normalized title
      title.downcase.gsub(/\s+/, '')
    end

    def parse_link link
      title, target = link.split '|'
      Map.new nil, title, target

      #if /^Category/ =~ link
      #  # drop category from the link
      #  link[9..-1]
      #end
    end


  end
end
