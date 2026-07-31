# hugosilvam.github.io

Sitio personal de Hugo E. Silva. HTML estático, sin dependencias ni build. Se publica tal cual en
GitHub Pages.

```
index.html        Bio + working papers + artículos + capítulos + work in progress + older papers
simplicity.html   Página de SimpliCity
styles.css        Todos los estilos (compartidos por las dos páginas)
images/           Foto de perfil
pdf/              CV y PDFs de los papers
```

## Publicar en GitHub Pages

1. Crea un repositorio llamado `hugosilvam.github.io` en tu cuenta de GitHub.
2. Desde esta carpeta:

   ```
   git init
   git add .
   git commit -m "Sitio personal"
   git branch -M main
   git remote add origin https://github.com/hugosilvam/hugosilvam.github.io.git
   git push -u origin main
   ```

3. En el repositorio, **Settings → Pages → Source: Deploy from a branch → main / (root)**.
4. En unos minutos queda en `https://hugosilvam.github.io`.

Los PDFs quedan en `https://hugosilvam.github.io/pdf/<archivo>.pdf`. Esas URLs no dependen de
Dropbox ni de Google Drive, así que no se vuelven a romper.

Para ver el sitio antes de publicar, abre `index.html` en el navegador, o levanta un servidor local:

```
python -m http.server 8000
```

## Cómo agregar un paper nuevo

Copia un `<li>` de la lista correspondiente en `index.html` y edita el texto. La estructura es:

```html
<li>
  <span class="yr">2027</span>          <!-- año; déjalo vacío si repite el del anterior -->
  <div>
    <a class="title" href="pdf/archivo.pdf">Título del paper</a>
    <span class="meta">with Coautor.<br><i>Revista</i>, 12:345678.</span>
    <span class="filelinks">
      <a href="pdf/archivo.pdf">PDF</a>
      <a href="https://doi.org/...">Journal</a>
    </span>
  </div>
</li>
```

El año se escribe solo en la primera entrada de cada año. Las siguientes llevan `<span class="yr"></span>`
vacío, y la columna de la izquierda queda como una línea de tiempo.

Si un paper todavía no tiene PDF, usa `<span class="title-plain">Título</span>` en vez del `<a>`.
Nunca dejes un `<a>` apuntando a un archivo que no existe.

## Pendientes

### 1. Tu foto

`images/hugo-silva.jpg` es un marcador de posición. La foto original del sitio de Google estaba en
una URL firmada que ya expiró y devuelve 403, así que no se pudo recuperar. Reemplaza el archivo
con tu foto (cuadrada, idealmente 600×600 o más). No hay que tocar el HTML.

### 2. PDFs que faltan

Estos papers no tienen PDF porque el enlace original estaba caído. Deja el archivo en `pdf/` con el
nombre indicado y agrega el enlace en `index.html`:

| Paper | Nombre de archivo sugerido | Qué pasó con el enlace original |
|---|---|---|
| Fare evasion in public transport | `pdf/fare-evasion.pdf` | Google Drive devolvía 404 |
| Regulating vertical markets through delegation | `pdf/vertical-markets.pdf` | Google Drive devolvía 401 (no era público) |
| Public transport and urban structure (working paper) | `pdf/pt-urban-structure.pdf` | el acortador `cutt.ly` dejó de existir |
| Team-based incentives in transportation firms (working paper) | `pdf/team-incentives.pdf` | la etiqueta `[working paper]` era texto plano, nunca tuvo enlace |
| Welfare-improving taxes in the urban equilibrium | `pdf/welfare-improving-taxes.pdf` | la etiqueta `[pdf]` era texto plano, nunca tuvo enlace |
| Input third-degree price discrimination by congestible facilities | `pdf/input-price-discrimination.pdf` | `economia.uc.cl` lo borró; no hay copia en archive.org |

### 3. Cosas que conviene que confirmes

- **Dos títulos que actualicé según SSRN.** El sitio de Google tenía versiones viejas:
  - *"...on housing **supply**: the role of land-use regulation"* → en SSRN es *"...on housing **and
    prices**: the role of land-use regulation"*.
  - *"Transport infrastructure and urban form: **a comprehensive review**"* → en SSRN (revisado el
    21 de enero de 2026) es *"...**a review of causal evidence**"*.

  Si prefieres los títulos antiguos, revierte esas dos líneas.
- **Coautores que faltaban.** SSRN lista *"The social divide of urban land use regulatory changes"*
  con Kenzo Asahi, Diego Gil, Andrea Herrera, Javier Peñafiel y tú. El sitio solo mencionaba a Gil y
  Asahi. Usé la lista completa de SSRN.
- **Otros títulos que corregí contra Crossref**, porque el sitio no coincidía con lo publicado:
  *"Public transport and urban **form**"* → *"...urban **structure**"*; *"Public transport subsidies
  and the **shadow** cost of public funds"* → *"...the **marginal** cost of public funds: an
  interpretative review"*; *"**Airlines'** route structure competition"* → *"**Airline** route
  structure competition"*; *"...other urban policies"* → *"...other urban **transport** policies"*.
- **Correo.** Puse `hugosilvam@gmail.com` como pediste. El sitio anterior mostraba `husilva@uc.cl`.
- **Millennium Nucleus in Just Transport** aparece sin enlace porque no encontré un sitio oficial.
  Si existe, agrégalo en el primer párrafo de la bio.
