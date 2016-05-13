#require 'oga'
require 'ox'
require 'csv'
Dir["./extractor/**/*.rb" ].each { |file| require file }

FILE_PATH = '/Users/toby/Downloads/enwiki-20160501-pages-articles-multistream.xml.bz2'

#csv = CSV.open("/Users/toby/Desktop/test", "w")
time = Time.now
i = 0
IO.popen("bzip2 -c -d #{FILE_PATH}") do |io|
  page = false
  buf = ''

  io.each do |line|
    if /<page>/ =~ line
      page = true
      i = i + 1
    elsif /<\/page>/ =~ line
      page = false
      buf << line

      page_xml = Ox.parse buf
      title = Extractor::Page.title_map page_xml

      #csv << PageParser.parse(buf)
      buf = ''

      #title =
      #  if redirect = page_xml.locate('redirect')[0]
      #    redirect.title
      #  else
      #    page_xml.title.text
      #  end

      #id = page_xml.id.text
      #ns = page_xml.ns.text
      #text = page_xml.locate('revision/text')[0].text

      #page_obj = Page.new id, ns, title, text
      #puts page_obj.extract
    end

    buf << line if page


    break if i > 10
  end
end

#csv.close

puts "Took #{Time.now - time}"
