{% if include.definition.constructor and include.definition.instance_methods.size > 1 %}
## Instance Methods
{% elsif include.definition.instance_methods.size > 0 %}
## Instance Methods
{% endif %}

{% for instance_method in include.definition.instance_methods %}
{% unless instance_method.constructor %}
{% include reference/method.md name=instance_method.name path=instance_method.path type="instance" inherited=instance_method.inherited %}
{% endunless %}
{% endfor %}

{% if include.definition.constructor and include.definition.instance_methods.size > 1 %}
[Back To Top](#)
{% elsif include.definition.instance_methods.size > 0 %}
[Back To Top](#)
{% endif %}
