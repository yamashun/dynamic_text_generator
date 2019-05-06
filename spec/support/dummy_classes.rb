class DummyTemplateModel
  attr_accessor :id, :attr1, :attr2

  def initialize(**args)
    args.each do |key, value|
      eval("@#{key.to_s} = '#{value}'")
    end
  end

  def self.find(id)
    self.new(id: id, attr1: '%{obj.title} Digest', attr2: 'Topic:%{obj.name}. URL:%{obj.url}')
  end
end

class DummySendClass
  include DynamicTextGenerator::Generatable

  template_model :dummy_template_model
  template_columns :attr1, :attr2

  def initialize(template_id, template_obj)
    @template_id = template_id
    @instance_for_template = template_obj
  end

  def send_something
    {
      title: text_attr1,
      body:  text_attr2,
    }
  end
end
