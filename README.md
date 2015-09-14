# ActsAsTranslated

[![Build Status](https://travis-ci.org/stijnster/acts_as_translated.svg?branch=master)](https://travis-ci.org/stijnster/acts_as_translated)
[![Gem Version](https://badge.fury.io/rb/acts_as_translated.svg)](http://badge.fury.io/rb/acts_as_translated)

ActsAsTranslated is a gem for easy attribute translation. It works with localized versions of an attribute and switches between the localized version, using the I18n.locale setting.

## Setup

In your bundler Gemfile

```
gem 'acts_as_translated', '~> 1.0'
```

## Usage

Create localized attributes on your model by extending the attribute with the locale.

### Data model

Your migration file should look like this;

```
create_table :countries do |t|
  t.string :name_nl
  t.string :name_fr
  t.string :name_en

  t.timestamps
end
```

### Class

Create a class;

```
class Country < ActiveRecord::Base

  acts_as_translated :name

end
```

### Use the localised version

Use it in your views, controllers, ... Use the non-localized version of the attribute (in this case "name").

```
<%= @country.name %>
```

### Multiple attributes

Combine multiple attributes at once when specifying localized attributes;

```
  acts_as_translated :name, :description
```

### Using defaults

By default, the gem defaults back to english, but you can specify another default

```
  acts_as_translated :slug
  acts_as_translated :name, :description, default: :fr
```

## Deprication warnings

To transition smoothly from the previous versions of acts_as_translated, the gem will currently support array styled definitions, as such;

```
class Country < ActiveRecord::Base

  acts_as_translated [:name, :description]

end
```

But this will be removed in future versions as the preferred way is to write;

```
class Country < ActiveRecord::Base

  acts_as_translated :name, :description

end
```

## History

I've started development on this gem in 2008, way before I18n was considered the de-facto standard gem for internationalising a Ruby or Ruby-on-Rails app. The gem originated as a lib file and eventually made its way into a gem as the code was being used in multiple projects.

The gem has been available for a few years now and serves in various production code.