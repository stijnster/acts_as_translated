# ActsAsTranslated

This acts_as extension allows easy attribute translation.

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
  acts_as_translated :name #, :default => :nl
end
```

Use it in your views, controllers, ...

```
<% Country.all.each do |country| %>
  <%= country.name %>
<% end %>
```

# Form Example

Build a dynamic form that extends, based on the number of languages available;

```
<%= form_for @country do %>
  ...
  <% @country.translated_fields_to_attributes.each do |attribute| %>
    <p><%= f.label attribute %><br/>
      <%= f.text_field attribute %></p>
    <% end %>
  ...
<% end %>
```

# Install

In your bundler Gemfile

```
gem 'acts_as_translated'
```