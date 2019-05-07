# DynamicTextGenerator
A library for dynamically generating text from template with variables embedded stored in the RDB.
It is intended to generate text for use in mail and push notifications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamic_text_generator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dynamic_text_generator

## Usage

### Table and model for stored template 
Create table and model for stored template 

```rb
class TemplateModel < ApplicationRecord
end
```

### Class definition to use template
Following 4 steps.

1. Include `DynamicTextGenerator::Generatable` module.
2. Define template model, corresponding to the table in which the template is stored.
3. Define template columns, columns of the model defined above in which the template is stored.
4. Add `initialize` method to set '@template_id' and  '@instance_for_template'

It is possible to call method `"text_#{template_column}"` for example `text_attr1`

```rb
class MyClass
  # 1
  include DynamicTextGenerator::Generatable
  
  # 2
  template_model :template_model
  # 3
  template_columns :attr1, :attr2
  
  # 4
  def initialize(template_id, template_obj)
    @template_id = template_id
    @instance_for_template = template_obj
  end
  
  def do_something
    {
      title: text_attr1,
      body:  text_attr2,
    }
  end
end
```

### Example

#### Template table and data

table name: notice_temlates

|id|tilte|content|
|---:|:---|:---|
|1|%{obj.title} Digest|Topic: %{obj.content_name}. URL:%{obj.url}|
|2|%{obj.title} Campaign|Campaign code: %{obj.campaign_code}. URL:%{obj.url}|

#### Obj for template
Obj for template must be respond to methods embedded in template.

```rb
obj1 = OpenStruct.new({ title: "Daily", contet_name: "Daily news", url: "https://foo.bar/news"  })
obj2 = OpenStruct.new({ title: "Limited time sale", campaign_code: "123456", url: "https://foo.bar/campaigns"  })
```

#### Class definition

```rb
class MyClass
  include DynamicTextGenerator::Generatable
  
  template_model :notice_template
  template_columns :title, :content
  
  def initialize(template_id, template_obj)
    @template_id = template_id
    @instance_for_template = template_obj
  end
  
  def do_something
    {
      title: text_title,
      body:  text_content,
    }
  end
end
```

#### run

```rb
instance1 = MyClass.new(1, obj1)
instance1.text_title # => Daily Digest
instance1.text_content # => Topic: Daily news. URL:https://foo.bar/news

instance2 = MyClass.new(2, obj2)
instance2.text_title # => Limited time sale Campaign
instance2.text_content # => Campaign code: 123456. URL:https://foo.bar/campaigns
instance2.do_something # => { titel: "Limited time sale Campaign", body: "Campaign code: 123456. URL:https://foo.bar/campaigns" }
```


## Development

TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dynamic_text_generator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
