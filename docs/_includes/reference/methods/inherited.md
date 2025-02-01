{% if include.inherited %}
{% if include.type == "class" %}Extended{% else %}Inherited{% endif %} From
: {% include reference/parent_link.md parent_path=include.method.parent_path %}
{% endif %}
