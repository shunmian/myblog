---
layout: post
title: Mobile Codex Sync with ccgram
categories: [-40 VibeCoding]
tags: [VibeCoding, Codex, ccgram, tmux, Telegram, Mobile]
number: [-0.0]
fullview: false
shortinfo: 用 ccgram、tmux 和 Telegram 在手机与 Mac 之间双向控制同一个 Codex 会话

---
目录
{:.article_content_title}

* TOC
{:toc}

---
{:.hr-short-left}

## Goal

Use [ccgram](https://github.com/alexei-led/ccgram) to control the same Codex session from both iPhone Telegram and Mac terminal.

```text
iPhone Telegram topic
        <->
ccgram
        <->
tmux window
        <->
Codex CLI
        ^
        |
Mac terminal: tmux attach -t ccgram
```

The key rule:

```text
one Telegram topic = one tmux window = one Codex session
```

Do not run another direct Codex in iTerm2/VS Code in the same repo while ccgram is controlling that repo. On Mac, attach to the ccgram tmux session instead:

```bash
tmux attach -t ccgram
```

## Setup Steps

### 1. Prepare iOS Telegram

If Telegram is not available in the current App Store region, switch to a region that supports Telegram.

My setup notes:

- Use VPN/proxy global outbound mode when needed.
- I switched to a US Apple ID.
- Telegram asked for a 1.19 USD startup/payment step.
- I used a virtual credit card bought from Taobao and added it to the Apple ID payment method.

This is just my personal setup note. Apple ID region and payment rules may change.

### 2. Install Tools

```bash
brew install tmux
nvm install 22
nvm use 22
```

Install and check ccgram:

```bash
ccgram --version
tmux -V
```

### 3. Create Telegram Bot

In Telegram, open:

```text
@BotFather
```

Create a bot:

```text
/newbot
```

Save the bot token:

```text
TELEGRAM_BOT_TOKEN=your_bot_token_here
```

In BotFather settings, set:

- Allow Groups: On
- Group Privacy: Off
- Topics: On

### 4. Create Telegram Group

Create a Telegram group and enable Topics.

Add the bot to the group and promote it to admin with permissions to read messages, send messages, and manage/create topics.

### 5. Get User ID

Message:

```text
@userinfobot
```

Use the returned number:

```text
ALLOWED_USERS=your_telegram_user_id
```

Example:

```text
ALLOWED_USERS=7360784229
```

### 6. Get Group ID

If a Telegram topic/message link looks like this:

```text
https://t.me/c/4306285083/11
```

Then the ccgram group id is:

```text
CCGRAM_GROUP_ID=-1004306285083
```

Take the middle number and prefix it with `-100`.

### 7. Configure ccgram

Create:

```bash
mkdir -p ~/.ccgram
nano ~/.ccgram/.env
```

Example:

```text
TELEGRAM_BOT_TOKEN=your_bot_token_here
ALLOWED_USERS=7360784229
CCGRAM_GROUP_ID=-1004306285083
```

### 8. Install Codex Hook

```bash
ccgram hook --provider codex --install
```

If Codex asks to trust hooks, handle it locally in tmux:

```bash
tmux attach -t ccgram
```

Then select:

```text
2. Trust all and continue
```

### 9. Start ccgram

```bash
ccgram
```

Keep this terminal running.

### 10. Create Topic and Start Codex

In Telegram group:

1. Create a topic, for example `zdetect`.
2. Send `Hi`.
3. Select working directory:

   ```text
   /Users/lal/zwhs/zdetect
   ```

4. Select provider:

   ```text
   Codex
   ```

5. Select mode, for example:

   ```text
   YOLO
   ```

ccgram will create a tmux window and start Codex inside it.

## Final Test

In Telegram topic, send:

```text
what is current working directory?
```

Expected answer:

```text
/Users/lal/zwhs/zdetect
```

On Mac, attach to the same session:

```bash
tmux attach -t ccgram
```

Use:

```text
Ctrl-b w
```

Select the corresponding tmux window and type:

```text
say hello from tmux
```

If Telegram receives the response, mobile and Mac are controlling the same Codex session.

Detach without closing the session:

```text
Ctrl-b d
```

