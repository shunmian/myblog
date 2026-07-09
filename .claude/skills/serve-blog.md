---
name: serve-blog
description: Start Jekyll dev server with realtime watchdog hot-reload
---

# Serve Blog

Starts the Jekyll development server with `--watch` flag for automatic reloading on file changes.

## What It Does

- Runs `bundle exec jekyll server --watch --baseurl ""`
- Watches for changes in posts, layouts, includes, and assets
- Automatically rebuilds and serves at http://localhost:4000
- Shows real-time compilation output

## Usage

Type `/serve-blog` to start the development server.

```bash
myblog  # alias for: bundle exec jekyll server --watch --baseurl ""
```

The server will:
- Listen on `http://localhost:4000`
- Rebuild posts/layouts on file changes (automatic hot-reload)
- Show compilation status in terminal
- Continue running until stopped (Ctrl+C)

## File Watch Behavior

Jekyll watches these directories:
- `_posts/` — blog posts (rebuilds instantly)
- `_layouts/` — page templates (rebuilds site)
- `_includes/` — reusable components (rebuilds site)
- `assets/` — CSS, JS, images (rebuilds if referenced)
- `_config.yml` — requires server restart

## Tips

- **Fast iteration**: edit markdown in `_posts/` for instant preview
- **Config changes**: changes to `_config.yml` require restarting server
- **Incremental builds**: enabled by default for faster rebuilds
- **Port conflict**: if 4000 is busy, use `jekyll server --port 4001`

## Troubleshooting

**Server won't start:**
```bash
bundle install  # reinstall gems
```

**Changes not appearing:**
```bash
# Restart server (Ctrl+C, then /serve-blog)
```

**Slow builds:**
```bash
# Use incremental flag (default enabled)
bundle exec jekyll build --incremental
```
