#setup Ipython Notebook and any extra software
source /root/spark/conf/spark-env.sh

#install prereqs
yum install -y python27-devel.x86_64
#yum install -y libpng-devel
#yum install -y freetype-devel

cd /home/hadoop

#install pip
curl -O https://bootstrap.pypa.io/get-pip.py
python27 get-pip.py
echo "installed Pip"
#set up venv
echo "changed directory to /home/hadoop"
cd /home/hadoop
echo "trying to install virtualenv"
pip install virtualenv
mkdir IPythonNB
cd IPythonNB
/usr/local/bin/virtualenv -p /usr/bin/python2.7 venv
source venv/bin/activate

#install python packages
pip install "ipython[notebook]"
pip install requests numpy
#pip install matplotlib
#pip install nltk
#pip install mllib

#set up Ipython Notebook config
echo "c = get_config()" >  /root/.ipython/profile_default/ipython_config.py
echo "c.NotebookApp.ip = '*'" >>  /root/.ipython/profile_default/ipython_config.py
echo "c.NotebookApp.open_browser = False"  >> /root/.ipython/profile_default/ipython_config.py
echo "c.NotebookApp.port = 8192" >> /root/.ipython/profile_default/ipython_config.py

# Make sure $SPARK_MASTER_IP is set
source /root/spark/conf/spark-env.sh

export IPYTHON_HOME=/home/hadoop/IPythonNB/venv/
export PATH=$PATH:$IPYTHON_HOME/bin
export IPYTHON_OPTS="notebook --no-browser --config=/root/.ipython/profile_default/ipython_config.py"
export MASTER=spark://$SPARK_MASTER_IP:7077
echo $MASTER
#start Ipython Notebook through pyspark
nohup /root/spark/bin/pyspark --master $MASTER > /var/log/python_notebook.log &
echo "Ipython Notebook started?"

echo "emrssh -ND 8157 root@"$SPARK_MASTER_IP
echo "http://"$SPARK_MASTER_IP":8192"



# TODO Check this in and start cluster then run 
# emrssh root@ip 'path/to/start_ipython.sh'
