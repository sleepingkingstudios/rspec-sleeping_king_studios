{% if include.definition.direct_subclasses.size > 0 %}
## Direct Subclasses

{% for subclass in include.definition.direct_subclasses -%}
{% include reference/reference_link.md label=subclass.name path=subclass.path -%}
{% unless forloop.last %}, {% endunless %}
{%- endfor %}

[Back To Top](#)
{% endif %}
