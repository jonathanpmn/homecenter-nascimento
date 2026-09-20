# homecenter-nascimento

Media center local com **Jellyfin** + **yt-dlp** para TV na rede de casa (LAN).  
Filmes/séries em `.mkv` / `.mp4`, pasta YouTube descarregada (sem Netflix/Prime/DRM).

## Estrutura de mídia no PC

```text
Media/
├── Movies/
├── Series/          # Ex.: Series/Nome da Série/Season 01/S01E01.mkv
├── YouTube/
└── Kids/
    ├── Movies/
    ├── Series/
    └── YouTube/
```

## Instalação por sistema

| SO | Guia |
|----|------|
| **Windows** (PC gamer) | [docs/install-windows.md](docs/install-windows.md) |
| **Linux** | [docs/install-linux.md](docs/install-linux.md) |
| **macOS** | [docs/install-macos.md](docs/install-macos.md) |

Para **agente de IA** no Windows: [AGENTS.md](AGENTS.md)

## Início rápido (qualquer SO com Docker)

```bash
git clone https://github.com/jonathanpmn/homecenter-nascimento.git
cd homecenter-nascimento
cp .env.example .env
# Edite .env: MEDIA_PATH e JELLYFIN_PUBLISHED_SERVER_URL

mkdir -p jellyfin/config jellyfin/cache
mkdir -p Media/{Movies,Series,YouTube,Kids/{Movies,Series,YouTube}}

docker compose pull
docker compose up -d
```

Abra **http://127.0.0.1:8096** → assistente (utilizador admin) → depois:

```bash
export JELLYFIN_PASSWORD='sua-senha'
./scripts/jellyfin-setup-libraries.sh
```

Na TV: app **Jellyfin** → servidor `http://IP-DO-PC:8096`.

## Scripts úteis

| Script | Função |
|--------|--------|
| `scripts/jellyfin-setup-libraries.sh` | Cria bibliotecas Series / Filmes / Kids YouTube |
| `scripts/jellyfin-auth.sh` | Gera header `Authorization` para API Jellyfin 12+ |
| `scripts/youtube-download.sh` | Descarrega vídeo/playlist YouTube → `Media/YouTube` |
| `scripts/youtube-kids.sh` | Igual, destino `Media/Kids/YouTube` |
| `scripts/organize-chris-downloads.py` | Extrai zips de temporadas para `Media/Series/...` |
| `scripts/jellyfin-fix-chris-metadata.sh` | Corrige TMDB 252 (Everybody Hates Chris 2005) |
| `scripts/setup.ps1` | Setup inicial no **Windows** (PowerShell) |

## Comandos diários

```bash
docker compose up -d      # subir
docker compose down       # parar
docker compose pull && docker compose up -d   # atualizar Jellyfin
```

## Licença / uso

Uso familiar. Respeite direitos de autor na origem dos ficheiros e nos Termos do YouTube ao usar `yt-dlp`.
