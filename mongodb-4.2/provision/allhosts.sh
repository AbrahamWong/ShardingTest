# Add hostname
sudo bash -c \\"echo '192.168.33.11 mongo-config-1' >> /etc/hosts\\"
sudo bash -c \\"echo '192.168.33.12 mongo-config-2' >> /etc/hosts\\"
sudo bash -c \\"echo '192.168.33.13 mongo-config-3' >> /etc/hosts\\"
sudo bash -c \\"echo '192.168.33.14 mongo-query-router' >> /etc/hosts\\"
sudo bash -c \\"echo '192.168.33.15 mongo-shard-1' >> /etc/hosts\\"
sudo bash -c \\"echo '192.168.33.16 mongo-shard-2' >> /etc/hosts\\"

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

# Idk why
sudo mkdir -p /data/db
sudo chown mongodb:mongodb /data/db
sudo chmod 777 /data/db