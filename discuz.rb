# encoding: UTF-8
require_relative "./helper"
require "nokogiri"

logger            = Logger.new(STDOUT)
DEBUG             = true
download_interval = 3

xiangceUrl = ARGV[0]

# Get topic ID
if xiangceUrl =~ /([^\/]*)\/thread-(\d+)-\d+-(\d+)\.html/ 
    siteURL = Regexp.last_match[1]
    topicID = Regexp.last_match[2]
    magicID = Regexp.last_match[3]   
    logger.info("Got topic ID : #{topicID}") if DEBUG
else
    logger.error("Could not get topic ID, exiting...")
    exit
end

# Get total page number
page = Nokogiri::HTML(open(tidy_url(xiangceUrl)))
if page.css("div#pgt a.last").text =~ /(\d+)/
    topicPageNumber = Regexp.last_match[1].to_i
    logger.info("Found #{topicPageNumber} pages in current topic")
else
    logger.error("Could not get topic pages number, exiting...")
end

# Get topic name and create directory
topicName = page.css("a#thread_subject").text
if Dir.exist?(topicName)
    logger.info("Using existing local directory [#{topicName}] to store photos")
else 
    Dir.mkdir(topicName)
    logger.info("Creating local directory [#{topicName}] to store photos")
end

photo_folder = topicName + "/photos"
Dir.mkdir(photo_folder) unless Dir.exist?(photo_folder)

# Save album Url to file
File.open(topicName + "/topicURL.txt", "w") do |f|
    f << xiangceUrl
end

# Process each topic page

(1 .. topicPageNumber).each do |page_number|
    page_url = siteURL + "/thread-#{topicID}-#{page_number.to_s}-#{magicID}.html"
    logger.info("Process page #{page_number} : #{page_url}")

    page = Nokogiri::HTML(open(tidy_url(page_url)))

    page.css("div.t_fsz img.zoom").each do |photo|
        next if photo['zoomfile'] == nil

        photo_src = siteURL + '/' + photo['zoomfile']
        photo_filename  = photo_src.split("/").last

        logger.info("Saving #{photo_src}")
        unless save_photo(photo_folder + "/#{photo_filename}", tidy_url(photo_src))
            logger.error("Failed to save #{photo_filename}!")
        end

        sleep download_interval
    end
end