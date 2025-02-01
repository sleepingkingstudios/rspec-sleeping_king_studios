{% capture formatted %}
{% for type in include.types %}{% include reference/type.md type=type -%}{%- unless forloop.last %}, {% endunless -%}{% endfor %}
{% endcapture %}
{{- formatted | strip -}}
