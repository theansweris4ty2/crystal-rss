#|RSS Reader Written in Crystal

require "http/server" 
require "xml"
require "colorize"



feeds = [] of String
File.each_line("feeds.config") do |line|
    feeds << line
end


feeds.each do |feed|
    response = HTTP::Client.get("#{feed}")
    xml_data = response.body
    document = XML.parse(xml_data)
    items = document.xpath_nodes("//item")

    items.each do |node|
        title = node.xpath_node("title").try(&.text).colorize(:blue).mode(:Bright)
        description = node.xpath_node("description").try(&.text).colorize(:white).mode(:Italic)
        link = node.xpath_node("link").try(&.text).colorize.mode(:underline)
        article = "\n #{title}: \n \n #{description} \n \n #{link} \n"
        puts article
    end
end
