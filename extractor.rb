require 'ox'
require 'csv'
Dir["./extractor/**/*.rb" ].each { |file| require file }

DUMP_PATH = '/Users/toby/Downloads/enwiki-20160501-pages-articles-multistream.xml.bz2'

module Extractor
  def self.extract dump_path
    maps_io = CSV.open("/Users/toby/Desktop/maps.csv", "w")
    links_io = CSV.open("/Users/toby/Desktop/links.csv", "w")

    parser = Page.new maps_io, links_io
    i = 0

    IO.popen("bzip2 -c -d #{dump_path}") do |io|
      page = false
      buf = ''

      io.each do |line|
        if /<page>/ =~ line
          page = true
          i = i + 1
        elsif /<\/page>/ =~ line
          page = false
          buf << line

          parser.parse buf

          buf = ''
        end

        buf << line if page

        break if i > 10000
      end
    end

    maps_io.close
    links_io.close
  end
end

if __FILE__ == $0
  time = Time.now
  Extractor.extract DUMP_PATH
  puts "Took: #{Time.now - time} seconds"
end
