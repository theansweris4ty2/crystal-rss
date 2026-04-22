#|RSS Reader Written in Crystal

require "http/server" 
require "xml"
require "colorize"
# require "markdown"


response = HTTP::Client.get("https://feeds.bbci.co.uk/news/rss.xml")

xml_data = response.body

document = XML.parse(xml_data)

items = document.xpath_nodes("//item")

items.each do |node|
    title = node.xpath_node("title").try(&.text[2..])
    description = node.xpath_node("description").try(&.text)
    link = node.xpath_node("link").try(&.text)
    article = "#{title}:#{description}#{link}"
    File.open("feed.md", "a") do |file|
        file.print article
    end
end