# encoding: UTF-8
require_relative "./helper"
require "nokogiri"

logger            = Logger.new(STDOUT)
DEBUG             = true
download_interval = 3

xiangceUrl = ARGV[0]

# Get album ID
xiangceUrl + "/" =~ /\/album\/(\d*)\//
albumId    = Regexp.last_match[1]
logger.info("Got album ID : #{albumId}") if DEBUG

# Get album photo number
page = Nokogiri::HTML(open(tidy_url(xiangceUrl)))
if page.css("span.count").text =~ /\(\D(\d*)\D\)/
    albumPhotoNumber = Regexp.last_match[1].to_i
    logger.info("Found #{albumPhotoNumber} photos in current album")
else
    logger.error("Could not get album photo number, exiting...")
end

# Get album name and create directory
albumName = page.css("div.info h1")[0].text
if Dir.exist?(albumName)
    logger.info("Using existing local directory [#{albumName}] to store photos")
else 
    Dir.mkdir(albumName)
    logger.info("Creating local directory [#{albumName}] to store photos")
end

photo_folder = albumName + "/photos"
Dir.mkdir(photo_folder) unless Dir.exist?(photo_folder)

# Save album Url to file
File.open(albumName + "/albumUrl.txt", "w") do |f|
    f << xiangceUrl
end

$photo_info_file = File.open(albumName + "/photo_info.txt", "w")

# Process each photo page

(1 .. (albumPhotoNumber / 18.0).ceil).each do |page_number|
    page_url = "http://www.douban.com/photos/album/#{albumId}/?start=" + (18 * page_number - 18).to_s
    logger.info("Process page #{page_number} : #{page_url}")

    page = Nokogiri::HTML(open(page_url))

    page.css("div.photolst div.photo_wrap a.photolst_photo").each do |photo|
        photo_src_large = photo.css("img")[0]['src'].gsub("thumb", "large")
        photo_filename  = photo_src_large.split("/").last
        photo_title     = photo['title']

        logger.info("Saving #{photo_filename} : #{photo_title}")
        save_photo(photo_folder + "/#{photo_filename}", photo_src_large)
        $photo_info_file.puts "#{photo_src_large},#{photo_title}"

        sleep download_interval
    end
end

$photo_info_file.close