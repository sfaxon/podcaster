xml.instruct! :xml, :version => "1.0", :encoding => "utf-8"
xml.rss("version" => "2.0", 
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
       "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
   "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd") {
  xml.channel{
    xml.title(@podcast["title"])
    xml.description(@podcast["description"])
    
    xml.itunes :summary, @podcast["description"]
    
    xml.itunes :author, @podcast["author"]
    xml.itunes :explicit, "no"
    xml.itunes :image, :href => "http://localhost:4567/podcasts/#{params[:splat]}/podcast.jpg"
    
    xml.lastBuildDate(Time.now.strftime("%a, %d %b %Y %H:%M:%S %z"))
    xml.language('en-us')
    @podcast[:items].each_with_index do |item, index|
      xml.item do
        mp3 = ::Mp3Info.open("public/#{item}")
        xml.title   mp3.tag.title
        xml.link    "http://localhost:4567/#{item.gsub(" ", "%20")}"
        xml.pubDate File.mtime("public/#{item}").strftime("%a, %d %b %Y %H:%M:%S %z")
        xml.tag!("dc:creator", @podcast["author"])
        xml.guid    "http://localhost:4567/#{item.gsub(" ", "%20")}"
        xml.description mp3.tag.comments
        xml.enclosure         :url => "http://localhost:4567/#{item.gsub(" ", "%20")}", #fixme, hard coded link
                              :length => File.size("public/#{item}"),
                              :type => "audio/mpeg"
      end
    end
  }
}
