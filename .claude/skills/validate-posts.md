---
name: validate-posts
description: Check all blog posts for proper front matter, formatting, and broken links
---

# Validate Posts

Validates all blog posts in `_posts/` directory for:
- Proper Jekyll front matter (layout, title, categories, tags)
- Broken image references
- Missing metadata
- File naming conventions

## Usage

```bash
/validate-posts
```

## Checks Performed

**Front Matter Validation**
- ✓ `layout: post` present
- ✓ `title` is non-empty
- ✓ `categories` array exists and is non-empty
- ✓ `tags` array exists
- ✓ `shortinfo` is present (for post preview)

**File Naming**
- ✓ Format: `YYYY-MM-DD-slug.md`
- ✓ Date is valid
- ✓ Slug uses lowercase and hyphens only

**Content**
- ✓ Image paths use correct URL format
- ✓ Markdown syntax is valid
- ✓ Internal links are resolvable
- ✓ No orphaned image files

**Organization**
- ✓ File is in correct category subfolder
- ✓ Images are in corresponding `assets/images/posts/` subfolder
- ✓ Consistent slug naming across related files

## Output

Reports:
```
✓ 47 posts validated
⚠ 2 warnings:
  - 2026-07-09-post.md: missing shortinfo
✗ 1 error:
  - 2026-07-08-old-post.md: broken image reference
```

## Common Issues

**Missing front matter field:**
```markdown
---
layout: post
title: Post Title
# Add missing fields:
categories: [VibeCoding]
tags: [tag1, tag2]
shortinfo: Brief description
---
```

**Broken image path:**
```markdown
# Wrong:
![](../../assets/images/posts/image.png)

# Correct:
![]({{site.url}}/assets/images/posts/-40_VibeCoding/2026-07-09-slug/image.png)
```

**File naming issue:**
```bash
# Wrong: missing date or uses spaces
2026-07-09 My Post Title.md

# Correct:
2026-07-09-my-post-title.md
```

## Tips

- Run this before committing new posts
- Fix all errors before deployment
- Warnings don't block deployment but should be reviewed
- Use this to maintain consistency across the blog
