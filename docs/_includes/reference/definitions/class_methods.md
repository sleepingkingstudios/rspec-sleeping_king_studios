{% if include.definition.class_methods.size > 0 %}
## Class Methods

{% for class_method in include.definition.class_methods %}
{% include reference/method.md name=class_method.name path=class_method.path type="class" inherited=class_method.inherited %}
{% endfor %}

[Back To Top](#)
{% endif %}
