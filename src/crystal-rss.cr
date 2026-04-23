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
    channel = document.xpath_nodes("//channel")
    channel.each do |node|
        title = node.xpath_node("title").try(&.text).colorize(:blue).mode(:bright).mode(:Blink)
        puts "\t \t \t #{title} \n"
    end
    items = document.xpath_nodes("//item")
    

    items.each do |node|
        title = node.xpath_node("title").try(&.text).colorize(:light_green).mode(:bold)
        description = node.xpath_node("description").try(&.text).colorize(:white).mode(:Italic)
        link = node.xpath_node("link").try(&.text).colorize(:light_cyan).mode(:underline).mode(:bright)
        article = "\n #{title}: \n \n #{description} \n \n #{link} \n \n"
        puts "#{article}"
    end
end
