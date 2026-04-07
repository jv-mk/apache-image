# PHP Apache Docker Setup (Multi-Arch: ARM64 + AMD64)

Dieses Projekt stellt ein Docker-Setup für **PHP + Apache** bereit, das auf **x86 Servern (z. B. mittwald)** läuft.

veraltet: https://github.com/jv-mk/php8.3-apache
neu: https://github.com/jv-mk/apache-image

---

## Ziel

* Deployment auf AMD64 (mittwald)
* Automatisierter Multi-Arch Build & Push

---

## Technologien

* Docker + Buildx
* PHP 8.x + Apache
* Multi-Arch Images (`linux/amd64`, `linux/arm64`)
* GitHub Container Registry (`ghcr.io`)

---

## Voraussetzungen

* Docker Desktop installiert
* Docker Buildx aktiviert
* Zugriff auf GitHub Container Registry (GHCR)

---

## Login bei GHCR

```bash
docker login ghcr.io
```

Vorraussetzung:  **GitHub Personal Access Token (PAT)** mit:

* `write:packages`
* `read:packages`

---

## Deployment

### Script ausführen

```bash
./deploy.sh
```

---

## Was das Script macht

* Erstellt (falls nötig) einen `buildx` Builder
* Baut ein Multi-Arch Image:

    * `linux/amd64`
    * `linux/arm64`
* Erstellt Version-Tag:

  ```
  20260218-1548-abc123
  ```
* Pusht zu:

  ```
  ghcr.io/<user>/<repo>
  ```
* Setzt optional `latest`

---

## Image prüfen

```bash
docker buildx imagetools inspect ghcr.io/jv-mk/apache-image:latest
```

Erwartetes Ergebnis:

```
Platforms:
  linux/amd64
  linux/arm64
```

---

## Deployment bei mittwald

mittwald nutzt **AMD64**, daher:

* Docker zieht automatisch die richtige Architektur
* Keine Anpassungen nötig

---

## Wichtige Hinweise

### Kein `--platform` im Dockerfile

Nicht verwenden:

```dockerfile
FROM --platform=linux/amd64 php:8.2-apache
```

Führt zu Warnungen und schlechter Portabilität

---

### Plattform nur beim Build

```bash
docker buildx build --platform linux/amd64,linux/arm64 ...
```

---

## Best Practice

* Lokal: native ARM64 Performance
* Produktion: AMD64 kompatibel
* Ein Image für alles

---

## Troubleshooting

### Fehler: `no such file or directory Dockerfile`

Lösung:

```bash
-f .docker/php/Dockerfile
```

---

### Fehler: `no matching manifest`

* Falsches Base Image
* Kein Multi-Arch Build

---

### GHCR Push schlägt fehl

```bash
docker login ghcr.io
```

Mit gültigem Token.
# apache-image
