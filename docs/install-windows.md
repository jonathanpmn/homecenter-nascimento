# Instalação — Windows (PC gamer)

## 1. Docker Desktop

1. Baixe [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/).
2. Instale com **WSL 2** habilitado.
3. **Settings → Resources → File sharing**: inclua `C:\Media` (ou o drive onde ficará a mídia).
4. Reinicie o Docker se alterar compartilhamento.

## 2. Repositório e pastas

```powershell
git clone https://github.com/jonathanpmn/homecenter-nascimento.git
cd homecenter-nascimento
.\scripts\setup.ps1
```

Ou manualmente:

```powershell
New-Item -ItemType Directory -Force -Path C:\Media\Movies, C:\Media\Series, C:\Media\YouTube, C:\Media\Kids\YouTube
New-Item -ItemType Directory -Force -Path .\jellyfin\config, .\jellyfin\cache
Copy-Item .env.example .env
```

Edite `.env`:

```env
MEDIA_PATH=C:/Media
JELLYFIN_PUBLISHED_SERVER_URL=http://SEU-IP-LAN:8096
```

IP LAN (PowerShell):

```powershell
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notmatch '^169' } | Select-Object -First 1).IPAddress
```

## 3. Subir Jellyfin

```powershell
docker compose -f docker-compose.yml -f docker-compose.windows.yml pull
docker compose -f docker-compose.yml -f docker-compose.windows.yml up -d
```

## 4. Wizard e bibliotecas

1. Browser: http://127.0.0.1:8096
2. Criar utilizador administrador.
3. Git Bash na pasta do projeto:

```bash
export JELLYFIN_PASSWORD='sua-senha'
./scripts/jellyfin-setup-libraries.sh
```

## 5. yt-dlp (opcional)

```powershell
winget install yt-dlp ffmpeg
```

No Git Bash:

```bash
./scripts/youtube-download.sh "URL_DO_YOUTUBE"
```

## 6. TV

- Instale **Jellyfin** na Android TV / Fire TV.
- Servidor: `http://SEU-IP-LAN:8096`

## Firewall

Se a TV não conectar: **Windows Defender Firewall** → permitir **Docker Desktop Backend** em redes privadas.

## Parar / remover

```powershell
docker compose -f docker-compose.yml -f docker-compose.windows.yml down
```
