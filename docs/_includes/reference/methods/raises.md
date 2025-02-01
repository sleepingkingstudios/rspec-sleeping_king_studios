{% if include.method.raises.size > 0 %}
{% if include.overload %}
###### Raises
{: #{{ include.heading_id }}--raises }
{% else %}
#### Raises
{: #{{ include.heading_id }}--raises }
{% endif %}
<ul>
{% for raised in include.method.raises -%}
<li>({%- include reference/type_list.md types=raised.type -%}){% if raised.description.size > 0 %} — {{ raised.description }}{% endif %}</li>
{%- endfor %}
</ul>
{% endif %}
