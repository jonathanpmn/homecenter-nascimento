# Instalação — macOS

## 1. Docker Desktop

Instale [Docker Desktop for Mac](https://www.docker.com/products/docker-desktop/).  
**Settings → Resources → File sharing**: permita a pasta `Media` (ex. `/Users/voce/Media`).

## 2. Clone e pastas

```bash
git clone https://github.com/jonathanpmn/homecenter-nascimento.git
cd homecenter-nascimento
cp .env.example .env
mkdir -p ~/Media/{Movies,Series,YouTube,Kids/{Movies,Series,YouTube}}
mkdir -p jellyfin/{config,cache}
```

`.env`:

```env
MEDIA_PATH=/Users/SEU_USUARIO/Media
JELLYFIN_PUBLISHED_SERVER_URL=http://$(ipconfig getifaddr en0):8096
```

## 3. Subir

```bash
docker compose pull
docker compose up -d
```

## 4. Wizard + bibliotecas

http://127.0.0.1:8096 → admin →

```bash
export JELLYFIN_PASSWORD='sua-senha'
./scripts/jellyfin-setup-libraries.sh
```

## 5. yt-dlp

```bash
brew install yt-dlp ffmpeg
./scripts/youtube-download.sh "URL"
```

## 6. Parar (liberar Mac)

```bash
docker compose down
osascript -e 'quit app "Docker"'   # opcional: fechar Docker Desktop
```
