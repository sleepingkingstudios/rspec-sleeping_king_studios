{% if include.definition.instance_attributes.size > 0 %}
## Instance Attributes

{% for instance_attribute in include.definition.instance_attributes %}
{% include reference/attribute.md attribute=instance_attribute write=instance_attribute.write type="instance" inherited=instance_attribute.inherited %}
{% endfor %}

[Back To Top](#)
{% endif %}
