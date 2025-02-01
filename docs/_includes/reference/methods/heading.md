{% capture char %}{% if include.type == "class" %}.{% else %}#{% endif %}{% endcapture %}
{% capture abstract %}{% if include.method.metadata.abstract %} <small>(abstract)</small>{% endif %}{% endcapture %}
{% capture deprecated %}{% if include.method.metadata.deprecated %} <small>(deprecated)</small>{% endif %}{% endcapture %}

<h3>
  {% if include.method.overloads.size > 0 %}
  {% for overload in method.overloads %}
  <code>{{ char }}{{ overload.signature }} => {% include reference/methods/return_types.md method=overload -%}{{ abstract }}{{ deprecated }}</code>{% unless forloop.last %}<br />{% endunless %}
  {%- endfor -%}
  {%- else -%}
  <code>{{ char }}{{ include.method.signature }} => {% include reference/methods/return_types.md method=include.method -%}{{ abstract }}{{ deprecated }}</code>
  {% endif -%}
</h3>
{: #{{ include.heading_id }} }
