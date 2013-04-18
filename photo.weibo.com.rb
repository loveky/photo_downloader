# encoding: UTF-8

require 'mechanize'
require "json"
require "base64"
require 'uri'
require 'optparse'

require_relative "./helper"

options = {}
OptionParser.new do |opts|
    opts.on('--user USERNAME', 'Weibo account username') do |value|
        options[:user] = value
    end
    opts.on('--pass PASSWORD', 'Weibo account password') do |value|
        options[:pass] = value
    end
    opts.on('--url URL', 'album URL') do |value|
        options[:url] = value
    end
end.parse!

logger            = Logger.new(STDOUT)
DEBUG             = true
download_interval = 3

xiangceUrl = options[:url]
agent = weibo_login(options[:user], options[:pass])
if agent == nil
    logger.error("Cannot login weibo, exiting...")
end

# Get album ID & user ID
if xiangceUrl =~ /\.com\/(\d+)\/albums\/detail\/album_id\/(\d+)#!\//
    albumID = Regexp.last_match[2]
    userID  = Regexp.last_match[1]       
    logger.info("Got album ID : #{albumID}") if DEBUG
    logger.info("Got user  ID : #{userID}") if DEBUG
else
    logger.error("Could not find albumID or userID, exiting...")
    exit
end

# Get album info, like name, photo numbers...
albumListUrl = "http://photo.weibo.com/albums/get_all?uid=" + userID + "&count=1000&page=1"
albumList    = JSON.parse(agent.get(albumListUrl).body)

album = albumList['data']['album_list'].select { |a| a['album_id'] == albumID }
album = album[0]

albumName = album['caption']
albumPhotoNumber = album['count']['photos'].to_i
logger.info("Got album name : #{albumName}")
logger.info("Find #{albumPhotoNumber} photos in current album")

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

(1 .. (albumPhotoNumber / 30.0).ceil).each do |page_number|
    page_url = 'http://photo.weibo.com/photos/get_all?uid=' + userID + '&album_id=' + albumID + '&count=30&page=' + page_number.to_s + '&type=1'
    photoList = JSON.parse(agent.get(page_url).body)

    photoList['data']['photo_list'].each do |photo|
        photo_src = photo['pic_host'] + "/mw690/" + photo['pic_name']

        logger.info("Saving #{photo_src} to " + photo_folder + "/#{photo['pic_name']}")
        unless save_photo(photo_folder + "/#{photo['pic_name']}", photo_src, agent)
            logger.error("Failed to save #{photo['pic_name']}")
        end

        $photo_info_file.puts "#{photo['photo_id']},#{photo['pic_name']},#{photo['caption']}"
        sleep download_interval
    end
end

$photo_info_file.close