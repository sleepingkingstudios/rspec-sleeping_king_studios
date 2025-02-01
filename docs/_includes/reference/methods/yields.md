{% if include.method.yields.size > 0 %}
{% if include.overload %}
###### Yields
{: #{{ include.heading_id }}--yields }
{% else %}
#### Yields
{: #{{ include.heading_id }}--yields }
{% endif %}
{% for yielded in include.method.yields %}
- {% if yielded.parameters.size > 0 %}({% for parameter in yielded.parameters %}{{ parameter }}{% unless forloop.last %}, {% endunless %}{% endfor %}){% if yielded.description.size > 0 %} — {% endif %}{% endif %}{% if yielded.description.size > 0 %}{{ yielded.description }}{% endif -%}
{% endfor %}
{% endif %}

{% if include.method.yield_params.size > 0 %}
{% if include.overload %}
###### Yield Parameters
{: #{{ include.heading_id }}--yield-parameters }
{% else %}
#### Yield Parameters
{: #{{ include.heading_id }}--yield-parameters }
{% endif %}
<ul>
{% for param in include.method.yield_params -%}
<li><strong>{{ param.name -}}</strong> {% if param.type.size > 0 %}({%- include reference/type_list.md types=param.type -%}){% endif %}{% if param.description.size > 0 %} — {{ param.description }}{% endif %}</li>
{%- endfor %}
</ul>
{% endif %}

{% if include.method.yield_returns.size > 0 %}
{% if include.overload %}
###### Yield Returns
{: #{{ include.heading_id }}--yield-returns }
{% else %}
#### Yield Returns
{: #{{ include.heading_id }}--yield-returns }
{% endif %}
<ul>
{% for return in include.method.yield_returns -%}
<li>{% if return.type.size > 0 %}({%- include reference/type_list.md types=return.type -%}){% endif %}{% if return.type.size > 0 and return.description.size > 0 %} — {% endif %}{% if return.description.size > 0 %}{{ return.description }}{% endif %}</li>
{%- endfor %}
</ul>
{% endif %}
