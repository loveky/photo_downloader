## Photo downloader ##

This repo contains several scripts used to download photo album from Internet.    
    
### photo.163.com.rb ###

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
    
### www.douban.com.rb ###

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
        
### photo.weibo.com.rb ###

Used to download weibo photo album.   
__Note: Plesae provide your Weibo Username/Password to download any weibo photo album. For weibo login process, please refer to [here](http://blog.csdn.net/flytomysky/article/details/8155714)  __

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