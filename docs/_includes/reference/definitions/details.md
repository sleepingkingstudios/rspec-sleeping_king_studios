{% if include.definition.parent_path.size > 0 %}
Parent Namespace
: {% include reference/parent_link.md parent_path=include.definition.parent_path -%}
{% endif %}

{% if include.definition.inherited_classes.size > 0 %}
Inherited Classes
: {% for inherited_class in include.definition.inherited_classes -%}
  {% include reference/reference_link.md label=inherited_class.name path=inherited_class.path %}
  &gt;
  {% endfor -%}
  Object
{% endif %}

{% if include.definition.extended_modules.size > 0 %}
Extended Modules
: {% for extended_module in include.definition.extended_modules -%}
  {% include reference/reference_link.md label=extended_module.name path=extended_module.path -%}
  {% unless forloop.last %}, {% endunless %}
  {%- endfor %}
{% endif %}

{% if include.definition.included_modules.size > 0 %}
Included Modules
: {% for included_module in include.definition.included_modules -%}
  {% include reference/reference_link.md label=included_module.name path=included_module.path -%}
  {% unless forloop.last %}, {% endunless %}
  {%- endfor %}
{% endif %}

{% if include.definition.files.size > 0 %}
Defined In
: {{ include.definition.files | first }}
{% endif %}
