hubot-google-trend [![NPM](http://badge.fury.io/js/hubot-google-trend.svg)](https://www.npmjs.org/package/hubot-google-trend) [![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/tcnksm/hubot-google-trend/blob/master/LICENCE)
====

Hubot job to show recent trend words on Google. Don't miss new trend.

## Usage

To know recent trend words:

![us](https://github.com/tcnksm/hubot-google-trend/blob/master/screenshots/us.png)

Or if you want to search another domain by TLD, for example `jp` (Japan):

![jp](https://github.com/tcnksm/hubot-google-trend/blob/master/screenshots/jp.png)

You can set `hubot-google-trend` as [cron](http://crontab.org/) job:

```coffee
Cron = require('cron').CronJob

new Cron('0 0 12 * * 1-5 ', () ->
    robot.emit 'google-trend', "jp"
).start()
```

Just emit `google-trend` event with `tld`.

## Configuration

By default `hubot-google-trend` try to show trend on [google.com](https://google.com). You can define default domain. For example, if you want to set it [google.fr](https://www.google.fr/) (France) :

```bash
export HUBOT_GOOGLE_TREND_TLD=fr
```

See more about TLD, [http://en.wikipedia.org/wiki/List_of_Google_domains](http://en.wikipedia.org/wiki/List_of_Google_domains).  

## Install

To install, use `npm`:

```bash
$ npm install --save hubot-google-trend
```

And add `hubot-google-trend` to your `external-scripts.json`.

## Contribution

1. Fork ([https://github.com/tcnksm/hubot-google-trend/fork](https://github.com/tcnksm/hubot-google-trend/fork))
1. Create a feature branch
1. Commit your changes
1. Rebase your local changes against the master branch
1. Create new Pull Request

## Tips

To get google domain with TLD. We parsed [http://en.wikipedia.org/wiki/List_of_Google_domains](http://en.wikipedia.org/wiki/List_of_Google_domains) with [EricChiang/pub](https://github.com/EricChiang/pup). 

```bash
$ wget http://en.wikipedia.org/wiki/List_of_Google_domains -O wiki.html
$ cat wiki.html | pup table slice{0} tr td text{} | grep '\.' | egrep -v 'google|g.cn' | sed -e 's/\.//g' | sed 's/^/\"/g' | sed 's/$/\"/g' > tld.txt
$ cat wiki.html | pup table slice{0} tr td text{} | grep '\.' | egrep 'google|g.cn' | sed 's/^/\"/g' | sed 's/$/\"/g' > domain.txt
$ paste -d":" tld.txt domain.txt
```

## Authors

- [tcnksm](https://github.com/tcnksm)
- [dchtnk](https://github.com/dchtnk) 
