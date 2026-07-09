---
name: deploy-blog
description: Build and deploy blog to GitHub Pages (gh-pages branch)
---

# Deploy Blog

Builds the Jekyll site and deploys to GitHub Pages on the `gh-pages` branch.

## Deployment Process

1. Build site to `public/` directory
2. Verify build succeeded
3. Commit changes to `gh-pages` branch
4. Push to `origin/gh-pages`

## Usage

```bash
/deploy-blog
```

## What Happens

```bash
# 1. Build production site
bundle exec jekyll build

# 2. Switch to gh-pages branch
git checkout gh-pages

# 3. Copy built files
cp -r public/* .

# 4. Commit changes
git add .
git commit -m "Rebuild site: $(date)"

# 5. Push to GitHub
git push origin gh-pages

# 6. Return to main branch
git checkout main
```

## Requirements

- All changes committed to `main` branch first
- `gh-pages` branch exists and tracks `origin/gh-pages`
- No uncommitted changes in working directory

## Troubleshooting

**Build failed:**
- Run `bundle install` to ensure dependencies are ready
- Check `_config.yml` for syntax errors
- Run `bundle exec jekyll build` locally to debug

**Push failed:**
- Verify GitHub credentials are configured
- Check branch permissions
- Ensure you have push access to `origin`

## Manual Deployment

If the script fails, deploy manually:

```bash
bundle exec jekyll build
cd public
git add .
git commit -m "Rebuild site"
git push origin gh-pages
```
