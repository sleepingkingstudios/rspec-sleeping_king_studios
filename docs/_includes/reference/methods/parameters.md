{% if include.method.params %}
{% if include.overload %}
###### Parameters
{: #{{ include.heading_id }}--parameters }
{% else %}
#### Parameters
{: #{{ include.heading_id }}--parameters }
{% endif %}
<ul>
{% for param in include.method.params -%}
<li><strong>{{ param.name }}</strong> {% if param.type.size > 0 %}({%- include reference/type_list.md types=param.type -%}){% endif %}{% if param.description.size > 0 %} — {{ param.description }}{% endif %}</li>
{%- endfor %}
</ul>
{% endif %}

{% if include.method.options.size > 0 %}
{% for options in include.method.options %}
{% if include.overload %}
###### Options Hash ({{ options.name }})
{: #{{ include.heading_id }}--options-{{ options.name }} }
{% else %}
#### Options Hash ({{ options.name }})
{: #{{ include.heading_id }}--options-{{ options.name }} }
{% endif %}
<ul>
{% for option in options.opts -%}
<li><strong>{{ option.name -}}</strong> {% if option.type.size > 0 %}({%- include reference/type_list.md types=option.type -%}){% endif %}{% if option.description.size > 0 %} — {{ option.description }}{% endif %}</li>
{%- endfor %}
</ul>
{% endfor %}
{% endif %}
