---
layout: post
title: 10xProgrammer
categories: [-20 Text Editor]
tags: [VSCode]
number: [-20.1]
fullview: false
shortinfo: 本文是对[10xProgrammer](https://edu.51cto.com/course/19329.html)的总结。
---
目录
{:.article_content_title}


* TOC
{:toc}

---
{:.hr-short-left}

## 1. VSCode 总结 ##

### 1.0 `shift`+`win`+`⌘` 

- VSCode的精华在于一个快捷键`shift`+`win`+`⌘`;
  - search command: `open files`
  - search shortcuts: `shortcuts` -> open the shortcuts pdf.

### 1.1 File

`shift`+`win`+`⌘`:
- `new untitled file`;
- `new window`;
- `save as workspace`;
- `open workspace`;
- `open recent`;
- `add folder to workspace`; 一个workspace可以有多属于不同根目录的folder。
- don't use `save`, `save as`; use auto save.

- `preference`
  - `keymap`;
  - `use snippets`;
  - `color theme`; 推荐一款`Dracula`
  - `file icon`;

### 1.2 Edit

- `undo`;
- `redo`;
- `find`, `replace` with/without selected area.
- `find`, `replace` for all files
- switch search from left panel to bottom section (the one with terminal)`"search.location": "panel"` in settings JSON
- `comment line`;
- `comment block`;
- `Emmet`, use for html auto spelling, which is outdated.

### 1.3 Selection

- `select all`;
- `expand selection` & `shrink selection`;
- `multi-cursor`
  - `add next occurrence`, `add previous occurrence`
  - `select all occurrence`.

### 1.4 View

- `command palette`;
- `open view`;
- `appearance`;
  - `full screen`;
  - `zen mode` (***);
  - `status bar`(***);
  - `side bar`;
  - `activity bar`;
  - `panel`
  - `zoom in`(***);
  - `zoom out`(***);
- `edit layout`
  - `split down`;
  - `split right`;
  - `single`;
  - switch between spitted window `cmd+}`/`cmd+{`
- `show minimap`
- `show breadcrumbs`
- `render whitespace`

### 1.5 Go
- `go to file`(***);
- `go to symbol in file`(***);
- `go to symbol in workspace`;
- `go to definition`;
- `go to type definition`(***);
- `go to implementation`;
- `back`;
- `forward`;
- `go to last edited`;
- `switch editor`;
  - `previous editor(window)`(***);
  - `next editor(window)`(***);
- `switch group`
  - `Group 1`;
  - `Group 2`;
- `go to line`;
- `go to bracket`(***); 
- `go to next(previous) problem`;
- `go to next(previous) change`;

### 1.6 Debug

Skip since it is bounded to specific language.

### 1.7 Terminal

Skip since the majority usage is use terminal as it is.

### 1.8 Help

- `Keyboard shortcuts reference`

## 2. Vim

- `%`, jump between parenthesis;
- `:10, 100s/thee/the/g`, replace thee to the between line 10 to 100.
- `:!ls`, execute cmd in vim
- `R`, replace multiple
- `/ignore\c`, search `ignore` by case insensitive
- `:help`, open help; `ctrl+w`, toggle between multiple windows.
- `V`, visual mode by selecting from the begin of line; `v` visual mode by selecting from current cursor.
- `vit` or `vat`, `vi}`or `va}`, select inner/append tag/}
- `ctrl+n`/`ctrl+p`, select next or previous in the opening list.
- `*`/`#`: 搜索文件中当前cursor下单词，从上(下))往下(上)。
  - 可以`v`选中单词(可以省略)，然后`*`, 跳至下一个occurrence, 然后`n`/`N`选下(上)一个。

- 结合vscode和neovim

## 3. VSCode + Vim optimization

- 设置全局快捷键: 全局指的是VSCode 有无`Vim`插件都有效的快捷键。
  - `Open Default Keyboard Shortcuts (JSON)`
  - `Open Keyboard Shortcuts (JSON)` (inherits from above).
- 导航快捷键优化, in `Open Keyboard Shortcuts (JSON)`, the following too global customization of shortcuts is highly recommended since this is how it works in vim
    - `{ "key": "Ctrl+]", "command": "editor.action.goToTypeDefinition"}`
    - `{ "key": "Ctrl+T", "command": "workbench.action.navigateBack"}`
- vscode的全部设置

{% highlight JSON linenos %}
{
  "vim.easymotion": true,
  "vim.sneak": true,
  "vim.visualstar": true,
  "vim.ignorecase": false,
  "vim.useSystemClipboard": true,
  "vim.useCtrlKeys": true,
  "vim.hlsearch": true,
  "vim.insertModeKeyBindings": [
    {
      "before": [
        "k",
        "j"
      ],
      "after": [
        "<Esc>"
      ]
    }
  ],
  "vim.leader": ",",
  "vim.visualModeKeyBindingsNonRecursive": [
    {
      "before": ["j"],
      "after": ["j", "z", "z"]
    },
    {
      "before": ["k"],
      "after": ["k", "z", "z"]
    },
    {
      "before": [
        ">"
      ],
      "commands": [
        "extension.matchitJumpItems"
      ]
    },
    {
      "before": [
        "?"
      ],
      "commands": [
        "extension.matchitSelectItems"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "x"
      ],
      "commands": [
        "editor.action.smartSelect.expand"
      ]
    },
    {
      "before": [
        "<leader>",
        "z",
        "z"
      ],
      "commands": [
        "editor.action.smartSelect.shrink"
      ]
    },
    {
      "before": [
        "<leader>",
        "q",
        "q"
      ],
      "commands": [
        "workbench.action.findInFiles"
      ]
    },
    {
      "before": [
        "<leader>",
        "s",
        "s"
      ],
      "commands": [
        "actions.find"
      ]
    }
  ],
  "vim.normalModeKeyBindingsNonRecursive": [
    {
      "before": [
        ">"
      ],
      "commands": [
        "extension.matchitJumpItems"
      ]
    },
    {
      "before": [
        "?"
      ],
      "commands": [
        "extension.matchitSelectItems"
      ]
    },
    {
      "before": [
        "<leader>",
        "q",
        "q"
      ],
      "commands": [
        "workbench.action.findInFiles"
      ]
    },
    {
      "before": [
        "<leader>",
        "f",
        "p"
      ],
      "commands": [
        "workbench.action.files.copyPathOfActiveFile"
      ]
    },
    {
      "before": [
        "<leader>",
        "f",
        "n"
      ],
      "commands": [
        "copyRelativeFilePath"
      ]
    },
    {
      "before": [
        "<leader>",
        "t",
        "p"
      ],
      "commands": [
        "workbench.action.togglePanel"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "m"
      ],
      "commands": [
        "workbench.action.showCommands"
      ]
    },
    {
      "before": [
        "<leader>",
        "c",
        "i"
      ],
      "commands": [
        "editor.action.commentLine"
      ]
    },
    {
      "before": [
        "<leader>",
        "t",
        "a"
      ],
      "commands": [
        "workbench.action.toggleActivityBarVisibility"
      ]
    },
    {
      "before": [
        "<leader>",
        "t",
        "b"
      ],
      "commands": [
        "workbench.action.toggleSidebarVisibility"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "s"
      ],
      "commands": [
        "workbench.action.files.save"
      ]
    },
    {
      "before": [
        "<leader>",
        "s",
        "s"
      ],
      "commands": [
        "actions.find"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "k"
      ],
      "commands": [
        "workbench.action.closeActiveEditor"
      ]
    },
    {
      "before": [
        "<leader>",
        "r",
        "r"
      ],
      "commands": [
        "workbench.action.openRecent"
      ]
    },
    {
      "before": [
        "<leader>",
        "k",
        "k"
      ],
      "commands": [
        "workbench.action.quickOpen"
      ]
    },
    {
      "before": [
        "<leader>",
        "i",
        "i"
      ],
      "commands": [
        "workbench.action.gotoSymbol"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "1"
      ],
      "commands": [
        "workbench.action.editorLayoutSingle"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "3"
      ],
      "commands": [
        "workbench.action.splitEditorRight"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "2"
      ],
      "commands": [
        "workbench.action.splitEditorDown"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "4"
      ],
      "commands": [
        "workbench.action.editorLayoutTwoByTwoGrid"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "0"
      ],
      "commands": [
        "workbench.action.closeGroup"
      ]
    },
    {
      "before": [
        "<leader>",
        "x",
        "z"
      ],
      "commands": [
        "workbench.action.terminal.focus"
      ]
    },
    {
      "before": [
        "<leader>",
        "f",
        "f"
      ],
      "commands": [
        "workbench.action.toggleZenMode"
      ]
    },
    {
      "before": [
        "<leader>",
        "w",
        "q"
      ],
      "after": [
        ":wq"
      ],
    }
  ],
  "vim.handleKeys": {
    "<C-a>": false,
  },
  "zenMode.centerLayout": false,
  "search.exclude": {
    "**/.git": true,
    "**/*.bundle.js": true,
    "**/bin-packages": true,
    "**/frontend-dist": true,
    "**/npm-packages-offline-cache": true
  },
  "search.useGlobalIgnoreFiles": true,
  "search.location": "panel",
  "window.zoomLevel": 2,
  "terminal.integrated.fontFamily": "Source Code Pro",
  "terminal.integrated.fontSize": 11,
  "eslint.autoFixOnSave": true,
  "files.autoSave": "afterDelay",
  "workbench.colorTheme": "Dracula",
  "workbench.statusBar.visible": true,
  "workbench.iconTheme": "material-icon-theme",
  "workbench.activityBar.visible": false,
  "breadcrumbs.enabled": true,
  "editor.rulers": [
    100,
    120
  ],
  "editor.renderWhitespace": "none",
  "editor.renderControlCharacters": false,
  "editor.detectIndentation": false,
  "editor.fontSize": 11,
  "editor.tabSize": 2,
  "editor.fontFamily": "Source Code Pro",
  "editor.formatOnSave": true,
  "editor.minimap.enabled": true,
  "editor.lineNumbers": "relative",
}
{% endhighlight %}


- File优化
  - `,rr`: open recent;
  - `,xf`: quick search and open file;
  - `,xs`: save file;
- undo/redo & copy/paste
  - `u`: undo; `crl+r`: redo;
  - `y`: copy; `p`: paste;
- find/replace
  - single file:
    - `,ss`: search; no replace optimization
  - multiple files:
    - `,qq`: search; no replace optimization
- comment
  - line, `,ci`;
- selection:
  - `,xx`, expand selection; `,zz`. shrink select
- view: aaa
  - `,xm`: open command palette;
  - `.ff`： zen mode;
  - `,x1`: single tab; `,x3`, right tab; `,x2`, bottom tab.
  - `ctrl+w`, switch between split windows.
- go:
  - `ctrl+]` go to type definition; `ctrl+t` go back. (Both are defined at (`Open Keyboard Shortcuts (JSON)`).
  - `,kk`, quick open file.
  - `a`, go to bracket.
  - Go to bracket:
    - install matchit extension for vscode, `extension.matchItJumpItems`(`>`), `extension.matchItSelectItems`(`?`).
  - `,ii`, go to symbol.
  - `gd`, go to definition;
  - `gf`, go to file under cursor.
  

## 4. Emacs + Vim



{% highlight C linenos %}

{% endhighlight %}

## A 参考资料 ##
- [《Vim Masterclass》](https://www.udemy.com/vim-commands-cheat-sheet/);



