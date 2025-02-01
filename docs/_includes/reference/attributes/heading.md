{% capture char %}{% if include.type == "class" %}.{% else %}#{% endif %}{% endcapture %}
{% capture access %}{% if include.attribute.read and include.attribute.write %}{% elsif include.attribute.read %} <small>(readonly)</small>{% else %} <small>(writeonly)</small>{% endif %}{% endcapture %}
{% capture abstract %}{% if include.method.metadata.abstract %} <small>(abstract)</small>{% endif %}{% endcapture %}
{% capture deprecated %}{% if include.method.metadata.deprecated %} <small>(deprecated)</small>{% endif %}{% endcapture %}

<h3>
  {% if include.method.overloads.size > 0 %}
  {% for overload in include.method.overloads %}
  <code>{{ char }}{{ overload.signature }} => {% include reference/methods/return_types.md method=overload %}{{ access }}</code>{% unless forloop.last %}<br />{% endunless %}
  {% endfor %}
  {%- else -%}
  <code>{{ char }}{{ include.method.signature }} => {% include reference/methods/return_types.md method=include.method %}{{ access }}{{ abstract }}{{ deprecated }}</code>
  {% endif %}
</h3>
{: #{{ include.heading_id }} }
