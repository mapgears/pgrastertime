h1. Add csar Files in WIS database

This HowTo show how to load a file in a wis database from a Linux VM in the Lab environment.

h2. Get files

File to load comes from the PROD environment.  To access this network we can transfer a file through ssh protocol via qdmzenavweb01 server  ( wis.dev.ccg-gcc.gc.ca or 10.209.0.246)

<pre>
$ ssh sftpwis@10.209.0.246 ls -l ./*.object.xml
sftpwis@10.209.0.246's password: 
-rw-rw-r-- 1 sftpwis sftpwis 3174 Apr 17 21:32 ./brasdor_c_20190507_0150.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3258 Apr 17 21:32 ./dalhousie_20190710_1m_0100.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3311 Apr 17 21:33 ./fortune_20190925_05m_0050.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3263 Apr 17 21:33 ./liver20191009_1-5x1-5_grid_0150.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3260 Apr 17 21:33 ./longpond_20190926_05m_0050.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3260 Apr 17 21:33 ./lunenburg_20191009_1-5m_0150.object.xml
-rw-rw-r-- 1 sftpwis sftpwis 3409 Apr 17 21:33 ./shippagan_20190409-0619_4x4_0400.object.xml
</pre>

Now copy files:

<pre>
$ scp sftpwis@10.209.0.246:./brasdor_c_20190507_0150* ./data
sftpwis@10.209.0.246's password: 
brasdor_c_20190507_0150.csar                                                                                                       100%  192KB   2.9MB/s   00:00    
brasdor_c_20190507_0150.csar0                                                                                                      100% 6992KB  29.4MB/s   00:00    
brasdor_c_20190507_0150_density.tiff                                                                                               100%  190KB  56.8MB/s   00:00    
brasdor_c_20190507_0150_depth.tiff                                                                                                 100% 1140KB   8.0MB/s   00:00    
brasdor_c_20190507_0150_mean.tiff                                                                                                  100% 1089KB  15.5MB/s   00:00    
brasdor_c_20190507_0150.object.xml                                                                                                 100% 3174     2.2MB/s   00:00    

</pre>

h2. Start pgrastertime pipenv

We presume you've already have pgrastertime installed on your home (if not follow installation instruction here: https://github.com/mapgears/pgrastertime)

<pre>
~/pgrastertime$ pipenv shell
Loading .env environment variables…
Launching subshell in virtual environment…
(pgrastertime) smercier@qbccenenavwis01:~/pgrastertime$
</pre> 


NOTE: on 10.209.0.182 connect with generic user `srvlocadm` and move in `./pgrastertime` directory

Be sure to point on the desired database.  Update `local.ini` file for that

h2. Process files with pgrastertime

h4. Step 1

Load data in database

<pre>
$ python3 pgrastertime.py -s ./sql/postprocess.sql -t brasdor_c_20190507_0150  -p xml -f  -r ../data/brasdor_c_20190507_0150.object.xml -m gdal_path=../gdal-2.4.0/

... 

...

==== pgRastertime log file
--- 2020-04-21 19:56:19 : brasdor_c_20190507_0150.object.xml (1 of 1)

==== Parameters
Param : Target table ->  brasdor_c_20190507_0150
Param : Source directory ->  ../data/brasdor_c_20190507_0150.object.xml
Param : Force ->  True
Param : Post process ->  ./sql/postprocess.sql
==== Result
Import Started : 2020-04-21 19:56:19
Import Ended : 2020-04-21 19:58:17
Number of XML file to process : 1
Number of invalid XML file or failed processes : 0
Execution took 118 seconds to process

==== No Invalid files
 Execution took 2.0 minutes to process

</pre>

Now we have a new `brasdor_c_20190507_0150` table in the database.  We can double check with `validate` option

h4. Step 2

validate ...

<pre>
$ python3 pgrastertime.py -t brasdor_c_20190507_0150  -p validate

Validate pgrastertime table brasdor_c_20190507_0150 ... 
('Space disk use 8960 kB',)
('The brasdor_c_20190507_0150 table containe 57 rows',)
('The brasdor_c_20190507_0150 table containe 1 objnam(xml files) in it.',)
('0 rows deploy in soundings_1m',)
('0 rows deploy in soundings_2m',)
('0 rows deploy in soundings_4m',)
('0 rows deploy in soundings_8m',)
('0 rows deploy in soundings_16m',)
('0 rows invalidate in soundings_1m',)
('0 rows invalidate in soundings_2m',)
('0 rows invalidate in soundings_4m',)
('0 rows invalidate in soundings_8m',)
('0 rows invalidate in soundings_16m',)

 Post process run successfully!

</pre>

NOTE: any query can be added in `./sql/validate.sql` file

h4. Step 3

Two ways are available to deploy:  with pgrastertime or plsql: 

<pre>
$ python3 pgrastertime.py -t brasdor_c_20190507_0150  -p deploy
</pre>

<pre>
pgrastertime=#  SELECT dfo_deploy('brasdor_c_20190507_0150');
pgrastertime=#  SELECT dfo_invalidate( 'brasdor_c_20190507_0150','TRUE' );
pgrastertime=#  SELECT dfo_update_most_recent_tables('brasdor_c_20190507_0150');
</pre>

h4. Step 4

Finally, validate ...

<pre>
$ python3 pgrastertime.py -t brasdor_c_20190507_0150  -p validate


</pre>



