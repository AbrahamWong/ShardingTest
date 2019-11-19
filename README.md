### Tugas Implementasi MongoDB pada Basis Data Terdistribusi
# MongoDB Sharding Cluster

## Deskripsi Tugas
1. Implementasi Cluster MongoDB
   - Menggunakan versi MongoDB: 4.2
   - Dapat menggunakan Vagrant/Docker
   - Cluster terdiri dari:
     - Config server: 2
     - Data/shard server: 3
     - Query router: 1
2. Menggunakan dataset
   - Menggunakan dataset berformat CSV atau JSON dengan ukuran > 1000 baris
   - Import ke dalam server MongoDB
3. Implementasi aplikasi CRUD
   - Menggunakan bahasa pemrograman yang support dengan connector MongoDB
   - Menggunakan Web/API/Scripting
   - Harus ada operasi CRUD
   - Untuk proses read, harus melibatkan juga agregasi
     - Minimal ada 2 contoh query agregasi
     
## Implementasi Cluster MongoDB
Terdapat beberapa server yang dibuat dalam tugas ini, berikut spesifikasi masing - masing server.
- Config Server
  - ```mongo-config-1```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.11
  - ```mongo-config-2```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.12
- Query Router
  - ```mongo-query-router```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.13
- Shard Server
  - ```mongo-shard-1```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.14
  - ```mongo-shard-2```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.15
  - ```mongo-shard-3```
    - OS : ```bento/ubuntu-18.04```
    - RAM : 512 MB
    - IP : 192.168.33.16
    
Buatlah sebuah ```Vagrantfile``` dengan rincian sebagai berikut:  
```Vagrantfile```
```bash
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "mongo_config_1" do |mongo_config_1|
    mongo_config_1.vm.hostname = "mongo-config-1"
    mongo_config_1.vm.box = "bento/ubuntu-18.04"
    mongo_config_1.vm.network "private_network", ip: "192.168.33.11"
    
    mongo_config_1.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-config-1"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_config_1.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end

  config.vm.define "mongo_config_2" do |mongo_config_2|
    mongo_config_2.vm.hostname = "mongo-config-2"
    mongo_config_2.vm.box = "bento/ubuntu-18.04"
    mongo_config_2.vm.network "private_network", ip: "192.168.33.12"
    
    mongo_config_2.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-config-2"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_config_2.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end

  config.vm.define "mongo_query_router" do |mongo_query_router|
    mongo_query_router.vm.hostname = "mongo-query-router"
    mongo_query_router.vm.box = "bento/ubuntu-18.04"
    mongo_query_router.vm.network "private_network", ip: "192.168.33.13"
    
    mongo_query_router.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-query-router"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_query_router.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end

  config.vm.define "mongo_shard_1" do |mongo_shard_1|
    mongo_shard_1.vm.hostname = "mongo-shard-1"
    mongo_shard_1.vm.box = "bento/ubuntu-18.04"
    mongo_shard_1.vm.network "private_network", ip: "192.168.33.14"
        
    mongo_shard_1.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-shard-1"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_shard_1.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end

  config.vm.define "mongo_shard_2" do |mongo_shard_2|
    mongo_shard_2.vm.hostname = "mongo-shard-2"
    mongo_shard_2.vm.box = "bento/ubuntu-18.04"
    mongo_shard_2.vm.network "private_network", ip: "192.168.33.15"
    
    mongo_shard_2.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-shard-2"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_shard_2.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end
  
  config.vm.define "mongo_shard_3" do |mongo_shard_3|
    mongo_shard_3.vm.hostname = "mongo-shard-3"
    mongo_shard_3.vm.box = "bento/ubuntu-18.04"
    mongo_shard_3.vm.network "private_network", ip: "192.168.33.16"
    
    mongo_shard_3.vm.provider "virtualbox" do |vb|
      vb.name = "mongo-shard-3"
      vb.gui = false
      vb.memory = "512"
    end

    mongo_shard_3.vm.provision "shell", path: "provision/allhosts.sh", privileged: false
  end

end
```

Setelah itu, buat file ```allhosts.sh``` pada folder ```provision``` dengan rincian sebagai berikut:  
```allhosts.sh```
```bash
# Copy APT sources list
sudo cp /vagrant/sources/sources.list /etc/apt/
sudo cp /vagrant/sources/mongodb-org-4.2.list /etc/apt/sources.list.d/

# Add MongoDB repo key
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

# Create a list file for MongoDB
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

# Update Repository
sudo apt-get update
# sudo apt-get upgrade -y

# Install MongoDB
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo service mongod start 

# Always rember
sudo systemctl start mongod
sudo systemctl enable mongod

# For mongod to not throwing error
sudo mkdir -p /data/db
sudo chown mongodb:mongodb /data/db
sudo chmod 777 /data/db
```

Setelah ```allhosts.sh``` dibuat, lakukan ```vagrant up```.  

## Konfigutasi Cluster MongoDB
#### Konfigurasikan file ```/etc/hosts``` pada tiap server dengan ```sudo nano /etc/hosts```, hapus bagian nama server tersebut, dan ganti dengan  
```
192.168.33.11 mongo-config-1
192.168.33.12 mongo-config-2
192.168.33.13 mongo-query-router
192.168.33.14 mongo-shard-1
192.168.33.15 mongo-shard-2
192.168.33.16 mongo-shard-3
```
  
#### Buat sebuah user untuk bagian autentikasi dengan:  
- Jalankan ```mongo``` pada salah satu server config. Misalkan ```mongo-config-1```.
```
vagrant ssh mongo_config_1
mongo
```
- Masuk ke dalam database ```admin```  
```
use admin
```
- Buat user
```
db.createUser({user: "mongo-admin", pwd: "password", roles:[{role: "root", db: "admin"}]})
```
  
#### Lakukan inisialisasi config server dengan:
- Ubah ```/etc/mongod.conf``` semua config server dengan perubahan berikut:
```
...

  port: 27019
  bindIp: <ip configserver>
...

replication:
  replSetName: configReplSet
  
sharding:
  clusterRole: "configsvr"
...
```
- Restart ```mongod``` pada masing - masong config server
```
sudo systemctl restart mongod
```
- Pada salah satu config server (selain yang ada pada perintah), jalankan perintah, dan masukkan passwor yang sudah diberikan ke dalam database 
```
mongo mongo-config-1:27019 -u mongo-admin -p --authenticationDatabase admin
```
- Inisialisasikan <i>replica set</i> pada ```mongo``` shell
```
rs.initiate( { _id: "configReplSet", configsvr: true, members: [ { _id: 0, host: "mongo-config-1:27019" }, { _id: 1, host: "mongo-config-2:27019" } ] } )
```

#### Konfigurasikan query router:
- Masuk ke dalam router
```
vagrant ssh mongo_query_router
```
- Buat file baru bernama ```/etc/mongos.conf``` dengan ```sudo nano /etc/mongos.conf```, berisi
```
# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongos.log

# network interfaces
net:
  port: 27017
  bindIp: 192.168.33.13

sharding:
  configDB: configReplSet/mongo-config-1:27019,mongo-config-2:27019
```
- Buat sebuah systemd baru dengan ```sudo nano /lib/systemd/system/mongos.service```, berisi
```
[Unit]
Description=Mongo Cluster Router
After=network.target

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongos --config /etc/mongos.conf
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

[Install]
WantedBy=multi-user.target
```
- Karena penggunaan ```mongos.service``` dan ```mongod``` dapat menyebabkan konflik, matikan ```mongod``` dan jalankan ```mongos.service``` dengan cara:
```
sudo systemctl stop mongod
sudo systemctl enable mongos.service
sudo systemctl start mongos
```
- Cek apakah ```mongos``` sudah berjalan sebagaimana mestinya dengan 
```
systemctl status mongos
```
- Apabila status ```mongos``` adalah ```active (running)```, berarti ```mongos``` telah berjalan dengan baik

#### Tambahkan & Gunakan Shard ke dalam Cluster:
- Pada setiap shard server, ubah file ```/etc/mongod.conf``` dengan perubahan berikut:
```
...
  bindIp = <ip shardserver>

...
sharding:
  clusterRole: "shardsvr"

...
```
- Pada salah satu shard server, jalankan:
```
mongo mongo-query-router:27017 -u mongo-admin -p --authenticationDatabase admin
```
- Tambahkan shard secara individual
```
sh.addShard( "mongo-shard-1:27017" )
sh.addShard( "mongo-shard-2:27017" )
sh.addShard( "mongo-shard-3:27017" )
```
- Buat database baru
```
use wineMag
```
- Nyalakan sharding pada database baru
```
sh.enableSharding("wineMag")
```
- Cek apakah proses sharding berhasil. Jika berhasil, database baru akan muncul.
```
use config
db.databases.find()
```

#### Gunakan Sharding pada level Collection:
- Pakai database yang telah kita sharding
```
use wineDB
```
- Buat koleksi baru dan <i>hash</i> kunci ```_id```
```
db.wineCollection.ensureIndex( { _id : "hashed" } )
```
- Lakukan sharding pada collection yang telah dibuat
```
sh.shardCollection( "wineMAg.wineCollection", { "_id" : "hashed" } )
```

## Menggunakan dataset
Dataset yang digunakan berasal dari [https://www.kaggle.com/zynicide/wine-reviews], dan memiliki dataset sekitar 129970 buah. Menggunakan .csv yang ada:
- Unduh file .zip dari web tersebut
```
sudo wget "https://storage.googleapis.com/kaggle-data-sets/1442/8172/compressed/winemag-data-130k-v2.csv.zip?GoogleAccessId=web-data@kaggle-161607.iam.gserviceaccount.com&Expires=1574261137&Signature=P2VdvM9kZEg9zLE9Par4Zbg3DVarqGxf4AYQwdNFRIxtrMTO0m%2BjF5I3Jq7R8vCeUHlVNMP98Pkb7BNz4vcZ%2B5EZnfrC%2Fzh6CWFRvCMPES8OW07G6UKApKV0rmZslIGBUy9KUX7qQDV6doHRVE4VCP8hIdaKgjpESQVaNCT07yBHeZEVy2j1brtH4rM6%2BYeQ%2FqJ2MaR34snKrh0WfvBWPEtKnKX53amtKJPu6xmbIAAuh932UEDqjpugoGgdlhqiX5M4EzXq94RNP9tjIsECPNsNudcuf9LoqnU2D63Tx6gkTkJYnTYHEbR8gVGs%2Fq6UR9C%2FsuhjIExqIZxkvb0Mpw%3D%3D&response-content-disposition=attachment%3B+filename%3Dwinemag-data-130k-v2.csv.zip" 
```
- Ekstrak .zip yang telah diunduh
```
sudo mv winemag-data-130k-v2.csv.zip\?GoogleAccessId\=web-data\@kaggle-161607.iam.gserviceaccount.com\&Expires\=1574261137\&Signature\=P2VdvM9kZEg9zLE9Par4Zbg3DVarqGxf4AYQwdNFRIxtrMTO0m+jF5I3Jq7R8vCeUHlVNMP98Pkb7BNz4vcZ+5EZnfrC%2Fzh6CWFRvCMPES8OW07G6U  wineMagData
sudo unzip wineMagData
```
- Import dataset ke dalam query router
```
mongoimport --db=wineMag --collection=wineCollection --type=csv --headerline --host=192.168.33.13:27017 --file=winemag-data-130k-v2.csv
```
- Cek apakah dataset telah terbagi - bagi dengan benar
```
mongo mongo-query-router:27017 -u mongo-admin -p --authenticationDatabase admin 
use wineMag
db.wineCollection.getShardDistribution()
```
![Hasil, menunjukkan bahwa terdapat 3 shard dan pembagian data cukup rata](img/res.jpg)
