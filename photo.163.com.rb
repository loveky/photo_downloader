# encoding: UTF-8
require_relative "./helper"

logger            = Logger.new(STDOUT)
DEBUG             = true
download_interval = 3

xiangceUrl = ARGV[0]

# Get album ID
xiangceUrl =~ /aid=(\d*)&/
albumId    = Regexp.last_match[1]
logger.info("Got album ID : #{albumId}") if DEBUG

# Get album list Url
xiangceUrlHtml = get(xiangceUrl)
xiangceUrlHtml.encode!("utf-8", "gbk")

if xiangceUrlHtml =~ /albumUrl : '([^']*)'/
    albumListUrl = Regexp.last_match[1]
    logger.info("Got album list URL : #{albumListUrl}") if DEBUG
else
    logger.error("Could not find album list Url, exiting...") if DEBUG
    exit 
end

# Get photo list URL
albumListUrlHtml = get(albumListUrl)
albumListUrlHtml.encode!("utf-8", "gbk")

if albumListUrlHtml =~ /\{id:#{albumId},name:'([^']*)'[^}]*purl:'([^']*)'/m 
    albumName = Regexp.last_match[1]
    photoListUrl  = Regexp.last_match[2]
    logger.info("Got album name : #{albumName}") if DEBUG
    logger.info("Got album photo list URL : #{photoListUrl}") if DEBUG
else
    logger.error("Could not find album information, exiting...") if DEBUG
    exit 
end

# Create directory to store photo, use album name as dir name
if Dir.exist?(albumName)
    logger.info("Using existing local directory [#{albumName}] to store photos")
else 
    Dir.mkdir(albumName)
    logger.info("Creating local directory [#{albumName}] to store photos")
end

photo_folder = albumName + "/photos"
Dir.mkdir(photo_folder) unless Dir.exist?(photo_folder)

# Get photo list
photoListUrlHtml = get(photoListUrl)
photoListUrlHtml.encode!("utf-8", "gbk")

if photoListUrlHtml =~ /(\[[^\]]*\])/m
    photoListJson = Regexp.last_match[1]
    photoListJson.gsub!(/([{,])(\w+):/, "\\1\"\\2\":").gsub!("\'", "\"")
    
    photoList = Yajl::Parser.parse(photoListJson)
else
    logger.error("Could not get photo list...")
    exit 
end

logger.info("Found #{photoList.size} photos in current album")

# Save photo info to file
File.open(albumName + "/photos.json", "w") do |f|
    f << photoList
end

# Save album Url to file
File.open(albumName + "/albumUrl.txt", "w") do |f|
    f << xiangceUrl
end

# Start to download photos
photoList.each_index do |photo_index|
    photo           = photoList[photo_index]
    filename        = photo_folder + "/" + photo['id'].to_s + File.extname(photo['ourl'])
    server_id, path = photo['ourl'].split("/", 2)
    ourl            = "http://img" + server_id + ".ph.126.net/" + path

    logger.info("[#{photo_index + 1}/#{photoList.size}] Downloading #{ourl}")
    save_photo(filename, ourl)

    sleep download_interval
end