# hugosilvam.github.io

Sitio personal de Hugo E. Silva. HTML estático, sin dependencias ni build. Se publica tal cual en
GitHub Pages.

```
index.html        Bio + working papers + artículos + capítulos + work in progress + older papers
simplicity.html   Página de SimpliCity
styles.css        Todos los estilos (compartidos por las dos páginas)
build-cv.ps1      Compila el CV desde Overleaf y actualiza pdf/cv.pdf
images/           Foto de perfil
pdf/              CV y PDFs de los papers
```

## El CV (inglés y español desde un solo archivo)

El fuente del CV **no vive en este repo**. Está en la carpeta que Overleaf sincroniza por Dropbox:

```
~/Dropbox/Apps/Overleaf/CV - Curriculum/main.tex
```

Así se sigue editando en el navegador. Ese único archivo genera **las dos versiones**:
`pdf/cv.pdf` (inglés) y `pdf/cv-es.pdf` (español). `build-cv.ps1` es lo único que los escribe.

### Flujo

1. Editas `main.tex` en Overleaf. Solo ese archivo.
2. Esperas a que Dropbox sincronice.
3. Desde esta carpeta:

   ```
   .\build-cv.ps1
   git add pdf/cv.pdf pdf/cv-es.pdf
   git commit -m "CV update"
   git push
   ```

Para compilar solo uno: `.\build-cv.ps1 -Language es`.

El script imprime la línea de fecha del CV (`January / Enero 2026`) al terminar, así se nota
enseguida si compilaste una versión vieja.

### Cómo editar el texto bilingüe

Cada string traducible va envuelto en `\tr{inglés}{español}`:

```latex
\section*{\tr{Research grants}{Proyectos de investigación}}
2024--2028 & \tr{Principal Investigator}{Investigador Principal}, ...
```

Reglas:

- **Los títulos de papers, revistas y congresos no se traducen.** Van en inglés en las dos
  versiones, como corresponde en un CV académico. Solo se traducen encabezados, cargos y prosa
  (consultorías, premios, actividades).
- Atajos ya definidos para lo que más se repite: `\cvwith` (with/con), `\cvand` (and/y),
  `\cvpresent` (present/presente).
- **Nunca pongas `&` ni `\\` dentro de un `\tr{}{}`.** Rompe la tabla de `tabularx`.
- Si agregas contenido nuevo y solo escribes el inglés, el español mostrará el inglés. No falla
  silenciosamente en el sentido de romperse, pero queda mezclado: conviene escribir los dos al
  mismo tiempo.

### Detalles de la compilación

- Compila con `pdflatex` directo, dos pasadas por idioma. No usa `latexmk` porque es un script de
  Perl y esta instalación de MiKTeX no tiene Perl. Si el CV alguna vez usa `\ref` o `\cite`, hay
  que agregar una tercera pasada.
- LaTeX corre en una carpeta temporal, así que no quedan `.aux`/`.log` en la carpeta de Overleaf.
  Si quedaran, Overleaf los sincronizaría de vuelta al proyecto.
- `babel` se deja en `spanish` para las dos versiones, igual que antes del cambio bilingüe. Ponerlo
  en `english` para la versión inglesa cambiaría los cortes de línea y el PDF en inglés dejaría de
  ser idéntico al ya publicado.
- Si mueves el proyecto de Overleaf: `.\build-cv.ps1 -Source "ruta\al\archivo.tex"`.

### `CV_esp.tex` quedó obsoleto

En la carpeta de Overleaf todavía está `CV_esp.tex`, el CV en español que se mantenía aparte. Ya no
se usa: había quedado desactualizado (fecha de julio 2025, cargos en CEDEUS e ISCI que en el inglés
estaban comentados, sin la consultoría 2024--2025). Conviene borrarlo desde Overleaf para que nadie
lo edite por error. Hay copia en `../cv-backup-pre-bilingual/`.

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
