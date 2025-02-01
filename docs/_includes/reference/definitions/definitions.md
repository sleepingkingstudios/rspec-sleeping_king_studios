{% if include.definition.defined_classes.size > 0 or include.definition.defined_modules.size > 0 %}
## Defined Under Namespace

{% if include.definition.defined_classes.size > 0 %}
Classes
: {% for defined_class in include.definition.defined_classes -%}
  {% capture path %}{{ include.definition.data_path }}/{{ defined_class.slug }}{% endcapture %}
  {% include reference/reference_link.md label=defined_class.name path=path -%}
  {% unless forloop.last %}, {% endunless %}
  {%- endfor %}
{% endif %}

{% if include.definition.defined_modules.size > 0 %}
Modules
: {% for defined_module in include.definition.defined_modules -%}
  {% capture path %}{{ include.definition.data_path }}/{{ defined_module.slug }}{% endcapture %}
  {% include reference/reference_link.md label=defined_module.name path=path -%}
  {% unless forloop.last %}, {% endunless %}
  {%- endfor %}
{% endif %}

[Back To Top](#)
{% endif %}
