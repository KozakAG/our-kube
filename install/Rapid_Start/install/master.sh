# 
echo "[TASK 1]  Prepairs"
apt update && apt install python3-pip sshpass -y
git clone https://github.com/su115/our-kube.git
cd our-kube
pip3 install -r requirements.txt