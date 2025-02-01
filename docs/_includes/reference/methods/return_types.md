{%- if include.method.constructor -%}
{{ include.method.returns.first.type.first.name | default: "Object" }}
{%- elsif include.method.returns.size > 0 -%}
{% for returns in include.method.returns %}
{%- include reference/type_list.md types=returns.type -%}{%- unless forloop.last -%}, {% endunless -%}
{% endfor %}
{%- else -%}
Object
{%- endif -%}
