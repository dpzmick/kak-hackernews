# Hacker News in kakoune
## Install
Copy (or symlink) `hacker_news.kak` into `~/.config/kak/autoload/`

See screenshot:

![demo](img/screen.gif)

## Commands
* `hacker_stories` - opens a new buffer (from a fifo) with the top 50 stories on HN
* `hacker_open` - opens a hacker news story with `xdg-open`
* `hacker_comments` - opens the discussion page for the story (again with `xdg-open`)

## Depends
* curl
* jq
