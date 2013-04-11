require "yajl"
require "open-uri"
require "logger"
require "zlib"

# save photo from "url" to "path"
def save_photo(file_path, url)
    File.open(file_path, 'w') do |output|
      open(url) do |input|
        output << input.read
      end
    end
end

def tidy_url(origin_url)
    url = origin_url.start_with?("http") ? "" : "http://"
    url += origin_url

    return url
end

def get(url) 
    url = tidy_url(url)
    f = open(url)
    if (f.content_encoding[0] == "gzip")
        gz   = Zlib::GzipReader.new(f)
        data = gz.read
        gz.close
    else
        data = f.read
    end

    return data
end