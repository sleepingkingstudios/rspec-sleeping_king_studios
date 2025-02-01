{% if include.definition.class_attributes.size > 0 %}
## Class Attributes

{% for class_attribute in include.definition.class_attributes %}
{% include reference/attribute.md attribute=class_attribute type="class" inherited=class_attribute.inherited %}
{% endfor %}

[Back To Top](#)
{% endif %}
