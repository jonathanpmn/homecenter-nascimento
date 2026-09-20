# Instruções para agente (Windows — PC gamer)

Objetivo: instalar Docker, clonar este repo, criar pastas de mídia, subir Jellyfin e configurar bibliotecas.

## Pré-requisitos

1. **Docker Desktop** instalado e em execução (WSL2 backend recomendado).
2. **Git** ou download ZIP do repo.
3. **Git Bash** ou **WSL** para scripts `.sh` (ou use `scripts/setup.ps1`).

## Passos (ordem)

1. Clonar:
   ```powershell
   git clone https://github.com/jonathanpmn/homecenter-nascimento.git
   cd homecenter-nascimento
   ```

2. Executar setup PowerShell:
   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\scripts\setup.ps1
   ```
   O script cria `C:\Media\...`, `jellyfin\config`, copia `.env` se não existir e pede o **IP LAN** do PC.

3. Subir Jellyfin (Windows):
   ```powershell
   docker compose -f docker-compose.yml -f docker-compose.windows.yml up -d
   ```

4. Abrir no browser: http://127.0.0.1:8096 — concluir wizard (criar utilizador admin).

5. Criar bibliotecas (Git Bash ou WSL na pasta do repo):
   ```bash
   export JELLYFIN_PASSWORD='senha-definida-no-wizard'
   ./scripts/jellyfin-setup-libraries.sh
   ```

6. Copiar mídia para `C:\Media\...` (Series, Kids, etc.).

7. Jellyfin → **Painel** → cada biblioteca → **Scan**.

8. TV: Jellyfin app → servidor `http://IP-LAN:8096` (mesmo IP do `.env`).

## Variáveis

| Variável | Exemplo Windows |
|----------|-----------------|
| `MEDIA_PATH` | `C:/Media` |
| `JELLYFIN_PUBLISHED_SERVER_URL` | `http://192.168.1.50:8096` |

## Hardware (opcional)

No painel Jellyfin → **Reprodução** → **Transcodificação**: se houver GPU NVIDIA, testar **NVENC**; Intel iGPU no Windows pode usar **QSV** após drivers instalados.

## Não fazer

- Não commitar `.env` com senhas.
- Não expor porta 8096 na internet sem VPN/túnel.
