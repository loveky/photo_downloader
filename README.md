## Photo downloader ##

This repo contains several scripts used to download photo album from Internet.    
    
### _photo.163.com.rb_ ###

Used to download 163 photo album.

    cd photo_downloader
    bundle install
    ruby photo.163.com.rb "http://photo.163.com/szrunners88#m=1&aid=252043522&p=1"   

This will generate the following directory structure.
   
    香港馬拉松2013-02-24            <-- Use album name as directory name
    |-- albumUrl.txt              <-- Contains the URL supplied on commandline  
    |-- photos                    <-- Directory contains photo files
    |   |-- 8145116642.jpg        <-- Use photo ID as photo file name
    |   |-- 8145116647.jpg
    |   `-- 8145155462.jpg
    `-- photos.json               <-- Contains detailed info of all photos
    
### _www.douban.com.rb_ ###

Used to download douban photo album.

    cd photo_downloader
    bundle install
    ruby www.douban.com.rb "http://www.douban.com/photos/album/91802771/"
    
This will generate the following directory structure.  

    业师傅的相册-20130224香港马拉松    
    ├── albumUrl.txt
    ├── photo_info.txt
    └── photos
        ├── p1884469713.jpg
        ├── p1884470009.jpg
        └── p1884470332.jpg
        
### _photo.weibo.com.rb_ ###

Used to download weibo photo album.   
__Note: Plesae provide your Weibo Username/Password to download any weibo photo album. For weibo login process, please refer to [here](http://blog.csdn.net/flytomysky/article/details/8155714)__

__Note: 目前此脚本不支持登陆过程需要填写验证码的情况，请在“账号设置”->“账号安全”->“登录保护”界面将你当前所在地设置为白名单。__

    cd photo_downloader
    bundle install
    ruby photo.weibo.com.rb --user USERNAME --pass PASSWORD --url 'http://photo.weibo.com/2486069750/albums/detail/album_id/3533767994606312#!/mode/1/page/1'    
    
This will generate the following directory structure.  

    2013厦门马拉松终点100米照片
    ├── albumUrl.txt
    ├── photo_info.txt
    └── photos
        ├── 942e69f6gw1e0r778w99uj.jpg
        ├── 942e69f6gw1e0r77c11imj.jpg
        └── 942e69f6gw1e0r77ef0tmj.jpg
        
### _discuz.rb_ ###

Used to download attachment pics from a discuz topic.
    
    cd photo_downloader
    bundle install
    ruby discuz.rb "http://bbs.running8.com/thread-153671-6-9.html"
    
This will generate the following directory structure.

    给力厦门——2013风11马拉松之旅（第11页厦马选手高清大图)
    ├── photos
    │   ├── 150841tq9sz3t1bisqgbjq.jpg
    │   ├── 150943luxepg6zgppgpkee.jpg
    │   ├── 151056jy6yncpjrzj9gcjk.jpg
    │   ├── 151142lmzlhb567brhjv1r.jpg
    │   ├── 151144ephddpj3hd1dpo30.jpg
    │   ├── 151252bdmqhe2eejahvfr3.jpg
    │   ├── 151326kzlpga3pbjkgclb3.jpg
    │   ├── 151354rarba5b55xg55bzg.jpg
    │   ├── 151422vylfbqz7dooy75nf.jpg
    │   ├── 152021gzq883w3pvzqs8yt.jpg
    │   ├── 152745x99h8zu8yhz39em4.jpg
    │   ├── 152920x54xzl03marmm8lr.jpg
    │   ├── 152959tmljckn6zuexc6ol.jpg
    │   ├── 153034e4ei9fhwhnibz0nd.jpg
    │   ├── 153310i6c6ijh9011ei679.jpg
    │   ├── 153418yoi0t05v8d8no55d.jpg
    │   ├── 153656uiq4mkq24gcs854d.jpg
    │   ├── 153814rxzoc6kx0hqqxldd.jpg
    │   ├── 153847xyn9nolqzcfodep2.jpg
    │   ├── 154157hwikfy116w0u1x6w.jpg
    │   ├── 154240d3ke3ctdc3aakd7t.jpg
    │   ├── 154436viirstnirrs9dyzd.jpg
    │   ├── 154756s8eg77gy1xt8me01.jpg
    │   └── 165727h9l8nbttpytey6da.jpg
    └── topicURL.txt
