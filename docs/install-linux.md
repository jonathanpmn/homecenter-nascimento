# Instalação — Linux

## 1. Docker

Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo usermod -aG docker "$USER"
# logout/login
```

## 2. Clone e mídia

```bash
git clone https://github.com/jonathanpmn/homecenter-nascimento.git
cd homecenter-nascimento
cp .env.example .env
mkdir -p ~/Media/{Movies,Series,YouTube,Kids/{Movies,Series,YouTube}}
mkdir -p jellyfin/{config,cache}
```

`.env`:

```env
MEDIA_PATH=/home/SEU_USUARIO/Media
JELLYFIN_PUBLISHED_SERVER_URL=http://$(hostname -I | awk '{print $1}'):8096
```

## 3. Subir (com Quick Sync em Intel N100)

```bash
docker compose -f docker-compose.yml -f docker-compose.linux.yml pull
docker compose -f docker-compose.yml -f docker-compose.linux.yml up -d
```

Painel Jellyfin → **Reprodução** → **Transcodificação** → **Intel QuickSync (QSV)**.

Pacotes úteis (Ubuntu):

```bash
sudo apt install -y intel-media-va-driver-non-free vainfo
```

## 4. Wizard + bibliotecas

http://127.0.0.1:8096 → criar admin →

```bash
export JELLYFIN_PASSWORD='sua-senha'
./scripts/jellyfin-setup-libraries.sh
```

## 5. yt-dlp

```bash
sudo apt install -y yt-dlp ffmpeg   # ou pip install yt-dlp
./scripts/youtube-download.sh "URL"
```

## 6. Serviço sempre ligado

O `restart: unless-stopped` no compose já religa após reboot se o Docker estiver ativo.
