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