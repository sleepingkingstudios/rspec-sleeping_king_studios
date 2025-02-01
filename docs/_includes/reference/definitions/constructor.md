{% if include.definition.constructor %}
{% for instance_method in include.definition.instance_methods %}
{% if instance_method.constructor %}
{% assign path=instance_method.path %}
{% assign inherited=instance_method.inherited %}
{% endif %}
{% endfor %}
## Constructor
{% include reference/method.md name="initialize" inherited=inherited path=path type="instance" %}

[Back To Top](#)
{% endif %}
