{% if include.label %}
  {% include reference/reference_link.md label=include.namespace.name path=include.namespace.data_path -%}
  {% if include.namespace.type == "class" %}
  {% assign parent_class = include.namespace.inherited_classes.first %}
  &lt; {% if parent_class %}{% include reference/reference_link.md label=parent_class.name path=parent_class.path %}{% else %}Object{% endif %}
  {% endif %}
{% endif %}

{% assign empty_array = "" | split: "," %}
{% assign defined_classes = include.namespace.defined_classes | default: empty_array %}
{% assign defined_modules = include.namespace.defined_modules | default: empty_array %}
{% assign definitions = defined_classes | concat: defined_modules | sort: "name" %}
{% if definitions.size > 0 %}
<ul style="margin-bottom: 0px;">
{% for definition in definitions %}
  <li>
    {% capture data_path %}
      {{- include.namespace.data_path -}}
      {% if include.namespace.data_path.size > 0 %}/{% endif %}
      {{- definition.slug -}}
    {% endcapture %}
    {% assign matched = site.modules | where: "data_path", data_path | where: "version", include.namespace.version | first %}
    {% unless matched %}
      {% assign matched = site.classes | where: "data_path", data_path | where: "version", include.namespace.version | first %}
    {% endunless %}
    {% include reference/namespace.md label=true namespace=matched -%}
  </li>
{% endfor %}
</ul>
{% else %}
{% unless include.label %}This namespace does not define any classes or modules.{% endunless %}
{% endif %}
