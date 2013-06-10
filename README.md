# Rumba::Crawler
[![Dependency Status](https://gemnasium.com/vladnik/rumba-crawler.png)](https://gemnasium.com/vladnik/rumba-crawler)
[![Build Status](https://travis-ci.org/vladnik/rumba-crawler.png?branch=master)](https://travis-ci.org/vladnik/rumba-crawler)
[![Code Climate](https://codeclimate.com/github/vladnik/rumba-crawler.png)](https://codeclimate.com/github/vladnik/rumba-crawler)
[![Gem Version](https://badge.fury.io/rb/rumba-crawler.png)](http://badge.fury.io/rb/rumba-crawler)

Web crawler with JSON-based DSL and EventMachine-powered page fetching

## Installation

Add this line to your application's Gemfile:

    gem 'rumba-crawler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rumba-crawler

## Usage
Gem supports ```"css", "root" and "regexp"``` service keys:
* css: CSS locator for node
* root: custom root for current node (parent node is used by default )
* regexp: regular expression to extract data

If you have multiple objects of the same type, put object description into ```[ ]```.

Besides it supports shortcut for ```"css"``` attribute, so if you don't have any nested nodes(leaf node) 
and you don't need ```"root" and "regexp"``` keys, you can omit "css" key and provide locator as string value 
(```"name": "span.name"``` in example).

Map your models to page structure like this:
```json
[
  {
    "game": {
      "css":".games",
      "teams":[
        { 
          "css": ".teams",
          "name": "span.name",
          "scores": { 
            "css":".score",
            "regexp":"[0-9]+"
          },
          "sport": {
            "css":"#sport",
            "root":"body"
          }
        }
	  ]	
	}
  }
]
```
This will allow you to extract data from page for current model structure:
```ruby
class Game
  # has_many :teams
  def teams=(array_value)
    array_value.each do |value|
      Team.find_or_create(value)
    end
  end
end
class Team
  # belongs_to :game
  # belongs_to :sport
  attr_writer :name, :scores
  def sport=(value)
    Sport.find_or_create(value)
  end
end
class Sport
  # has_many :teams
end
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
