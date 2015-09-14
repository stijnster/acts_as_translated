# ActsAsTranslated

[![Build Status](https://travis-ci.org/stijnster/acts_as_translated.svg?branch=master)](https://travis-ci.org/stijnster/acts_as_translated)
[![Gem Version](https://badge.fury.io/rb/acts_as_translated.svg)](http://badge.fury.io/rb/acts_as_translated)

This acts_as extension allows easy attribute translation. The gem uses the current I18n.locale to return the translated attribute.

## Examples

Your migration file should look like this;

```
create_table :countries do |t|
  t.string :name_nl
  t.string :name_fr
  t.string :name_en

  t.timestamps
end
```

Create a class;

```
class Country < ActiveRecord::Base

  acts_as_translated :name # optional, pass in default fallback locale; default: :nl

end
```

Use it in your views, controllers, ...

```
<% Country.all.each do |country| %>
  <%= country.name %>
<% end %>
```

In your bundler Gemfile

```
gem 'acts_as_translated', '~> 1.0'
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

I've started development on this gem in 2008, way before I18n was considered the de-facto standard gem for internationalising a Ruby or Ruby-on-Rails app.

The gem has been available for a few years now and serves in various production code.