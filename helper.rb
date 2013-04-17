require "yajl"
require "open-uri"
require "logger"
require "zlib"

# save photo from "url" to "path"
def save_photo(file_path, url,  agent = nil)
    File.open(file_path, 'w') do |output|
        if agent.nil?
            open(url) do |input|
                output << input.read
            end
        else
            output << agent.get(url).body
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

def weibo_login(username, password)
    agent = Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20100101 Firefox/14.0.1'

     #pre login
    preloginurl = 'http://login.sina.com.cn/sso/prelogin.php?entry=sso&callback=sinaSSOController.preloginCallBack&su=dW5kZWZpbmVk&rsakt=mod&client=ssologin.js(v1.4.2)&_=' + Time.now.to_i.to_s

    page = agent.get(preloginurl)
    keys = page.body[/\{\"retcode[^\0]*\}/]
    keys = JSON.parse(keys)
    return nil if keys['retcode'] != 0
     
    logindata = {   'entry'         => 'weibo', 
                    'gateway'       => '1',
                    'from'          => '', 
                    'savestate'     => '7', 
                    'userticket'    => '1',
                    'ssosimplelogin'=> '1', 
                    'vsnf'          => '1', 
                    'su'            => '', 
                    'service'       => 'miniblog', 
                    'servertime'    => '', 
                    'nonce'         => '',
                    'pwencode'      => 'rsa2', 
                    'rsakv'         => '', 
                    'sp'            => '',
                    'encoding'      => 'UTF-8', 
                    'prelt'         => '115',
                    'exittype'      => 'META',
                    'url'           => 'http://weibo.com/ajaxlogin.php?framelogin=1&callback=parent.sinaSSOController.feedBackUrlCallBack'
            }

    logindata['servertime'] = keys['servertime'] 
    logindata['nonce']      = keys['nonce'] 
    logindata['rsakv']      = keys['rsakv'] 
    logindata['su']         = Base64.strict_encode64("ylzcylx@gmail.com".sub("@","%40"))

    pwdkey  = keys['servertime'].to_s + "\t" + keys['nonce'].to_s + "\n" + "rdpschina".to_s
    pub     = OpenSSL::PKey::RSA::new
    pub.e   = 65537
    pub.n   = OpenSSL::BN.new(keys['pubkey'],16)

    logindata['sp'] = pub.public_encrypt(pwdkey).unpack('H*').first
           
    loginuri = 'http://login.sina.com.cn/sso/login.php?client=ssologin.js(v1.4.2)'

    page = agent.post(loginuri,logindata)

    redrecturi = page.body[/http:\/\/weibo.com\/ajax[^'"]*/]
    retcode = redrecturi.match(/retcode=([\d]+)/)
    retcode = retcode[1] if retcode != nil
    return nil if redrecturi == nil

    if retcode.to_s != '0'
        reason = redrecturi.match(/reason=([^&]+)/)
        reason = reason[1] if reason != nil
        reason = URI.unescape(reason)
        puts "Cannot login Weibo: " + reason.encode("UTF-8", "gbk")
        return nil
    end

    page  = agent.get(redrecturi)
    ujson = page.body[/\{\"result\"\:[^)]+\}/]
    return nil  if ujson == nil
    rval = JSON.parse(ujson);
    return nil if rval.has_key?('userinfo') == false
    return nil if rval.has_key?('result') == false
    return nil if rval['result'] == false

    agent.get('http://weibo.com/login.php');

    return agent
end