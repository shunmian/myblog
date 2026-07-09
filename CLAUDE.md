# MyBlog

A Jekyll-powered blog with realtime hot-reload and custom styling. Deployed to GitHub Pages (gh-pages branch).

## Commands

- `myblog` — start dev server at http://localhost:4000 with `--watch` (auto-reloads on file changes)
- `bundle install` — install gem dependencies
- `bundle exec jekyll build` — build static site to `public/` directory
- `bundle exec jekyll build --incremental` — faster incremental builds during development
- `git push origin gh-pages` — deploy to GitHub Pages

Always run `bundle install` if Gemfile changes.

## Structure

- `_posts/` — blog posts (one per file, organized by category in subdirectories)
- `_layouts/` — page layouts (post, page, default)
- `_includes/` — reusable template components
- `assets/` — CSS, JavaScript, images (organized by type and post category)
- `public/` — **generated build output** (do NOT edit, `.gitignore`d from source)
- `_config.yml` — Jekyll configuration (site title, author, pagination, plugins)
- `_plugins/` — custom Jekyll plugins

## Rules

- **Post naming**: `YYYY-MM-DD-title-slug.md` in appropriate category subdirectory
- **Front matter**: every post must have `layout: post`, `title`, `categories`, `tags`
- **Categories**: organize posts under `_posts/{category}/` for better structure
- **Images**: store post images in `assets/images/posts/{category}/{post-date}/`
- **Config edits**: changes to `_config.yml` require server restart (Ctrl+C, re-run `myblog`)
- **Build output**: always commit to `gh-pages` branch, never to main
- **Incremental builds**: use `--incremental` flag for development (faster iteration)

## Development Workflow

1. Run `myblog` to start server with hot-reload
2. Edit markdown files in `_posts/` — changes appear instantly
3. Edit layouts/includes in `_layouts/` or `_includes/` — rebuild automatic
4. Add images to `assets/images/posts/{category}/{date}/`
5. Commit changes to main branch (`gh-pages` is deployment target)

## Front Matter Template

```yaml
---
layout: post
title: Your Post Title
categories: [Category Name]
tags: [tag1, tag2]
number: [-1.0]  # custom ordering
fullview: false  # show full post on index or excerpt
shortinfo: Brief description for preview
---
```

## File Structure Example

```
_posts/
├── -40_VibeCoding/
│   └── 2026-07-09-ClaudeCode实战.md
├── -30_Architecture/
│   └── 2026-03-29-SystemDesign.md
└── -20_Performance/

assets/images/posts/
├── -40_VibeCoding/
│   └── ClaudeCode实战/
│       ├── week-1-example.png
│       └── architecture.jpg
└── -30_Architecture/
```

## Important Notes

- **Hot-reload**: Jekyll watches `_posts/`, `_layouts/`, `_includes/`, `assets/` for changes
- **Destination**: builds to `public/` (configured in `_config.yml`)
- **Baseurl**: set to empty string (`""`) for local dev, absolute path for production
- **Plugins**: using `jekyll-paginate`, `jekyll-feed`, custom syntax highlighting with coderay
- **Ruby version**: locked to 3.1.3 (check `.ruby-version` file)

## Deployment

```bash
# Commit to main branch
git add .
git commit -m "Add/update post"
git push origin main

# Then build and push to gh-pages
bundle exec jekyll build
cd public
git add .
git commit -m "Rebuild site"
git push origin gh-pages
```

Or use GitHub Actions if configured for automatic deployment.
