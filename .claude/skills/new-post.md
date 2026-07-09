---
name: new-post
description: Create a new blog post with proper front matter and structure
---

# New Post

Scaffolds a new blog post with proper Jekyll front matter, directory structure, and naming conventions.

## Usage

Type `/new-post` and provide:
- Title
- Category (VibeCoding, Architecture, Performance, etc.)
- Initial tags
- Brief description

## Output

Creates:
1. Post file: `_posts/{CATEGORY}/YYYY-MM-DD-{slug}.md`
2. Image directory: `assets/images/posts/{CATEGORY}/{date}/`
3. Front matter with proper metadata

## Front Matter Template

```yaml
---
layout: post
title: Your Post Title
categories: [Category Name]
tags: [tag1, tag2, tag3]
number: [-1.0]
fullview: false
shortinfo: Brief one-line description for preview
---

# Your Post Title

Content starts here...
```

## Directory Structure

```
_posts/
├── -40_VibeCoding/
│   ├── 2026-07-09-post-title.md
│   └── ...
└── -30_Architecture/

assets/images/posts/
├── -40_VibeCoding/
│   └── 2026-07-09-post-title/
│       ├── image1.png
│       └── image2.jpg
```

## Category Examples

- `-40_VibeCoding` — Claude Code, AI development practices
- `-30_Architecture` — System design, architecture patterns
- `-20_Performance` — Optimization, benchmarking
- `-10_DevOps` — Deployment, infrastructure

## Tips

- Use kebab-case for post filename slugs
- Add images to the post's date-specific folder
- Use relative URLs in markdown: `![]({{site.url}}/assets/images/posts/...)`
- Keep post titles clear and SEO-friendly
