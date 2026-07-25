# Jamez’s Blog

Hugo site source for a technical blog about large language models, inference systems, and AI products.

The public repository contains the Hugo configuration, PaperMod theme, layouts,
styles, static assets, and site structure pages. Published articles are read at
build time from the private `jamez-bondos/blog-content` repository and are never
committed here.

## Local development

This project supports exactly Hugo `0.164.0`. Initialize the pinned theme and
start the development server:

```bash
git submodule update --init --recursive
hugo server --buildDrafts
```

Open <http://localhost:1313/>.

The `content/posts/dev-*` page bundles are draft-only fixtures for checking article cards, covers, search, math, code highlighting, tables, and the H2/H3 table of contents. A normal production build excludes them:

```bash
hugo --gc --minify
```

PaperMod currently emits known deprecation warnings with Hugo `0.164.0`. The
theme submodule remains pinned until an upstream-compatible version is selected.

## Content contract

The public repository owns site structure content:

- `content/search.md`
- `content/posts/_index.md`

The private content repository may only add articles in Page Bundle form:

```text
content/posts/<slug>/
├── index.md
└── cover.jpg
```

When an article has a cover, its front matter must use a bundle-relative path:

```yaml
cover:
  image: "cover.jpg"
  relative: true
  alt: "Image description"
```

`relative: true` keeps the article image, Open Graph image, X Card image, and
JSON-LD image on the same bundle URL. The default Archetype intentionally does
not add an empty cover block.

For local preview with a separate content checkout, create a temporary merged
content directory using the same ownership rule as CI: copy this repository's
structure content while excluding `content/posts/dev-*`, then merge only the
private repository's `content/posts/` directory. Do not copy private search or
section files into the build.

## GitHub Pages deployment

The production site is `https://jamez-bondos.github.io/`. GitHub Pages must use
**GitHub Actions** as its source; no `gh-pages` branch is used.

`.github/workflows/deploy-hugo.yml` builds with Hugo `0.164.0`, checks out the
private content repository, merges only its post bundles, and deploys the
generated Pages artifact. A content push sends a `repository_dispatch` event
containing the exact content commit SHA.

The public site repository requires this Actions secret:

- `CONTENT_REPO_TOKEN`: fine-grained PAT limited to
  `jamez-bondos/blog-content`, with `Contents: Read-only`.

The private content repository requires:

- `SITE_DISPATCH_TOKEN`: fine-grained PAT limited to
  `jamez-bondos/jamez-bondos.github.io`, with `Contents: Read and write`.

Secrets must be stored through GitHub repository settings or `gh secret set`.
Never put token values in YAML, logs, Markdown, or Git history.

## Known launch item

Brand artwork is not ready, so the following PaperMod assets are intentionally
absent for the first deployment and may return 404:

- `static/favicon.ico`
- `static/favicon-16x16.png`
- `static/favicon-32x32.png`
- `static/apple-touch-icon.png`
- `static/safari-pinned-tab.svg`

Add all five together when the final brand assets are available.
